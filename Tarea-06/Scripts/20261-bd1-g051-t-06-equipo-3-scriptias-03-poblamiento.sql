-- 1. ROL
INSERT INTO rol (nombre_rol, descripcion) VALUES
    ('Administrador', 'Administra el sistema'),
    ('Apicultor',     'Produce y vende productos apícolas'),
    ('Técnico',       'Técnico de campo'),
    ('Coordinador',   'Coordina operaciones');

-- 2. UBICACION (39 municipios del Anexo B)
INSERT INTO ubicacion (departamento, municipio, codigo_dane) VALUES
    ('Antioquia',       'Caucasia',               '05154000'),
    ('Antioquia',       'El Bagre',               '05190000'),
    ('Antioquia',       'Zaragoza',               '05895000'),
    ('Antioquia',       'Santa Fe de Antioquia',  '05042000'),
    ('Antioquia',       'Medellín (Santa Elena)', '05001001'),
    ('Cundinamarca',    'Fusagasugá',             '25290000'),
    ('Cundinamarca',    'Girardot',               '25307000'),
    ('Cundinamarca',    'Ubaté',                  '25817000'),
    ('Cundinamarca',    'Zipaquirá',              '25899000'),
    ('Cundinamarca',    'La Mesa',                '25430000'),
    ('Boyacá',          'Tunja',                  '15001000'),
    ('Boyacá',          'Duitama',                '15244000'),
    ('Boyacá',          'Sogamoso',               '15762000'),
    ('Boyacá',          'Chiquinquirá',           '15176000'),
    ('Boyacá',          'Paipa',                  '15516000'),
    ('Santander',       'Bucaramanga',            '68001000'),
    ('Santander',       'San Gil',                '68679000'),
    ('Santander',       'Socorro',                '68755000'),
    ('Santander',       'Barbosa',                '68081000'),
    ('Huila',           'Neiva',                  '41001000'),
    ('Huila',           'Pitalito',               '41551000'),
    ('Huila',           'Garzón',                 '41298000'),
    ('Huila',           'La Plata',               '41396000'),
    ('Meta',            'Villavicencio',           '50001000'),
    ('Meta',            'Granada',                '50313000'),
    ('Meta',            'Acacías',                '50006000'),
    ('Córdoba',         'Montería',               '23001000'),
    ('Córdoba',         'Planeta Rica',           '23555000'),
    ('Córdoba',         'Sahagún',                '23660000'),
    ('Sucre',           'Sincelejo',              '70001000'),
    ('Sucre',           'Corozal',                '70215000'),
    ('Sucre',           'Sampués',                '70670000'),
    ('Magdalena',       'Santa Marta',            '47001000'),
    ('Magdalena',       'Ciénaga',                '47189000'),
    ('Magdalena',       'Fundación',              '47288000'),
    ('Valle del Cauca', 'Cali',                   '76001000'),
    ('Valle del Cauca', 'Palmira',                '76520000'),
    ('Valle del Cauca', 'Buga',                   '76111000'),
    ('Valle del Cauca', 'Tuluá',                  '76834000');

-- 3. PRODUCTO (Anexo C - 6 productos)
INSERT INTO producto (nombre_producto, tipo_producto, descripcion, unidad_medida, precio_unitario) VALUES
    ('Miel',       'Miel',       'Miel de abejas natural sin procesar',              '1 kg',    25000.00),
    ('Polen',      'Polen',      'Polen apícola deshidratado para consumo humano',   '250 g',   20000.00),
    ('Propóleo',   'Propóleo',   'Extracto alcohólico con propiedad antimicrobiana', '30 ml',   35000.00),
    ('Jalea Real', 'Jalea Real', 'Jalea real fresca de alta pureza',                '10-20 g', 40000.00),
    ('Cera',       'Cera',       'Cera natural de abejas en bloque',                 '1 kg',    30000.00),
    ('Apitoxina',  'Apitoxina',  'Veneno de abeja para uso terapéutico certificado', '1 g',    300000.00);

