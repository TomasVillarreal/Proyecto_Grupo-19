**Tema investigación: Manejo de Transacciones y Transacciones Anidadas**

**1. Introducción**

El manejo de transacciones en SQL Server constituye un mecanismo esencial para preservar la integridad, coherencia y confiabilidad de los datos.\
Una transacción es una secuencia de una o más operaciones en una unidad lógica de trabajo, donde todas las instrucciones deben completarse con éxito. En caso de fallo, SQL Server debe revertir la totalidad de los cambios aplicados antes del punto inicial de la transacción. Garantizando que se cumplan todas o ninguna de las operaciones.

El presente informe analiza el uso de transacciones y transacciones anidadas. Además, se describe cómo se aplican los principios **ACID** en cada etapa, así como el funcionamiento del control de errores y la gestión de bloques TRY…CATCH.

SIntaxis:
``` sql
BEGIN TRY
BEGIN TRANSACTION
-- Operaciones SQL
COMMIT TRANSACTION
END TRY
BEGIN CATCH
IF @@TRANCOUNT > 0
ROLLBACK TRANSACTION
PRINT 'Error: ' + ERROR\_MESSAGE ()
END CATCH
```
**2. Conceptos Generales de Transacciones**

Una transacción en SQL Server se inicia mediante la instrucción:
``` sql
BEGIN TRANSACTION
```
y finaliza con:
``` sql
COMMIT TRANSACTION
```
o, en caso de error:
``` sql
ROLLBACK TRANSACTION
```
Durante su ejecución, SQL Server mantiene bloqueos sobre los recursos afectados para asegurar la correcta serialización y evitar inconsistencias.


**2.1 Contador interno @@TRANCOUNT**

- Cada BEGIN TRANSACTION incrementa el contador.
- Cada COMMIT lo decrementa.
- Un ROLLBACK lo devuelve directamente a 0.

**3. Modelo ACID** 

El modelo ACID está compuesto por:\
**Atomicidad, Consistencia, Aislamiento y Durabilidad.**

**3.1 Atomicidad**

La atomicidad garantiza que todas las operaciones dentro de la transacción se ejecuten completamente o se reviertan por completo. Si cualquier instrucción falla (por ejemplo, violación de PK o UNIQUE), todas las inserciones se revierten, preservando la atomicidad.

**3.2 Consistencia**

La consistencia asegura que la base de datos pase de un estado válido a otro estado igualmente válido antes y después de la transacción.\
Se garantiza mediante:

- Restricciones PK y FK
- Reglas UNIQUE
- Declaración de tipos de datos
- Inserciones dependientes entre tablas

**3.3 Aislamiento**

El aislamiento controla cómo y cuándo las transacciones pueden ver los cambios realizadas por otras transacciones concurrentes, de esta manera las transacciones no interfieren entre sí.
``` sql
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
``` 
**3.4 Durabilidad**

Una vez ejecutado:
``` sql
COMMIT TRANSACTION
```
SQL Server garantiza que los cambios se registrarán en el log y quedarán almacenados permanentemente, aun en caso de fallo del servidor.

**4. Manejo de Errores con TRY…CATCH**

En SQL Server se utiliza el mecanismo estructurado más robusto para la gestión de errores dentro de transacciones. Su función es aislar la lógica principal dentro del bloque TRY, mientras que los errores que se produzcan en ese segmento son capturados automáticamente por el bloque CATCH. Este mecanismo es superior a la verificación manual con @@ERROR, ya que centraliza el manejo del error y simplifica la lógica, lo que reduce la probabilidad de fallas en la gestión transaccional.

Sintaxis:
``` sql
BEGIN TRY

    BEGIN TRANSACTION

-- Operaciones SQL

COMMIT TRANSACTION;

END TRY
BEGIN CATCH

    IF @@TRANCOUNT > 0

       ROLLBACK TRANSACTION;

    PRINT 'Error: ' + ERROR\_MESSAGE();

END CATCH
```
**4.1 Tipos de errores comunes**

- **PK o UNIQUE duplicada** Código: **2627.**
- **Violación de clave foránea**: Código: **547.**
- **CHECK** Datos fuera de rango.
- **THROW** Errores manuales para pruebas.

**5. Transacciones Anidadas**

En los sistemas de gestión de bases de datos, una *transacción anidada* se entiende como una transacción que se ejecuta dentro del contexto de otra transacción. En términos teóricos, cada transacción interna debería tener la capacidad de confirmarse o revertirse de manera independiente. Sin embargo, SQL Server no implementa transacciones anidadas reales, ya que no permite que una transacción interna tenga autonomía frente a la transacción externa.

