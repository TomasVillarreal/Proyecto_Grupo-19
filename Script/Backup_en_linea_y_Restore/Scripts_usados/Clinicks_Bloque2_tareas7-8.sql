/* ====================================================================
 BLOQUE 2: RESTAURACIÓN ESCENARIO 1 (Tareas 7-8)
====================================================================
*/
--Tarea 7: Para poder implementar los recovery de los logs en planteados en el escenario 1,
--se simula un ataque/desastre en la base de datos borrandola
USE MASTER
go
DROP DATABASE Clinicks_BD_I
go
--Hora de finalización: 2025-11-16T19:56:22.7739436-03:00

-- 7.1. Restaurar el backup FULL: se restauran las estructuras y datos al momento de realizar el primer backup completo
RESTORE DATABASE [Clinicks_BD_I]
    FROM DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS01\MSSQL\DATA\Clinicks_Base_de_datos_BU_Full.bak'
    WITH NORECOVERY, STATS = 10;
GO
-- WITH NORECOVERY: indica que la base de datos queda a la espera de la carga del siguiente archivo de log en la cadena (estado de Restoring)

-- 7.2. Restaurar el LOG 1 (recuperando y deteniéndose en el tiempo)
-- Se ingresa como variable la hora de finalizacion de transaccion del backup de log 1 (el que contiene los primeros 20 registros de la tabla pacientes)
--para luego ingresarla como parametro a la hora de realizar la restauracion del log 1.

DECLARE @HoraCorte DATETIME = '2025-11-16 19:19:21.023'; 

PRINT 'Restaurando hasta: ' + CONVERT(VARCHAR, @HoraCorte, 121);

RESTORE LOG [Clinicks_BD_I]
    FROM DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS01\MSSQL\DATA\Clinicks_LOG1.trn'
    WITH RECOVERY, STATS = 10, STOPAT = @HoraCorte;
GO


-- En esta oportunidad, como el backup del Log 1 no fue capaz de pausar el estado de Recovering de la base de datos, se fuerza su recuperacion manualmente con el comando:
RESTORE DATABASE [Clinicks_BD_I] WITH RECOVERY;
GO

-- TAREA 8: Verificar el resultado
PRINT '--- Tarea 8: Verificación (Escenario 1) ---';
USE Clinicks_BD_I;

--Se realiza un select para confirmar que se hayan restaurado solo los primeros 20 registros de la tabla Paciente
SELECT COUNT(*) AS 'Total Restaurado (Escenario 1)' FROM Paciente;
SELECT * FROM Paciente;
GO 

