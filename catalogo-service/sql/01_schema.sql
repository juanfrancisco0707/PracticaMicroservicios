-- ============================================================
-- Script 01: Schema de Catálogo de Productos
-- Proyecto: PracticaMicroservicios
-- Base de datos: Supabase (PostgreSQL)
-- Ejecutar en: Supabase Dashboard → SQL Editor
-- ============================================================

-- ─────────────────────────────────────────
-- Tabla: categorias
-- ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS categorias (
    id         UUID        DEFAULT gen_random_uuid() PRIMARY KEY,
    nombre     VARCHAR(100) NOT NULL UNIQUE,
    descripcion TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ─────────────────────────────────────────
-- Tabla: productos
-- ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS productos (
    id           UUID           DEFAULT gen_random_uuid() PRIMARY KEY,
    nombre       VARCHAR(200)   NOT NULL,
    descripcion  TEXT,
    precio       NUMERIC(10, 2) NOT NULL CHECK (precio >= 0),
    stock        INTEGER        NOT NULL DEFAULT 0 CHECK (stock >= 0),
    categoria_id UUID           REFERENCES categorias(id) ON DELETE SET NULL,
    activo       BOOLEAN        DEFAULT TRUE,
    imagen_url   TEXT,
    created_at   TIMESTAMPTZ    DEFAULT NOW(),
    updated_at   TIMESTAMPTZ    DEFAULT NOW()
);

-- ─────────────────────────────────────────
-- Índices para mejorar búsquedas
-- ─────────────────────────────────────────
CREATE INDEX IF NOT EXISTS idx_productos_categoria  ON productos(categoria_id);
CREATE INDEX IF NOT EXISTS idx_productos_activo     ON productos(activo);
CREATE INDEX IF NOT EXISTS idx_productos_nombre     ON productos USING gin(to_tsvector('spanish', nombre));

-- ─────────────────────────────────────────
-- Función: actualizar updated_at automáticamente
-- ─────────────────────────────────────────
CREATE OR REPLACE FUNCTION actualizar_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_productos_updated_at
    BEFORE UPDATE ON productos
    FOR EACH ROW
    EXECUTE FUNCTION actualizar_updated_at();

-- ─────────────────────────────────────────
-- Vista: productos con nombre de categoría
-- ─────────────────────────────────────────
CREATE OR REPLACE VIEW v_productos_detalle AS
SELECT
    p.id,
    p.nombre,
    p.descripcion,
    p.precio,
    p.stock,
    p.activo,
    p.imagen_url,
    p.created_at,
    p.updated_at,
    c.id          AS categoria_id,
    c.nombre      AS categoria_nombre,
    c.descripcion AS categoria_descripcion
FROM productos p
LEFT JOIN categorias c ON p.categoria_id = c.id;
