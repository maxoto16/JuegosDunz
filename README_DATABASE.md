# Base de Datos - Tienda de Videojuegos VR "JuegosDunz"

## Descripción General
Este script SQL crea una base de datos completa para una tienda de videojuegos de realidad virtual. Está diseñado para ser ejecutado en phpMyAdmin y contiene todas las tablas, relaciones, datos de ejemplo y funcionalidades necesarias para gestionar una tienda VR.

## Estructura de la Base de Datos

### Tablas Principales

#### 1. `juegos` - Tabla principal de videojuegos
- **Propósito**: Almacena toda la información de los videojuegos VR
- **Campos principales**:
  - `titulo`: Nombre del juego
  - `descripcion`: Descripción completa del juego
  - `precio` / `precio_oferta`: Precios normal y con descuento
  - `tipo_vr`: Tipo de experiencia VR (ROOM_SCALE, SEATED, etc.)
  - `calificacion_promedio`: Calificación calculada automáticamente
  - `capturas_pantalla`: JSON con URLs de imágenes

#### 2. `categorias` - Categorías de juegos
- **Propósito**: Clasificar los juegos por género
- **Incluye**: Acción, Aventura, Simulación, Terror, Deportes, Puzzle, Educativo, Multijugador

#### 3. `desarrolladores` - Información de desarrolladores
- **Propósito**: Almacenar datos de estudios de desarrollo
- **Campos**: Nombre, país, sitio web, descripción, fecha de fundación

#### 4. `requisitos_vr` - Requisitos técnicos VR
- **Propósito**: Especificar requisitos de hardware para cada juego
- **Tipos**: PC_VR, STANDALONE, MOVIL_VR, CONSOLA_VR
- **Incluye**: CPU, GPU, RAM, espacio en disco, dispositivos compatibles

#### 5. `reseñas` - Reseñas y calificaciones
- **Propósito**: Sistema de reseñas de usuarios
- **Campos**: Calificación (1-5), comentario, horas jugadas, verificación

### Tablas Auxiliares

#### 6. `etiquetas` - Sistema de etiquetas/tags
- **Propósito**: Etiquetar juegos con características específicas
- **Ejemplos**: Singleplayer, Multiplayer, Co-op, Narrativo

#### 7. `juegos_etiquetas` - Relación muchos a muchos
- **Propósito**: Conectar juegos con múltiples etiquetas

#### 8. `inventario` - Control de inventario
- **Propósito**: Gestionar stock de juegos (principalmente digitales)
- **Campos**: Stock disponible, reservado, mínimo

## Características Especiales

### Vistas Predefinidas
1. **`vista_juegos_completa`**: Información completa de juegos con joins
2. **`vista_juegos_populares`**: Juegos ordenados por popularidad

### Procedimientos Almacenados
1. **`ActualizarCalificacionJuego`**: Recalcula automáticamente las calificaciones
2. **`AplicarDescuento`**: Aplica descuentos a juegos específicos

### Triggers Automáticos
- **Actualización automática de calificaciones**: Cuando se crean, modifican o eliminan reseñas
- **Mantenimiento de integridad**: Asegura consistencia en los datos

## Datos de Ejemplo Incluidos

El script incluye datos de ejemplo para todas las tablas:
- **7 juegos populares**: Beat Saber, Half-Life: Alyx, Superhot VR, etc.
- **6 desarrolladores**: Beat Games, Valve, Oculus Studios, etc.
- **8 categorías**: Cubriendo todos los géneros principales VR
- **5 perfiles de requisitos**: Desde básico hasta avanzado
- **Reseñas de ejemplo**: Para demostrar el sistema de calificaciones

## Instrucciones de Instalación

### En phpMyAdmin:
1. Abre phpMyAdmin en tu servidor
2. Selecciona la pestaña "SQL"
3. Copia y pega el contenido completo del archivo `database_tienda_vr.sql`
4. Haz clic en "Continuar" para ejecutar el script
5. La base de datos `tienda_vr_dunz` será creada automáticamente

### Verificación:
- Revisa que se hayan creado 8 tablas
- Verifica que las tablas contengan datos de ejemplo
- Prueba las vistas ejecutando: `SELECT * FROM vista_juegos_completa;`

## Consultas Útiles de Ejemplo

```sql
-- Ver todos los juegos disponibles
SELECT * FROM vista_juegos_completa;

-- Juegos en oferta
SELECT titulo, precio, precio_oferta, porcentaje_descuento 
FROM juegos 
WHERE en_oferta = TRUE;

-- Juegos por categoría
SELECT c.nombre AS categoria, COUNT(*) AS total_juegos
FROM juegos j
JOIN categorias c ON j.id_categoria = c.id_categoria
GROUP BY c.nombre;

-- Top juegos por calificación
SELECT titulo, calificacion_promedio, total_reseñas
FROM juegos 
ORDER BY calificacion_promedio DESC, total_reseñas DESC;
```

## Mantenimiento

### Agregar un nuevo juego:
```sql
INSERT INTO juegos (titulo, descripcion, precio, id_desarrollador, id_categoria, id_requisito_vr, tipo_vr)
VALUES ('Nuevo Juego VR', 'Descripción del juego', 39.99, 1, 1, 1, 'ROOM_SCALE');
```

### Aplicar descuento:
```sql
CALL AplicarDescuento(1, 25); -- 25% de descuento al juego ID 1
```

### Agregar reseña:
```sql
INSERT INTO reseñas (id_juego, nombre_usuario, calificacion, comentario)
VALUES (1, 'Usuario123', 5, 'Excelente juego!');
```

## Notas Técnicas

- **Encoding**: UTF-8 para soporte completo de caracteres españoles
- **Motores**: InnoDB para soporte de transacciones y claves foráneas
- **Índices**: Optimizados para consultas frecuentes (precio, categoría, calificación)
- **Integridad**: Restricciones y triggers para mantener consistencia
- **Escalabilidad**: Diseño preparado para crecimiento futuro

## Extensiones Futuras Sugeridas

1. **Sistema de usuarios**: Tabla de usuarios registrados
2. **Carrito de compras**: Sistema de compras temporal
3. **Historial de compras**: Registro de transacciones
4. **Sistema de descuentos**: Cupones y promociones
5. **Métricas avanzadas**: Estadísticas de uso y ventas
6. **Multidioma**: Soporte para múltiples idiomas
7. **API REST**: Endpoints para aplicaciones móviles/web

---
*Creado para JuegosDunz - Tienda de Videojuegos VR*