------------------------------------------------------------------ COMIENZO CARGA DATOS ------------------------------------------------------------------ 

use Clinicks_BD_I;

INSERT INTO Rol (nombre_rol) VALUES ('Medico'), ('Enfermero'), ('Adminstrativo');

INSERT INTO Especialidad (nombre_especialidad)
VALUES
-- Especialidades para enfermeros
('Enfermeria Pediatrica'),
('Enfermeria Quirurgica'),
('Enfermeria Geriatrica'),
('Enfermeria en Emergencias'),
('Enfermeria en Salud Mental'),

-- Especialidades para médicos
('Cardiologia'),
('Neurologia'),
('Pediatria'),
('Traumatologia'),
('Dermatologia');

INSERT INTO Rol_especialidad (id_rol, id_especialidad)
VALUES
-- Enfermeros (Rol = 2)
(2, 1), -- Enfermeria Pediatrica
(2, 2), -- Enfermeria Quirurgica
(2, 3), -- Enfermeria Geriatrica
(2, 4), -- Enfermeria en Emergencias
(2, 5), -- Enfermeria en Salud Mental

-- Medicos (Rol = 1)
(1, 6), -- Cardiologia
(1, 7), -- Neurologia
(1, 8), -- Pediatria
(1, 9), -- Traumatologia
(1, 10); -- Dermatologia

INSERT INTO Tipo_registro (nombre_registro)
VALUES
-- Enfermeria Pediatrica
('Control de signos vitales en ninos'),
('Registro de medicacion pediatrica'),
('Evaluacion de crecimiento y desarrollo'),
('Atencion de heridas leves'),
('Educacion sanitaria a padres'),

-- Enfermeria Quirurgica
('Preparacion preoperatoria del paciente'),
('Control postoperatorio inmediato'),
('Registro de material esterilizado'),
('Monitoreo intraoperatorio'),
('Evaluacion de recuperacion anestesica'),

-- Enfermeria Geriatrica
('Control de presion arterial en adultos mayores'),
('Administracion de medicacion geriatrica'),
('Evaluacion del estado nutricional'),
('Registro de caidas'),
('Seguimiento de ulceras por presion'),

-- Enfermeria en Emergencias
('Atencion inicial de trauma'),
('Control de via aerea'),
('Registro de reanimacion cardiopulmonar'),
('Evaluacion primaria del paciente'),
('Informe de traslado a cuidados intensivos'),

-- Enfermeria en Salud Mental
('Valoracion del estado emocional'),
('Registro de conducta agresiva'),
('Control de tratamiento psiquiatrico'),
('Acompanamiento terapeutico'),
('Informe de evolucion psicologica'),

-- Cardiologia
('Electrocardiograma'),
('Control de presion arterial'),
('Prueba de esfuerzo'),
('Consulta cardiologica inicial'),
('Monitoreo de ritmo cardiaco'),

-- Neurologia
('Evaluacion neurologica basal'),
('Registro de reflejos motores'),
('Control de crisis convulsivas'),
('Informe de tomografia cerebral'),
('Consulta de seguimiento neurologico'),

-- Pediatria
('Consulta pediatrica general'),
('Control de vacunacion infantil'),
('Diagnostico de infeccion respiratoria'),
('Evaluacion nutricional infantil'),
('Registro de fiebre en ninos'),

-- Traumatologia
('Evaluacion de fractura'),
('Control de inmovilizacion'),
('Registro de cirugia ortopedica'),
('Rehabilitacion traumatologica'),
('Consulta de seguimiento posquirurgico'),

-- Dermatologia
('Evaluacion de lesion cutanea'),
('Control de tratamiento dermatologico'),
('Aplicacion de crema medicada'),
('Registro de biopsia de piel'),
('Consulta dermatologica general');

INSERT INTO Registro_especialidad (id_tipo_registro, id_rol, id_especialidad)
VALUES
-- Enfermeria Pediatrica (id_especialidad = 1, rol = 2)
(1, 2, 1),
(2, 2, 1),
(3, 2, 1),
(4, 2, 1),
(5, 2, 1),

-- Enfermeria Quirurgica (id_especialidad = 2, rol = 2)
(6, 2, 2),
(7, 2, 2),
(8, 2, 2),
(9, 2, 2),
(10, 2, 2),

-- Enfermeria Geriatrica (id_especialidad = 3, rol = 2)
(11, 2, 3),
(12, 2, 3),
(13, 2, 3),
(14, 2, 3),
(15, 2, 3),

