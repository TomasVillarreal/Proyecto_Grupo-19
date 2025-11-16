
<h1 align="center">Conclusiones sobre la experimentación sobre:</h1>
<h2 align="center">Optimización de consultas a través de índices</h2>

## Preámbulo:
Para realizar este experimento sobre la optimización, se creó una tabla distinta, pero de igual estructura que la tabla Registro que originalmente fue planteada para el sistema. Estas dos tablas se diferencian de la tabla originalmente planteada en su clave primaria, esto debido a que la clave primaria original era una compuesta por 2 columnas (id_registro, id_paciente), pero con el fin de poder llevar a cabo este experimento, se decidió que la clave primaria sea una simple y que este compuesta únicamente sobre id_registro. Además, los datos contenidos en las dos tablas son exactamente los mismos entre sí, así que no hay diferencias en los datos contenidos por las distintas tablas.

Si bien es verdad que las dos tablas son esencialmente iguales (a excepción del nombre de la tabla en sí, y de los nombres de las restricciones), la tabla de Registro_Indexado_Clustered (la cual va a ser usada para poder realizar el conjunto de pruebas con un índice clustered) tiene la característica única entre las dos  de que su clave primaria es una non-clustered, es decir, que si bien va a identificar a cada una de sus filas de forma única, la forma en la que se ordenan esos datos en el disco al guardarse no va a ser mediante esta clave. Esto se realizó debido a que si hacíamos una PK como normalmente lo haríamos, se ordenarían los datos según esta clave y no podríamos crear un índice clustered sobre esa tabla, pues solo puede haber una por tabla.

También para poder ver bien las diferencias en tiempos, y otro conjunto de datos importantes al poder comparar eficiencias entre consultas, se decidió activar:
```sql
SET STATISTICS IO ON;
SET STATISTICS TIME ON;
```
Se pueden ver estas tablas y sus estructuras <a href="https://github.com/TomasVillarreal/Proyecto_Grupo-19/tree/Optimizacion-Indices/Script/Optimizacion_Indices/scripts_usados/creacion_tabla_indexada.sql">acá</a>.

## Introducción:
El tema de investigación sobre el cual se realizaron los experimentos aquí propuestos es el de optimización de consultas mediante índices, el cual establece una mejora en eficiencia y tiempo de ejecución entre consultas a través del uso de índices. 

El uso de índices logra que el motor de base de datos evite la necesidad de tener que estar buscando fila por fila (recorriendo toda una tabla entera) para buscar coincidencias sobre la condición establecida en la consulta. Podemos imaginar el mecanismo realizado por el motor de base de datos como si estuviésemos leyendo un libro académico, tal que si deseamos leer cierto capitulo específicamente, buscaríamos en el índice cual es la página en la cual dicho capitulo empieza.

En estos experimentos, se utilizarán únicamente índices agrupados (clustered) simples (es decir, sin incluir columnas extra), e índices agrupados con columnas extra incluidas, para ver las diferencias en tiempos, diferencias en el número de páginas de la caché que el motor tuvo que realizar para completar la consulta, planes de ejecución y demás, con respecto a la tabla sin índices. Además, todos los índices se crearán sobre el campo “fecha_registro”, para poder ejecutar búsquedas en periodos de tiempo.
 
