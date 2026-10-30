---
agent: diana.plan
description: Genera, valida o regenera el plan tecnico Diana a partir de constitucion, spec canonica y spec operativa, usando skills y knowledge como contexto obligatorio antes de /speckit.plan.
---

# /diana.plan — Generador de Plan Tecnico Diana

## Uso

/diana.plan action="generate"
/diana.plan action="validate"
/diana.plan action="regenerate"

Modo recomendado multi-proyecto:

/diana.plan action="generate" scope="project" project="inversions"

## Argumentos

| Argumento | Valores | Default | Descripcion |
|-----------|---------|---------|-------------|
| action | generate | validate | regenerate | generate | Operacion sobre el plan tecnico |
| scope | project | change | sdk | project | Nivel de ejecucion |
| project | id en projects-knowledge-radar | inversions | Proyecto objetivo |
| name | string (nombre de change ya existente) | auto-detect | Change objetivo cuando aplique |

## Comportamiento por default (si omites argumentos)

- Si omites `scope`, se usa `scope="project"`.
- Si omites `project`, se usa `project="inversions"`.
- Si omites `name`, se auto-detecta el change: si existe exactamente uno en `changes/`, se usa ese; si hay varios, se usa el modificado mas recientemente.
- Resultado default: plan tecnico Diana del proyecto/change activo, listo para alimentar `/speckit.plan`.

## Objetivo

Producir un plan tecnico consistente y trazable, subordinado a constitucion + spec canonica + spec operativa, enriquecido por skills y knowledge del proyecto.

## Fuentes Oficiales Obligatorias

Para `scope=project`:
1. `.drfic/diana/projects/registry/indexes/projects-knowledge-radar.yaml`
2. `.drfic/diana/projects/<project>/constitution.md`
3. `.drfic/diana/projects/<project>/changes/<name>/spec.md`
4. `specs/001-plataforma-inversiones-ia/spec.md`
5. `.drfic/diana/projects/<project>/changes/<name>/context.md`
6. `.drfic/tickets/<project>/` (ticket relacionado al change, si existe — pool compartido top-level, agrupado por proyecto)

## Skills + Knowledge First (obligatorio)

Antes de generar o validar plan:

1. Cargar skills:
- `.drfic/diana/projects/<project>/capabilities/manifest.yaml`
- `.drfic/diana/projects/<project>/capabilities/agent-skill-matrix.yaml`
- `.drfic/diana/projects/<project>/capabilities/sdd-engine-matrix.yaml`
- `.drfic/diana/engine/skills/` (escanear directamente el directorio para detectar skills SDK compartidas, sin manifest paralelo)

2. Cargar knowledge (escaneo directo del arbol, sin indice paralelo en ningun scope):
- `.drfic/knowledge/` (arbol compartido entre proyectos; escanear el arbol completo para detectar documentos relevantes al plan)
- Para `scope=sdk`: escanear directamente `.drfic/diana/engine/knowledge/<categoria>/` (sin `master-index.md` que mantener, igual que los demas scopes)

3. Resolver required_skills para etapa de planificacion:
- `speckit.plan`
- En engines alternos: etapa equivalente (`design`, `architecture`).

4. Si falta skill o knowledge:
- No bloquear.
- Degradar con metodologia estandar.
- Reportar gap y comando recomendado `/diana.knowledge ...`.

## Salidas Obligatorias

1. Plan tecnico canonico del change:
- `.drfic/diana/projects/<project>/changes/<name>/plan.md`

2. Evidencia de consistencia plan/spec (en validate):
- reporte en salida con OK/GAPS + acciones sugeridas.

3. Trazabilidad hacia Speckit:
- confirmar que el plan queda listo para `/speckit.plan`.

## Action=generate

- Generar o actualizar `plan.md` subordinado a constitucion y specs.
- Incluir arquitectura, fases, riesgos y criterios de validacion tecnica.
- Mantener alineacion con FR/SC de spec operativa.

## Action=validate

Verificar:
- Que el plan no contradiga constitucion/spec.
- Que cada fase del plan tenga trazabilidad con requisitos de spec.
- Que se consideren skills requeridas para `speckit.plan`.
- Que haya cobertura minima de seguridad, resiliencia, observabilidad y cumplimiento.

Devolver resumen:
- OK: [n]
- GAPS: [n]
- Lista de acciones recomendadas.

## Action=regenerate

- Releer todas las fuentes oficiales.
- Recalcular el plan desde cero.
- Reescribir `plan.md` manteniendo continuidad semantica cuando sea posible.
- Reportar cambios significativos vs version previa.

## Integracion con Speckit

Flujo recomendado:
1. `/diana.skills action="validate" scope="project" project="inversions"`
2. `/diana.knowledge scope="project" project="inversions"`
3. `/diana.plan action="generate" scope="project" project="inversions"`
4. `/speckit.plan`

## Notas de agente (Diana)

Roles conceptuales durante esta accion:
- BULMA: plan-architect (principal)
- VEGETA: canon-reviewer (validacion)
- KRILIN: task-readiness (preparacion de descomposicion)

Estos roles guian la accion, pero la seleccion de agente ejecutor depende de la configuracion del prompt/agent en VS Code.
