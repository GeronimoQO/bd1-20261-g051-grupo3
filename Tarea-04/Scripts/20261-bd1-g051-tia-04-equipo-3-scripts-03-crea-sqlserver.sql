CREATE TABLE rol (
    rol_id INT IDENTITY(1,1) PRIMARY KEY,
    nombre_rol VARCHAR(50) NOT NULL UNIQUE,
    descripcion_rol VARCHAR(MAX) NULL
);

CREATE TABLE ubicacion (
    ubicacion_id INT IDENTITY(1,1) PRIMARY KEY,
    departamento VARCHAR(100) NOT NULL,
    municipio VARCHAR(100) NOT NULL,
    codigo_dane CHAR(8) UNIQUE NULL
);

CREATE TABLE usuario (
    usuario_id INT IDENTITY(1,1) PRIMARY KEY,
    nombre_usuario VARCHAR(100) NOT NULL,
    correo_usuario VARCHAR(150) NOT NULL UNIQUE,
    contraseña_usuario VARCHAR(255) NOT NULL,
    telefono_usuario VARCHAR(20) NULL,
    fecha_registro DATE NOT NULL,
    usuario_activo BIT NOT NULL DEFAULT 1,
    rol_id INT NOT NULL,
    ubicacion_id INT NULL,

    CONSTRAINT FK_usuario_rol FOREIGN KEY (rol_id) REFERENCES rol(rol_id),
    CONSTRAINT FK_usuario_ubicacion FOREIGN KEY (ubicacion_id) REFERENCES ubicacion(ubicacion_id)
);

CREATE TABLE apiario (
    apiario_id INT IDENTITY(1,1) PRIMARY KEY,
    nombre_apiario VARCHAR(150) NOT NULL,
    direccion_apiario VARCHAR(255) NULL,
    coordenadas VARCHAR(100) NULL,
    registro_ica VARCHAR(50) UNIQUE NULL,
    fecha_registro DATE NOT NULL,
    ubicacion_id INT NOT NULL,

    CONSTRAINT FK_apiario_ubicacion FOREIGN KEY (ubicacion_id) REFERENCES ubicacion(ubicacion_id)
);

CREATE TABLE usuario_apiario (
    usuario_id INT NOT NULL,
    apiario_id INT NOT NULL,
    fecha_asignacion DATE NOT NULL,
    rol_apiario VARCHAR(50) NULL,

    CONSTRAINT PK_usuario_apiario PRIMARY KEY (usuario_id, apiario_id),
    CONSTRAINT FK_usuario_apiario_usuario FOREIGN KEY (usuario_id) REFERENCES usuario(usuario_id),
    CONSTRAINT FK_usuario_apiario_apiario FOREIGN KEY (apiario_id) REFERENCES apiario(apiario_id)
);

CREATE TABLE colmena (
    colmena_id INT IDENTITY(1,1) PRIMARY KEY,
    codigo_colmena VARCHAR(30) NOT NULL UNIQUE,
    tipo_colmena VARCHAR(80) NULL,
    fecha_instalacion DATE NULL,
    estado_colmena VARCHAR(30) NOT NULL,
    apiario_id INT NOT NULL,

    CONSTRAINT FK_colmena_apiario FOREIGN KEY (apiario_id) REFERENCES apiario(apiario_id)
);

CREATE TABLE dispositivo_iot (
    dispositivo_id INT IDENTITY(1,1) PRIMARY KEY,
    codigo_dispositivo VARCHAR(50) NOT NULL UNIQUE,
    tipo_sensor VARCHAR(80) NOT NULL,
    marca_dispositivo VARCHAR(80) NULL,
    fecha_instalacion DATE NULL,
    dispositivo_activo BIT NOT NULL DEFAULT 1,
    colmena_id INT NOT NULL,

    CONSTRAINT FK_dispositivo_colmena FOREIGN KEY (colmena_id) REFERENCES colmena(colmena_id)
);

CREATE TABLE telemetria (
    telemetria_id INT IDENTITY(1,1) PRIMARY KEY,
    fecha_hora DATETIME2 NOT NULL,
    temperatura_celcius DECIMAL(5,2) NULL,
    humedad_relativa DECIMAL(5,2) NULL,
    peso_kg DECIMAL(7,3) NULL,
    nivel_ruido DECIMAL(5,2) NULL,
    datos_sensor NVARCHAR(MAX) NULL,
    dispositivo_id INT NOT NULL,

    CONSTRAINT FK_telemetria_dispositivo FOREIGN KEY (dispositivo_id) REFERENCES dispositivo_iot(dispositivo_id)
);

