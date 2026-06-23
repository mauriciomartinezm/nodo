# nodo

App de servicios: los clientes publican una necesidad (`Publicacion`) y los trabajadores se postulan (`Postulacion`) para realizarla. Una vez aceptado un trabajador, se genera un historial de servicio que termina en una reseña mutua.

Proyecto retomado en 2026-06 tras ~1 año inactivo — si algo en este README no coincide con el código, confía en el código y actualiza este archivo.

## Estructura del repo

```
frontend/   App Flutter (clientes y trabajadores)
backend/    API Node.js/Express
database/   Esquema SQL (PostgreSQL)
docs/       Documentación del proyecto
```

Documentación más detallada:
- [docs/database-schema.md](docs/database-schema.md) — esquema de base de datos y las reglas de negocio detrás de cada tabla.

## Backend

Stack: Node.js (ESM) + Express + PostgreSQL (`pg`) + Redis (notificaciones) + Firebase Admin (push notifications y storage).

### Configuración

```bash
cd backend
npm install
```

Necesitas dos archivos locales, ninguno de los dos se versiona en git — pídeselos a alguien del equipo que ya los tenga:

- **`backend/.env`** — variables de entorno:

  | Variable | Para qué |
  |---|---|
  | `PORT` | Puerto del servidor (default 3001) |
  | `DATABASE_URL` | Connection string de PostgreSQL |
  | `REDIS_USERNAME` / `REDIS_PASSWORD` / `REDIS_HOST` / `REDIS_PORT` | Conexión a Redis Cloud (usado para notificaciones) |

- **`backend/serviceAccount.json`** — credenciales del Service Account de Firebase Admin (Project Settings → Service Accounts → Generate new private key, si necesitas generarlo de nuevo).

Si alguna vez ves credenciales reales en un diff de git, deténte y avisa al equipo antes de hacer commit — ambos archivos deben quedar siempre fuera de tracking.

### Correr

```bash
npm run dev    # con autoreload (nodemon)
npm start      # modo normal
```

El servidor expone los endpoints bajo `/api` (ver `backend/routes/`).

## Frontend

Stack: Flutter + Provider + Firebase (Storage, Messaging).

```bash
cd frontend
flutter pub get
flutter run
```

La URL del backend está hardcodeada en [`lib/core/constants/api_constants.dart`](frontend/lib/core/constants/api_constants.dart) (`baseUrl`) — hay que descomentar/ajustar la IP según dónde esté corriendo la API (local, emulador Android, o la URL en la nube) antes de probar.

## Base de datos

El esquema vive en [`database/script.sql`](database/script.sql) (PostgreSQL). Para entender las decisiones detrás de cada tabla — qué es muchos-a-muchos, cuándo se crea cada registro, qué se descartó a propósito — ver [docs/database-schema.md](docs/database-schema.md).

## Pendientes conocidos al retomar el proyecto

- Rotar las credenciales de Firebase/PostgreSQL/Redis que estuvieron hardcodeadas en el código (ya movidas a variables de entorno, pero las claves viejas quedaron expuestas en el historial de git).
- Propagar al backend/frontend los cambios de esquema documentados en `docs/database-schema.md` (categorías, `historial_servicio`, reseñas).
- Mejorar la UI de "Mis postulaciones" del trabajador para mostrar el historial con estados claros (pendiente/rechazada/considerada), estilo LinkedIn.
