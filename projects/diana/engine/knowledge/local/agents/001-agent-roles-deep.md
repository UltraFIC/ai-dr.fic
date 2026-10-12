# Agent Roles Deep — Diana SDK Knowledge

> **ID**: SDK-A-001
> **Generado**: 2026-10-11 | **Estado**: 🟢 Completo
> **Scope**: SDK-level
> **Fuentes internas**: `sdk/diana/rules/agents.md`, `sdk/diana/prompts/agent-*.md`, `sdk/diana/rules/sdd-quality-metrics.md`, `sdk/diana/rules/speckit-integration.md`

---

## Resumen

Diana define identidades narrativas (alias estilo Dragon Ball) para sus agentes IA, pero el **principio rector es que el alias nunca sustituye el rol técnico**:

> **El rol técnico manda. El alias comunica. El canon no se negocia.**

Cada agente se define por: alias narrativo, rol técnico SDD, responsabilidades explícitas y prohibiciones explícitas. Los agentes son **asistentes disciplinados, no decisores**: no infieren requisitos ausentes, no modifican el canon sin autorización humana y no actúan fuera de su rol. Speckit (o cualquier engine) reconoce el rol técnico, ignora la narrativa, y respeta el canon que los agentes protegen.

## Mapeo oficial de agentes

| Alias | Rol técnico | Fase SDD principal | Prompt file |
|-------|-------------|---------------------|-------------|
| **PICCOLO** | Spec Writer | Specify / Clarify | `prompts/agent-spec-writer.md` |
| **BULMA** | Plan Architect | Plan | `prompts/agent-plan-architect.md` |
| **VEGETA** | Canon Reviewer | Transversal (valida en cada transición de fase) | `prompts/agent-reviewer.md` |
| **KRILIN** | Task Generator | Tasks | `prompts/agent-task-generator.md` |
| **GOHAN** | QA Validator | Implement / post-implementación | `prompts/agent-qa-validator.md` |
| **GOKU** | Copilot | Transversal (asistencia continua) | `prompts/agent-copilot.md` |
| **TRUNKS** | Evolution / Refactor Agent (opcional) | Evolución futura, estabilidad evolutiva | *No existe aún — ver Gaps* |

---

## PICCOLO — Spec Writer

**Cuándo actúa**: al inicio de una iniciativa greenfield (genera `spec.md` SPEC-001) o cuando una iniciativa brownfield requiere una especificación derivada porque cambia el "qué" del sistema. También interviene en `/speckit.clarify` para resolver ambigüedades dentro de la spec existente.

**Qué produce**: `spec.md` completo y estructurado — requisitos funcionales y no funcionales claros, fuera de alcance explícito, criterios de aceptación medibles.

**Entradas permitidas**: `constitution.md` (si existe), `meta.md` (solo como contexto organizacional, nunca como requisito), solicitud humana explícita.

**Restricciones/prohibiciones**: no infiere requisitos faltantes ni completa información ausente; no modifica el alcance sin autorización explícita; no incluye tickets o CR como requisitos (son organizacionales, no funcionales); no diseña arquitectura, no propone implementación, no genera tareas; usa español como idioma principal y lenguaje verificable, no ambiguo.

**Responsable de métrica**: Completitud de la Especificación e Índice de Ambigüedad (`rules/sdd-quality-metrics.md` §4.1, §5.1).

## BULMA — Plan Architect

**Cuándo actúa**: después de que `spec.md` está aprobado/activo; convierte la especificación canónica en plan técnico ejecutable (`/speckit.plan`).

**Qué produce**: `plan.md` — fases técnicas claras, componentes y responsabilidades, riesgos técnicos y mitigaciones, consideraciones de IA/costos/seguridad.

**Entradas permitidas**: `spec.md`, `constitution.md` (si existe), lineamientos técnicos explícitos.

**Restricciones/prohibiciones**: respeta estrictamente `spec.md`; no modifica requisitos funcionales ni redefine el producto; no introduce decisiones no justificadas; no crea nuevas funcionalidades; prioriza modularidad, trazabilidad y escalabilidad.

