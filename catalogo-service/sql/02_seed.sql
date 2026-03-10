-- ============================================================
-- Script 02: Datos de Ejemplo (Seed)
-- Proyecto: PracticaMicroservicios
-- Ejecutar DESPUÉS de 01_schema.sql
-- ============================================================

-- ─────────────────────────────────────────
-- Categorías
-- ─────────────────────────────────────────
INSERT INTO categorias (id, nombre, descripcion) VALUES
    ('11111111-0000-0000-0000-000000000001', 'Electrónica',   'Dispositivos electrónicos y accesorios tecnológicos'),
    ('11111111-0000-0000-0000-000000000002', 'Ropa',          'Prendas de vestir para todas las edades'),
    ('11111111-0000-0000-0000-000000000003', 'Alimentos',     'Productos de despensa y consumibles')
ON CONFLICT (nombre) DO NOTHING;

-- ─────────────────────────────────────────
-- Productos
-- ─────────────────────────────────────────
INSERT INTO productos (nombre, descripcion, precio, stock, categoria_id, activo) VALUES
    -- Electrónica
    ('Laptop HP 15"',
     'Procesador Intel Core i5, 8GB RAM, SSD 256GB, Windows 11',
     12499.00, 15,
     '11111111-0000-0000-0000-000000000001', TRUE),

    ('Mouse Inalámbrico Logitech',
     'Mouse ergonómico, 1000 DPI, batería AAA incluida',
     349.00, 50,
     '11111111-0000-0000-0000-000000000001', TRUE),

    ('Teclado Mecánico RGB',
     'Switches Blue, retroiluminación RGB, USB-C',
     799.00, 30,
     '11111111-0000-0000-0000-000000000001', TRUE),

    ('Monitor 24" Full HD',
     'Panel IPS, 75Hz, HDMI + VGA, sin bordes',
     3299.00, 8,
     '11111111-0000-0000-0000-000000000001', TRUE),

    -- Ropa
    ('Playera Polo Slim Fit',
     'Tela piqué 100% algodón, disponible en tallas S-XL',
     299.00, 100,
     '11111111-0000-0000-0000-000000000002', TRUE),

    ('Jeans Skinny Azul',
     'Mezclilla stretch, talla 28-36, lavado oscuro',
     599.00, 60,
     '11111111-0000-0000-0000-000000000002', TRUE),

    -- Alimentos
    ('Café Gourmet 500g',
     'Café molido de altura, tostado medio, origen Chiapas',
     189.00, 200,
     '11111111-0000-0000-0000-000000000003', TRUE),

    ('Aceite de Oliva Extra Virgen 1L',
     'Primera extracción en frío, bajo acidez, origen español',
     259.00, 120,
     '11111111-0000-0000-0000-000000000003', TRUE)
ON CONFLICT DO NOTHING;
