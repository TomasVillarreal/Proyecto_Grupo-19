CREATE DATABASE  Clinicks_BD_I
USE Clinicks_BD_I;

CREATE TABLE Paciente
(
  id_paciente INT IDENTITY(1,1) NOT NULL,
  nombre_paciente VARCHAR(100) NOT NULL,
  apellido_paciente VARCHAR(100) NOT NULL,
  dni_paciente INT NOT NULL,
  telefono_paciente INT NOT NULL,
  CONSTRAINT PK_paciente PRIMARY KEY (id_paciente),
  CONSTRAINT CK_paciente_nombre_paciente CHECK (nombre_paciente LIKE '%[A-Za-z¡…Õ”⁄·ÈÌÛ˙—Ò -]%' 
       AND nombre_paciente NOT LIKE '%[^A-Za-z¡…Õ”⁄·ÈÌÛ˙—Ò -]%'),
  CONSTRAINT CK_paciente_apellido_paciente CHECK (apellido_paciente LIKE '%[A-Za-z¡…Õ”⁄·ÈÌÛ˙—Ò -]%' 
       AND apellido_paciente NOT LIKE '%[^A-Za-z¡…Õ”⁄·ÈÌÛ˙—Ò -]%'),
  CONSTRAINT UQ_paciente_dni_paciente UNIQUE (dni_paciente),
);

CREATE TABLE Ficha_medica
(
  id_paciente INT NOT NULL,
  fecha_creacion DATE NOT NULL CONSTRAINT DF_fecha_creacion_ficha DEFAULT GETDATE(),
  tipo_sanguineo VARCHAR(3) NOT NULL,
  estatura INT NOT NULL,
  peso FLOAT NOT NULL,
  CONSTRAINT PK_ficha_medica PRIMARY KEY (id_paciente),
  CONSTRAINT FK_ficha_medica_paciente FOREIGN KEY (id_paciente) REFERENCES Paciente(id_paciente),
  CONSTRAINT CK_ficha_medica_tipo_sanguineo CHECK (tipo_sanguineo IN ('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-')),
  CONSTRAINT CK_ficha_medica_estatura CHECK (estatura > 0),
  CONSTRAINT CK_ficha_medica_peso CHECK (peso > 0),
);

CREATE TABLE Usuario
(
  id_usuario INT IDENTITY(1,1) NOT NULL,
  nombre_usuario VARCHAR(200) NOT NULL,
  apellido_usuario VARCHAR(200) NOT NULL,
  email_usuario VARCHAR(200) NOT NULL,
  password VARCHAR(200) NOT NULL,
  dni_usuario INT NOT NULL,
  CONSTRAINT PK_usuario PRIMARY KEY (id_usuario),
  CONSTRAINT CK_usuario_nombre_usuario CHECK (nombre_usuario LIKE '%[A-Za-z¡…Õ”⁄·ÈÌÛ˙—Ò -]%' 
       AND nombre_usuario NOT LIKE '%[^A-Za-z¡…Õ”⁄·ÈÌÛ˙—Ò -]%'),
  CONSTRAINT CK_usuario_apellido_usuario CHECK (apellido_usuario LIKE '%[A-Za-z¡…Õ”⁄·ÈÌÛ˙—Ò -]%' 
       AND apellido_usuario NOT LIKE '%[^A-Za-z¡…Õ”⁄·ÈÌÛ˙—Ò -]%'),
  CONSTRAINT UQ_usuario_email_usuario UNIQUE (email_usuario),
  CONSTRAINT CK_usuario_email_formato CHECK (email_usuario LIKE '%_@%_._%'),
  CONSTRAINT UQ_usuario_dni_usuario UNIQUE (dni_usuario),
);

CREATE TABLE Rol
(
  id_rol INT IDENTITY(1,1) NOT NULL,
  nombre_rol VARCHAR(200) NOT NULL,
  CONSTRAINT PK_rol PRIMARY KEY (id_rol),
  CONSTRAINT UQ_rol_nombre_rol UNIQUE (nombre_rol),
);

CREATE TABLE Medicacion
(
  id_medicacion INT IDENTITY(1,1) NOT NULL,
  nombre_medicacion VARCHAR(200) NOT NULL,
  dosis_medicacion INT NOT NULL,
  CONSTRAINT PK_medicacion PRIMARY KEY (id_medicacion),
  CONSTRAINT CK_medicacion_nombre_medicacion CHECK (nombre_medicacion LIKE '%[A-Za-z—Ò]%'
      AND nombre_medicacion NOT LIKE '%[^A-Za-z—Ò -]%'
      AND nombre_medicacion NOT LIKE '%  %'),
  CONSTRAINT UQ_medicacion_nombre_medicacion UNIQUE (nombre_medicacion),
  CONSTRAINT CK_medicacion_dosis CHECK (dosis_medicacion > 0),
);

CREATE TABLE Tipo_registro
(
  id_tipo_registro INT IDENTITY(1,1) NOT NULL,
  nombre_registro VARCHAR(200) NOT NULL,
  CONSTRAINT PK_tipo_registro PRIMARY KEY (id_tipo_registro),
  CONSTRAINT CK_tipo_registro_nombre_registro CHECK (nombre_registro LIKE '%[A-Za-z—Ò]%'
      AND nombre_registro NOT LIKE '%[^A-Za-z—Ò -]%'
      AND nombre_registro NOT LIKE '%  %'),
  CONSTRAINT UQ_tipo_registro_nombre_registro UNIQUE (nombre_registro),
);