**Responsable de métrica**: Trazabilidad Canon→Implementación y Reutilización del Canon (junto con PICCOLO).

## VEGETA — Canon Reviewer

**Cuándo actúa**: de forma transversal, en cada transición relevante entre fases — valida coherencia entre constitución, spec, plan y artefactos derivados antes de avanzar.

**Qué produce**: reporte de validación — lista de conflictos detectados, riesgos por inferencia o ambigüedad. **No corrige contenido automáticamente**, solo reporta.

**Entradas permitidas**: `constitution.md`, `spec.md`, `plan.md`, `artifacts/`.

**Restricciones/prohibiciones**: no modifica archivos; no propone cambios no solicitados; prioriza estabilidad del canon sobre velocidad.

**Responsable de métrica**: Estabilidad del Canon, Índice de Ambigüedad, Inferencias Detectadas, Determinismo de Ejecución — VEGETA es, en la práctica, el agente con más responsabilidades de calidad en `sdd-quality-metrics.md` (§4.2, §5.1, §5.2, §7.1).

## KRILIN — Task Generator

**Cuándo actúa**: cuando `plan.md` está aprobado (`/speckit.tasks`); transforma el plan en tareas listas para ejecución.

**Qué produce**: lista de tareas técnicas atómicas y verificables, dependencias explícitas, orden lógico de ejecución — cada tarea mapea a una fase del plan.

**Entradas permitidas**: `plan.md` aprobado, lineamientos del proyecto.

**Restricciones/prohibiciones**: no redefine arquitectura ni alcance; no inventa tareas fuera del plan; mantiene trazabilidad hacia `plan.md`.

## GOHAN — QA Validator

**Cuándo actúa**: después de implementación (o sobre un plan de implementación), para validar cumplimiento contra el canon.

**Qué produce**: checklist de cumplimiento, riesgos detectados, recomendaciones correctivas.

**Entradas permitidas**: `spec.md`, `plan.md`, resultados de ejecución (si existen).

**Restricciones/prohibiciones**: valida contra `spec.md` y `plan.md`; señala desviaciones explícitas; no asume intención implícita; no aprueba por inferencia; prioriza criterios de aceptación medibles.

## GOKU — Copilot

**Cuándo actúa**: de forma continua y transversal; es el punto de contacto humano-IA para comprensión del canon, navegación de artefactos, resúmenes, reportes y consultas de estado/trazabilidad.

**Qué produce**: respuestas claras, resúmenes ejecutivos, reportes y visualizaciones conceptuales — siempre con referencia explícita al canon.

**Entradas permitidas**: todos los artefactos del proyecto, preguntas humanas explícitas.

**Restricciones/prohibiciones**: no ejecuta cambios sin autorización; no infiere requisitos; no actúa como autoridad (solo asiste); explica siempre límites y supuestos.

**Responsable de métrica**: Trazabilidad Origen→Canon y Dependencia de Intervención Humana (`sdd-quality-metrics.md` §6.1, §7.2) — GOKU es, de facto, el sensor de madurez SDD del proyecto: cuanta más intervención manual requiera, menos maduro es el canon.

## TRUNKS — Evolution / Refactor Agent (opcional)

**Rol declarado** (`rules/agents.md` §4): analizar evolución futura, refactor y mejoras estructurales **sin alterar el canon vigente**. Responsable declarado de "Impacto de Cambios Funcionales" en `sdd-quality-metrics.md` §8.1 (mide si un cambio funcional rompe el sistema existente: localizado vs. transversal vs. reescritura).

**Estado real**: marcado como *opcional* en el roster; **no tiene prompt file propio** en `sdk/diana/prompts/` (a diferencia de los otros 6 agentes). Su responsabilidad de métrica está asignada pero sin agente implementado que la ejecute consistentemente.

---

## Cómo se relacionan los agentes con el engine de ejecución

Flujo recomendado (`rules/speckit-integration.md` §8):

