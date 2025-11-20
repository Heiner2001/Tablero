# Guía Rápida: Configurar SMTP para Recordatorios

## Opción 1: Script Automático (Windows)

1. Ejecuta el script:
   ```cmd
   config_smtp.bat
   ```

2. Ingresa tu información cuando se solicite:
   - Email (ej: tu-email@gmail.com)
   - Contraseña de aplicación (para Gmail)
   - Servidor SMTP (Enter para usar Gmail por defecto)
   - Puerto (Enter para usar 587 por defecto)

3. El script configurará las variables de entorno automáticamente.

4. **IMPORTANTE**: Mantén esa ventana abierta y ejecuta el servidor Django en la misma ventana.

## Opción 2: Configuración Manual

### Para Windows (CMD):
```cmd
set EMAIL_BACKEND=django.core.mail.backends.smtp.EmailBackend
set EMAIL_HOST=smtp.gmail.com
set EMAIL_PORT=587
set EMAIL_USE_TLS=True
set EMAIL_HOST_USER=tu-email@gmail.com
set EMAIL_HOST_PASSWORD=tu-contraseña-de-aplicacion
set DEFAULT_FROM_EMAIL=tu-email@gmail.com
```

### Para Windows (PowerShell):
```powershell
$env:EMAIL_BACKEND="django.core.mail.backends.smtp.EmailBackend"
$env:EMAIL_HOST="smtp.gmail.com"
$env:EMAIL_PORT="587"
$env:EMAIL_USE_TLS="True"
$env:EMAIL_HOST_USER="tu-email@gmail.com"
$env:EMAIL_HOST_PASSWORD="tu-contraseña-de-aplicacion"
$env:DEFAULT_FROM_EMAIL="tu-email@gmail.com"
```

## Configuración para Gmail

### Paso 1: Habilitar verificación en 2 pasos
1. Ve a: https://myaccount.google.com/security
2. Activa "Verificación en 2 pasos"

### Paso 2: Crear contraseña de aplicación
1. Ve a: https://myaccount.google.com/apppasswords
2. Selecciona "Correo" y "Otro (nombre personalizado)"
3. Escribe "Kanban Board" o el nombre que prefieras
4. Copia la contraseña de 16 caracteres generada
5. **Usa esta contraseña** en `EMAIL_HOST_PASSWORD` (NO tu contraseña normal)

## Probar el Envío

### Opción 1: Desde el Frontend
1. Ve al calendario en la aplicación
2. Haz clic en "📧 Enviar Recordatorios"
3. Selecciona las opciones deseadas
4. Haz clic en "Enviar Recordatorios"
5. Verifica que los correos lleguen

### Opción 2: Script de Prueba
```cmd
python test_email_smtp.py
```

## Verificar que Funciona

Después de configurar, ejecuta:
```cmd
python test_email_smtp.py
```

Deberías ver:
- Correos enviados: X
- Errores: 0

Si hay errores, verifica:
- ✅ Que las credenciales sean correctas
- ✅ Para Gmail: que uses contraseña de aplicación (no la normal)
- ✅ Que la verificación en 2 pasos esté activada

## Solución de Problemas

### Error: "SMTPAuthenticationError"
- Verifica que `EMAIL_HOST_USER` y `EMAIL_HOST_PASSWORD` sean correctos
- Para Gmail, asegúrate de usar una contraseña de aplicación
- Verifica que la verificación en 2 pasos esté activada

### Los correos no llegan
- Revisa la carpeta de spam
- Verifica que los usuarios tengan email configurado
- Revisa los logs del servidor

### Volver a modo desarrollo (consola)
```cmd
set EMAIL_BACKEND=django.core.mail.backends.console.EmailBackend
```

