---
agent: diana.tasks
description: Genera, valida o regenera el backlog canónico Diana desde constitución, especificación y plan, y lo enlaza con el backlog operativo de Speckit.
---

# /diana.tasks — Generador de Tareas Canónicas Diana

## Uso

/diana.tasks action="generate"
/diana.tasks action="validate"
/diana.tasks action="regenerate"
/diana.tasks action="generate" project="inversions" name="mfa-accesos-criticos" team="TEAM-01"

Modo recomendado multi-proyecto:

/diana.tasks action="generate" scope="project" project="inversions" name="mfa-accesos-criticos"

Modo incremental multi-team:

/diana.tasks action="generate" project="inversions" name="mfa-accesos-criticos"

## Argumentos

| Argumento | Valores | Default | Descripcion |
|-----------|---------|---------|-------------|
| action | generate | validate | regenerate | generate | Operacion sobre el backlog canónico |
| scope | project | change | sdk | project | Nivel de ejecucion |
| project | id en projects-knowledge-radar | inversions | Proyecto objetivo |
| name | string (nombre de change ya existente) | auto-detect | Change objetivo |
| team | TEAM-01..TEAM-99 | null | Equipo objetivo para generacion puntual en topologia multi_team |

## Comportamiento por default

- Si omites `scope`, se usa `scope="project"`.
- Si omites `project`, se usa `project="inversions"`.
- Si omites `name`, se auto-detecta el change: si existe exactamente uno en `changes/`, se usa ese; si hay varios, se usa el modificado mas recientemente.
- Resultado default: backlog canónico del change activo, listo para coordinación con `/speckit.tasks` o `/speckit.implement`.
- En `topology: multi_team`, si omites `team`, generar SOLO tasks pendientes por equipo (equipos en `scope_primario.md` que aun no tengan `teams/TEAM-XX/tasks.md`).

## Fuentes Oficiales Obligatorias

1. `.drfic/diana/projects/registry/indexes/projects-knowledge-radar.yaml`
2. `.drfic/diana/projects/<project>/constitution.md`
3. Fuente de spec segun topologia:
  - `single_person`: `.drfic/diana/projects/<project>/changes/<name>/spec.md`
  - `multi_team`: `.drfic/diana/projects/<project>/changes/<name>/teams/TEAM-XX/spec.md`
4. Fuente de plan segun topologia:
  - `single_person`: `.drfic/diana/projects/<project>/changes/<name>/plan.md`
  - `multi_team`: `.drfic/diana/projects/<project>/changes/<name>/teams/TEAM-XX/plan.md`
5. `specs/001-plataforma-inversiones-ia/spec.md`
6. `specs/001-plataforma-inversiones-ia/plan.md` (si existe como derivado operativo)
7. `.drfic/diana/projects/<project>/capabilities/manifest.yaml`
8. `.drfic/diana/projects/<project>/capabilities/agent-skill-matrix.yaml`
9. `.drfic/diana/projects/<project>/capabilities/sdd-engine-matrix.yaml`

## Skills + Knowledge First (obligatorio)

Antes de generar o validar tareas:

1. Cargar skills relevantes para `speckit.tasks`.
2. Cargar knowledge del change, proyecto y SDK en ese orden.
3. Si falta skill o knowledge_doc:
- No bloquear.
- Continuar con metodología estándar.
- Reportar gap y recomendar `/diana.knowledge`.

## Template Core Obligatoria

1. `.drfic/diana/engine/templates/change-tasks.md`

## Salidas Obligatorias

1. Backlog canonico de salida (segun topologia):
  - `single_person`: `.drfic/diana/projects/<project>/changes/<name>/tasks.md`
  - `multi_team`: `.drfic/diana/projects/<project>/changes/<name>/teams/TEAM-XX/tasks.md`
2. Enlace de derivación hacia `specs/001-plataforma-inversiones-ia/tasks.md` cuando exista
3. Resumen de congruencia Diana <-> Speckit en salida de validación

## Action=generate

- Generar backlog canónico por fases, historias o streams.
- Mantener IDs estables cuando sea posible.
- Incluir trazabilidad a constitución, especificación y plan.
- Declarar si existe un backlog operativo derivado para Speckit.

## Action=validate

