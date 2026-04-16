--Tablas independientes

-- 1. TABLA: rol
DROP TABLE IF EXISTS rol CASCADE;

CREATE TABLE rol (
    rol_id      INTEGER      GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre_rol  VARCHAR(50)  NOT NULL UNIQUE,
    descripcion TEXT
);

--2. TABLA: ubicacion
CREATE TABLE ubicacion (
    ubicacion_id  INTEGER      GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    departamento  VARCHAR(100) NOT NULL,
    municipio     VARCHAR(100) NOT NULL,
    codigo_dane   CHAR(8)      UNIQUE
);

--3. TABLA: producto
CREATE TABLE producto (
    producto_id     INTEGER      GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre_producto VARCHAR(100) NOT NULL,
    tipo_producto   VARCHAR(80)  NOT NULL,
    descripcion     TEXT,
    unidad_medida   VARCHAR(30)  NOT NULL
);

--Tablas dependientes

--4. TABLA: usuario
CREATE TABLE usuario (
    usuario_id     INTEGER      GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre_usuario VARCHAR(100) NOT NULL,
    correo         VARCHAR(150) NOT NULL UNIQUE,
    contrasena     VARCHAR(255) NOT NULL,
    telefono       VARCHAR(20),
    fecha_registro DATE         NOT NULL DEFAULT CURRENT_DATE,
    activo         BOOLEAN      NOT NULL DEFAULT TRUE,
    rol_id         INTEGER      NOT NULL,
    ubicacion_id   INTEGER,
 
    CONSTRAINT fk_usuario_rol
        FOREIGN KEY (rol_id)
        REFERENCES rol (rol_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
 
    CONSTRAINT fk_usuario_ubicacion
        FOREIGN KEY (ubicacion_id)
        REFERENCES ubicacion (ubicacion_id)
        ON UPDATE CASCADE
        ON DELETE SET NULL
);

--5. TABLA: apiario
CREATE TABLE apiario (
    apiario_id       	   INTEGER      GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre_apiario   	   VARCHAR(150) NOT NULL,
    direccion_apiario      VARCHAR(255),
    coordenadas    		   VARCHAR(100),
    registro_ica    	   VARCHAR(50)  UNIQUE,
    fecha_registro  	   DATE         NOT NULL DEFAULT CURRENT_DATE,
    ubicacion_id     	   INTEGER      NOT NULL,
 
    CONSTRAINT fk_apiario_ubicacion
        FOREIGN KEY (ubicacion_id)
        REFERENCES ubicacion (ubicacion_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

--6. TABLA: usuario_apiario
CREATE TABLE usuario_apiario (
    usuario_id       	INTEGER     NOT NULL,
    apiario_id       	INTEGER     NOT NULL,
    fecha_asignacion 	DATE        NOT NULL DEFAULT CURRENT_DATE,
    rol_apiario   		VARCHAR(50),
 
    CONSTRAINT pk_usuario_apiario
        PRIMARY KEY (usuario_id, apiario_id),
 
    CONSTRAINT fk_usuario_apiario_usuario
        FOREIGN KEY (usuario_id)
        REFERENCES usuario (usuario_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
 
    CONSTRAINT fk_usuario_apiario_apiario
        FOREIGN KEY (apiario_id)
        REFERENCES apiario (apiario_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

--7. TABLA: colmena
CREATE TABLE colmena (
    colmena_id        INTEGER     GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    codigo_colmena    VARCHAR(30) NOT NULL UNIQUE,
    tipo_colmena      VARCHAR(80),
    fecha_instalacion DATE,
    estado_colmena    VARCHAR(30) NOT NULL DEFAULT 'Activa',
    apiario_id        INTEGER     NOT NULL,
 
    CONSTRAINT fk_colmena_apiario
        FOREIGN KEY (apiario_id)
        REFERENCES apiario (apiario_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

--8. TABLA: dispositivo iot
CREATE TABLE dispositivo_iot (
    dispositivo_id     INTEGER     GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    codigo_dispositivo VARCHAR(50) NOT NULL UNIQUE,
    tipo_sensor        VARCHAR(80) NOT NULL,
    marca_dispositivo  VARCHAR(80),
    fecha_instalacion  DATE,
    dispositivo_activo BOOLEAN     NOT NULL DEFAULT TRUE,
    colmena_id         INTEGER     NOT NULL,
 
    CONSTRAINT fk_dispositivo_colmena
        FOREIGN KEY (colmena_id)
        REFERENCES colmena (colmena_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

--9. TABLA: telemetria
CREATE TABLE telemetria (
    telemetria_id  			INTEGER    GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    fecha_hora     			TIMESTAMP  NOT NULL DEFAULT NOW(),
    temperatura_celcius		NUMERIC(5,2),
    humedad_relativa	    NUMERIC(5,2),
    peso_kg        			NUMERIC(7,3),
    nivel_ruido 			NUMERIC(5,2),
    datos_sensor   			JSONB,
    dispositivo_id 			INTEGER    NOT NULL,
 
    CONSTRAINT fk_telemetria_dispositivo
        FOREIGN KEY (dispositivo_id)
        REFERENCES dispositivo_iot (dispositivo_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

--10. TABLA: bitacora sanitaria
CREATE TABLE bitacora_sanitaria (
    bitacora_id     		INTEGER     GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    fecha_evento     		DATE        NOT NULL,
    tipo_evento        		VARCHAR(80) NOT NULL,
    descripcion_evento      TEXT,
    medicamento		 		VARCHAR(150),
    dosis_tratamiento		VARCHAR(80),
    proximo_control    		DATE,
    colmena_id      		INTEGER     NOT NULL,
 
    CONSTRAINT fk_bitacora_colmena
        FOREIGN KEY (colmena_id)
        REFERENCES colmena (colmena_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

--11. TABLA: lote_produnto
CREATE TABLE lote_producto (
    lote_id       			INTEGER      GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    codigo_lote   			VARCHAR(50)  NOT NULL UNIQUE,
    fecha_cosecha    		DATE         NOT NULL,
    cantidad_producida      NUMERIC(10,3) NOT NULL,
    observaciones  			TEXT,
    colmena_id      		INTEGER      NOT NULL,
    producto_id     		INTEGER      NOT NULL,
 
    CONSTRAINT fk_lote_colmena
        FOREIGN KEY (colmena_id)
        REFERENCES colmena (colmena_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
 
    CONSTRAINT fk_lote_producto
        FOREIGN KEY (producto_id)
        REFERENCES producto (producto_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

--12. TABLA: certificaion
CREATE TABLE certificacion (
    certificado_id          INTEGER      GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre_certificado      VARCHAR(150) NOT NULL,
    entidad_emisora  		VARCHAR(150) NOT NULL,
    numero_certificado      VARCHAR(80)  NOT NULL UNIQUE,
    fecha_emision    		DATE         NOT NULL,
    fecha_vencimiento 		DATE,
    url_documento    		VARCHAR(500),
    usuario_id       		INTEGER      NOT NULL,
 
    CONSTRAINT fk_cert_usuario
        FOREIGN KEY (usuario_id)
        REFERENCES usuario (usuario_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

--13. TABLA: publicacion
CREATE TABLE publicacion (
    publicacion_id   			 INTEGER       GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    titulo_publicacion           VARCHAR(200)  NOT NULL,
    descripcion_oferta	         TEXT,
    precio_unitario  			 NUMERIC(12,2) NOT NULL,
    cantidad_disponible 	     NUMERIC(10,3) NOT NULL,
    fecha_publicacion 		     DATE         NOT NULL DEFAULT CURRENT_DATE,
    publicacion_activa			 BOOLEAN       NOT NULL DEFAULT TRUE,
    lote_id          			 INTEGER       NOT NULL,
    usuario_id       			 INTEGER       NOT NULL,
 
    CONSTRAINT fk_publicacion_lote
        FOREIGN KEY (lote_id)
        REFERENCES lote_producto (lote_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
 
    CONSTRAINT fk_publicacion_usuario
        FOREIGN KEY (usuario_id)
        REFERENCES usuario (usuario_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

--14. TABLA: transaccion
CREATE TABLE transaccion (
    transaccion_id 			   INTEGER       GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    fecha_transaccion		   TIMESTAMP     NOT NULL DEFAULT NOW(),
    tipo_transaccion		   VARCHAR(50)   NOT NULL,
    valor_total    			   NUMERIC(14,2) NOT NULL,
    estado_transaccion         VARCHAR(30)   NOT NULL DEFAULT 'Pendiente',
    usuario_id     			   INTEGER       NOT NULL,
 
    CONSTRAINT fk_transaccion_usuario
        FOREIGN KEY (usuario_id)
        REFERENCES usuario (usuario_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

--15. TABLA: transaccion_publicacion
CREATE TABLE transaccion_publicacion (
    transaccion_id  		 INTEGER       NOT NULL,
    publicacion_id  		 INTEGER       NOT NULL,
    cantidad_comprada        NUMERIC(10,3) NOT NULL,
    precio_acordado 		 NUMERIC(12,2) NOT NULL,
 
    CONSTRAINT pk_transaccion_publicacion_publicacion
        PRIMARY KEY (transaccion_id, publicacion_id),
 
    CONSTRAINT fk_transaccion_publicacion_transaccion
        FOREIGN KEY (transaccion_id)
        REFERENCES transaccion (transaccion_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
 
    CONSTRAINT fk_transaccion_publicacion_publicacion
        FOREIGN KEY (publicacion_id)
        REFERENCES publicacion (publicacion_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

--16. TABLA: bolsa_empleo
CREATE TABLE bolsa_empleo (
    bolsa_id                INTEGER      GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    titulo_oferta           VARCHAR(200) NOT NULL,
    descripcion_oferta      TEXT         NOT NULL,
    tipo_oferta             VARCHAR(80)  NOT NULL,
    fecha_inicio            DATE        NOT NULL DEFAULT CURRENT_DATE,
    fecha_cierre            DATE,
    oferta_activa           BOOLEAN      NOT NULL DEFAULT TRUE,
    usuario_id              INTEGER      NOT NULL,
 
    CONSTRAINT fk_bolsa_usuario
        FOREIGN KEY (usuario_id)
        REFERENCES usuario (usuario_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);