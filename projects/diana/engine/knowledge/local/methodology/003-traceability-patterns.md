# Traceability Patterns — Diana SDK Knowledge

> **ID**: SDK-M-003
> **Scope**: SDK
> **Estado**: 🟢 Completo

## TL;DR

La trazabilidad es el eje vertebrador del SDD: cada artefacto debe poder rastrearse bidireccionalmente hasta su fuente de origen y hacia sus derivados.

## Conceptos Clave

- **Trazabilidad hacia adelante**: de fuente (UCC) → constitución → spec → plan → tasks
- **Trazabilidad hacia atrás**: de tasks → plan → spec → constitución → UCC
- **IDs estables**: los IDs canónicos (T001, RF-001, etc.) no cambian entre ciclos
- **Matriz de trazabilidad**: documento que mapea relaciones entre artefactos

## Patrón de IDs

| Artefacto | Formato ID | Ejemplo |
|-----------|-----------|---------|
| UCC | NNN-alias-ucc | 001-inv-ucc |
| Ticket | NNN-alias-tkt | 001-inv-tkt |
| Requisito Funcional | RF-NNN | RF-001 |
| Requisito No Funcional | RNF-NNN | RNF-001 |
| Tarea Canónica | TNNN | T001 |
| Fase de Plan | F-NNN | F-001 |

## Integración con el SDK

Cada acción Diana que genera artefactos debe incluir una sección de trazabilidad explícita en su salida, referenciando los IDs de origen.
