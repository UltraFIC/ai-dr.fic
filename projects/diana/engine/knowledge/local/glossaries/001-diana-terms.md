# Glosario Diana/SDD/Speckit — Diana SDK Knowledge

> **ID**: SDK-G-001
> **Generado**: 2026-10-11 | **Estado**: 🟢 Completo
> **Scope**: SDK-level
> **Fuentes internas**: `sdk/diana/rules/*.md`, `sdk/diana/templates/*.md`, `sdk/diana/prompts/agent-*.md`

---

## Cómo usar este glosario

Es la fuente canónica de términos para todos los proyectos gobernados por Diana. Si un documento de cualquier capa (SDK, cross-project, proyecto) usa un sinónimo listado en la columna "Sinónimos Evitados", debe corregirse para usar el término canónico.

---

## Términos Canónicos — Núcleo Diana

| Término | Definición Canónica | Sinónimos Evitados |
|---------|--------------------|--------------------|
| **SDD** | Software/Spec-Driven Development — metodología de desarrollo gobernada por Diana, donde el canon (spec+plan) precede y gobierna la generación de código. | — |
| **Diana** | Motor SDD desarrollado por DRFIC; gobierna el ciclo de vida completo de artefactos y agentes, independientemente del engine de ejecución elegido. | — |
| **Speckit** | Motor de ejecución operativo bajo Diana; implementa las fases specify→implement. Uno de varios `motor_sdd` posibles (ver `integration-profile.md`). | — |
| **Engine (SDD)** | Cualquier motor de ejecución operativo (Speckit, OpenSpec, u otro) que Diana puede gobernar vía un perfil de integración. | "framework de ejecución" |
| **Canon** | Fuente de verdad autorizada de una iniciativa (constitución + spec activa + plan activo). No puede ser contradicha por documentos operativos ni derivados. | — |
| **Canon Funcional** | El "qué" del sistema: autoridad = `spec.md`. | — |
| **Canon Técnico** | El "cómo" del sistema: autoridad = `plan.md`, subordinado al canon funcional. | — |
| **Constitution / Constitución** | Documento rector del proyecto (`<PROYECTO>-CONSTITUTION`) que define autoridad, filosofía y principios no negociables. Nace solo en greenfield o por decisión explícita de alto nivel; casi inmutable. | "arquitectura doc" |
| **Spec** | Especificación funcional de una iniciativa (`spec.md`, ID `<NNN>-<PROYECTO>-SPEC`). Define comportamiento esperado, requisitos, fuera de alcance, criterios de aceptación medibles. | "requerimientos", "PRD" |
| **Plan** | Documento de diseño técnico y arquitectura (`plan.md`, ID `<NNN>-<PROYECTO>-PLAN`) que implementa una spec sin redefinir su alcance. | "arquitectura doc" |
| **Tasks** | Descomposición atómica y verificable del plan (`tasks/`, ID `<NNN>-<PROYECTO>-TASK`). No crea funcionalidad nueva. | — |
| **Initiative / Iniciativa** | Unidad de trabajo que agrupa meta.md + canon (constitución si aplica + spec + plan + tasks) de un cambio concreto dentro de un proyecto. | "feature", "épica" |
| **Meta.md** | Archivo de trazabilidad organizacional de una iniciativa (origen: CC/ticket, tipo declarado). Informativo, nunca ejecutable; el engine nunca lo interpreta. | — |
| **Change Request / Control de Cambios (CC)** | Evento de origen organizacional (`<NNN>-<PROYECTO>-CC`) que describe un problema o necesidad de negocio, nunca la solución técnica. Speckit no lo lee. | — |
| **Ticket (TKT)** | Evento de origen organizacional (`<NNN>-<PROYECTO>-TKT`) que declara objetivo y alcance de usuario; puede referenciar un CC. No define canon ni arquitectura. | — |
| **Greenfield** | Tipo de iniciativa: proyecto nuevo, sin sistema previo ni canon funcional. Nace constitución + SPEC-001 + plan inicial. | — |
| **Brownfield** | Tipo de iniciativa: evolución o mejora funcional de un sistema existente. Nace spec derivada + plan; NO nace nueva constitución. | — |
| **Bugfix** | Tipo de iniciativa: corrección de errores sin cambio de comportamiento esperado. Nace plan correctivo + tasks; NO nace spec ni constitución. | — |
| **Quality Gate (SDD)** | Punto de control obligatorio antes de avanzar de fase (antes de plan, antes de tasks, antes de implementar, después de cambios funcionales), evaluado contra las 5 dimensiones de `rules/sdd-quality-metrics.md`. | — |
| **Determinismo de Ejecución** | Métrica de calidad IA: si distintas ejecuciones/agentes producen resultados consistentes sobre el mismo canon. | — |
| **Índice de Ambigüedad** | Métrica de calidad: cuántas decisiones del canon quedan abiertas a interpretación (lenguaje vago, reglas no medibles). | — |
| **Integration Profile / Perfil de Integración** | Artefacto (`integration-profile.md`) que declara, por iniciativa, el `motor_sdd` elegido, modo de orquestación, topología de desarrollo y política de autoridad. | — |
| **Engine Handoff** | Artefacto (`engine-handoff.md`) que define exactamente qué debe consumir un engine concreto, en qué orden y con qué límites, sin reinterpretar el canon Diana. | — |
| **Motor SDD (`motor_sdd`)** | Campo del perfil de integración con valores `diana_only`, `speckit`, `openspec`, `hybrid` — determina si Diana opera sola, delega a un engine único, o combina varios. | — |

