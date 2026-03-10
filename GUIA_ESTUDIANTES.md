# 🎓 Guía de Implementación para Estudiantes: MicroTienda

¡Bienvenidos! En esta sesión vamos a implementar el sistema completo de microservicios de **MicroTienda** en sus propios equipos. 

Actualmente ustedes ya tienen experiencia y un proyecto propio en **Supabase** (con tablas de productos, usuarios y categorías). En este proyecto, vamos a **integrar su Catálogo de Supabase** con nuevas tecnologías: añadiremos **MongoDB** para gestionar la Autenticación (Usuarios) y los Pedidos.

Sigue estos pasos cuidadosamente:

---

## 📋 Requisitos Previos

Antes de empezar, asegúrate de tener instalado en tu computadora:
1. **Docker Desktop** (Asegúrate de que esté abierto y corriendo).
2. **Git** (Para clonar el repositorio).
3. **Node.js** (Opcional, pero recomendado si quieres correr servicios sueltos sin Docker).

---

## 🚀 Paso 1: Obtener el Código Base

1. Abre tu terminal (Símbolo del sistema, PowerShell o Git Bash).
2. Clona el repositorio del profesor usando el siguiente comando:
   ```bash
   git clone https://github.com/juanfranciscoit0707/PracticaMicroservicios.git
   ```
3. Entra a la carpeta del proyecto:
   ```bash
   cd PracticaMicroservicios
   ```

---

## 🗄️ Paso 2: Configurar tu base de datos en Supabase (Catálogo)

En este proyecto, el **Catálogo de Productos** funcionará directamente con tu proyecto de Supabase.

1. Abre el archivo `docker-compose.yml` en Visual Studio Code.
2. Ve a la sección del servicio `catalogo-service` (cerca de la línea 52).
3. Reemplaza las siguientes variables de entorno con las credenciales de **TU propio proyecto de Supabase**:
   ```yaml
   catalogo-service:
     ...
     environment:
       - SUPABASE_URL=https://TU_PROYECTO.supabase.co
       - SUPABASE_ANON_KEY=TU_API_KEY_PUBLICA
       - JWT_SECRET=supersecretkey
       - PORT=3000
   ```
   > **Nota:** Puedes obtener estas credenciales entrando a tu Dashboard de Supabase -> Project Settings -> API.

4. **Si aún no tienes las tablas de productos y categorías**, entra al *SQL Editor* de tu Supabase y ejecuta los scripts ubicados en la carpeta `catalogo-service/sql/` de este proyecto (primero el `01_schema.sql` y luego el `02_seed.sql` para tener datos de prueba). *Nota: Si ya tienes las tablas por prácticas anteriores, asegúrate de que los nombres y campos coincidan con lo requerido por el frontend (tabla `productos` y `categorias`).*

---

## 🍃 Paso 3: Incorporar MongoDB y Levantar los Microservicios

Aquí es donde entra la magia de **Docker**. El archivo `docker-compose.yml` está configurado para descargar automáticamente **MongoDB** y levantar bases de datos independientes para los usuarios y los pedidos, sin que tengas que instalar Mongo en tu máquina.

1. En tu terminal (asegurándote de estar dentro de la carpeta `PracticaMicroservicios`), ejecuta el siguiente comando:
   ```bash
   docker-compose up --build -d
   ```
   *Expliquemos qué hace esto:*
   - Descarga la imagen oficial de `mongo:latest`.
   - Crea `db-usuarios` (MongoDB para credenciales).
   - Crea `db-pedidos` (MongoDB para historial de compras).
   - Construye y levanta los microservicios (`usuarios-service` en Node.js, `pedidos-service` en Python, `catalogo-service` en Node.js).
   - Levanta el Frontend y un Gateway (Nginx).

2. Espera a que termine. Puedes verificar que todo esté corriendo con:
   ```bash
   docker-compose ps
   ```
   Deberías ver 7 contenedores en estado `Up`.

---

## 🎮 Paso 4: ¡Probar el Sistema Localmente!

El sistema utiliza un Gateway (Nginx) para unificar todo. Ya que los servicios están corriendo, puedes acceder a la aplicación web.

1. **Abre tu navegador web** y ve a: [http://localhost:8080](http://localhost:8080)
2. Verás la página principal de "MicroTienda".
3. **Prueba el flujo completo:**
   - Entra a **"Login / Registro"** y crea una cuenta nueva. *(Esto se guardará en tu MongoDB local).*
   - Inicia sesión con la cuenta recién creada.
   - Entra al **"Catálogo"**. Verás los productos que están alojados en tu **Supabase** en la nube.
   - Intenta "Comprar" un producto. *(Esto creará un registro de orden en tu otra base de datos MongoDB).*
   - Entra a **"Mis Pedidos"** para ver tu historial de compra.

¡Felicidades! Has logrado orquestar una arquitectura de microservicios híbrida (Base de datos en la nube + Bases de datos locales en contenedores) usando Docker y la API de Supabase.
