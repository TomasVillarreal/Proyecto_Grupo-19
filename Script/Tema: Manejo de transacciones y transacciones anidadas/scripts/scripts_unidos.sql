use Clinicks_BD_I_COPIA

--Finalidad, si ocurre violacion de principios de pk, o restricciones unique
--INSERCION DE NUEVO PACIENTE
DECLARE @dni_paciente_ins INT = 47123456  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRY
BEGIN TRANSACTION
--Se crea nuevo paciente
    INSERT INTO Paciente (nombre_paciente, apellido_paciente, dni_paciente, telefono_paciente)
    VALUES ('Marina', 'Quiroga', @dni_paciente_ins, 1198765432)
    DECLARE @nuevo_id_paciente INT = SCOPE_IDENTITY()--Se obtiene valor del identity recien creado y se asigna a la var tempo 

--Se crea su ficha medica
    INSERT INTO Ficha_medica (id_paciente, tipo_sanguineo, estatura, peso)
    VALUES (@nuevo_id_paciente, 'O+', 165, 60.5)

--Se crea un registro clinico inicial 
    INSERT INTO Registro (
        observaciones, id_tipo_registro,
        id_rol_procedimiento, id_especialidad_procedimiento,
        id_rol_usuario, id_usuario, id_especialidad_usuario, id_paciente
    )
    VALUES ('Control inicial. Signos vitales dentro de parametros normales', 
        1, 2, 1, 2, 6, 1, @nuevo_id_paciente)
    DECLARE @nuevo_id_registro INT = SCOPE_IDENTITY()

--Se agrega la MEDICACION asociada al Registro
--id_medicacion = 1 (amoxicilina)
    INSERT INTO Registro_medicacion (id_medicacion, id_registro, id_paciente)
    VALUES (1, @nuevo_id_registro, @nuevo_id_paciente)

    COMMIT TRANSACTION;
    PRINT 'Transaccion completada correctamente: paciente creado junto a ficha y registro'
-----Se prueba error con rollback al querer ingresar mismo paciente con mismos datos-----
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION; 
    PRINT '-----------------------------------'
    PRINT 'El paciente ' + CAST(@dni_paciente_ins AS VARCHAR) + ' ya existe'
    PRINT ERROR_MESSAGE();
    PRINT '-----------------------------------'
END CATCH;
-------------------------------------------------------------------


--ELIMINACION PACIENTE EN CASCADA

DECLARE @dni_paciente_elim INT = 40000003 --40000001 

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRY
BEGIN TRANSACTION
--Eliminar a la paciente usando su DNI único
   DELETE FROM Paciente
   WHERE dni_paciente = @dni_paciente_elim;

---------------------------------
--Prueba para forzar error
 --THROW 50000, 'ERROR SIMULADO: prueba de ROLLBACK ejecutada', 1
---------------------------------

--Se verifica que ya no se haya eliminado
   IF @@ROWCOUNT = 0
   BEGIN
--Si se eliminaron 0 filas, mostramos una advertencia
        PRINT 'No se encontro paciente con ese DNI. No se realizaron cambios'
        COMMIT TRANSACTION
   END
   ELSE
   BEGIN

-- Si se elimina la fila en Paciente, las filas asociadas en Ficha_medica, 
-- Registro y Registro_medicacion se eliminan automáticamente (CASCADE).
    COMMIT TRANSACTION;
    PRINT 'Paciente dado de baja con exito'
   END
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
    BEGIN
        ROLLBACK TRANSACTION;
        PRINT '-----------------------------------'
        PRINT 'No se pudo eliminar al paciente '+ CAST(@dni_paciente_elim AS VARCHAR)
        PRINT ERROR_MESSAGE()
        PRINT '-----------------------------------'

    END
END CATCH


--------------------------------------------------
--INSERCION CON MEDICACION OPCIONAL
--------------------------------------------------

