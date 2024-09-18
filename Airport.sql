-- GRUPO
-- Estudiante: Martínez Balderrama Aarón 
-- Reg: 221044957

-- Estudiante: Bartolome Ramos Hans Angelo 
-- Reg: 213037114

-- Estudiante: Vidal Lopez Daniela
-- Reg: 214058840


-- Creación de la base de datos
CREATE DATABASE airport;
USE airport;

-- Tabla: Customer (Clientes)
CREATE TABLE Customer (
    id INT IDENTITY(1,1) PRIMARY KEY,
    Date_of_Birth DATE NOT NULL CHECK (Date_of_Birth <= GETDATE()), -- La fecha de nacimiento debe ser en el pasado
    Name VARCHAR(200) NOT NULL CHECK (Name LIKE '%[A-Za-z ]%') -- Solo permite letras y espacios
);

-- Tabla: Airport (Aeropuertos)
CREATE TABLE Airport (
    id INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(200) NOT NULL CHECK (Name LIKE '%[A-Za-z0-9 ]%') -- Permite letras, números y espacios
);

-- Tabla: Plane_Model (Modelos de Aviones)
CREATE TABLE Plane_Model (
    id INT IDENTITY(1,1) PRIMARY KEY,
    Description VARCHAR(200) NOT NULL CHECK (Description LIKE '%[A-Za-z0-9 ]%'), -- Permite letras, números y espacios
    Graphic VARCHAR(200) NOT NULL
);

-- Tabla: Frequent_Flyer_Card (Tarjetas de Viajero Frecuente)
CREATE TABLE Frequent_Flyer_Card (
    FFC_Number INT IDENTITY(1,1) PRIMARY KEY,
    Miles INT NOT NULL CHECK (Miles >= 0), -- Las millas deben ser no negativas
    Meal_Code INT NOT NULL CHECK (Meal_Code >= 0), -- El código de comida debe ser no negativo
    Customer_id INT NOT NULL,
    FOREIGN KEY (Customer_id) REFERENCES Customer(id) 
        ON DELETE CASCADE ON UPDATE CASCADE -- Eliminación y actualización en cascada
);

-- Tabla: Airplane (Aviones)
CREATE TABLE Airplane (
    Registration_Number INT IDENTITY(1,1) PRIMARY KEY,
    Begin_of_Operation DATE NOT NULL CHECK (Begin_of_Operation <= GETDATE()), -- La fecha debe ser en el pasado o presente
    Status VARCHAR(200) NOT NULL CHECK (Status IN ('Operational', 'Maintenance', 'Decommissioned')), -- Valores limitados
    Plane_Model_id INT NULL, -- Permitir valores nulos
    FOREIGN KEY (Plane_Model_id) REFERENCES Plane_Model(id) 
        ON DELETE SET NULL ON UPDATE CASCADE -- Eliminación en cascada establece NULL, actualización en cascada
);

-- Tabla: Flight_Number (Números de Vuelo)
CREATE TABLE Flight_Number (
    id INT IDENTITY(1,1) PRIMARY KEY,
    Departure_Time TIME NOT NULL,
    Description VARCHAR(200) NOT NULL CHECK (Description LIKE '%[A-Za-z0-9 ]%'), -- Permite letras, números y espacios
    Type BIT NOT NULL CHECK (Type IN (0, 1)), -- Tipo debe ser 0 o 1
    Airline VARCHAR(200) NOT NULL,
    Airport_Start INT NOT NULL,
    Airport_Goal INT NOT NULL,
    FOREIGN KEY (Airport_Start) REFERENCES Airport(id) 
        ON DELETE NO ACTION ON UPDATE NO ACTION, -- Cambiado a NO ACTION para evitar ciclos
    FOREIGN KEY (Airport_Goal) REFERENCES Airport(id) 
        ON DELETE NO ACTION ON UPDATE NO ACTION -- Cambiado a NO ACTION para evitar ciclos
);

