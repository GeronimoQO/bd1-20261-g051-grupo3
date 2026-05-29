-- PASO 1: INSERCIÓN DE UN APIARIO CON DATO JSONB

 
INSERT INTO apiario (nombre_apiario, direccion_apiario, ubicacion_geografica, registro_ica, ubicacion_id)
VALUES (
    'Apiario El Porvenir',
    'Vereda El Porvenir, km 12, vía Paipa',
    '{
        "coordenadas": {
            "latitud":  5.78432,
            "longitud": -73.11560
        },
        "altitud_msnm": 2540,
        "tipo_zona": "rural",
        "condiciones_ambientales": {
            "flora_dominante": ["eucalipto", "mora", "acacia"],
            "fuente_agua_cercana": true,
            "temperatura_promedio_c": 16
        }
    }',
    'ICA-00201',
    15                      -- ubicacion_id 15 = Paipa, Boyacá
);

-- PASO 2: CONSULTA DEL DATO JSONB

 
-- -- Consulta general del apiario recién insertado --
SELECT
    apiario_id,
    nombre_apiario,
    ubicacion_geografica -> 'coordenadas'                         AS coordenadas,
    (ubicacion_geografica -> 'altitud_msnm')::INTEGER             AS altitud_msnm,
    ubicacion_geografica ->> 'tipo_zona'                          AS tipo_zona,
    ubicacion_geografica -> 'condiciones_ambientales'             AS condiciones_ambientales
FROM apiario
WHERE registro_ica = 'ICA-00201';
 
 
-- -- Consulta de un valor anidado dentro del JSONB (temperatura) --
SELECT
    nombre_apiario,
    (ubicacion_geografica -> 'condiciones_ambientales' ->> 'temperatura_promedio_c')::NUMERIC AS temp_c,
    (ubicacion_geografica -> 'condiciones_ambientales' ->> 'fuente_agua_cercana')::BOOLEAN    AS agua_cercana
FROM apiario
WHERE registro_ica = 'ICA-00201';

-- PASO 3: ACTUALIZACIÓN DE UN DATO DENTRO DEL JSONB

-- -- Verificación ANTES de la actualización --
SELECT
    nombre_apiario,
    ubicacion_geografica -> 'condiciones_ambientales' AS condiciones_antes
FROM apiario
WHERE registro_ica = 'ICA-00201';
 
-- -- Actualización: la temperatura promedio cambia de 16°C a 18°C --
UPDATE apiario
SET ubicacion_geografica = jsonb_set(
    ubicacion_geografica,
    '{condiciones_ambientales, temperatura_promedio_c}',  -- ruta del campo a modificar
    '18',                                                  -- nuevo valor (JSONB)
    false                                                  -- no crear la clave si no existe
)
WHERE registro_ica = 'ICA-00201';
 
-- -- Verificación DESPUÉS de la actualización --
SELECT
    nombre_apiario,
    ubicacion_geografica -> 'condiciones_ambientales' AS condiciones_despues
FROM apiario
WHERE registro_ica = 'ICA-00201';
