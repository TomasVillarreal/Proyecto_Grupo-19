<h1 align="center"> Conclusiones de la Aplicación Práctica de Backup y Backup en Línea al Proyecto de Estudio “Clinicks \- Sistema de Gestión de Pacientes” </h1>

# Preámbulo: 

Con el fin de realizar una aplicación integral de copia de seguridad y restauración al modelo desarrollado para el presente Proyecto de Estudio, se han agregado dos lotes de datos a la tabla Pacientes, identificados en el script práctico como Lote 1 y Lote 2 (de 10 registros cada uno) en dos etapas diferenciadas para simular una carga de trabajo normal en el contexto del ingreso de datos de los pacientes que acuden a la Clínica y obtener una visión clara del almacenamiento de los datos en el  Log de Transacciones. Asimismo, se utilizó como estructura de datos y pool de datos de partida a las tablas y registros contenidos en : <a href=https://github.com/TomasVillarreal/Proyecto_Grupo-19/tree/main/Script/Backup_en_linea_y_Restore/Scripts_usados> este link</a>. 

# Introducción: 

El desarrollo del trabajo de aplicación práctica sobre la temática Backup y Backup en Línea fue planificado con el objetivo de lograr un análisis provechoso del desempeño de las estrategias de copia de seguridad en Línea y la recuperación ante desastres basada en el modelo de recuperación completo de SQL Server (Full Recovery Model), la cual también facilita la implementación de una Point-in-Time Restore (recuperación hasta un punto de tiempo determinado).   
Para una mayor comprensión de las operaciones realizadas, es necesario esclarecer ciertos conceptos estructurales del SSMS: 

* Write-Ahead-Loggin (WAL): se trata del protocolo central por el que se rigen las operaciones en SQL SERVER, que garantiza la propiedad de Atomicidad y Durabilidad (ACID) al no permitir que ninguna modificación se escriba en el archivo .mdf de la base de datos (archivo principal donde se definen las estructuras principales como la determinación de tablas,columnas, indices, etc.) sin antes haberse registrado en el archivo de registro de transacciones (.ldf).   
  Al determinarse el Modelo de Recuperación Completa para el caso de estudio, es posible retener el historial de transacciones hasta que se realice un respaldo explícito del Log, permitiendo la restauración del estado de la base de datos a un momento específico de tiempo.   
    
* Log Chain: La entereza de la estrategia implementada se encuentra en el manejo de la cadena de logs. Cada registro de transacción aplicado a una base de datos posee un identificador único secuencial denominado LSN (Log Sequence Number, Número de Secuencia del Log). Al realizar un backup de Log se está resguardando una sucesión de LSN determinada, donde el primer número de secuencia de log debe coincidir o sobreescribir al último número de secuencia del último respaldo realizado. La desventaja de esta estrategia está en que el quiebre de la continuidad de la cadena de Logs imposibilita la restauración posterior a dicho punto de quiebre.  
* Fases de Restauración: el proceso de restauración de una base de datos posee tres etapas, estrechamente relacionadas al uso de las cláusulas NORECOVERY y RECOVERY:   
- Fase de Copia de Datos: se transfieren las páginas de datos hacia el disco desde el medio de respaldo.   
- Fase REDO/ROLLFOWARD: el motor procesa el transaction log y aplica las modificaciones indicadas para actualizar la base de datos. Al utilizar la cláusula NORERECOVERY se le indica al motor que debe detenerse y entrar en el estado de Restoring a la espera de la carga de logs siguientes al último almacenado en el backup restaurado hasta ese punto.   
- Fase UNDO/ROLLBACK: el motor identifica las transacciones activas al momento del corte (fase anterior) y las revierte para asegurar la integridad transaccional. Al utilizar RECOVERY, se libera a la base de datos de su estado “en espera” y pasa a su estado online. 

El caso de aplicación práctica contempla la creación de un Backup completo de la base de datos preliminar, el cual actúa como raíz de los dos escenarios de restauración tras un desastre (simulado por la eliminación completa de la base de datos) que se desarrollan : el primero de ellos plantea una estrategia de Recuperación a un Punto en el Tiempo, tomando como referencia temporal a la hora de finalización de ejecución del primer Backup de Log, creado tras la inserción del Lote 1 de registros a la tabla Paciente; por otro lado, el segundo escenario plantea una recuperación completa de la cadena de Logs implementada para esta experimentación, lo cual supone la recuperación de ambos Backups del Log y los 30 registros totales de la tabla de referencia.    
Los procesos mencionados están divididos en: 

