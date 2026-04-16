-- Modificaciones--

-- 1.1.- Agregar un campo a la tabla "usuario" (productor de la red apícola)
	ALTER TABLE usuario
    	ADD COLUMN foto_perfil VARCHAR(500);

-- 1.2.- Modificar un campo de la tabla "usuario"
	ALTER TABLE usuario
    	ALTER COLUMN nombre_usuario TYPE VARCHAR(150);

-- 1.3.1.- Crear una tabla nueva coherente con el sistema
CREATE TABLE reporte_colmena (
    reporte_id      		INTEGER      GENERATED ALWAYS AS IDENTITY,
    titulo_reporte          VARCHAR(200) NOT NULL,
    descripcion_reporte     TEXT,
    productividad   		NUMERIC(5,2)
);

-- 1.3.2.- Agregar clave primaria y 3 campos a la tabla
ALTER TABLE reporte_colmena
    ADD CONSTRAINT pk_reporte_colmena PRIMARY KEY (reporte_id);
 
ALTER TABLE reporte_colmena
    ADD COLUMN tipo_reporte  VARCHAR(80),
    ADD COLUMN observaciones TEXT,
    ADD COLUMN puntaje       NUMERIC(4,1);

-- 1.3.3.- Quitar uno de los campos de la tabla
ALTER TABLE reporte_colmena
    DROP COLUMN observaciones;

-- 1.3.4.- Cambiar el nombre de la tabla
ALTER TABLE reporte_colmena
    RENAME TO inspeccion_colmena;

-- 1.3.5.- Agregar un campo único a la tabla renombrada
ALTER TABLE inspeccion_colmena
    ADD COLUMN codigo_inspeccion VARCHAR(50) UNIQUE;

-- 1.3.6.- Agregar 2 fechas de inicio y fin con control de orden
ALTER TABLE inspeccion_colmena
    ADD COLUMN fecha_inicio DATE,
    ADD COLUMN fecha_fin    DATE,
    ADD CONSTRAINT chk_orden_fechas
        CHECK (fecha_fin >= fecha_inicio);

-- 1.3.7.- Agregar 1 campo entero con control para que no sea negativo
ALTER TABLE inspeccion_colmena
    ADD COLUMN cantidad_abejas INTEGER,
    ADD CONSTRAINT chk_cantidad_no_negativa
        CHECK (cantidad_abejas >= 0);

-- 1.3.8.- Modificar el tamaño de un campo texto
ALTER TABLE inspeccion_colmena
    ALTER COLUMN tipo_reporte TYPE VARCHAR(120);

-- 1.3.9.- Modificar el campo numérico con control de rango
ALTER TABLE inspeccion_colmena
    ADD CONSTRAINT chk_rango_puntaje
        CHECK (puntaje BETWEEN 0 AND 10);

-- 1.3.10.- Agregar un índice a la tabla
CREATE INDEX idx_inspeccion_fecha_inicio
    ON inspeccion_colmena (fecha_inicio);

-- 1.3.11.- Eliminar una de las fechas
ALTER TABLE inspeccion_colmena
    DROP CONSTRAINT chk_orden_fechas;
 
ALTER TABLE inspeccion_colmena
    DROP COLUMN fecha_fin;

-- 1.3.10.- Borrar todos los datos de la tabla sin dejar traza
TRUNCATE TABLE inspeccion_colmena;

-- Insertar datos de prueba
INSERT INTO inspeccion_colmena (titulo_reporte, productividad, tipo_reporte, puntaje, codigo_inspeccion, fecha_inicio, cantidad_abejas)
VALUES 
    ('Inspección colmena 1', 85.5, 'Sanitario', 8.5, 'INS-001', '2026-03-01', 5000),
    ('Inspección colmena 2', 90.0, 'Productivo', 9.0, 'INS-002', '2026-03-15', 7000),
    ('Inspección colmena 3', 78.3, 'Sanitario', 7.5, 'INS-003', '2026-04-01', 4500);

-- Verificar que los datos existen
SELECT * FROM inspeccion_colmena;