## Consulta de una tabla sin índice vs de una tabla con índice clustered simple (sin incluir otras columnas):
Para estas pruebas se realizó este índice, sobre la columna “fecha_registro” de la tabla Registro_Indexado_Clustered:
```sql
CREATE CLUSTERED INDEX IX_Registro_Indexado_Clustered_Fecha_Paciente
ON Registro_Indexado_Clustered (fecha_registro); 
```
Ahora, para poder hacer las pruebas se realizó exactamente la misma consulta para ambas tablas, Registro (sin índice) y Registro_Indexado_Clustered (con el índice puesto arriba)
```sql
SELECT * FROM Registro
WHERE fecha_registro BETWEEN '20100101' AND '20150101';

SELECT * FROM Registro_Indexado_Clustered
WHERE fecha_registro BETWEEN '20100101' AND '20150101'; 
```
Ambas consultas devuelven la misma cantidad de filas (109.263 filas), en la misma cantidad de tiempo (00:00:00), sin embargo, al ver el plan de ejecución vemos lo siguiente:
- Para la primera consulta:
<p align="center">
  <img src="https://raw.githubusercontent.com/TomasVillarreal/Proyecto_Grupo-19/Optimizacion-Indices/Script/Optimizacion_Indices/imgs/prueba1_plan_sinindices.png" alt="Plan sin indices" width="160"/>
</p>
   
- Para la segunda consulta:
<p align="center">
  <img src="https://raw.githubusercontent.com/TomasVillarreal/Proyecto_Grupo-19/Optimizacion-Indices/Script/Optimizacion_Indices/imgs/prueba1_plan_conindice.png" alt="Plan de ejecucion para la consulta sobre la tabla con indices" width="160"/>
</p>
   
Como podemos observar, el motor consideró que hay una MUY significativa diferencia entre los costos de ambas consultas, tal que el motor observó que la primera consulta (la consulta sobre la tabla no indexada) es mucho más pesada que la consulta sobre la tabla con el índice en “fecha_registro”.

La diferencia tan radical cae en el tipo de búsqueda que realiza la primera consulta, tal que como la tabla sobre la cual se hace no tiene índice, el motor se ve obligado a leer todas las filas de la tabla para poder buscar donde la columna “fecha_registro” coincide con el periodo establecido en la consulta (Clustered Index Scan). Como la consulta es muy pesada, el motor busca optimizar la consulta a través de la creación de múltiples hilos de ejecución tal que estos leerán todas las filas de la tabla (Parallelism).

Por el contrario, la segunda consulta se realiza sobre la tabla que si posee un índice agrupado sobre la columna que se está filtrando en el where. A pesar del nombre similar, este tipo de estrategia de búsqueda realizado por el motor (Busqueda en índice cluster / Clustered index seek) es una donde el motor de búsqueda aprovecha que la tabla tiene ese índice clustered sobre “fecha_registro”, tal que ahora la tabla y sus filas están físicamente ordenadas según “fecha_registro”. Gracias a esto, el motor puede ir básicamente descendiendo a través del árbol para detectar en cuales páginas se encuentran las filas que cumplen con la condición es establecida en la consulta, evitando así la necesidad de que el motor lea toda la tabla en búsqueda de estas filas.

Esto se puede ver claramente al ejecutar ambas consultas con el STATISTICS IO/TIME ON, tal que al realizarlo se ve esto:
<p align="center">
  <img src="https://raw.githubusercontent.com/TomasVillarreal/Proyecto_Grupo-19/Optimizacion-Indices/Script/Optimizacion_Indices/imgs/prueba1_tiempos.png" alt="Estadisticas y tiempos de la prueba con indice vs sin indice" width="160"/>
</p>  

Como se puede ver ahí mas claramente, hay una gran diferencia entre ambas. Las mayores diferencias ocurren en:
- CPU time (tiempo que la CPU tardo procesando la consulta): 360 ms vs 78 ms.
- Elapsed time (tiempo de duración de la consulta, desde que inició hasta que termino): 821 ms vs 929 ms.
- Scan count (cantidad de veces que el operador SCAN se ejecutó sobre la tabla o índice (puede ser por paralelismo)): 13 vs 1.
- Logical reads (número de páginas del buffer leídas para obtener los datos de la consulta): 12730 vs 1446
- Physical reads (número de paginas que se tuvo que traer del disco porque no se encontraban en la caché): 0 vs 0.

