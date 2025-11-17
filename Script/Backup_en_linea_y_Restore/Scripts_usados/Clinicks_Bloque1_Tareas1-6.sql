/* ====================================================================
 BLOQUE 1: CREACIÓN, CONFIGURACIÓN Y BACKUPS (Tareas 1-6)
====================================================================
*/

--Como la base Clinicks_BD_I y sus estructuras fueron definidas previamente, 
--se procede a configurar su modelo de recuperación para garantizar que se 
--realice correctamente el backup en linea. Asimismo, se trabajará con el lote de datos inicial presentado en "Clinicks_Inserts"
USE Clinicks_BD_I 

-- Verificación del modo de recuperación para mayor certeza: al trabajar con la versión Express de SQL Managenement Server, 
--el modo de recuperación establecido por defecto es el "Simple", sin embargo, este borra las transacciones del log automáticamente, 
--haciendo imposible el tipo de restauración completa que se requiere (almacenar todas las transacciones en el archivo de log hasta que se haga un BACKUP LOG)
PRINT '--- Tarea 1: Modo de Recuperación ---';
SELECT name, recovery_model_desc FROM sys.databases WHERE name = 'Clinicks_BD_I';
GO 
--Trea 1: se establece el modo de recuperación full 
ALTER DATABASE [Clinicks_BD_I] SET RECOVERY FULL WITH NO_WAIT;
GO

--Tarea 2: Se realiza un primer backup completo de la base de datos en su estado inicial
PRINT '--- Tarea 2: Realizando Backup FULL ---';
BACKUP DATABASE [Clinicks_BD_I]
    TO DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS01\MSSQL\DATA\Clinicks_Base_de_datos_BU_Full.bak'
    WITH NOFORMAT, NOINIT,  NAME = N'  Base de Datos_Clinikcs_Copia de seguridad_Full',
  STATS = 10
GO
--Hora de finalización: 2025-11-16T19:15:06.6237380-03:00

--Comandos utilizados: 
 --*NOINNIT:En lugar de sobrescribir el archivo de backup, agrega este nuevo backup al final del archivo existente. 
 --*NOFORMAT: Le dice a SQL Server que no reescriba la cabecera del medio (el archivo). Simplemente asume que el formato es correcto y empieza a escribir los datos del backup.
 --STATS = 10 Muestra el progreso del backup en la ventana de "Mensajes". Imprimirá una notificación cada vez que complete un 10% del trabajo (luego 20%, 30%, etc.).

 --Tarea 3: Se realizan 10 inserts sobre la tabla Pacientes, tomada como tabla de referencia.(Lote 1 de inserts)
INSERT INTO Paciente (nombre_paciente, apellido_paciente, dni_paciente, telefono_paciente) VALUES
('Julian', 'Acuña', 22358126, 1135821700),  -- id_paciente = 11
('Carla', 'Monzon', 40308612, 1158147211), -- id_paciente = 12
('Juan Carlos', 'Encina', 32124567, 167541234),-- id_paciente= 13
('Sonia', 'Diaz', 35678124, 1107651232), -- id_paciente = 14
('Segundo', 'Esquivel', 34657348, 1167890123),-- id_paciente = 15
('Samanta', 'Barrios', 399342921, 123456789),-- id_paciente = 16 
('Bruno', 'Albarrenque', 48308260, 1152134506),-- id_paciente = 17
('Marcela', 'Herrera', 46234854, 1112345678),-- id_paciente = 18
('Leonardo', 'Williams', 3817343, 1187631452),-- id_paciente = 19
('Ana Paula', 'Villanueva', 43365732, 108921734)-- id_paciente = 20
GO
-- (Verificación Tarea 3: se obtiene el total de registros de la tabla Pacientes luego de la inserción del lote 1 de datos)
SELECT COUNT(*) AS 'Total Despues Lote 1' FROM Paciente --20 registros
GO

