-- 1.- DATOS SEMI-ESTRUCTURADOS PARA DATOS IoT (Sensores)

-- Insertar una ubicacion de prueba
INSERT INTO ubicacion (departamento, municipio, codigo_dane)
VALUES ('Antioquia', 'Medellín', 'ANT001');

-- Insertar un apiario de prueba
INSERT INTO apiario (nombre_apiario, direccion_apiario, coordenadas, registro_ica, fecha_registro, ubicacion_id)
VALUES ('Apiario La Montaña', 'Vereda El Carmelo km 5', '6.2518,-75.5636', 'ICA-2024-001', '2024-01-15', 1);

-- Insertar una colmena de prueba
INSERT INTO colmena (codigo_colmena, tipo_colmena, estado_colmena, apiario_id)
VALUES ('COL-001', 'Langstroth', 'Activa', 1);

-- 1.1.- Agregar campo JSONB a la tabla telemetria
ALTER TABLE telemetria
    ADD COLUMN datos_ambientales JSONB;

-- 1.2.- Agregar registros con datos IoT en formato JSONB

-- Primero necesitamos un dispositivo para referenciar
INSERT INTO dispositivo_iot (codigo_dispositivo, tipo_sensor, marca_dispositivo, dispositivo_activo, colmena_id)
VALUES ('SENS-001', 'Multisensor', 'SensorBee', TRUE, 2);

INSERT INTO dispositivo_iot (codigo_dispositivo, tipo_sensor, marca_dispositivo, dispositivo_activo, colmena_id)
VALUES ('SENS-002', 'Temperatura/Humedad', 'ApiTech', TRUE, 2);

INSERT INTO telemetria (fecha_hora, temperatura_celcius, humedad_relativa, peso_kg, nivel_ruido, datos_ambientales, dispositivo_id)
VALUES (
    '2026-04-12 08:00:00',
    28.5, 72.0, 42.7, 35.0,
    '{
        "timestamp": "2026-04-12T08:00:00",
        "temperatura_c": 28.5,
        "humedad_relativa": 72,
        "nivel_ruido_db": 35,
        "peso_colmena_kg": 42.7,
        "alertas": {
            "sobrecalentamiento": false,
            "humedad_alta": true,
            "peso_bajo": false
        },
        "estado_colmena": "estable"
    }'::JSONB,
    4
);

INSERT INTO telemetria (fecha_hora, temperatura_celcius, humedad_relativa, peso_kg, nivel_ruido, datos_ambientales, dispositivo_id)
VALUES (
    '2026-04-12 14:30:00',
    35.2, 85.0, 41.3, 52.0,
    '{
        "timestamp": "2026-04-12T14:30:00",
        "temperatura_c": 35.2,
        "humedad_relativa": 85,
        "nivel_ruido_db": 52,
        "peso_colmena_kg": 41.3,
        "alertas": {
            "sobrecalentamiento": true,
            "humedad_alta": true,
            "peso_bajo": true
        },
        "estado_colmena": "alerta",
        "bateria_dispositivo_pct": 62,
        "co2_ppm": 412
    }'::JSONB,
    5
);	 

-- 1.3.- Consultar la información agregada

-- Consulta 1: Ver todos los registros con su JSONB completo
SELECT
    telemetria_id,
    fecha_hora,
    datos_ambientales
FROM telemetria
WHERE datos_ambientales IS NOT NULL;

-- Consulta 2: Extraer campos específicos del JSONB
SELECT
    telemetria_id,
    fecha_hora,
    datos_ambientales->>'estado_colmena' AS estado,
    datos_ambientales->>'temperatura_c'  AS temperatura,
    datos_ambientales->'alertas'->>'sobrecalentamiento' AS alerta_calor
FROM telemetria
WHERE datos_ambientales IS NOT NULL;

-- Consulta 3: Filtrar colmenas en estado de alerta
SELECT
    telemetria_id,
    fecha_hora,
    datos_ambientales->>'estado_colmena' AS estado
FROM telemetria
WHERE datos_ambientales @> '{"estado_colmena": "alerta"}';

-- 2.- DATOS SEMI-ESTRUCTURADOS (PARA BIG DATA o IoT)

-- 2.1.- Agregar campo JSONB a la tabla apiario
ALTER TABLE apiario
    ADD COLUMN condiciones_entorno JSONB;


-- 2.2.- Agregar registros con datos en formato JSONB
UPDATE apiario
SET condiciones_entorno = '{
    "altitud_msnm": 1850,
    "clima": "templado",
    "temperatura_promedio_c": 18,
    "humedad_promedio_pct": 75,
    "flora_cercana": ["eucalipto", "aguacate", "naranjo"],
    "fuentes_agua": ["quebrada", "pozo"],
    "riesgos": {
        "inundacion": false,
        "sequia": false,
        "contaminacion_agricola": true
    },
    "certificacion_organica": false
}'::JSONB
WHERE apiario_id = 1;

-- 2.3.- Consultar la información agregada

-- Consulta 1: Ver apiarios con sus condiciones de entorno
SELECT
    apiario_id,
    nombre_apiario,
    condiciones_entorno
FROM apiario
WHERE condiciones_entorno IS NOT NULL;

-- Consulta 2: Extraer campos específicos del JSONB
SELECT
    nombre_apiario,
    condiciones_entorno->>'clima'                  AS clima,
    condiciones_entorno->>'altitud_msnm'           AS altitud,
    condiciones_entorno->>'certificacion_organica' AS es_organico
FROM apiario
WHERE condiciones_entorno IS NOT NULL;