-- Tabla: Ticket (Boletos)
CREATE TABLE Ticket (
    Ticketing_Code INT IDENTITY(1,1) PRIMARY KEY,
    Number INT NOT NULL CHECK (Number > 0), -- Número de ticket debe ser positivo
    Customer_id INT NOT NULL,
    FOREIGN KEY (Customer_id) REFERENCES Customer(id) 
        ON DELETE CASCADE ON UPDATE CASCADE -- Eliminación y actualización en cascada
);

-- Tabla: Flight (Vuelos)
CREATE TABLE Flight (
    id INT IDENTITY(1,1) PRIMARY KEY,
    Boarding_Time TIME NOT NULL,
    Flight_Date DATE NOT NULL CHECK (Flight_Date >= GETDATE()), -- La fecha de vuelo debe ser presente o futura
    Gate TINYINT NOT NULL CHECK (Gate > 0), -- El número de puerta debe ser positivo
    Check_In_Counter BIT NOT NULL CHECK (Check_In_Counter IN (0, 1)), -- Valor binario
    Flight_Number_id INT NOT NULL,
    FOREIGN KEY (Flight_Number_id) REFERENCES Flight_Number(id) 
        ON DELETE NO ACTION ON UPDATE NO ACTION -- Cambiado a NO ACTION para evitar ciclos
);

-- Tabla: Seat (Asientos)
CREATE TABLE Seat (
    id INT IDENTITY(1,1) PRIMARY KEY,
    Size INT NOT NULL CHECK (Size > 0), -- El tamaño debe ser positivo
    Number INT NOT NULL CHECK (Number > 0), -- El número de asiento debe ser positivo
    Location VARCHAR(200) NOT NULL,
    Plane_Model_id INT NOT NULL,
    FOREIGN KEY (Plane_Model_id) REFERENCES Plane_Model(id) 
        ON DELETE NO ACTION ON UPDATE NO ACTION -- Cambiado a NO ACTION para evitar ciclos
);

-- Tabla: Available_Seat (Asientos Disponibles)
CREATE TABLE Available_Seat (
    id INT IDENTITY(1,1) PRIMARY KEY,
    Flight_id INT NOT NULL,
    Seat_id INT NOT NULL,
    FOREIGN KEY (Flight_id) REFERENCES Flight(id) 
        ON DELETE NO ACTION ON UPDATE NO ACTION, -- Cambiado a NO ACTION para evitar ciclos
    FOREIGN KEY (Seat_id) REFERENCES Seat(id) 
        ON DELETE NO ACTION ON UPDATE NO ACTION -- Cambiado a NO ACTION para evitar ciclos
);

-- Tabla: Coupon (Cupones)
CREATE TABLE Coupon (
    id INT IDENTITY(1,1) PRIMARY KEY,
    Date_of_Redemption DATE NOT NULL CHECK (Date_of_Redemption >= GETDATE()), -- La fecha de redención debe ser presente o futura
    Class VARCHAR(200) NOT NULL CHECK (Class IN ('Economy', 'Business', 'First')), -- Clases predefinidas
    Standby VARCHAR(200) NOT NULL CHECK (Standby IN ('Yes', 'No')), -- Standby debe ser 'Yes' o 'No'
    Meal_Code INT NOT NULL CHECK (Meal_Code >= 0), -- El código de comida debe ser no negativo
    Ticketing_Code INT NOT NULL,
    Available_Seat_id INT NOT NULL,
    Flight_id INT NOT NULL,
    FOREIGN KEY (Ticketing_Code) REFERENCES Ticket(Ticketing_Code) 
        ON DELETE NO ACTION ON UPDATE NO ACTION, -- Cambiado a NO ACTION para evitar ciclos
    FOREIGN KEY (Available_Seat_id) REFERENCES Available_Seat(id) 
        ON DELETE NO ACTION ON UPDATE NO ACTION, -- Cambiado a NO ACTION para evitar ciclos
    FOREIGN KEY (Flight_id) REFERENCES Flight(id) 
        ON DELETE NO ACTION ON UPDATE NO ACTION -- Cambiado a NO ACTION para evitar ciclos
);

