-- Desactivar el modo seguro al inicio
SET SQL_SAFE_UPDATES = 0;
SET FOREIGN_KEY_CHECKS = 0;

-- Eliminar la base de datos si existe y crearla nuevamente
DROP DATABASE IF EXISTS banco_union;
CREATE DATABASE banco_union;
USE banco_union;

-- Tabla Clientes
DROP TABLE IF EXISTS Clientes;
CREATE TABLE Clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    identificacion VARCHAR(20) NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    direccion VARCHAR(255),
    telefono VARCHAR(15),
    correo VARCHAR(100),
    estado ENUM('Activo', 'Inactivo') DEFAULT 'Activo',
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ultima_actividad TIMESTAMP
);

-- Tabla Cuentas
DROP TABLE IF EXISTS Cuentas;
CREATE TABLE Cuentas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    tipo ENUM('Personal', 'Empresarial') NOT NULL,
    saldo DECIMAL(15, 2) DEFAULT 0.00,
    limite_saldo DECIMAL(15, 2),
    fecha_apertura TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    estado ENUM('Activa', 'Cerrada') DEFAULT 'Activa',
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id)
);

-- Tabla Cheques
DROP TABLE IF EXISTS Cheques;
CREATE TABLE Cheques (
    id INT AUTO_INCREMENT PRIMARY KEY,
    numero_cheque VARCHAR(20) UNIQUE,  -- Quitamos el AUTO_INCREMENT de aquí
    id_cuenta INT NOT NULL,
    beneficiario VARCHAR(100) NOT NULL,
    monto DECIMAL(15, 2) NOT NULL,
    monto_letras VARCHAR(255) NOT NULL,
    prioridad ENUM('Alta', 'Media', 'Baja') NOT NULL,
    firma_digital VARCHAR(64) NOT NULL,
    estado ENUM('Pendiente', 'Procesado', 'Rechazado') DEFAULT 'Pendiente',
    razon_rechazo ENUM(
        'Saldo insuficiente',
        'Cuenta bloqueada',
        'Error en datos',
        'Firma inválida',
        'Cuenta inactiva',
        'Límite excedido',
        'Formato inválido',
        'Cliente inactivo'
    ) NULL,
    fecha_emision DATE NOT NULL,
    fecha_proceso TIMESTAMP,
    cobrado BOOLEAN DEFAULT FALSE,
    cuenta_saldo_momento DECIMAL(15, 2),
    fecha_modificacion TIMESTAMP,
    usuario_modificacion VARCHAR(50),
    FOREIGN KEY (id_cuenta) REFERENCES Cuentas(id)
);

-- Tabla de secuencia para cheques
DROP TABLE IF EXISTS cheque_sequence;
CREATE TABLE cheque_sequence (
    next_val INT NOT NULL
) ENGINE = InnoDB;

-- Modificar secuencia del número de cheque y agregar trigger
ALTER TABLE Cheques AUTO_INCREMENT = 1000;

-- Modificar el trigger para usar un contador independiente
INSERT INTO cheque_sequence VALUES (1000);

DELIMITER //
CREATE TRIGGER before_insert_cheques
BEFORE INSERT ON Cheques
FOR EACH ROW
BEGIN
    DECLARE next_id INT;
    UPDATE cheque_sequence SET next_val = next_val + 1;
    SELECT next_val INTO next_id FROM cheque_sequence LIMIT 1;
    SET NEW.numero_cheque = CONCAT('CH', LPAD(next_id, 7, '0'));
END//
DELIMITER ;

-- Tabla Transacciones
DROP TABLE IF EXISTS Transacciones;
CREATE TABLE Transacciones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_cuenta INT NOT NULL,
    tipo ENUM('Deposito', 'Retiro') NOT NULL,
    monto DECIMAL(15, 2) NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    referencia VARCHAR(50) UNIQUE,
    saldo_anterior DECIMAL(15, 2),
    saldo_nuevo DECIMAL(15, 2),
    estado ENUM('Exitosa', 'Fallida') DEFAULT 'Exitosa',
    FOREIGN KEY (id_cuenta) REFERENCES Cuentas(id)
);