-- TAREA 4: Se realiza un backup del log (contiene los registros del lote1 + los 10 registros originales de  la tabla Paciente, 
--20 registros en total de dicha tabla. No se realizaron modificaciones sobre las demas tablas del modelo.
PRINT '--- Tarea 4: Realizando Backup LOG 1 ---';
DECLARE @HoraCorte_Log1 DATETIME = GETDATE();
PRINT '================================================================';
PRINT 'HORA DE CORTE (STOPAT): ' + CONVERT(VARCHAR, @HoraCorte_Log1, 121);
PRINT '================================================================';
--Hora de finalización: 2025-11-16 19:19:21.023

PRINT '--- Realizando Backup LOG 1 ---';
BACKUP LOG [Clinicks_BD_I]
    TO DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS01\MSSQL\DATA\Clinicks_LOG1.trn' 
    WITH INIT, NAME = N'Clinicks_Copia_de_seguridad_LOG1', STATS = 10; 
GO
-- Se hace una pequeña pausa para asegurar una marca de tiempo distinta
WAITFOR DELAY '00:00:05'; 
GO

-- TAREA 5: Se generan otros 10 inserts (Lote 2). Se hará una pausa de 1 minuto entre las transacciones a fin de obtener distintas y mas representativas marcas de tiempo en el log
 INSERT INTO Paciente (nombre_paciente, apellido_paciente, dni_paciente, telefono_paciente) VALUES
('Santino', 'Alavarez', 34590432, 1190056921)  -- id_paciente = 21
-- Hago una pausa de un minuto
WAITFOR DELAY '00:01'; 

INSERT INTO Paciente (nombre_paciente, apellido_paciente, dni_paciente, telefono_paciente) VALUES
('Justina', 'Martins', 29666324, 1100001234)  -- id_paciente = 22
-- Hago una pausa de un minuto
WAITFOR DELAY '00:01';

INSERT INTO Paciente (nombre_paciente, apellido_paciente, dni_paciente, telefono_paciente) 
VALUES('Walter', 'Liniers', 21000372, 1177889900) -- id_paciente = 23
-- Hago una pausa de un minuto
WAITFOR DELAY '00:01';

INSERT INTO Paciente (nombre_paciente, apellido_paciente, dni_paciente, telefono_paciente) VALUES
('Stefania', 'Bucatti', 36903105, 1145672183)    -- id_paciente = 24
-- Hago una pausa de un minuto
WAITFOR DELAY '00:01';

INSERT INTO Paciente (nombre_paciente, apellido_paciente, dni_paciente, telefono_paciente) VALUES
('German', 'Lovato', 34222841, 1115379478) -- id_paciente = 25
-- Hago una pausa de un minuto
WAITFOR DELAY '00:01';

INSERT INTO Paciente (nombre_paciente, apellido_paciente, dni_paciente, telefono_paciente) VALUES
('Bautista', 'Silva', 39342923, 1135613399) -- id_paciente = 26
-- Hago una pausa de un minuto
WAITFOR DELAY '00:01';

INSERT INTO Paciente (nombre_paciente, apellido_paciente, dni_paciente, telefono_paciente) VALUES
('Iker', 'Sotomayor',48380907, 1152138547)  -- id_paciente = 27 
-- Hago una pausa de un minuto
WAITFOR DELAY '00:01';

INSERT INTO Paciente (nombre_paciente, apellido_paciente, dni_paciente, telefono_paciente) VALUES
('Micaela', 'Bustos', 46234904, 1112347856)  -- id_paciente = 28
-- Hago una pausa de un minuto
WAITFOR DELAY '00:01';

INSERT INTO Paciente (nombre_paciente, apellido_paciente, dni_paciente, telefono_paciente) VALUES
('Lucas', 'Chavez', 38717891, 1187635214) -- id_paciente = 29
-- Hago una pausa de un minuto
WAITFOR DELAY '00:01';

INSERT INTO Paciente (nombre_paciente, apellido_paciente, dni_paciente, telefono_paciente) VALUES
('Paulina', 'Sotelo', 43365324, 1109214875); -- id_paciente = 30
GO
--Hora de finalización: 2025-11-16T19:29:59.4121228-03:00

-- (Verificación Tarea 5)

SELECT COUNT(*) AS 'Total Despues Lote 2' FROM Paciente; -- 30 registros de la tabla Paciente
SELECT * FROM Paciente;
GO

-- TAREA 6: Realizar nuevamente backup de archivo de log (LOG 2): incluye los 10 nuevos registros insertados en el lote 2 
PRINT '--- Tarea 6: Realizando Backup LOG 2 ---';
BACKUP LOG [Clinicks_BD_I]
    TO DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS01\MSSQL\DATA\Clinikcs_LOG2.trn'
    WITH INIT, NAME = N'Clinicks_Copia_de_seguridad__LOG2', STATS = 10;
GO 

--Hora de finalización: 2025-11-16T19:35:04.8795213-03:00

-- Se verifica el header de cada backup de log. con la fecha de finalizacion de backup para confirmar hasta que log se debe restaurar
RESTORE HEADERONLY 
    FROM DISK='C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS01\MSSQL\DATA\Clinicks_LOG1.trn' 
GO
RESTORE HEADERONLY 
    FROM DISK='C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS01\MSSQL\DATA\Clinikcs_LOG2.trn'
GO

