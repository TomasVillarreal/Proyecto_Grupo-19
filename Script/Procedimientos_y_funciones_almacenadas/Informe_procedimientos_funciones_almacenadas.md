<h1>Procedimientos y funciones almacenadas</h1>

<h2>Procedimientos almacenados</h2>

Un procedimiento almacenado (Store Procedure) es un conjunto de sentencias en lenguaje Transact SQL (extensión de SQL que permite utilizar SQL para realizar tareas complejas como saltos, bucles, etc) que pueden almacenarse en el propio servidor.
Dichos procedimientos permiten parámetros de entrada y devuelven diversos parámetros de salida a los cuales el programa puede llamar. También contienen instrucciones que permiten la realización de operaciones en la base de datos permitiendo a su vez llamar a otros procedimientos.

Entre los beneficios que tiene la utilización de procedimientos almacenados se destacan:[1]

- Tráfico de red reducido entre el servidor y cliente: debido a que el procedimiento se ejecuta como un único lote de código, a través de la red solo se envía la llamada para ejecutar dicho procedimiento.
- Mayor seguridad: el procedimiento controla los procesos y actividades que se realizan y permisos que se otorgan, protegiendo los objetos subyacentes de la base de datos. Además cuando una aplicación invoca a un procedimiento a través de la red, solo es visible la llamada para ejecutarlo, dejando oculto los nombres de los objetos, tablas y datos de la base de datos.
- Reutilización de código: la encapsulación en procedimientos de operaciones repetitivas evita la reescritura innecesaria de código reduciendo a su vez, posibles inconsistencias.
- Mantenimiento más sencillo: ante cualquier cambio que se desee realizar, basta con modificar los procedimientos en lugar de la base de datos subyacente o la capa de datos, la cual permanece independiente y aislada de cambios en los diseños, relaciones o procesos de la base de datos.
- Rendimiento mejorado: por defecto, un procedimiento se compila por primera vez, se ejecuta y se crea un plan de ejecución, el cual se reutiliza en ejecuciones posteriores, por lo que, para nuevas ejecuciones, no se debe crear un nuevo plan por lo que el procesamiento del procedimiento suele tardar menos tiempo.

Por otro lado los beneficios de las funciones almacenadas son:

- Reutilización de lógica: permiten encapsular cálculos o transformaciones repetitivas, evitando duplicar código en consultas o procedimientos.
- Mayor legibilidad: simplifican consultas complejas al reemplazar expresiones largas por una llamada a función.
- Determinismo y consistencia: garantizan que, dado un mismo conjunto de parámetros, siempre devuelvan el mismo resultado, reduciendo errores en consultas.
- Modularidad: permiten dividir operaciones lógicas en partes más claras y manejables, facilitando el mantenimiento y la organización del código SQL.

---

<h2>Tipos de procedimientos almacenados</h2>

<h3>Procedimientos temporarios o temporales</h3>

Son un tipo de procedimientos definidos por el usuario y se caracterizan por ser procedimientos permanentes excepto que se almacenen en la base de datos temporal tempdb, la cual es un recurso global que contiene los objetos de usuario que se crean explícitamente (tablas, variables grandes, etc), objetos internos que crea el motor de base de datos, entre otros.[2]

Se subclasifican en procedimientos temporales locales y globales. Los primeros tienen un signo ’#’ como primer carácter en sus nombres y solo son visibles para la conexión del usuario actual, siendo eliminados al cerrar dicha sesión.
Por su parte, los procedimientos temporales globales tienen dos signos ‘##’ como los primeros caracteres de sus nombres y son visibles para cualquier usuario tras su creación y se eliminan al final de la última sesión que utilizó el procedimiento.

<h3>Procedimientos del sistema</h3>

Se incluyen en el motor de la base de datos y se almacenan físicamente en la resourcedb interna oculta y aparecen lógicamente en el sysschema de cada base de datos, tanto definida por el sistema como por el usuario.

<h3>Procedimientos definidos por el usuario extendido</h3>

Los procedimientos extendidos permiten crear rutinas externas en un lenguaje de programación. Estos procedimientos son DLL que una instancia de SQL Server puede cargar y ejecutar dinámicamente.

<h3>Triggers o disparadores</h3>

Son un tipo de procedimiento en SQL que se ejecuta cuando se cumple una determinada condición al momento de realizar una operación.
Los triggers, dependiendo de la base de datos pueden ser de inserción, actualización o de borrado.
Son principalmente usados para mejorar la administración de la base de datos sin necesidad de que el usuario ejecute la sentencia SQL aunque también sus usos se extienden para generar valores de columnas, prevenir errores de datos, sincronizar tablas, modificar valores  de una vista, etc.

Existen dos tipos de disparadores que se clasifican según la cantidad de ejecuciones a realizar:

- Row Triggers (o Disparadores de fila): son aquellas que se ejecutarán tantas veces como se llamen desde la tabla asociada al trigger.
- Statement Triggers (o Disparadores de secuencia): son aquellos que sin importar la cantidad de  veces que se cumpla con la condición, su ejecución es única.

Los triggers son lo mismo que los Stored Procedures pero éstos se ejecutan desatendidamente y automáticamente cuando un usuario realiza una acción con la tabla  de una base de datos que lleve asociado este trigger.[4]

---

<h2>Principales diferencias entre procedimientos y funciones almacenadas</h2>

