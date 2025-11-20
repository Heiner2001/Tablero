#!/usr/bin/env python
"""
Script para probar el envío de correos con SMTP configurado
"""
import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'proyectofinal.settings')
django.setup()

from kanban.tasks import send_board_reminders_to_all_users
from django.conf import settings

print("=" * 70)
print("PRUEBA DE ENVIO DE CORREOS CON SMTP")
print("=" * 70)
print()

# Verificar configuración
print("Configuracion SMTP actual:")
print(f"  EMAIL_BACKEND: {settings.EMAIL_BACKEND}")
print(f"  EMAIL_HOST: {settings.EMAIL_HOST}")
print(f"  EMAIL_PORT: {settings.EMAIL_PORT}")
print(f"  EMAIL_USE_TLS: {settings.EMAIL_USE_TLS}")
print(f"  EMAIL_HOST_USER: {settings.EMAIL_HOST_USER}")
print(f"  DEFAULT_FROM_EMAIL: {settings.DEFAULT_FROM_EMAIL}")
print()

if settings.EMAIL_BACKEND == 'django.core.mail.backends.console.EmailBackend':
    print("ADVERTENCIA: Estas usando el backend de consola.")
    print("Para usar SMTP real, configura las variables de entorno:")
    print("  - EMAIL_HOST_USER")
    print("  - EMAIL_HOST_PASSWORD")
    print()
    print("Ejecuta: config_smtp.bat")
    print()
    respuesta = input("Deseas continuar con la prueba de todas formas? [s/n]: ").strip().lower()
    if respuesta != 's':
        print("Prueba cancelada.")
        exit(0)

print("=" * 70)
print("Ejecutando envio de recordatorios...")
print("=" * 70)
print()

try:
    result = send_board_reminders_to_all_users(
        include_overdue=True,
        include_1_3_days=True,
        include_4_7_days=False
    )
    
    print()
    print("=" * 70)
    print("RESULTADO:")
    print("=" * 70)
    print(f"  Correos enviados: {result.get('emails_sent', 0)}")
    print(f"  Errores: {result.get('errors', 0)}")
    print(f"  Usuarios procesados: {result.get('users_processed', 0)}")
    print("=" * 70)
    
    if result.get('emails_sent', 0) > 0:
        print()
        print("SUCCESS: Los correos se enviaron correctamente!")
        print("Revisa las bandejas de entrada de los destinatarios.")
    elif result.get('errors', 0) > 0:
        print()
        print("ERROR: Hubo problemas al enviar los correos.")
        print("Verifica:")
        print("  - Que las credenciales SMTP sean correctas")
        print("  - Para Gmail: que uses una contrasena de aplicacion")
        print("  - Que la verificacion en 2 pasos este activada (Gmail)")
    else:
        print()
        print("INFO: No se enviaron correos porque no hay tareas que cumplan los criterios.")
        print("Crea algunas tareas con fechas cercanas para probar.")
        
except Exception as e:
    print()
    print("=" * 70)
    print("ERROR AL EJECUTAR:")
    print("=" * 70)
    print(f"  {str(e)}")
    print("=" * 70)
    import traceback
    traceback.print_exc()