Verificar:
- Que toda tarea derive del plan y no contradiga la constitución.
- Que exista cobertura suficiente de requisitos y restricciones.
- Que las dependencias estén explicitadas.
- Que, si existe `specs/.../tasks.md`, la congruencia entre ambos backlog sea explicable.

Devolver resumen:
- OK: [n]
- GAPS: [n]
- Lista de acciones recomendadas.

## Action=regenerate

- Releer todas las fuentes oficiales.
- Recalcular backlog desde cero.
- Reescribir `tasks.md` manteniendo continuidad semántica cuando sea posible.
- Reportar cambios significativos vs versión previa.

## Conciencia de Topologia (OBLIGATORIO ANTES DE GENERAR)

Antes de generar tareas, leer `context.md` del change para determinar topologia:

- `.drfic/diana/projects/<project>/changes/<name>/context.md`

Si `topology: single_person` (o no hay topology registrado):
- Generar backlog unico: `<name>/tasks.md` (comportamiento default)

Si `topology: multi_team`:
- Leer `scope_primario.md`:
  `.drfic/diana/projects/<project>/changes/<name>/scope_primario.md`
- Resolver fuente base de tareas (en orden):
  1. `teams/TEAM-XX/tasks.md` existentes (si aplica para incremental/regenerate)
  2. `<name>/tasks.md` (si existe)
  3. `teams/TEAM-XX/spec.md` + `teams/TEAM-XX/plan.md` + constitucion + context.md (si NO existe tasks global)
- Leer el plan y spec por equipo ya generados:
  - `<name>/teams/TEAM-XX/spec.md`
  - `<name>/teams/TEAM-XX/plan.md`
- Si se pasa `team=TEAM-XX`:
  - Generar SOLO `<name>/teams/TEAM-XX/tasks.md`
  - Si el team no existe en `scope_primario.md`, detener con error accionable.
- Si NO se pasa `team`:
  - Resolver lista de equipos desde `scope_primario.md`.
  - Generar SOLO equipos pendientes (`teams/TEAM-XX/tasks.md` inexistente).
  - No regenerar equipos ya existentes en `action=generate`.
  - Reportar al final: `generados`, `omitidos_por_existencia`, `errores`.
- Cada tasks.md de equipo contiene SOLO las tareas correspondientes al scope_primario del equipo,
  con IDs trazables al canonico global (`tasks.md` del change).
- Cuando exista `tasks.md` (global del change), preservar literalidad de lineas de tarea al derivar por equipo
  (incluyendo checkbox `- [ ]` o `- [x]`, ID y descripcion).
- Speckit lee `teams/TEAM-XX/tasks.md` como input base y los optimiza con su logica SDD.
- En `multi_team`, el backlog global puede no existir; no debe bloquear la generacion por equipo.

Reglas operativas multi-team:
1. `action=generate` + `team` especifico -> operacion puntual de un equipo.
2. `action=generate` sin `team` -> operacion incremental sobre pendientes.
3. `action=regenerate` + `team` especifico -> reescribe solo ese equipo.
4. `action=regenerate` sin `team` -> reescribe todos los equipos de `scope_primario.md`.
5. `action=validate` sin `team` -> valida todos los equipos y reporta faltantes.

## Integración con Speckit

Flujo recomendado:
1. `/diana.integrate action="bootstrap" scope="project" project="inversions" name="mfa-accesos-criticos" engine="speckit" orchestration="manual" topology="multi_team"`
2. `/diana.skills action="validate" scope="project" project="inversions"`
3. `/diana.knowledge scope="project" project="inversions"`
4. `/diana.plan action="generate" scope="project" project="inversions"`
5. `/diana.tasks action="generate" scope="project" project="inversions" name="mfa-accesos-criticos"`
6. `/speckit.tasks` solo como derivado operativo o validación de ejecución
7. `/diana.teams action="generate" scope="project" project="inversions" name="mfa-accesos-criticos"`
8. `/diana.sync action="tasks" mode="dry-run"` al cierre de sprint
9. `/speckit.implement`

## Notas de agente (Diana)

Roles conceptuales durante esta acción:
- BULMA: decomposition-architect
- VEGETA: constitutional-reviewer
- KRILIN: implementation-readiness
