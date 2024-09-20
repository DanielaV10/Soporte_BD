USE master;
ALTER DATABASE airport SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
drop database airport;

create database airport;
use airport;

-- 1. Cliente
create table Cliente(
    id_cliente int identity(1,1) primary key,
    Fecha_de_Nacimiento date not null,
    Nombre varchar(100) not null
);

-- 2. Aeropuerto
create table Aeropuerto(
    id_aereopuerto int identity(1,1) primary key,
    Nombre varchar(100) not null
);

-- 3. Modelo de Avion
create table Modelo_Avion(
    id_modelo_avion int identity(1,1) primary key,
    Descripcion varchar(100) not null,
    Grafico varchar(100) not null
);

-- 4. Avion
create table Avion(
    id_Numero_Registro int identity(1,1) primary key,
    Inicio_de_Operacion date not null,
    Estado varchar(100) not null,
    Modelo_Avion_id int not null,
    foreign key (Modelo_Avion_id) references Modelo_Avion(id_modelo_avion)
);

-- 5. Numero de Vuelo
create table Numero_Vuelo(
    id_numero_vuelo int identity(1,1) primary key,
    Hora_Salida time not null,
    Descripcion varchar(100) not null,
    Tipo bit not null,
    Aerolinea varchar(100) not null,
    Aeropuerto_Inicio int not null,
    Aeropuerto_Destino int not null,
    foreign key (Aeropuerto_Inicio) references Aeropuerto(id_aereopuerto),
    foreign key (Aeropuerto_Destino) references Aeropuerto(id_aereopuerto)
);

-- 6. Vuelo
create table Vuelo(
    id_vuelo int identity(1,1) primary key,
    Hora_Embarque time not null,
    Fecha_Vuelo date not null,
    Puerta tinyint not null,
    Mostrador_Check_In bit not null,
    Numero_Vuelo_id int not null,
    foreign key (Numero_Vuelo_id) references Numero_Vuelo(id_numero_vuelo)
);

-- 7. Asiento
create table Asiento(
    id_asiento int identity(1,1) primary key,
    Tamano int not null,
    Numero int not null,
    Ubicacion varchar(100) not null,
    Modelo_Avion_id int not null,
    foreign key (Modelo_Avion_id) references Modelo_Avion(id_modelo_avion)
);

-- 8. Asiento Disponible
create table Asiento_Disponible(
    id_asiento_disponible int identity(1,1) primary key,
    Vuelo_id int not null,
    Asiento_id int not null,
    foreign key (Vuelo_id) references Vuelo(id_vuelo),
    foreign key (Asiento_id) references Asiento(id_asiento)
);

-- 9. Reserva
create table Reserva(
    id_reserva int identity(1,1) primary key,
    Cliente_id int not null,
    Fecha_Reserva date not null,
    foreign key (Cliente_id) references Cliente(id_cliente)
);

-- 10. Boleto
create table Boleto(
    id_Codigo_Boleto int identity(1,1) primary key,
    Numero int not null,
    Cliente_id int not null,
    Reserva_id int null,
    foreign key (Cliente_id) references Cliente(id_cliente),
    foreign key (Reserva_id) references Reserva(id_reserva)
);

-- 21. Escalas TABLA AÑADIDA RESEINTEMENTE
create table Escala (
    id_escala int identity(1,1) primary key, -- Identificador único de la escala
    id_boleto int not null,                   -- Boleto al que pertenece la escala
    id_vuelo int not null,                    -- Vuelo específico de esta escala
    Orden tinyint not null,                   -- Orden de la escala dentro del trayecto (1 para el primer vuelo, 2 para el segundo, etc.)
    foreign key (id_boleto) references Boleto(id_Codigo_Boleto),
    foreign key (id_vuelo) references Vuelo(id_vuelo)
);

