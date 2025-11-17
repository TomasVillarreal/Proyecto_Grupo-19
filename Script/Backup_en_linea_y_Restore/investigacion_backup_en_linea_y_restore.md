# Tema de investigación:   
## Backup y Backup en línea

## Introducción

Se entiende por **Backup (copia de seguridad)** al proceso de crear y almacenar una copia de los datos (archivos de bases de datos, estructuras, registros de transacciones) de una base de datos SQL, la cual puede ser utilizada posteriormente para restaurar y recuperar dichos datos tras sufrir una falla o pérdida (desperfectos del hardware, ciberataques o simples cortes de energía) [1].

Se debe comprender además la diferencia entre el **modelo de recuperación de datos** y la **restauración de datos** propiamente dicha; el primero refiere a una propiedad de la base de datos que determina sus requisitos de copias de seguridad y restauración al controlar el mantenimiento del registro de transacciones. Existen tres modelos: simple, completa y por medio de registros de operaciones masivas (bulk-logged) [1]. En cuanto a la restauración, comprende un proceso multifacético que copia todos los datos y páginas del registro desde un backup de SQL Server específico a una base de datos concreta [1]. La correcta identificación del modelo de restauración es crucial, puesto que marca las limitaciones impuestas a la hora de planificar la estrategia ideal de recuperación para cada situación.

## ¿Qué son el RTO y el RPO?

Una recuperación eficaz de la base de datos ante eventos imprevistos debe comprender un plan de copias robusto, que garantice la replicación constante y el almacenamiento correcto de los datos, de manera que se minimice la pérdida o corrupción de los mismos y se asegure la continuidad del negocio. Para ello, se toman como parámetros al **Objetivo de Tiempo de Recuperación (RTO)**, el cual define la cantidad máxima de tiempo de inactividad del sistema admisible luego de un fallo antes de que las operaciones del negocio se vean afectadas [2]. De forma complementaria, se tiene en cuenta además el **Objetivo de Punto de Recuperación (RPO)**, que determina el periodo máximo tolerable de pérdida de datos medido en tiempo [2]. Ambas métricas son esenciales en el diseño de un plan de recuperación eficiente.

## Tipos de Modelos de Recuperación

### Modelo de Recuperación Simple
Este modelo elimina automáticamente los registros del log de transacciones tras cada transacción completada. Por lo tanto, no admite copias de seguridad del registro de transacciones, solo copias de seguridad completas o diferenciales [3]. Las operaciones que requieren copias de seguridad del registro de transacciones no son compatibles con el modelo de recuperación simple [4]. Esto puede provocar la pérdida de los datos modificados entre el momento de la copia de seguridad completa o diferencial más reciente y el momento del fallo. Sus ventajas consisten en su baja complejidad para administrarse y el poco espacio requerido en el disco, al remover automáticamente los logs de transacciones.

### Modelo de Recuperación Completo
El objetivo es restaurar por completo la base de datos, la cual permanece fuera de linea durante todo el proceso. Antes de que cualquier parte de la base de datos pueda conectarse, se recuperan todos los datos a un punto consistente (todas las partes de la base de datos se encuentran en el mismo momento) y no existen transacciones pendientes [4]. Con el modelo de recuperación completa, después de restaurar la copia de seguridad, se debe restaurar todas las copias de seguridad posteriores del registro de transacciones y, a continuación, recuperar la base de datos. Es posible restaurar una base de datos a un punto de recuperación específico dentro de una de estas copias de seguridad del registro. El punto de recuperación puede ser una fecha y hora específicas, una transacción marcada o un número de secuencia de registro (LSN) [5].

### Modelo de Recuperación Bulk-Logged
Un complemento del modelo de recuperación completa que permite realizar copias masivas de alto rendimiento. Reduce el uso del espacio de registro mediante un registro mínimo para la mayoría de las operaciones masivas [4].

## Tipos de Backups en SQL Server