En SQL Server, ejecutar múltiples BEGIN TRANSACTION no crea niveles independientes de transacciones, sino que únicamente incrementa el contador interno @@TRANCOUNT. Por este motivo, SQL Server utiliza un mecanismo alternativo denominado SAVEPOINT, el cual permite simular el comportamiento esperado de una transacción anidada mediante rollback* parcial.

Sintaxis:
``` sql
BEGIN TRANSACTION 

-- Operaciones iniciales

SAVE TRANSACTION PuntoControl; -- SAVEPOINT

-- Operaciones que pueden fallar

IF (condición)
ROLLBACK TRANSACTION PuntoControl  -- Revierte solo hasta el savepoint
ELSE
    COMMIT TRANSACTION -- Confirma toda la transacción
``` 
**6. Fragmentos que Representan Cada Concepto**

|**Concepto**|**Fragmento del Código**|**Significado**|
| :- | :- | :- |
|Atomicidad|BEGIN TRAN … COMMIT/ROLLBACK|Todas las inserciones se ejecutan como una unidad|
|Consistencia|FK + SCOPE\_IDENTITY ()|Preserva integridad entre tablas|
|Aislamiento|Nivel predeterminado READ COMMITTED|Evita lecturas sucias|
|Durabilidad|COMMIT TRANSACTION|Garantiza persistencia en el log|
|Control de errores|TRY CATCH|Mecanismo formal para revertir|
|Transacciones anidadas|SAVEPOINT|SQL Server incrementa @@TRANCOUNT|

**7. Recomendación de uso**

**7.1 Usar transacciones cuando:**

- Se afecta más de una tabla.
- El proceso debe ser confiable.
- Hay relaciones dependientes.
- Se manejan datos críticos.

**7.2 No usar transacciones cuando:**

- Son solo SELECT.
- Procesos analíticos.
- Cargas masivas sin necesidad de ACID.




**8. Implementación interna de transacciones en SQL Server**

SQL Server implementa transacciones de manera automática e interna para garantizar el cumplimiento del modelo ACID, incluso cuando el usuario no declara explícitamente un BEGIN TRANSACTION. Cada instrucción que modifica datos como ser:

INSERT, UPDATE, DELETE o MERGE.

Se ejecuta dentro de una transacción implícita generada por el motor.

Este mecanismo se sustenta en el modelo Write-Ahead Logging (WAL), mediante el cual todos los cambios se registran primero en el log de transacciones antes de ser aplicados a las páginas de datos, asegurando la durabilidad y recuperabilidad del sistema. Paralelamente, el motor administra bloqueos (locks) mediante el Lock Manager, controlando el nivel de aislamiento y evitando conflictos entre transacciones concurrentes. SQL Server también gestiona estructuras internas de undo y redo para revertir cambios o restaurarlos tras fallos inesperados. Finalmente, el motor mantiene un contador interno (@@TRANCOUNT), responsable de coordinar la apertura y cierre de transacciones implícitas y explícitas. 

Gracias a estos mecanismos coordinados, SQL Server garantiza atomicidad, consistencia, aislamiento y durabilidad en toda operación que altere datos, independientemente de si el programador define o no transacciones manualmente antes de modificar cualquier dato en disco:

**9. Conclusión**

Se puede concluir que los mecanismos de transacciones y transacciones anidadas son componentes esenciales para garantizar la integridad y consistencia en sistemas basados en bases de datos relacionales. Las transacciones proporcionan un manejo confiable bajo el principio de” todo o nada”, asegurando que un conjunto de operaciones solo se confirme si todas pueden ejecutarse con éxito, evitando así estados parciales o inconsistentes.

Por otro lado, las transacciones anidadas implementadas mediante savepoints permiten establecer puntos de control intermedios dentro de una transacción mayor. Esto brinda la flexibilidad de revertir únicamente una parte del proceso sin perder el resto del trabajo realizado, facilitando el manejo de datos opcionales o etapas que requieren una lógica específica.

**10. Fuentes**

\- Microsoft Learn: <https://learn.microsoft.com/es-es/sql/t-sql/language-elements/begin-transaction-transact-sql?view=sql-server-ver16>\
` `- Video: La magia de las transacciones: <https://youtu.be/keL9-EtE-zE?si=ivUUfk5irjl7k_2e>