--------------------------------------------------
--EXPERIMENTO 3: Prueba de INSERCION EXITOSA 
--INSERCION CON MEDICACION OPCIONAL
--------------------------------------------------
PRINT '---EXPERIMENTO 3: INSERCION EXITOSA---'
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
DECLARE @dni_test INT = 40000003
DECLARE @id_medicacion_prueba_existente INT = 1

BEGIN TRANSACTION
BEGIN TRY
--Se crea nuevo paciente
    INSERT INTO Paciente (nombre_paciente, apellido_paciente, dni_paciente, telefono_paciente)
    VALUES ('Luis', 'Rojas', @dni_test, 1199000000)
    DECLARE @id_paciente_1 INT = SCOPE_IDENTITY()

--Se crea ficha medica
    INSERT INTO Ficha_medica (id_paciente, tipo_sanguineo, estatura, peso)
    VALUES (@id_paciente_1, 'A+', 170, 75.0)

--Se crea registro clinico
    INSERT INTO Registro (observaciones, id_tipo_registro, id_rol_procedimiento, id_especialidad_procedimiento, id_rol_usuario, id_usuario, id_especialidad_usuario, id_paciente)
    VALUES ('Control de rutina.', 1, 2, 1, 2, 6, 1, @id_paciente_1)
    DECLARE @id_registro_1 INT = SCOPE_IDENTITY()

--SE ESTABLECE SAVEPOINT ANTES DE OPCIONAL (Medicacion)
    SAVE TRANSACTION Medicacion_Check
--Se agrega MEDICACION EXITOSA
    INSERT INTO Registro_medicacion (id_medicacion, id_registro, id_paciente)
    VALUES (@id_medicacion_prueba_existente, @id_registro_1, @id_paciente_1)

    COMMIT TRANSACTION;
    PRINT 'EXPERIMENTO 3: Insercion Completa Exitosa (Paciente, Ficha, Registro, Medicación)';

END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
    PRINT 'ERROR EN EXPERIMENTO 3: EL PACIENTE ' +CAST(@dni_test AS VARCHAR)+ ' YA FUE INGRESADO ' + ERROR_MESSAGE()
END CATCH

--------------------------------------------------
-- EXPERIMENTO 4: Prueba de ROLLBACK PARCIAL 
-- Medicacion Falla
--------------------------------------------------
DECLARE @dni_test2 INT = 40000003
DECLARE @id_medicacion_prueba_fallida2 INT = 9999 --Este ID NO EXISTE (causa el fallo de FK)
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

PRINT '---EXPERIMENTO 4: ROLLBACK PARCIAL ---'

BEGIN TRY
BEGIN TRANSACTION
    --Se crea nuevo paciente
    INSERT INTO Paciente (nombre_paciente, apellido_paciente, dni_paciente, telefono_paciente)
    VALUES ('Ana', 'Perez', @dni_test2, 1199000001)
    DECLARE @id_paciente_2 INT = SCOPE_IDENTITY()

    --Se crea ficha medica
    INSERT INTO Ficha_medica (id_paciente, tipo_sanguineo, estatura, peso)
    VALUES (@id_paciente_2, 'O-', 160, 55.0)

    --Se crea registro clinico
    INSERT INTO Registro (observaciones, id_tipo_registro, id_rol_procedimiento, id_especialidad_procedimiento, id_rol_usuario, id_usuario, id_especialidad_usuario, id_paciente)
    VALUES ('Paciente con gripe. Se intenta recetar medicacion', 1, 2, 1, 2, 6, 1, @id_paciente_2)
    DECLARE @id_registro_2 INT = SCOPE_IDENTITY()

    --ESTABLECER SAVEPOINT (TRANSACCION ANIDADA)
    SAVE TRANSACTION Medicacion_Check

    --Se intenta agregar MEDICACION que se SABE FALLARA (FK)
    INSERT INTO Registro_medicacion (id_medicacion, id_registro, id_paciente)
    VALUES (@id_medicacion_prueba_fallida2, @id_registro_2, @id_paciente_2)
    
    COMMIT TRANSACTION

