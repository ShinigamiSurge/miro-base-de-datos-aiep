/* =========================================================
   BASE DE DATOS - INVENTARIO JARDÍN INFANTIL
   PostgreSQL / Supabase
   ========================================================= */

/* =========================================================
   1. TABLA BODEGA
   ========================================================= */

CREATE TABLE bodega (
    id BIGSERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    activo BOOLEAN NOT NULL DEFAULT TRUE
);


/* =========================================================
   2. TABLA RESPONSABLE
   ========================================================= */

CREATE TABLE responsable (
    id BIGSERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    cargo VARCHAR(100),
    activo BOOLEAN NOT NULL DEFAULT TRUE
);


/* =========================================================
   3. TABLA PROVEEDOR
   ========================================================= */

CREATE TABLE proveedor (
    id BIGSERIAL PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    telefono VARCHAR(30),
    correo VARCHAR(150),
    direccion VARCHAR(200),
    activo BOOLEAN NOT NULL DEFAULT TRUE
);


/* =========================================================
   4. TABLA PRODUCTOS
   ========================================================= */

CREATE TABLE productos (
    id BIGSERIAL PRIMARY KEY,

    id_bodega BIGINT NOT NULL,

    nombre_producto VARCHAR(150) NOT NULL,

    descripcion TEXT,

    cantidad_peso NUMERIC(10,2) DEFAULT 0,

    stock INTEGER NOT NULL DEFAULT 0,

    ultima_entrada TIMESTAMP,

    ultima_salida TIMESTAMP,

    activo BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT fk_producto_bodega
        FOREIGN KEY (id_bodega)
        REFERENCES bodega(id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT chk_stock_positivo
        CHECK (stock >= 0),

    CONSTRAINT chk_cantidad_peso_positiva
        CHECK (cantidad_peso >= 0)
);


/* =========================================================
   5. TABLA MOVIMIENTO
   ========================================================= */

CREATE TABLE movimiento (
    id BIGSERIAL PRIMARY KEY,

    producto_id BIGINT NOT NULL,

    bodega_id BIGINT NOT NULL,

    tipo VARCHAR(20) NOT NULL,

    fecha TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    proveedor_id BIGINT,

    cantidad INTEGER NOT NULL,

    precio_unitario NUMERIC(12,2),

    observacion TEXT,

    motivo VARCHAR(200),

    id_responsable BIGINT NOT NULL,


    /* -----------------------------------------------------
       LLAVES FORÁNEAS
       ----------------------------------------------------- */

    CONSTRAINT fk_movimiento_producto
        FOREIGN KEY (producto_id)
        REFERENCES productos(id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT fk_movimiento_bodega
        FOREIGN KEY (bodega_id)
        REFERENCES bodega(id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT fk_movimiento_proveedor
        FOREIGN KEY (proveedor_id)
        REFERENCES proveedor(id)
        ON DELETE SET NULL
        ON UPDATE CASCADE,

    CONSTRAINT fk_movimiento_responsable
        FOREIGN KEY (id_responsable)
        REFERENCES responsable(id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,


    /* -----------------------------------------------------
       RESTRICCIONES
       ----------------------------------------------------- */

    CONSTRAINT chk_tipo_movimiento
        CHECK (tipo IN ('entrada', 'salida')),

    CONSTRAINT chk_cantidad_movimiento
        CHECK (cantidad > 0),

    CONSTRAINT chk_precio_unitario
        CHECK (
            precio_unitario IS NULL
            OR precio_unitario >= 0
        )
);


/* =========================================================
   6. DATOS DE LAS BODEGAS
   ========================================================= */

INSERT INTO bodega (
    nombre,
    descripcion
)
VALUES
(
    'Artículos fungibles',
    'Materiales utilizados habitualmente en actividades educativas y manualidades.'
),
(
    'Artículos de aseo',
    'Productos utilizados para la limpieza y desinfección del jardín infantil.'
),
(
    'Artículos de oficina',
    'Materiales utilizados para labores administrativas y de organización.'
);


/* =========================================================
   7. DATOS DE RESPONSABLES
   ========================================================= */

INSERT INTO responsable (
    nombre,
    apellido,
    cargo
)
VALUES
(
    'Carolina',
    'González',
    'Educadora'
),
(
    'Jorge',
    'Muñoz',
    'Encargado de bodega'
),
(
    'Marcela',
    'Rojas',
    'Administradora'
);


/* =========================================================
   8. DATOS DE PROVEEDORES
   ========================================================= */

INSERT INTO proveedor (
    nombre,
    telefono,
    correo,
    direccion
)
VALUES
(
    'Distribuidora Escolar SpA',
    '+56 9 1111 1111',
    'contacto@distribuidoraescolar.cl',
    'Santiago, Chile'
),
(
    'Productos Limpios Ltda.',
    '+56 9 2222 2222',
    'ventas@productoslimpios.cl',
    'Santiago, Chile'
),
(
    'Oficina y Papel SpA',
    '+56 9 3333 3333',
    'ventas@oficinaypapel.cl',
    'Santiago, Chile'
);


/* =========================================================
   9. PRODUCTOS
   ========================================================= */

/* ---------------------------------------------------------
   BODEGA 1 - ARTÍCULOS FUNGIBLES
   --------------------------------------------------------- */

INSERT INTO productos (
    id_bodega,
    nombre_producto,
    descripcion,
    cantidad_peso,
    stock
)
VALUES
(1, 'Lápices de colores',
 'Lápices de colores para actividades educativas y artísticas.',
 0.00, 125),

(1, 'Plumones',
 'Plumones lavables para actividades y manualidades.',
 0.00, 90),

(1, 'Crayones',
 'Crayones para actividades de dibujo infantil.',
 0.00, 115),

(1, 'Témpera',
 'Frascos de témpera de distintos colores.',
 5.00, 30),

(1, 'Pegamento en barra',
 'Pegamento en barra para actividades escolares.',
 0.00, 75),

(1, 'Pegamento líquido',
 'Pegamento líquido escolar no tóxico.',
 5.00, 15),

(1, 'Cartulina',
 'Cartulina de diferentes colores para actividades.',
 0.00, 190),

(1, 'Papel lustre',
 'Papel lustre de distintos colores.',
 0.00, 112),

(1, 'Plasticina',
 'Plasticina de colores para actividades educativas.',
 10.00, 90),

(1, 'Papel kraft',
 'Rollos de papel kraft para actividades y decoración.',
 10.00, 3);


/* ---------------------------------------------------------
   BODEGA 2 - ARTÍCULOS DE ASEO
   --------------------------------------------------------- */

INSERT INTO productos (
    id_bodega,
    nombre_producto,
    descripcion,
    cantidad_peso,
    stock
)
VALUES
(2, 'Cloro',
 'Cloro para limpieza y desinfección de superficies.',
 5.00, 20),

(2, 'Desinfectante',
 'Desinfectante para pisos y superficies.',
 5.00, 25),

(2, 'Jabón líquido',
 'Jabón líquido para lavado de manos.',
 5.00, 30),

(2, 'Alcohol gel',
 'Alcohol gel para higiene de manos.',
 1.00, 40),

(2, 'Toalla de papel',
 'Rollos de toalla de papel para baños y áreas comunes.',
 0.00, 80),

(2, 'Papel higiénico',
 'Rollos de papel higiénico para baños.',
 0.00, 120),

(2, 'Bolsas de basura',
 'Bolsas de basura para residuos generales.',
 0.00, 100),

(2, 'Guantes de limpieza',
 'Guantes reutilizables para labores de limpieza.',
 0.00, 25),

(2, 'Esponjas',
 'Esponjas para limpieza de superficies.',
 0.00, 30),

(2, 'Paños de limpieza',
 'Paños reutilizables para limpieza de superficies.',
 0.00, 40);


/* ---------------------------------------------------------
   BODEGA 3 - ARTÍCULOS DE OFICINA
   --------------------------------------------------------- */

INSERT INTO productos (
    id_bodega,
    nombre_producto,
    descripcion,
    cantidad_peso,
    stock
)
VALUES
(3, 'Resma de papel',
 'Resma de papel tamaño carta para impresión.',
 2.50, 20),

(3, 'Cuadernos',
 'Cuadernos para registros y planificación.',
 0.00, 30),

(3, 'Lápices pasta',
 'Lápices pasta de tinta azul y negra.',
 0.00, 100),

(3, 'Lápices grafito',
 'Lápices grafito para escritura y actividades.',
 0.00, 80),

(3, 'Gomas de borrar',
 'Gomas de borrar para actividades de escritura.',
 0.00, 50),

(3, 'Sacapuntas',
 'Sacapuntas para lápices grafito y de colores.',
 0.00, 30),

(3, 'Tijeras escolares',
 'Tijeras de punta redonda para actividades educativas.',
 0.00, 35),

(3, 'Reglas',
 'Reglas plásticas para actividades educativas.',
 0.00, 25),

(3, 'Clips',
 'Clips metálicos para documentos.',
 0.00, 15),

(3, 'Carpetas',
 'Carpetas para almacenar documentos.',
 0.00, 40),

(3, 'Archivadores',
 'Archivadores para documentación del jardín infantil.',
 0.00, 15);


/* =========================================================
   10. FUNCIÓN PARA ACTUALIZAR STOCK
   ========================================================= */

CREATE OR REPLACE FUNCTION actualizar_stock()
RETURNS TRIGGER AS $$
BEGIN

    /* -----------------------------------------------------
       ENTRADA
       ----------------------------------------------------- */

    IF NEW.tipo = 'entrada' THEN

        UPDATE productos
        SET
            stock = stock + NEW.cantidad,
            ultima_entrada = NEW.fecha
        WHERE id = NEW.producto_id;


    /* -----------------------------------------------------
       SALIDA
       ----------------------------------------------------- */

    ELSIF NEW.tipo = 'salida' THEN

        UPDATE productos
        SET
            stock = stock - NEW.cantidad,
            ultima_salida = NEW.fecha
        WHERE id = NEW.producto_id;

    END IF;

    RETURN NEW;

END;
$$ LANGUAGE plpgsql;


/* =========================================================
   11. TRIGGER AUTOMÁTICO DE STOCK
   ========================================================= */

CREATE TRIGGER trigger_actualizar_stock
AFTER INSERT ON movimiento
FOR EACH ROW
EXECUTE FUNCTION actualizar_stock();


/* =========================================================
   12. MOVIMIENTOS DE PRUEBA
   ========================================================= */

/* ---------------------------------------------------------
   BODEGA 1 - FUNGIBLES
   --------------------------------------------------------- */

INSERT INTO movimiento (
    producto_id,
    bodega_id,
    tipo,
    proveedor_id,
    cantidad,
    precio_unitario,
    observacion,
    motivo,
    id_responsable
)
VALUES
(1, 1, 'entrada', 1, 20, 1500,
 'Ingreso de material escolar.',
 'Reposición de stock',
 2),

(2, 1, 'entrada', 1, 15, 1200,
 'Ingreso de plumones.',
 'Reposición de stock',
 2),

(3, 1, 'salida', NULL, 10, 1200,
 'Material entregado a sala.',
 'Actividad educativa',
 1),

(4, 1, 'entrada', 1, 10, 2500,
 'Ingreso de témperas.',
 'Reposición de stock',
 2),

(5, 1, 'salida', NULL, 8, 1800,
 'Pegamentos entregados a educadoras.',
 'Actividad de manualidades',
 1),

(6, 1, 'entrada', 1, 12, 2200,
 'Ingreso de pegamento líquido.',
 'Reposición de stock',
 2),

(7, 1, 'salida', NULL, 20, 500,
 'Cartulinas entregadas para actividades.',
 'Actividad educativa',
 1),

(8, 1, 'entrada', 1, 25, 300,
 'Ingreso de papel lustre.',
 'Reposición de stock',
 2),

(9, 1, 'salida', NULL, 15, 900,
 'Plasticina entregada a las salas.',
 'Actividad educativa',
 1),

(10, 1, 'entrada', 1, 20, 800,
 'Ingreso de papel kraft.',
 'Reposición de stock',
 2);


/* ---------------------------------------------------------
   BODEGA 2 - ASEO
   --------------------------------------------------------- */

INSERT INTO movimiento (
    producto_id,
    bodega_id,
    tipo,
    proveedor_id,
    cantidad,
    precio_unitario,
    observacion,
    motivo,
    id_responsable
)
VALUES
(11, 2, 'entrada', 2, 10, 3500,
 'Ingreso de cloro.',
 'Reposición de stock',
 2),

(12, 2, 'salida', NULL, 5, 4000,
 'Desinfectante utilizado durante la semana.',
 'Limpieza general',
 2),

(13, 2, 'entrada', 2, 15, 2800,
 'Ingreso de jabón líquido.',
 'Reposición de stock',
 2),

(14, 2, 'salida', NULL, 8, 2500,
 'Alcohol gel distribuido en las salas.',
 'Higiene de manos',
 1),

(15, 2, 'entrada', 2, 20, 1800,
 'Ingreso de toallas de papel.',
 'Reposición de stock',
 2),

(16, 2, 'salida', NULL, 10, 5000,
 'Papel higiénico entregado para baños.',
 'Reposición de baños',
 2),

(17, 2, 'entrada', 2, 25, 3000,
 'Ingreso de bolsas de basura.',
 'Reposición de stock',
 2),

(18, 2, 'salida', NULL, 5, 2500,
 'Guantes utilizados en labores de limpieza.',
 'Limpieza general',
 2),

(19, 2, 'entrada', 2, 10, 1200,
 'Ingreso de esponjas.',
 'Reposición de stock',
 2),

(20, 2, 'salida', NULL, 7, 1800,
 'Paños utilizados en limpieza.',
 'Limpieza general',
 2);


/* ---------------------------------------------------------
   BODEGA 3 - OFICINA
   --------------------------------------------------------- */

INSERT INTO movimiento (
    producto_id,
    bodega_id,
    tipo,
    proveedor_id,
    cantidad,
    precio_unitario,
    observacion,
    motivo,
    id_responsable
)
VALUES
(21, 3, 'entrada', 3, 15, 4500,
 'Ingreso de resmas de papel.',
 'Reposición de stock',
 3),

(22, 3, 'salida', NULL, 10, 2000,
 'Cuadernos entregados al personal.',
 'Uso administrativo',
 3),

(23, 3, 'entrada', 3, 20, 500,
 'Ingreso de lápices pasta.',
 'Reposición de stock',
 3),

(24, 3, 'salida', NULL, 15, 400,
 'Lápices entregados al personal.',
 'Uso administrativo',
 3),

(25, 3, 'entrada', 3, 10, 350,
 'Ingreso de gomas de borrar.',
 'Reposición de stock',
 3),

(26, 3, 'salida', NULL, 5, 500,
 'Sacapuntas entregados para uso educativo.',
 'Material escolar',
 1),

(27, 3, 'entrada', 3, 12, 1200,
 'Ingreso de tijeras escolares.',
 'Reposición de stock',
 2),

(28, 3, 'salida', NULL, 8, 600,
 'Reglas entregadas para actividades.',
 'Actividad educativa',
 1),

(29, 3, 'entrada', 3, 15, 300,
 'Ingreso de clips.',
 'Reposición de stock',
 3),

(30, 3, 'salida', NULL, 10, 1500,
 'Carpetas entregadas para documentación.',
 'Uso administrativo',
 3),

(31, 3, 'entrada', 3, 8, 3500,
 'Ingreso de archivadores.',
 'Reposición de stock',
 3);


/* =========================================================
   13. CONSULTAS PARA COMPROBAR LA BASE DE DATOS
   ========================================================= */


/* Ver bodegas */

SELECT *
FROM bodega;


/* Ver responsables */

SELECT *
FROM responsable;


/* Ver proveedores */

SELECT *
FROM proveedor;


/* Ver productos y stock */

SELECT
    p.id,
    p.nombre_producto,
    b.nombre AS bodega,
    p.stock,
    p.activo
FROM productos p
INNER JOIN bodega b
    ON p.id_bodega = b.id
ORDER BY p.id;


/* Ver movimientos */

SELECT
    m.id,
    p.nombre_producto,
    b.nombre AS bodega,
    m.tipo,
    m.fecha,
    m.cantidad,
    m.precio_unitario,
    pr.nombre AS proveedor,
    CONCAT(r.nombre, ' ', r.apellido) AS responsable,
    m.motivo,
    m.observacion
FROM movimiento m
INNER JOIN productos p
    ON m.producto_id = p.id
INNER JOIN bodega b
    ON m.bodega_id = b.id
LEFT JOIN proveedor pr
    ON m.proveedor_id = pr.id
INNER JOIN responsable r
    ON m.id_responsable = r.id
ORDER BY m.id;