-- 4. USUARIO - 1 admin
INSERT INTO usuario (nombre_usuario, correo, contrasena, telefono, rol_id, ubicacion_id)
VALUES ('Admin Sistema', 'admin@redapicola.co', 'hash_admin', '6044441122', 1, 1);

-- 100 Apicultores (rol_id = 2)
INSERT INTO usuario (nombre_usuario, correo, contrasena, telefono, rol_id, ubicacion_id)
SELECT
    'Apicultor ' || gs,
    'apicultor' || gs || '@redapicola.co',
    md5(gs::text),
    '30' || lpad((gs * 7919 % 100000000)::text, 8, '0'),
    2,
    (gs % 39) + 1
FROM generate_series(1, 100) AS gs;

-- 10 Técnicos (rol_id = 3)
INSERT INTO usuario (nombre_usuario, correo, contrasena, telefono, rol_id, ubicacion_id)
SELECT
    'Técnico ' || gs,
    'tecnico' || gs || '@redapicola.co',
    md5('tec' || gs::text),
    '31' || lpad((gs * 1234 % 100000000)::text, 8, '0'),
    3,
    (gs % 39) + 1
FROM generate_series(1, 10) AS gs;

-- 5. APIARIO - 200 apiarios
INSERT INTO apiario (nombre_apiario, direccion_apiario, ubicacion_geografica, registro_ica, ubicacion_id)
SELECT
    'Apiario ' || gs,
    'Vereda Rural, km ' || (gs % 15 + 1),
    jsonb_build_object(
        'coordenadas', jsonb_build_object(
            'latitud',  round((4.0 + (gs % 8))::numeric, 5),
            'longitud', round((-74.0 - (gs % 5))::numeric, 5)
        ),
        'altitud_msnm', 500 + (gs % 2500),
        'tipo_zona', 'rural',
        'condiciones_ambientales', jsonb_build_object(
            'flora_dominante', '["eucalipto","café"]'::jsonb,
            'fuente_agua_cercana', true
        )
    ),
    'ICA-' || lpad(gs::text, 5, '0'),
    (gs % 39) + 1
FROM generate_series(1, 200) AS gs;

-- 6. USUARIO_APIARIO
INSERT INTO usuario_apiario (usuario_id, apiario_id, rol_apiario)
SELECT
    (gs % 100) + 2,
    gs,
    'Propietario'
FROM generate_series(1, 200) AS gs;

-- 7. COLMENA - 2 por apiario = 400 colmenas
INSERT INTO colmena (codigo_colmena, tipo_colmena, fecha_instalacion, estado_colmena, apiario_id)
SELECT
    'COL-' || lpad(gs::text, 4, '0'),
    (ARRAY['Langstroth','Warre','Layens'])[(gs % 3) + 1],
    DATE '2022-01-01' + ((gs % 730) || ' days')::interval,
    CASE WHEN gs % 10 = 0 THEN 'Inactiva' ELSE 'Activa' END,
    (gs % 200) + 1
FROM generate_series(1, 400) AS gs;

-- 8. MERCADO - 1 por municipio = 39 mercados
INSERT INTO mercado (nombre_mercado, direccion, tipo_mercado, ubicacion_id)
SELECT
    'Mercado Apícola ' || municipio,
    'Carrera ' || (ubicacion_id % 20 + 1) || ' # ' || (ubicacion_id % 15 + 1) || '-' || (ubicacion_id % 90 + 10) || ', Centro',
    CASE WHEN ubicacion_id % 5 = 0 THEN 'Virtual' ELSE 'Físico' END,
    ubicacion_id
FROM ubicacion;

-- 9. CONSUMIDOR - 50 por ubicación = 1950 consumidores
INSERT INTO consumidor (nombre, correo, telefono, ubicacion_id)
SELECT
    'Consumidor ' || gs,
    'consumidor' || gs || '@email.co',
    '30' || lpad((gs * 3571 % 100000000)::text, 8, '0'),
    (gs % 39) + 1
