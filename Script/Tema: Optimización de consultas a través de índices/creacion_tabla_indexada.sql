USE Clinicks_BD_I;


CREATE TABLE Registro_Indexado
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
  CONSTRAINT PK_registro_indexado PRIMARY KEY (id_registro, id_paciente),
  CONSTRAINT FK_registro_indexado_registro_especialidad FOREIGN KEY (id_tipo_registro, id_rol_procedimiento, id_especialidad_procedimiento) REFERENCES Registro_especialidad(id_tipo_registro, id_rol, id_especialidad),
  CONSTRAINT FK_registro_indexado_usuario_rol_especialidad FOREIGN KEY (id_rol_usuario, id_usuario, id_especialidad_usuario) REFERENCES Usuario_rol_especialidad(id_rol, id_usuario, id_especialidad),
  CONSTRAINT FK_registro_indexado_ficha_paciente FOREIGN KEY (id_paciente) REFERENCES Ficha_medica(id_paciente),
);