-- Enfermeria en Emergencias (id_especialidad = 4, rol = 2)
(16, 2, 4),
(17, 2, 4),
(18, 2, 4),
(19, 2, 4),
(20, 2, 4),

-- Enfermeria en Salud Mental (id_especialidad = 5, rol = 2)
(21, 2, 5),
(22, 2, 5),
(23, 2, 5),
(24, 2, 5),
(25, 2, 5),

-- Cardiologia (id_especialidad = 6, rol = 1)
(26, 1, 6),
(27, 1, 6),
(28, 1, 6),
(29, 1, 6),
(30, 1, 6),

-- Neurologia (id_especialidad = 7, rol = 1)
(31, 1, 7),
(32, 1, 7),
(33, 1, 7),
(34, 1, 7),
(35, 1, 7),

-- Pediatria (id_especialidad = 8, rol = 1)
(36, 1, 8),
(37, 1, 8),
(38, 1, 8),
(39, 1, 8),
(40, 1, 8),

-- Traumatologia (id_especialidad = 9, rol = 1)
(41, 1, 9),
(42, 1, 9),
(43, 1, 9),
(44, 1, 9),
(45, 1, 9),

-- Dermatologia (id_especialidad = 10, rol = 1)
(46, 1, 10),
(47, 1, 10),
(48, 1, 10),
(49, 1, 10),
(50, 1, 10);



--MEDICACION (10 unidades)
INSERT INTO Medicacion (nombre_medicacion, dosis_medicacion) VALUES
('Amoxicilina', 500),  -- id_medicacion = 1
('Ibuprofeno', 600),   -- id_medicacion = 2
('Omeprazol', 20),     -- id_medicacion = 3
('Paracetamol', 750),  -- id_medicacion = 4
('Losartán', 50),      -- id_medicacion = 5
('Aspirina', 100),     -- id_medicacion = 6
('Sertralina', 50),    -- id_medicacion = 7
('Furosemida', 40),    -- id_medicacion = 8
('Metformina', 850),   -- id_medicacion = 9
('Diazepam', 10);      -- id_medicacion = 10
GO

--USUARIO (10 unidades - 5 Medicos, 5 Enfermeros)
INSERT INTO Usuario (nombre_usuario, apellido_usuario, email_usuario, password, dni_usuario) VALUES
-- Médicos (Esp. 6 a 10)
('Adriana', 'Gomez', 'a.gomez@clinic.com', 'pass1', 20111222),  -- id_usuario = 1
('Braulio', 'Flores', 'b.flores@clinic.com', 'pass2', 21333444), -- id_usuario = 2
('Carla', 'Rojas', 'c.rojas@clinic.com', 'pass3', 22555666),   -- id_usuario = 3
('Daniel', 'Sosa', 'd.sosa@clinic.com', 'pass4', 23777888),   -- id_usuario = 4
('Elena', 'Vera', 'e.vera@clinic.com', 'pass5', 24999000),    -- id_usuario = 5
-- Enfermeros (Esp. 1 a 5)
('Fabian', 'Luna', 'f.luna@clinic.com', 'pass6', 25121314),   -- id_usuario = 6
('Gloria', 'Mendez', 'g.mendez@clinic.com', 'pass7', 26454647), -- id_usuario = 7
('Hugo', 'Nuñez', 'h.nunez@clinic.com', 'pass8', 27787980),    -- id_usuario = 8
('Irma', 'Ortiz', 'i.ortiz@clinic.com', 'pass9', 28010203),    -- id_usuario = 9
('Javier', 'Paz', 'j.paz@clinic.com', 'pass10', 29343536);    -- id_usuario = 10
GO

--USUARIO_ROL (ID_ROL = 1 para Medico, 2 para Enfermeros)
INSERT INTO Usuario_Rol (id_rol, id_usuario)
SELECT 1, id_usuario FROM Usuario WHERE id_usuario BETWEEN 1 AND 5; -- Medicos (ID=1)
INSERT INTO Usuario_Rol (id_rol, id_usuario)
SELECT 2, id_usuario FROM Usuario WHERE id_usuario BETWEEN 6 AND 10; -- Enfermeros (ID=2)
GO

