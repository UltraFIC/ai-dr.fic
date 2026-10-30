---
agent: diana.new
description: Escanda la estructura base de un proyecto Diana ya nombrado por /diana.context, valida que no exista, crea carpetas (changes, scrum/backlog, capabilities, prompts) y registra el proyecto en projects-knowledge-radar. Los tickets ya no se scaffoldean por proyecto — viven en el pool compartido `.drfic/tickets/`.
---

# /diana.new - Inicializador de Proyecto Diana

## Uso

/diana.new project="inversions"
/diana.new project="market-lab"
/diana.new project="risk-engine" force="true"

## Argumentos

| Argumento | Valores | Default | Descripcion |
|-----------|---------|---------|-------------|
| action | create \| validate | create | `create` inicializa estructura; `validate` revisa estructura esperada |
| project | string | requerido | Nombre del proyecto, YA decidido y registrado via `/diana.context scope="project"` |
| force | true \| false | false | Si `true`, permite completar faltantes sin sobrescribir archivos existentes |

## Objetivo

Crear la estructura base canonica de un proyecto dentro de:
- `.drfic/diana/projects/<project>/`

con validacion de no colision y registro automatico en:
- `.drfic/diana/projects/registry/indexes/projects-knowledge-radar.yaml`

## Precondicion Obligatoria

`/diana.new` NO decide el nombre del proyecto ni crea prefijos/alias. Antes de ejecutarse:
1. Debe existir `.drfic/diana/projects/<project>/context.md`, producido por `/diana.context scope="project" name="<project>"`.
2. Si ese archivo no existe, detener con error: "ejecuta `/diana.context scope=\"project\"` primero".

## Reglas Canonicas

1. Validacion de existencia (obligatoria):
   - Si ya existe `.drfic/diana/projects/<project>/changes/` (es decir, `/diana.new` ya corrio), detener con error salvo `force=true`.
   - Si existe `id` en `projects-knowledge-radar.yaml`, detener con error.
   - No crear duplicados.

2. Principio de no sobrescritura:
   - En `action=create`, no sobrescribir archivos existentes.
   - En `force=true`, solo completar faltantes.

## Estructura Base Obligatoria

Crear SOLO carpetas y archivos estructurales minimos (el `context.md` del proyecto ya existe, creado por `/diana.context`):

- `.drfic/diana/projects/<project>/README.md` (titulo y descripcion del proyecto)

- `.drfic/diana/projects/<project>/changes/.gitkeep`
- `.drfic/diana/projects/<project>/changes/backup/.gitkeep`

- `.drfic/diana/projects/<project>/scrum/backlog/.gitkeep`
- `.drfic/diana/projects/<project>/scrum/backlog/backup/.gitkeep`

- `.drfic/diana/projects/<project>/capabilities/.gitkeep`

- `.drfic/diana/projects/<project>/prompts/.gitkeep` (reservado para overrides futuros de acciones por proyecto; no se puebla por esta accion)

Nota: no se crea `decision-log.md` ni carpeta `governance/` — no aportan valor en el modelo actual. Tampoco se crea `tickets/` por proyecto: los tickets viven en el pool compartido `.drfic/tickets/` (ver `/diana.ticket`), con el proyecto anotado como metadata dentro de cada ticket, no como carpeta contenedora.

## Registro en Radar (obligatorio)

Actualizar `projects-knowledge-radar.yaml` agregando entrada:

- `id: <project>`
- `enabled: true`
- `knowledge_root: .drfic/knowledge/` (arbol compartido entre todos los proyectos, libre por tema, poblado on-demand por /diana.knowledge; sin carpeta por proyecto ni indice paralelo que mantener)
- `skills_manifest: null` (sera poblado por /diana.skills en `capabilities/manifest.yaml`)
- `agent_skill_matrix: null` (sera poblado por /diana.skills en `capabilities/agent-skill-matrix.yaml`)
- `sdd_engine_matrix: null` (sera poblado por /diana.skills en `capabilities/sdd-engine-matrix.yaml`)

## Nota sobre Archivos Canonicos

Los archivos canonicos se crean con acciones especificas despues de bootstrap:
- `./context.md` -> `/diana.context scope="project"` (ya debe existir antes de este paso)
- `./constitution.md` -> `/diana.constitution`
- `./changes/<name>/context.md` -> `/diana.context scope="change"` o `/diana.change`
- `./changes/<name>/spec.md` -> `/diana.specify` o `/speckit.specify`
- `./changes/<name>/plan.md` -> `/diana.plan` o `/speckit.plan`
- `./changes/<name>/tasks.md` -> `/diana.tasks` o `/speckit.tasks`
- `.drfic/tickets/<project>/tkt-<num>-<palabras>.md` (pool compartido top-level, agrupado por proyecto) -> `/diana.ticket`
- `./capabilities/*.yaml` (manifest, agent-skill-matrix, sdd-engine-matrix) -> `/diana.skills`
- `.drfic/knowledge/**` (contenido libre por tema, arbol compartido entre proyectos) -> `/diana.knowledge`
- `.drfic/skills-dev/<skill-name>/SKILL.md` (borradores de skill, pool compartido entre proyectos) -> `/diana.skills` (genera el borrador) + `/diana.install-skill` (lo activa en uno o mas agentes)

## Action=create

- Confirmar precondicion (`context.md` del proyecto existe).
- Validar inexistencia en carpeta y radar.
- Crear estructura base y archivos minimos.
- Registrar proyecto en radar.
- Reportar rutas creadas y comandos siguientes.

## Action=validate

Verificar:
- Estructura base completa.
- Presencia de archivos estructurales minimos (README/.gitkeep).
- Entrada correcta en radar.
- Coherencia entre `id` y rutas.

Devolver:
- `OK: [n]`
- `GAPS: [n]`
- Acciones sugeridas.

## Hooks de Extension

Antes de inicializar, revisar `.specify/extensions.yml` en `hooks.before_new`.
Despues de inicializar, revisar `.specify/extensions.yml` en `hooks.after_new`.
Manejar `optional` y `enabled` igual que otras acciones Diana/Speckit.

## Integracion Recomendada

Flujo sugerido para proyecto nuevo:
1. `/diana.context scope="project" name="<project>" title="..." description="..."`
2. `/diana.new project="<project>"`
3. `/diana.change project="<project>" name="<primer-change>" title="<cambio-inicial>" description="<contexto>"`
4. `/diana.constitution project="<project>"`
5. `/diana.skills action="generate" scope="project" project="<project>"`
6. `/diana.knowledge scope="project" project="<project>"`
7. `/diana.plan action="generate" scope="project" project="<project>" name="<primer-change>"`