-- 11. Cupon
create table Cupon(
    id_cupon int identity(1,1) primary key,
    Fecha_Redencion date not null,
    Clase varchar(100) not null,
    Standby varchar(100) not null,
    Codigo_Comida int not null,
    Codigo_Boleto int not null,
    Asiento_Disponible_id int not null,
    Vuelo_id int not null,
    Checkin_Hora time, -- Se agregó el campo para el check-in
    Checkin_Fecha date, -- Se agregó el campo para el check-in
    foreign key (Codigo_Boleto) references Boleto(id_Codigo_Boleto),
    foreign key (Asiento_Disponible_id) references Asiento_Disponible(id_asiento_disponible),
    foreign key (Vuelo_id) references Vuelo(id_vuelo)
);

-- 12. Piezas de Equipaje
create table Piezas_de_Equipaje(
    id_piezas_equipaje int identity(1,1) primary key,
    Numero int not null,
    Peso int not null,
    Cupon_id int not null,
    foreign key (Cupon_id) references Cupon(id_cupon)
);

-- 13. Tarjeta Viajero Frecuente
create table Tarjeta_Viajero_Frecuente(
    id_Numero_Tarjeta int identity(1,1) primary key,
    Millas int not null,
    Codigo_Comida int not null,
    Cliente_id int not null,
    foreign key (Cliente_id) references Cliente(id_cliente)
);

-- 14. Documentacion
create table Documentacion(
    id_documentacion int identity(1,1) primary key,
    Tipo_Documento varchar(100) not null,
    Numero_Documento varchar(100) not null,
    id_boleto int not null,
    foreign key (id_boleto) references Boleto(id_Codigo_Boleto)
);

-- 15. Rol de Tripulación
create table Rol(
    id_rol int identity(1,1) primary key,
    Descripcion varchar(100) not null
);

-- 16. Tripulación
create table Tripulacion(
    id_tripulacion int identity(1,1) primary key,
    Nombre varchar(100) not null,
    Cargo varchar(100) not null
);

-- 17. Tripulación en Vuelo
create table Tripulacion_Vuelo(
    Vuelo_id int not null,
    Tripulacion_id int not null,
    Rol_id int not null,
    foreign key (Vuelo_id) references Vuelo(id_vuelo),
    foreign key (Tripulacion_id) references Tripulacion(id_tripulacion),
    foreign key (Rol_id) references Rol(id_rol),
    primary key (Vuelo_id, Tripulacion_id, Rol_id)
);

-- 18. Avion en Vuelo (nueva tabla para asignación de aeronaves a cada vuelo)
create table Avion_Vuelo(
    id_avion_vuelo int identity(1,1) primary key,
    id_vuelo int not null,
    id_numero_registro int not null, -- Asociado a la aeronave específica
    foreign key (id_vuelo) references Vuelo(id_vuelo),
    foreign key (id_numero_registro) references Avion(id_Numero_Registro)
);

-- 19. Cancelación
create table Cancelacion(
    id_cancelacion int identity(1,1) primary key,
    Tipo_Cancelacion varchar(100) not null,
    Fecha_Cancelacion date not null,
    Motivo varchar(255) not null,
    id_reserva int, -- Si es una cancelación de reserva
    id_vuelo int,   -- Si es una cancelación de vuelo
    foreign key (id_reserva) references Reserva(id_reserva),
    foreign key (id_vuelo) references Vuelo(id_vuelo)
);

-- 20. Multa por Cancelación
create table Multa_Cancelacion(
    id_multa int identity(1,1) primary key,
    id_cancelacion int not null,
    Monto decimal(10,2) not null,
    Fecha_Pago date,
    foreign key (id_cancelacion) references Cancelacion(id_cancelacion)
);
-------------------------------------------PROCESOS ALMACENADOS------------------------------------------------------------------
CREATE PROCEDURE CrearReservaConBoleto
    @Cliente_id INT,
    @Fecha_Reserva DATE,
    @NumeroBoletos INT  -- Cantidad de boletos que se quieren reservar
