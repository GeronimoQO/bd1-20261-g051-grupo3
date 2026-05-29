-- Verificación ANTES de insertar
SELECT producto_id, nombre_producto, tipo_producto, precio_unitario
FROM producto;
 
-- Inserción del nuevo producto
INSERT INTO producto (nombre_producto, tipo_producto, descripcion, unidad_medida, precio_unitario)
VALUES (
    'Hidromiel',
    'Bebida Fermentada',
    'Bebida artesanal elaborada a base de miel de abejas fermentada con agua',
    '750 ml',
    45000.00
);
 
-- Verificación DESPUÉS de insertar (confirmar que quedó registrado)
SELECT producto_id, nombre_producto, tipo_producto, precio_unitario
FROM producto;
 
-- Eliminación del producto por error (no se comercializará aún)
DELETE FROM producto
WHERE nombre_producto = 'Hidromiel';
 
-- Verificación DESPUÉS de eliminar (confirmar que fue borrado)
SELECT producto_id, nombre_producto, tipo_producto, precio_unitario
FROM producto;
 
-- CASO 2: APICULTOR INSERTADO Y ELIMINADO POR ERROR

-- Verificación ANTES de insertar (últimos 5 apicultores registrados)
SELECT usuario_id, nombre_usuario, correo, rol_id
FROM usuario
WHERE rol_id = 2
ORDER BY usuario_id DESC
LIMIT 5;
 
-- Inserción del nuevo apicultor (rol_id = 2 corresponde a 'Apicultor')
INSERT INTO usuario (nombre_usuario, correo, contrasena, telefono, rol_id, ubicacion_id)
VALUES (
    'Carlos Mendoza',
    'cmendoza.apicultor@redapicola.co',
    md5('clave_temporal_2024'),
    '3014567890',
    2,
    1
);
 
-- Verificación DESPUÉS de insertar (confirmar que quedó registrado)
SELECT usuario_id, nombre_usuario, correo, rol_id
FROM usuario
WHERE correo = 'cmendoza.apicultor@redapicola.co';
 
-- Eliminación del apicultor por error (ya no participará en la Red)
DELETE FROM usuario
WHERE correo = 'cmendoza.apicultor@redapicola.co';
 
-- Verificación DESPUÉS de eliminar (confirmar que fue borrado)
SELECT usuario_id, nombre_usuario, correo, rol_id
FROM usuario
WHERE correo = 'cmendoza.apicultor@redapicola.co';
