# SDD Lifecycle — Diana SDK Knowledge

> **ID**: SDK-M-001
> **Generado**: 2026-10-11 | **Estado**: 🟢 Completo
> **Scope**: SDK-level (cross-proyecto)
> **Fuentes internas**: `engine/rules/lifecycle.md`, `engine/rules/speckit-integration.md`, `engine/rules/spec-versioning.md`, `engine/rules/governance-and-naming.md`, `engine/rules/sdd-quality-metrics.md`, `engine/templates/integration-profile.md`, `engine/templates/engine-handoff.md`

---

## Resumen

Diana es el **motor de gobernanza SDD (Software/Spec-Driven Development)**: define qué artefactos existen, cuándo nacen, quién los aprueba y qué puede tocar un engine de ejecución (Speckit, OpenSpec u otro). Diana nunca ejecuta código ni genera planes por sí misma en producción — gobierna el canon y delega la ejecución operativa a un *engine* bajo un **perfil de integración** explícito (`diana_only | speckit | openspec | hybrid`, ver `templates/integration-profile.md`).

Principio rector (literal de `rules/speckit-integration.md`):

> **DIANA-SDK gobierna. Speckit ejecuta. El canon no se infiere.**

---

## 1. Eventos de origen (qué detona trabajo)

Solo existen tres eventos de origen válidos para iniciar trabajo (`rules/lifecycle.md` §3):

1. **Control de Cambios** (`<NNN>-<PROYECTO>-CC`) — describe el problema/necesidad, nunca la solución técnica.
2. **Ticket de usuario** (`<NNN>-<PROYECTO>-TKT`) — puede referenciar un CC; sin CC solo se permite para bugfix.
3. **Decisión estratégica explícita** — declarada por un humano con autoridad sobre el proyecto.

Estos eventos pertenecen a la dimensión **organizacional**: no son ejecutables y Speckit/OpenSpec **nunca los leen ni interpretan directamente**. Su trazabilidad hacia el canon se declara siempre en `meta.md` (informativo, no ejecutable).

## 2. Tipos de iniciativa y qué artefactos nacen

El tipo de iniciativa determina qué nace. Hay exactamente tres tipos (`rules/lifecycle.md` §4-§7):

| Tipo | Condición | Nace | NO nace |
|------|-----------|------|---------|
| **Greenfield** (proyecto nuevo) | No existe sistema previo ni canon funcional | `constitution.md`, `spec.md` (SPEC-001), `plan.md` | Iniciativas previas, specs derivadas |
| **Brownfield** (evolución funcional) | El sistema existe; cambia el "qué" | `spec.md` nuevo (derivado), `plan.md` | Nueva constitución; no se reescribe el canon fundacional |
| **Bugfix** (corrección) | Existe ticket de error; no cambia comportamiento esperado | `plan.md` correctivo, `tasks/` | Constitución; nueva especificación funcional |

Regla de oro: *"No todo cambio genera una especificación. No toda especificación genera una constitución. Todo lo que se ejecuta debe tener canon explícito."*

## 3. El ciclo de fases (specify → clarify → plan → tasks → implement)

Diana gobierna, pero el ciclo operativo que ejecuta el engine (Speckit u otro) sigue las fases estándar de la industria SDD. Mapeo oficial de artefactos a fases, con los agentes Diana que gobiernan cada una (ver detalle completo en `knowledge/agents/agent-roles-deep.md`):

| Fase | Comando típico del engine | Artefacto producido | Agente Diana que gobierna | Autoridad |
|------|---------------------------|---------------------|---------------------------|-----------|
| 0. Constitution | `/speckit.constitution` (solo greenfield, evento raro) | `constitution.md` | Humano + VEGETA (revisión) | Canónica, casi inmutable |
| 1. Specify | `/speckit.specify` | `spec.md` (`<NNN>-<PROYECTO>-SPEC`) | **PICCOLO** (Spec Writer) | Canónica — autoridad funcional |
| 2. Clarify | `/speckit.clarify` | Ambigüedades resueltas dentro de `spec.md` | PICCOLO + VEGETA | Refina el canon, no lo redefine |
| 3. Plan | `/speckit.plan` | `plan.md` (`<NNN>-<PROYECTO>-PLAN`) | **BULMA** (Plan Architect) | Canónica — implementa la spec, no la redefine |
| 4. Tasks | `/speckit.tasks` | `tasks/` (`<NNN>-<PROYECTO>-TASK`) | **KRILIN** (Task Generator) | Derivada — mapea 1:1 al plan |
| 5. Implement | `/speckit.implement` (o engine equivalente) | Código + artefactos derivados (`research.md`, `data-model.md`, contratos, `quickstart.md`) | Engine ejecuta; **GOHAN** valida | Derivada, regenerable |