AS
BEGIN
    -- Verificar que haya suficientes boletos disponibles
    IF (SELECT COUNT(*) FROM Boleto WHERE Reserva_id IS NULL) >= @NumeroBoletos
    BEGIN
        -- Insertar nueva reserva
        INSERT INTO Reserva (Cliente_id, Fecha_Reserva)
        VALUES (@Cliente_id, @Fecha_Reserva);
        
        DECLARE @Reserva_id INT = SCOPE_IDENTITY();  -- Obtener el ID de la reserva creada
        
        -- Asignar boletos a la reserva
        UPDATE TOP (@NumeroBoletos) Boleto
        SET Reserva_id = @Reserva_id
        WHERE Reserva_id IS NULL;
    END
    ELSE
    BEGIN
        RAISERROR ('No hay suficientes boletos disponibles para realizar la reserva.', 16, 1);
    END
END;









-------------------------------------------INSERCIONES MASIVAS (ARRANQUE) PARTE #1-------------------------------------------------------
-- Por favor inserten los datos paso por paso para evitar un error en la insercion



--PASO #1 Insercion de 5 modelos de avion, por lo general hay de 2 a 3 en los aereopuertos
INSERT INTO Modelo_Avion (Descripcion, Grafico)
VALUES 
('Boeing 737', 'grafico_boeing737.png'),
('Airbus A320', 'grafico_airbusa320.png'),
('Embraer 190', 'grafico_embraer190.png'),
('Boeing 787', 'grafico_boeing787.png'),
('Airbus A350', 'grafico_airbusa350.png');

-- Modelo_Avion
DECLARE @i int = 1
WHILE @i <= 10
BEGIN
    INSERT INTO Modelo_Avion (Descripcion, Grafico)
    VALUES ('Modelo ' + CONVERT(varchar, @i), 'Grafico ' + CONVERT(varchar, @i))
    SET @i = @i + 1
END



-- Paso #2 insercion de 10 aereopuertos
INSERT INTO Aeropuerto (Nombre)
VALUES 
('Aeropuerto Internacional de Ciudad de México'),
('Aeropuerto Internacional de Los Ángeles'),
('Aeropuerto Internacional de Miami'),
('Aeropuerto Internacional de Tokio'),
('Aeropuerto Internacional de París-Charles de Gaulle'),
('Aeropuerto Internacional de Madrid-Barajas'),
('Aeropuerto Internacional de Londres-Heathrow'),
('Aeropuerto Internacional de Frankfurt'),
('Aeropuerto Internacional de Dubai'),
('Aeropuerto Internacional de Singapur-Changi');

---- Tarjeta_Viajero_Frecuente
DECLARE @i int = 1
WHILE @i <= 200
BEGIN
    INSERT INTO Tarjeta_Viajero_Frecuente (Millas, Codigo_Comida, Cliente_id)
    VALUES (ABS(CHECKSUM(NEWID())) % 10000, ABS(CHECKSUM(NEWID())) % 100, ABS(CHECKSUM(NEWID())) % 500 + 1)
    SET @i = @i + 1
END

-- Rol
DECLARE @i int = 1
WHILE @i <= 5
BEGIN
    INSERT INTO Rol (Descripcion)
    VALUES ('Rol ' + CONVERT(varchar, @i))
    SET @i = @i + 1
END

-- Tripulacion
DECLARE @i int = 1
WHILE @i <= 50
BEGIN
    INSERT INTO Tripulacion (Nombre, Cargo)
    VALUES ('Tripulante ' + CONVERT(varchar, @i), 'Cargo ' + CONVERT(varchar, @i))
    SET @i = @i + 1
END

-- Paso#3 Insercion de 1000 de 51000 primera prueba clientes
DECLARE @i INT = 1;
WHILE @i <= 1000
BEGIN
    INSERT INTO Cliente (Fecha_de_Nacimiento, Nombre)
    VALUES (
        DATEADD(YEAR, -ABS(CHECKSUM(NEWID()) % 60 + 18), GETDATE()), -- Fecha de nacimiento aleatoria entre 18 y 78 años
        CONCAT('Cliente', @i)
    );
    SET @i = @i + 1;
