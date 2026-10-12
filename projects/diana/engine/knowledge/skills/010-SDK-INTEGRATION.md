# 010-SDK-INTEGRATION — SDD Engine Integration Patterns

## Objetivo

Dotar al agente `diana.integrate` de patrones profesionales para integración multi-framework, handoff canónico y ejecución coordinada entre Diana y engines SDD.

## Knowledge docs

- local/patterns/001-speckit-integration-patterns.md
- local/patterns/005-multi-engine-orchestration.md
- local/methodology/001-sdd-lifecycle.md

## Criterios de exito

- Handoff completo con trazabilidad a artefactos canónicos.
- Soporte para Speckit, OpenSpec y Generic-SDD.
- Pipeline multi-team con etapas paralelas y secuenciales.
- Validación de cobertura canónica (preserved, expanded, merged, dropped).
- Regla de no-omisión aplicada correctamente.

## Fallback

Si falta esta skill, generar handoff mínimo sin validación de cobertura. Reportar gap 010-SDK-INTEGRATION.