FROM generate_series(1, 1950) AS gs;

-- 10. LOTE_PRODUCTO - 1 por colmena = 400 lotes
INSERT INTO lote_producto (codigo_lote, fecha_cosecha, cantidad_producida, observaciones, colmena_id, producto_id)
SELECT
    'LOTE-2024-' || lpad(gs::text, 5, '0'),
    DATE '2024-01-01' + ((gs % 150) || ' days')::interval,
    round((5 + random() * 55)::numeric, 3),
    'Cosecha regular temporada 2024',
    gs,
    (gs % 6) + 1
FROM generate_series(1, 400) AS gs;

-- 11. PUBLICACION - 1 por lote = 400 publicaciones
INSERT INTO publicacion (titulo_publicacion, descripcion_oferta, precio_unitario, cantidad_disponible, lote_id, usuario_id)
SELECT
    'Venta producto apícola - Lote ' || gs,
    'Producto de calidad directo del apiario',
    (ARRAY[25000, 20000, 35000, 40000, 30000, 300000])[(gs % 6) + 1],
    round((5 + random() * 40)::numeric, 3),
    gs,
    (gs % 100) + 2
FROM generate_series(1, 400) AS gs;

-- 12. PEDIDO - 2000 pedidos
INSERT INTO pedido (fecha_pedido, estado_pedido, valor_total, consumidor_id, mercado_id)
SELECT
    TIMESTAMP '2024-01-01' + ((gs % 180) || ' days')::interval
                           + ((gs % 24) || ' hours')::interval,
    (ARRAY['Pendiente','En proceso','Entregado','Entregado','Entregado'])[(gs % 5) + 1],
    round((10000 + random() * 190000)::numeric, 2),
    (gs % 1950) + 1,
    (gs % 39)  + 1
FROM generate_series(1, 2000) AS gs;

-- 13. DETALLE_PEDIDO - 2 líneas por pedido = 4000 detalles
INSERT INTO detalle_pedido (pedido_id, publicacion_id, cantidad, precio_unitario)
SELECT
    gs AS pedido_id,
    ((gs - 1) % 400) + 1 AS publicacion_id,
    round((1 + random() * 4)::numeric, 3),
    (ARRAY[25000, 20000, 35000, 40000, 30000, 300000])[(gs % 6) + 1]
FROM generate_series(1, 2000) AS gs
UNION ALL
SELECT
    gs AS pedido_id,
    ((gs + 199) % 400) + 1 AS publicacion_id,
    round((1 + random() * 4)::numeric, 3),
    (ARRAY[25000, 20000, 35000, 40000, 30000, 300000])[(gs % 6) + 1]
FROM generate_series(1, 2000) AS gs;

SELECT 'rol'             AS tabla, COUNT(*) AS registros FROM rol
UNION ALL SELECT 'ubicacion',       COUNT(*) FROM ubicacion
UNION ALL SELECT 'producto',        COUNT(*) FROM producto
UNION ALL SELECT 'usuario',         COUNT(*) FROM usuario
UNION ALL SELECT 'apiario',         COUNT(*) FROM apiario
UNION ALL SELECT 'usuario_apiario', COUNT(*) FROM usuario_apiario
UNION ALL SELECT 'colmena',         COUNT(*) FROM colmena
UNION ALL SELECT 'mercado',         COUNT(*) FROM mercado
UNION ALL SELECT 'consumidor',      COUNT(*) FROM consumidor
UNION ALL SELECT 'lote_producto',   COUNT(*) FROM lote_producto
UNION ALL SELECT 'publicacion',     COUNT(*) FROM publicacion
UNION ALL SELECT 'pedido',          COUNT(*) FROM pedido
UNION ALL SELECT 'detalle_pedido',  COUNT(*) FROM detalle_pedido
ORDER BY tabla;