END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
    BEGIN
        --Verificar si el error fue una violacion de FK (547)
        IF ERROR_NUMBER() = 547 
        BEGIN
            --Deshacemos SOLO la insercion de la medicacion.
            ROLLBACK TRANSACTION Medicacion_Check
            
            --Cerramos la transaccion principal (Paciente, Ficha, Registro) exitosamente.
            COMMIT TRANSACTION 
            PRINT 'EXPERIMENTO 4: ROLLBACK PARCIAL EXITOSO'
            PRINT 'Paciente y Registro Clínico guardados. Insercion de Medicacion revertida'
        END
        ELSE
        BEGIN
            --Si es otro error (ej. en Registro), se revierte toda la transaccion principal
            ROLLBACK TRANSACTION 
            PRINT 'EXPERIMENTO 4: Fallo de Transaccion COMPLETA. Se revirtio todo: ' + ERROR_MESSAGE()
        END
    END
END CATCH

--------------------------------------------------
--------------------------------------------------
--------------------------------------------------
--------------------------------------------------
--------------------------------------------------
--------------------------------------------------
--------------------------------------------------
--------------------------------------------------
--------------------------------------------------
--------------------------------------------------
--------------------------------------------------







--VERIFICACION Y ON DELETE CASCADE
--------------------------------------------------
--Verificacion

SELECT 
--Informacion del Paciente
P.id_paciente,
P.nombre_paciente + ' ' + P.apellido_paciente AS Nombre_Completo,
P.dni_paciente,    
--Informacion de la Ficha Medica
FM.tipo_sanguineo,
FM.estatura,
FM.peso,  
--Informacion del Registro
R.id_registro,
R.fecha_registro,
TR.nombre_registro AS Tipo_Procedimiento,
R.observaciones,   
-- Informacion de la Medicacin
M.nombre_medicacion,
M.dosis_medicacion
FROM  Paciente as P
    INNER JOIN Ficha_medica as FM 
    ON P.id_paciente = FM.id_paciente
    INNER JOIN Registro as R 
    ON P.id_paciente = R.id_paciente
    INNER JOIN Tipo_registro as TR 
    ON R.id_tipo_registro = TR.id_tipo_registro
    LEFT JOIN Registro_medicacion as RM
    ON R.id_registro = RM.id_registro AND R.id_paciente = RM.id_paciente
    LEFT JOIN Medicacion as M 
    ON RM.id_medicacion = M.id_medicacion
WHERE P.dni_paciente =40000003 --40000001 



---------------------------------------------------------------------
--Se realiza modificacion de constraint en fk agregando ON DELETE CASCADE en las tbalasde Ficha Medica, Registro, Registro_modificacion
--Ficha medica
ALTER TABLE Ficha_medica
DROP CONSTRAINT FK_ficha_medica_paciente;

ALTER TABLE Ficha_medica
ADD CONSTRAINT FK_ficha_medica_paciente FOREIGN KEY (id_paciente)
REFERENCES Paciente(id_paciente)
ON DELETE CASCADE;
GO

--Registro
ALTER TABLE Registro
DROP CONSTRAINT FK_registro_ficha_paciente;

ALTER TABLE Registro
ADD CONSTRAINT FK_registro_ficha_paciente FOREIGN KEY (id_paciente)
REFERENCES Ficha_medica(id_paciente)
ON DELETE CASCADE;
GO

--Registro Medicacion
ALTER TABLE Registro_medicacion
DROP CONSTRAINT FK_registro_medicacion_registro;

ALTER TABLE Registro_medicacion
ADD CONSTRAINT FK_registro_medicacion_registro FOREIGN KEY (id_registro, id_paciente)
REFERENCES Registro(id_registro, id_paciente)
ON DELETE CASCADE;
GO


