END;

-- Paso #4 Insercion de 300 aviones iniciales para arrancar bien
DECLARE @i INT = 1;
WHILE @i <= 300
BEGIN
    INSERT INTO Avion (Inicio_de_Operacion, Estado, Modelo_Avion_id)
    VALUES (
        DATEADD(DAY, -ABS(CHECKSUM(NEWID()) % 730), GETDATE()),  -- Fecha aleatoria en los últimos 2 años
        'Operativo', 
        ABS(CHECKSUM(NEWID()) % 5) + 1 -- Modelo aleatorio entre 5 modelos
    );
    SET @i = @i + 1;
END;

-- Poblar numero de vuelo inicialmente con 500 despues hasta llegar a 2000
DECLARE @i INT = 1;
WHILE @i <= 500
BEGIN
    INSERT INTO Numero_Vuelo (Hora_Salida, Descripcion, Tipo, Aerolinea, Aeropuerto_Inicio, Aeropuerto_Destino)
    VALUES (
        CONVERT(TIME, DATEADD(SECOND, ABS(CHECKSUM(NEWID()) % 86400), 0)),  -- Hora aleatoria
        CONCAT('Vuelo', @i),
        ABS(CHECKSUM(NEWID()) % 2), -- Tipo aleatorio
        'Aerolinea' + CONVERT(VARCHAR, ABS(CHECKSUM(NEWID()) % 10) + 1), -- Nombre aleatorio de aerolínea
        ABS(CHECKSUM(NEWID()) % 10) + 1, -- Aeropuerto de inicio aleatorio entre 10
        ABS(CHECKSUM(NEWID()) % 10) + 1  -- Aeropuerto de destino aleatorio entre 10
    );
    SET @i = @i + 1;
END;


---------------------------------- INSERCIONES MASIVAS 2DA PARTE-------------------------------------------------------------
SELECT COUNT(*) FROM Asiento;

--PASO#1 INSERTANDO 2000 vuelos
DECLARE @i INT;
SET @i = 1;
WHILE @i <= 2000
BEGIN
    INSERT INTO Vuelo (Hora_Embarque, Fecha_Vuelo, Puerta, Mostrador_Check_In, Numero_Vuelo_id)
    VALUES (
        CONVERT(TIME, DATEADD(SECOND, ABS(CHECKSUM(NEWID()) % 86400), 0)),  -- Hora aleatoria
        DATEADD(DAY, ABS(CHECKSUM(NEWID()) % 730), GETDATE()),  -- Fecha aleatoria en los próximos 2 años
        ABS(CHECKSUM(NEWID()) % 20) + 1, -- Puerta aleatoria
        ABS(CHECKSUM(NEWID()) % 2), -- Mostrador Check-In aleatorio (0 o 1)
        ABS(CHECKSUM(NEWID()) % 500) + 1 -- Numero de vuelo entre 1 y 500
    );
    SET @i = @i + 1;
END;

--PASO#2 Insertar 51000 Clientes
DECLARE @i INT;
SET @i = 1;
WHILE @i <= 50000
BEGIN
    INSERT INTO Cliente (Fecha_de_Nacimiento, Nombre)
    VALUES (
        DATEADD(YEAR, -ABS(CHECKSUM(NEWID()) % 80 + 18), GETDATE()),  -- Fecha de nacimiento aleatoria (18-80 años)
        LEFT(NEWID(), 30)  -- Nombre aleatorio
    );
    SET @i = @i + 1;
END;


-- Asiento
DECLARE @i int = 1
WHILE @i <= 100
BEGIN
    INSERT INTO Asiento (Tamano, Numero, Ubicacion, Modelo_Avion_id)
    VALUES (ABS(CHECKSUM(NEWID())) % 10 + 1, @i, 'Ubicacion ' + CONVERT(varchar, @i), ABS(CHECKSUM(NEWID())) % 10 + 1)
    SET @i = @i + 1
