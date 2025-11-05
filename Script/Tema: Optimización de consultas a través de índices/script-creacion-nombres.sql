use Clinicks_BD_I;

-- ============================================
-- CREAR VECTOR DE NOMBRES Y APELLIDOS SIN TILDES
-- ============================================

-- Limpieza si ya existen
IF OBJECT_ID('tempdb..#Nombres') IS NOT NULL DROP TABLE #Nombres;
IF OBJECT_ID('tempdb..#Apellidos') IS NOT NULL DROP TABLE #Apellidos;
IF OBJECT_ID('tempdb..#Personas') IS NOT NULL DROP TABLE #Personas;

-- Crear tablas temporales
CREATE TABLE #Nombres (id INT IDENTITY(1,1), nombre VARCHAR(50));
CREATE TABLE #Apellidos (id INT IDENTITY(1,1), apellido VARCHAR(50));
CREATE TABLE #Personas (id INT IDENTITY(1,1), nombre VARCHAR(50), apellido VARCHAR(50));

-- ============================================
-- CARGAR LISTA DE NOMBRES (1000)
-- ============================================
INSERT INTO #Nombres (nombre)
VALUES
('Agustin'), ('Alan'), ('Alberto'), ('Alejandro'), ('Alexis'), ('Alvaro'), ('Andres'), ('Angel'), ('Antonio'),
('Benjamin'), ('Bruno'), ('Camilo'), ('Carlos'), ('Cristian'), ('Dario'), ('David'), ('Diego'), ('Eduardo'),
('Elias'), ('Emiliano'), ('Enzo'), ('Esteban'), ('Facundo'), ('Federico'), ('Felipe'), ('Francisco'), ('Franco'),
('Gabriel'), ('Gaston'), ('Gonzalo'), ('Guillermo'), ('Hernan'), ('Ignacio'), ('Ivan'), ('Javier'), ('Jeremias'),
('Joaquin'), ('Jorge'), ('Jose'), ('Juan'), ('Julian'), ('Kevin'), ('Leandro'), ('Leonel'), ('Lucas'), ('Luciano'),
('Luis'), ('Manuel'), ('Marco'), ('Marcos'), ('Mario'), ('Martin'), ('Mateo'), ('Matias'), ('Maximiliano'),
('Miguel'), ('Nicolas'), ('Oscar'), ('Pablo'), ('Pedro'), ('Rafael'), ('Ramiro'), ('Ricardo'), ('Roberto'),
('Rodrigo'), ('Santiago'), ('Sebastian'), ('Sergio'), ('Tomas'), ('Valentin'), ('Victor'), ('Walter'),
('Adriana'), ('Alejandra'), ('Ana'), ('Andrea'), ('Angela'), ('Beatriz'), ('Carla'), ('Carmen'), ('Catalina'),
('Claudia'), ('Cristina'), ('Daniela'), ('Diana'), ('Dolores'), ('Elena'), ('Elizabeth'), ('Eva'), ('Fernanda'),
('Florencia'), ('Gabriela'), ('Graciela'), ('Guadalupe'), ('Ines'), ('Irene'), ('Isabel'), ('Jimena'), ('Josefina'),
('Juana'), ('Julia'), ('Karen'), ('Laura'), ('Leticia'), ('Liliana'), ('Lorena'), ('Lucia'), ('Luisa'), ('Magdalena'),
('Manuela'), ('Marcela'), ('Maria'), ('Mariana'), ('Marta'), ('Mercedes'), ('Milagros'), ('Miriam'), ('Monica'),
('Natalia'), ('Noelia'), ('Patricia'), ('Paula'), ('Pilar'), ('Rocio'), ('Romina'), ('Rosa'), ('Sandra'), ('Sara'),
('Abel'), ('Adan'), ('Adriel'), ('Aitor'), ('Alanis'), ('Alcides'), ('Aleix'), ('Alfredo'), ('Amador'), ('Amelia'),
('Amparo'), ('Anahi'), ('Anastasio'), ('Anibal'), ('Antonia'), ('Ariadna'), ('Armando'), ('Arnoldo'), ('Arturo'), ('Aurelio'),
('Azucena'), ('Baltasar'), ('Bartolome'), ('Belinda'), ('Bernardo'), ('Berta'), ('Blanca'), ('Braulio'), ('Candela'), ('Cecilia'),
('Celeste'), ('Ciro'), ('Claudio'), ('Clemente'), ('Concepcion'), ('Constanza'), ('Cristobal'), ('Damian'), ('Danilo'), ('Delfina'),
('Demetrio'), ('Denis'), ('Domingo'), ('Donato'), ('Dorotea'), ('Edgar'), ('Efrain'), ('Elvio'), ('Emilia'), ('Ernesto'),
('Estela'), ('Eugenio'), ('Eulalia'), ('Eusebio'), ('Eva'), ('Ezequiel'), ('Fabian'), ('Faustino'), ('Feliciano'), ('Flavio'),
('Flor'), ('Fortunato'), ('Francisca'), ('Froilan'), ('Genaro'), ('Gerardo'), ('German'), ('Gilda'), ('Gregorio'), ('Guillermina'),
('Hector'), ('Herminia'), ('Hipolito'), ('Homero'), ('Horacio'), ('Hugo'), ('Humberto'), ('Ida'), ('Ignacia'), ('Ildefonso'),
('Inocencio'), ('Irma'), ('Isaac'), ('Ismael'), ('Jacinto'), ('Jacqueline'), ('Jaime'), ('Janet'), ('Jazmin'), ('Jenifer'),
('Jesica'), ('Joel'), ('Jonatan'), ('Josef'), ('Josue'), ('Juanita'), ('Julio'), ('Justina'), ('Karen'), ('Karla'),
('Lautaro'), ('Leila'), ('Leonardo'), ('Lidia'), ('Lisandro'), ('Lola'), ('Lorenz'), ('Lucero'), ('Ludmila'), ('Luisina'),
('Macarena'), ('Maia'), ('Malena'), ('Manolo'), ('Marcelo'), ('Marcos'), ('Maribel'), ('Marina'), ('Mario'), ('Martina'),
('Mateo'), ('Mauricio'), ('Maximo'), ('Melina'), ('Mercedes'), ('Mia'), ('Miguel'), ('Mirta'), ('Moisés'), ('Morena'),
('Nadia'), ('Nahuel'), ('Nancy'), ('Natalia'), ('Nayla'), ('Nazareno'), ('Nerea'), ('Nestor'), ('Nicanor'), ('Nicole'),
('Nilda'), ('Noa'), ('Noelia'), ('Nora'), ('Norberto'), ('Norma'), ('Octavio'), ('Olga'), ('Omar'), ('Orlando'),
('Oscar'), ('Osvaldo'), ('Pascual'), ('Patricio'), ('Paulina'), ('Pedro'), ('Pepe'), ('Pia'), ('Priscila'), ('Rafael'),
('Ramona'), ('Raquel'), ('Rebeca'), ('Renata'), ('Ricardo'), ('Rita'), ('Roberto'), ('Rodrigo'), ('Rogelio'), ('Rosa'),
('Rosalia'), ('Rosana'), ('Rosario'), ('Roxana'), ('Rubén'), ('Sabina'), ('Salvador'), ('Samuel'), ('Sandra'), ('Sara'),
('Sebastian'), ('Selena'), ('Sergio'), ('Silvana'), ('Silvia'), ('Simón'), ('Soledad'), ('Sonia'), ('Sophie'), ('Susana'),
('Tadeo'), ('Tamara'), ('Teodoro'), ('Teresa'), ('Thiago'), ('Tomas'), ('Trinidad'), ('Ulises'), ('Valentina'), ('Vanesa'),
('Vicente'), ('Virginia'), ('Violeta'), ('Veronica'), ('Valeria'), ('Vanina'), ('Viviana'), ('Yamila'), ('Yanina'), ('Yasmin'),
('Yolanda'), ('Yohana'), ('Yair'), ('Yago'), ('Yuliana'), ('Zaira'), ('Zoe'), ('Zulema'), ('Abigail'), ('Adela'),
('Agata'), ('Aida'), ('Ainara'), ('Aitana'), ('Alba'), ('Alina'), ('Amaya'), ('Amparo'), ('Anais'), ('Anahi'),
('Andrea'), ('Angela'), ('Anisa'), ('Antonia'), ('Araceli'), ('Ariadna'), ('Ariana'), ('Astrid'), ('Aurora'), ('Ayelen'),
('Azul'), ('Barbara'), ('Belen'), ('Bianca'), ('Brenda'), ('Carina'), ('Carolina'), ('Casandra'), ('Cecilia'), ('Celina'),
('Cinthia'), ('Clara'), ('Clarisa'), ('Claudia'), ('Concepcion'), ('Coral'), ('Cristina'), ('Dafne'), ('Dalila'), ('Daniela'),
('Debora'), ('Delia'), ('Diana'), ('Dolores'), ('Elena'), ('Elisa'), ('Elsa'), ('Emilia'), ('Erica'), ('Estefania'),
('Estela'), ('Eugenia'), ('Eva'), ('Fabiola'), ('Fatima'), ('Felisa'), ('Fernanda'), ('Fiorella'), ('Florencia'), ('Francisca'),
('Gabriela'), ('Genoveva'), ('Georgina'), ('Gilda'), ('Gladys'), ('Gloria'), ('Graciela'), ('Guadalupe'), ('Ines'), ('Irene'),
('Isidora'), ('Itzel'), ('Ivana'), ('Jacinta'), ('Jade'), ('Jazmin'), ('Jennifer'), ('Jessica'), ('Joana'), ('Josefa'),
('Joselyn'), ('Juana'), ('Judith'), ('Julia'), ('Juliana'), ('Justina'), ('Karen'), ('Karina'), ('Kassandra'), ('Katia'),
('Kiara'), ('Lara'), ('Laura'), ('Leila'), ('Leonor'), ('Leticia'), ('Lia'), ('Liliana'), ('Lina'), ('Lisandra'),
('Lissette'), ('Lola'), ('Lorena'), ('Lucia'), ('Lucrecia'), ('Ludmila'), ('Luisa'), ('Luna'), ('Luz'), ('Magali'),
('Magdalena'), ('Maia'), ('Malena'), ('Manuela'), ('Marcela'), ('Margarita'), ('Maria'), ('Mariana'), ('Maricel'), ('Mariela'),
('Marina'), ('Marta'), ('Martina'), ('Matilde'), ('Melanie'), ('Melina'), ('Mercedes'), ('Mia'), ('Milagros'), ('Miriam'),
('Mirta'), ('Monica'), ('Morena'), ('Nadia'), ('Naiara'), ('Nancy'), ('Natalia'), ('Nayla'), ('Nerea'), ('Nicole'),
('Noelia'), ('Nora'), ('Norma'), ('Olga'), ('Paloma'), ('Pamela'), ('Patricia'), ('Paula'), ('Paz'), ('Pilar'),
('Priscila'), ('Rafaela'), ('Ramona'), ('Raquel'), ('Rebeca'), ('Regina'), ('Renata'), ('Rita'), ('Rocío'), ('Romina'),
('Rosa'), ('Rosalia'), ('Rosana'), ('Rosario'), ('Roxana'), ('Sabina'), ('Salma'), ('Sandra'), ('Sara'), ('Selena')