Nota de compatibilidad: este ciclo es funcionalmente equivalente al de GitHub Spec Kit (`constitution → specify → clarify → plan → tasks → implement`), al de AWS Kiro (`requirements.md → design.md → tasks.md`, con gates de aprobación humana entre cada uno) y, de forma más flexible, a los artefactos *delta spec* de OpenSpec (`propose → apply → sync → archive`). Diana no reinventa el ciclo: lo gobierna añadiendo una capa de canon y trazabilidad por encima del engine elegido.

## 4. Roles de los artefactos

- **`constitution.md`** — principios no negociables del proyecto (filosofía, límites, convenciones). Nace solo en greenfield o por decisión explícita de alto nivel. Es el equivalente funcional del `constitution.md` de Spec Kit y de los `steering files` (`product.md/tech.md/structure.md`) de Kiro, pero en Diana es **canon versionado y casi inmutable**, no contexto ambiental cargado automáticamente.
- **`spec.md`** — el "qué": comportamiento esperado, requisitos funcionales/no funcionales, fuera de alcance, criterios de aceptación medibles. Autoridad funcional; si hay ambigüedad, el engine debe detenerse (nunca inferir).
- **`plan.md`** — el "cómo": arquitectura técnica, fases, componentes, riesgos. Implementa la spec; nunca redefine alcance. Un plan puede evolucionar sin que la spec cambie.
- **`tasks/`** — descomposición atómica y verificable del plan, con dependencias explícitas y trazabilidad hacia `plan.md`. No crean funcionalidad nueva.
- **`meta.md`** — trazabilidad organizacional (CC/ticket de origen, tipo de iniciativa). Informativo, nunca ejecutable; el engine **no lo interpreta**.
- **`integration-profile.md`** — decide el `motor_sdd` (`diana_only | speckit | openspec | hybrid`), el modo de orquestación (manual/automático) y la política de sincronización de tareas para la iniciativa activa (ver sección 6).
- **`engine-handoff.md`** — el "contrato" explícito que indica a un engine concreto qué debe consumir, en qué orden, y qué límites de reinterpretación tiene. Es la pieza que hace posible el modo híbrido sin que el engine contamine el canon.

## 5. Puntos de control y validación entre fases (quality gates)

Las métricas oficiales (`rules/sdd-quality-metrics.md`) se evalúan **antes de avanzar de fase**, nunca post-mortem:

- Antes de `/speckit.plan` → validar completitud y no-ambigüedad de `spec.md` (PICCOLO/VEGETA).
- Antes de `/speckit.tasks` → validar trazabilidad spec → plan (BULMA/KRILIN).
- Antes de implementar → validar determinismo de ejecución y cero/mínimas inferencias (VEGETA).
- Después de cualquier cambio funcional → revalidar estabilidad evolutiva y reutilización del canon (TRUNKS/BULMA).

Umbral mínimo para considerar una iniciativa "lista para ejecución": canon alto, ambigüedad baja, inferencias cero o mínimas, trazabilidad completa, determinismo IA alto. **Si una falla, la iniciativa no debe ejecutarse** — se regresa a la fase anterior (ver §7).

## 6. Cómo Diana gobierna y el engine ejecuta

Reglas duras (`rules/speckit-integration.md` §4-§6):

- El engine (Speckit/OpenSpec/otro) **solo opera a nivel de iniciativa** (`projects/<proyecto>/initiatives/<NNN>/`), nunca a nivel de proyecto o portafolio.
- El engine **puede generar** artefactos derivados dentro de su propia subcarpeta (`speckit/`, equivalente para otros engines): planes derivados, research, data-model, contratos, tasks. Estos son regenerables y no tienen autoridad sobre el canon.
- El engine **no puede** crear/modificar `constitution.md`, crear specs funcionales nuevas, inferir requisitos ausentes, interpretar tickets/CR, ni cambiar el idioma declarado.
- Ante ambigüedad, información incompleta o conflicto entre artefactos, el engine **debe detenerse y reportar** — nunca asumir.
- Toda aprobación del canon es **siempre humana**; regenerar un artefacto derivado no implica aprobarlo.

## 7. Ciclos de retroalimentación (cuándo regresar a una fase anterior)