--USUARIO_ROL_ESPECIALIDAD
INSERT INTO Usuario_rol_especialidad (id_rol, id_usuario, id_especialidad) VALUES
-- Medicos (Rol=1, Especialidades 6 a 10)
(1, 1, 6), (1, 2, 7), (1, 3, 8), (1, 4, 9), (1, 5, 10),
-- Enfermeros (Rol=2, Especialidades 1 a 5)
(2, 6, 1), (2, 7, 2), (2, 8, 3), (2, 9, 4), (2, 10, 5);
GO

--PACIENTE (10 unidades)
INSERT INTO Paciente (nombre_paciente, apellido_paciente, dni_paciente, telefono_paciente) VALUES
('Pedro', 'Acosta', 30101202, 1123456789),  -- id_paciente = 1
('Laura', 'Blanco', 31303404, 1134567890),  -- id_paciente = 2
('Martin', 'Castro', 32505606, 1145678901), -- id_paciente = 3
('Sofia', 'Diaz', 33707808, 1156789012),    -- id_paciente = 4
('Ricardo', 'Esposito', 34909091, 1167890123), -- id_paciente = 5
('Valentina', 'Fernandez', 35111213, 1178901234), -- id_paciente = 6
('Gaston', 'Gimenez', 36313435, 1189012345),  -- id_paciente = 7
('Julieta', 'Herrera', 37515657, 1190123456),  -- id_paciente = 8
('Andres', 'Ibarra', 38717879, 1101234567),    -- id_paciente = 9
('Paula', 'Jara', 39919092, 1112345678);      -- id_paciente = 10
GO

-- FICHA_MEDICA (10 unidades)
INSERT INTO Ficha_medica (id_paciente, tipo_sanguineo, estatura, peso) VALUES
(1, 'O+', 175, 78.5),
(2, 'A-', 162, 55.2),
(3, 'B+', 180, 90.1),
(4, 'AB+', 168, 63.8),
(5, 'O-', 170, 75.0),
(6, 'A+', 155, 50.9),
(7, 'B-', 185, 95.7),
(8, 'AB-', 172, 69.4),
(9, 'O+', 178, 82.3),
(10, 'A-', 160, 58.6);
GO

--REGISTRO (10 unidades - Usando ID_ROL Fijos 1 y 2)
INSERT INTO Registro (
    observaciones, id_tipo_registro,
    id_rol_procedimiento, id_especialidad_procedimiento,
    id_rol_usuario, id_usuario, id_especialidad_usuario, id_paciente
) VALUES
('Control de presion arterial. Se mantiene medicacion.', 27, 1, 6, 1, 1, 6, 1),
('Control de signos vitales post-operatorio. Estable.', 1, 2, 1, 2, 6, 1, 2),
('Consulta de seguimiento neurologico. Sin cambios significativos.', 35, 1, 7, 1, 2, 7, 3),
('Curacion de herida simple. Se retiran puntos en 5 días.', 7, 2, 2, 2, 7, 2, 4),
('Diagnostico de infección respiratoria. Se receta antibiótico.', 38, 1, 8, 1, 3, 8, 5),
('Control de PA en adulto mayor. Se administra diuretico.', 11, 2, 3, 2, 8, 3, 6),
('Control de inmovilizacion por fractura. Evolucion favorable.', 42, 1, 9, 1, 4, 9, 7),
('Atención inicial de trauma leve en extremidad.', 16, 2, 4, 2, 9, 4, 8),
('Control de tratamiento dermatológico tópico. Buena respuesta.', 47, 1, 10, 1, 5, 10, 9),
('Control de tratamiento psiquiatrico. Se evalua estado de animo.', 23, 2, 5, 2, 10, 5, 10);
GO

--REGISTRO_MEDICACION 
INSERT INTO Registro_medicacion (id_medicacion, id_registro, id_paciente) VALUES
(5, 1, 1),  -- Registro 1 (Paciente 1) -> Losartan (ID=5)
(1, 5, 5),  -- Registro 5 (Paciente 5) -> Amoxicilina (ID=1)
(8, 6, 6),  -- Registro 6 (Paciente 6) -> Furosemida (ID=8)
(7, 10, 10); -- Registro 10 (Paciente 10) -> Sertralina (ID=7)
GO
------------------------------------------------------------------ FIN CARGA DATOS ------------------------------------------------------------------ 
------------------------------------------------------------------ COMIENZO 2 REGISTROS POR PACIENTE ------------------------------------------------------------------ 
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
------------------------------------------------------------------ FIN 2 REGISTROS POR PACIENTE ------------------------------------------------------------------ 