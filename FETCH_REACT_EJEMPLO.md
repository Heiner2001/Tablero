# Fetch de React para obtener usuarios del tablero

## 📍 Ubicación del código

### 1. Servicio API (`frontend/src/services/api.js`)

```javascript
// Línea 173-174
getBoardUsersForReminders: () => {
  return api.get('/api/board-users-for-reminders/');
},
```

### 2. Uso en Calendar.jsx (`frontend/src/pages/Calendar.jsx`)

```javascript
// Línea 266
const usersResponse = await kanbanService.getBoardUsersForReminders();
```

## 🔧 Configuración de Axios

### Instancia de Axios (`frontend/src/services/api.js`)

```javascript
import axios from 'axios';
import { API_CONFIG } from '../config/api';

// Crear instancia de axios con configuración base
const api = axios.create({
  ...API_CONFIG,
  withCredentials: true,  // OBLIGATORIO: Sin esto, la cookie jamás llega a React
});

// Interceptor para agregar CSRF token
api.interceptors.request.use(
  (config) => {
    const csrftoken = getCookie('csrftoken');
    if (csrftoken) {
      config.headers['X-CSRFToken'] = csrftoken;
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);
```

### Configuración base (`frontend/src/config/api.js`)

```javascript
const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || 
  (import.meta.env.DEV ? '' : 'https://kanban-backend.onrender.com');

export const API_CONFIG = {
  baseURL: API_BASE_URL,  // En desarrollo: '' (usa proxy de Vite)
  withCredentials: true,  // Para incluir cookies en las peticiones
  headers: {
    'Content-Type': 'application/json',
  },
};
```

## 🌐 Equivalente con Fetch nativo

Si quisieras usar `fetch` en lugar de `axios`, sería así:

```javascript
// Función equivalente con fetch
async function getBoardUsersForReminders() {
  // Obtener CSRF token de las cookies
  const getCookie = (name) => {
    const value = `; ${document.cookie}`;
    const parts = value.split(`; ${name}=`);
    if (parts.length === 2) return parts.pop().split(';').shift();
    return null;
  };

  const csrftoken = getCookie('csrftoken');
  
  // URL: En desarrollo usa ruta relativa (proxy de Vite)
  // En producción: usaría la URL completa del backend
  const url = '/api/board-users-for-reminders/';
  
  // Headers
  const headers = {
    'Content-Type': 'application/json',
  };
  
  // Agregar CSRF token si está disponible
  if (csrftoken) {
    headers['X-CSRFToken'] = csrftoken;
  }
  
  try {
    const response = await fetch(url, {
      method: 'GET',
      credentials: 'include',  // IMPORTANTE: Para enviar cookies
      headers: headers,
    });
    
    if (!response.ok) {
      if (response.status === 401) {
        // No autenticado, redirigir a login
        window.location.href = '/login';
        return;
      }
      throw new Error(`HTTP error! status: ${response.status}`);
    }
    
    const data = await response.json();
    return { data };
  } catch (error) {
    console.error('Error al obtener usuarios:', error);
    throw error;
  }
}
```

## 📊 Flujo completo en Calendar.jsx

```javascript
// Línea 262-284
setEmailStatus('⏳ Obteniendo usuarios del tablero...');

try {
  // 1. Llamar al servicio
  const usersResponse = await kanbanService.getBoardUsersForReminders();
  
  // 2. Verificar respuesta
  if (!usersResponse || !usersResponse.data) {
    setEmailStatus(`❌ Error: No se pudo conectar con el servidor.`);
    return;
  }
  
  // 3. Verificar éxito
  if (!usersResponse.data.success) {
    setEmailStatus(`❌ Error: ${usersResponse.data.error || 'No se pudieron obtener los usuarios'}`);
    return;
  }

  // 4. Obtener usuarios
  const users = usersResponse.data.users || [];
  
  // 5. Verificar que haya usuarios
  if (users.length === 0) {
    setEmailStatus('ℹ️ No hay usuarios con tareas pendientes.');
    return;
  }

  // 6. Continuar con el envío de correos...
  setEmailStatus(`⏳ Enviando correos a ${users.length} usuario(s)...`);
  
} catch (err) {
  // Manejo de errores...
}
```

## 🔄 Proxy de Vite

El proxy de Vite (`frontend/vite.config.js`) redirige las peticiones:

```javascript
proxy: {
  '/api': {
    target: 'http://127.0.0.1:8000',
    changeOrigin: true,
    secure: false,
    configure: (proxy, _options) => {
      proxy.on('proxyReq', (proxyReq, req, _res) => {
        // Asegurar que las cookies se envíen
        if (req.headers.cookie) {
          proxyReq.setHeader('Cookie', req.headers.cookie);
        }
      });
    },
  },
}
```

## 📍 URL final

- **En desarrollo (con proxy):**
  - Frontend hace: `GET /api/board-users-for-reminders/`
  - Vite redirige a: `http://127.0.0.1:8000/api/board-users-for-reminders/`

- **En producción:**
  - Frontend hace: `GET https://kanban-backend.onrender.com/api/board-users-for-reminders/`

## ✅ Características importantes

1. **withCredentials: true** - Envía cookies automáticamente
2. **CSRF Token** - Se agrega automáticamente desde las cookies
3. **Manejo de errores** - Interceptores para 401, 404, etc.
4. **Proxy de Vite** - Permite usar rutas relativas en desarrollo