-- ============================================
-- CARGAR LISTA DE APELLIDOS (1100)
-- ============================================
INSERT INTO #Apellidos (apellido)
VALUES
('Acosta'), ('Aguirre'), ('Alonso'), ('Alvarez'), ('Amaya'), ('Arias'), ('Avila'), ('Baez'), ('Barrera'), ('Benitez'),
('Blanco'), ('Bravo'), ('Bustamante'), ('Cabrera'), ('Camacho'), ('Campos'), ('Cardozo'), ('Carrizo'), ('Castillo'), ('Castro'),
('Cisneros'), ('Contreras'), ('Correa'), ('Cortes'), ('Cuevas'), ('Delgado'), ('Diaz'), ('Dominguez'), ('Escobar'), ('Espinoza'),
('Fernandez'), ('Figueroa'), ('Flores'), ('Franco'), ('Fuentes'), ('Gallardo'), ('Gimenez'), ('Godoy'), ('Gomez'), ('Gonzalez'),
('Guerrero'), ('Gutierrez'), ('Herrera'), ('Ibarra'), ('Juarez'), ('Lopez'), ('Luna'), ('Maldonado'), ('Martinez'), ('Medina'),
('Mendez'), ('Molina'), ('Monzon'), ('Morales'), ('Moreno'), ('Muñoz'), ('Navarro'), ('Nunez'), ('Ojeda'), ('Ortiz'),
('Pacheco'), ('Paredes'), ('Perez'), ('Quiroga'), ('Ramos'), ('Ramirez'), ('Rios'), ('Rivas'), ('Rivera'), ('Rodriguez'),
('Rojas'), ('Romero'), ('Ruiz'), ('Salas'), ('Salazar'), ('Sanchez'), ('Sosa'), ('Suarez'), ('Torres'), ('Vega'),
('Vera'), ('Vidal'), ('Villarreal'), ('Villalba'), ('Zamora'), ('Zarate'), ('Barrios'), ('Bermudez'), ('Cano'), ('Carvajal'),
('Chavez'), ('Delvalle'), ('Esquivel'), ('Esteban'), ('Galvez'), ('Ledesma'), ('Mansilla'), ('Miranda'), ('Montoya'), ('Palacios'),
('Pinto'), ('Portillo'), ('Quintero'), ('Reyes'), ('Serrano'), ('Tapia'), ('Valdez'), ('Vallejo'), ('Vasquez'), ('Zuniga'),
('Abreu'), ('Acevedo'), ('Aguilar'), ('Alarcon'), ('Alfaro'), ('Altamirano'), ('Amador'), ('Andrade'), ('Angulo'), ('Antunez'),
('Aragon'), ('Aranda'), ('Arenas'), ('Arguello'), ('Armas'), ('Arriaga'), ('Arroyo'), ('Ayala'), ('Baeza'), ('Balderas'),
('Ballesteros'), ('Barajas'), ('Barbosa'), ('Barreto'), ('Barragan'), ('Barrios'), ('Bautista'), ('Beltran'), ('Bermejo'), ('Bernal'),
('Berrocal'), ('Bocanegra'), ('Bonilla'), ('Borja'), ('Briones'), ('Bueno'), ('Bustos'), ('Caballero'), ('Caceres'), ('Calderon'),
('Calvo'), ('Canales'), ('Cantero'), ('Cano'), ('Cantu'), ('Caraballo'), ('Carballo'), ('Cardenas'), ('Carranza'), ('Carretero'),
('Casas'), ('Castañeda'), ('Cazares'), ('Cedillo'), ('Centeno'), ('Cervantes'), ('Chavez'), ('Cifuentes'), ('Colina'), ('Colmenares'),
('Contreras'), ('Cornejo'), ('Cortez'), ('Cuellar'), ('Curiel'), ('Delvalle'), ('Diaz'), ('Duarte'), ('Dueñas'), ('Encinas'),
('Enriquez'), ('Escamilla'), ('Esparza'), ('Esteban'), ('Estrada'), ('Fajardo'), ('Farias'), ('Ferrer'), ('Fierro'), ('Fonseca'),
('Franco'), ('Galindo'), ('Gallegos'), ('Galvez'), ('Gamboa'), ('Garcia'), ('Garrido'), ('Gavilan'), ('Giron'), ('Gonzales'),
('Gracia'), ('Granados'), ('Guardado'), ('Guillen'), ('Guzman'), ('Haro'), ('Hernandez'), ('Herreros'), ('Hidalgo'), ('Huerta'),
('Ibanez'), ('Infante'), ('Islas'), ('Izquierdo'), ('Jacobo'), ('Jaramillo'), ('Jimenez'), ('Jiron'), ('Lagos'), ('Lara'),
('Lasso'), ('Leiva'), ('Lemus'), ('Leon'), ('Lerma'), ('Leyva'), ('Limones'), ('Llamas'), ('Llanos'), ('Lobo'),
('Loera'), ('Longoria'), ('Lorente'), ('Loyola'), ('Lucero'), ('Lugo'), ('Macias'), ('Madrid'), ('Maestre'), ('Magana'),
('Maida'), ('Malagon'), ('Manzano'), ('Marin'), ('Marquez'), ('Marrero'), ('Marti'), ('Mateos'), ('Matos'), ('Mayorga'),
('Mejia'), ('Melendez'), ('Meneses'), ('Merino'), ('Mesa'), ('Miralles'), ('Miramontes'), ('Mireles'), ('Mojica'), ('Mondragon'),
('Montes'), ('Morales'), ('Moreira'), ('Moscoso'), ('Mosquera'), ('Moya'), ('Munguia'), ('Murillo'), ('Naranjo'), ('Narvaez'),
('Navas'), ('Nevarez'), ('Nieto'), ('Noriega'), ('Obando'), ('Obregon'), ('Ocampo'), ('Ochoa'), ('Oliva'), ('Olivares'),
('Olivera'), ('Orellana'), ('Ornelas'), ('Ortega'), ('Osorio'), ('Ovalle'), ('Padilla'), ('Palma'), ('Paniagua'), ('Pantoja'),
('Parra'), ('Pastor'), ('Patiño'), ('Peñaloza'), ('Peralta'), ('Perdomo'), ('Peres'), ('Pichardo'), ('Pimentel'), ('Piña'),
('Plascencia'), ('Polanco'), ('Ponce'), ('Portales'), ('Posadas'), ('Preciado'), ('Puente'), ('Puga'), ('Quezada'), ('Quijano')