* Bloque I: tareas 1 a la 6  
  \-Tarea 1: Configuración del modo de recuperación Full.   
  \-Tarea 2:Creación del Backup completo de la base de datos Clinicks\_BD\_I.   
  \-Tarea 3: Inserción del Lote 1 de registros a la tabla Pacientes.   
  \-Tarea 4: Creación del Primer Backup del Log (Log1) y definición de la hora de corte (marca de tiempo a utilizar en el escenario de recuperación 1).  
  \-Tarea 5: Inserción del Lote 2 de registros a la tabla Pacientes.   
  \-Tarea 6:  Creación del Segundo Backup del Log (Log2)   
    
* Bloque 2:  tareas 7 y 8  
  \-Tarea 7: simulación de un desastre (borrado completo de la Base de Datos Clinicks\_BD\_I y restauración al punto en el tiempo de finalización del Log 1)\.   
  \-Tarea 8: verificación de la restauración correcta de la estructura de datos y los 20 registros de la tabla de referencia almacenados hasta ese punto.   
    
* Bloque 3: Tarea 9   
  \-Tarea 9: simulación de un desastre (borrado completo de la Base de Datos Clinicks\_BD\_I y restauración de la cadena de log (Log 1 y Log2)). Se realiza además una verificación de la restauración correcta de la estructura de datos y los 30 registros de la tabla de referencia almacenados.




# Resultados del Bloque 1: 

Por defecto, la versión Express de SQL SERVER MANAGEMENT, establece como default el modo de recuperación simple.   
Luego de realizar una query con los comandos de creación contenidos en <a href=https://github.com/TomasVillarreal/Proyecto_Grupo-19/tree/main/Script/Backup_en_linea_y_Restore/Scripts_usados> los archivos Clinicks_creacion_tablas y Cliniks_inserts</a>  y ajustar el modo de recuperación de Simple a Completo, se procedió a realizar el backup “raíz” del proyecto, puesto que no es posible realizar la recuperación de los backups de Logs sin antes haber realizado un backup full de la base de datos a resguardar. 

<p align="center">
  <img src="https://github.com/TomasVillarreal/Proyecto_Grupo-19/blob/main/Script/Backup_en_linea_y_Restore/img_aplicacion_practica_backup/modo%20simple%20recovery.png" alt="verificación del Recovery Mode seteado a Simple"/>
</p> 
<p align="center">
  <img src="https://github.com/TomasVillarreal/Proyecto_Grupo-19/blob/main/Script/Backup_en_linea_y_Restore/img_aplicacion_practica_backup/modo%20full%20recovery.png" alt="verificación del Recovery Mode seteado a Full"/>
</p> 

Una vez hechas las configuraciones necesarias para realizar un Backup Full de la base de datos, se ejecutan los comandos para obtener el backup completo 1 que nos permitirá realizar los backups de la cadena de transacciones más adelante (sin un backup Full "raíz", no es posible realizar backups de registro posteriores). 
<p align="center">
  <img src="<p align="center">
  <img src="https://github.com/TomasVillarreal/Proyecto_Grupo-19/blob/main/Script/Backup_en_linea_y_Restore/img_aplicacion_practica_backup/modo%20full%20recovery.png" alt="Backup Completo de la Base de datos"/>

</p> 

Se procede a realizar una carga de trabajo representativa (10 inserts sobre la tabla pacientes) para marcar una diferenciación en los datos almacenados en el Backup Full 1 y el Backup Log 1\. Asimismo, se realiza una consulta para comprobar la cantidad de registros de la tabla Pacientes (20 registros tras el insert mencionado).   
<p align="center">
  <img src="https://github.com/TomasVillarreal/Proyecto_Grupo-19/blob/main/Script/Backup_en_linea_y_Restore/img_aplicacion_practica_backup/lote%201%20de%20datos.png" alt="Lote 1 de datos insertado a la tabla Paciente"/>
</p> 

Se realiza el primer Backup Log (Log1) haciendo hincapié en registrar su hora de finalización para posteriormente utilizarla como marca temporal en la Recuperación en un Punto de Tiempo.
<p align="center">
  <img src="https://github.com/TomasVillarreal/Proyecto_Grupo-19/blob/main/Script/Backup_en_linea_y_Restore/img_aplicacion_practica_backup/log1-primer%20insert.png" alt="Primer Backup de log 1"/>
</p> 


Análogamente a la inserción del Lote 1 de datos, se realiza el insert del Lote 2, estableciendo una pausa de un minuto entre cada registro para lograr marcas de tiempo significativas en el transact-log   
<p align="center">
  <img src="https://github.com/TomasVillarreal/Proyecto_Grupo-19/blob/main/Script/Backup_en_linea_y_Restore/img_aplicacion_practica_backup/lote%202%20de%20datos.png" alt="Lote 2 de datos insertado a la tabla Paciente"/>
