
<h1 align="center">Tema de investigación</h3>
<h2 align="center">Optimización de consultas a través de índices</h4>

## Introducción:
Cuando se trabaja con bases de datos relacionales, puede ocurrir que nuestras consultas para el acceso a los datos tengan un bajo rendimiento, provocando así que ocurran tiempos de respuesta mayores a los esperados o incluso errores por timeout.

Una de las razones por la cual puede ocurrir este bajo rendimiento en nuestras consultas es debido a la falta de índices, o el uso inadecuado de estos, [1]. 

La optimización de las consultas mediante índices es una de las formas más sencillas y efectivas de mejorar los tiempos de respuesta. Debido a esto, es conveniente saber el que son los índices, para que sirven, cuales son los distintos tipos de índices y en qué momentos usar cual.

## ¿Qué son los índices en las bases de datos relacionales?
Un índice es una asignación clave-valor para una o varias columnas de una tabla para indicar a la base de datos qué filas contienen qué valores sin tener que escanear cada fila, [2]. De este modo, se termina creando una nueva estructura de búsqueda de datos que está directamente relacionada con esa tabla y el conjunto de columnas.

Esta estructura permite a la base de datos evitar el escaneo de toda la tabla, ya que el motor de la base de datos puede utilizar el índice para identificar directamente qué filas contienen los valores buscados, [2].

Una forma común de entenderlo es como el índice de una guía telefónica. Si intentara encontrar a alguien con el apellido "Pérez" en una guía telefónica, iría directamente al índice a buscar el apellido, luego procedería a buscar aquellos cuyo apellido que comienzan con “P”, luego simplemente empezaría a buscar desde el número de página indicado en el índice, [2].

## ¿Cómo crear los índices para una tabla?
Si bien hay diferencias en sintaxis acerca del comando específico para la creación de un índice, así como de los parámetros que estos comandos conllevan, entre distintos sistemas gestores de bases de datos, [3], la estructura general del comando para su creación es la siguiente:
```sql
CREATE INDEX nombre_índice
ON nombre_tabla (nombre_columna_1, nombre_columna_2, …)
```
Ahora, supongamos que tenemos la siguiente tabla de clientes en nuestra base de datos:
```sql
CREATE TABLE Customer (
    ID              INT             PRIMARY KEY,
    FirstName       VARCHAR(50),
    LastName        VARCHAR(50),
    Gender          INT,
    DOB             DATE,
    Email           VARCHAR(100),
    MainPhone       VARCHAR(18),
    LastOrderDate   DATETIME2(2)
);
```
 
Supongamos ahora que deseamos crear un índice respecto del nombre y apellido del cliente para poder acelerar el proceso de búsqueda. Eso se haría de la siguiente forma:
```sql
CREATE INDEX IX_CustomerName
ON Customer (FirstName, LastName)
```

Ahora, una vez ejecutado dicho código tendremos un nuevo índice para la tabla Customer denominado IX_Customer_Name, el cual nos ayudara para consultas como esta, donde se busca a un cliente mediante su nombre y apellido: 
```sql
SELECT FirstName, LastName, Email
FROM Customer
WHERE Nombre = 'Marcos' and LastName = 'Diaz'
```

Para consultas como la de arriba no es necesario mencionar específicamente al índice, sino que el propio motor de la base de datos usara el índice de forma implícita, evitando así la necesidad de estar buscando fila por fila, [3].


## Tipos de índice en SQL:
Hay muchos tipos de índices diferentes, cada uno con su propia estructura de datos y su propia función.
### 1)	Índice B-Tree:
En esencia, este tipo de índice organiza los datos en una estructura jerárquica similar a un árbol invertido, tal que esta consta de una raíz, ramas y hojas, donde cada uno de los registros de datos se almacenan en los nodos hoja. 

De esta forma, cada nodo del árbol puede contener múltiples claves y punteros: las claves actúan como marcadores, mientras que los punteros permiten navegar rápidamente hacia la rama correspondiente- 

Para consultas que buscan valores específicos, este tipo de estructura permite una metodología de búsqueda binaria, donde cada recorrido de nodo reduce el espacio de búsqueda a la mitad, lo que reduce significativamente los tiempos de búsqueda.

Además, estos también son excelentes para gestionar consultas de rango, que buscan registros dentro de un rango específico de valores, permitiendo localizar rápidamente el punto de inicio del rango y luego recorrer secuencialmente los nodos hoja para obtener todos los registros relevantes, [4].

