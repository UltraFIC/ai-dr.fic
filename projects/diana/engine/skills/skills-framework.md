# Skills Framework Design

## Objetivo

Dotar al agente `diana.skills` de patrones profesionales para diseñar, mantener y gobernar skills canónicas, matrices agente-skill y mapeo a engines SDD.

## Criterios de exito

- Skills-manifest completo con trazabilidad a fuentes canónicas.
- Agent-skill-matrix con primary/secondary skills por agente.
- SDD-engine-matrix con required_skills por etapa/engine.
- Skill docs modulares con knowledge_docs enlazados.
- Reuso cross-proyecto validado escaneando `engine/skills/` directamente (sin manifest paralelo).

## Fallback

Si falta esta skill, generar skills-manifest mínimo sin matrices de engine. Reportar gap 'skills-framework'.

## Conocimiento Relacionado

Criticidad: mandatory

- `knowledge/domains/knowledge-management.md`
- `knowledge/agent-design/agent-capabilities-matrix.md`
