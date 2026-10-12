# 013-SDK-KNOWLEDGE-MGMT — Knowledge Management Systems

## Objetivo

Dotar al agente `diana.knowledge` de patrones profesionales para investigación profunda, estructuración de conocimiento y mantenimiento de índices.

## Knowledge docs

- local/domains/004-knowledge-management.md
- local/methodology/001-sdd-lifecycle.md
- local/agents/002-agent-capabilities-matrix.md
- remote/sources.md

## Criterios de exito

- Documentos de conocimiento completos y bien estructurados.
- Barrido canónico antes de toda generación (Fase 0).
- Skills-first: verificar skills-manifest antes de knowledge.
- Índices sincronizados sin duplicados.
- Fuentes remotas registradas con snapshots cuando aplique.
- Cobertura de temas obligatorios del proyecto.

## Fallback

Si falta esta skill, generar conocimiento sin barrido canónico previo. Reportar gap 013-SDK-KNOWLEDGE-MGMT.