END

-- Tarjeta_Viajero_Frecuente
DECLARE @i int = 1
WHILE @i <= 200
BEGIN
    INSERT INTO Tarjeta_Viajero_Frecuente (Millas, Codigo_Comida, Cliente_id)
    VALUES (ABS(CHECKSUM(NEWID())) % 10000, ABS(CHECKSUM(NEWID())) % 100, ABS(CHECKSUM(NEWID())) % 500 + 1)
    SET @i = @i + 1
END


-- Asiento_Disponible
DECLARE @i int = 1
WHILE @i <= 200000
BEGIN
    DECLARE @asiento_id int
    SELECT TOP 1 @asiento_id = id_asiento
    FROM Asiento
    ORDER BY NEWID()

    INSERT INTO Asiento_Disponible (Vuelo_id, Asiento_id)
    VALUES (ABS(CHECKSUM(NEWID())) % 2000 + 1, @asiento_id)
    SET @i = @i + 1
END

-- Avion_Vuelo
DECLARE @i int = 1
WHILE @i <= 2000
BEGIN
    INSERT INTO Avion_Vuelo (id_vuelo, id_numero_registro)
    VALUES (@i, ABS(CHECKSUM(NEWID())) % 100 + 1)
    SET @i = @i + 1
END

--PASO#3 Insertar 200.000 mil tikets
-- Create the sequence for generating unique ticket numbers
CREATE SEQUENCE dbo.Boleto_Sequence
    START WITH 1
    INCREMENT BY 1;
	
-- Insert tickets, some with reservations and others without
DECLARE @i INT = 1;
DECLARE @cliente_id INT;
DECLARE @boletos_cliente INT;
DECLARE @total_boletos INT = 200000;
DECLARE @num_boletos_insertados INT = 0;

WHILE @num_boletos_insertados < @total_boletos
BEGIN
    -- Select a random client among the 51,000 existing ones
    SET @cliente_id = ABS(CHECKSUM(NEWID()) % 51000) + 1;

    -- Decide how many tickets this client will buy (between 2 and 3 tickets)
    SET @boletos_cliente = ABS(CHECKSUM(NEWID()) % 2) + 2; -- Values between 2 and 3

    -- Insert tickets for this client
    WHILE @boletos_cliente > 0 AND @num_boletos_insertados < @total_boletos
    BEGIN
        -- Decide randomly if the ticket will be with or without a reservation (50% probability)
        IF ABS(CHECKSUM(NEWID()) % 2) = 0
        BEGIN
            -- Ticket without reservation (Reserva_id will be NULL)
            INSERT INTO Boleto (Numero, Cliente_id, Reserva_id)
            VALUES (NEXT VALUE FOR dbo.Boleto_Sequence, @cliente_id, NULL);
        END
        ELSE
        BEGIN
            -- Ticket with reservation
            DECLARE @Fecha_Reserva DATE = DATEADD(DAY, ABS(CHECKSUM(NEWID()) % 730), '2022-01-01');  -- Random date in 2 years
            -- Insert the reservation
            INSERT INTO Reserva (Cliente_id, Fecha_Reserva)
            VALUES (@cliente_id, @Fecha_Reserva);
            
            -- Get the id of the newly created reservation
            DECLARE @Reserva_id INT = SCOPE_IDENTITY();

            -- Insert the ticket with the reservation
            INSERT INTO Boleto (Numero, Cliente_id, Reserva_id)
            VALUES (NEXT VALUE FOR dbo.Boleto_Sequence, @cliente_id, @Reserva_id);
        END

        -- Update the ticket counter and the counter for this client
        SET @boletos_cliente = @boletos_cliente - 1;
        SET @num_boletos_insertados = @num_boletos_insertados + 1;
    END
