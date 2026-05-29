-- VISTA #1

CREATE OR REPLACE VIEW vw_ventas_apicultor_municipio AS
SELECT
    ub.departamento,
    ub.municipio,
    u.usuario_id                          AS cod_apicultor,
    u.nombre_usuario                      AS apicultor,
    COUNT(DISTINCT pe.pedido_id)          AS total_pedidos,
    SUM(dp.cantidad * dp.precio_unitario) AS total_ventas_cop
FROM usuario u
    JOIN publicacion pub  ON u.usuario_id       = pub.usuario_id         -- JOIN 1: apicultor → publicaciones
    JOIN detalle_pedido dp ON pub.publicacion_id = dp.publicacion_id     -- JOIN 2: publicación → detalles de pedido
    JOIN pedido pe        ON dp.pedido_id        = pe.pedido_id          -- JOIN 3: pedido
    JOIN mercado m        ON pe.mercado_id       = m.mercado_id
    JOIN ubicacion ub     ON m.ubicacion_id      = ub.ubicacion_id
WHERE u.rol_id = 2                                                       -- solo apicultores
GROUP BY ub.departamento, ub.municipio, u.usuario_id, u.nombre_usuario
HAVING SUM(dp.cantidad * dp.precio_unitario) > 500000                   -- filtro: ventas > $500.000 COP
ORDER BY total_ventas_cop DESC;
 
-- Consulta de verificación de la vista
SELECT *
FROM vw_ventas_apicultor_municipio
LIMIT 20;
