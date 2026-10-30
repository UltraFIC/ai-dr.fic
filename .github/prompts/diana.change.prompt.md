---
agent: diana.change
description: Crea (o asegura) la carpeta de un change dentro de changes/<name>/ con su context.md, de forma independiente por defecto (sin ticket). Es el atajo de un paso que delega en /diana.context scope="change".
---

# /diana.change - Inicio de un Change

## Uso

/diana.change project="inversions" name="mfa-accesos-criticos" title="MFA para accesos criticos" description="Agregar MFA para roles trader/admin"
/diana.change project="inversions" name="fix-login-timeout" --input "docs/cambios/fix-login-timeout.md"
/diana.change project="inversions" name="taxonomia-riesgo" title="Actualizar taxonomia de riesgo" description="Refinar categorias de riesgo"
/diana.change project="inversions" name="mfa-v2" title="MFA v2" description="..." create_ticket="true" ticket_title="Dar seguimiento a MFA v2"

## Argumentos

| Argumento | Valores | Default | Descripcion |
|-----------|---------|---------|-------------|
| action | create \| validate | create | Crea o valida el change |
| project | string | requerido | Proyecto objetivo (ya debe existir) |
| name | string (1-2 palabras significativas, lowercase) | requerido | Nombre del change; es el nombre literal de la carpeta `changes/<name>/`. Sin numeracion, sin alias. |
| input | ruta markdown | null | Fuente principal del contenido de `context.md` |
| title | string | null | Titulo del change (si no hay `input`) |
| description | string | null | Descripcion base (si no hay `input`) |
| content | string | null | Cuerpo completo inline para `context.md` |
| create_ticket | true \| false | **false** | Si `true`, ademas crea un ticket en el pool compartido `.drfic/tickets/` enlazado a este change. Por defecto un change NO crea ticket: un change debe poder generarse de forma independiente. |
| ticket_title | string | auto | Titulo del ticket derivado (solo si `create_ticket=true`) |
| ticket_description | string | auto | Descripcion del ticket derivado (solo si `create_ticket=true`) |

## Objetivo

Asegurar que exista `changes/<name>/` con su `context.md`, delegando la captura de contenido en la misma logica que `/diana.context scope="change"` (de hecho, `/diana.change` es un atajo de un solo paso sobre esa accion; si `/diana.context scope="change" project="<project>" name="<name>"` ya corrio, este comando simplemente confirma que existe y, si `create_ticket=true`, crea el ticket enlazado).

## Reglas de Resolucion de Contenido

Prioridad para construir el contenido de `context.md` (identica a `/diana.context`):

1. Si existe `--input`, usar el contenido completo del archivo.
2. Si no hay `input` y existe `content`, usar `content`.
3. Si no hay `input` ni `content`, usar la plantilla minima (`templates/context.md`) con `title` + `description`.
4. Si no hay suficiente informacion para (1-3), detener con error accionable.

## Estructura de Salida

- `.drfic/diana/projects/<project>/changes/<name>/context.md`
- Ticket relacionado (solo si `create_ticket=true`):
  - `.drfic/tickets/<project>/tkt-<num_ticket_interno>-<1-4 palabras>.md` (pool compartido, agrupado por proyecto), con su campo `Relacion` apuntando a `project: <project>` y `change: changes/<name>`.

## Action=create

- Resolver `project` y `name` (sin prefijo ni alias).
- Validar que `changes/<name>/` no exista ya (salvo que se este completando con `--input` sobre un change existente, en cuyo caso tratar como `/diana.context action=validate` primero).
- Resolver contenido de `context.md` con la prioridad definida, usando `templates/context.md`.
- Crear `changes/<name>/context.md`.
- Si `create_ticket=true`, crear el ticket relacionado (ver `/diana.ticket`, modo `create` o `link`).
- Reportar rutas creadas.

## Action=validate

Verificar:
- `changes/<name>/context.md` existe y cumple la estructura de `templates/context.md`.
- Si existe algun ticket que declare `Relacion` hacia este change, la referencia es consistente.

Devolver:
- `OK: [n]`
- `GAPS: [n]`
- Acciones sugeridas.

## Hooks de Extension

Antes de crear, revisar `.specify/extensions.yml` en `hooks.before_change`.
Despues de crear, revisar `.specify/extensions.yml` en `hooks.after_change`.
Aplicar politica `optional/enabled` equivalente a otras acciones Diana.
