# 012-SDK-SKILLS-FRAMEWORK — Skills Framework Design

## Objetivo

Dotar al agente `diana.skills` de patrones profesionales para diseñar, mantener y gobernar skills canónicas, matrices agente-skill y mapeo a engines SDD.

## Knowledge docs

- local/domains/004-knowledge-management.md
- local/agents/002-agent-capabilities-matrix.md
- local/glossaries/001-diana-terms.md

## Criterios de exito

- Skills-manifest completo con trazabilidad a fuentes canónicas.
- Agent-skill-matrix con primary/secondary skills por agente.
- SDD-engine-matrix con required_skills por etapa/engine.
- Skill docs modulares con knowledge_docs enlazados.
- Reuso cross-proyecto validado contra shared-skills-manifest.

## Fallback

Si falta esta skill, generar skills-manifest mínimo sin matrices de engine. Reportar gap 012-SDK-SKILLS-FRAMEWORK.
