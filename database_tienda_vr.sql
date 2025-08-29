-- ===============================================
-- Script de Base de Datos para Tienda de Videojuegos VR
-- JuegosDunz - Tienda de Realidad Virtual
-- ===============================================

-- Crear la base de datos
CREATE DATABASE IF NOT EXISTS tienda_vr_dunz;
USE tienda_vr_dunz;

-- ===============================================
-- Tabla de Categorías de Juegos
-- ===============================================
CREATE TABLE categorias (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion TEXT,
    icono VARCHAR(100),
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ===============================================
-- Tabla de Desarrolladores/Editores
-- ===============================================
CREATE TABLE desarrolladores (
    id_desarrollador INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    pais VARCHAR(50),
    sitio_web VARCHAR(200),
    descripcion TEXT,
    fecha_fundacion DATE,
    activo BOOLEAN DEFAULT TRUE,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ===============================================
-- Tabla de Requisitos VR
-- ===============================================
CREATE TABLE requisitos_vr (
    id_requisito INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    tipo_dispositivo ENUM('PC_VR', 'STANDALONE', 'MOVIL_VR', 'CONSOLA_VR') NOT NULL,
    cpu_minimo VARCHAR(100),
    gpu_minimo VARCHAR(100),
    ram_minimo VARCHAR(20),
    espacio_disco VARCHAR(20),
    dispositivos_compatibles TEXT,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ===============================================
-- Tabla Principal de Juegos
-- ===============================================
CREATE TABLE juegos (
    id_juego INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    descripcion TEXT,
    descripcion_corta VARCHAR(300),
    precio DECIMAL(10,2) NOT NULL,
    precio_oferta DECIMAL(10,2) NULL,
    en_oferta BOOLEAN DEFAULT FALSE,
    porcentaje_descuento INT DEFAULT 0,
    
    -- Información del juego
    id_desarrollador INT,
    id_categoria INT,
    id_requisito_vr INT,
    
    -- Características VR específicas
    tipo_vr ENUM('ROOM_SCALE', 'SEATED', 'STANDING', 'TELEPORT', 'FREE_MOVEMENT') NOT NULL,
    multijugador BOOLEAN DEFAULT FALSE,
    max_jugadores INT DEFAULT 1,
    edad_minima INT DEFAULT 0,
    duracion_estimada VARCHAR(50),
    
    -- Calificación y popularidad
    calificacion_promedio DECIMAL(3,2) DEFAULT 0.00,
    total_reseñas INT DEFAULT 0,
    ventas_totales INT DEFAULT 0,
    
    -- Multimedia
    imagen_portada VARCHAR(300),
    trailer_url VARCHAR(300),
    capturas_pantalla JSON,
    
    -- Estado y fechas
    disponible BOOLEAN DEFAULT TRUE,
    fecha_lanzamiento DATE,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Claves foráneas
    FOREIGN KEY (id_desarrollador) REFERENCES desarrolladores(id_desarrollador),
    FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria),
    FOREIGN KEY (id_requisito_vr) REFERENCES requisitos_vr(id_requisito),
    
    -- Índices para optimización
    INDEX idx_precio (precio),
    INDEX idx_categoria (id_categoria),
    INDEX idx_calificacion (calificacion_promedio),
    INDEX idx_fecha_lanzamiento (fecha_lanzamiento)
);

-- ===============================================
-- Tabla de Reseñas y Calificaciones
-- ===============================================
CREATE TABLE reseñas (
    id_reseña INT AUTO_INCREMENT PRIMARY KEY,
    id_juego INT NOT NULL,
    nombre_usuario VARCHAR(50) NOT NULL,
    email_usuario VARCHAR(100),
    calificacion INT NOT NULL CHECK (calificacion >= 1 AND calificacion <= 5),
    titulo_reseña VARCHAR(150),
    comentario TEXT,
    recomendado BOOLEAN DEFAULT TRUE,
    horas_jugadas DECIMAL(5,1) DEFAULT 0.0,
    verificado BOOLEAN DEFAULT FALSE,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (id_juego) REFERENCES juegos(id_juego) ON DELETE CASCADE,
    INDEX idx_juego_calificacion (id_juego, calificacion)
);

-- ===============================================
-- Tabla de Etiquetas/Tags
-- ===============================================
CREATE TABLE etiquetas (
    id_etiqueta INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    color VARCHAR(7) DEFAULT '#3498db',
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ===============================================
-- Tabla de relación Juegos-Etiquetas (Muchos a Muchos)
-- ===============================================
CREATE TABLE juegos_etiquetas (
    id_juego INT,
    id_etiqueta INT,
    PRIMARY KEY (id_juego, id_etiqueta),
    FOREIGN KEY (id_juego) REFERENCES juegos(id_juego) ON DELETE CASCADE,
    FOREIGN KEY (id_etiqueta) REFERENCES etiquetas(id_etiqueta) ON DELETE CASCADE
);

-- ===============================================
-- Tabla de Inventario
-- ===============================================
CREATE TABLE inventario (
    id_inventario INT AUTO_INCREMENT PRIMARY KEY,
    id_juego INT NOT NULL,
    stock_disponible INT DEFAULT 0,
    stock_reservado INT DEFAULT 0,
    stock_minimo INT DEFAULT 5,
    es_digital BOOLEAN DEFAULT TRUE,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (id_juego) REFERENCES juegos(id_juego) ON DELETE CASCADE
);

-- ===============================================
-- DATOS DE EJEMPLO
-- ===============================================

-- Insertar categorías
INSERT INTO categorias (nombre, descripcion, icono) VALUES
('Acción', 'Juegos de acción y aventura en realidad virtual', 'fas fa-fist-raised'),
('Aventura', 'Experiencias inmersivas de exploración y narrativa', 'fas fa-map'),
('Simulación', 'Simuladores realistas de diversas actividades', 'fas fa-car'),
('Terror', 'Experiencias de terror y suspense en VR', 'fas fa-ghost'),
('Deportes', 'Juegos deportivos y de fitness en realidad virtual', 'fas fa-running'),
('Puzzle', 'Juegos de lógica y rompecabezas en 3D', 'fas fa-puzzle-piece'),
('Educativo', 'Experiencias educativas y de aprendizaje', 'fas fa-graduation-cap'),
('Multijugador', 'Experiencias sociales y cooperativas', 'fas fa-users');

-- Insertar desarrolladores
INSERT INTO desarrolladores (nombre, pais, sitio_web, descripcion, fecha_fundacion) VALUES
('Beat Games', 'República Checa', 'https://beatsaber.com', 'Desarrollador de Beat Saber, uno de los juegos VR más populares', '2017-05-01'),
('Valve Corporation', 'Estados Unidos', 'https://www.valvesoftware.com', 'Gigante de los videojuegos, creador de Steam VR', '1996-08-24'),
('Oculus Studios', 'Estados Unidos', 'https://www.oculus.com', 'Estudio de desarrollo de Meta para experiencias VR', '2012-07-01'),
('Survios', 'Estados Unidos', 'https://survios.com', 'Especialistas en experiencias VR inmersivas', '2013-01-01'),
('Fast Travel Games', 'Suecia', 'https://www.fasttravelgames.com', 'Desarrollador independiente de juegos VR innovadores', '2016-03-01'),
('Vertigo Games', 'Países Bajos', 'https://vertigo-games.com', 'Especialistas en juegos VR de alta calidad', '2008-01-01');

-- Insertar requisitos VR
INSERT INTO requisitos_vr (nombre, descripcion, tipo_dispositivo, cpu_minimo, gpu_minimo, ram_minimo, espacio_disco, dispositivos_compatibles) VALUES
('PC VR Básico', 'Requisitos mínimos para VR en PC', 'PC_VR', 'Intel i5-4590 / AMD FX 8350', 'NVIDIA GTX 1060 / AMD RX 580', '8 GB', '2 GB', 'Oculus Rift, HTC Vive, Valve Index'),
('PC VR Avanzado', 'Requisitos recomendados para mejor experiencia', 'PC_VR', 'Intel i7-8700K / AMD Ryzen 5 3600', 'NVIDIA RTX 3070 / AMD RX 6700 XT', '16 GB', '5 GB', 'Oculus Rift S, HTC Vive Pro, Valve Index'),
('Quest Standalone', 'Para dispositivos VR autónomos', 'STANDALONE', 'Snapdragon XR2', 'Adreno 650', '6 GB', '1 GB', 'Meta Quest 2, Meta Quest Pro'),
('PlayStation VR', 'Requisitos para PSVR', 'CONSOLA_VR', 'PS4 Pro recomendado', 'GPU integrada PS4', '8 GB', '3 GB', 'PlayStation VR, PlayStation VR2'),
('Móvil VR', 'Para experiencias VR móviles', 'MOVIL_VR', 'Snapdragon 855+', 'Adreno 640', '6 GB', '500 MB', 'Samsung Gear VR, Google Daydream');

-- Insertar etiquetas
INSERT INTO etiquetas (nombre, color) VALUES
('Singleplayer', '#e74c3c'),
('Multiplayer', '#3498db'),
('Co-op', '#2ecc71'),
('Competitivo', '#f39c12'),
('Narrativo', '#9b59b6'),
('Sandbox', '#1abc9c'),
('Supervivencia', '#34495e'),
('Música', '#e67e22'),
('Fitness', '#27ae60'),
('Educativo', '#8e44ad');

-- Insertar juegos de ejemplo
INSERT INTO juegos (titulo, descripcion, descripcion_corta, precio, id_desarrollador, id_categoria, id_requisito_vr, tipo_vr, multijugador, max_jugadores, edad_minima, duracion_estimada, calificacion_promedio, total_reseñas, imagen_portada, fecha_lanzamiento) VALUES
('Beat Saber', 'El juego de ritmo más popular en VR donde cortas bloques al ritmo de la música con sables de luz. Una experiencia única que combina música, ejercicio y diversión.', 'Corta bloques al ritmo de la música con sables de luz en este adictivo juego de ritmo VR.', 29.99, 1, 5, 1, 'STANDING', TRUE, 4, 7, '10-100 horas', 4.8, 15420, '/images/beat_saber.jpg', '2019-05-21'),

('Half-Life: Alyx', 'Una precuela de Half-Life 2 diseñada específicamente para VR. Vive una aventura inmersiva completa en el universo de Half-Life con mecánicas revolucionarias.', 'La esperada precuela de Half-Life diseñada exclusivamente para realidad virtual.', 59.99, 2, 2, 2, 'ROOM_SCALE', FALSE, 1, 13, '15-20 horas', 4.9, 8750, '/images/half_life_alyx.jpg', '2020-03-23'),

('Superhot VR', 'El tiempo se mueve solo cuando te mueves. Un shooter único donde cada movimiento cuenta y la estrategia es clave para sobrevivir.', 'Shooter único donde el tiempo se mueve solo cuando tú te mueves.', 24.99, 3, 1, 1, 'ROOM_SCALE', FALSE, 1, 10, '5-8 horas', 4.7, 12300, '/images/superhot_vr.jpg', '2017-12-07'),

('The Walking Dead: Saints & Sinners', 'Sobrevive en un apocalipsis zombie en Nueva Orleans. Toma decisiones difíciles, combate cuerpo a cuerpo realista y explora un mundo post-apocalíptico.', 'Experiencia de supervivencia zombie inmersiva en Nueva Orleans post-apocalíptica.', 39.99, 4, 1, 2, 'ROOM_SCALE', FALSE, 1, 17, '15-25 horas', 4.6, 6890, '/images/walking_dead_vr.jpg', '2020-01-23'),

('Job Simulator', 'Simula trabajos cotidianos en un mundo donde los robots han reemplazado a los humanos. Experiencia divertida y relajante perfecta para nuevos usuarios de VR.', 'Simula trabajos cotidianos en un mundo dominado por robots.', 19.99, 3, 3, 1, 'ROOM_SCALE', FALSE, 1, 0, '4-6 horas', 4.4, 9500, '/images/job_simulator.jpg', '2016-04-05'),

('Arizona Sunshine', 'Shooter cooperativo de zombies en el desierto de Arizona. Combate hordas de muertos vivientes solo o con amigos en esta aventura post-apocalíptica.', 'Shooter cooperativo de zombies en el desierto post-apocalíptico de Arizona.', 34.99, 5, 1, 1, 'ROOM_SCALE', TRUE, 4, 16, '8-12 horas', 4.3, 7200, '/images/arizona_sunshine.jpg', '2017-02-14'),

('Pistol Whip', 'Combina shooter y juego de ritmo en experiencias cinematográficas llenas de acción. Dispara al ritmo de la música en escenarios dinámicos.', 'Shooter rítmico que combina acción cinematográfica con música electrizante.', 24.99, 6, 5, 1, 'STANDING', FALSE, 1, 7, '5-10 horas', 4.5, 5400, '/images/pistol_whip.jpg', '2019-11-07');

-- Insertar reseñas de ejemplo
INSERT INTO reseñas (id_juego, nombre_usuario, calificacion, titulo_reseña, comentario, recomendado, horas_jugadas) VALUES
(1, 'VRGamer123', 5, 'El mejor juego de VR!', 'Beat Saber es increíble. He jugado más de 100 horas y nunca me aburro. Perfecto para hacer ejercicio mientras te diviertes.', TRUE, 125.5),
(1, 'MusicLover', 5, 'Adictivo y divertido', 'No puedo parar de jugar. La sensación de cortar los bloques es muy satisfactoria.', TRUE, 67.2),
(2, 'HalfLifeFan', 5, 'Obra maestra', 'Valve ha creado algo especial. La inmersión es total y la historia es fascinante.', TRUE, 18.3),
(3, 'ActionHero', 4, 'Concepto genial', 'Me encanta la mecánica del tiempo. Muy original y bien ejecutado.', TRUE, 12.1),
(4, 'ZombieSlayer', 5, 'Terror auténtico', 'El realismo del combate cuerpo a cuerpo es impresionante. Realmente sientes el peso de las armas.', TRUE, 28.7),
(5, 'CasualPlayer', 4, 'Perfecto para principiantes', 'Muy divertido y accesible. Ideal para mostrar VR a amigos y familia.', TRUE, 8.4);

-- Relacionar juegos con etiquetas
INSERT INTO juegos_etiquetas (id_juego, id_etiqueta) VALUES
(1, 1), (1, 8), (1, 9),  -- Beat Saber: Singleplayer, Música, Fitness
(2, 1), (2, 5),          -- Half-Life Alyx: Singleplayer, Narrativo
(3, 1), (3, 4),          -- Superhot VR: Singleplayer, Competitivo
(4, 1), (4, 7),          -- Walking Dead: Singleplayer, Supervivencia
(5, 1), (5, 6),          -- Job Simulator: Singleplayer, Sandbox
(6, 2), (6, 3), (6, 7),  -- Arizona Sunshine: Multiplayer, Co-op, Supervivencia
(7, 1), (7, 8), (7, 4);  -- Pistol Whip: Singleplayer, Música, Competitivo

-- Insertar inventario
INSERT INTO inventario (id_juego, stock_disponible, stock_reservado, stock_minimo, es_digital) VALUES
(1, 999, 25, 50, TRUE),
(2, 999, 15, 30, TRUE),
(3, 999, 10, 25, TRUE),
(4, 999, 20, 40, TRUE),
(5, 999, 5, 20, TRUE),
(6, 999, 12, 30, TRUE),
(7, 999, 8, 25, TRUE);

-- ===============================================
-- VISTAS ÚTILES
-- ===============================================

-- Vista de juegos con información completa
CREATE VIEW vista_juegos_completa AS
SELECT 
    j.id_juego,
    j.titulo,
    j.descripcion_corta,
    j.precio,
    j.precio_oferta,
    j.en_oferta,
    j.porcentaje_descuento,
    c.nombre AS categoria,
    d.nombre AS desarrollador,
    j.calificacion_promedio,
    j.total_reseñas,
    j.tipo_vr,
    j.multijugador,
    j.edad_minima,
    j.fecha_lanzamiento,
    i.stock_disponible,
    r.nombre AS requisitos_vr
FROM juegos j
LEFT JOIN categorias c ON j.id_categoria = c.id_categoria
LEFT JOIN desarrolladores d ON j.id_desarrollador = d.id_desarrollador
LEFT JOIN inventario i ON j.id_juego = i.id_juego
LEFT JOIN requisitos_vr r ON j.id_requisito_vr = r.id_requisito
WHERE j.disponible = TRUE;

-- Vista de juegos más populares
CREATE VIEW vista_juegos_populares AS
SELECT 
    j.titulo,
    j.precio,
    j.calificacion_promedio,
    j.total_reseñas,
    j.ventas_totales,
    c.nombre AS categoria,
    d.nombre AS desarrollador
FROM juegos j
JOIN categorias c ON j.id_categoria = c.id_categoria
JOIN desarrolladores d ON j.id_desarrollador = d.id_desarrollador
WHERE j.disponible = TRUE
ORDER BY j.ventas_totales DESC, j.calificacion_promedio DESC;

-- ===============================================
-- PROCEDIMIENTOS ALMACENADOS
-- ===============================================

DELIMITER //

-- Procedimiento para actualizar calificación promedio de un juego
CREATE PROCEDURE ActualizarCalificacionJuego(IN p_id_juego INT)
BEGIN
    DECLARE v_promedio DECIMAL(3,2);
    DECLARE v_total INT;
    
    SELECT AVG(calificacion), COUNT(*) 
    INTO v_promedio, v_total
    FROM reseñas 
    WHERE id_juego = p_id_juego;
    
    UPDATE juegos 
    SET calificacion_promedio = IFNULL(v_promedio, 0),
        total_reseñas = IFNULL(v_total, 0)
    WHERE id_juego = p_id_juego;
END //

-- Procedimiento para aplicar descuento a un juego
CREATE PROCEDURE AplicarDescuento(
    IN p_id_juego INT, 
    IN p_porcentaje INT
)
BEGIN
    DECLARE v_precio_original DECIMAL(10,2);
    
    SELECT precio INTO v_precio_original 
    FROM juegos 
    WHERE id_juego = p_id_juego;
    
    UPDATE juegos 
    SET precio_oferta = v_precio_original * (1 - p_porcentaje/100),
        en_oferta = TRUE,
        porcentaje_descuento = p_porcentaje
    WHERE id_juego = p_id_juego;
END //

DELIMITER ;

-- ===============================================
-- TRIGGERS
-- ===============================================

DELIMITER //

-- Trigger para actualizar calificación cuando se inserta una reseña
CREATE TRIGGER tr_nueva_reseña 
AFTER INSERT ON reseñas
FOR EACH ROW
BEGIN
    CALL ActualizarCalificacionJuego(NEW.id_juego);
END //

-- Trigger para actualizar calificación cuando se modifica una reseña
CREATE TRIGGER tr_actualizar_reseña 
AFTER UPDATE ON reseñas
FOR EACH ROW
BEGIN
    CALL ActualizarCalificacionJuego(NEW.id_juego);
END //

-- Trigger para actualizar calificación cuando se elimina una reseña
CREATE TRIGGER tr_eliminar_reseña 
AFTER DELETE ON reseñas
FOR EACH ROW
BEGIN
    CALL ActualizarCalificacionJuego(OLD.id_juego);
END //

DELIMITER ;

-- ===============================================
-- CONSULTAS DE EJEMPLO
-- ===============================================

-- Juegos más vendidos
-- SELECT * FROM vista_juegos_populares LIMIT 10;

-- Juegos en oferta
-- SELECT titulo, precio, precio_oferta, porcentaje_descuento 
-- FROM juegos 
-- WHERE en_oferta = TRUE;

-- Juegos por categoría
-- SELECT c.nombre AS categoria, COUNT(*) AS total_juegos
-- FROM juegos j
-- JOIN categorias c ON j.id_categoria = c.id_categoria
-- GROUP BY c.nombre;

-- Desarrolladores más activos
-- SELECT d.nombre, COUNT(*) AS juegos_publicados
-- FROM desarrolladores d
-- JOIN juegos j ON d.id_desarrollador = j.id_desarrollador
-- GROUP BY d.nombre
-- ORDER BY juegos_publicados DESC;

-- ===============================================
-- FIN DEL SCRIPT
-- ===============================================