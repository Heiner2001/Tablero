@echo off
echo ========================================
echo Iniciando Backend (Django) y Frontend (React)
echo ========================================
echo.
echo IMPORTANTE: Este script abrirá DOS ventanas:
echo   1. Backend Django en http://127.0.0.1:8000
echo   2. Frontend React en http://localhost:5173
echo.
echo Debes acceder a: http://localhost:5173
echo NO accedas directamente a http://127.0.0.1:8000/board/
echo.
pause

REM Iniciar Backend en una nueva ventana
start "Backend Django" cmd /k "cd /d %~dp0 && run_server.bat"

REM Esperar un poco para que el backend inicie
timeout /t 3 /nobreak >nul

REM Iniciar Frontend en otra nueva ventana
start "Frontend React" cmd /k "cd /d %~dp0 && start_frontend.bat"

echo.
echo ========================================
echo Servidores iniciados!
echo.
echo Accede a: http://localhost:5173
echo ========================================
pause

