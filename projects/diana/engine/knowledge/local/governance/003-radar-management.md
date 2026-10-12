# Radar Management — Diana SDK Knowledge

> **ID**: SDK-GOV-003
> **Scope**: SDK
> **Estado**: 🟢 Completo

## TL;DR

El radar de proyectos (`projects-knowledge-radar.yaml`) es el registro maestro de todos los proyectos Diana activos, sus alias, y el estado de su conocimiento y skills.

## Conceptos Clave

- **Radar**: archivo YAML en `projects/knowledge/indexes/` que lista todos los proyectos
- **Alias persistido**: el alias resuelto en `diana.new` se guarda en el radar para reuso
- **Estado**: cada proyecto tiene indicadores de completitud de knowledge, skills y matrices

## Estructura del Radar

```yaml
projects:
  - id: diana-inversions
    alias: inv
    enabled: true
    knowledge_index: projects/diana-inversions/knowledge/indexes/master-index.md
    skills_manifest: projects/diana-inversions/knowledge/indexes/skills-manifest.yaml
    agent_skill_matrix: projects/diana-inversions/knowledge/indexes/agent-skill-matrix.yaml
    sdd_engine_matrix: projects/diana-inversions/knowledge/indexes/sdd-engine-matrix.yaml
```

## Reglas de Mantenimiento

1. Todo proyecto nuevo debe registrarse en el radar
2. El alias es inmutable una vez registrado (a menos que se forza)
3. Al deshabilitar un proyecto (`enabled: false`), no se elimina del radar
4. El radar es la fuente primaria para resolución de alias en todas las acciones Diana
