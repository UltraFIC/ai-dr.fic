---
agent: diana.constitution
description: Genera, valida o regenera la constitucion de un proyecto Diana usando como fuente principal el context.md de un change, con soporte dinamico por proyecto e input explicito.
---

# /diana.constitution - Generador de Constitucion Diana

## Uso

/diana.constitution action="generate"
/diana.constitution action="validate"
/diana.constitution action="regenerate"
/diana.constitution project="inversions"

Con entrada explicita:

/diana.constitution action="generate" --input ".drfic/diana/projects/inversions/changes/mfa-accesos-criticos/context.md"

Ejemplos de uso:

1. Generacion automatica de la constitucion desde el context.md de change mas reciente:
- /diana.constitution project="demoapp"

2. Generacion automatica de la constitucion desde el context.md de un change especifico:
- /diana.constitution project="demoapp" name="setup-inicial"

3. Respetar contenido exacto de una constitucion formal entregada por el usuario:
- /diana.constitution project="demoapp" --input "temporal/demoapp-constitution-tempo.md" input_mode="authoritative"

4. Profesionalizar un borrador de constitucion y tomar en cuenta el context.md de un change o una fuente de contexto especifica:
- /diana.constitution project="demoapp" --input "temporal/borrador-constitucion.md" input_mode="draft"
- /diana.constitution project="demoapp" --input "temporal/borrador-constitucion.md" input_mode="draft" context_input=".drfic/diana/projects/demoapp/changes/setup-inicial/context.md"

## Argumentos

| Argumento | Valores | Default | Descripcion |
|-----------|---------|---------|-------------|
| action | generate | validate | regenerate | generate | Operacion sobre la constitucion |
| scope | project | change | sdk | project | Nivel de ejecucion |
| project | id en projects-knowledge-radar | inversions | Proyecto objetivo |
| name | string (nombre de change ya existente) | auto-detect | Change cuyo `context.md` se usa como fuente, cuando aplique |
| input | ruta de archivo markdown | null | Input opcional: `context.md` especifico, constitucion formal del usuario o borrador de constitucion |
| context_input | ruta de archivo markdown | auto-resolver segun modo | Contexto explicito opcional (`context.md` de change, spec u otro artefacto canonico de soporte) |
| input_mode | authoritative | draft | draft | Define si `--input` se respeta casi literalmente o si puede enriquecerse/normalizarse |

## Comportamiento por default (si omites argumentos)

- Si omites `action`, se usa `action="generate"`.
- Si omites `scope`, se usa `scope="project"`.
- Si envias solo `project`, se busca automaticamente el `context.md` de change mas reciente del proyecto.
- Si no envias `project`, se usa `project="inversions"`.
- Si omites `name`, se auto-detecta el change: si existe uno solo, se usa ese; si hay varios, se usa el modificado mas recientemente.

## Objetivo

Producir una constitucion canonica, trazable y validable, derivada principalmente del `context.md` de un change del proyecto activo.

## Modelo de Generacion

La constitucion se construye con tres capas:

1. Fuente primaria:
- `context.md` de change auto-resuelto o `--input` explicito.

2. Estructura canonica:
- plantilla constitucional minima de Diana (proposito, principios, gobernanza, calidad/cumplimiento y versionado).

## Plantilla Base Obligatoria

La accion MUST cargar como base la plantilla fisica del SDK:
- `.drfic/diana/engine/templates/constitution.md`

Regla de uso:
1. Cargar estructura y secciones base desde la plantilla.
2. Aplicar la derivacion desde `context.md`/input sobre esa estructura.
3. Mantener trazabilidad explicita fuente -> constitucion.
4. Si la plantilla no existe, degradar a plantilla minima del prompt y reportar GAP.

3. Agente especializado:
- redaccion normativa.
- trazabilidad context.md -> principios.
- deteccion de gaps.
- normalizacion semantica y de gobernanza.

El agente puede apoyarse en metodologia base compartida de Diana/SDK, pero NO requiere que ya existan `skills` o `knowledge` del proyecto. Esos artefactos se generan despues de la constitucion.

## Regla de Fuente Principal (obligatoria)

La accion debe resolver fuentes por escenario:

1. Sin `--input`:
- usar el `context.md` del change mas reciente del proyecto como fuente primaria.

2. Con `--input` apuntando a un `context.md` de change:
- usar ese input como fuente primaria.

3. Con `--input` y `input_mode="authoritative"`:
- interpretar `--input` como constitucion formal del usuario.
- respetar contenido fuente (normalizacion minima).
- usar contexto secundario solo para validacion cruzada y trazabilidad (desde `context_input` o auto-resuelto).

4. Con `--input` y `input_mode="draft"`:
- interpretar `--input` como borrador de constitucion.
- complementar obligatoriamente con contexto de cambio/alcance (desde `context_input` o auto-resuelto) para derivar restricciones y gobernanza.

