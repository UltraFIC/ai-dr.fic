# Índice por Agente — Diana SDK Knowledge

> Mapa de qué documentos de conocimiento y skills son más relevantes para cada agente Diana.

## Agentes Narrativos Internos (SDK)

| Agente | Alias | Documentos Clave | Skills Clave |
|--------|-------|-----------------|--------------|
| PICCOLO | Spec Writer | SDK-M-001, SDK-DOM-001, SDK-G-001 | 014-SDK-REQUIREMENTS-ENG, 022-SDK-TRACEABILITY |
| BULMA | Plan Architect | SDK-M-001, SDK-M-002, SDK-A-001, SDK-P-001, SDK-DOM-002 | 015-SDK-ARCHITECTURE-PLANNING, 021-SDK-OBSERVABILITY |
| VEGETA | Canon Reviewer | SDK-G-001, SDK-M-001, SDK-M-003, SDK-GOV-001 | 022-SDK-TRACEABILITY, 011-SDK-CONSTITUTION |
| KRILIN | Task Generator | SDK-A-001, SDK-P-002, SDK-DOM-003 | 016-SDK-TASK-DECOMPOSITION, 022-SDK-TRACEABILITY |
| GOHAN | QA Validator | SDK-M-001, SDK-M-002, SDK-G-001, SDK-DOM-005 | 006-SDK-TEST-QA, 020-SDK-SECURITY-BASELINE |
| GOKU | Copilot | todos | 019-SDK-HELP-AUTHORING, 013-SDK-KNOWLEDGE-MGMT |
| TRUNKS | Evolution | SDK-M-001, SDK-A-001, SDK-M-003 | 022-SDK-TRACEABILITY |

## Acciones Diana (Prompts/Agents)

| Acción | Agente Asociado | Skills Primarias | Conocimiento Local Clave |
|--------|----------------|-----------------|-------------------------|
| diana.new | GOKU | 007-SDK-PROJECT-BOOTSTRAP | SDK-P-004, SDK-GOV-003 |
| diana.change | VEGETA | 008-SDK-CHANGE-MGMT | SDK-P-003, SDK-DOM-006 |
| diana.ticket | VEGETA | 009-SDK-TICKET-MGMT | SDK-GOV-002, SDK-P-003 |
| diana.integrate | BULMA | 010-SDK-INTEGRATION | SDK-P-001, SDK-P-005 |
| diana.constitution | BULMA + VEGETA | 011-SDK-CONSTITUTION | SDK-GOV-001, SDK-M-001 |
| diana.skills | GOHAN | 012-SDK-SKILLS-FRAMEWORK | SDK-A-002, SDK-DOM-004 |
| diana.knowledge | GOKU | 013-SDK-KNOWLEDGE-MGMT | SDK-DOM-004, SDK-A-002 |
| diana.specify | PICCOLO | 014-SDK-REQUIREMENTS-ENG | SDK-DOM-001, SDK-GOV-001 |
| diana.plan | BULMA | 015-SDK-ARCHITECTURE-PLANNING | SDK-DOM-002, SDK-TECH-004, SDK-TECH-005 |
| diana.tasks | KRILIN | 016-SDK-TASK-DECOMPOSITION | SDK-DOM-003, SDK-P-002 |
| diana.teams | BULMA + VEGETA | 017-SDK-TEAM-TOPOLOGY | SDK-P-002, SDK-DOM-007 |
| diana.sync | GOHAN | 018-SDK-STATE-RECONCILIATION | SDK-P-006, SDK-M-002 |
| diana.help | GOKU | 019-SDK-HELP-AUTHORING | SDK-DOM-008, SDK-G-001 |

## Skills Transversales (Aplican a todas las acciones)

| Skill | Propósito |
|-------|-----------|
| 001-SDK-SDDCORE | Metodología base SDD |
| 020-SDK-SECURITY-BASELINE | Criterios mínimos de seguridad |
| 022-SDK-TRACEABILITY | Trazabilidad entre artefactos canónicos |
| 006-SDK-TEST-QA | Validación y aseguramiento de calidad |
