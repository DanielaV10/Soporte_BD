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

-- Tabla: Aerolineas
CREATE TABLE Aerolineas (
    id_aerolinea INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(200) NOT NULL CHECK (nombre LIKE '%[A-Za-z0-9 ]%'), -- Permite letras, números y espacios
    codigo_icao CHAR(3) NOT NULL CHECK (codigo_icao LIKE '[A-Z][A-Z][A-Z]'), -- Exactamente 3 letras mayúsculas
    pais NVARCHAR(200) NOT NULL CHECK (pais LIKE '%[A-Za-z ]%') -- Solo permite letras y espacios
);

-- Tabla: Aviones
CREATE TABLE Aviones (
    id_avion INT IDENTITY(1,1) PRIMARY KEY,
    modelo NVARCHAR(200) NOT NULL CHECK (modelo LIKE '%[A-Za-z0-9 ]%'), -- Permite letras, números y espacios
    capacidad INT NOT NULL CHECK (capacidad > 0), -- La capacidad debe ser positiva
    id_aerolinea INT,
    FOREIGN KEY (id_aerolinea) REFERENCES Aerolineas(id_aerolinea) 
        ON DELETE NO ACTION ON UPDATE NO ACTION -- Cambiado a NO ACTION para evitar ciclos
);

-- Tabla: Pilotos
CREATE TABLE Pilotos (
    id_piloto INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(200) NOT NULL CHECK (nombre LIKE '%[A-Za-z ]%'), -- Solo permite letras y espacios
    licencia NVARCHAR(50) NOT NULL CHECK (licencia LIKE '%[A-Za-z0-9 ]%'), -- Permite letras, números y espacios
    id_aerolinea INT,
    FOREIGN KEY (id_aerolinea) REFERENCES Aerolineas(id_aerolinea) 
        ON DELETE NO ACTION ON UPDATE NO ACTION -- Cambiado a NO ACTION para evitar ciclos
);

-- Tabla: Tripulacion
CREATE TABLE Tripulacion (
    id_tripulacion INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(200) NOT NULL CHECK (nombre LIKE '%[A-Za-z ]%'), -- Solo permite letras y espacios
    id_aerolinea INT,
    FOREIGN KEY (id_aerolinea) REFERENCES Aerolineas(id_aerolinea) 
        ON DELETE NO ACTION ON UPDATE NO ACTION -- Cambiado a NO ACTION para evitar ciclos
);

-- Tabla: Vuelos
CREATE TABLE Vuelos (
    id_vuelo INT IDENTITY(1,1) PRIMARY KEY,
    numero_vuelo NVARCHAR(50) NOT NULL CHECK (numero_vuelo LIKE '%[A-Za-z0-9 ]%'), -- Permite letras, números y espacios
    fecha DATE NOT NULL CHECK (fecha >= GETDATE()), -- La fecha debe ser presente o futura
    hora TIME NOT NULL,
    origen NVARCHAR(200) NOT NULL CHECK (origen LIKE '%[A-Za-z0-9 ]%'), -- Permite letras, números y espacios
    destino NVARCHAR(200) NOT NULL CHECK (destino LIKE '%[A-Za-z0-9 ]%'), -- Permite letras, números y espacios
    id_avion INT,
    id_piloto INT,
    FOREIGN KEY (id_avion) REFERENCES Aviones(id_avion) 
        ON DELETE NO ACTION ON UPDATE NO ACTION, -- Cambiado a NO ACTION para evitar ciclos
    FOREIGN KEY (id_piloto) REFERENCES Pilotos(id_piloto) 
        ON DELETE NO ACTION ON UPDATE NO ACTION -- Cambiado a NO ACTION para evitar ciclos
);

-- Tabla: Asientos Disponibles en Vuelos
CREATE TABLE Asientos_Disponibles (
    id_asiento_disponible INT IDENTITY(1,1) PRIMARY KEY,
    numero_asiento NVARCHAR(10) NOT NULL CHECK (numero_asiento LIKE '%[A-Za-z0-9 ]%'), -- Permite letras, números y espacios
    clase NVARCHAR(50) NOT NULL CHECK (clase IN ('Economy', 'Business', 'First')), -- Clases predefinidas
    id_vuelo INT,
    FOREIGN KEY (id_vuelo) REFERENCES Vuelos(id_vuelo) 
        ON DELETE NO ACTION ON UPDATE NO ACTION -- Cambiado a NO ACTION para evitar ciclos
);