- **Backup Completo (Full):** representan a la instancia de base de datos en su totalidad al momento de finalizar la copia de seguridad.
- **Backup Diferencial:** se trata de una copia de seguridad basada en la última copia completa o parcial realizada sobre una base de datos. Este tipo de backup solamente registra las extensiones de datos que han sido modificados en grupos de archivos desde la última copia realizada [1], la cual es denominada base de la diferencial.
- **Backup Parcial:** contiene datos de algunos de los grupos de archivos de la base de datos [1], conteniendo los datos del grupo de archivos principal, todos los grupos de archivos de lectura/escritura y, opcionalmente, uno o varios archivos de solo lectura [6]. Este tipo de backup está diseñado para usarse con el modelo de recuperación simple a fin de mejorar la flexibilidad al realizar copias de seguridad de bases de datos grandes que contienen uno o varios archivos de solo lectura.
- **Backup de Archivos:** una copia de seguridad de uno o varios archivos de la base de datos [1].
- **Backup de Registro:** copia de seguridad del log de transacciones que incluye a todos aquellos registros que no fueron incluidos en la copia anterior [1].

## ¿Cómo crear un Backup completo para una base de datos?

Una vez definida las estructuras y datos de nuestra base de datos, la sintaxis básica para la creación de un **Backup de tipo Full** es:

```sql
BACKUP DATABASE [nombre_base_de_datos]
TO <dispositivo_almacenamiento> = N'direccion_almacenamiento_Backup.bak'
WITH <especificaciones> N'nombre_archivo_Backup_Full',
     STATS = 10;
GO
```

Para la aplicación práctica de esta temática y a modo de ejemplo, el comando t-sql utilizado para generar el Backup Full inicial de la base de datos es:

```sql
PRINT '--- Tarea 2: Realizando Backup FULL ---';
BACKUP DATABASE [Clinicks_BD_I]
    TO DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS01\MSSQL\DATA\Clinicks_Base_de_datos_BU_Full.bak'
    WITH NOFORMAT, NOINIT,  NAME = N'  Base de Datos_Clinikcs_Copia de seguridad_Full',
  STATS = 10
GO
```

En este caso, se indica que el Backup se almacenará en el disco C de la unidad donde se crea el mismo, en una carpeta (Data) específica y con los permisos necesarios para que el SSMS pueda realizar las tareas requeridas de lectura y escritura. A su vez, los comandos de especificaciones utilizados corresponden a:

- **NOINIT:** En lugar de sobrescribir el archivo de backup, agrega este nuevo backup al final del archivo existente, lo cual es importante si se trabaja con una cadena de Log de transacciones.
- **NOFORMAT:** Le indica a SQL Server que no debe reescribir la cabecera del medio (el archivo). Simplemente asume que el formato es correcto y empieza a escribir los datos del backup.
- **STATS = 10:** Muestra el progreso del backup en la ventana de "Mensajes". Imprimirá una notificación cada vez que complete un 10% del trabajo (luego 20%, 30%, etc.). Resulta útil para el usuario llevar un registro explícito del progreso de creación del Backup.

### Creación del Backup del Log de transacciones

```sql
BACKUP LOG [Clinicks_BD_I]
TO DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS01\MSSQL\DATA\Clinicks_LOG1.trn' 
    WITH INIT, NAME = N'Clinicks_Copia_de_seguridad_LOG1', STATS = 10; 
GO
```

De manera similar a la sintaxis para un backup full, el backup de LOG no presenta mayores diferencias con el primero, más allá de utilizar la palabra reservada LOG y la especificación INIT, la cual sobreescribe el archivo .bak existente.

## Bibliografía
1. https://learn.microsoft.com/en-us/sql/relational-databases/backup-restore/backup-overview-sql-server?view=sql-server-ver17
2. https://aerospike.com/blog/understanding-database-disaster-recovery/
3. https://www.syncfusion.com/blogs/post/sql-server-recovery-models-a-quick-guide/amp
4. https://learn.microsoft.com/en-us/sql/relational-databases/backup-restore/recovery-models-sql-server?view=sql-server-ver17
5. https://learn.microsoft.com/en-us/sql/relational-databases/backup-restore/complete-database-restores-full-recovery-model?view=sql-server-ver17
6. https://learn.microsoft.com/es-es/sql/relational-databases/backup-restore/partial-backups-sql-server?view=sql-server-ver17

