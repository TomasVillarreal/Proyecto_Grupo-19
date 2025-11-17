--ELIMINACION PACIENTE EN CASCADA

DECLARE @dni_paciente_elim INT = 40000002 --40000001 

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRY
BEGIN TRANSACTION
--Eliminar a la paciente usando su DNI único
   DELETE FROM Paciente
   WHERE dni_paciente = @dni_paciente_elim;

---------------------------------
--Prueba para forzar error
  THROW 50000, 'ERROR SIMULADO: prueba de ROLLBACK ejecutada', 1
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
