Tema investigación: Manejo de Transacciones y Transacciones Anidadas

Secuencia de operaciones (INSERT, UPDATE, DELETE, etc.) que se consideran como una unidad lógica de trabajo: todas deben completarse correctamente para que los cambios permanezcan, o si ocurre un error se debe revertir (rollback) todo lo hecho en esa unidad.

En muchos motores de base de datos se pueden abrir transacciones dentro de otras. Pero en SQL Server no funciona como “verdaderas” transacciones anidadas independientes. 

BEGIN TRANSACTION cuando se está dentro de una transacción, lo que realmente sucede es que @@TRANCOUNT se incrementa. Pero no se crea una transacción separada totalmente aislada.
Un COMMIT TRANSACTION simplemente decrementa @@TRANCOUNT en 1 (siempre que @@TRANCOUNT > 1).
ROLLBACK TRANSACTION, revierte toda la transacción (la que está activa en ese momento) no solamente el “nivel interno”.Aunque se realice BEGIN TRAN, un ROLLBACK sin especificar un marcador deja @@TRANCOUNT a 0 y revierte todo. 
No se modifica el nivel de aislamiento dentro de una “sub-transacción” en un nuevo contexto completamente distinto.


STX FORMA 1:
BEGIN TRAN
	--CONSULTA--
		IF(@@ERROR >0)
		GO TO Error1
	ROLLBACK TRAN
	--CONSULTA--
COMMIT TRAN

Error1:
if(@@ERROR <> 0)
BEGIN
ROLLBACK TRAN
‘Se produjo error 1, la solución se ejecuta a continuación’
TRAN

STX FORMA 2:
BEGIN TRAN
--CONSULTA--
    IF(@@ERROR >0)
    GO TO Error1
    ROLLBACK TRAN
--CONSULTA--
COMMIT TRAN

END TRY
BEGIN CATCH
ROLLBACK
‘Se produjo error 1, la solución se ejecuta a continuación’
END CATCH

[Fuente: microsft learm ] (https://learn.microsoft.com/es-es/sql/t-sql/language-elements/begin-transaction-transact-sql?view=sql-server-ver16)
[Fuente: (video) La magia de las transacciones] (https://youtu.be/keL9-EtE-zE?si=ivUUfk5irjl7k_2e)

--------Continuar investigando--------
Distinto de Stop procedure