-- ============================================
-- INSERTAR 100 USUARIOS ÚNICOS
-- ============================================

BEGIN TRY
BEGIN TRANSACTION;

WITH Combinaciones AS
(
    SELECT TOP 100
        N.nombre AS nombre_usuario,
        A.apellido AS apellido_usuario,
        CONCAT(N.nombre, '.', A.apellido, '@mail.com') AS email_usuario,
        '1234' AS password,
        30000000 + ROW_NUMBER() OVER (ORDER BY NEWID()) AS dni_usuario
    FROM #Nombres N
    CROSS JOIN #Apellidos A
    ORDER BY NEWID()
)
INSERT INTO Usuario (nombre_usuario, apellido_usuario, email_usuario, password, dni_usuario)
SELECT *
FROM Combinaciones;

COMMIT TRANSACTION;
PRINT 'Inserción exitosa de 100 usuarios.';

END TRY
BEGIN CATCH
ROLLBACK TRANSACTION;
PRINT 'Ocurrió un error. La transacción fue revertida.';
PRINT ERROR_MESSAGE();
END CATCH;




-- ============================================
-- INSERTAR 1000 PACIENTES ÚNICOS
-- ============================================

BEGIN TRY
BEGIN TRANSACTION;

WITH PacientesAleatorios AS
(
    SELECT TOP 1000
        N.nombre AS nombre_paciente,
        A.apellido AS apellido_paciente,
        -- DNI aleatorio entre 46.000.000 y 46.999.999
        CAST(46000000 + CAST(RAND(CHECKSUM(NEWID())) * 999999 AS INT) AS INT) AS dni_paciente,
        -- Teléfono fijo de 10 dígitos
        1234567890 AS telefono_paciente
    FROM #Nombres N
    CROSS JOIN #Apellidos A
    ORDER BY NEWID()
),
Pacientes AS
(
    SELECT 
        nombre_paciente,
        apellido_paciente,
        dni_paciente,
        telefono_paciente
    FROM PacientesAleatorios
)
INSERT INTO Paciente (nombre_paciente, apellido_paciente, dni_paciente, telefono_paciente)
SELECT nombre_paciente, apellido_paciente, dni_paciente, telefono_paciente
FROM Pacientes;