CREATE TABLE Especialidad
(
  id_especialidad INT IDENTITY(1,1) NOT NULL,
  nombre_especialidad VARCHAR(100) NOT NULL,
  CONSTRAINT PK_especialidad PRIMARY KEY (id_especialidad),
  CONSTRAINT CK_especialidad_nombre_especialidad CHECK (nombre_especialidad LIKE '%[A-Za-z—Ò]%'
      AND nombre_especialidad NOT LIKE '%[^A-Za-z—Ò -]%'
      AND nombre_especialidad NOT LIKE '%  %'),
  CONSTRAINT UQ_especialidad_nombre_especialidad UNIQUE (nombre_especialidad),
);

CREATE TABLE Rol_especialidad
(
  id_rol INT NOT NULL,
  id_especialidad INT NOT NULL,
  CONSTRAINT PK_rol_especialidad PRIMARY KEY (id_rol, id_especialidad),
  CONSTRAINT FK_rol_especialidad_rol FOREIGN KEY (id_rol) REFERENCES Rol(id_rol),
  CONSTRAINT FK_rol_especialidad_especialidad FOREIGN KEY (id_especialidad) REFERENCES Especialidad(id_especialidad)
);

CREATE TABLE Registro_especialidad
(
  id_tipo_registro INT NOT NULL,
  id_rol INT NOT NULL,
  id_especialidad INT NOT NULL,
  CONSTRAINT PK_registro_especialidad PRIMARY KEY (id_tipo_registro, id_rol, id_especialidad),
  CONSTRAINT FK_registro_especialidad_tipo_registro FOREIGN KEY (id_tipo_registro) REFERENCES Tipo_registro(id_tipo_registro),
  CONSTRAINT FK_registro_especialidad_rol_especialidad FOREIGN KEY (id_rol, id_especialidad) REFERENCES Rol_especialidad(id_rol, id_especialidad)
);

CREATE TABLE Usuario_Rol
(
  id_rol INT NOT NULL,
  id_usuario INT NOT NULL,
  CONSTRAINT PK_usuario_rol PRIMARY KEY (id_rol, id_usuario),
  CONSTRAINT FK_usuario_rol_rol FOREIGN KEY (id_rol) REFERENCES Rol(id_rol),
  CONSTRAINT FK_usuario_rol_usuario FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario)
);

CREATE TABLE Usuario_rol_especialidad
(
  id_rol INT NOT NULL,
  id_usuario INT NOT NULL,
  id_especialidad INT NOT NULL,
  CONSTRAINT PK_usuario_rol_especialidad PRIMARY KEY (id_rol, id_usuario, id_especialidad),
  CONSTRAINT FK_usuario_rol_especialidad_usuario_rol FOREIGN KEY (id_rol, id_usuario) REFERENCES Usuario_Rol(id_rol, id_usuario),
  CONSTRAINT FK_usuario_rol_especialidad_rol_especialidad FOREIGN KEY (id_rol, id_especialidad) REFERENCES Rol_especialidad(id_rol, id_especialidad)
);

CREATE TABLE Registro
(
  id_registro INT IDENTITY(1,1) NOT NULL,
  fecha_registro DATE NOT NULL CONSTRAINT DF_fecha_registro DEFAULT GETDATE(),
  observaciones VARCHAR(255) NOT NULL,
  id_tipo_registro INT NOT NULL,
  id_rol_procedimiento INT NOT NULL,
  id_especialidad_procedimiento INT NOT NULL,
  id_rol_usuario INT NOT NULL,
  id_usuario INT NOT NULL,
  id_especialidad_usuario INT NOT NULL,
  id_paciente INT NOT NULL,
  CONSTRAINT PK_registro PRIMARY KEY (id_registro, id_paciente),
  CONSTRAINT FK_registro_registro_especialidad FOREIGN KEY (id_tipo_registro, id_rol_procedimiento, id_especialidad_procedimiento) REFERENCES Registro_especialidad(id_tipo_registro, id_rol, id_especialidad),
  CONSTRAINT FK_registro_usuario_rol_especialidad FOREIGN KEY (id_rol_usuario, id_usuario, id_especialidad_usuario) REFERENCES Usuario_rol_especialidad(id_rol, id_usuario, id_especialidad),
  CONSTRAINT FK_registro_ficha_paciente FOREIGN KEY (id_paciente) REFERENCES Ficha_medica(id_paciente),
);

CREATE TABLE Registro_medicacion
(
  id_medicacion INT NOT NULL,
  id_registro INT NOT NULL,
  id_paciente INT NOT NULL,
  CONSTRAINT PK_registro_medicacion PRIMARY KEY (id_medicacion, id_registro, id_paciente),
  CONSTRAINT FK_registro_medicacion_medicacion FOREIGN KEY (id_medicacion) REFERENCES Medicacion(id_medicacion),
  CONSTRAINT FK_registro_medicacion_registro FOREIGN KEY (id_registro, id_paciente) REFERENCES Registro(id_registro, id_paciente)
);
