use Clinicks_BD_I
--EXPERIMENTO 3: Prueba de INSERCION EXITOSA 
--INSERCION CON MEDICACION OPCIONAL
--------------------------------------------------
PRINT '---EXPERIMENTO 3: INSERCION EXITOSA---'
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
DECLARE @dni_test INT = 40000002
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
