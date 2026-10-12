# Diana SDK Knowledge — Índice Maestro (SDK Level)

> **Para Speckit**: Lee este archivo al inicio de Phase 0 para enriquecer tu contexto con conocimiento profundo del motor Diana.
> Si un tema no está cubierto aquí, continúa con tu metodología de investigación normal.

**Versión**: 0.3.0  
**Última actualización**: 2026-10-11  
**Alcance**: SDK-level (cross-proyecto)

---

## Documentos Disponibles

### Metodología SDD

| ID | Archivo | Descripción | Relevante para |
|----|---------|-------------|---------------|
| SDK-M-001 | `local/methodology/001-sdd-lifecycle.md` | Ciclo completo SDD con Diana: eventos de origen, tipos de iniciativa, fases specify→implement, quality gates, modos standalone/híbrido y comparativa con OpenSpec/Spec Kit/Kiro/BMAD | specify, plan, tasks, implement |
| SDK-M-002 | `local/methodology/002-sdd-quality-gates-deep.md` | Quality gates profundos del ciclo SDD | plan, tasks, implement |
| SDK-M-003 | `local/methodology/003-traceability-patterns.md` | Patrones de trazabilidad entre artefactos canónicos | todas las acciones |

### Agentes Diana

| ID | Archivo | Descripción | Relevante para |
|----|---------|-------------|---------------|
| SDK-A-001 | `local/agents/001-agent-roles-deep.md` | Capacidades profundas de PICCOLO, BULMA, VEGETA, KRILIN, GOHAN, GOKU, TRUNKS: cuándo actúan, entradas/salidas, prohibiciones, y comparación con rosters de BMAD/Spec Kit/Kiro | plan, tasks |
| SDK-A-002 | `local/agents/002-agent-capabilities-matrix.md` | Matriz de capacidades: acciones → skills → agentes narrativos | todas las acciones |

### Patrones Genéricos

| ID | Archivo | Descripción | Relevante para |
|----|---------|-------------|---------------|
| SDK-P-001 | `local/patterns/001-speckit-integration-patterns.md` | Cómo integrar cualquier dominio con Speckit/OpenSpec, arquitectura de knowledge en 3 capas, patrón de prompts de agentes, y diseño standalone/híbrido vía `integration-profile.md` | plan |
| SDK-P-002 | `local/patterns/002-multi-team-coordination.md` | Patrones de coordinación multi-equipo SDD | teams, integrate |
| SDK-P-003 | `local/patterns/003-change-management-patterns.md` | Patrones profesionales de gestión de cambios | change, ticket |
| SDK-P-004 | `local/patterns/004-scaffolding-patterns.md` | Patrones de scaffolding y estructura base Diana | new |
| SDK-P-005 | `local/patterns/005-multi-engine-orchestration.md` | Orquestación multi-engine SDD (Speckit, OpenSpec, Generic-SDD) | integrate |
| SDK-P-006 | `local/patterns/006-state-synchronization.md` | Patrones de sincronización de estado entre Speckit y Diana | sync |

### Gobernanza

| ID | Archivo | Descripción | Relevante para |
|----|---------|-------------|---------------|
| SDK-GOV-001 | `local/governance/001-constitution-design-patterns.md` | Patrones de diseño de constituciones de proyecto | constitution |
| SDK-GOV-002 | `local/governance/002-ticket-workflows.md` | Flujos de trabajo de tickets de servicio | ticket |
| SDK-GOV-003 | `local/governance/003-radar-management.md` | Gestión del radar de proyectos y alias persistidos | new, todas |

### Técnico

| ID | Archivo | Descripción | Relevante para |
|----|---------|-------------|---------------|
| SDK-TECH-001 | `local/technical/001-cli-architecture-patterns.md` | Patrones de arquitectura CLI para SDK | core SDK |
| SDK-TECH-002 | `local/technical/002-python-packaging.md` | Empaquetado Python con hatchling | core SDK |
| SDK-TECH-003 | `local/technical/003-git-workflows.md` | Flujos git y GitHub para SDK | core SDK |
| SDK-TECH-004 | `local/technical/004-security-baseline.md` | Línea base de seguridad para proyectos SDD | specify, plan, tasks |
| SDK-TECH-005 | `local/technical/005-observability-patterns.md` | Patrones de observabilidad (logging, métricas, tracing) | specify, plan, tasks |

### Dominios de Ingeniería

