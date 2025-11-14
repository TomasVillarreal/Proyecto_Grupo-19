USE Clinicks_BD_I;


/* Creacion de la tabla donde colocaremos todos los indices non-clustered necesarios para las pruebas.
Es como una tabla normal y corriente, nada raro*/
CREATE TABLE Registro_Indexado_Nonclustered
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
  CONSTRAINT PK_registro_indexado PRIMARY KEY (id_registro),
  CONSTRAINT FK_registro_indexado_registro_especialidad FOREIGN KEY (id_tipo_registro, id_rol_procedimiento, id_especialidad_procedimiento) REFERENCES Registro_especialidad(id_tipo_registro, id_rol, id_especialidad),
  CONSTRAINT FK_registro_indexado_usuario_rol_especialidad FOREIGN KEY (id_rol_usuario, id_usuario, id_especialidad_usuario) REFERENCES Usuario_rol_especialidad(id_rol, id_usuario, id_especialidad),
  CONSTRAINT FK_registro_indexado_ficha_paciente FOREIGN KEY (id_paciente) REFERENCES Ficha_medica(id_paciente),
);

/* Aca es donde esta lo raro. Esta tabla sera aquella la cual tendra el indice clustered sobre fecha y otro conjunto de columnas.
Lo raro viene de que la clave primaria es non-clustered, es decir, que la tabla no va a estar fisicamente ordenada
por la clave primaria, y por lo tanto al guardarse los registros no van a seguir un orden especifico.
Esto es justamente porque si creamos una PK como lo hacemos en las otras dos tablas, no podremos crear
un indice clustered*/
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
  CONSTRAINT PK_registro_indexado_clustered PRIMARY KEY NONCLUSTERED (id_registro), -- Aca esta la diferencia!!!
  CONSTRAINT FK_registro_indexado_clustered_registro_especialidad FOREIGN KEY (id_tipo_registro, id_rol_procedimiento, id_especialidad_procedimiento) REFERENCES Registro_especialidad(id_tipo_registro, id_rol, id_especialidad),
  CONSTRAINT FK_registro_indexado_clustered_usuario_rol_especialidad FOREIGN KEY (id_rol_usuario, id_usuario, id_especialidad_usuario) REFERENCES Usuario_rol_especialidad(id_rol, id_usuario, id_especialidad),
  CONSTRAINT FK_registro_indexado_clustered_ficha_paciente FOREIGN KEY (id_paciente) REFERENCES Ficha_medica(id_paciente),
);

/* Esta es la tabla mas normalita, no va a tener ningun indice (ni clustered, ni non-clustered).
Es en escencia la misma que la tabla que va a tener indices non-clustered, no tiene nada raro.*/
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




