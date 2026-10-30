# Quality Gates SDD — Diana SDK Knowledge

> **ID**: SDK-M-002
> **Scope**: SDK
> **Estado**: 🟢 Completo

## TL;DR

Los quality gates son puntos de control obligatorios antes de cada etapa crítica del ciclo SDD. Garantizan que los artefactos canónicos cumplen criterios mínimos antes de avanzar.

## Conceptos Clave

- **Gate de entrada**: validación pre-ejecución (artefactos fuente completos)
- **Gate de salida**: validación post-ejecución (artefacto generado cumple calidad)
- **Checklist obligatorio**: lista de verificación por gate, documentada en `checklists/`
- **Veto por gap**: si un gate detecta gaps críticos, la etapa no puede continuar

## Gates del Ciclo SDD

1. **Gate de Plan** (antes de `/diana.plan`):
   - Constitución existe y está vigente
   - Spec canónica completa con RF/RNF
   - Skills manifiesto actualizado
   - Knowledge docs cargados

2. **Gate de Tasks** (antes de `/diana.tasks`):
   - Plan técnico validado contra spec
   - Trazabilidad fases → requisitos
   - Dependencias explicitadas

3. **Gate de Implement** (antes de `/speckit.implement`):
   - Backlog canónico completo
   - Asignación por equipo resuelta
   - Sync mode definido

## Integración con el SDK

Los checklists físicos están en `checklists/`. Cada acción Diana debe cargar el checklist correspondiente antes de ejecutar.

## Referencias

- `checklists/sdd-quality-gate.md`
- `checklists/plan-quality-checklist.md`
- `checklists/tasks-quality-checklist.md`
