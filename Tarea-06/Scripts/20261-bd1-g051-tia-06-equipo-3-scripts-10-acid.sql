-- PROPIEDAD 1: ATOMICIDAD

-- ---- Verificación ANTES de la transacción ----
SELECT producto_id, nombre_producto, precio_unitario
FROM producto
WHERE producto_id = 1;
 
SELECT mercado_id, nombre_mercado, direccion
FROM mercado
WHERE mercado_id = 1;
 
-- ---- Inicio de la transacción (será revertida) ----
BEGIN;
 
    -- Actualización 1: se modifica el precio de la Miel
    UPDATE producto
    SET precio_unitario = 99999.00
    WHERE producto_id = 1;	
 
    -- Actualización 2: se modifica la dirección del mercado
    UPDATE mercado
    SET direccion = ' Dirección temporal - ROLLBACK TEST'
    WHERE mercado_id = 1;
 
ROLLBACK;   -- Se revierten AMBAS actualizaciones (atomicidad)
 
-- ---- Verificación DESPUÉS del ROLLBACK (deben verse los valores originales) ----
SELECT producto_id, nombre_producto, precio_unitario
FROM producto
WHERE producto_id = 1;
 
SELECT mercado_id, nombre_mercado, direccion
FROM mercado
WHERE mercado_id = 1;
 
-- PROPIEDAD 2: CONSISTENCIA

-- -- CASO A: INSERT con correo duplicado (viola UNIQUE en usuario.correo) --
-- Error esperado: duplicate key value violates unique constraint
INSERT INTO usuario (nombre_usuario, correo, contrasena, rol_id)
VALUES ('Duplicado Test', 'apicultor1@redapicola.co', 'hash_test', 2);
 
 
-- -- CASO B: UPDATE con rol_id inexistente (viola FK fk_usuario_rol) --
-- Error esperado: insert or update violates foreign key constraint
UPDATE usuario
SET rol_id = 999
WHERE usuario_id = 2;
 
 
-- -- CASO C: DELETE de un pedido que tiene detalles asociados (viola FK fk_detalle_pedido_pedido) --
-- Error esperado: update or delete violates foreign key constraint
-- La tabla detalle_pedido usa ON DELETE RESTRICT sobre pedido_id.
DELETE FROM pedido
WHERE pedido_id = 1;
 
 
-- ============================================================
-- PROPIEDAD 3: AISLAMIENTO
-- Caso hipotético — no requiere ejecución.
-- 
-- Escenario: Dos apicultores (Sesión A y Sesión B) intentan publicar
-- el mismo lote de producto de forma simultánea.
-- 
--   Sesión A: BEGIN → lee cantidad_disponible del lote 10 (valor = 30 kg)
--             → publica 20 kg → aún no hace COMMIT
-- 
--   Sesión B: BEGIN → lee cantidad_disponible del lote 10 (aún ve 30 kg,
--             porque Sesión A no hizo COMMIT) → publica 25 kg
-- 
--   Sin aislamiento: ambas sesiones leen el mismo valor y podrían
--   publicar más cantidad de la disponible (sobreoferta).
-- 
--   Con nivel REPEATABLE READ o SERIALIZABLE, PostgreSQL detecta el
--   conflicto y lanza un error en la sesión que intenta confirmar de
--   segunda, protegiendo la integridad del stock.
-- ============================================================
 
-- PROPIEDAD 4: DURABILIDAD
 
-- ---- Verificación ANTES de la transacción ----
SELECT producto_id, nombre_producto, precio_unitario
FROM producto
WHERE producto_id = 3;
 
-- ---- Transacción con COMMIT ----
BEGIN;
 
    -- Actualización: nuevo precio del Propóleo por temporada alta
    UPDATE producto
    SET precio_unitario = 38000.00
    WHERE producto_id = 3;
 
COMMIT;    -- El cambio queda grabado de forma permanente en el disco
 
-- ---- Verificación DESPUÉS del COMMIT (debe mostrar el precio actualizado) ----
SELECT producto_id, nombre_producto, precio_unitario
FROM producto
WHERE producto_id = 3;
