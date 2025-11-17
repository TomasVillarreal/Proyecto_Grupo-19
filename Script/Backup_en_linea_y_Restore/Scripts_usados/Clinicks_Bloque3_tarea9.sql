/* ====================================================================
 BLOQUE 3: RESTAURACIÓN ESCENARIO 2 (Tarea 9)
====================================================================
*/

--9.1 (Simulación de desastre)
USE MASTER;
GO
DROP DATABASE Clinicks_BD_I;
GO

PRINT '--- Tarea 9: Se restauran AMBOS logs (completo) ---';

-- 9.2. Se restaura el backup completo: nuevamente, se restauran las estructuras y datos contenidos en el primer backup full de la base de datos
RESTORE DATABASE [Clinicks_BD_I]
    FROM DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS01\MSSQL\DATA\Clinicks_Base_de_datos_BU_Full.bak'
    WITH NORECOVERY, STATS = 10;
GO
-- 9.3. Se restaura el LOG 1 (sin recuperar, es decir, sin terminar el estado Recovering)
RESTORE LOG [Clinicks_BD_I]
    FROM DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS01\MSSQL\DATA\Clinicks_LOG1.trn'
    WITH NORECOVERY, STATS = 10;
GO
-- 9.3. Se restaura el LOG 2: en este escenario, como se busca restaurar ambos archivos log de la cadena, es el Log 2 quien quita a la base de 
--datos del estado Recovering, terminando su recuperacion por completo
--De esta manera, se recuperan los datos contenidos en el ultimo backup de Log (los 30 registros totales de la Tabla Pacientes)
RESTORE LOG [Clinicks_BD_I]
    FROM DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS01\MSSQL\DATA\Clinikcs_LOG2.trn'
    WITH RECOVERY, STATS = 10;
GO

-- Verificación Tarea 9
--Por ultimo, se realiza una verificacion a traves de un select que muestra los 30 registros totales de la Tabla Paciente obtenidos del Log 2
PRINT '--- Verificación (Escenario 2) ---';
USE Clinicks_BD_I;
GO
SELECT COUNT(*) AS 'Total Restaurado (Escenario 2)' FROM Paciente;
SELECT * FROM Paciente;
GO