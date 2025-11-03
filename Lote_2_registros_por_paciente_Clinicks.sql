
USE Clinicks_BD_I;

INSERT INTO Registro (
    fecha_registro, observaciones, id_tipo_registro,
    id_rol_procedimiento, id_especialidad_procedimiento,
    id_rol_usuario, id_usuario, id_especialidad_usuario, id_paciente
) VALUES
--PACIENTE 1 
('2025-11-04', 'Monitoreo de ritmo cardíaco 24h. Leves arritmias detectadas.', 30, 1, 6, 1, 1, 6, 1), -- Medico 1 (Cardiologia)
('2025-11-05', 'Control de medicación. Paciente refiere sentirse bien con dosis actual.', 12, 2, 3, 2, 8, 3, 1), -- Enfermero 8 (Enf. Geriatrica)

--PACIENTE 2 
('2025-11-04', 'Evaluación de crecimiento y desarrollo. Talla en percentil 50.', 3, 2, 1, 2, 6, 1, 2), -- Enfermero 6 (Enf. Pediatrica)
('2025-11-05', 'Consulta de seguimiento neurológico. Se descarta migraña.', 35, 1, 7, 1, 2, 7, 2), -- Medico 2 (Neurologia)

--PACIENTE 3
('2025-11-04', 'Rehabilitación post-cirugía. Se realizan ejercicios de movilidad.', 44, 1, 9, 1, 4, 9, 3), -- Medico 4 (Traumatologia)
('2025-11-05', 'Evaluación de recuperación anestésica tras procedimiento menor.', 10, 2, 2, 2, 7, 2, 3), -- Enfermero 7 (Enf. Quirurgica)

--PACIENTE 4 
('2025-11-04', 'Control de tratamiento dermatológico tópico. Lesión mejorando.', 47, 1, 10, 1, 5, 10, 4), -- Médico 5 (Dermatología)
('2025-11-05', 'Evaluación del estado nutricional. Dieta balanceada recomendada.', 13, 2, 3, 2, 8, 3, 4), -- Enfermero 8 (Enf. Geriátrica)

--PACIENTE 5 
('2025-11-04', 'Informe de traslado a cuidados intensivos (observación).', 20, 2, 4, 2, 9, 4, 5), -- Enfermero 9 (Enf. Emergencias)
('2025-11-05', 'Diagnóstico de infección respiratoria alta. Tratamiento oral.', 38, 1, 8, 1, 3, 8, 5), -- Médico 3 (Pediatria)

--PACIENTE 6 
('2025-11-04', 'Registro de medicación pediátrica (analgésicos).', 2, 2, 1, 2, 6, 1, 6), -- Enfermero 6 (Enf. Pediátrica)
('2025-11-05', 'Consulta de seguimiento posquirúrgico (Traumatología).', 45, 1, 9, 1, 4, 9, 6), -- Médico 4 (Traumatología)

--PACIENTE 7
('2025-11-04', 'Preparación preoperatoria. Vía periférica instalada.', 6, 2, 2, 2, 7, 2, 7), -- Enfermero 7 (Enf. Quirurgica)
('2025-11-05', 'Consulta de seguimiento por gastroenteritis.', 36, 1, 8, 1, 3, 8, 7), -- Medico 3 (Pediatra)

--PACIENTE 8 
('2025-11-04', 'Registro de conducta agresiva. Intervención exitosa.', 22, 2, 5, 2, 10, 5, 8), -- Enfermero 10 (Enf. Salud Mental)
('2025-11-05', 'Prueba de esfuerzo realizada. Resultados satisfactorios.', 28, 1, 6, 1, 1, 6, 8), -- Medico 1 (Cardiologia)

--PACIENTE 9
('2025-11-04', 'Atención inicial de trauma leve en miembro inferior.', 16, 2, 4, 2, 9, 4, 9), -- Enfermero 9 (Enf. Emergencias)
('2025-11-05', 'Aplicación de crema medicada en zona afectada.', 48, 1, 10, 1, 5, 10, 9), -- Médico 5 (Dermatología)

--PACIENTE 10 
('2025-11-04', 'Informe de evolución psicológica. Mejora notable en ánimo.', 25, 2, 5, 2, 10, 5, 10), -- Enfermero 10 (Enf. Salud Mental)
('2025-11-05', 'Registro de fiebre. Se toman medidas de control térmico.', 40, 1, 8, 1, 3, 8, 10); -- Medico 3 (Pediatria)
GO






--Consulta de todos los Registros 


SELECT
    -- Informacion del Paciente
    P.nombre_paciente + ' ' + P.apellido_paciente AS [Paciente],
    -- Informacion del Registro Clinico
    R.fecha_registro AS [Fecha Consulta],
    TR.nombre_registro AS [Tipo de Procedimiento],
    R.observaciones AS [Observaciones del Profesional],
    -- Informacion de la Medicacion
    CASE
        WHEN M.nombre_medicacion IS NOT NULL
        THEN CONCAT(M.nombre_medicacion, ' (', M.dosis_medicacion, ' mg)')
        ELSE ''
    END AS [Medicacion Prescrita],
    -- Informacion del Profesional que atend
    U.nombre_usuario + ' ' + U.apellido_usuario AS [Profesional Atendió],
    RL_U.nombre_rol AS [Rol Profesional],
    E_U.nombre_especialidad AS [Especialidad del Profesional]
FROM
    Registro R
JOIN
    Paciente P ON R.id_paciente = P.id_paciente
JOIN
    Tipo_registro TR ON R.id_tipo_registro = TR.id_tipo_registro
LEFT JOIN
    Registro_medicacion RM ON R.id_registro = RM.id_registro AND R.id_paciente = RM.id_paciente
LEFT JOIN
    Medicacion M ON RM.id_medicacion = M.id_medicacion
JOIN
    Usuario U ON R.id_usuario = U.id_usuario
JOIN
    Rol RL_U ON R.id_rol_usuario = RL_U.id_rol
JOIN
    Especialidad E_U ON R.id_especialidad_usuario = E_U.id_especialidad
ORDER BY
    P.id_paciente ASC,
    R.fecha_registro ASC;
GO