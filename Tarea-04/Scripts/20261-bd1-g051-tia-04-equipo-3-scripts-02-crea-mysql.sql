CREATE TABLE rol (
    rol_id INT NOT NULL AUTO_INCREMENT, 
    nombre_rol VARCHAR(50) NOT NULL,
    descripcion_rol TEXT, 
    PRIMARY KEY (rol_id),
    UNIQUE (nombre_rol)
);

CREATE TABLE ubicacion (
    ubicacion_id INT NOT NULL AUTO_INCREMENT,
    departamento VARCHAR(100) NOT NULL,
    municipio VARCHAR(100) NOT NULL,
    codigo_dane CHAR(8),
    PRIMARY KEY (ubicacion_id),
    UNIQUE (codigo_dane)
);

CREATE TABLE usuario(
    usuario_id INT NOT NULL AUTO_INCREMENT,
    nombre_usuario VARCHAR(100) NOT NULL,
    correo_usuario VARCHAR(150) NOT NULL,
    contraseña_usuario VARCHAR(255) NOT NULL,
    telefono_usuario VARCHAR(20),
    fecha_registro DATE NOT NULL, 
    usuario_activo TINYINT NOT NULL,
    rol_id INT NOT NULL,
    ubicacion_id INT NOT NULL,
    PRIMARY KEY(usuario_id),
    CONSTRAINT fk_rol FOREIGN KEY (rol_id) REFERENCES rol (rol_id),
    CONSTRAINT fk_ubicacion FOREIGN KEY (ubicacion_id) REFERENCES ubicacion (ubicacion_id)
);

CREATE TABLE apiario (
    apiario_id INT NOT NULL AUTO_INCREMENT,
    nombre_apiario VARCHAR(150) NOT NULL,
    direccion_apiario VARCHAR(255),
    coordenadas VARCHAR(100),
    registro_ica VARCHAR(50),
    fecha_registro DATE NOT NULL,
    ubicacion_id INT NOT NULL,
    PRIMARY KEY (apiario_id),
    UNIQUE (registro_ica),
    CONSTRAINT fk_apiario_ubicacion FOREIGN KEY (ubicacion_id) REFERENCES ubicacion (ubicacion_id)
);

CREATE TABLE usuario_apiario (
    usuario_id INT NOT NULL,
    apiario_id INT NOT NULL,
    fecha_asignacion DATE NOT NULL,
    rol_apiario VARCHAR(50),
    PRIMARY KEY (usuario_id, apiario_id),
    CONSTRAINT fk_usuario_apiario_usuario FOREIGN KEY (usuario_id) REFERENCES usuario (usuario_id),
    CONSTRAINT fk_usuario_apiario_apiario FOREIGN KEY (apiario_id) REFERENCES apiario (apiario_id)
);

CREATE TABLE colmena (
    colmena_id INT NOT NULL AUTO_INCREMENT,
    codigo_colmena VARCHAR(30) NOT NULL,
    tipo_colmena VARCHAR(80),
    fecha_instalacion DATE,
    estado_colmena VARCHAR(30) NOT NULL,
    apiario_id INT NOT NULL,
    PRIMARY KEY (colmena_id),
    UNIQUE (codigo_colmena),
    CONSTRAINT fk_colmena_apiario FOREIGN KEY (apiario_id) REFERENCES apiario (apiario_id)
);

CREATE TABLE dispositivo_iot (
    dispositivo_id INT NOT NULL AUTO_INCREMENT,
    codigo_dispositivo VARCHAR(50) NOT NULL,
    tipo_sensor VARCHAR(80) NOT NULL,
    marca_dispositivo VARCHAR(80),
    fecha_instalacion DATE,
    dispositivo_activo TINYINT(1) NOT NULL DEFAULT 1,
    colmena_id INT NOT NULL,
    PRIMARY KEY (dispositivo_id),
    UNIQUE (codigo_dispositivo),
    CONSTRAINT fk_dispositivo_colmena FOREIGN KEY (colmena_id) REFERENCES colmena (colmena_id)
);

CREATE TABLE telemetria (
    telemetria_id INT NOT NULL AUTO_INCREMENT,
    fecha_hora DATETIME NOT NULL,
    temperatura_celcius DECIMAL(5,2),
    humedad_relativa DECIMAL(5,2),
    peso_kg DECIMAL(7,3),
    nivel_ruido DECIMAL(5,2),
    datos_sensor JSON,
    dispositivo_id INT NOT NULL,
    PRIMARY KEY (telemetria_id),
    CONSTRAINT fk_telemetria_dispositivo FOREIGN KEY (dispositivo_id) REFERENCES dispositivo_iot (dispositivo_id)
);

