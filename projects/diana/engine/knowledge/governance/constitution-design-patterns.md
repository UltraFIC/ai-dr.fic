# Constitution Design Patterns — Diana SDK Knowledge

> **ID**: SDK-GOV-001
> **Scope**: SDK
> **Estado**: 🟢 Completo

## TL;DR

Patrones para diseñar constituciones de proyecto robustas, con redacción normativa, trazabilidad a UCC y gobierno de cambios explícito.

## Conceptos Clave

- **Constitución**: documento fundacional del proyecto que define propósito, principios, gobernanza y calidad
- **Redacción normativa**: uso consistente de MUST/SHOULD/MAY (RFC 2119)
- **Trazabilidad constitucional**: cada principio debe poder rastrearse a su UCC de origen
- **Versionado**: la constitución se versiona independientemente

## Estructura Canónica

1. **Propósito y alcance**: qué problema resuelve el proyecto y qué NO incluye
2. **Principios no negociables**: reglas que no pueden ser alteradas sin nuevo UCC
3. **Gobernanza de cambios**: cómo se proponen, revisan y aprueban cambios
4. **Criterios de calidad y cumplimiento**: estándares mínimos aceptables
5. **Política de versionado**: cómo se versiona la constitución y artefactos derivados

## Input Modes

- **authoritative**: el input del usuario se respeta como fuente de verdad; solo normalización mínima
- **draft**: el input se trata como borrador; se enriquece y profesionaliza manteniendo trazabilidad

## Agentes Involucrados

- BULMA: constitution-architect (estructura y derivación)
- VEGETA: governance-reviewer (consistencia y rigor)

## Fuentes Externas

- [RFC 2119 Key Words](https://tools.ietf.org/html/rfc2119) — palabras clave para redacción normativa