### 2)	Índice Hash:
Este tipo de índice surge como una herramienta especializada diseñada para operaciones de recuperación de datos de alta velocidad, especialmente cuando el objetivo es encontrar coincidencias exactas. Esta técnica de indexación emplea una función hash, un algoritmo matemático que transforma los valores de los datos en un espacio de direcciones único, asignando eficazmente cada dato a una ubicación específica en la memoria. 

Cuando se inserta un valor de datos en la base de datos, la función hash calcula un valor hash (un índice numérico) basado en dicho valor. Este valor hash determina la ubicación de almacenamiento exacta donde se almacenarán los datos. Por consiguiente, cuando se realiza una consulta para buscar estos datos, se aplica la misma función hash al valor de la consulta para dirigir rápidamente la búsqueda a la ubicación de almacenamiento adecuada, evitando así la necesidad de un escaneo secuencial del conjunto de datos.

Este tipo de índice es una excelente opción para comparaciones de igualdad. Dado que la función hash calcula directamente la ubicación de almacenamiento de un valor de datos, las operaciones de recuperación suelen realizarse en tiempo constante. Sin embargo, no son adecuados para consultas de rango ni para operaciones que requieren datos ordenados, debido a la naturaleza de las funciones hash, que distribuyen los valores de los datos en el espacio de direcciones de una manera que no guarda relación con el orden real de dichos valores, [4].

### 3)	Índice Compuesto:
Un índice compuesto combina varias columnas de una tabla en una única estructura, creando una ruta de búsqueda multidimensional. Este sofisticado enfoque de indexación mejora significativamente la eficiencia de las consultas, especialmente al trabajar con condiciones combinadas en varias columnas.

La esencia de un índice compuesto reside en su capacidad para encapsular la relación entre dos o más columnas de una tabla en una estructura de índice unificada. Al crear un índice compuesto, ordena los datos según la primera columna especificada en el índice; luego, dentro de esa clasificación, ordena según la segunda columna, y así sucesivamente. 

Los índices compuestos son especialmente beneficiosos para consultas que involucran operaciones JOIN con criterios de filtrado específicos. Al alinear la estructura del índice con las columnas utilizadas en las condiciones JOIN, el motor de base de datos puede localizar con mayor rapidez las filas relevantes de cada tabla, minimizando así la sobrecarga computacional asociada al proceso de unión.

Una de las ventajas más atractivas de los índices compuestos es su capacidad para facilitar la búsqueda eficiente basada en condiciones que abarcan varias columnas. En escenarios donde las consultas filtran o unen tablas frecuentemente según un conjunto específico de columnas, un índice compuesto puede reducir drásticamente la cantidad de datos que deben analizarse, acelerando así el tiempo de ejecución de las consultas, [4].

### 4)	Índice de cobertura:
Un índice de cobertura es una técnica de indexación avanzada que incluye todas las columnas necesarias para satisfacer una consulta. Esto significa que el motor de base de datos puede obtener todos los datos necesarios del índice sin tener que acceder a las páginas de datos de la tabla. 

Al incluir todas las columnas necesarias para una consulta dentro del propio índice, la base de datos puede omitir el paso, más laborioso, de obtener los registros de la tabla. Esto resulta especialmente beneficioso en situaciones donde las consultas acceden con frecuencia a un subconjunto de columnas de una tabla más grande.

La cobertura de índices puede mejorar significativamente el rendimiento de las consultas que solo involucran las columnas indexadas. El acceso directo a los datos requeridos a través del índice minimiza las operaciones de E/S de disco, acelera la recuperación de datos y reduce la carga general del sistema de base de datos. Esto hace que la cobertura de índices sea especialmente valiosa en entornos de alto volumen de lectura, donde la velocidad de las consultas es crucial, [4].

### 5)	Índice de texto completo:
Los índices de texto completo son un tipo de índice especializado diseñado para satisfacer necesidades de búsqueda de texto en las bases de datos. Los índices de texto completo están diseñados para permitir operaciones de búsqueda exhaustivas sobre datos textuales, lo que permite a los usuarios realizar consultas complejas que van más allá de la simple coincidencia de palabras clave.

Este tipo de índice procesan la totalidad del texto, y para esto dividen al texto en palabras claves, o tokens, e luego se procede a indexarlos para facilitar una recuperación eficiente. A diferencia de los índices estándar, que solo referencian la ubicación de registros completos o campos específicos, los índices de texto completo proporcionan una asignación granular de las ocurrencias de cada palabra dentro de los datos textuales.

