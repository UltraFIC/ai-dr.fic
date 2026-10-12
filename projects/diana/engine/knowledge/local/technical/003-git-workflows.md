# Git Workflows — Diana SDK Knowledge

> **ID**: SDK-TECH-003
> **Scope**: SDK
> **Estado**: 🟢 Completo

## TL;DR

Flujos de trabajo git para el desarrollo del SDK Diana y para proyectos que usan Diana, con convenciones de commits, branching y releases.

## Conceptos Clave

- **Branch por iniciativa**: `NNN-alias-descripcion` para cada cambio
- **Commits convencionales**: `tipo(scope): descripción` con referencia a IDs canónicos
- **Tags semver**: `vMAJOR.MINOR.PATCH` sincronizados con CHANGELOG.md
- **GitHub Actions**: CI/CD para tests, linting y publicación

## Convención de Commits

```
feat(diana.new): agregar validación de alias duplicado
fix(diana.sync): corregir mapeo de IDs en dry-run
docs(skills): actualizar 012-SDK-SKILLS-FRAMEWORK
refactor(cli): separar lógica de entrada/salida
```

## Flujo de Release

1. `CHANGELOG.md` se actualiza en cada PR
2. Al hacer release, se crea tag `vX.Y.Z`
3. GitHub Action publica a PyPI automáticamente
4. El changelog se genera desde commits convencionales
