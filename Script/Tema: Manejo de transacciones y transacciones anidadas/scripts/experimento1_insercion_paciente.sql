use Clinicks_BD_I

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