## Agentes Diana (ver detalle en `local/agents/001-agent-roles-deep.md`)

| Término | Definición Canónica |
|---------|---------------------|
| **PICCOLO** | Alias del agente Spec Writer — define/protege `spec.md`. |
| **BULMA** | Alias del agente Plan Architect — diseña `plan.md` que implementa la spec. |
| **VEGETA** | Alias del agente Canon Reviewer — revisa coherencia y rigor del canon; no corrige, solo reporta. |
| **KRILIN** | Alias del agente Task Generator — descompone el plan en tareas ejecutables. |
| **GOHAN** | Alias del agente QA Validator — valida cumplimiento contra spec y plan. |
| **GOKU** | Alias del agente Copilot — asiste a humanos en comprensión, navegación y resumen del canon; no decide. |
| **TRUNKS** | Alias del agente Evolution/Refactor (opcional) — analiza evolución futura y refactor sin alterar el canon vigente. Sin prompt file implementado aún (gap). |
| **Alias narrativo** | Identidad tipo Dragon Ball de un agente Diana; comunica, nunca sustituye el rol técnico ni altera responsabilidades SDD. |

## Términos de frameworks pares (para operación híbrida/interoperable)

Diana debe poder razonar sobre estos términos cuando opera en modo híbrido (`motor_sdd: hybrid`) o cuando un humano migra artefactos entre frameworks. Se listan junto a su equivalente conceptual Diana más cercano.

