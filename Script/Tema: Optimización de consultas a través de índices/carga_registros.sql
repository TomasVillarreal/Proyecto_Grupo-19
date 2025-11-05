USE Clinicks_BD_I;

SET NOCOUNT ON;

BEGIN TRY
    BEGIN TRANSACTION;

    DECLARE @idRolMedico INT;
    SELECT @idRolMedico = id_rol FROM Rol WHERE nombre_rol = 'Medico';

    IF @idRolMedico IS NULL
        THROW 51000, 'No existe el rol "Medico".', 1;

    -- Lista de médicos disponibles (Rol = Medico)
    IF OBJECT_ID('tempdb..#Medicos') IS NOT NULL DROP TABLE #Medicos;
    SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS rn,
           ure.id_rol, ure.id_usuario, ure.id_especialidad
    INTO #Medicos
    FROM Usuario_rol_especialidad ure
    WHERE ure.id_rol = @idRolMedico;

    DECLARE @cntMedicos INT = (SELECT COUNT(*) FROM #Medicos);
    IF @cntMedicos = 0
        THROW 51001, 'No hay médicos cargados.', 1;

    -- Lista de fichas médicas
    IF OBJECT_ID('tempdb..#Fichas') IS NOT NULL DROP TABLE #Fichas;
    SELECT id_paciente, fecha_creacion
    INTO #Fichas
    FROM Ficha_medica;

    DECLARE @cntFichas INT = (SELECT COUNT(*) FROM #Fichas);

    -- Tabla temporal de todos los tipos posibles (para consultas rápidas)
    IF OBJECT_ID('tempdb..#RegEsp') IS NOT NULL DROP TABLE #RegEsp;
    SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS rn,
           id_tipo_registro, id_rol, id_especialidad
    INTO #RegEsp
    FROM Registro_especialidad;

    -- Observación fija
    DECLARE @obs NVARCHAR(255) = N'El paciente esta sano, no presenta sintomas algunos';

    DECLARE @f INT = 1;
    WHILE @f <= @cntFichas
    BEGIN
        DECLARE @id_paciente INT, @fecha_creacion DATE;
        SELECT @id_paciente = id_paciente, @fecha_creacion = fecha_creacion
        FROM #Fichas WHERE id_paciente = @f;

        DECLARE @i INT = 1;
        WHILE @i <= 1000
        BEGIN
            DECLARE @rndMedico INT = 1 + ABS(CHECKSUM(NEWID()) % @cntMedicos);

            DECLARE @id_rol_usuario INT, @id_usuario INT, @id_especialidad_usuario INT;
            SELECT @id_rol_usuario = id_rol,
                   @id_usuario = id_usuario,
                   @id_especialidad_usuario = id_especialidad
            FROM #Medicos WHERE rn = @rndMedico;

            -- Filtramos tipos de registro válidos para esa especialidad
            DECLARE @cntTipos INT = (
                SELECT COUNT(*) FROM #RegEsp
                WHERE id_rol = @id_rol_usuario AND id_especialidad = @id_especialidad_usuario
            );

            IF @cntTipos > 0
            BEGIN
                DECLARE @rndTipo INT = 1 + ABS(CHECKSUM(NEWID()) % @cntTipos);
                DECLARE @id_tipo_registro INT, @id_rol_proc INT, @id_esp_proc INT;

                SELECT TOP 1
                    @id_tipo_registro = id_tipo_registro,
                    @id_rol_proc = id_rol,
                    @id_esp_proc = id_especialidad
                FROM #RegEsp
                WHERE id_rol = @id_rol_usuario AND id_especialidad = @id_especialidad_usuario
                ORDER BY NEWID();

                -- Generamos fecha aleatoria entre fecha_creacion y hoy
                DECLARE @fecha DATE =
                    DATEADD(DAY,
                        ABS(CHECKSUM(NEWID()) % (1 + DATEDIFF(DAY, @fecha_creacion, GETDATE()))),
                        @fecha_creacion
                    );

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

                INSERT INTO Registro_Indexado (
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

            SET @i += 1;
        END

        SET @f += 1;
    END

    COMMIT TRANSACTION;
    PRINT 'Inserción completa de 1.000.000 registros.';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error en la transacción: ' + ERROR_MESSAGE();
END CATCH;


select count (*) from registro;
