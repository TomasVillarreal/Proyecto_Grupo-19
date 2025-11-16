USE Clinicks_BD_I;

-- Creacion de la tabla sobre la cual se realizara un indice clustered sobre "fecha_registro"
CREATE TABLE Registro_Indexado_Clustered_Sin_Include
(
  id_registro INT IDENTITY(1,1) NOT NULL,
  fecha_registro DATE NOT NULL CONSTRAINT DF_fecha_registro_indexado DEFAULT GETDATE(),
  observaciones VARCHAR(255) NOT NULL,
  id_tipo_registro INT NOT NULL,
  id_rol_procedimiento INT NOT NULL,
  id_especialidad_procedimiento INT NOT NULL,
  id_rol_usuario INT NOT NULL,
  id_usuario INT NOT NULL,
  id_especialidad_usuario INT NOT NULL,
  id_paciente INT NOT NULL,
  CONSTRAINT PK_registro_indexado PRIMARY KEY NONCLUSTERED(id_registro),
  CONSTRAINT FK_registro_indexado_registro_especialidad FOREIGN KEY (id_tipo_registro, id_rol_procedimiento, id_especialidad_procedimiento) REFERENCES Registro_especialidad(id_tipo_registro, id_rol, id_especialidad),
  CONSTRAINT FK_registro_indexado_usuario_rol_especialidad FOREIGN KEY (id_rol_usuario, id_usuario, id_especialidad_usuario) REFERENCES Usuario_rol_especialidad(id_rol, id_usuario, id_especialidad),
  CONSTRAINT FK_registro_indexado_ficha_paciente FOREIGN KEY (id_paciente) REFERENCES Ficha_medica(id_paciente),
);

-- Creacion de la tabla sobre la cual se realizara un indice clustered sobre "fecha_registro", "id_paciente", "id_usuario"
CREATE TABLE Registro_Indexado_Clustered
(
  id_registro INT IDENTITY(1,1) NOT NULL,
  fecha_registro DATE NOT NULL CONSTRAINT DF_fecha_registro_indexado_clustered DEFAULT GETDATE(),
  observaciones VARCHAR(255) NOT NULL,
  id_tipo_registro INT NOT NULL,
  id_rol_procedimiento INT NOT NULL,
  id_especialidad_procedimiento INT NOT NULL,
  id_rol_usuario INT NOT NULL,
  id_usuario INT NOT NULL,
  id_especialidad_usuario INT NOT NULL,
  id_paciente INT NOT NULL,
  CONSTRAINT PK_registro_indexado_clustered PRIMARY KEY NONCLUSTERED (id_registro),
  CONSTRAINT FK_registro_indexado_clustered_registro_especialidad FOREIGN KEY (id_tipo_registro, id_rol_procedimiento, id_especialidad_procedimiento) REFERENCES Registro_especialidad(id_tipo_registro, id_rol, id_especialidad),
  CONSTRAINT FK_registro_indexado_clustered_usuario_rol_especialidad FOREIGN KEY (id_rol_usuario, id_usuario, id_especialidad_usuario) REFERENCES Usuario_rol_especialidad(id_rol, id_usuario, id_especialidad),
  CONSTRAINT FK_registro_indexado_clustered_ficha_paciente FOREIGN KEY (id_paciente) REFERENCES Ficha_medica(id_paciente),
);

-- Creacion de la tabla sin indices
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
  CONSTRAINT PK_registro PRIMARY KEY (id_registro),
  CONSTRAINT FK_registro_registro_especialidad FOREIGN KEY (id_tipo_registro, id_rol_procedimiento, id_especialidad_procedimiento) REFERENCES Registro_especialidad(id_tipo_registro, id_rol, id_especialidad),
  CONSTRAINT FK_registro_usuario_rol_especialidad FOREIGN KEY (id_rol_usuario, id_usuario, id_especialidad_usuario) REFERENCES Usuario_rol_especialidad(id_rol, id_usuario, id_especialidad),
  CONSTRAINT FK_registro_ficha_paciente FOREIGN KEY (id_paciente) REFERENCES Ficha_medica(id_paciente),
);



