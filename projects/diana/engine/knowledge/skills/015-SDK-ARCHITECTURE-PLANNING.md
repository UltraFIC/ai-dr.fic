# 015-SDK-ARCHITECTURE-PLANNING — Architecture & Technical Planning

## Objetivo

Dotar al agente `diana.plan` de patrones profesionales para diseño arquitectónico, planificación técnica y validación de consistencia contra constitución y specs.

## Knowledge docs

- local/domains/002-architecture-planning.md
- local/domains/006-risk-management.md
- local/methodology/001-sdd-lifecycle.md
- local/methodology/002-sdd-quality-gates-deep.md

## Criterios de exito

- Plan técnico con arquitectura, fases, riesgos y criterios de validación.
- Trazabilidad bidireccional fases ↔ requisitos de spec.
- Cobertura de seguridad, resiliencia, observabilidad y cumplimiento.
- Skills + knowledge cargados como contexto obligatorio.
- Plan listo para consumo por speckit.plan.

## Fallback

Si falta esta skill, generar plan sin validación de seguridad/observabilidad. Reportar gap 015-SDK-ARCHITECTURE-PLANNING.
