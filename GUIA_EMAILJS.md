# Guía de Configuración de EmailJS

Esta guía te ayudará a configurar EmailJS para enviar recordatorios por correo electrónico desde el frontend.

## ¿Qué es EmailJS?

EmailJS es un servicio que permite enviar correos electrónicos directamente desde el frontend sin necesidad de un servidor SMTP. Es ideal para aplicaciones que necesitan enviar correos sin configurar un servidor de correo.

## Pasos para Configurar EmailJS

### 1. Crear una cuenta en EmailJS

1. Ve a [https://www.emailjs.com/](https://www.emailjs.com/)
2. Crea una cuenta gratuita (permite hasta 200 correos/mes)
3. Verifica tu correo electrónico

### 2. Crear un Email Service

1. En el dashboard de EmailJS, ve a **Email Services**
2. Haz clic en **Add New Service**
3. Selecciona tu proveedor de correo (Gmail, Outlook, etc.)
4. Sigue las instrucciones para conectar tu cuenta
5. **Copia el Service ID** (formato: `service_xxxxxxx`)

### 3. Crear un Email Template

1. Ve a **Email Templates**
2. Haz clic en **Create New Template**
3. Configura el template con los siguientes campos:
   - **To Email**: `{{to_email}}`
   - **To Name**: `{{to_name}}`
   - **Subject**: `{{subject}}`
   - **Content**: `{{message}}`

   Ejemplo de template:
   ```
   To: {{to_email}}
   From: tu-email@ejemplo.com
   Subject: {{subject}}
   
   {{message}}
   ```

4. **Copia el Template ID** (formato: `template_xxxxxxx`)

### 4. Obtener tu Public Key

1. Ve a **Account** → **General**
2. Encuentra tu **Public Key**
3. **Copia la Public Key**

### 5. Configurar en el Frontend

Tienes dos opciones para configurar EmailJS:

#### Opción A: Configuración Manual (Recomendada para pruebas)

1. Abre la aplicación en el navegador
2. Ve a **Calendario** → **Enviar Recordatorios**
3. Haz clic en **⚙️ Configurar EmailJS**
4. Ingresa tus credenciales:
   - **Service ID**: El Service ID que copiaste
   - **Template ID**: El Template ID que copiaste
   - **Public Key**: Tu Public Key
5. Haz clic en **💾 Guardar Configuración**

La configuración se guardará en el localStorage de tu navegador.

#### Opción B: Variables de Entorno (Recomendada para producción)

1. Crea un archivo `.env` en la carpeta `frontend/`
2. Agrega las siguientes variables:

```env
VITE_EMAILJS_SERVICE_ID=service_xxxxxxx
VITE_EMAILJS_TEMPLATE_ID=template_xxxxxxx
VITE_EMAILJS_PUBLIC_KEY=xxxxxxxxxxxxx
```

3. Reinicia el servidor de desarrollo

## Uso del Sistema de Recordatorios

1. Ve a **Calendario** en la aplicación
2. Haz clic en **📧 Enviar Recordatorios**
3. Selecciona los tipos de recordatorios que deseas enviar:
   - ✅ Tareas y subtareas vencidas
   - ✅ Tareas y subtareas que vencen en 1-3 días
   - ✅ Tareas y subtareas que vencen en 4-7 días
4. Haz clic en **📧 Enviar Recordatorios**

El sistema:
- Obtendrá todos los usuarios con acceso al tablero
- Filtrará las tareas según los criterios seleccionados
- Enviará un correo personalizado a cada usuario con sus tareas pendientes

## Estructura del Correo

Cada correo incluye:
- **Asunto**: "Recordatorios de Tareas - Tablero Kanban" o "[URGENTE] Recordatorios de Tareas - Tablero Kanban" si hay tareas vencidas
- **Contenido**:
  - Saludo personalizado con el nombre del usuario
  - Lista de tareas vencidas (si aplica)
  - Lista de tareas que vencen en 1-3 días (si aplica)
  - Lista de tareas que vencen en 4-7 días (si aplica)
  - Mensaje de cierre

## Solución de Problemas

### Error: "Debes configurar EmailJS primero"
- Asegúrate de haber guardado la configuración de EmailJS
- Verifica que las credenciales sean correctas

### Error: "No se pudieron obtener los usuarios"
- Verifica que el backend esté corriendo
- Verifica que tengas acceso al tablero

### Los correos no se envían
- Verifica que el Service ID, Template ID y Public Key sean correctos
- Revisa la consola del navegador para ver errores detallados
- Verifica que tu cuenta de EmailJS tenga créditos disponibles

### Los correos llegan vacíos
- Verifica que el template de EmailJS tenga los campos correctos: `{{to_email}}`, `{{to_name}}`, `{{subject}}`, `{{message}}`

## Límites de EmailJS

- **Plan Gratuito**: 200 correos/mes
- **Plan Pago**: Desde $15/mes con más límites

Para más información, visita [https://www.emailjs.com/docs/](https://www.emailjs.com/docs/)