Si se requiere contexto y no existe ni `context_input` ni fuente auto-resuelta, detener con error accionable.

## Comportamiento de `input_mode`

Si se usa `--input`, el agente debe aplicar uno de estos modos:

1. `input_mode="authoritative"`
- Respetar el contenido fuente como autoritativo.
- Permitir solo normalizacion estructural minima, naming, secciones obligatorias y trazabilidad.
- NO inventar alcance nuevo ni reglas no sustentadas por el input.
- Si faltan secciones constitucionales, reportar gaps en lugar de rellenarlas agresivamente.
- El contexto secundario se usa solo para validacion cruzada (no para reescribir el contenido autoritativo).

2. `input_mode="draft"`
- Tratar el input como borrador base.
- Permitir enriquecer redaccion, formalizar principios, completar secciones faltantes y convertir el contenido a lenguaje constitucional/normativo.
- Mantener trazabilidad explicita entre contenido fuente y contenido inferido/normalizado.
- Integrar contexto auto-resuelto o `context_input` especifico para no perder alcance y restricciones del cambio.

Si no se especifica `input_mode`, usar `draft`.

## Fuentes Secundarias (solo para validacion cruzada)

Estas fuentes NO sustituyen la fuente primaria, solo validan consistencia:
- `.drfic/diana/projects/<project>/constitution.md` (si existe)
- `.drfic/diana/projects/<project>/changes/<name>/spec.md` (si existe)
- `specs/001-plataforma-inversiones-ia/spec.md` (si existe)

## Salidas Obligatorias

1. Constitucion canonica del proyecto:
- `.drfic/diana/projects/<project>/constitution.md`

2. Reporte de trazabilidad context.md -> Constitucion (en salida):
- Lista de secciones/principios derivados del `context.md`.
- Gaps detectados y decision tomada.

3. Reporte de validacion (en `action=validate`):
- `OK: [n]`
- `GAPS: [n]`
- Acciones sugeridas.

## Plantilla Minima de Constitucion (resultado esperado)

El resultado debe incluir al menos:
1. Proposito y alcance.
2. Principios no negociables.
3. Gobernanza de cambios.
4. Criterios de calidad y cumplimiento.
5. Politica de versionado de constitucion.

## Action=generate

- Cargar plantilla base en `.drfic/diana/engine/templates/constitution.md`.
- Resolver escenario de fuentes segun `input`, `input_mode` y `context_input`.
- Si corresponde, resolver automaticamente el `context.md` del change mas reciente.
- Aplicar `input_mode` cuando exista `--input`.
- Generar o actualizar `constitution.md` con trazabilidad explicita al `context.md` fuente.
- Mantener redaccion normativa (MUST/SHOULD claros, sin ambiguedad).

## Action=validate

Verificar:
- Que existe trazabilidad directa al `context.md` fuente.
- Que no hay principios contradictorios con el `context.md`.
- Que el versionado de constitucion es coherente.
- Que la gobernanza de cambios esta explicitada.

Devolver resumen:
- OK: [n]
- GAPS: [n]
- Lista de acciones recomendadas.

## Action=regenerate

- Releer fuente primaria actual.
- Recalcular constitucion desde cero.
- Reescribir `constitution.md` preservando continuidad semantica cuando sea posible.
- Reportar cambios significativos frente a version previa.

## Comportamiento Dinamico Recomendado

- Si el proyecto cambia, resolver automaticamente rutas con `<project>` y `<name>`.
- Si el change fuente cambia, priorizar `--input` o `name` explicito.
- Si ejecutas `/diana.constitution project="<project>"`, usar por default el `context.md` del change mas reciente del proyecto.
- Para pipelines o ejecucion reproducible, preferir siempre `--input` explicito.
- Si el usuario desea preservar fielmente un contenido entregado, combinar `--input` con `input_mode="authoritative"`.
- Si el usuario desea profesionalizar un borrador, combinar `--input` con `input_mode="draft"` y opcionalmente `context_input` para fijar la fuente de contexto exacta.

## Integracion Recomendada

Flujo sugerido:
1. `/diana.constitution action="generate" --input "<ruta-context.md>"`
2. `/diana.skills action="generate" scope="project" project="<project>"`
3. `/diana.knowledge scope="project" project="<project>"`
4. `/diana.plan action="generate" scope="project" project="<project>"`

## Notas de agente (Diana)

Roles conceptuales durante esta accion:
- BULMA: constitution-architect (principal)
- VEGETA: governance-reviewer (consistencia y rigor)
- KRILIN: traceability-checker (mapeo context.md -> constitucion)

Estos roles guian la accion, pero la seleccion de agente ejecutor depende de la configuracion del prompt/agent en VS Code.

El agente entra en accion con conocimiento base metodologico de Diana y una estructura canonica de constitucion; no depende de `skills` ni `knowledge` especificos del proyecto para generar la primera constitucion.