CREATE TABLE bitacora_sanitaria (
    bitacora_id INT IDENTITY(1,1) PRIMARY KEY,
    fecha_event DATE NOT NULL,
    tipo_evento VARCHAR(80) NOT NULL,
    descripcion_bitacora VARCHAR(MAX) NULL,
    medicamento VARCHAR(150) NULL,
    dosis VARCHAR(80) NULL,
    proximo_control DATE NULL,
    colmena_id INT NOT NULL,

    CONSTRAINT FK_bitacora_colmena FOREIGN KEY (colmena_id) REFERENCES colmena(colmena_id)
);

CREATE TABLE producto (
    producto_id INT IDENTITY(1,1) PRIMARY KEY,
    nombre_producto VARCHAR(100) NOT NULL,
    tipo_product VARCHAR(80) NOT NULL,
    descripcion_producto VARCHAR(MAX) NULL,
    unidad_medida VARCHAR(30) NOT NULL
);

CREATE TABLE lote_producto (
    lote_id INT IDENTITY(1,1) PRIMARY KEY,
    codigo_lote VARCHAR(50) NOT NULL UNIQUE,
    fecha_cosecha DATE NOT NULL,
    cantidad_producida DECIMAL(10,3) NOT NULL,
    observaciones VARCHAR(MAX) NULL,
    colmena_id INT NOT NULL,
    producto_id INT NOT NULL,

    CONSTRAINT FK_lote_colmena FOREIGN KEY (colmena_id) REFERENCES colmena(colmena_id),
    CONSTRAINT FK_lote_producto FOREIGN KEY (producto_id) REFERENCES producto(producto_id)
);

CREATE TABLE certificacion (
    certificado_id INT IDENTITY(1,1) PRIMARY KEY,
    nombre_certificado VARCHAR(150) NOT NULL,
    entidad_emisora VARCHAR(150) NOT NULL,
    numero_certificado VARCHAR(80) NOT NULL UNIQUE,
    fecha_emision DATE NOT NULL,
    fecha_vencimiento DATE NULL,
    url_documento VARCHAR(500) NULL,
    usuario_id INT NOT NULL,

    CONSTRAINT FK_certificacion_usuario FOREIGN KEY (usuario_id) REFERENCES usuario(usuario_id)
);

CREATE TABLE publicacion (
    publicacion_id INT IDENTITY(1,1) PRIMARY KEY,
    titulo_publicacion VARCHAR(200) NOT NULL,
    descripcion_publicacion VARCHAR(MAX) NULL,
    precio_unitario DECIMAL(12,2) NOT NULL,
    cantidad_disponible DECIMAL(10,3) NOT NULL,
    fecha_publicacion DATE NOT NULL,
    publicacion_active BIT NOT NULL DEFAULT 1,
    lote_id INT NOT NULL,
    usuario_id INT NOT NULL,

    CONSTRAINT FK_publicacion_lote FOREIGN KEY (lote_id) REFERENCES lote_producto(lote_id),
    CONSTRAINT FK_publicacion_usuario FOREIGN KEY (usuario_id) REFERENCES usuario(usuario_id)
);

CREATE TABLE transaccion (
    transaccion_id INT IDENTITY(1,1) PRIMARY KEY,
    fecha_transaccion DATETIME2 NOT NULL,
    tipo_transaccion VARCHAR(50) NOT NULL,
    valor_total DECIMAL(14,2) NOT NULL,
    estado_transaccion VARCHAR(30) NOT NULL,
    usuario_id INT NOT NULL,

    CONSTRAINT FK_transaccion_usuario FOREIGN KEY (usuario_id) REFERENCES usuario(usuario_id)
);

CREATE TABLE transaccion_publicacion (
    transaccion_id INT NOT NULL,
    publicacion_id INT NOT NULL,
    cantidad_comprada DECIMAL(10,3) NOT NULL,
    precio_acordado DECIMAL(12,2) NOT NULL,

    CONSTRAINT PK_transaccion_publicacion PRIMARY KEY (transaccion_id, publicacion_id),
    CONSTRAINT FK_transaccion_pub_transaccion FOREIGN KEY (transaccion_id) REFERENCES transaccion(transaccion_id),
    CONSTRAINT FK_transaccion_pub_publicacion FOREIGN KEY (publicacion_id) REFERENCES publicacion(publicacion_id)
);

CREATE TABLE bolsa_empleo (
    bolsa_id INT IDENTITY(1,1) PRIMARY KEY,
    titulo_oferta VARCHAR(200) NOT NULL,
    descripcion_oferta VARCHAR(MAX) NOT NULL,
    tipo_oferta VARCHAR(80) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_cierre DATE NULL,
    oferta_activa BIT NOT NULL DEFAULT 1,
    usuario_id INT NOT NULL,

    CONSTRAINT FK_bolsa_empleo_usuario FOREIGN KEY (usuario_id) REFERENCES usuario(usuario_id)
);