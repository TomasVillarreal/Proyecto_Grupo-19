USE Clinicks_BD_I;
GO

-- 1. MEDICACION (10 unidades)
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

-- 2. USUARIO (10 unidades - 5 Medicos, 5 Enfermeros)
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

-- 3. USUARIO_ROL (ID_ROL = 1 para Medico, 2 para Enfermeros)
INSERT INTO Usuario_Rol (id_rol, id_usuario)
SELECT 1, id_usuario FROM Usuario WHERE id_usuario BETWEEN 1 AND 5; -- Medicos (ID=1)
INSERT INTO Usuario_Rol (id_rol, id_usuario)
SELECT 2, id_usuario FROM Usuario WHERE id_usuario BETWEEN 6 AND 10; -- Enfermeros (ID=2)
GO

-- 4. USUARIO_ROL_ESPECIALIDAD
INSERT INTO Usuario_rol_especialidad (id_rol, id_usuario, id_especialidad) VALUES
-- Medicos (Rol=1, Especialidades 6 a 10)
(1, 1, 6), (1, 2, 7), (1, 3, 8), (1, 4, 9), (1, 5, 10),
-- Enfermeros (Rol=2, Especialidades 1 a 5)
(2, 6, 1), (2, 7, 2), (2, 8, 3), (2, 9, 4), (2, 10, 5);
GO

-- 5. PACIENTE (10 unidades)
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

-- 6. FICHA_MEDICA (10 unidades)
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

-- 7. REGISTRO (10 unidades - Usando ID_ROL Fijos 1 y 2)
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

-- 8. REGISTRO_MEDICACION 
INSERT INTO Registro_medicacion (id_medicacion, id_registro, id_paciente) VALUES
(5, 1, 1),  -- Registro 1 (Paciente 1) -> Losartan (ID=5)
(1, 5, 5),  -- Registro 5 (Paciente 5) -> Amoxicilina (ID=1)
(8, 6, 6),  -- Registro 6 (Paciente 6) -> Furosemida (ID=8)
(7, 10, 10); -- Registro 10 (Paciente 10) -> Sertralina (ID=7)
GO