-- Insertar datos iniciales para Clientes
INSERT INTO Clientes (identificacion, nombre, apellido, direccion, telefono, correo, estado)
VALUES
('123456789', 'Juan', 'Perez', 'Calle 1 #123', '3001234567', 'juan.perez@example.com', 'Activo'),
('987654321', 'Ana', 'Lopez', 'Carrera 5 #45', '3207654321', 'ana.lopez@example.com', 'Activo'),
('456789123', 'Carlos', 'Ramirez', 'Diagonal 10 #89', '3109876543', 'carlos.ramirez@example.com', 'Inactivo'),
('789123456', 'Laura', 'Martinez', 'Av. Principal #101', '3501230987', 'laura.martinez@example.com', 'Activo'),
('321654987', 'Maria', 'Torres', 'Calle 8 #76', '3107654321', 'maria.torres@example.com', 'Activo'),
('654321789', 'Sofia', 'Gomez', 'Calle 9 #123', '3106543210', 'sofia.gomez@example.com', 'Activo'),
('987123654', 'Luis', 'Fernandez', 'Carrera 10 #456', '3009871234', 'luis.fernandez@example.com', 'Activo'),
('852741963', 'Carmen', 'Diaz', 'Av. Central #789', '3208527416', 'carmen.diaz@example.com', 'Activo'),
('741852963', 'Miguel', 'Hernandez', 'Carrera 22 #12', '3209987456', 'miguel.hernandez@example.com', 'Activo'),
('963258741', 'Sara', 'Morales', 'Av. Sur #23', '3204567890', 'sara.morales@example.com', 'Activo'),
('223456789', 'Pedro', 'Gomez', 'Calle 21 #123', '3102234567', 'pedro.gomez@example.com', 'Activo'),
('287654321', 'Lucia', 'Cortez', 'Carrera 7 #85', '3201234123', 'lucia.cortez@example.com', 'Activo'),
('333111444', 'Roberto', 'Silva', 'Av. 45 #90', '3157894561', 'roberto.silva@example.com', 'Inactivo'),
('444222555', 'Diana', 'Vargas', 'Calle 67 #23', '3209876543', 'diana.vargas@example.com', 'Activo'),
('555333666', 'Mario', 'Ruiz', 'Carrera 89 #12', '3114567890', 'mario.ruiz@example.com', 'Activo'),
('666444777', 'Carmen', 'Ortiz', 'Av. 34 #56', '3145678901', 'carmen.ortiz@example.com', 'Inactivo'),
('777555888', 'Andrea', 'Vargas', 'Calle 100 #45', '3157894561', 'andrea.vargas@example.com', 'Activo'),
('888666999', 'Ricardo', 'Mendoza', 'Av. 78 #23', '3209876543', 'ricardo.mendoza@example.com', 'Activo'),
('999777000', 'Carolina', 'Paz', 'Carrera 34 #67', '3114567890', 'carolina.paz@example.com', 'Inactivo'),
('000888999', 'Fernando', 'Luna', 'Calle 56 #89', '3145678901', 'fernando.luna@example.com', 'Activo'),
('111999000', 'Valentina', 'Rojas', 'Av. 90 #12', '3168529637', 'valentina.rojas@example.com', 'Activo');

