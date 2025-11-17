**Tema investigación: Manejo de Transacciones y Transacciones Anidadas**

**1. Introducción**

El manejo de transacciones en SQL Server constituye un mecanismo esencial para preservar la integridad, coherencia y confiabilidad de los datos.\
Una transacción es una secuencia de una o más operaciones en una unidad lógica de trabajo, donde todas las instrucciones deben completarse con éxito. En caso de fallo, SQL Server debe revertir la totalidad de los cambios aplicados antes del punto inicial de la transacción. Garantizando que se cumplan todas o ninguna de las operaciones.

El presente informe analiza el uso de transacciones y transacciones anidadas. Además, se describe cómo se aplican los principios **ACID** en cada etapa, así como el funcionamiento del control de errores y la gestión de bloques TRY…CATCH.

BEGIN TRANSACTION cuando se está dentro de una transacción, lo que realmente sucede es que @@TRANCOUNT se incrementa. 
@@TRANCOUNT es una variable que se utiliza para mantener el conteo del nivel de anidamiento de transacciones activas dentro de la sesión actual. Se incrementa en 1 cada vez que se ejecuta una instrucción BEGIN TRANSACTION.
COMMIT TRANSACTION simplemente decrementa @@TRANCOUNT en 1 (siempre que @@TRANCOUNT > 1). 
ROLLBACK TRANSACTION, revierte toda la transacción (la que está activa en ese momento) no solamente el “nivel interno”. Aunque se realice BEGIN TRAN, un ROLLBACK sin especificar un marcador deja @@TRANCOUNT a 0 y revierte todo. No se modifica el nivel de aislamiento dentro de una “sub-transacción” en un nuevo contexto completamente distinto.

Sintaxis:

BEGIN TRY

`    `BEGIN TRANSACTION

`    `-- Operaciones SQL

`    `COMMIT TRANSACTION

END TRY

BEGIN CATCH

`    `IF @@TRANCOUNT > 0

`        `ROLLBACK TRANSACTION;

`    `PRINT 'Error: ' + ERROR\_MESSAGE ()

END CATCH

**2. Conceptos Generales de Transacciones**

Una transacción en SQL Server se inicia mediante la instrucción:

BEGIN TRANSACTION

y finaliza con:

COMMIT TRANSACTION

o, en caso de error:

ROLLBACK TRANSACTION

Durante su ejecución, SQL Server mantiene bloqueos sobre los recursos afectados para asegurar la correcta serialización y evitar inconsistencias.


**2.1 Contador interno @@TRANCOUNT**

Cada vez que se ejecuta un BEGIN TRANSACTION, SQL Server incrementa la variable de sistema @@TRANCOUNT en 1.\
Este contador se decrementa con cada COMMIT TRANSACTION.

**3. Modelo ACID y su Aplicación en el Código**

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

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

BEGIN TRANSACTION

**3.4 Durabilidad**

Una vez ejecutado:

COMMIT TRANSACTION

SQL Server garantiza que los cambios se registrarán en el log y quedarán almacenados permanentemente, aun en caso de fallo del servidor.

**4. Manejo de Errores con TRY…CATCH**

En SQL Server se utiliza el mecanismo estructurado más robusto para la gestión de errores dentro de transacciones. Su función es aislar la lógica principal dentro del bloque TRY, mientras que los errores que se produzcan en ese segmento son capturados automáticamente por el bloque CATCH. Este mecanismo es superior a la verificación manual con @@ERROR, ya que centraliza el manejo del error y simplifica la lógica, lo que reduce la probabilidad de fallas en la gestión transaccional.

Sintaxis:

BEGIN TRY

`    `BEGIN TRANSACTION

-- Operaciones SQL

`    `COMMIT TRANSACTION;

END TRY

BEGIN CATCH

`    `IF @@TRANCOUNT > 0

`        `ROLLBACK TRANSACTION;

`    `PRINT 'Error: ' + ERROR\_MESSAGE();

END CATCH

**5. Transacciones Anidadas**

En los sistemas de gestión de bases de datos, una *transacción anidada* se entiende como una transacción que se ejecuta dentro del contexto de otra transacción. En términos teóricos, cada transacción interna debería tener la capacidad de confirmarse o revertirse de manera independiente. Sin embargo, SQL Server no implementa transacciones anidadas reales, ya que no permite que una transacción interna tenga autonomía frente a la transacción externa.

En SQL Server, ejecutar múltiples BEGIN TRANSACTION no crea niveles independientes de transacciones, sino que únicamente incrementa el contador interno @@TRANCOUNT. Por este motivo, SQL Server utiliza un mecanismo alternativo denominado SAVEPOINT, el cual permite simular el comportamiento esperado de una transacción anidada mediante rollback* parcial.

Sintaxis:

BEGIN TRANSACTION 

-- Operaciones iniciales

SAVE TRANSACTION PuntoControl; -- SAVEPOINT

-- Operaciones que pueden fallar

IF (condición)

`    `ROLLBACK TRANSACTION PuntoControl  -- Revierte solo hasta el savepoint

ELSE

`    `COMMIT TRANSACTION -- Confirma toda la transacción

**6. Fragmentos que Representan Cada Concepto**

|**Concepto**|**Fragmento del Código**|**Significado**|
| :- | :- | :- |
|Atomicidad|BEGIN TRAN … COMMIT/ROLLBACK|Todas las inserciones se ejecutan como una unidad|
|Consistencia|FK + SCOPE\_IDENTITY ()|Preserva integridad entre tablas|
|Aislamiento|Nivel predeterminado READ COMMITTED|Evita lecturas sucias|
|Durabilidad|COMMIT TRANSACTION|Garantiza persistencia en el log|
|Control de errores|TRY CATCH|Mecanismo formal para revertir|
|Transacciones anidadas|SAVEPOINT|SQL Server incrementa @@TRANCOUNT|

**7. Conclusión**

Se puede concluir que los mecanismos de transacciones y transacciones anidadas son componentes esenciales para garantizar la integridad y consistencia en sistemas basados en bases de datos relacionales. Las transacciones proporcionan un manejo confiable bajo el principio de” todo o nada”, asegurando que un conjunto de operaciones solo se confirme si todas pueden ejecutarse con éxito, evitando así estados parciales o inconsistentes.

Por otro lado, las transacciones anidadas implementadas mediante savepoints permiten establecer puntos de control intermedios dentro de una transacción mayor. Esto brinda la flexibilidad de revertir únicamente una parte del proceso sin perder el resto del trabajo realizado, facilitando el manejo de datos opcionales o etapas que requieren una lógica específica.

**8. Fuentes**

\- Microsoft Learn: <https://learn.microsoft.com/es-es/sql/t-sql/language-elements/begin-transaction-transact-sql?view=sql-server-ver16>\
` `- Video: La magia de las transacciones: <https://youtu.be/keL9-EtE-zE?si=ivUUfk5irjl7k_2e>











