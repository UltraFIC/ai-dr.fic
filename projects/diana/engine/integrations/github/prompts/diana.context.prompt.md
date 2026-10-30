---
agent: diana.context
description: Captura el nombre y contexto inicial de un proyecto o de un change, usando la plantilla unica context.md. Debe ejecutarse antes de /diana.new (scope=project) y antes de /diana.change (scope=change).
---

# /diana.context - Captura de Contexto Diana

## Uso

/diana.context scope="project" name="inversions" title="Plataforma de inversiones" description="Monorepo de inversiones asistido por IA"
/diana.context scope="change" project="inversions" name="mfa-accesos-criticos" title="MFA para accesos criticos" description="Agregar MFA para roles trader/admin"
/diana.context scope="change" project="inversions" name="fix-login-timeout" --input "docs/cambios/fix-login-timeout.md"

## Argumentos

| Argumento | Valores | Default | Descripcion |
|-----------|---------|---------|-------------|
| action | create \| validate | create | `create` escribe `context.md`; `validate` revisa estructura esperada |
| scope | project \| change | requerido | A que nivel pertenece el contexto |
| project | string | requerido si `scope=change` | Proyecto objetivo (ya debe existir si `scope=change`) |
| name | string (1-2 palabras significativas, lowercase, sin espacios) | requerido | Nombre de proyecto (`scope=project`) o de change (`scope=change`). Identidad final: es literalmente el nombre de carpeta, sin prefijo ni numeracion. |
| input | ruta markdown | null | Fuente principal del contenido |
| title | string | null | Titulo (si no hay `input`) |
| description | string | null | Descripcion/contexto base (si no hay `input`) |
| content | string | null | Cuerpo completo inline |
| force | true \| false | false | Si `true`, permite sobrescribir `context.md` existente |

## Objetivo

Ser el unico punto de entrada que decide el **nombre** de un proyecto o de un change y produce su `context.md`, antes de que exista cualquier otra carpeta:

- `scope=project` -> `.drfic/diana/projects/<name>/context.md` (debe correr **antes** de `/diana.new`, que luego lee este archivo para confirmar que el proyecto fue registrado).
- `scope=change` -> `.drfic/diana/projects/<project>/changes/<name>/context.md` (crea la carpeta del change si no existe; puede usarse directamente o via el atajo `/diana.change`, que internamente delega aqui cuando no se le pasa `--input`/`content` propio).

## Reglas Canonicas

1. Normalizacion de nombre:
   - `name` NUNCA lleva prefijo forzado (ni `diana-`, ni ningun otro). Se usa tal cual, en minuscula, 1-2 palabras separadas por guion si aplica.
   - No existe alias ni numeracion secuencial para este nombre: la carpeta resultante (`projects/<name>/` o `changes/<name>/`) es la unica identidad.

2. Validacion de existencia:
   - `scope=project`: si ya existe `.drfic/diana/projects/<name>/context.md` y `force=false`, detener con error.
   - `scope=change`: si ya existe `.drfic/diana/projects/<project>/changes/<name>/context.md` y `force=false`, detener con error. Si `project` no existe todavia (no hay `projects/<project>/context.md`), detener y recomendar correr `/diana.context scope="project"` primero.

3. Resolucion de contenido (misma prioridad en ambos scopes):
   1. Si existe `--input`, usar el contenido completo del archivo.
   2. Si no hay `input` y existe `content`, usar `content`.
   3. Si no hay `input` ni `content`, usar la plantilla minima con `title` + `description`.
   4. Si no hay suficiente informacion para (1-3), detener con error accionable.

4. Plantilla base obligatoria: `engine/templates/context.md` (unica para ambos scopes; ver seccion "Tipo"/"Origen" que solo aplica a `scope=change`).

## Action=create

- Resolver `scope`, `name` (y `project` si `scope=change`).
- Validar no-colision segun regla 2.
- Resolver contenido segun regla 3, usando `templates/context.md` como base.
- Escribir `context.md` en la ruta correspondiente.
- Reportar ruta creada y siguiente accion recomendada (`/diana.new` si `scope=project`; `/diana.specify` o `/diana.plan` si `scope=change`).

## Action=validate

Verificar:
- `context.md` existe en la ruta esperada segun `scope`.
- Contiene las secciones minimas (Titulo, Contexto, Alcance, Impacto Esperado, Riesgos, Estado; mas Tipo/Origen si `scope=change`).

Devolver:
- `OK: [n]`
- `GAPS: [n]`
- Acciones sugeridas.

## Hooks de Extension

Antes de crear, revisar `.specify/extensions.yml` en `hooks.before_context`.
Despues de crear, revisar `.specify/extensions.yml` en `hooks.after_context`.
Aplicar politica `optional/enabled` equivalente a otras acciones Diana.

## Integracion Recomendada

Flujo sugerido para proyecto nuevo:
1. `/diana.context scope="project" name="<project>" title="..." description="..."`
2. `/diana.new project="<project>"`
3. `/diana.change project="<project>" name="<primer-change>" title="..." description="..."` (o `/diana.context scope="change"` directo)
4. `/diana.constitution project="<project>"`
5. `/diana.skills action="generate" scope="project" project="<project>"`
6. `/diana.knowledge scope="project" project="<project>"`
7. `/diana.specify project="<project>" name="<primer-change>"`
8. `/diana.plan project="<project>" name="<primer-change>"`
9. `/diana.tasks project="<project>" name="<primer-change>"`