COMMIT TRANSACTION;
PRINT 'Inserción exitosa de 1000 pacientes.';

END TRY
BEGIN CATCH
ROLLBACK TRANSACTION;
PRINT 'Ocurrió un error. La transacción fue revertida.';
PRINT ERROR_MESSAGE();
END CATCH;



DECLARE @idRolMedico INT, @idRolEnfermero INT;

SELECT @idRolMedico = id_rol FROM Rol WHERE nombre_rol = 'Medico';
SELECT @idRolEnfermero = id_rol FROM Rol WHERE nombre_rol = 'Enfermero';

-- Asignar rol Médico a los primeros 50 usuarios
INSERT INTO Usuario_Rol (id_rol, id_usuario)
SELECT @idRolMedico, id_usuario
FROM (
    SELECT TOP 50 id_usuario
    FROM Usuario
    ORDER BY id_usuario
) AS Primeros50;

-- Asignar rol Enfermero a los siguientes 50 usuarios
INSERT INTO Usuario_Rol (id_rol, id_usuario)
SELECT @idRolEnfermero, id_usuario
FROM (
    SELECT id_usuario
    FROM Usuario
    ORDER BY id_usuario
    OFFSET 50 ROWS FETCH NEXT 50 ROWS ONLY
) AS Siguientes50;