-- Insertar datos iniciales para Cuentas (corregido)
INSERT INTO Cuentas (id_cliente, tipo, saldo, limite_saldo, estado)
VALUES
(1, 'Personal', 5000000, 10000000, 'Activa'),
(2, 'Personal', 2000000, 10000000, 'Activa'),
(3, 'Empresarial', 15000000, NULL, 'Activa'),
(4, 'Personal', 0, 10000000, 'Activa'),
(5, 'Empresarial', 50000000, NULL, 'Activa'),
(6, 'Personal', 2500000, 10000000, 'Activa'),
(7, 'Empresarial', 35000000, NULL, 'Activa'),
(8, 'Personal', 1000000, 10000000, 'Activa'),
(9, 'Personal', 7000000, 10000000, 'Activa'),
(10, 'Empresarial', 20000000, NULL, 'Activa'),
(11, 'Personal', 4000000, 10000000, 'Activa'),
(12, 'Empresarial', 75000000, NULL, 'Activa'),
(13, 'Personal', 9500000, 10000000, 'Activa'),
(14, 'Empresarial', 25000000, NULL, 'Activa'),
(15, 'Personal', 100000, 10000000, 'Cerrada'),
(16, 'Empresarial', 0, NULL, 'Cerrada'),
((SELECT id FROM Clientes WHERE identificacion = '777555888'), 'Personal', 9800000, 10000000, 'Activa'),
((SELECT id FROM Clientes WHERE identificacion = '888666999'), 'Personal', 9900000, 10000000, 'Activa'),
((SELECT id FROM Clientes WHERE identificacion = '999777000'), 'Empresarial', 80000000, NULL, 'Activa'),
((SELECT id FROM Clientes WHERE identificacion = '000888999'), 'Empresarial', 95000000, NULL, 'Activa'),
((SELECT id FROM Clientes WHERE identificacion = '111999000'), 'Personal', 100000, 10000000, 'Activa');

-- Insertar transacciones básicas
INSERT INTO Transacciones (id_cuenta, tipo, monto, fecha)
VALUES
(1, 'Deposito', 5000000, '2023-11-01'),
(2, 'Retiro', 1000000, '2023-11-02'),
(3, 'Deposito', 3000000, '2023-12-01'),
(4, 'Retiro', 2000000, '2023-12-02'),
(5, 'Deposito', 8000000, '2023-12-03'),
(6, 'Deposito', 2500000, '2023-12-05'),
(7, 'Retiro', 5000000, '2023-12-07'),
(8, 'Deposito', 1500000, '2023-12-10'),
(9, 'Deposito', 2500000, '2023-12-15'),
(10, 'Deposito', 3000000, '2023-12-20'),
(11, 'Deposito', 4000000, '2023-12-25'),
(12, 'Retiro', 5000000, '2023-12-28');

-- Insertar transacciones con referencia y saldos
INSERT INTO Transacciones (id_cuenta, tipo, monto, fecha, referencia, saldo_anterior, saldo_nuevo, estado)
VALUES
(1, 'Deposito', 1000000, NOW() - INTERVAL 5 DAY, 'REF001', 4000000, 5000000, 'Exitosa'),
(2, 'Retiro', 500000, NOW() - INTERVAL 3 DAY, 'REF002', 2500000, 2000000, 'Exitosa'),
(3, 'Deposito', 2000000, NOW() - INTERVAL 45 DAY, 'REF003', 13000000, 15000000, 'Exitosa'),
(4, 'Retiro', 1000000, NOW() - INTERVAL 40 DAY, 'REF004', 1000000, 0, 'Exitosa');

-- Insertar transacciones de prueba para últimos 30 días
INSERT INTO Transacciones (id_cuenta, tipo, monto, fecha)
VALUES
(1, 'Deposito', 1000000, NOW() - INTERVAL 15 DAY),
(2, 'Retiro', 500000, NOW() - INTERVAL 20 DAY),
(3, 'Deposito', 750000, NOW() - INTERVAL 45 DAY);

-- Insertar transacciones para prueba de inactividad
INSERT INTO Transacciones (id_cuenta, tipo, monto, fecha)
VALUES
(1, 'Deposito', 1000000, NOW() - INTERVAL 60 DAY),
(2, 'Deposito', 2000000, NOW() - INTERVAL 45 DAY),
(3, 'Deposito', 3000000, NOW() - INTERVAL 35 DAY);

-- Agregar más transacciones recientes
INSERT INTO Transacciones (id_cuenta, tipo, monto, fecha, referencia, saldo_anterior, saldo_nuevo)
VALUES
-- Clientes con ambas actividades (transacciones Y cheques)
(1, 'Deposito', 5000000, NOW(), 'REF_TEST_1', 10000000, 15000000),
(2, 'Retiro', 1000000, NOW(), 'REF_TEST_2', 5000000, 4000000),