-- Tabla: Boletos en Vuelos
CREATE TABLE Boletos_Vuelos (
    id_boleto INT IDENTITY(1,1) PRIMARY KEY,
    codigo_boleto NVARCHAR(50) NOT NULL CHECK (codigo_boleto LIKE '%[A-Za-z0-9 ]%'), -- Permite letras, números y espacios
    fecha_emision DATE NOT NULL CHECK (fecha_emision <= GETDATE()), -- La fecha de emisión debe ser en el pasado o presente
    id_vuelo INT,
    id_cliente INT,
    id_asiento_disponible INT,
    FOREIGN KEY (id_vuelo) REFERENCES Vuelos(id_vuelo) 
        ON DELETE NO ACTION ON UPDATE NO ACTION, -- Cambiado a NO ACTION para evitar ciclos
    FOREIGN KEY (id_cliente) REFERENCES Customer(id) 
        ON DELETE NO ACTION ON UPDATE NO ACTION, -- Cambiado a NO ACTION para evitar ciclos
    FOREIGN KEY (id_asiento_disponible) REFERENCES Asientos_Disponibles(id_asiento_disponible) 
        ON DELETE NO ACTION ON UPDATE NO ACTION -- Cambiado a NO ACTION para evitar ciclos
);





--------------------------------------------------- INSERTS PARA CADA TABLA ------------------------------------------------------------------------
-- Inserciones para la tabla Customer
INSERT INTO Customer (Date_of_Birth, Name) VALUES ('1985-06-15', 'Juan Pérez');
INSERT INTO Customer (Date_of_Birth, Name) VALUES ('1990-12-01', 'María López');
INSERT INTO Customer (Date_of_Birth, Name) VALUES ('1978-04-22', 'Carlos García');

-- Inserciones para la tabla Airport
INSERT INTO Airport (Name) VALUES ('JFK International Airport');
INSERT INTO Airport (Name) VALUES ('Los Angeles International Airport');
INSERT INTO Airport (Name) VALUES ('Chicago Hare International Airport');

-- Inserciones para la tabla Plane_Model
INSERT INTO Plane_Model (Description, Graphic) VALUES ('Boeing 737', 'boeing737.jpg');
INSERT INTO Plane_Model (Description, Graphic) VALUES ('Airbus A320', 'airbusA320.jpg');
INSERT INTO Plane_Model (Description, Graphic) VALUES ('Boeing 747', 'boeing747.jpg');

-- Inserciones para la tabla Frequent_Flyer_Card
INSERT INTO Frequent_Flyer_Card (Miles, Meal_Code, Customer_id) VALUES (50000, 2, 1);
INSERT INTO Frequent_Flyer_Card (Miles, Meal_Code, Customer_id) VALUES (75000, 3, 2);
INSERT INTO Frequent_Flyer_Card (Miles, Meal_Code, Customer_id) VALUES (120000, 1, 3);

-- Inserciones para la tabla Airplane
INSERT INTO Airplane (Begin_of_Operation, Status, Plane_Model_id) VALUES ('2015-03-15', 'Operational', 1);
INSERT INTO Airplane (Begin_of_Operation, Status, Plane_Model_id) VALUES ('2018-07-10', 'Maintenance', 2);
INSERT INTO Airplane (Begin_of_Operation, Status, Plane_Model_id) VALUES ('2020-01-25', 'Operational', 3);

-- Inserciones para la tabla Flight_Number
INSERT INTO Flight_Number (Departure_Time, Description, Type, Airline, Airport_Start, Airport_Goal) VALUES ('06:30:00', 'NY to LA', 0, 'American Airlines', 1, 2);
INSERT INTO Flight_Number (Departure_Time, Description, Type, Airline, Airport_Start, Airport_Goal) VALUES ('14:45:00', 'LA to Chicago', 1, 'United Airlines', 2, 3);
INSERT INTO Flight_Number (Departure_Time, Description, Type, Airline, Airport_Start, Airport_Goal) VALUES ('09:00:00', 'Chicago to NY', 0, 'Delta Airlines', 3, 1);

-- Inserciones para la tabla Ticket
INSERT INTO Ticket (Number, Customer_id) VALUES (101, 1);
INSERT INTO Ticket (Number, Customer_id) VALUES (102, 2);
INSERT INTO Ticket (Number, Customer_id) VALUES (103, 3);

-- Inserciones para la tabla Flight
INSERT INTO Flight (Boarding_Time, Flight_Date, Gate, Check_In_Counter, Flight_Number_id) VALUES ('05:30:00', '2024-09-15', 12, 1, 1);
INSERT INTO Flight (Boarding_Time, Flight_Date, Gate, Check_In_Counter, Flight_Number_id) VALUES ('13:45:00', '2024-09-16', 5, 0, 2);
INSERT INTO Flight (Boarding_Time, Flight_Date, Gate, Check_In_Counter, Flight_Number_id) VALUES ('08:00:00', '2024-09-17', 3, 1, 3);

-- Inserciones para la tabla Seat
INSERT INTO Seat (Size, Number, Location, Plane_Model_id) VALUES (18, 25, 'Window', 1); 
INSERT INTO Seat (Size, Number, Location, Plane_Model_id) VALUES (20, 10, 'Aisle', 2); 
INSERT INTO Seat (Size, Number, Location, Plane_Model_id) VALUES (19, 7, 'Middle', 3); 