BEGIN TRY
    BEGIN TRANSACTION;

    -- ============================================
    -- ASIGNAR ESPECIALIDADES ALEATORIAS A CADA USUARIO_ROL
    -- ============================================

    ;WITH EspecialidadesAleatorias AS
    (
        SELECT
            ur.id_usuario,
            ur.id_rol,
            e.id_especialidad,
            ROW_NUMBER() OVER (PARTITION BY ur.id_usuario ORDER BY NEWID()) AS rn
        FROM Usuario_Rol ur
        JOIN Rol_especialidad e
            ON e.id_rol = ur.id_rol
    )
    INSERT INTO Usuario_rol_especialidad (id_rol, id_usuario, id_especialidad)
    SELECT
        id_rol,
        id_usuario,
        id_especialidad
    FROM EspecialidadesAleatorias
    WHERE rn = 1;  -- Tomar solo 1 especialidad aleatoria por usuario

    COMMIT TRANSACTION;
    PRINT 'Asignación aleatoria de especialidades por usuario exitosa.';

END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Ocurrió un error. La transacción fue revertida.';
    PRINT ERROR_MESSAGE();
END CATCH;

truncate table ficha_medica;

-- ============================================
-- INSERTAR FICHAS MÉDICAS PARA LOS 1000 PACIENTES
-- ============================================