| Término externo | Framework de origen | Definición | Equivalente conceptual en Diana |
|------------------|----------------------|------------|-----------------------------------|
| **Delta Spec** | OpenSpec | Documento interino que marca cambios como ADDED/MODIFIED/REMOVED sobre la spec primaria, sin reescribirla completa. | Sin equivalente exacto; lo más cercano es una nueva versión de `spec.md` en una nueva iniciativa (Diana no versiona in-place). |
| **Propose / Apply / Sync / Archive** | OpenSpec | Ciclo operativo: proponer cambio, ejecutarlo, sincronizar con el código, archivar en la spec primaria. | specify≈propose, plan≈design, tasks≈tasks, implement≈apply, cierre de iniciativa≈archive. |
| **EARS** (Easy Approach to Requirements Syntax) | AWS Kiro | Sintaxis de requisitos tipo "WHEN \<evento\> THE SYSTEM SHALL \<comportamiento\>". | No es obligatoria en Diana, pero es compatible como estilo de redacción de criterios de aceptación en `spec.md`. |
| **Steering files** (`product.md`, `tech.md`, `structure.md`) | AWS Kiro | Contexto de proyecto cargado automáticamente en cada interacción. | Parcialmente equivalente a `constitution.md`, pero Diana la trata como canon cargado por comando explícito, no como contexto ambiental automático. |
| **Constitution.md** (Spec Kit) | GitHub Spec Kit | Principios no negociables cargados como prompt fragment en cada comando. | Equivalente directo a `constitution.md` de Diana, con la diferencia de que en Diana es canon versionado con proceso de aprobación formal, no solo un fragmento de prompt. |
| **Converge / Reconcile** | GitHub Spec Kit (2026) | Validación post-implementación que compara código contra spec/plan/tasks y añade tareas correctivas si hay gaps. | Responsabilidad hoy asignada implícitamente a GOHAN, sin comando ni artefacto de salida formalizado (gap). |
| **ADR** (Architectural Decision Record) | Industria general / schema `spec-driven-with-adr` de OpenSpec / Spec Kit constitution | Registro persistente de contexto, opciones, decisión y consecuencias de una decisión técnica, independiente del ciclo de cambio. | No existe como artefacto propio en Diana hoy; candidato a vivir dentro de la iniciativa junto a `plan.md` (gap, ver patrones). |
| **PRD** (Product Requirements Document) | BMAD-METHOD | Documento de requisitos funcionales en formato Given/When/Then, producido por el agente PM. | Equivalente aproximado a `spec.md`, aunque Diana evita el término "PRD" como sinónimo explícitamente (ver tabla núcleo). |
| **Story (dev story)** | BMAD-METHOD | Archivo hiper-detallado que el Scrum Master agent prepara para el Dev agent, con contexto completo embebido. | Equivalente aproximado a una tarea individual dentro de `tasks/`, aunque Diana no embebe todo el contexto arquitectónico en cada tarea — remite a `plan.md`. |
| **Greenfield / Brownfield** (Flattener) | BMAD-METHOD | Mismos términos, misma distinción de workflows; BMAD añade un "Flattener tool" para onboarding de código existente. | Términos idénticos en Diana (`rules/lifecycle.md`); Diana no tiene hoy un "Flattener" equivalente. |
| **Vibe coding** | Industria general (contraste con SDD) | Desarrollo ad-hoc con IA sin spec previa, propenso a drift y alucinación de APIs. | Diana lo previene por diseño: ningún engine puede generar código fuera de una iniciativa con canon explícito. |

## Convenciones de identificación (IDs)

| Término | Formato | Ejemplo |
|---------|---------|---------|
| Control de Cambios | `<NNN>-<PROYECTO>-CC` | `001-DIANA-CC` |
| Ticket | `<NNN>-<PROYECTO>-TKT` | `014-INVERSIONES-TKT` |
| Constitución | `<PROYECTO>-CONSTITUTION` | `INVERSIONES-CONSTITUTION` |
| Especificación | `<NNN>-<PROYECTO>-SPEC` | `002-INVERSIONES-SPEC` |
| Plan | `<NNN>-<PROYECTO>-PLAN` | `001-INV-PLAN` |
| Tarea | `<NNN>-<PROYECTO>-TASK` | — |

Nota: `<NNN>` reinicia por proyecto, no es numeración global del repo; no debe confundirse con versionado semántico (SemVer) — Diana usa versionado secuencial por iniciativa (`SPEC-001`, `SPEC-002`...), donde el número indica orden histórico funcional, no compatibilidad binaria.

## Estados de artefactos

| Estado | Significado |
|--------|-------------|
| **Borrador** | En elaboración, no ejecutable. |
| **Activa** | Canónica y ejecutable; solo las specs Activas pueden ser ejecutadas por el engine. |
| **Deprecada** | Reemplazada por una versión posterior; se conserva, no se elimina ni modifica. |
| **Archivada** | Histórica, solo referencia. |

## Estados de knowledge (todas las capas)

| Estado | Significado |
|--------|-------------|
| 🟢 Completo | Documento con contenido sustancial generado y vigente. |
| 🟡 Esqueleto | Estructura lista, contenido pendiente de generación. |
| 🔴 Faltante | Documento referenciado pero no creado. |