Esta estrategia de indexación admite consultas de búsqueda sofisticadas, como búsquedas de frases, de proximidad y condicionales, entre otras. Los usuarios pueden consultar la base de datos buscando frases específicas, palabras próximas o la presencia de ciertas palabras y excluir otras.

La principal ventaja de emplear índices de texto completo reside en su capacidad para mejorar significativamente la experiencia de búsqueda. Permiten que la base de datos filtre rápidamente grandes conjuntos de datos para encontrar información textual relevante, una tarea que resultaría extremadamente lenta si se realizara escaneando cada documento, línea por línea. Es especialmente útil para empresas y aplicaciones que gestionan un gran volumen de contenido textual, [4].

### 6)	Índice único:
Los índices únicos exigen que solo exista un valor único para las columnas indexadas dentro de una tabla.

Un índice único funciona creando una estructura de datos a la que el sistema de gestión de bases de datos (SGBD) puede acceder rápidamente para comprobar la unicidad de un valor dado antes de permitir una operación de inserción o actualización. Cuando se intenta crear una nueva entrada en una columna o conjunto de columnas con un índice único, el SGBD consulta este índice para comprobar que el valor propuesto no exista ya. Si el valor se encuentra dentro del índice, la operación se rechaza, evitando así la duplicación y preservando la integridad de los datos, [4].

### 7)	Índice espacial:
La gestión y consulta eficiente de datos geoespaciales se ha vuelto crucial para una amplia gama de aplicaciones. Desde soluciones cartográficas y servicios basados en la ubicación hasta el análisis espacial en diversas industrias, la capacidad de procesar información geoespacial con rapidez y precisión es clave. Aquí es donde entran en juego los índices espaciales, que proporcionan una estrategia de indexación especializada diseñada específicamente para el almacenamiento, la recuperación y el análisis de datos espaciales.

Los índices espaciales están diseñados para gestionar datos que representan objetos definidos en un espacio geométrico, como puntos, líneas, polígonos y geometrías más complejas. Estos índices optimizan las consultas que involucran relaciones y operaciones espaciales, como determinar la proximidad (la distancia entre dos objetos), la contención (si un objeto abarca a otro) y la intersección (si dos objetos se superponen y cómo).

Los índices espaciales gestionan datos multidimensionales, considerando las coordenadas y formas de los objetos espaciales, [4].

### 8)	Índice de mapa de bits (Bitmap):
Los índices de mapa de bits emplean una estructura única que aprovecha las matrices de bits. 

En esencia, un índice de mapa de bits consta de una serie de bits para cada valor distinto de la columna que indexa. Cada bit de la matriz corresponde a una fila de la tabla; el bit se establece en 1 si la fila contiene el valor y en 0 si no. Esta representación binaria permite que los índices de mapa de bits almacenen cantidades sustanciales de datos de forma altamente comprimida, lo que reduce los requisitos de almacenamiento y mejora el rendimiento de las consultas.

La principal ventaja de los índices de mapa de bits reside en su capacidad para realizar operaciones de filtrado rápidas. Cuando una consulta especifica un valor específico en la columna indexada, la base de datos puede consultar rápidamente la matriz de bits correspondiente, identificando al instante todas las filas que cumplen el criterio. Además, los índices de mapa de bits pueden acelerar significativamente las consultas que combinan múltiples condiciones mediante operaciones lógicas (AND, OR, NOT).

Por ejemplo, considere una tabla de base de datos que almacena información sobre libros, con una columna que indica el género. Un índice de mapa de bits en la columna de género crearía una matriz de bits independiente para cada género. Consultar todos los libros de "Ciencia Ficción" implicaría simplemente acceder a la matriz de bits de "Ciencia Ficción", donde cada bit establecido en 1 representa una fila o un libro perteneciente a ese género, [4].

## Conclusión:
La implementación adecuada de índices en bases de datos relacionales es fundamental para optimizar el rendimiento de las consultas. Cada tipo de índice ofrece ventajas específicas según la naturaleza de los datos y las consultas que se realizan, tal que su correcta elección y aplicación permite reducir los tiempos de respuesta, minimizar el consumo de recursos y garantizar la eficiencia general del sistema de base de datos, lo que resulta esencial en entornos de alto volumen de información.

## Bibliografía:
[1] https://blog.damavis.com/optimizacion-de-indices-en-bases-de-datos-relacionales/.

[2] https://www.jackmarchant.com/how-does-a-relational-database-index-really-work.

[3] https://codigonautas.com/indices-base-datos-relacional/.

[4] https://www.linkedin.com/pulse/common-types-indexes-relational-databases-taras-sahaidachnyi-spljf.





  