| ID | Archivo | Descripción | Relevante para |
|----|---------|-------------|---------------|
| SDK-DOM-001 | `local/domains/001-requirements-engineering.md` | Ingeniería de requisitos funcionales y no funcionales | specify |
| SDK-DOM-002 | `local/domains/002-architecture-planning.md` | Planificación arquitectónica y técnica profesional | plan |
| SDK-DOM-003 | `local/domains/003-task-decomposition.md` | Descomposición de trabajo en tareas ejecutables | tasks |
| SDK-DOM-004 | `local/domains/004-knowledge-management.md` | Gestión de conocimiento y sistemas de índices | knowledge, skills |
| SDK-DOM-005 | `local/domains/005-testing-patterns.md` | Patrones de testing para SDK y proyectos | core SDK |
| SDK-DOM-006 | `local/domains/006-risk-management.md` | Gestión de riesgos técnicos y de proyecto | change, plan |
| SDK-DOM-007 | `local/domains/007-team-topology-patterns.md` | Patrones de topología de equipos (Conway's Law) | teams |
| SDK-DOM-008 | `local/domains/008-documentation-authoring.md` | Autoría de documentación técnica y de ayuda | help |

### Glosarios

| ID | Archivo | Descripción | Relevante para |
|----|---------|-------------|---------------|
| SDK-G-001 | `local/glossaries/001-diana-terms.md` | Glosario canónico Diana/SDD/Speckit, incluyendo equivalencias de términos con OpenSpec/Spec Kit/Kiro/BMAD para interoperabilidad | todos |

---

## Skills Compartidas del SDK

| ID | Archivo | Descripción | Relevante para |
|----|---------|-------------|---------------|
| SDK-SKILL-001 | `skills/001-SDK-SDDCORE.md` | SDD Core Methodology | todas las acciones |
| SDK-SKILL-002 | `skills/002-SDK-TSSTACK.md` | TypeScript React Node Stack | proyectos TS |
| SDK-SKILL-003 | `skills/003-SDK-PYTHON-PKG.md` | Python Package Development | core SDK |
| SDK-SKILL-004 | `skills/004-SDK-CLI-DESIGN.md` | CLI Design & Development | core SDK |
| SDK-SKILL-005 | `skills/005-SDK-GIT-WORKFLOW.md` | Git Workflows & GitHub | core SDK |
| SDK-SKILL-006 | `skills/006-SDK-TEST-QA.md` | Testing & QA | core SDK, todas |
| SDK-SKILL-007 | `skills/007-SDK-PROJECT-BOOTSTRAP.md` | Project Scaffolding & Bootstrap | diana.new |
| SDK-SKILL-008 | `skills/008-SDK-CHANGE-MGMT.md` | Change Management & Control | diana.change |
| SDK-SKILL-009 | `skills/009-SDK-TICKET-MGMT.md` | Ticket & Service Management | diana.ticket |
| SDK-SKILL-010 | `skills/010-SDK-INTEGRATION.md` | SDD Engine Integration | diana.integrate |
| SDK-SKILL-011 | `skills/011-SDK-CONSTITUTION.md` | Governance & Constitution Design | diana.constitution |
| SDK-SKILL-012 | `skills/012-SDK-SKILLS-FRAMEWORK.md` | Skills Framework Design | diana.skills |
| SDK-SKILL-013 | `skills/013-SDK-KNOWLEDGE-MGMT.md` | Knowledge Management Systems | diana.knowledge |
| SDK-SKILL-014 | `skills/014-SDK-REQUIREMENTS-ENG.md` | Requirements Engineering | diana.specify |
| SDK-SKILL-015 | `skills/015-SDK-ARCHITECTURE-PLANNING.md` | Architecture & Technical Planning | diana.plan |
| SDK-SKILL-016 | `skills/016-SDK-TASK-DECOMPOSITION.md` | Task Decomposition & Backlog | diana.tasks |
| SDK-SKILL-017 | `skills/017-SDK-TEAM-TOPOLOGY.md` | Team Topology & Coordination | diana.teams |
| SDK-SKILL-018 | `skills/018-SDK-STATE-RECONCILIATION.md` | State Reconciliation & Sync | diana.sync |
| SDK-SKILL-019 | `skills/019-SDK-HELP-AUTHORING.md` | Help Systems & Documentation | diana.help |
| SDK-SKILL-020 | `skills/020-SDK-SECURITY-BASELINE.md` | Security Baseline | specify, plan, tasks |
| SDK-SKILL-021 | `skills/021-SDK-OBSERVABILITY.md` | Observability Patterns | specify, plan, tasks |
| SDK-SKILL-022 | `skills/022-SDK-TRACEABILITY.md` | Traceability & Audit | todas las acciones |

---

## Fuentes Remotas Registradas

Ver `remote/sources.md` para el catálogo completo de fuentes externas (Speckit, ITIL, OWASP, C4, Team Topologies, etc.)

---

## Estado de Cobertura

| Área | Estado | Notas |
|------|--------|-------|
| Metodología SDD | 🟢 Completo | 3 documentos (lifecycle, quality gates, traceability). Lifecycle (001) generado 2026-10-11; gaps abiertos: falta comando de reconciliación spec↔código, TRUNKS sin prompt file |
| Agentes | 🟢 Completo | 2 documentos (roles deep, capabilities matrix). Roles deep (001) generado 2026-10-11; gap abierto: TRUNKS no tiene prompt file implementado en `prompts/` |
| Patrones genéricos | 🟢 Completo | 6 documentos (Speckit, multi-team, change, scaffolding, orchestration, sync). Speckit integration (001) generado 2026-10-11; gaps abiertos: hooks/extensiones no implementados, sin ADR explícito, sin guía de migración entre `motor_sdd` |
| Gobernanza | 🟢 Completo | 3 documentos (constitution, tickets, radar) |
| Técnico | 🟢 Completo | 5 documentos (CLI, packaging, git, security, observability) |
| Dominios ingeniería | 🟢 Completo | 8 documentos (requirements, architecture, tasks, knowledge, testing, risk, teams, docs) |
| Glosario SDK | 🟢 Completo | Generado 2026-10-11, incluye mapeo de términos con frameworks SDD pares |
| Skills SDK | 🟢 Completo | 22 skills (2 existentes + 20 nuevas) |
| Fuentes remotas | 🟢 Completo | Catálogo con 14+ fuentes registradas |

**Leyenda**: 🟢 Completo · 🟡 Esqueleto (estructura lista, contenido pendiente) · 🔴 Faltante

---

## Instrucciones de Consumo para Speckit

```
SI master-index.md tiene documentos relevantes para la feature activa:
  → Leer y usar como contexto de alto nivel
SI hay gaps (áreas no cubiertas):
  → Proceder con investigación propia (metodología normal de Phase 0)
  → NO bloquear el plan por falta de conocimiento local
```