</p> 
Finalmente, se realiza el Backup del Log 2, el cual contiene los registros de ambos Lotes de Datos  
<p align="center">
  <img src="https://github.com/TomasVillarreal/Proyecto_Grupo-19/blob/main/Script/Backup_en_linea_y_Restore/img_aplicacion_practica_backup/log2-ambos%20inserts.png" alt="Segundo Backup de Log 2"/>
</p> 

# Resultados del Bloque 2: 

Posteriormente al borrado completo de la base de datos mediante la sentencia DROP DATABASE Clinicks\_BD\_I, se restaura el Backup Full 1 y el Log 1  
<p align="center">
  <img src="https://github.com/TomasVillarreal/Proyecto_Grupo-19/blob/main/Script/Backup_en_linea_y_Restore/img_aplicacion_practica_backup/recovery%20backup%201.png" alt="Recovery Backup Full 1"/>
</p> 

<p align="center">
  <img src="https://github.com/TomasVillarreal/Proyecto_Grupo-19/blob/main/Script/Backup_en_linea_y_Restore/img_aplicacion_practica_backup/recovery%20log1.png" alt="Recovery del Backup log1"/>
</p>  

En esta oportunidad, la restauración del Log 1 no fue suficiente para sacar a la Base de Datos de su estado Recovery, lo cual implicó que no se pudo acceder automáticamente a los archivos contenidos en ambos backups implementados, ya que nunca se pasó a la fase de UNDO. Por ello, y para “desatascar” manualmente a la base de datos se utilizó el comando RESTORE DATABASE \[Clinicks\_BD\_I\] WITH RECOVERY;  

Al ejecutar dicho comando, si fue posible realizar las verificaciones planificadas, las cuales demostraron que la estructura de la tabla Pacientes junto con sus 20 primeros registros fueron almacenados y restaurados satisfactoriamente. 
<p align="center">
  <img src="https://github.com/TomasVillarreal/Proyecto_Grupo-19/blob/main/Script/Backup_en_linea_y_Restore/img_aplicacion_practica_backup/verificacion%20recovery%201%20(backup%2Blog1).png" alt="Verificación Recovery escenario 1"/>
</p>  

# Resultados del Bloque 3: 

En la puesta en práctica del escenario 2, no fue necesaria la implementación del comando RESTORE DATABASE \[Clinicks\_BD\_I\] WITH RECOVERY, puesto que al realizar el restore de la cadena de logs completa no había transacciones activas por las cuales la base de datos deba permanecer en estado de espera. 
<p align="center">
  <img src="https://github.com/TomasVillarreal/Proyecto_Grupo-19/blob/main/Script/Backup_en_linea_y_Restore/img_aplicacion_practica_backup/verificacion%20tarea%209.png" alt="Recovery Escenario 3"/>
</p> 

De esta manera, se obtuvo la restauración total de la base de datos completa (estructura “raíz” y los 30 registros de la tabla de referencia).
<p align="center">
  <img src="https://github.com/TomasVillarreal/Proyecto_Grupo-19/blob/main/Script/Backup_en_linea_y_Restore/img_aplicacion_practica_backup/verificacion%20tarea%209.png" alt="Recovery Escenario 3"/>
</p> 

# Conclusiones: 

Mediante esta puesta en práctica de dos estrategias de recuperación complementarias y muy comúnmente utilizadas en modelos con aplicación real  (Recuperación Completa de la Cadena de Logs y Restauración hasta un Punto de Tiempo determinado) no puede concluirse que determinada estrategia sea superior que otra al haberse comparado bajo un mismo escenario de desastre/pérdida y un volumen pequeño de datos, sino que se infiere que brindan soluciones a planificaciones e intereses puntuales (valorizar más el RPO o el RTO). Con la Restauración a un Punto en el Tiempo el objetivo está en recuperar el estado de la base de datos antes del desastre; si bien se dispone de la característica de obtener una mayor precisión al detenerse la restauración (STOPAT) en un instante específico, pudiendo descartar así las operaciones que hayan podido desencadenar la pérdida de datos, esto  también supone  una mayor complejidad al tener que rastrear dicha marca temporal dentro de bases de datos de grandes volúmenes, volviéndose aún mayor el desafío al tener que determinar qué volumen de datos debe/puede perderse si  los backups de Log no son realizados periódicamente y acompañados de las verificaciones y documentación pertinentes. 

En el caso de la Recuperación Completa de la Cadena, el foco está en preservar el mayor volumen de datos posible al contar con la aptitud de restaurar hasta el último backup de Log disponible previo al desastre, lo cual lo vuelve una estrategia muy robusta si se busca resguardar los datos ante posibles fallas de hardware. 

Debido a la naturaleza del modelo empleado para esta experimentación práctica, donde la carga de datos está a cargo de personal administrativo no especializado en el manejo de Bases de Datos y transacciones sql, puede deducirse que un plan de recuperación ante desastres imprevistos más eficiente es la Recuperación Completa de la Cadena de Log.