END;

--PASO#4 Script para generar cupones y asignar asientos
DECLARE @boleto_id INT;
DECLARE @asiento_id INT;
DECLARE @vuelo_id INT;
DECLARE @num_escalas INT;
DECLARE @cupon_id INT;
DECLARE @asientos_disponibles TABLE (id_asiento_disponible INT);
DECLARE @escala_id INT;

-- Obtenemos todos los boletos que ya existen
DECLARE boleto_cursor CURSOR FOR
SELECT id_Codigo_Boleto
FROM Boleto;

-- Abrimos el cursor para recorrer todos los boletos
OPEN boleto_cursor;
FETCH NEXT FROM boleto_cursor INTO @boleto_id;

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Determinamos un número aleatorio de escalas (entre 1 y 3) para este boleto
    SET @num_escalas = ABS(CHECKSUM(NEWID()) % 3) + 1;  -- 1 a 3 escalas

    -- Para cada escala (o vuelo en caso de 1 vuelo directo)
    WHILE @num_escalas > 0
    BEGIN
        -- Seleccionamos un vuelo aleatorio
        SET @vuelo_id = (SELECT TOP 1 id_vuelo FROM Vuelo ORDER BY NEWID());

        -- Llenamos una tabla temporal con los asientos disponibles para el vuelo
        DELETE FROM @asientos_disponibles;
        INSERT INTO @asientos_disponibles (id_asiento_disponible)
        SELECT id_asiento_disponible
        FROM Asiento_Disponible
        WHERE Vuelo_id = @vuelo_id
        AND id_asiento_disponible NOT IN (
            SELECT Asiento_Disponible_id
            FROM Cupon
            WHERE Vuelo_id = @vuelo_id
        );

        -- Seleccionamos un asiento aleatorio de los disponibles
        SET @asiento_id = (SELECT TOP 1 id_asiento_disponible FROM @asientos_disponibles ORDER BY NEWID());

        -- Generamos una fecha y hora aleatoria para el check-in del cupón
        DECLARE @Checkin_Hora TIME = CAST(ABS(CHECKSUM(NEWID()) % 24) AS VARCHAR) + ':' + CAST(ABS(CHECKSUM(NEWID()) % 60) AS VARCHAR);
        DECLARE @Checkin_Fecha DATE = DATEADD(DAY, ABS(CHECKSUM(NEWID()) % 730), '2022-01-01');

        -- Insertamos el cupón asociado al boleto y al asiento disponible
        INSERT INTO Cupon (Fecha_Redencion, Clase, Standby, Codigo_Comida, Codigo_Boleto, Asiento_Disponible_id, Vuelo_id, Checkin_Hora, Checkin_Fecha)
        VALUES (
            GETDATE(),                       -- Fecha de redención actual
            'Economy',                       -- Clase aleatoria (puedes cambiar este valor)
            'No',                            -- Standby (puede ser sí o no, aleatoriamente)
            ABS(CHECKSUM(NEWID()) % 10) + 1, -- Código de comida aleatorio
            @boleto_id,                      -- Boleto al que está asociado el cupón
            @asiento_id,                     -- Asiento disponible seleccionado
            @vuelo_id,                       -- Vuelo seleccionado
            @Checkin_Hora,                   -- Hora de check-in aleatoria
            @Checkin_Fecha                   -- Fecha de check-in aleatoria
        );

        -- Insertamos la escala asociada al boleto y al vuelo
        INSERT INTO Escala (id_boleto, id_vuelo, Orden)
        VALUES (@boleto_id, @vuelo_id, @num_escalas);

        -- Disminuimos el número de escalas restantes
        SET @num_escalas = @num_escalas - 1;
    END

    -- Vamos al siguiente boleto
    FETCH NEXT FROM boleto_cursor INTO @boleto_id;
END;

-- Cerramos el cursor y liberamos recursos
CLOSE boleto_cursor;
DEALLOCATE boleto_cursor;