BEGIN TRY
    BEGIN TRANSACTION;

    -- CTE para generar datos aleatorios de forma determinística por paciente
    WITH FichasAleatorias AS
    (
        SELECT
            p.id_paciente,

            DATEFROMPARTS(1980, 1, 1) AS FechaNacimiento,


            -- 2. Tipo Sanguíneo aleatorio: Se usa un CASE para evitar que CHOOSE devuelva NULL
            -- El CHOOSE original podía devolver NULL si el índice era 0 o mayor que 8,
            -- aunque el módulo se limitaba a 1-8, la generación de números en SQL a veces es tricky.
            -- Usamos un CASE que fuerza el índice a estar entre 1 y 8.
            CASE ABS(CHECKSUM(NEWID())) % 8 + 1
                WHEN 1 THEN 'A+'
                WHEN 2 THEN 'A-'
                WHEN 3 THEN 'B+'
                WHEN 4 THEN 'B-'
                WHEN 5 THEN 'AB+'
                WHEN 6 THEN 'AB-'
                WHEN 7 THEN 'O+'
                ELSE 'O-' -- El resto (solo 8)
            END AS tipo_sanguineo_aleatorio,

            -- 3. Estatura aleatoria entre 150 y 190
            CAST(ABS(CHECKSUM(NEWID())) % 41 + 150 AS INT) AS estatura_aleatoria,

            -- 4. Peso aleatorio entre 50.0 y 100.0 (FLOAT)
            CAST(RAND(CHECKSUM(NEWID())) * 50.0 + 50.0 AS FLOAT) AS peso_aleatoria
        FROM Paciente p
    )
    -- Insertar la Ficha_medica por cada paciente
    INSERT INTO Ficha_medica (id_paciente, fecha_creacion, tipo_sanguineo, estatura, peso)
    SELECT
        id_paciente,
        FechaNacimiento,
        tipo_sanguineo_aleatorio,
        estatura_aleatoria,
        peso_aleatoria
    FROM FichasAleatorias;

    COMMIT TRANSACTION;
    PRINT 'Inserción exitosa de Fichas Médicas para los 1000 pacientes. ';

END TRY
BEGIN CATCH
    -- Si algo falla, revertir todos los cambios
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
    PRINT 'Ocurrió un error al insertar las Fichas Médicas. La transacción fue revertida.';
    PRINT ERROR_MESSAGE();
END CATCH;