# Radar Management — Diana SDK Knowledge

> **ID**: SDK-GOV-003
> **Scope**: SDK
> **Estado**: 🟢 Completo

## TL;DR

El radar de proyectos (`projects-knowledge-radar.yaml`) es el registro maestro de todos los proyectos Diana activos, sus alias, y el estado de su conocimiento y skills.

## Conceptos Clave

- **Radar**: archivo YAML en `.drfic/diana/projects/registry/indexes/projects-knowledge-radar.yaml` que lista todos los proyectos.
- **Sin alias**: el modelo actual no usa prefijo forzado (`diana-<project>`) ni alias de 3 letras — el nombre de carpeta del proyecto es la única identidad.
- **Sin knowledge por proyecto**: el conocimiento profundo vive en `.drfic/knowledge/` (plano, compartido entre todos los proyectos), no bajo cada proyecto — por eso el radar apunta a ese árbol compartido vía `knowledge_root`, no a un índice por proyecto.
- **Estado**: cada proyecto tiene indicadores de completitud de skills (manifest/matrices en `capabilities/`).

## Estructura del Radar

```yaml
projects:
  - id: inversions
    enabled: true
    knowledge_root: .drfic/knowledge/
    skills_manifest: .drfic/diana/projects/inversions/capabilities/manifest.yaml
    agent_skill_matrix: .drfic/diana/projects/inversions/capabilities/agent-skill-matrix.yaml
    sdd_engine_matrix: .drfic/diana/projects/inversions/capabilities/sdd-engine-matrix.yaml
```

## Reglas de Mantenimiento

1. Todo proyecto nuevo debe registrarse en el radar (`/diana.new`).
2. Al deshabilitar un proyecto (`enabled: false`), no se elimina del radar — se marca `archived: true` con una razón si aplica.
3. El radar es la fuente primaria para listar proyectos activos en todas las acciones Diana.
