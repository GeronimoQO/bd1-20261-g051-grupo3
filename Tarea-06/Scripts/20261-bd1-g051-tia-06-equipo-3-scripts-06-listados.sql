-- CONSULTA #1 - SIN JOIN

 SELECT
    ubicacion_id  AS codigo,
    municipio,
    departamento
FROM ubicacion
ORDER BY municipio ASC;

-- CONSULTA #2

SELECT
    u.departamento,
    u.municipio,
    m.nombre_mercado,
    m.tipo_mercado
FROM ubicacion u
    JOIN mercado m ON u.ubicacion_id = m.ubicacion_id
ORDER BY u.departamento ASC, u.municipio ASC;

-- CONSULTA #3
 
SELECT
    ub.municipio,
    u.usuario_id     AS cod_apicultor,
    u.nombre_usuario AS apicultor,
    a.apiario_id     AS cod_apiario,
    a.nombre_apiario AS apiario
FROM ubicacion ub
    JOIN usuario u ON ub.ubicacion_id = u.ubicacion_id    -- JOIN 1: apicultores del municipio
                   AND u.rol_id = 2
    JOIN apiario a ON ub.ubicacion_id = a.ubicacion_id    -- JOIN 2: apiarios del municipio
ORDER BY ub.municipio ASC, u.nombre_usuario ASC, a.nombre_apiario ASC
LIMIT 200;

-- CONSULTA #4 

SELECT
    u.usuario_id       AS cod_apicultor,
    u.nombre_usuario   AS apicultor,
    a.apiario_id       AS cod_apiario,
    a.nombre_apiario   AS apiario,
    p.producto_id      AS cod_producto,
    p.nombre_producto  AS producto,
    p.precio_unitario
FROM usuario u
    JOIN usuario_apiario ua ON u.usuario_id  = ua.usuario_id    -- JOIN 1: apicultor → relación apiario
    JOIN apiario a          ON ua.apiario_id = a.apiario_id     -- JOIN 2: datos del apiario
    JOIN colmena c          ON a.apiario_id  = c.apiario_id     -- JOIN 3: colmenas del apiario
    JOIN lote_producto lp   ON c.colmena_id  = lp.colmena_id   -- JOIN 4: lotes producidos
    JOIN producto p         ON lp.producto_id = p.producto_id   -- JOIN 5: nombre del producto
WHERE u.rol_id = 2
ORDER BY u.nombre_usuario ASC, a.nombre_apiario ASC, p.nombre_producto ASC;
 
-- CONSULTA #5 - MÚLTIPLES JOIN (6 JOIN)

SELECT
    pe.pedido_id                    AS cod_pedido,
    pe.fecha_pedido,
    pe.estado_pedido,
    u.usuario_id                    AS cod_productor,
    u.nombre_usuario                AS productor,
    c.consumidor_id                 AS cod_consumidor,
    c.nombre                        AS consumidor,
    ub.municipio
FROM pedido pe
    JOIN mercado m        ON pe.mercado_id     = m.mercado_id        -- JOIN 1: mercado del pedido
    JOIN ubicacion ub     ON m.ubicacion_id    = ub.ubicacion_id     -- JOIN 2: municipio del mercado
    JOIN consumidor c     ON pe.consumidor_id  = c.consumidor_id     -- JOIN 3: datos del consumidor
    JOIN detalle_pedido dp ON pe.pedido_id     = dp.pedido_id        -- JOIN 4: líneas del pedido
    JOIN publicacion pub  ON dp.publicacion_id = pub.publicacion_id  -- JOIN 5: publicación vendida
    JOIN usuario u        ON pub.usuario_id    = u.usuario_id        -- JOIN 6: productor (apicultor)
WHERE ub.municipio = 'Medellín (Santa Elena)'
ORDER BY pe.fecha_pedido ASC;
