# Esquema de base de datos

Fuente de verdad: [`database/script.sql`](../database/script.sql) (PostgreSQL). Este documento explica el *por qué* de cada decisión, no solo el *qué* — para eso ya está el script.

Última revisión: 2026-06-22, al retomar el proyecto tras ~1 año inactivo. El script anterior estaba desincronizado con el código (le faltaban tablas que el backend ya consultaba); este documento y el script fueron reconstruidos a partir de un script DBML que el equipo aportó, corrigiendo los puntos donde contradecía reglas de negocio ya validadas.

## Entidades principales

- **`usuario`** — clientes y trabajadores conviven en la misma tabla (`tipo_usuario` distingue el rol).
- **`categoria`** — categorías de trabajo (electricista, plomero, jardinero, etc.).
- **`publicacion`** — la necesidad que publica un cliente.
- **`postulacion`** — la postulación de un trabajador a una publicación.
- **`historial_servicio`** — el registro de una relación de servicio real (postulación aceptada → trabajo en curso → finalizado/cancelado).
- **`transaccion`**, **`resena`**, **`disputa`**, **`reporte`**, **`conversacion`**, **`mensaje`** — soporte al ciclo de vida del servicio.

## Reglas de negocio confirmadas

### 1. Categorías son muchos-a-muchos en ambos sentidos

Un trabajador puede tener varias categorías (ej. electricista *y* jardinero). Una publicación puede requerir varias categorías (ej. un requerimiento que aplica a plomero *y* albañil).

Por eso existen las tablas intermedias `usuario_categoria` y `publicacion_categoria` — **no** hay FK directa `id_categoria` en `usuario` ni en `publicacion`. (Un script DBML que circuló por el equipo proponía simplificar esto a una categoría única; se descartó explícitamente.)

### 2. Reseñas son bidireccionales, pero condicionadas

Cliente y trabajador pueden calificarse mutuamente — pero la calificación solo es válida si existe una relación de servicio real entre ambos (un registro en `historial_servicio`). No es una calificación libre tipo comentario abierto.

Por eso `resena` usa `id_calificador` / `id_calificado` (genéricos, cualquiera de los dos roles) + `id_historial_servicio` como contexto obligatorio. La validación de "solo si hubo servicio" vive en el backend, no se puede expresar como constraint SQL simple.

### 3. `historial_servicio` se crea al aceptar la postulación, no al completar el trabajo

Debe quedar un registro desde el momento en que el cliente acepta a un trabajador (`fecha_inicio`), sin importar si después el servicio se cancela, se completa, o lo que pase. `fecha_finalizacion`, `estado`, `calificacion` y `notas_*` se actualizan según el desenlace.

**Esto todavía no está implementado en el backend** — hoy `trabajoController.js` solo actualiza `estado` en `publicacion` y `postulacion` al aceptar; falta el insert en `historial_servicio` en ese mismo flujo.

### 4. No existe catálogo de servicios fijos del trabajador

La tabla `servicio` (que existía en el script viejo: trabajador publica un servicio con precio propio) se eliminó definitivamente. El modelo de negocio es 100% publicación → postulación: el cliente publica su necesidad, el trabajador se postula. No es una idea pendiente, está descartada.

### 5. El historial de postulaciones del trabajador se conserva siempre, incluidas las rechazadas

Como en LinkedIn: un trabajador debe poder ver todas sus postulaciones pasadas, sin importar el resultado. Por eso rechazar/aceptar una postulación es un `UPDATE` de `estado`, nunca un `DELETE` — el `DELETE` solo existe para que el propio trabajador retire su postulación si quiere.

Esto ya funciona a nivel de datos y está parcialmente reflejado en la UI (`TrabajosScreen2` → tab "Mis postulaciones" en el frontend). Pendiente: mejorar la presentación visual (badges de estado claros, orden cronológico) — ver tareas pendientes del frontend.

## Cambios pendientes de propagar al código

El esquema en `script.sql` ya refleja las reglas anteriores, pero el código (backend y frontend) todavía asume el esquema viejo en varios puntos:

| Área | Qué hay que cambiar |
|---|---|
| `categoriaController.js`, `usuarioController.js` (login), `notificacionService.js` | Siguen consultando correctamente vía `usuario_categoria` (eso no cambia), pero `notificacionService.js` lee `categoria.nombre`, que ahora es `categoria.nombre_categoria` |
| `publicacionController.js` | OK, ya usa `publicacion_categoria` — sin cambios necesarios |
| Flujo de aceptar postulación (`trabajoController.js`, `postulacionController.js`) | Falta crear el registro en `historial_servicio` al aceptar |
| `frontend/lib/models/categorie.dart` | Parsea `json['nombre']`; el backend devuelve `nombre_categoria` |
| Reseñas (`resena`) | Sin implementación en backend todavía — se construye desde cero sobre el esquema nuevo |

## Diagrama

El esquema completo en formato DBML (para pegar en [dbdiagram.io](https://dbdiagram.io)) se generó a partir de este script y vive documentado en el historial de conversación del equipo — si se pierde, se puede regenerar leyendo `database/script.sql` tabla por tabla.