Una función almacenada es un conjunto de instrucciones SQL que se almacena asociado a una base de datos. Es un objeto que se crea con la sentencia CREATE FUNCTION y se invoca con la sentencia SELECT o dentro de una expresión.
Una función puede tener cero o muchos parámetros de entrada y siempre devuelve un valor, asociado al nombre de la función.

Las funciones se clasifican en:

- Funciones escalares (devuelven un solo valor, como el ejemplo presentado).
- Funciones con valores de tabla (TVF):
  - Inline: devuelven directamente un SELECT.
  - Multisentencia: permiten declarar tablas internas.

Un procedimiento almacenado es mucho más flexible para escribir cualquier código que uno desee, mientras que las funciones tienen una estructura y funcionalidad rígidas, por ejemplo una de las formas para llamar a un procedimiento almacenado es mediante el uso de la palabra reservada “execute” o su abreviación “exec”, aunque también se puede invocarlo sin dicha instrucción y hasta sin especificar el nombre del esquema al que pertenece. Por su parte, las funciones son menos flexibles siendo necesaria la especificación del esquema al que pertenece y aunque pueda ser tedioso, es considerado una buena práctica para evitar conflictos con otros objetos que puedan tener el mismo nombre pero pertenecer a otro esquema. Por ejemplo: dbo (Database Owner), el cual es el esquema predeterminado que se crea en cada base de datos de SQL Server.)[3]

También podemos ver una diferencia y ventaja a favor de los procedimientos almacenados, puesto que los mismos pueden obtener varios parámetros mientras que, en las funciones, solo se puede devolver una variable o una tabla.

En una función escalar, puede devolver sólo una variable y en un procedimiento almacenado múltiples variables. Sin embargo, para llamar a las variables de salida en un procedimiento almacenado, es necesario el declarar variables fuera del procedimiento para poder invocarlo.

Además, no puede invocar procedimientos dentro de una función. Pero, por otro lado, en un procedimiento se puede invocar funciones y procedimientos almacenados.

---

<h2>Estructura de los procedimientos</h2>

Los procedimientos se crean anteponiendo las palabras claves “CREATE PROCEDURE” y luego indicando el parámetro de salida. Dicho parámetro se define en la siguiente línea, ubicando el carácter “@” antes de definir el nombre del mismo, para luego seguir con el tipo de dato y su longitud (en caso de que se desee especificar).
Para ejecutar el procedimiento se hace uso de la palabra reservada “EXEC”.
Como buena práctica se recomienda hacer uso de “BEGIN/END”, los cuales delimitan bloques de instrucciones, permitiendo mayor legibilidad y siendo fundamentales si se usan estructuras de control como “IF/ELSE/WHILE/TRY-CATCH”.

Ejemplo básico de como convertir la temperatura de grados celsius a fahrenheit utilizando un procedimiento:

```SQL
CREATE PROCEDURE celsiusAFahrenheit
@celsius REAL
AS 
BEGIN
SELECT @celsius*1.8+32 AS Fahrenheit;
END;

EXEC celsiusAFahrenheit 20;  -- Para su ejecución.
```
<img src="./Script/Procedimientos_y_funciones_almacenadas/img/Procedimiento%20conversor%20de%20grados%20celsius%20a%20fahrenheit.png" alt="Procedimiento" />

---

<h2>Estructura de las funciones</h2>

Para crear una función primero, se hace uso de las palabras reservadas “CREATE FUNCTION”, similar a los procedimientos y luego se especifica el esquema a utilizar, por defecto, se puede usar “dbo.[nombre_de_nuestra_funcion]”.

El paso siguiente es definir los parámetros que utilizará nuestra función, junto con su tipo de dato y su tamaño. Luego, el tipo de dato que se busca que devuelva nuestra función y con la palabra reservada “BEGIN” podremos crear un espacio para definir variables locales de nuestra función, así como también la lógica que pretendemos que maneje nuestra función.
Para ver el resultado de nuestra función usamos un SELECT.

```SQL
CREATE FUNCTION dbo.f_celsiusAFahrenheit(@celsius REAL)
RETURNS REAL
AS
BEGIN
    RETURN @celsius*1.8+32
END;

SELECT dbo.f_celsiusAFahrenheit(19) AS Fahrenheit;  -- Para su ejecución
```

<img src="./Script/Procedimientos_y_funciones_almacenadas/img/Funciones%20conversor%20de%20grados%20celsius%20a%20fahrenheit.png" alt="Funcion" />


---
<h2>Conclusión</h2>

Tanto las funciones como los procedimientos en SQL son de suma ayuda de acuerdo al escenario que se plantee. Los procedimientos almacenados son más fáciles de crear en cuanto a su sintaxis y tamaño de código mientras que las funciones tienen una estructura más rígida y admiten menos cláusulas y funcionalidades pero su manipulación de resultados es más sencilla que la de los procedimientos.
Ambas son herramientas de las cuales se puede sacar un gran provecho siempre que se tenga el conocimiento adecuado para su manipulación.

---

<h2>Bibliografía:</h2>

[1] https://learn.microsoft.com/en-us/sql/relational-databases/stored-procedures/stored-procedures-database-engine?view=sql-server-ver17

[2] https://learn.microsoft.com/es-es/sql/relational-databases/databases/tempdb-database?view=sql-server-ver17

[3] https://www.sqlshack.com/es/funciones-frente-a-los-procedimientos-almacenados-en-sql-server/

[4] https://www.academia.edu/31208981/TRIGGERS_Y_PROCEDIMIENTO_ALMACENADO?utm
