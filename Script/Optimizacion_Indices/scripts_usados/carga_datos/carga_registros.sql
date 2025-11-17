USE Clinicks_BD_I;

SET NOCOUNT ON;

BEGIN TRY
    BEGIN TRANSACTION;

    -- Obtenemos el id del rol demedico
    DECLARE @idRolMedico INT;
    SELECT @idRolMedico = id_rol FROM Rol WHERE nombre_rol = 'Medico';

    -- Si dicho rol no existe, tiro error y aborto la carga
    IF @idRolMedico IS NULL
        THROW 51000, 'No existe el rol "Medico".', 1;

    -- Creo una tabla temporal para tener a todos los medicos registrados
    IF OBJECT_ID('tempdb..#Medicos') IS NOT NULL DROP TABLE #Medicos;
    SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS rn,
           ure.id_rol, ure.id_usuario, ure.id_especialidad
    INTO #Medicos
    FROM Usuario_rol_especialidad ure
    WHERE ure.id_rol = @idRolMedico;

    -- Contamos el nro de medicos puestos en la tabla temporal
    DECLARE @cntMedicos INT = (SELECT COUNT(*) FROM #Medicos);
    -- Si la cantidad es 0, osea que no hay medicos cargados, tiro error y aborto la carga
    IF @cntMedicos = 0
        THROW 51001, 'No hay médicos cargados.', 1;

    -- Creo una tabla temporal con todas las fichas medicas (una por paciente)
    IF OBJECT_ID('tempdb..#Fichas') IS NOT NULL DROP TABLE #Fichas;
    SELECT id_paciente, fecha_creacion
    INTO #Fichas
    FROM Ficha_medica;

    -- Obtengo el nro de fichas medicas
    DECLARE @cntFichas INT = (SELECT COUNT(*) FROM #Fichas);

    -- Creo una tabla temporal con todos los tipos de registro que hay, junto a su especialidad
    IF OBJECT_ID('tempdb..#RegEsp') IS NOT NULL DROP TABLE #RegEsp;
    SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS rn,
           id_tipo_registro, id_rol, id_especialidad
    INTO #RegEsp
    FROM Registro_especialidad;

    -- Creo una observacion fija que ira en todos los registros
    DECLARE @obs NVARCHAR(255) = N'El paciente esta sano, no presenta sintomas algunos';

    DECLARE @f INT = 1;
    -- Hago un bucle que recorrera todas las fichas medicas:
    WHILE @f <= @cntFichas
    BEGIN
        -- Obtengo los datos del paciente:
        DECLARE @id_paciente INT, @fecha_creacion DATE;
        SELECT @id_paciente = id_paciente, @fecha_creacion = fecha_creacion
        FROM #Fichas WHERE id_paciente = @f;

        -- Creo una variable q se usara como contador para crear todos los registros
        DECLARE @i INT = 1;
        -- Hago el bucle para crear estos 1000 registros por paciente
        WHILE @i <= 1000
        BEGIN
            -- Selecciono el id de un medico de forma aleatoria
            DECLARE @rndMedico INT = 1 + ABS(CHECKSUM(NEWID()) % @cntMedicos);

            -- Obtengo los datos necesarios a guardar a partir de ese id aleatorio
            DECLARE @id_rol_usuario INT, @id_usuario INT, @id_especialidad_usuario INT;
            SELECT @id_rol_usuario = id_rol,
                   @id_usuario = id_usuario,
                   @id_especialidad_usuario = id_especialidad
            FROM #Medicos WHERE rn = @rndMedico;

            -- Obtenemos todos los tipos de especialidad validos para la especialidad de ese medico
            DECLARE @cntTipos INT = (
                SELECT COUNT(*) FROM #RegEsp
                WHERE id_rol = @id_rol_usuario AND id_especialidad = @id_especialidad_usuario
            );

            -- Si existen tipos de registro validos,
            IF @cntTipos > 0
            BEGIN
                -- Selecciono uno de esos tipos de forma aleatoria
                DECLARE @rndTipo INT = 1 + ABS(CHECKSUM(NEWID()) % @cntTipos);
                DECLARE @id_tipo_registro INT, @id_rol_proc INT, @id_esp_proc INT;

                -- Y agarro los datos pertinentes a ese tipo de registro
                SELECT TOP 1
                    @id_tipo_registro = id_tipo_registro,
                    @id_rol_proc = id_rol,
                    @id_esp_proc = id_especialidad
                FROM #RegEsp
                WHERE id_rol = @id_rol_usuario AND id_especialidad = @id_especialidad_usuario
                ORDER BY NEWID();

                -- Generamos una fecha aleatoria entre la fecha de creacion de la ficha medica, y la fecha actual
                DECLARE @fecha DATE =
                    DATEADD(DAY,
                        ABS(CHECKSUM(NEWID()) % (1 + DATEDIFF(DAY, @fecha_creacion, GETDATE()))),
                        @fecha_creacion
                    );

                -- Inserto todos estos datos a la tabla registro (sin indice)
                INSERT INTO Registro (
                    fecha_registro, observaciones,
                    id_tipo_registro,
                    id_rol_procedimiento, id_especialidad_procedimiento,
                    id_rol_usuario, id_usuario, id_especialidad_usuario,
                    id_paciente
                )
                VALUES (
                    @fecha, @obs,
                    @id_tipo_registro,
                    @id_rol_proc, @id_esp_proc,
                    @id_rol_usuario, @id_usuario, @id_especialidad_usuario,
                    @id_paciente
                );

                -- Inserto los datos en la tabla Registro_Indexado_Clustered_Sin_Include (con indice, solo en fecha registro)
                INSERT INTO Registro_Indexado_Clustered_Sin_Include (
                    fecha_registro, observaciones,
                    id_tipo_registro,
                    id_rol_procedimiento, id_especialidad_procedimiento,
                    id_rol_usuario, id_usuario, id_especialidad_usuario,
                    id_paciente
                )
                VALUES (
                    @fecha, @obs,
                    @id_tipo_registro,
                    @id_rol_proc, @id_esp_proc,
                    @id_rol_usuario, @id_usuario, @id_especialidad_usuario,
                    @id_paciente
                );

                -- Inserto los datos en la tabla Registro_Indexado_Clustered (con indice, en fecha registro, id paciente, id usuario)
                INSERT INTO Registro_Indexado_Clustered (
                    fecha_registro, observaciones,
                    id_tipo_registro,
                    id_rol_procedimiento, id_especialidad_procedimiento,
                    id_rol_usuario, id_usuario, id_especialidad_usuario,
                    id_paciente
                )
                VALUES (
                    @fecha, @obs,
                    @id_tipo_registro,
                    @id_rol_proc, @id_esp_proc,
                    @id_rol_usuario, @id_usuario, @id_especialidad_usuario,
                    @id_paciente
                );
            END

            -- Sumo uno para crear al siguiente registro
            SET @i += 1;
        END

        -- Sumo uno para ir a la siguiente ficha meidca
        SET @f += 1;
    END

    COMMIT TRANSACTION;
    PRINT 'Inserción completa de 1.000.000 registros.';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error en la transacción: ' + ERROR_MESSAGE();
END CATCH;

-- Verificaciones
select count(*) from registro;
select count(*) from Registro_Indexado_Clustered;
select count(*) from Registro_Indexado_Clustered_Sin_Include;
