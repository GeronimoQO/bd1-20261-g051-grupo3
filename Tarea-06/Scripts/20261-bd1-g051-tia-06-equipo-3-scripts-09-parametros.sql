-- CONSULTA PREPARADA

PREPARE consulta_pedidos_filtrada (VARCHAR, VARCHAR, NUMERIC) AS
SELECT
    ub.departamento,
    p.nombre_producto,
    pe.estado_pedido,
    COUNT(DISTINCT pe.pedido_id)          AS total_pedidos,
    SUM(dp.cantidad * dp.precio_unitario) AS total_cop
FROM pedido pe
    JOIN mercado m        ON pe.mercado_id      = m.mercado_id           -- JOIN 1: pedido → mercado
    JOIN ubicacion ub     ON m.ubicacion_id     = ub.ubicacion_id        -- JOIN 2: mercado → ubicación
    JOIN detalle_pedido dp ON pe.pedido_id      = dp.pedido_id           -- JOIN 3: pedido → detalle
    JOIN publicacion pub  ON dp.publicacion_id  = pub.publicacion_id
    JOIN lote_producto lp ON pub.lote_id        = lp.lote_id
    JOIN producto p       ON lp.producto_id     = p.producto_id
WHERE  ub.departamento   = $1             -- Parámetro 1: departamento
  AND  pe.estado_pedido  = $2             -- Parámetro 2: estado del pedido
GROUP BY ub.departamento, p.nombre_producto, pe.estado_pedido
HAVING SUM(dp.cantidad * dp.precio_unitario) > $3  -- Parámetro 3: monto mínimo COP
ORDER BY total_cop DESC;
 
 
-- Ejecución de la consulta preparada con valores de ejemplo:

EXECUTE consulta_pedidos_filtrada('Antioquia', 'Entregado', 100000);
 
 
-- Liberar la consulta preparada al terminar
DEALLOCATE consulta_pedidos_filtrada;
