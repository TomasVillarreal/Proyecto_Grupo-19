**Conclusión de los resultados del experimento de las transacciones y transacciones anidadas**

**Introducción**

En esta sección se presentan los resultados obtenidos tras ejecutar diversos experimentos orientados a evaluar el comportamiento de las transacciones en SQL Server, junto con el manejo de errores, la eliminación en cascada y el uso de transacciones anidadas mediante SAVEPOINT.\
El objetivo es verificar la correcta aplicación de los principios ACID en situaciones reales: inserciones completas, inserciones fallidas, rollback total, rollback parcial, y eliminación con ON DELETE CASCADE.\
Cada experimento se acompañó de la consulta de verificación para confirmar en qué estado quedaron los datos.

**Experimento 1**

**Inserción completa y validación de restricciones (DNI = 47123456)**

**Descripción**

Se inserta un nuevo paciente junto con ficha médica, primer registro clínico y medicación.\
Luego, se vuelve a intentar insertar el mismo paciente para forzar un error por violación de UNIQUE (dni\_paciente).\
Se evalúa el correcto funcionamiento del bloque TRY/CATCH y de la atomicidad transaccional.

**Resultado obtenido**

- Primera inserción: múltiples tablas cargadas correctamente dentro de una única transacción.

  ![Imagen que contiene Interfaz de usuario gráfica&#x0A;&#x0A;El contenido generado por IA puede ser incorrecto.](Aspose.Words.52393418-7012-49e9-9193-6aa10b3a4a36.001.png)

  ![Interfaz de usuario gráfica, Texto

El contenido generado por IA puede ser incorrecto.]

  ![ref1]

- Segunda inserción: error capturado correctamente, la transacción se revierte por completo y no se crean datos duplicados.

  ![](Aspose.Words.52393418-7012-49e9-9193-6aa10b3a4a36.004.png)

**Conclusión del experimento**

Este experimento confirma que la atomicidad se cumple: o se insertan todas las tablas o no se inserta ninguna.\
Además, se evidencia que TRY/CATCH gestiona adecuadamente las excepciones y evita estados inconsistentes.

**Experimento 2**

**Eliminación en cascada con ROLLBACK forzado (DNI = 47123456)**

**Descripción**

Se elimina al paciente previamente insertado.\
Dado que se agregaron restricciones ON DELETE CASCADE, también deberían eliminarse automáticamente su ficha médica, registros y medicación asociada.\
Luego se lanza un error intencional mediante THROW para provocar un ROLLBACK completo.

**Resultado obtenido**

- Caso 1: El delete se ejecuta con exito.

  ![](Aspose.Words.52393418-7012-49e9-9193-6aa10b3a4a36.005.png)

- Caso 2: No existe el paciente.

  ![](Aspose.Words.52393418-7012-49e9-9193-6aa10b3a4a36.006.png)

- Caso 3: El DELETE se ejecuta, pero al generarse el error forzado (THROW 50000) se ejecuta un ROLLBACK total. Todo vuelve a su estado previo: el paciente continúa existiendo, con sus registros y medicación.

  ![Imagen que contiene Interfaz de usuario gráfica&#x0A;&#x0A;El contenido generado por IA puede ser incorrecto.](Aspose.Words.52393418-7012-49e9-9193-6aa10b3a4a36.007.png)

  ![Interfaz de usuario gráfica, Texto

El contenido generado por IA puede ser incorrecto.]

  ![ref1]

**Conclusión** **del experimento**

Este experimento demuestra que la durabilidad queda subordinada al COMMIT.\
Si una transacción que contenía una eliminación en cascada no llega a confirmarse, SQL Server revierte todo, preservando completamente la consistencia.


**Experimento 3** 

**Inserción con medicación opcional (Caso exitoso, DNI = 40000002)**

**Descripción**

Se realiza la inserción completa de un paciente con todos sus datos, y se agrega un SAVEPOINT antes del bloque opcional de medicación.

**Resultado obtenido**

- El paciente, su ficha y su registro son insertados correctamente.
- La medicación también se inserta sin errores.
- Toda la transacción es confirmada con éxito.

  ![Texto&#x0A;&#x0A;El contenido generado por IA puede ser incorrecto.](Aspose.Words.52393418-7012-49e9-9193-6aa10b3a4a36.008.png)

  ![](Aspose.Words.52393418-7012-49e9-9193-6aa10b3a4a36.009.png)

  ![](Aspose.Words.52393418-7012-49e9-9193-6aa10b3a4a36.010.png)

- Error al ingresar paciente que ya existe en la base de datos.

  ![Texto&#x0A;&#x0A;El contenido generado por IA puede ser incorrecto.](Aspose.Words.52393418-7012-49e9-9193-6aa10b3a4a36.011.png)

**Conclusión del experimento**

Se verifica que una transacción con SAVEPOINT se comporta igual que una transacción común cuando todas las operaciones tienen éxito, SQL Server incrementa @@TRANCOUNT, ejecuta las instrucciones y realiza COMMIT global sin necesidad de rollback parcial.




**Experimento 4**

**Rollback parcial: falla en medicación (DNI = 40000003)**

**Descripción**

Se inserta un paciente con su ficha médica y registro clínico, pero al intentar insertar la medicación se genera a propósito una violación de FK.

Esto activa el SAVEPOINT y permite hacer un rollback parcial solo del paciente, ficha médica y registro, sin afectar las inserciones principales.

**Resultado obtenido**

- Paciente, ficha y registro: insertados correctamente
- Medicación: revertida
- COMMIT final exitoso para la parte válida de la transacción

  ![Texto&#x0A;&#x0A;El contenido generado por IA puede ser incorrecto.](Aspose.Words.52393418-7012-49e9-9193-6aa10b3a4a36.012.png)

  ![](Aspose.Words.52393418-7012-49e9-9193-6aa10b3a4a36.013.png)

  ![](Aspose.Words.52393418-7012-49e9-9193-6aa10b3a4a36.014.png)

- Si se desea agregar paciente con mismo DNI devuelve error.

  ![Texto&#x0A;&#x0A;El contenido generado por IA puede ser incorrecto.](Aspose.Words.52393418-7012-49e9-9193-6aa10b3a4a36.015.png)

**Conclusión del experimento**

Este caso confirma que los SAVEPOINT permiten simular transacciones anidadas, haciendo posible revertir solo una parte de la transacción.\
Demuestra que SQL Server mantiene la atomicidad “por segmentos” si así se define en la lógica del desarrollador.


**Conclusión General de los Experimentos**

Los resultados obtenidos confirman que SQL Server implementa correctamente los principios ACID cuando se utilizan transacciones y control de errores de manera adecuada:

- **Atomicidad:** Los experimentos muestran que las inserciones múltiples se realizan como una unidad indivisible.
- **Consistencia:** Las FK, PK y reglas UNIQUE garantizan estados válidos incluso cuando se producen errores.
- **Aislamiento:** El nivel READ COMMITTED evita lecturas inadecuadas en todos los experimentos.
- **Durabilidad:** Los cambios solo se vuelven definitivos cuando se ejecuta COMMIT el rollback forzado lo demuestra claramente.

Los SAVEPOINT permiten manejar errores en secciones específicas (por ejemplo, medicación opcional), lo cual proporciona una mayor robustez que las transacciones tradicionales.

En conjunto, los experimentos confirman que el diseño transaccional implementado es **robusto, integro y seguro**.










[Interfaz de usuario gráfica, Texto

El contenido generado por IA puede ser incorrecto.]: Aspose.Words.52393418-7012-49e9-9193-6aa10b3a4a36.002.png
[ref1]: Aspose.Words.52393418-7012-49e9-9193-6aa10b3a4a36.003.png
