# Architecture Planning — Diana SDK Knowledge

> **ID**: SDK-DOM-002
> **Scope**: SDK
> **Estado**: 🟢 Completo

## TL;DR

Prácticas profesionales de planificación arquitectónica y técnica para el ciclo SDD: diseño de sistemas, descomposición en fases y validación de cobertura.

## Conceptos Clave

- **Arquitectura**: estructura de componentes, sus relaciones y principios de diseño
- **Fases**: etapas de implementación con entregables y dependencias
- **Riesgos técnicos**: identificados con plan de mitigación
- **Criterios de validación**: cómo se verifica que la implementación cumple la arquitectura

## Estructura del Plan Técnico

1. **Arquitectura de alto nivel**: diagrama de componentes y flujos principales
2. **Descomposición en fases**: F-001, F-002, ... con dependencias
3. **Stack tecnológico**: lenguajes, frameworks, infraestructura
4. **Riesgos y mitigaciones**: tabla de riesgos técnicos
5. **Criterios de validación**: por fase y por requisito
6. **Recursos estimados**: esfuerzo, perfiles, herramientas

## Patrones de Validación

- Cada fase del plan se traza a requisitos de spec
- Cobertura mínima de seguridad, resiliencia, observabilidad
- Consistencia vertical: constitución → spec → plan
- Gates de calidad antes de avanzar a tasks

## Integración con el SDK

Usado por `diana.plan` para generar planes técnicos completos y por `diana.tasks` como fuente de descomposición.