-- Clientes solo con transacciones
(3, 'Deposito', 2000000, NOW(), 'REF_TEST_3', 8000000, 10000000),
(4, 'Deposito', 3000000, NOW(), 'REF_TEST_4', 7000000, 10000000);

-- Agregar transacciones para probar todos los escenarios
INSERT INTO Transacciones (id_cuenta, tipo, monto, fecha, referencia, saldo_anterior, saldo_nuevo)
SELECT 
    id,
    CASE WHEN RAND() > 0.5 THEN 'Deposito' ELSE 'Retiro' END,
    FLOOR(RAND() * 1000000) + 100000,
    CASE 
        WHEN RAND() < 0.3 THEN NOW() - INTERVAL FLOOR(RAND() * 60) DAY
        WHEN RAND() < 0.6 THEN NOW() - INTERVAL FLOOR(RAND() * 30) DAY
        ELSE NOW() - INTERVAL FLOOR(RAND() * 15) DAY
    END,
    CONCAT('REF_AUTO_', id, '_', FLOOR(RAND() * 1000)),
    FLOOR(RAND() * 5000000) + 1000000,
    FLOOR(RAND() * 5000000) + 1000000
FROM Cuentas
WHERE estado = 'Activa'
LIMIT 100;

-- Insertar datos iniciales base para Cheques
INSERT INTO Cheques (id_cuenta, beneficiario, monto, monto_letras, prioridad, firma_digital, estado, razon_rechazo, fecha_emision)
VALUES
(1, 'Luis Fernandez', 150000, 'Ciento cincuenta mil pesos', 'Alta', 'FIRMA101', 'Pendiente', NULL, '2023-12-01'),
(2, 'Maria Torres', 100000, 'Cien mil pesos', 'Media', 'FIRMA102', 'Procesado', NULL, '2023-12-03'),
(3, 'Carlos Ramirez', 500000, 'Quinientos mil pesos', 'Baja', 'FIRMA103', 'Rechazado', 'Saldo insuficiente', '2023-12-05'),
(4, 'Ana Lopez', 800000, 'Ochocientos mil pesos', 'Alta', 'FIRMA104', 'Pendiente', NULL, '2023-12-08'),
(5, 'Juan Perez', 1000000, 'Un millón de pesos', 'Media', 'FIRMA105', 'Procesado', NULL, '2023-12-10'),
(6, 'Sofia Gomez', 250000, 'Doscientos cincuenta mil pesos', 'Baja', 'FIRMA106', 'Rechazado', 'Cuenta bloqueada', '2023-12-12'),
(7, 'Miguel Hernandez', 750000, 'Setecientos cincuenta mil pesos', 'Alta', 'FIRMA107', 'Pendiente', NULL, '2023-12-15'),
(8, 'Laura Martinez', 50000, 'Cincuenta mil pesos', 'Baja', 'FIRMA108', 'Procesado', NULL, '2023-12-18'),
(9, 'Sara Morales', 900000, 'Novecientos mil pesos', 'Alta', 'FIRMA109', 'Pendiente', NULL, '2023-12-20'),
(10, 'Lucia Cortez', 450000, 'Cuatrocientos cincuenta mil pesos', 'Media', 'FIRMA110', 'Pendiente', NULL, '2023-12-22'),
(11, 'Maria Lopez', 200000, 'Doscientos mil pesos', 'Alta', 'SIG123', 'Rechazado', 'Error en datos', '2023-11-10'),
(12, 'Carlos Reyes', 500000, 'Quinientos mil pesos', 'Media', 'SIG124', 'Rechazado', 'Firma inválida', '2023-11-12'),
(13, 'Laura Perez', 800000, 'Ochocientos mil pesos', 'Alta', 'SIG125', 'Pendiente', NULL, '2023-11-13'),
(14, 'Luis Sanchez', 100000, 'Cien mil pesos', 'Baja', 'SIG126', 'Procesado', NULL, '2023-11-14'),
(15, 'Ana Torres', 300000, 'Trescientos mil pesos', 'Media', 'SIG127', 'Pendiente', NULL, '2023-11-15');