En casi todos estos datos, vemos que una abrumadora diferencia en la eficiencia de las consultas, tal que la consulta sobre la tabla con el índice agrupado en “fecha_registro” es claramente superior. La única instancia donde ambas consultas son equivalentes es en el numero de paginas físicas que se tuvieron que leer del disco, cuando estas paginas no estuvieron en la caché, y la única instancia donde la primera consulta fue superior a la segunda es en el tiempo total de ejecución de ambas consultas.

## Consulta de una tabla con índice clustered simple (sin incluir otras columnas) vs de una tabla con índice clustered incluyendo las columnas de id_usuario e id_paciente:
Para estas pruebas se realizó este índice, sobre la columna “fecha_registro”, “id_paciente” e “id_usuario” de la tabla Registro_Indexado_Clustered_Sin_Include:
```sql
CREATE CLUSTERED INDEX IX_Registro_Indexado_Clustered_Fecha_Paciente_Include
ON Registro_Indexado_Clustered_Sin_Include (fecha_registro, id_paciente, id_usuario);
```
Ahora, para poder hacer las pruebas se realizó exactamente la misma consulta para ambas tablas, Registro_Indexado_Clustered_Sin_Include y Registro_Indexado_Clustered (con el índice puesto arriba)
```sql
SELECT id_paciente, id_usuario FROM Registro_Indexado_Clustered_Sin_Include
WHERE fecha_registro BETWEEN '20100101' AND '20150101';

SELECT id_paciente, id_usuario FROM Registro_Indexado_Clustered
WHERE fecha_registro BETWEEN '20100101' AND '20150101';
```

Ambas consultas siguen devolviendo las mismas filas que en las pruebas anteriores (109.263), y en la misma cantidad de tiempo (00:00:00), y al ver el plan de ejecución vemos una pecurialidad:
- Para la primera consulta:
<p align="center">
  <img src="https://raw.githubusercontent.com/TomasVillarreal/Proyecto_Grupo-19/Optimizacion-Indices/Script/Optimizacion_Indices/imgs/prueba2_plan_sininclude.png" alt="Plan de ejecucion para la consulta sobre la tabla con indice clustered sin columnas de mas" width="160"/>
</p>
   
- Para la segunda consulta:
<p align="center">
  <img src="https://raw.githubusercontent.com/TomasVillarreal/Proyecto_Grupo-19/Optimizacion-Indices/Script/Optimizacion_Indices/imgs/prueba2_plan_coninclude.png" alt="Plan de ejecucion para la consulta sobre la tabla con indice clustered con columnas de mas" width="160"/>
</p>
 
Ambas consultas son esencialmente iguales entre sí. Esto queda aun mas en evidencia al ver los tiempos registrados al realizar la consulta:

 <p align="center">
  <img src="https://raw.githubusercontent.com/TomasVillarreal/Proyecto_Grupo-19/Optimizacion-Indices/Script/Optimizacion_Indices/imgs/prueba2_tiempos.png" alt="Estadisticas y tiempos de la prueba con con indice clustered con include vs sin include width="160"/>
</p>
 
Como se pueden observar, tanto los tiempos como las demás estadísticas son esencialmente iguales y hay mínimas diferencias entre sí.

## Conclusiones:

A través de este conjunto de experimentos de comparación de las mismas consultas para tablas con distintos índices (sin índice, con índice agrupado simple, con índice agrupado con columnas extra) se vio que el uso de índices para consultas sobre tablas con una cantidad masiva de filas resulta indispensable si la eficiencia es lo que se busca, en contraposición de hacer consultas sobre una tabla sin índice. Sin embargo, contrario a lo que se esperaba, en las pruebas no se vio diferencia alguna entre el hacer uso de un índice agrupado sobre una única columna (“fecha_registro” en este caso) y el hacer uso de un índice agrupado sobre múltiples columnas (“fecha_registro”, “id_paciente”, “id_registro”, en este caso), pues todas las estadisticas tuvieron diferencias mínimas entre sí. 


 


