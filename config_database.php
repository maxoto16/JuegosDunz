<?php
/**
 * Configuración de Base de Datos para Tienda VR JuegosDunz
 * Archivo de conexión a la base de datos MySQL
 */

// Configuración de la base de datos
define('DB_HOST', 'localhost');          // Host de la base de datos
define('DB_NAME', 'tienda_vr_dunz');     // Nombre de la base de datos
define('DB_USER', 'root');               // Usuario de MySQL (cambiar según configuración)
define('DB_PASS', '');                   // Contraseña de MySQL (cambiar según configuración)
define('DB_CHARSET', 'utf8mb4');         // Charset para soporte completo UTF-8

/**
 * Clase para manejar la conexión a la base de datos
 */
class DatabaseConnection {
    private $connection;
    private static $instance = null;
    
    /**
     * Constructor privado para patrón Singleton
     */
    private function __construct() {
        try {
            $dsn = "mysql:host=" . DB_HOST . ";dbname=" . DB_NAME . ";charset=" . DB_CHARSET;
            $options = [
                PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
                PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                PDO::ATTR_EMULATE_PREPARES   => false,
            ];
            
            $this->connection = new PDO($dsn, DB_USER, DB_PASS, $options);
        } catch (PDOException $e) {
            throw new Exception("Error de conexión a la base de datos: " . $e->getMessage());
        }
    }
    
    /**
     * Obtener instancia única de la conexión (Singleton)
     */
    public static function getInstance() {
        if (self::$instance === null) {
            self::$instance = new DatabaseConnection();
        }
        return self::$instance;
    }
    
    /**
     * Obtener la conexión PDO
     */
    public function getConnection() {
        return $this->connection;
    }
    
    /**
     * Prevenir clonación
     */
    private function __clone() {}
    
    /**
     * Prevenir deserialización
     */
    public function __wakeup() {}
}

/**
 * Función helper para obtener la conexión rápidamente
 */
function getDBConnection() {
    return DatabaseConnection::getInstance()->getConnection();
}

/**
 * Ejemplo de uso - Funciones básicas para la tienda VR
 */

/**
 * Obtener todos los juegos disponibles
 */
function obtenerJuegosDisponibles($limite = 10, $categoria = null) {
    $db = getDBConnection();
    
    $sql = "SELECT * FROM vista_juegos_completa WHERE 1=1";
    $params = [];
    
    if ($categoria) {
        $sql .= " AND categoria = :categoria";
        $params[':categoria'] = $categoria;
    }
    
    $sql .= " ORDER BY calificacion_promedio DESC LIMIT :limite";
    $params[':limite'] = $limite;
    
    $stmt = $db->prepare($sql);
    
    // Bind de parámetros
    foreach ($params as $key => $value) {
        if ($key === ':limite') {
            $stmt->bindValue($key, $value, PDO::PARAM_INT);
        } else {
            $stmt->bindValue($key, $value);
        }
    }
    
    $stmt->execute();
    return $stmt->fetchAll();
}

/**
 * Obtener juego por ID
 */
function obtenerJuegoPorId($id) {
    $db = getDBConnection();
    
    $sql = "SELECT * FROM vista_juegos_completa WHERE id_juego = :id";
    $stmt = $db->prepare($sql);
    $stmt->bindValue(':id', $id, PDO::PARAM_INT);
    $stmt->execute();
    
    return $stmt->fetch();
}

/**
 * Obtener reseñas de un juego
 */
function obtenerReseñasJuego($id_juego, $limite = 5) {
    $db = getDBConnection();
    
    $sql = "SELECT * FROM reseñas 
            WHERE id_juego = :id_juego 
            ORDER BY fecha_creacion DESC 
            LIMIT :limite";
    
    $stmt = $db->prepare($sql);
    $stmt->bindValue(':id_juego', $id_juego, PDO::PARAM_INT);
    $stmt->bindValue(':limite', $limite, PDO::PARAM_INT);
    $stmt->execute();
    
    return $stmt->fetchAll();
}

/**
 * Agregar una nueva reseña
 */
function agregarReseña($id_juego, $nombre_usuario, $calificacion, $comentario, $email = null) {
    $db = getDBConnection();
    
    try {
        $sql = "INSERT INTO reseñas (id_juego, nombre_usuario, email_usuario, calificacion, comentario) 
                VALUES (:id_juego, :nombre_usuario, :email_usuario, :calificacion, :comentario)";
        
        $stmt = $db->prepare($sql);
        $stmt->execute([
            ':id_juego' => $id_juego,
            ':nombre_usuario' => $nombre_usuario,
            ':email_usuario' => $email,
            ':calificacion' => $calificacion,
            ':comentario' => $comentario
        ]);
        
        return true;
    } catch (PDOException $e) {
        error_log("Error al agregar reseña: " . $e->getMessage());
        return false;
    }
}

/**
 * Buscar juegos por término
 */
function buscarJuegos($termino, $limite = 10) {
    $db = getDBConnection();
    
    $sql = "SELECT * FROM vista_juegos_completa 
            WHERE titulo LIKE :termino 
               OR descripcion_corta LIKE :termino 
               OR categoria LIKE :termino 
               OR desarrollador LIKE :termino
            ORDER BY calificacion_promedio DESC 
            LIMIT :limite";
    
    $stmt = $db->prepare($sql);
    $termino_busqueda = "%$termino%";
    $stmt->bindValue(':termino', $termino_busqueda);
    $stmt->bindValue(':limite', $limite, PDO::PARAM_INT);
    $stmt->execute();
    
    return $stmt->fetchAll();
}

/**
 * Obtener categorías disponibles
 */
function obtenerCategorias() {
    $db = getDBConnection();
    
    $sql = "SELECT * FROM categorias ORDER BY nombre";
    $stmt = $db->prepare($sql);
    $stmt->execute();
    
    return $stmt->fetchAll();
}

/**
 * Aplicar descuento a un juego (usa el procedimiento almacenado)
 */
function aplicarDescuentoJuego($id_juego, $porcentaje) {
    $db = getDBConnection();
    
    try {
        $sql = "CALL AplicarDescuento(:id_juego, :porcentaje)";
        $stmt = $db->prepare($sql);
        $stmt->execute([
            ':id_juego' => $id_juego,
            ':porcentaje' => $porcentaje
        ]);
        
        return true;
    } catch (PDOException $e) {
        error_log("Error al aplicar descuento: " . $e->getMessage());
        return false;
    }
}

// Ejemplo de configuración adicional
ini_set('default_charset', 'UTF-8');
date_default_timezone_set('America/Mexico_City'); // Ajustar según ubicación

// Configuración de errores para desarrollo (comentar en producción)
error_reporting(E_ALL);
ini_set('display_errors', 1);

?>