-- Insertar cheques con datos adicionales
INSERT INTO Cheques (id_cuenta, beneficiario, monto, monto_letras, prioridad, firma_digital, estado, razon_rechazo, fecha_emision, cobrado, cuenta_saldo_momento)
VALUES
(1, 'Elena Castro', 2000000, 'Dos millones de pesos', 'Alta', 'FIRMA201', 'Pendiente', NULL, CURDATE(), FALSE, 5000000),
(2, 'Ricardo Paz', 1500000, 'Un millón quinientos mil pesos', 'Media', 'FIRMA202', 'Pendiente', NULL, CURDATE(), FALSE, 2000000),
(3, 'Jorge Wong', 3000000, 'Tres millones de pesos', 'Alta', 'FIRMA203', 'Rechazado', 'Límite excedido', CURDATE() - INTERVAL 5 DAY, FALSE, 15000000),
(4, 'Patricia Luna', 500000, 'Quinientos mil pesos', 'Baja', 'FIRMA204', 'Procesado', NULL, CURDATE() - INTERVAL 2 DAY, TRUE, 1000000);

-- Insertar cheques de prueba
INSERT INTO Cheques (id_cuenta, beneficiario, monto, monto_letras, prioridad, firma_digital, estado, fecha_emision)
VALUES
(1, 'Test Beneficiario', 100000, 'Cien mil pesos', 'Alta', 'FIRMA999', 'Pendiente', CURDATE()),
(1, 'Test CRUD 1', 8000000, 'Ocho millones de pesos', 'Alta', 'FIRMA_CRUD_1', 'Pendiente', CURDATE()),
(2, 'Test CRUD 2', 9999999, 'Nueve millones novecientos noventa y nueve mil novecientos noventa y nueve pesos', 'Alta', 'FIRMA_CRUD_2', 'Pendiente', CURDATE());

-- Agregar cheques pendientes adicionales
INSERT INTO Cheques (id_cuenta, beneficiario, monto, monto_letras, prioridad, firma_digital, estado, fecha_emision)
VALUES
-- Clientes con ambas actividades
(1, 'Test Conjunto 1', 100000, 'Cien mil pesos', 'Alta', 'FIRMA_TEST_1', 'Pendiente', CURDATE()),
(2, 'Test Conjunto 2', 200000, 'Doscientos mil pesos', 'Media', 'FIRMA_TEST_2', 'Pendiente', CURDATE()),

-- Clientes solo con cheques
(5, 'Test Solo Cheque 1', 300000, 'Trescientos mil pesos', 'Baja', 'FIRMA_TEST_3', 'Pendiente', CURDATE()),
(6, 'Test Solo Cheque 2', 400000, 'Cuatrocientos mil pesos', 'Alta', 'FIRMA_TEST_4', 'Pendiente', CURDATE());

-- Agregar más cheques con diferentes estados y prioridades
INSERT INTO Cheques (id_cuenta, beneficiario, monto, monto_letras, prioridad, firma_digital, estado, fecha_emision)
SELECT 
    c.id,
    CONCAT('Beneficiario Auto ', FLOOR(RAND() * 1000)),
    FLOOR(RAND() * 5000000) + 100000,
    'Monto en letras automático',
    CASE FLOOR(RAND() * 3)
        WHEN 0 THEN 'Alta'
        WHEN 1 THEN 'Media'
        ELSE 'Baja'
    END,
    CONCAT('FIRMA_AUTO_', FLOOR(RAND() * 10000)),
    CASE FLOOR(RAND() * 3)
        WHEN 0 THEN 'Pendiente'
        WHEN 1 THEN 'Procesado'
        ELSE 'Rechazado'
    END,
    DATE_SUB(CURDATE(), INTERVAL FLOOR(RAND() * 30) DAY)
FROM Cuentas c
WHERE c.estado = 'Activa'
LIMIT 100;

