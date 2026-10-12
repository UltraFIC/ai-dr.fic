# Requirements Engineering — Diana SDK Knowledge

> **ID**: SDK-DOM-001
> **Scope**: SDK
> **Estado**: 🟢 Completo

## TL;DR

Prácticas profesionales de ingeniería de requisitos adaptadas al ciclo SDD: elicitación, análisis, especificación y validación de requisitos funcionales y no funcionales.

## Conceptos Clave

- **RF (Requisito Funcional)**: comportamiento específico que el sistema debe ejecutar
- **RNF (Requisito No Funcional)**: atributos de calidad del sistema (rendimiento, seguridad, escalabilidad)
- **Criterios de aceptación**: condiciones medibles que validan el cumplimiento del requisito
- **Trazabilidad**: cada requisito se vincula a su fuente (UCC, constitución)

## Estructura de un Requisito

```
RF-NNN: [Título descriptivo]
  Descripción: [Qué debe hacer el sistema]
  Criterios de aceptación:
    - [Condición 1]
    - [Condición 2]
  Prioridad: [Alta/Media/Baja]
  Fuente: [UCC NNN o Constitución sección X]
```

## Técnicas de Elicitación

1. Análisis de documentos fuente (UCC, tickets)
2. Derivación de principios constitucionales
3. Restricciones implícitas del dominio
4. Supuestos explicitados con riesgo asociado

## Validación de Spec

- Completitud: todo RF/RNF tiene criterios de aceptación
- Consistencia: no hay requisitos contradictorios
- Trazabilidad: cada requisito tiene fuente identificada
- Ambición: requisitos son medibles y verificables
