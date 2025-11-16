USE Clinicks_BD_I;

-- Creacion del indice clustered sobre unicamente fecha registro
CREATE CLUSTERED INDEX IX_Registro_Indexado_Clustered_Fecha_Paciente
ON Registro_Indexado_Clustered_Sin_Include (fecha_registro);

/*Creacion del indice clustered sobre fecha_registro, id_paciente, id_usuario.
Como tal al leer la consigna que pedia que se incluyan un conjunto de columnas, pensaba 
en hacer una consulta asi:

CREATE CLUSTERED INDEX IX_Registro_Indexado_Clustered_Fecha_Paciente_Include
ON Registro_Indexado_Clustered (fecha_registro)
INCLUDE (id_paciente, id_usuario);

Pero esto resulta en un error debido a que los indices clustered no admite
la sentencia include, tal que eso funciona con los indices non-clustered (y mejora
muchisimo el rendimiento de las consultas para esos casos).
Por lo tanto se concluyo que lo que la consigna pedia es esto:
*/
CREATE CLUSTERED INDEX IX_Registro_Indexado_Clustered_Fecha_Paciente_Include
ON Registro_Indexado_Clustered (fecha_registro, id_paciente, id_usuario);




