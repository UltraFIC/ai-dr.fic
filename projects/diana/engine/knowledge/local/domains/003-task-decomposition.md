# Task Decomposition — Diana SDK Knowledge

> **ID**: SDK-DOM-003
> **Scope**: SDK
> **Estado**: 🟢 Completo

## TL;DR

Patrones profesionales para descomponer planes técnicos en tareas ejecutables, con trazabilidad, dependencias y asignación por equipo.

## Conceptos Clave

- **Descomposición funcional**: dividir por funcionalidad (historias de usuario)
- **Descomposición técnica**: dividir por capa técnica (frontend, API, datos)
- **Descomposición por fase**: dividir siguiendo las fases del plan
- **ID canónico**: TNNN único y estable para cada tarea
- **Dependencia**: relación entre tareas (bloqueante, secuencial, paralela)

## Estructura de Tarea Canónica

```
T-NNN: [Título]
  Descripción: [Qué hay que hacer]
  Fase: [F-NNN]
  Requisitos: [RF-NNN, RNF-NNN]
  Dependencias: [T-NNN, T-NNN]
  Criterios de aceptación:
    - [Condición]
  Estado: [ ] pendiente / [x] completado
```

## Reglas de Descomposición

1. Toda tarea se traza a al menos un requisito de spec
2. Toda tarea se traza a una fase del plan
3. Dependencias explicitadas antes de comenzar
4. IDs estables entre ciclos de regeneración
5. Topología considerada: global vs por equipo
