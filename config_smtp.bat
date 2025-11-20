@echo off
echo ========================================
echo CONFIGURACION DE SMTP PARA RECORDATORIOS
echo ========================================
echo.
echo Este script configurara las variables de entorno para SMTP.
echo Las variables solo estaran activas en esta ventana de terminal.
echo.
echo IMPORTANTE PARA GMAIL:
echo 1. Debes tener verificacion en 2 pasos activada
echo 2. Crea una "Contrasena de aplicacion" desde:
echo    https://myaccount.google.com/apppasswords
echo 3. Usa esa contrasena de 16 caracteres (NO tu contrasena normal)
echo.
echo ========================================
echo.

set /p EMAIL_USER="Ingresa tu email (ej: tu-email@gmail.com): "
if "%EMAIL_USER%"=="" (
    echo Error: Debes ingresar un email
    pause
    exit /b 1
)

set /p EMAIL_PASS="Ingresa tu contrasena de aplicacion: "
if "%EMAIL_PASS%"=="" (
    echo Error: Debes ingresar una contrasena
    pause
    exit /b 1
)

set /p SMTP_HOST="Servidor SMTP [smtp.gmail.com]: "
if "%SMTP_HOST%"=="" set SMTP_HOST=smtp.gmail.com

set /p SMTP_PORT="Puerto SMTP [587]: "
if "%SMTP_PORT%"=="" set SMTP_PORT=587

set /p USE_TLS="Usar TLS? [True]: "
if "%USE_TLS%"=="" set USE_TLS=True

echo.
echo ========================================
echo CONFIGURANDO VARIABLES DE ENTORNO...
echo ========================================
echo.

set EMAIL_BACKEND=django.core.mail.backends.smtp.EmailBackend
set EMAIL_HOST=%SMTP_HOST%
set EMAIL_PORT=%SMTP_PORT%
set EMAIL_USE_TLS=%USE_TLS%
set EMAIL_HOST_USER=%EMAIL_USER%
set EMAIL_HOST_PASSWORD=%EMAIL_PASS%
set DEFAULT_FROM_EMAIL=%EMAIL_USER%

echo Variables configuradas exitosamente!
echo.
echo ========================================
echo CONFIGURACION APLICADA:
echo ========================================
echo EMAIL_BACKEND=%EMAIL_BACKEND%
echo EMAIL_HOST=%EMAIL_HOST%
echo EMAIL_PORT=%EMAIL_PORT%
echo EMAIL_USE_TLS=%EMAIL_USE_TLS%
echo EMAIL_HOST_USER=%EMAIL_HOST_USER%
echo DEFAULT_FROM_EMAIL=%DEFAULT_FROM_EMAIL%
echo ========================================
echo.

echo Ahora puedes:
echo 1. Probar el envio desde el frontend (calendario)
echo 2. O ejecutar: python test_email_smtp.py
echo.
echo IMPORTANTE: Manten esta ventana abierta y ejecuta el servidor
echo Django en esta misma ventana para que las variables funcionen.
echo.

set /p PROBAR="Deseas probar el envio ahora? [s/n]: "
if /i "%PROBAR%"=="s" (
    echo.
    echo Probando envio de correos...
    echo.
    python test_email_smtp.py
)

echo.
pause

