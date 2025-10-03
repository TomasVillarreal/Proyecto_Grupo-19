CREATE DATABASE Clinicks_BDI;

USE Clinicks_BDI;

CREATE TABLE Paciente
(
  dni_paciente INT NOT NULL,
  nombre_paciente VARCHAR(100) NOT NULL,
  apellido_paciente VARCHAR(100) NOT NULL,
  telefono INT NOT NULL,
  CONSTRAINT PK_dni_paciente PRIMARY KEY (dni_paciente),
  CONSTRAINT CK_nombre_paciente CHECK (nombre_paciente LIKE '%[A-Za-z]%' AND nombre_paciente NOT LIKE '%[^A-Za-z]%'),
  CONSTRAINT CK_apellido_paciente CHECK (apellido_paciente LIKE '%[A-Za-z]%' AND apellido_paciente NOT LIKE '%[^A-Za-z]%'),
  CONSTRAINT CK_telefono CHECK (telefono NOT LIKE '%[^0-9]%')
);

CREATE TABLE Historial
(
  id_historial INT NOT NULL,
  dni_paciente INT NOT NULL,
  fecha_creacion DATE NOT NULL,
  CONSTRAINT PK_id_historial_dni PRIMARY KEY (id_historial, dni_paciente),
  CONSTRAINT FK_dni_historial FOREIGN KEY (dni_paciente) REFERENCES Paciente(dni_paciente),
  CONSTRAINT DF_fecha_creacion DEFAULT GETDATE() FOR fecha_creacion
);

CREATE TABLE Rol
(
  id_rol INT NOT NULL,
  nombre_rol VARCHAR(200) NOT NULL,
  CONSTRAINT PK_id_rol PRIMARY KEY (id_rol),
  CONSTRAINT UQ_nombre_rol UNIQUE (nombre_rol),
);

CREATE TABLE Usuario
(
  dni_usuario INT NOT NULL,
  id_rol INT NOT NULL,
  nombre_usuario VARCHAR(200) NOT NULL,
  apellido_usuario VARCHAR(200) NOT NULL,
  email_usuario VARCHAR(200) NOT NULL,
  password VARCHAR(200) NOT NULL,
  CONSTRAINT PK_id_dni_usuario PRIMARY KEY (dni_usuario),
  CONSTRAINT FK_id_rol FOREIGN KEY (id_rol) REFERENCES Rol(id_rol),
  CONSTRAINT CK_nombre_usuario CHECK (nombre_usuario LIKE '%[A-Za-z]%' AND nombre_usuario NOT LIKE '%[^A-Za-z]%'),
  CONSTRAINT CK_apellido_usuario CHECK (apellido_usuario LIKE '%[A-Za-z]%' AND apellido_usuario NOT LIKE '%[^A-Za-z]%'),
  CONSTRAINT UQ_email_usuario UNIQUE (email_usuario),
  CONSTRAINT CK_email_formato CHECK (email_usuario LIKE '%_@%_._%')
);

CREATE TABLE Medicacion
(
  id_medicacion INT NOT NULL,
  nombre_medicacion VARCHAR(200) NOT NULL,
  dosis_medicacion DECIMAL(8, 2) NOT NULL,
  CONSTRAINT PK_id_medicacion PRIMARY KEY (id_medicacion),
  CONSTRAINT UQ_NombreMedicacion UNIQUE (nombre_medicacion),
  CONSTRAINT CK_Dosis_Positiva CHECK (dosis_medicacion > 0)
)

CREATE TABLE Tipo_registro
(
  id_procedimiento INT NOT NULL,
  nombre_registro VARCHAR(200) NOT NULL,
  CONSTRAINT PK_id_procedimiento PRIMARY KEY (id_procedimiento),
  CONSTRAINT UQ_nombre_resgistro UNIQUE (nombre_registro)
);

CREATE TABLE Especialidad
(
  id_especialidad INT NOT NULL,
  nombre_especialidad VARCHAR(100) NOT NULL,
  CONSTRAINT PK_id_especialidad PRIMARY KEY (id_especialidad),
  CONSTRAINT UQ_nombre_especialidad UNIQUE (nombre_especialidad)
);

CREATE TABLE Rol_especialidad
(
  id_rol INT NOT NULL,
  id_especialidad INT NOT NULL,
  CONSTRAINT PK_id_rol_especialidad PRIMARY KEY (id_rol, id_especialidad),
  CONSTRAINT FK_id_rol FOREIGN KEY (id_rol) REFERENCES Rol(id_rol),
  CONSTRAINT FK_id_especialidad FOREIGN KEY (id_especialidad) REFERENCES Especialidad(id_especialidad)
);

CREATE TABLE Registro_especialidad
(
  id_procedimiento INT NOT NULL,
  id_rol INT NOT NULL,
  id_especialidad INT NOT NULL,
  CONSTRAINT PK_id_procedimiento_rol_especialidad PRIMARY KEY (id_procedimiento, id_rol, id_especialidad),
  CONSTRAINT FK_id_procecimiento FOREIGN KEY (id_procedimiento) REFERENCES Tipo_registro(id_procedimiento),
  CONSTRAINT FK_id_rol_especialidad FOREIGN KEY (id_rol, id_especialidad) REFERENCES Rol_especialidad(id_rol, id_especialidad)
);

CREATE TABLE Registro
(
  id_registro INT NOT NULL,
  id_historial INT NOT NULL,
  dni_paciente INT NOT NULL,
  id_procedimiento INT NOT NULL,
  id_rol INT NOT NULL,
  id_especialidad INT NOT NULL,
  fecha_registro DATE NOT NULL,
  observaciones VARCHAR (200) NOT NULL,
  CONSTRAINT PK_id_resgitro_historial_paciente PRIMARY KEY (id_registro, id_historial, dni_paciente),
  CONSTRAINT FK_id_historial_dni_paciente FOREIGN KEY (id_historial, dni_paciente) REFERENCES Historial(id_historial, dni_paciente),
  CONSTRAINT FK_id_procedimiento_rol_especialidad FOREIGN KEY (id_procedimiento, id_rol, id_especialidad) 
  REFERENCES Registro_especialidad(id_procedimiento, id_rol, id_especialidad),
  CONSTRAINT DF_fecha_registro DEFAULT GETDATE() FOR fecha_registro,
  CONSTRAINT CK_fecha_registro CHECK (fecha_registro <= GETDATE()),
);

CREATE TABLE Registro_medicacion
(
  id_medicacion INT NOT NULL,
  id_registro INT NOT NULL,
  id_historial INT NOT NULL,
  dni_paciente INT NOT NULL,
  CONSTRAINT PK_id_medicacion_registro_historial_paciente PRIMARY KEY (id_medicacion, id_registro, id_historial, dni_paciente),
  CONSTRAINT FK_medicacion FOREIGN KEY (id_medicacion) REFERENCES Medicacion(id_medicacion),
  CONSTRAINT FK_id_resgitro_historial_paciente
  FOREIGN KEY (id_registro, id_historial, dni_paciente) REFERENCES Registro(id_registro, id_historial, dni_paciente)
);