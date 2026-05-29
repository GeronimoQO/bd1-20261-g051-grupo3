-- CONSULTA #1 - GROUP BY

SELECT
    ub.departamento,
    ub.municipio,
    COUNT(u.usuario_id)  AS total_productores
FROM usuario u
    JOIN ubicacion ub ON u.ubicacion_id = ub.ubicacion_id
WHERE u.rol_id = 2                                        -- rol 2 = Apicultor
GROUP BY ub.departamento, ub.municipio
ORDER BY ub.departamento ASC, ub.municipio ASC;

-- CONSULTA #2 - GROUP BY

SELECT
    ub.departamento,
    ub.municipio,
    COUNT(c.consumidor_id)  AS total_consumidores
FROM consumidor c
    JOIN ubicacion ub ON c.ubicacion_id = ub.ubicacion_id
GROUP BY ub.departamento, ub.municipio
ORDER BY ub.departamento ASC, ub.municipio ASC;

-- CONSULTA #3 - GROUP BY
 
SELECT
    ub.municipio,
    a.nombre_apiario                   AS apiario,
    COUNT(DISTINCT u.usuario_id)       AS total_productores,
    COUNT(DISTINCT ua.apiario_id)      AS total_apiarios
FROM usuario u
    JOIN usuario_apiario ua ON u.usuario_id  = ua.usuario_id    -- productor → relación apiario
    JOIN apiario a          ON ua.apiario_id = a.apiario_id     -- datos del apiario
    JOIN ubicacion ub       ON a.ubicacion_id = ub.ubicacion_id -- municipio del apiario
WHERE u.rol_id = 2
  AND ub.departamento = 'Antioquia'
GROUP BY ub.municipio, a.nombre_apiario
ORDER BY ub.municipio ASC, a.nombre_apiario ASC;

-- CONSULTA #4 - GROUP BY + HAVING

SELECT
    ub.municipio,
    a.nombre_apiario                          AS apiario,
    COUNT(DISTINCT pe.pedido_id)              AS total_pedidos,
    SUM(dp.cantidad * dp.precio_unitario)     AS total_cop
FROM pedido pe
    JOIN mercado m        ON pe.mercado_id     = m.mercado_id        -- mercado del pedido
    JOIN ubicacion ub     ON m.ubicacion_id    = ub.ubicacion_id     -- municipio del mercado
    JOIN detalle_pedido dp ON pe.pedido_id     = dp.pedido_id        -- líneas del pedido
    JOIN publicacion pub  ON dp.publicacion_id = pub.publicacion_id  -- publicación vendida
    JOIN lote_producto lp ON pub.lote_id       = lp.lote_id          -- lote del producto
    JOIN colmena c        ON lp.colmena_id     = c.colmena_id        -- colmena de origen
    JOIN apiario a        ON c.apiario_id      = a.apiario_id        -- apiario proveedor
WHERE ub.departamento = 'Boyacá'
GROUP BY ub.municipio, a.nombre_apiario
HAVING SUM(dp.cantidad * dp.precio_unitario) > 5000000              -- filtro arbitrario: > $5.000.000
ORDER BY total_cop DESC;

-- CONSULTA #5 - GROUP BY

SELECT
    ub.departamento,
    ub.municipio,
    p.nombre_producto,
    COUNT(DISTINCT pe.pedido_id)   AS total_pedidos,
    SUM(dp.cantidad)               AS cantidad_total_unidades
FROM producto p
    JOIN lote_producto lp ON p.producto_id     = lp.producto_id      -- lote del producto
    JOIN publicacion pub  ON lp.lote_id        = pub.lote_id         -- publicación del lote
    JOIN detalle_pedido dp ON pub.publicacion_id = dp.publicacion_id -- pedidos que la incluyen
    JOIN pedido pe        ON dp.pedido_id      = pe.pedido_id         -- datos del pedido
    JOIN mercado m        ON pe.mercado_id     = m.mercado_id         -- mercado del pedido
    JOIN ubicacion ub     ON m.ubicacion_id    = ub.ubicacion_id      -- ubicación
GROUP BY ub.departamento, ub.municipio, p.nombre_producto
ORDER BY total_pedidos DESC;

-- CONSULTAS ANALÍTICAS PARA RESPONDER LAS PREGUNTAS
 
-- Pregunta 1: ¿Quién fue el productor que más recibió pedidos?
SELECT
    u.usuario_id,
    u.nombre_usuario                  AS productor,
    COUNT(DISTINCT pe.pedido_id)      AS total_pedidos_recibidos
FROM usuario u
    JOIN publicacion pub  ON u.usuario_id      = pub.usuario_id
    JOIN detalle_pedido dp ON pub.publicacion_id = dp.publicacion_id
    JOIN pedido pe        ON dp.pedido_id      = pe.pedido_id
WHERE u.rol_id = 2
GROUP BY u.usuario_id, u.nombre_usuario
ORDER BY total_pedidos_recibidos DESC
LIMIT 1;
 
-- Pregunta 2: ¿Cuál departamento recibió más pedidos y cuál menos?
SELECT
    ub.departamento,
    COUNT(DISTINCT pe.pedido_id)  AS total_pedidos
FROM pedido pe
    JOIN mercado m    ON pe.mercado_id  = m.mercado_id
    JOIN ubicacion ub ON m.ubicacion_id = ub.ubicacion_id
GROUP BY ub.departamento
ORDER BY total_pedidos DESC;           -- primer registro = más pedidos, último = menos
 
-- Pregunta 3: ¿Cuál fue el producto que recibió menos pedidos?
SELECT
    p.nombre_producto,
    COUNT(DISTINCT pe.pedido_id)  AS total_pedidos
FROM producto p
    JOIN lote_producto lp  ON p.producto_id      = lp.producto_id
    JOIN publicacion pub   ON lp.lote_id         = pub.lote_id
    JOIN detalle_pedido dp ON pub.publicacion_id = dp.publicacion_id
    JOIN pedido pe         ON dp.pedido_id       = pe.pedido_id
GROUP BY p.nombre_producto
ORDER BY total_pedidos ASC
LIMIT 1;
 
-- Pregunta 4: ¿Cuál fue el municipio con el mayor monto (COP) de pedidos?
SELECT
    ub.municipio,
    SUM(pe.valor_total)  AS total_cop
FROM pedido pe
    JOIN mercado m    ON pe.mercado_id  = m.mercado_id
    JOIN ubicacion ub ON m.ubicacion_id = ub.ubicacion_id
GROUP BY ub.municipio
ORDER BY total_cop DESC
LIMIT 1;
