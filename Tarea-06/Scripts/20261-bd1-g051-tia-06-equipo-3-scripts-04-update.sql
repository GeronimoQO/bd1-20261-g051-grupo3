 -- ACTUALIZACIÓN DE DIRECCIONES EN LA TABLA mercado
 
-- Verificación ANTES de actualizar
SELECT mercado_id, nombre_mercado, direccion
FROM mercado
WHERE mercado_id IN (1, 2, 3);
 
-- Actualización 1: Mercado de Caucasia cambia de local
UPDATE mercado
SET direccion = 'Calle 20 # 15-40, Barrio Centro Comercial'
WHERE mercado_id = 1;
 
-- Actualización 2: Mercado de El Bagre se traslada
UPDATE mercado
SET direccion = 'Carrera 8 # 10-55, Sector La Esperanza'
WHERE mercado_id = 2;
 
-- Actualización 3: Mercado de Zaragoza amplía sede
UPDATE mercado
SET direccion = 'Avenida Principal # 3-22, Plaza Central'
WHERE mercado_id = 3;
 
-- Verificación DESPUÉS de actualizar
SELECT mercado_id, nombre_mercado, direccion
FROM mercado
WHERE mercado_id IN (1, 2, 3);
 
 -- ACTUALIZACIÓN DE PRECIOS EN LA TABLA producto

-- Verificación ANTES de actualizar
SELECT producto_id, nombre_producto, precio_unitario
FROM producto;
 
-- Actualización 1: Precio de la Miel sube por alta demanda
UPDATE producto
SET precio_unitario = 28000.00
WHERE producto_id = 1;
 
-- Actualización 2: Precio del Polen baja por sobreproducción
UPDATE producto
SET precio_unitario = 17500.00
WHERE producto_id = 2;
 
-- Actualización 3: Precio de la Jalea Real sube por escasez
UPDATE producto
SET precio_unitario = 48000.00
WHERE producto_id = 4;
 
-- Verificación DESPUÉS de actualizar
SELECT producto_id, nombre_producto, precio_unitario
FROM producto;
