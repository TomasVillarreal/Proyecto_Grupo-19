use Clinicks_BD_I;

-- Activo las estadisticas para poder ver las diferencias entre las consultas:
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

-- Conjunto de pruebas entre la tabla sin indice, y la tabla con un indice clustered simple

-- Ejemplo de consulta:
SELECT * FROM Registro
WHERE fecha_registro BETWEEN '20100101' AND '20150101';

SELECT * FROM Registro_Indexado_Clustered_Sin_Include
WHERE fecha_registro BETWEEN '20100101' AND '20150101';

-- Conjunto de pruebas entre la tabla con indice clustered simple, y con indice clustered con mas columnas

-- Ejemplo de consulta:
SELECT * FROM Registro_Indexado_Clustered_Sin_Include
WHERE fecha_registro BETWEEN '20100101' AND '20150101';

SELECT * FROM Registro_Indexado_Clustered
WHERE fecha_registro BETWEEN '20100101' AND '20150101';


-- Desactivacion de las estadisticas:
SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;