- Si `/speckit.clarify` revela que el "qué" no estaba bien definido → se regresa a **Specify** (PICCOLO), nunca se parchea el plan para compensar.
- Si la validación GOHAN detecta desviación entre implementación y canon → se regresa a **Tasks** o **Plan** según el origen del gap (nunca se re-interpreta la spec silenciosamente).
- Si un bug revela ambigüedad real en la spec → se aclara sin cambiar comportamiento, o se versiona explícitamente como nueva iniciativa (`rules/spec-versioning.md` §10). Un bugfix **nunca** crea una nueva versión de spec por sí mismo.
- Cambios de "cómo" (refactor, performance, librerías) nunca disparan versionado de spec; solo cambios de "qué" lo hacen (`rules/spec-versioning.md` §4).
- Cada nueva versión de spec vive en una **nueva iniciativa** (`SPEC-001` → iniciativa `001-foundation`; `SPEC-002` → iniciativa `002-...`), nunca como `spec-v2.md` dentro de la misma carpeta.

## 8. Modos de operación: standalone vs. híbrido

Diana ya contempla operación dual vía `integration-profile.md` (`motor_sdd`):

- **`diana_only`** — Diana gobierna y ejecuta sin delegar a un engine externo; usar en iniciativas pequeñas o cuando no se requiere la maquinaria de Speckit/OpenSpec.
- **`speckit`** — Diana gobierna, Speckit ejecuta specify→plan→tasks→implement dentro de los límites de la sección 6.
- **`openspec`** — igual que arriba, pero usando el ciclo propose/apply/sync/archive de OpenSpec como engine de ejecución; Diana mapea sus fases (specify≈propose, plan≈design, tasks≈tasks, implement≈apply, archive≈cierre de iniciativa).
- **`hybrid`** — más de un engine convive (p. ej. OpenSpec para iteración rápida de deltas + Speckit para iniciativas grandes con gates estrictos); el `engine-handoff.md` de cada iniciativa declara qué engine aplica a qué stage, y la política `conflicto_sin_mapeo: block_global_close` impide cerrar la iniciativa si hay un conflicto de mapeo sin resolver.

Esto es deliberado y refleja el consenso 2026 de la industria: ningún framework SDD exige ser el único (Thoughtworks posiciona OpenSpec como "tool agnostic"; guías CxO recomiendan no estandarizar a un solo framework por portafolio). Diana lo resuelve con un artefacto explícito versionado (`integration-profile.md`) en vez de dejarlo implícito en la cabeza del equipo.

## 9. Comparativa con frameworks SDD pares

| Framework | Fases equivalentes | Gate humano | Artefacto de principios | Reconciliación spec↔código |
|-----------|--------------------|--------------|--------------------------|------------------------------|
| **Diana (este SDK)** | specify→clarify→plan→tasks→implement, gobernado por agentes | Sí, obligatorio en constitution/spec/plan | `constitution.md` (canon casi inmutable) | Vía GOHAN + métricas de calidad SDD |
| **GitHub Spec Kit** | constitution→specify→clarify→plan→tasks→implement→(converge, 2026) | Opcional, vía revisión de PR | `constitution.md` (prompt fragment, cargado por comando) | `/speckit.reconcile` (nuevo, 2026) |
| **OpenSpec** | explore→propose→apply→sync→archive (delta specs ADDED/MODIFIED/REMOVED) | Fluido, sin gates rígidos por diseño | Opcional vía schema `spec-driven-with-adr` | `/opsx:sync` |
| **AWS Kiro** | requirements(EARS)→design→tasks, variantes Requirements-First/Design-First/Quick Spec | Sí, gate de aprobación entre cada markdown | `steering/` (`product.md`, `tech.md`, `structure.md`) | Diffs en vivo por tarea; sin reconcile automático documentado |
| **BMAD-METHOD** | Planning (Analyst→PM→Architect) → Context-Engineered Dev (SM→Dev→QA) | Sí, Definition of Ready por historia | PRD + Architecture doc + ADRs | Revisión manual del agente QA |

Fuentes: ver `remote/sources.md` (sección a poblar con snapshots) y la lista completa de URLs citadas en el reporte de generación de este documento.

## 10. Gaps abiertos

- No existe aún en este repo un comando `/diana.reconcile` (o equivalente) para cerrar el loop spec↔código de forma semi-automática, a diferencia de `/opsx:sync` o `/speckit.reconcile`. Recomendado evaluarlo como extensión futura.
- `rules/sdd-quality-metrics.md` asigna responsabilidad a TRUNKS para "Impacto de Cambios Funcionales", pero TRUNKS no tiene aún un prompt file en `engine/agents/` (es "opcional" según `rules/agents.md`). Ver gap detallado en `knowledge/agents/agent-roles-deep.md`.
