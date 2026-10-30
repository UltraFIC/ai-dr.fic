# Architecture & Technical Planning

## Objetivo

Dotar al agente `diana.plan` de patrones profesionales para diseño arquitectónico, planificación técnica y validación de consistencia contra constitución y specs.

## Criterios de exito

- Plan técnico con arquitectura, fases, riesgos y criterios de validación.
- Trazabilidad bidireccional fases ↔ requisitos de spec.
- Cobertura de seguridad, resiliencia, observabilidad y cumplimiento.
- Skills + knowledge cargados como contexto obligatorio.
- Plan listo para consumo por speckit.plan.

## Fallback

Si falta esta skill, generar plan sin validación de seguridad/observabilidad. Reportar gap 'architecture-planning'.

## Conocimiento Relacionado

Criticidad: mandatory

- `knowledge/domains/architecture-planning.md`
- `knowledge/domains/risk-management.md`