-- Inserciones para la tabla Available_Seat
INSERT INTO Available_Seat (Flight_id, Seat_id) VALUES (1, 1);
INSERT INTO Available_Seat (Flight_id, Seat_id) VALUES (2, 2);
INSERT INTO Available_Seat (Flight_id, Seat_id) VALUES (3, 3);

-- Inserciones para la tabla Coupon
INSERT INTO Coupon (Date_of_Redemption, Class, Standby, Meal_Code, Ticketing_Code, Available_Seat_id, Flight_id) VALUES ('2024-09-15', 'Economy', 'No', 2, 1, 1, 1);
INSERT INTO Coupon (Date_of_Redemption, Class, Standby, Meal_Code, Ticketing_Code, Available_Seat_id, Flight_id) VALUES ('2024-09-16', 'Business', 'Yes', 3, 2, 2, 2);
INSERT INTO Coupon (Date_of_Redemption, Class, Standby, Meal_Code, Ticketing_Code, Available_Seat_id, Flight_id) VALUES ('2024-09-17', 'First', 'No', 1, 3, 3, 3);

-- Inserciones para la tabla Pieces_of_Luggage
INSERT INTO Pieces_of_Luggage (Number, Weight, Coupon_id) VALUES (2, 30, 1);
INSERT INTO Pieces_of_Luggage (Number, Weight, Coupon_id) VALUES (1, 25, 2);
INSERT INTO Pieces_of_Luggage (Number, Weight, Coupon_id) VALUES (3, 45, 3);

-- Inserciones para la tabla Aerolineas
INSERT INTO Aerolineas (nombre, codigo_icao, pais) VALUES ('American Airlines', 'AAL', 'United States');
INSERT INTO Aerolineas (nombre, codigo_icao, pais) VALUES ('United Airlines', 'UAL', 'United States');
INSERT INTO Aerolineas (nombre, codigo_icao, pais) VALUES ('Delta Airlines', 'DAL', 'United States');

-- Inserciones para la tabla Aviones
INSERT INTO Aviones (modelo, capacidad, id_aerolinea) VALUES ('Boeing 737', 160, 1);
INSERT INTO Aviones (modelo, capacidad, id_aerolinea) VALUES ('Airbus A320', 180, 2);
INSERT INTO Aviones (modelo, capacidad, id_aerolinea) VALUES ('Boeing 747', 400, 3);

-- Inserciones para la tabla Pilotos
INSERT INTO Pilotos (nombre, licencia, id_aerolinea) VALUES ('John Smith', 'AA12345', 1);
INSERT INTO Pilotos (nombre, licencia, id_aerolinea) VALUES ('David Johnson', 'UA54321', 2);
INSERT INTO Pilotos (nombre, licencia, id_aerolinea) VALUES ('Michael Brown', 'DA98765', 3);

-- Inserciones para la tabla Tripulacion
INSERT INTO Tripulacion (nombre, id_aerolinea) VALUES ('Crew A', 1);
INSERT INTO Tripulacion (nombre, id_aerolinea) VALUES ('Crew B', 2);
INSERT INTO Tripulacion (nombre, id_aerolinea) VALUES ('Crew C', 3);

-- Inserciones para la tabla Vuelos
INSERT INTO Vuelos (numero_vuelo, fecha, hora, origen, destino, id_avion, id_piloto) VALUES ('AA100', '2024-09-15', '06:30:00', 'New York', 'Los Angeles', 1, 1);
INSERT INTO Vuelos (numero_vuelo, fecha, hora, origen, destino, id_avion, id_piloto) VALUES ('UA200', '2024-09-16', '14:45:00', 'Los Angeles', 'Chicago', 2, 2);
INSERT INTO Vuelos (numero_vuelo, fecha, hora, origen, destino, id_avion, id_piloto) VALUES ('DL300', '2024-09-17', '09:00:00', 'Chicago', 'New York', 3, 3);

-- Inserciones para la tabla Asientos_Disponibles
INSERT INTO Asientos_Disponibles (numero_asiento, clase, id_vuelo) VALUES ('25A', 'Economy', 1);
INSERT INTO Asientos_Disponibles (numero_asiento, clase, id_vuelo) VALUES ('10B', 'Business', 2);
INSERT INTO Asientos_Disponibles (numero_asiento, clase, id_vuelo) VALUES ('7C', 'First', 3);

-- Inserciones para la tabla Boletos_Vuelos
INSERT INTO Boletos_Vuelos (codigo_boleto, fecha_emision, id_vuelo, id_cliente, id_asiento_disponible) VALUES ('AA100-001', '2024-09-01', 1, 1, 1);
INSERT INTO Boletos_Vuelos (codigo_boleto, fecha_emision, id_vuelo, id_cliente, id_asiento_disponible) VALUES ('UA200-002', '2024-09-02', 2, 2, 2);
INSERT INTO Boletos_Vuelos (codigo_boleto, fecha_emision, id_vuelo, id_cliente, id_asiento_disponible) VALUES ('DL300-003', '2024-09-03', 3, 3, 3);

