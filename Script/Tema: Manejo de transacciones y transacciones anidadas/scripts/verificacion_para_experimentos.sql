use Clinicks_BD_I
--Verificacion
SELECT 
--Informacion del Paciente
P.id_paciente,
P.nombre_paciente + ' ' + P.apellido_paciente AS Nombre_Completo,
P.dni_paciente,    
--Informacion de la Ficha Medica
FM.tipo_sanguineo,
FM.estatura,
FM.peso,  
--Informacion del Registro
R.id_registro,
R.fecha_registro,
TR.nombre_registro AS Tipo_Procedimiento,
R.observaciones,   
--Informacion de la Medicacin
M.nombre_medicacion,
M.dosis_medicacion
FROM  Paciente as P
    INNER JOIN Ficha_medica as FM 
    ON P.id_paciente = FM.id_paciente
    INNER JOIN Registro as R 
    ON P.id_paciente = R.id_paciente
    INNER JOIN Tipo_registro as TR 
    ON R.id_tipo_registro = TR.id_tipo_registro
    LEFT JOIN Registro_medicacion as RM
    ON R.id_registro = RM.id_registro AND R.id_paciente = RM.id_paciente
    LEFT JOIN Medicacion as M 
    ON RM.id_medicacion = M.id_medicacion

WHERE P.dni_paciente = --47123456 --40000002 --40000003 
