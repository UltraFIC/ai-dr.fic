# Change Management Patterns — Diana SDK Knowledge

> **ID**: SDK-P-003
> **Scope**: SDK
> **Estado**: 🟢 Completo

## TL;DR

Patrones profesionales de gestión de cambios adaptados al ciclo SDD, basados en ITIL y adaptados para trazabilidad canónica con Diana.

## Conceptos Clave

- **UCC (Unidad de Control de Cambios)**: documento que describe, justifica y autoriza un cambio
- **Ticket**: solicitud de servicio vinculada opcionalmente a un UCC
- **Ciclo de vida del cambio**: Draft → Review → Approved → Implemented → Closed
- **Numeración secuencial**: NNN incremental por proyecto, independiente entre proyectos

## Estructura de un UCC Profesional

1. **Cabecera**: ID, proyecto, fecha, autor, estado
2. **Título**: descriptivo y único
3. **Contexto**: problema u oportunidad que motiva el cambio
4. **Alcance**: qué incluye y qué NO incluye
5. **Impacto esperado**: funcional, técnico, operacional
6. **Riesgos**: identificados con mitigación propuesta
7. **Plan de implementación**: pasos de alto nivel
8. **Criterios de éxito**: cómo se valida el cambio
9. **Trazabilidad**: tickets, specs, o documentos relacionados

## Patrón de Vinculación UCC ↔ Ticket

- `standalone`: ticket sin UCC (incidencias, consultas)
- `linked`: ticket vinculado 1:1 con UCC (mismo NNN)
- `reuse`: múltiples tickets para un mismo UCC