CREATE TABLE bitacora_sanitaria (
    bitacora_id INT NOT NULL AUTO_INCREMENT,
    fecha_evento DATE NOT NULL,
    tipo_evento VARCHAR(80) NOT NULL,
    descripcion_bitacora TEXT,
    medicamento VARCHAR(150),
    dosis VARCHAR(80),
    proximo_control DATE,
    colmena_id INT NOT NULL,
    PRIMARY KEY (bitacora_id),
    CONSTRAINT fk_bitacora_colmena FOREIGN KEY (colmena_id) REFERENCES colmena (colmena_id)
);

CREATE TABLE producto (
    producto_id INT NOT NULL AUTO_INCREMENT,
    nombre_producto VARCHAR(100) NOT NULL,
    tipo_producto VARCHAR(80) NOT NULL,
    descripcion_producto TEXT,
    unidad_medida VARCHAR(30) NOT NULL,
    PRIMARY KEY (producto_id)
);

CREATE TABLE lote_producto (
    lote_id INT NOT NULL AUTO_INCREMENT,
    codigo_lote VARCHAR(50) NOT NULL,
    fecha_cosecha DATE NOT NULL,
    cantidad_producida DECIMAL(10,3) NOT NULL,
    observaciones TEXT,
    colmena_id INT NOT NULL,
    producto_id INT NOT NULL,
    PRIMARY KEY (lote_id),
    UNIQUE (codigo_lote),
    CONSTRAINT fk_lote_colmena FOREIGN KEY (colmena_id) REFERENCES colmena (colmena_id),
    CONSTRAINT fk_lote_producto FOREIGN KEY (producto_id) REFERENCES producto (producto_id)
);

CREATE TABLE certificacion (
    certificado_id INT NOT NULL AUTO_INCREMENT,
    nombre_certificado VARCHAR(150) NOT NULL,
    entidad_emisora VARCHAR(150) NOT NULL,
    numero_certificado VARCHAR(80) NOT NULL,
    fecha_emission DATE NOT NULL,
    fecha_vencimiento DATE,
    url_documento VARCHAR(500),
    usuario_id INT NOT NULL,
    PRIMARY KEY (certificado_id),
    UNIQUE (numero_certificado),
    CONSTRAINT fk_certificacion_usuario FOREIGN KEY (usuario_id) REFERENCES usuario (usuario_id)
);

CREATE TABLE publicacion (
    publicacion_id INT NOT NULL AUTO_INCREMENT,
    titulo_publicacion VARCHAR(200) NOT NULL,
    descripcion_publicacion TEXT,
    precio_unitario DECIMAL(12,2) NOT NULL,
    cantidad_disponible DECIMAL(10,3) NOT NULL,
    fecha_publicacion DATE NOT NULL,
    publicacion_activa TINYINT(1) NOT NULL DEFAULT 1,
    lote_id INT NOT NULL,
    usuario_id INT NOT NULL,
    PRIMARY KEY (publicacion_id),
    CONSTRAINT fk_publicacion_lote FOREIGN KEY (lote_id) REFERENCES lote_producto (lote_id),
    CONSTRAINT fk_publicacion_usuario FOREIGN KEY (usuario_id) REFERENCES usuario (usuario_id)
);
    
CREATE TABLE transaccion (
    transaccion_id INT NOT NULL AUTO_INCREMENT,
    fecha_transaccion DATETIME NOT NULL,
    tipo_transaccion VARCHAR(50) NOT NULL,
    valor_total DECIMAL(14,2) NOT NULL,
    estado_transaccion VARCHAR(30) NOT NULL,
    usuario_id INT NOT NULL,
    PRIMARY KEY (transaccion_id),
    CONSTRAINT fk_transaccion_usuario FOREIGN KEY (usuario_id) REFERENCES usuario (usuario_id)
);

CREATE TABLE transaccion_publicacion (
    transaccion_id INT NOT NULL,
    publicacion_id INT NOT NULL,
    cantidad_comprada DECIMAL(10,3) NOT NULL,
    precio_acordado DECIMAL(12,2) NOT NULL,
    PRIMARY KEY (transaccion_id, publicacion_id),
    CONSTRAINT fk_publicacion_transaccion FOREIGN KEY (transaccion_id) REFERENCES transaccion (transaccion_id),
    CONSTRAINT fk_transaccion_publicacion FOREIGN KEY (publicacion_id) REFERENCES publicacion (publicacion_id)
);

CREATE TABLE bolsa_empleo (
    bolsa_id INT NOT NULL AUTO_INCREMENT,
    titulo_oferta VARCHAR(200) NOT NULL,
    descripcion_oferta TEXT NOT NULL,
    tipo_oferta VARCHAR(80) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_cierre DATE,
    oferta_activa TINYINT(1) NOT NULL DEFAULT 1,
    usuario_id INT NOT NULL,
    PRIMARY KEY (bolsa_id),
    CONSTRAINT fk_bolsa_usuario FOREIGN KEY (usuario_id) REFERENCES usuario (usuario_id)
);