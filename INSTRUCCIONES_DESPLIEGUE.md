# 🚀 Instrucciones de Despliegue - Proyecto Tablero

## ✅ Paso 1 Completado: Código en GitHub
- ✅ Repositorio: https://github.com/Heiner2001/Tablero
- ✅ Código subido correctamente

---

## 🔙 Paso 2: Desplegar Backend en Render

### 2.1 Crear cuenta e iniciar
1. Ve a: https://dashboard.render.com
2. Click en "Get Started for Free" o "Sign In" si ya tienes cuenta
3. Autoriza con GitHub cuando te lo pida

### 2.2 Crear nuevo servicio
1. Click en el botón **"New +"** (arriba a la derecha)
2. Selecciona **"Web Service"**

### 2.3 Conectar repositorio
1. En "Public Git repository", busca: `Heiner2001/Tablero`
2. O pega la URL: `https://github.com/Heiner2001/Tablero`
3. Click en **"Connect"**

### 2.4 Configurar el servicio
Completa estos campos:

- **Name**: `tablero-backend` (o el nombre que prefieras)
- **Region**: `Oregon (US West)` (gratis)
- **Branch**: `main`
- **Root Directory**: Dejar vacío o poner `.`
- **Runtime**: `Python 3`
- **Build Command**: 
  ```
  pip install -r requirements.txt && python manage.py collectstatic --noinput
  ```
- **Start Command**: 
  ```
  daphne -b 0.0.0.0 -p $PORT proyectofinal.asgi:application
  ```
- **Plan**: Selecciona **"Free"**

### 2.5 Variables de Entorno (MUY IMPORTANTE)
Click en **"Advanced"** y luego en **"Add Environment Variable"**:

1. **SECRET_KEY**: 
   - Key: `SECRET_KEY`
   - Value: Genera una clave ejecutando esto en tu terminal:
     ```bash
     python -c "from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())"
     ```
   - O usa: `django-insecure-change-this-in-production-$(date +%s)`

2. **DEBUG**: 
   - Key: `DEBUG`
   - Value: `False`

3. **USE_HTTPS**: 
   - Key: `USE_HTTPS`
   - Value: `True`

4. **ALLOWED_HOSTS**: 
   - Key: `ALLOWED_HOSTS`
   - Value: `tablero-backend.onrender.com` (se actualizará después)

### 2.6 Crear el servicio
1. Scroll hacia abajo
2. Click en **"Create Web Service"**
3. **Espera 5-10 minutos** mientras se despliega (primera vez puede tardar más)

### 2.7 Obtener la URL del backend
1. Cuando termine el despliegue (verás "Live" en verde)
2. **Copia la URL** que aparece en la parte superior (ejemplo: `https://tablero-backend.onrender.com`)
3. ⚠️ **GUARDA ESTA URL** - La necesitarás para el frontend

---

## 🎨 Paso 3: Desplegar Frontend en Vercel

### 3.1 Crear cuenta e iniciar
1. Ve a: https://vercel.com/dashboard
2. Click en **"Sign Up"** o **"Log In"**
3. **Usa GitHub para registrarte** (más fácil)

### 3.2 Crear nuevo proyecto
1. Click en **"Add New..."** → **"Project"**
2. Si es tu primera vez, autoriza a Vercel para acceder a tus repositorios de GitHub

### 3.3 Importar repositorio
1. Busca tu repositorio: `Heiner2001/Tablero`
2. Click en **"Import"**

### 3.4 Configurar el proyecto
Vercel detectará automáticamente que es Vite, pero verifica:

- **Framework Preset**: `Vite` (debería detectarse automáticamente)
- **Root Directory**: `frontend` ⚠️ **IMPORTANTE: Cambia esto a `frontend`**
- **Build Command**: `npm run build` (automático)
- **Output Directory**: `dist` (automático)
- **Install Command**: `npm install` (automático)

### 3.5 Variables de Entorno
1. Click en **"Environment Variables"**
2. Agrega:
   - **Key**: `VITE_API_BASE_URL`
   - **Value**: La URL de tu backend de Render (ejemplo: `https://tablero-backend.onrender.com`)
3. Click en **"Add"**

### 3.6 Desplegar
1. Scroll hacia abajo
2. Click en **"Deploy"**
3. **Espera 2-5 minutos** mientras se despliega

### 3.7 Obtener la URL del frontend
1. Cuando termine el despliegue, verás un mensaje de éxito
2. **Copia la URL** que aparece (ejemplo: `https://tablero-xxxxx.vercel.app`)
3. ⚠️ **GUARDA ESTA URL** - La necesitarás para actualizar el backend

---

## 🔄 Paso 4: Actualizar Backend con URL del Frontend

### 4.1 Volver a Render
1. Ve a tu servicio `tablero-backend` en Render
2. Click en **"Environment"** (en el menú lateral izquierdo)

### 4.2 Actualizar Variables de Entorno
Edita las siguientes variables (click en el ícono de editar):

1. **CORS_ALLOWED_ORIGINS**: 
   - Cambia el valor a: `https://tu-frontend.vercel.app` (la URL que obtuviste en el Paso 3)

2. **CSRF_TRUSTED_ORIGINS**: 
   - Cambia el valor a: `https://tu-frontend.vercel.app` (la misma URL del frontend)

3. **ALLOWED_HOSTS**: 
   - Cambia el valor a: `tablero-backend.onrender.com,tu-frontend.vercel.app` (ambas URLs separadas por coma)

### 4.3 Guardar cambios
1. Click en **"Save Changes"** al final de la página
2. Render reiniciará automáticamente el servicio
3. **Espera 2-3 minutos** hasta que vuelva a estar "Live"

---

## ✅ Paso 5: ¡Listo! Tus Links Finales

Después de completar todos los pasos, tendrás:

- 🔙 **Backend**: `https://tablero-backend.onrender.com` (o la URL que Render te asignó)
- 🎨 **Frontend**: `https://tu-frontend.vercel.app` (o la URL que Vercel te asignó)

---

## 🆘 Solución de Problemas

### Error: "No module named 'daphne'"
- Verifica que `daphne` esté en `requirements.txt`
- Asegúrate de que el Build Command sea correcto

### Error de CORS en el frontend
- Verifica que `CORS_ALLOWED_ORIGINS` tenga exactamente la URL de Vercel (con https://)
- No olvides reiniciar el servicio en Render después de actualizar las variables

### El backend no responde
- Revisa los logs en Render (tab "Logs")
- Verifica que el Start Command sea correcto
- Asegúrate de que todas las variables de entorno estén configuradas

### Error en el build del frontend
- Revisa los logs en Vercel
- Verifica que el Root Directory sea `frontend`
- Asegúrate de que la variable `VITE_API_BASE_URL` esté configurada

---

## 📝 Notas Importantes

- ⏰ El backend en Render puede tardar 1-2 minutos en responder después de estar inactivo (plan gratuito)
- 🔒 Las cookies funcionan correctamente con HTTPS en producción
- 💾 El proyecto usa SQLite por defecto (para producción, considera PostgreSQL)
- 🔄 Cualquier cambio que subas a GitHub se desplegará automáticamente en Render y Vercel

---

## 🎯 Resumen de Links

- 📦 **GitHub**: https://github.com/Heiner2001/Tablero
- 🔙 **Render Dashboard**: https://dashboard.render.com
- 🎨 **Vercel Dashboard**: https://vercel.com/dashboard

¡Sigue estos pasos y tendrás tu proyecto desplegado en producción! 🚀