-- Tabla: Pieces_of_Luggage (Piezas de Equipaje)
CREATE TABLE Pieces_of_Luggage (
    id INT IDENTITY(1,1) PRIMARY KEY,
    Number INT NOT NULL CHECK (Number > 0), -- El número de piezas debe ser positivo
    Weight INT NOT NULL CHECK (Weight > 0), -- El peso debe ser positivo
    Coupon_id INT NOT NULL,
    FOREIGN KEY (Coupon_id) REFERENCES Coupon(id) 
        ON DELETE NO ACTION ON UPDATE NO ACTION -- Cambiado a NO ACTION para evitar ciclos
);
-- MODIFICACION 1/*/*/*/*/**/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/**/*/*/
--##################################################################################################

-- Tabla: Clasificación_Pasajeros
CREATE TABLE Clasificacion_Pasajeros (
    id_clasificacion INT IDENTITY(1,1) PRIMARY KEY,
    Nivel VARCHAR(8) NOT NULL CHECK (Nivel IN ('Diamante', 'Platino', 'Oro', 'Plata','Ninguno')), -- Niveles predefinidos
    Fecha_Clasificacion DATE NOT NULL CHECK (Fecha_Clasificacion <= GETDATE()), -- Fecha de clasificación debe ser en el pasado o presente
	id_Customer INT,
	FOREIGN KEY (id_Customer) REFERENCES Customer(id)
   ON DELETE CASCADE ON UPDATE CASCADE -- Evita ciclos;
);
-- PROCEDIMIENTO ALMACENADO Y TRIGGERS NECESARIO
-- PA para calcular las millas de cada cliente con la tabla Frequent_Flyer_Card
go
CREATE FUNCTION dbo.CalcularMillasTotales(@id_clasificacion INT)
RETURNS INT
AS
BEGIN
    DECLARE @total_millas INT;
    
    SELECT @total_millas = SUM(Miles)
    FROM Frequent_Flyer_Card f, Clasificacion_Pasajeros c, Customer cu
    WHERE c.id_clasificacion=@id_clasificacion and cu.id=c.id_Customer and f.Customer_id=cu.id
    RETURN ISNULL(@total_millas, 0); -- Retorna 0 si no hay millas registradas
END;
go
go
--trigger para actualizar la membresia del cliente en la clasifiacion
CREATE TRIGGER dbo.Trigger_ActualizarClasificacion
ON Frequent_Flyer_Card
AFTER INSERT
AS
BEGIN
    DECLARE @id_clasificacion INT;
    DECLARE @total_millas INT;
    DECLARE @nuevo_nivel VARCHAR(8);

    -- Obtener el id_clasificacion del registro insertado
	DECLARE @FFC_Number INT;
	SELECT @FFC_Number = i.FFC_Number
	FROM INSERTED i;

	DECLARE @Customer_id INT;
	SELECT @Customer_id = c.id
	FROM  Customer  c, Frequent_Flyer_Card f
	WHERE  f.FFC_Number=@FFC_Number and f.Customer_id=c.id ;
	select * from Customer
	SELECT @id_clasificacion = c.id_clasificacion
	FROM  Clasificacion_Pasajeros c  
	WHERE c.id_Customer=@Customer_id 

    -- Calcular la suma total de millas para ese id_clasificacion
    SET @total_millas = dbo.CalcularMillasTotales(@id_clasificacion);

    -- Determinar el nuevo nivel basado en las millas
    IF @total_millas >= 200000
        SET @nuevo_nivel = 'Diamante';
    ELSE IF @total_millas >= 150000
        SET @nuevo_nivel = 'Platino';
    ELSE IF @total_millas >= 100000
        SET @nuevo_nivel = 'Oro';
    ELSE IF @total_millas >= 70000
        SET @nuevo_nivel = 'Plata';
    ELSE
        SET @nuevo_nivel = 'Ninguno'; -- Opcional, puede dejarlo vacío si no aplica un nivel específico

    -- Actualizar la tabla Clasificacion_Pasajeros con el nuevo nivel
    UPDATE Clasificacion_Pasajeros
    SET Nivel = @nuevo_nivel
    WHERE id_clasificacion = @id_clasificacion;
END;
go

-- MODIFICACION 2/*/*/*/*/**/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/**/*/*/
--##################################################################################################
CREATE TABLE Aerolineas (
    id_aerolinea INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(200) NOT NULL CHECK (nombre LIKE '%[A-Za-z0-9 ]%'), -- Permite letras, números y espacios
    codigo_icao CHAR(3) NOT NULL CHECK (codigo_icao LIKE '[A-Z][A-Z][A-Z]'), -- Exactamente 3 letras mayúsculas
    pais NVARCHAR(200) NOT NULL CHECK (pais LIKE '%[A-Za-z ]%') -- Solo permite letras y espacios
);
-- SE AÑADIRA EL ATRIBUTO ID_AIRLINE EN LA TABLA AIRPLANE para ver el avion a que aerolinea pertenece
-- Tabla: Aerolineas
ALTER TABLE Airplane
ADD id_airline INT NOT NULL;
alter table Airplane
add constraint fkairplane
foreign key (id_airline) references Aerolineas(id_aerolinea);

-- Tabla: tripulacion
CREATE TABLE Tripulacion (
    id_tripulacion INT IDENTITY(1,1) PRIMARY KEY,
    id_Flight INT NOT NULL , -- de la tabla vuelo
    FOREIGN KEY (id_Flight) REFERENCES Flight(id) 
        ON DELETE NO ACTION ON UPDATE NO ACTION -- Cambiado a NO ACTION para evitar ciclos
);

-- Tabla para Profesión
CREATE TABLE Profesion (
    id INT IDENTITY(1,1) PRIMARY KEY,      -- Identificador único de la profesión
    nombre VARCHAR(50) NOT NULL, -- Nombre de la profesión
    fecha_fin DATE               -- Fecha de finalización (opcional)
);

-- Tabla para Tripulante
CREATE TABLE Tripulante (
    cod INT IDENTITY(1,1) PRIMARY KEY,       -- Código único del tripulante
    nombre VARCHAR(100) NOT NULL, -- Nombre del tripulante
    edad INT,                     -- Edad del tripulante
    id_tripulacion INT REFERENCES Tripulacion(id_tripulacion), -- Llave foránea a la tabla Tripulación
    id_profesion INT REFERENCES Profesion(id) -- Llave foránea a la tabla Profesión
);



-- AÑADIMOS el atributo ESTADO EN LA TABLA seat(ASIENTO) la condicion de los asiento para ver si se pueden USAR
ALTER TABLE seat
add estado varchar(20) check (estado in('disponible','mantenimiento')); --estados predefinidos;
-- AÑADIMOS el atributo ESTADO EN LA TABLA Available_Seat(Asientos disponibles) son los asientos en buen estado que estan disponibles para su uso
ALTER TABLE Available_Seat
add estado varchar(20) check (estado in('disponible','ocupado')); --estados predefinidos;

--CREAMOS UNA TABLA TRAMO MAYOR DONDE SE COLOCARAN EL DESTINO Y ORIGEN PRINCIPAL DE CADA VUELO
create table Tramo_mayor(
id int identity  (1,1) not null primary key,
origen int not null,
destino int not null,
duracion time not null,
distancia int not null, --distancia en km o millas
foreign key (origen) references Airport(id),
foreign key (destino) references Airport(id)
)

--CREAMOS LA TABLA NUMERO DE TRAMO,ESTA TABLA INDICA EN QUE TRAMO REALIZO EL VUELO
create table Numero_tramo(
id int identity(1,1) not null primary key,
numero tinyint not null check(numero>0),
id_tramoMayor int not null,
foreign key (id_tramoMayor) references Tramo_mayor(id)
on delete  cascade on update  cascade
)

--AHORA AÑADIMOS LAS COLUMNAS FORANEAS TRAMO Y NUMERO DE TRAMO EN LA TABLA Flight (vuelo) 
alter table Flight
add id_tramo int not null,id_numeroTramo int not null;

alter table Flight
add constraint tramox
foreign key (id_tramo) references Tramo_mayor(id);

alter table Flight
add constraint tramoy
foreign key (id_numeroTramo) references Numero_tramo(id);

--CREAMOS UNA TABLA TRAMO Menor DONDE SE COLOCARAN EL DESTINO Y ORIGEN QUE SE ENCUENTRAN DENTRO DE UN TRAMO MAYOR ESPECIFICO
create table tramo_menor(
id int identity  (1,1) not null primary key,
origen int not null,
destino int not null,
duracion time not null,
distancia int not null, --distancia en km o millas
orden tinyint not null check (orden>0),
id_numeroTramo int not null,
foreign key (origen) references Airport(id),
foreign key (destino) references Airport(id),
foreign key (id_numeroTramo) references Numero_tramo(id)
on delete  cascade on update  cascade -- si se elimina una fila de la tabla numeroTramo, no es necesario tener los tramos menores
)

-- CREAMOS LA TABLA TICKET-TRANSFER - en el contexto de documentacion // cuando el comprador vende o se lo compra a otra pasajero
create table Ticker_Transfer(
id int not null identity(1,1) primary key,
id_ticket int not null,
id_comprador int not null,
id_pasajero int not null,
foreign key (id_ticket) references Ticket(Ticketing_Code)
on delete cascade on update cascade,
foreign key (id_comprador) references Customer(id)
on delete no action on update no action,
foreign key (id_pasajero) references Customer(id)
on delete no action on update no action,
)
--------------------------------------------------- INSERTS PARA CADA TABLA ------------------------------------------------------------------------
-- Crear 80,000 clientes
INSERT INTO Customer (Date_of_Birth, Name)
SELECT 
    DATEADD(DAY, -1 * (ABS(CHECKSUM(NEWID())) % 20000), GETDATE()), -- Fecha de nacimiento entre hace 55 años y hoy
    CONCAT('Cliente_', ROW_NUMBER() OVER (ORDER BY (SELECT NULL)))
FROM (SELECT TOP (80000) * FROM sys.all_objects) AS Temp;

-- Asignar clasificación a cada cliente
INSERT INTO Clasificacion_Pasajeros (Nivel, Fecha_Clasificacion, id_Customer)
SELECT
    'Ninguno', -- Nivel inicial
    GETDATE(), -- Fecha actual
    C.id
FROM Customer C;

-- Asignar una tarjeta de viajero frecuente al 50% de los clientes
INSERT INTO Frequent_Flyer_Card (Miles, Meal_Code, Customer_id)
SELECT
    ABS(CHECKSUM(NEWID())) % 100000, -- Millas acumuladas
    ABS(CHECKSUM(NEWID())) % 10,     -- Código de comida
    C.id
FROM Customer C
WHERE ABS(CHECKSUM(NEWID())) % 2 = 0;

-- Crear 50 aeropuertos
INSERT INTO Airport (Name)
SELECT CONCAT('Aeropuerto_', ROW_NUMBER() OVER (ORDER BY (SELECT NULL)))
FROM (SELECT TOP (50) * FROM sys.all_objects) AS Temp;

-- Crear 10 aerolíneas
INSERT INTO Aerolineas (nombre, codigo_icao, pais)
SELECT 
    CONCAT('Aerolínea_', ROW_NUMBER() OVER (ORDER BY (SELECT NULL))),
    CHAR(65 + ((ROW_NUMBER() OVER (ORDER BY (SELECT NULL))) % 26)) + 
    CHAR(65 + ((ROW_NUMBER() OVER (ORDER BY (SELECT NULL))) % 26)) + 
    CHAR(65 + ((ROW_NUMBER() OVER (ORDER BY (SELECT NULL))) % 26)),
    CONCAT('País_', ROW_NUMBER() OVER (ORDER BY (SELECT NULL)))
FROM (SELECT TOP (10) * FROM sys.all_objects) AS Temp;

-- Crear 20 modelos de avión
INSERT INTO Plane_Model (Description, Graphic)
SELECT 
    CONCAT('Modelo_', ROW_NUMBER() OVER (ORDER BY (SELECT NULL))),
    CONCAT('Gráfico_', ROW_NUMBER() OVER (ORDER BY (SELECT NULL)))
FROM (SELECT TOP (20) * FROM sys.all_objects) AS Temp;

-- Crear 100 aviones
INSERT INTO Airplane (Begin_of_Operation, Status, Plane_Model_id, id_airline)
SELECT
    DATEADD(DAY, -1 * (ABS(CHECKSUM(NEWID())) % 1000), GETDATE()), -- Fecha entre hace ~3 años y hoy
    CASE (ABS(CHECKSUM(NEWID())) % 3)
        WHEN 0 THEN 'Operational'
        WHEN 1 THEN 'Maintenance'
        ELSE 'Decommissioned'
    END,
    ABS(CHECKSUM(NEWID())) % 20 + 1, -- ID de modelo de avión entre 1 y 20
    ABS(CHECKSUM(NEWID())) % 10 + 1  -- ID de aerolínea entre 1 y 10
FROM (SELECT TOP (100) * FROM sys.all_objects) AS Temp;

-- Crear 2000 números de vuelo
INSERT INTO Flight_Number (Departure_Time, Description, Type, Airline, Airport_Start, Airport_Goal)
SELECT
    CONVERT(TIME, DATEADD(MINUTE, ABS(CHECKSUM(NEWID())) % 1440, '00:00')), -- Hora aleatoria
    CONCAT('Descripción vuelo_', ROW_NUMBER() OVER (ORDER BY (SELECT NULL))),
    ABS(CHECKSUM(NEWID())) % 2, -- Tipo 0 o 1
    A.nombre,
    ABS(CHECKSUM(NEWID())) % 50 + 1, -- ID de aeropuerto de inicio
    ABS(CHECKSUM(NEWID())) % 50 + 1  -- ID de aeropuerto de destino
FROM (SELECT TOP (2000) * FROM sys.all_objects) AS Temp
CROSS JOIN (SELECT id_aerolinea, nombre FROM Aerolineas) AS A;

-- Crear 100 tramos mayores
INSERT INTO Tramo_mayor (origen, destino, duracion, distancia)
SELECT
    ABS(CHECKSUM(NEWID())) % 50 + 1, -- Aeropuerto origen
    ABS(CHECKSUM(NEWID())) % 50 + 1, -- Aeropuerto destino
    CONVERT(TIME, DATEADD(MINUTE, ABS(CHECKSUM(NEWID())) % 480 + 60, '00:00')), -- Duración entre 1 y 8 horas
    ABS(CHECKSUM(NEWID())) % 10000 + 500 -- Distancia entre 500 y 10,500 km
FROM (SELECT TOP (100) * FROM sys.all_objects) AS Temp;

-- Crear 200 números de tramo
INSERT INTO Numero_tramo (numero, id_tramoMayor)
SELECT
    ROW_NUMBER() OVER (ORDER BY (SELECT NULL)),
    TM.id
FROM Tramo_mayor TM;

-- Crear vuelos y asignar a números de vuelo y tramos
INSERT INTO Flight (Boarding_Time, Flight_Date, Gate, Check_In_Counter, Flight_Number_id, id_tramo, id_numeroTramo)
SELECT
    CONVERT(TIME, DATEADD(MINUTE, ABS(CHECKSUM(NEWID())) % 60, FN.Departure_Time)), -- Hora de embarque
    DATEADD(DAY, ABS(CHECKSUM(NEWID())) % 730, GETDATE()), -- Fecha aleatoria en 2 años
    ABS(CHECKSUM(NEWID())) % 50 + 1, -- Gate
    ABS(CHECKSUM(NEWID())) % 2, -- Check-In Counter
    FN.id,
    TM.id,
    NT.id
FROM Flight_Number FN
CROSS APPLY (SELECT TOP 1 id FROM Tramo_mayor ORDER BY NEWID()) AS TM
CROSS APPLY (SELECT TOP 1 id FROM Numero_tramo WHERE id_tramoMayor = TM.id ORDER BY NEWID()) AS NT;

-- Crear tramos menores
INSERT INTO tramo_menor (origen, destino, duracion, distancia, orden, id_numeroTramo)
SELECT
    ABS(CHECKSUM(NEWID())) % 50 + 1, -- Aeropuerto origen
    ABS(CHECKSUM(NEWID())) % 50 + 1, -- Aeropuerto destino
    CONVERT(TIME, DATEADD(MINUTE, ABS(CHECKSUM(NEWID())) % 180 + 30, '00:00')), -- Duración entre 30 min y 3 horas
    ABS(CHECKSUM(NEWID())) % 3000 + 100, -- Distancia entre 100 y 3100 km
    ROW_NUMBER() OVER (PARTITION BY NT.id ORDER BY (SELECT NULL)),
    NT.id
FROM Numero_tramo NT
CROSS APPLY (SELECT TOP (ABS(CHECKSUM(NEWID())) % 3 + 1) * FROM sys.all_objects) AS T; -- Cada tramo mayor tiene entre 1 y 3 tramos menores

-- Crear asientos para cada modelo de avión
INSERT INTO Seat (Size, Number, Location, Plane_Model_id, estado)
SELECT
    ABS(CHECKSUM(NEWID())) % 3 + 1, -- Tamaño entre 1 y 3
    ROW_NUMBER() OVER (ORDER BY (SELECT NULL)), -- Número de asiento
    CASE (ABS(CHECKSUM(NEWID())) % 3)
        WHEN 0 THEN 'Ventana'
        WHEN 1 THEN 'Pasillo'
        ELSE 'Centro'
    END,
    PM.id,
    'disponible'
FROM Plane_Model PM
CROSS APPLY (
    SELECT TOP (ABS(CHECKSUM(NEWID())) % 100 + 100) * FROM sys.all_objects
) AS Seats;

-- Asignar asientos disponibles a cada vuelo
INSERT INTO Available_Seat (Flight_id, Seat_id, estado)
SELECT
    F.id,
    S.id,
    'disponible'
FROM Flight F
JOIN Airplane A ON A.id = ABS(CHECKSUM(NEWID())) % 100 + 1 -- Asignar avión al vuelo
JOIN Seat S ON S.Plane_Model_id = A.Plane_Model_id
WHERE S.estado = 'disponible';

-- Crear 200,000 boletos
INSERT INTO Ticket (Number, Customer_id)
SELECT
    ROW_NUMBER() OVER (ORDER BY (SELECT NULL)),
    C.id
FROM Customer C
CROSS APPLY (SELECT TOP (ABS(CHECKSUM(NEWID())) % 3 + 1) * FROM sys.all_objects) AS T -- Cada cliente compra entre 1 y 3 boletos
WHERE ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) <= 200000;

-- Asignar cupones a los tickets y asientos disponibles
INSERT INTO Coupon (Date_of_Redemption, Class, Standby, Meal_Code, Ticketing_Code, Available_Seat_id, Flight_id)
SELECT
    DATEADD(DAY, ABS(CHECKSUM(NEWID())) % 730, GETDATE()), -- Fecha de redención
    CASE (ABS(CHECKSUM(NEWID())) % 3)
        WHEN 0 THEN 'Economy'
        WHEN 1 THEN 'Business'
        ELSE 'First'
    END,
    CASE (ABS(CHECKSUM(NEWID())) % 2)
        WHEN 0 THEN 'Yes'
        ELSE 'No'
    END,
    ABS(CHECKSUM(NEWID())) % 10, -- Código de comida
    ROW_NUMBER() OVER (ORDER BY (SELECT NULL)), -- Código de ticket
    AS.id, -- Asiento disponible
    F.id -- Vuelo
FROM Ticket T
JOIN Available_Seat AS ON AS.estado = 'disponible'
JOIN Flight F ON F.id = AS.Flight_id;