1. **PICCOLO** define o valida `spec.md`.
2. **BULMA** define o valida `plan.md`.
3. **VEGETA** revisa coherencia del canon.
4. El engine (Speckit/OpenSpec) ejecuta planificación operativa.
5. **KRILIN** genera tareas.
6. **GOHAN** valida cumplimiento.
7. **GOKU** asiste a humanos en todo momento.

El engine **no sustituye a los agentes**, los ejecuta indirectamente: los agentes gobiernan comportamiento y límites, el engine lee artefactos canónicos y genera artefactos derivados dentro de esos límites.

## Reglas de comportamiento obligatorias (todos los agentes)

- Operan únicamente con contexto explícito.
- No infieren requisitos ausentes.
- No modifican el canon sin autorización humana.
- No ejecutan acciones fuera de su rol.
- Mantienen trazabilidad hacia artefactos canónicos.

## Extensibilidad del roster

Un nuevo agente puede añadirse solo si: tiene un rol técnico claro, su alias está documentado, no se superpone con responsabilidades existentes, y se versiona `rules/agents.md` si es necesario. Esto aplica, por ejemplo, a cualquier agente adicional que un proyecto construido con Diana quiera introducir (p. ej. un "Security Reviewer" o "Localization Agent") — debe declararse con la misma estructura de identidad, nunca como un alias suelto sin rol técnico.

## Comparación con rosters de agentes de frameworks pares

| Diana | Rol equivalente en BMAD-METHOD | Rol equivalente en Spec Kit | Rol equivalente en Kiro |
|-------|----------------------------------|------------------------------|--------------------------|
| PICCOLO (Spec Writer) | Analyst + PM (Product Brief, PRD) | Agente único ejecutando `/speckit.specify` | Agente único generando `requirements.md` (formato EARS) |
| BULMA (Plan Architect) | Architect (architecture doc, ADRs, epics/stories) | Agente único ejecutando `/speckit.plan` | Agente único generando `design.md` |
| VEGETA (Canon Reviewer) | Architect (Definition of Ready) + revisión cruzada | Sin agente dedicado; validación vía constitution como prompt fragment | Gate de aprobación humana entre artefactos (no es un agente) |
| KRILIN (Task Generator) | Scrum Master (hyper-detailed stories) | Agente único ejecutando `/speckit.tasks` | Generación de `tasks.md` dentro del mismo flujo |
| GOHAN (QA Validator) | QA ("Test Architect & Quality Advisor") | Sin agente dedicado nativo (ver `/speckit.reconcile`, 2026) | Sin agente dedicado; tests generados por tarea |
| GOKU (Copilot) | Orchestrator/Master agent | El propio asistente (Copilot/Claude Code/Cursor) actuando en todas las fases | El asistente de Kiro en modo chat |
| TRUNKS (Evolution) | Sin equivalente directo documentado | Sin equivalente directo | Sin equivalente directo |

La diferencia estructural clave: BMAD, Spec Kit y Kiro tienden a **un agente genérico que cambia de sombrero por fase** (o personas que viven solo en la fase de planeación como BMAD), mientras Diana declara una **identidad persistente por rol con prohibiciones explícitas por agente**, lo cual facilita auditoría (sabes exactamente qué agente debía detener una ejecución ambigua) pero exige mantener 7 prompt files sincronizados en vez de uno solo.

## Gaps abiertos

- **TRUNKS no tiene prompt file.** Es el único agente "opcional" del roster sin implementación; su métrica de calidad asignada (`sdd-quality-metrics.md` §8.1) queda sin dueño operativo claro. Recomendado: decidir si se implementa `prompts/agent-evolution.md` o si se reasigna esa métrica a BULMA/VEGETA explícitamente.
- No hay un agente Diana dedicado a reconciliación spec↔código (equivalente a lo que Spec Kit cubre con `/speckit.reconcile` o OpenSpec con `/opsx:sync`); hoy esa responsabilidad recae implícitamente en GOHAN sin un artefacto de salida estandarizado para drift.
