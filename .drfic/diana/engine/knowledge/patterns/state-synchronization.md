# State Synchronization Patterns — Diana SDK Knowledge

> **ID**: SDK-P-006
> **Scope**: SDK
> **Estado**: 🟢 Completo

## TL;DR

Patrones para sincronización de estado entre artefactos operativos (Speckit) y artefactos canónicos (Diana), preservando la autoridad de IDs canónicos.

## Conceptos Clave

- **Backlog canónico**: el que vive en Diana (`001-inv-tasks.md` o `teams/TEAM-XX/tasks.md`)
- **Backlog operativo**: el que genera Speckit (`specs/*/tasks.md`)
- **Mapeo explícito**: relación Speckit Txxx → Diana Tyyy documentada en `teams/TEAM-XX/tasks.md`
- **Dry-run**: modo simulación que reporta cambios sin aplicarlos
- **Apply**: modo que escribe cambios en artefactos Diana

## Flujo de Sincronización

1. Speckit completa tareas en `specs/*/tasks.md`
2. `/diana.sync action="tasks" mode="dry-run"` calcula diferencias
3. Revisar conflictos de mapeo y unmapped
4. `/diana.sync action="tasks" mode="apply"` actualiza Diana
5. Orden: slices por equipo → agregación global

## Políticas de Extensión

- `mirror-team`: tareas Speckit sin mapeo se reportan pero no bloquean
- `conflict-on-unmapped`: tareas sin mapeo generan conflicto bloqueante

## Regla de Cierre Global

El backlog global solo cierra tareas por IDs canónicos existentes. No se crean IDs nuevos durante sync.