-- Agregar cheques específicos para pruebas de procesamiento
INSERT INTO Cheques (id_cuenta, beneficiario, monto, monto_letras, prioridad, firma_digital, estado, fecha_emision)
SELECT 
    id,
    CONCAT('Test Procesamiento ', id),
    500000,
    'Quinientos mil pesos',
    CASE id % 3 
        WHEN 0 THEN 'Alta'
        WHEN 1 THEN 'Media'
        ELSE 'Baja'
    END,
    CONCAT('FIRMA_PROC_', id),
    'Pendiente',
    CURDATE()
FROM Cuentas 
WHERE estado = 'Activa'
LIMIT 50;

-- Agregar datos específicos para pruebas
INSERT INTO Cheques (id_cuenta, beneficiario, monto, monto_letras, prioridad, firma_digital, estado, fecha_emision)
SELECT 
    id,
    'Test Conjunto A',
    1000000,
    'Un millón de pesos',
    'Alta',
    CONCAT('FIRMA_CONJ_A_', id),
    'Pendiente',
    CURDATE()
FROM Cuentas 
WHERE id IN (
    SELECT id_cuenta 
    FROM Transacciones 
    WHERE fecha >= NOW() - INTERVAL 30 DAY
    GROUP BY id_cuenta
    HAVING COUNT(*) > 5
)
LIMIT 20;

-- Crear índices
CREATE INDEX idx_fecha ON Transacciones(fecha);
CREATE INDEX idx_cuenta_fecha ON Transacciones(id_cuenta, fecha);
CREATE INDEX idx_estado_prioridad ON Cheques(estado, prioridad);
CREATE INDEX idx_fecha_emision ON Cheques(fecha_emision);
CREATE INDEX idx_numero_cheque ON Cheques(numero_cheque);
CREATE INDEX idx_cliente_estado ON Clientes(estado);
CREATE INDEX idx_cuenta_estado ON Cuentas(estado);
CREATE INDEX idx_transaccion_fecha ON Transacciones(fecha);
CREATE INDEX idx_cheque_estado_fecha ON Cheques(estado, fecha_emision);
CREATE INDEX idx_ultima_actividad ON Clientes(ultima_actividad);
CREATE INDEX idx_cuenta_monto ON Transacciones(id_cuenta, monto);
CREATE INDEX idx_cheque_prioridad_fecha ON Cheques(prioridad, fecha_emision);
CREATE INDEX idx_cuenta_tipo_saldo ON Cuentas(tipo, saldo);

-- Actualizar última actividad de clientes
UPDATE Clientes c 
SET ultima_actividad = (
    SELECT MAX(actividad) 
    FROM (
        SELECT t.fecha as actividad
        FROM Cuentas cu
        JOIN Transacciones t ON cu.id = t.id_cuenta
        WHERE cu.id_cliente = c.id
        
        UNION
        
        SELECT ch.fecha_emision as actividad
        FROM Cuentas cu
        JOIN Cheques ch ON cu.id = ch.id_cuenta
        WHERE cu.id_cliente = c.id
        
        UNION
        
        SELECT c2.fecha_registro as actividad
        FROM Clientes c2
        WHERE c2.id = c.id
    ) as fechas
);

-- Actualizar saldos de cuentas
UPDATE Cuentas c
SET saldo = (
    SELECT COALESCE(
        inicial.saldo + IFNULL(mov.total, 0),
        inicial.saldo
    )
    FROM (
        SELECT id, saldo 
        FROM Cuentas 
        WHERE id = c.id
    ) inicial
    LEFT JOIN (
        SELECT 
            id_cuenta,
            SUM(CASE 
                WHEN tipo = 'Deposito' THEN monto 
                ELSE -monto 
            END) as total
        FROM Transacciones
        GROUP BY id_cuenta
    ) mov ON inicial.id = mov.id_cuenta
)
WHERE estado = 'Activa';

-- Actualizar cheques aleatorios
UPDATE Cheques 
SET estado = 'Pendiente',
    prioridad = 'Alta'
WHERE id IN (
    SELECT id 
    FROM (
        SELECT id 
        FROM Cheques 
        ORDER BY RAND() 
        LIMIT 10
    ) temp
);

-- Reactivar el modo seguro
SET SQL_SAFE_UPDATES = 1;
SET FOREIGN_KEY_CHECKS = 1;