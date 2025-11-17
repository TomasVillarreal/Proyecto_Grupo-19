use Clinicks_BD_I
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

