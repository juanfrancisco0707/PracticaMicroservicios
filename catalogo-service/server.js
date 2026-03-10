const express = require('express');
const { createClient } = require('@supabase/supabase-js');
const jwt = require('jsonwebtoken');
require('dotenv').config();

const app = express();
app.use(express.json());

const PORT = process.env.PORT || 3000;
const JWT_SECRET = process.env.JWT_SECRET || 'supersecretkey';
const SUPABASE_URL = process.env.SUPABASE_URL;
const SUPABASE_ANON_KEY = process.env.SUPABASE_ANON_KEY;

if (!SUPABASE_URL || !SUPABASE_ANON_KEY) {
    console.error('❌ Faltan variables de entorno: SUPABASE_URL y SUPABASE_ANON_KEY');
    process.exit(1);
}

// Cliente Supabase
const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

// ─── Middleware: verificar JWT de usuarios-service ────────────────────────────
function verificarToken(req, res, next) {
    const authHeader = req.headers['authorization'];
    if (!authHeader) return res.status(401).json({ error: 'Token requerido' });

    const token = authHeader.split(' ')[1]; // "Bearer <token>"
    try {
        const payload = jwt.verify(token, JWT_SECRET);
        req.usuario = payload;
        next();
    } catch (err) {
        return res.status(401).json({ error: 'Token inválido o expirado' });
    }
}

// ─── Health Check ─────────────────────────────────────────────────────────────
app.get('/', (req, res) => {
    res.json({
        message: 'Catalogo Service is running 🛍️',
        db: 'Supabase (PostgreSQL)'
    });
});

// ─── CATEGORÍAS ───────────────────────────────────────────────────────────────

// GET /categories → listar todas las categorías (público)
app.get('/categories', async (req, res) => {
    const { data, error } = await supabase
        .from('categorias')
        .select('*')
        .order('nombre');

    if (error) return res.status(500).json({ error: error.message });
    res.json(data);
});

// ─── PRODUCTOS ────────────────────────────────────────────────────────────────

// GET /products → listar productos activos con categoría (público)
app.get('/products', async (req, res) => {
    const { categoria } = req.query;

    let query = supabase
        .from('v_productos_detalle')
        .select('*')
        .eq('activo', true)
        .order('nombre');

    if (categoria) {
        query = query.eq('categoria_id', categoria);
    }

    const { data, error } = await query;
    if (error) return res.status(500).json({ error: error.message });
    res.json(data);
});

// GET /products/:id → detalle de un producto (público)
app.get('/products/:id', async (req, res) => {
    const { id } = req.params;

    const { data, error } = await supabase
        .from('v_productos_detalle')
        .select('*')
        .eq('id', id)
        .single();

    if (error || !data) return res.status(404).json({ error: 'Producto no encontrado' });
    res.json(data);
});

// POST /products → crear producto (requiere JWT)
app.post('/products', verificarToken, async (req, res) => {
    const { nombre, descripcion, precio, stock, categoria_id, imagen_url } = req.body;

    if (!nombre || precio === undefined) {
        return res.status(400).json({ error: 'Campos requeridos: nombre, precio' });
    }

    const { data, error } = await supabase
        .from('productos')
        .insert([{ nombre, descripcion, precio, stock: stock ?? 0, categoria_id, imagen_url, activo: true }])
        .select()
        .single();

    if (error) return res.status(500).json({ error: error.message });
    res.status(201).json({ message: 'Producto creado', producto: data });
});

// PUT /products/:id → actualizar producto (requiere JWT)
app.put('/products/:id', verificarToken, async (req, res) => {
    const { id } = req.params;
    const { nombre, descripcion, precio, stock, categoria_id, imagen_url, activo } = req.body;

    const { data, error } = await supabase
        .from('productos')
        .update({ nombre, descripcion, precio, stock, categoria_id, imagen_url, activo })
        .eq('id', id)
        .select()
        .single();

    if (error) return res.status(500).json({ error: error.message });
    if (!data) return res.status(404).json({ error: 'Producto no encontrado' });
    res.json({ message: 'Producto actualizado', producto: data });
});

// DELETE /products/:id → eliminar (soft delete) producto (requiere JWT)
app.delete('/products/:id', verificarToken, async (req, res) => {
    const { id } = req.params;

    const { data, error } = await supabase
        .from('productos')
        .update({ activo: false })
        .eq('id', id)
        .select()
        .single();

    if (error) return res.status(500).json({ error: error.message });
    if (!data) return res.status(404).json({ error: 'Producto no encontrado' });
    res.json({ message: 'Producto desactivado correctamente' });
});

// ─── Inicio ───────────────────────────────────────────────────────────────────
app.listen(PORT, () => {
    console.log(`🚀 Catalogo Service corriendo en puerto ${PORT}`);
    console.log(`📦 Conectado a Supabase: ${SUPABASE_URL}`);
});
