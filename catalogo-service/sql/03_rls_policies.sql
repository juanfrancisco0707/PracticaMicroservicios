-- ============================================================
-- Script 03: Row Level Security (RLS) Policies
-- Proyecto: PracticaMicroservicios
-- Ejecutar DESPUÉS de 01_schema.sql
-- ============================================================

-- Habilitar RLS en ambas tablas
ALTER TABLE categorias ENABLE ROW LEVEL SECURITY;
ALTER TABLE productos   ENABLE ROW LEVEL SECURITY;

-- ─────────────────────────────────────────
-- Políticas para CATEGORIAS
-- ─────────────────────────────────────────

-- Cualquiera puede leer categorías (catálogo público)
CREATE POLICY "categorias_lectura_publica"
    ON categorias FOR SELECT
    USING (true);

-- Solo el service_role puede insertar/actualizar/eliminar
CREATE POLICY "categorias_escritura_service"
    ON categorias FOR ALL
    USING (auth.role() = 'service_role');

-- ─────────────────────────────────────────
-- Políticas para PRODUCTOS
-- ─────────────────────────────────────────

-- Cualquiera puede leer productos activos (catálogo público)
CREATE POLICY "productos_lectura_publica"
    ON productos FOR SELECT
    USING (activo = true);

-- Solo el service_role puede gestionar productos
CREATE POLICY "productos_escritura_service"
    ON productos FOR ALL
    USING (auth.role() = 'service_role');

-- ─────────────────────────────────────────
-- Nota: el catalogo-service usa la anon key
-- con RLS desactivado para operaciones
-- de escritura porque valida el JWT propio
-- de la app (no el de Supabase Auth).
-- Para producción real, usar service_role key
-- en el backend y nunca exponerla al cliente.
-- ─────────────────────────────────────────

-- Permitir al rol anon leer (para el microservicio con anon key)
CREATE POLICY "productos_anon_lectura"
    ON productos FOR SELECT
    TO anon
    USING (activo = true);

CREATE POLICY "categorias_anon_lectura"
    ON categorias FOR SELECT
    TO anon
    USING (true);

-- Permitir al rol anon CRUD (el microservicio valida JWT propio)
CREATE POLICY "productos_anon_escritura"
    ON productos FOR ALL
    TO anon
    USING (true)
    WITH CHECK (true);

CREATE POLICY "categorias_anon_escritura"
    ON categorias FOR ALL
    TO anon
    USING (true)
    WITH CHECK (true);
