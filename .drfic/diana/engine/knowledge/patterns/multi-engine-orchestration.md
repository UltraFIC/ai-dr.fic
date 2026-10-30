# Multi-Engine Orchestration Patterns — Diana SDK Knowledge

> **ID**: SDK-P-005
> **Scope**: SDK
> **Estado**: 🟢 Completo

## TL;DR

Patrones para orquestar múltiples engines SDD (Speckit, OpenSpec, Generic-SDD) desde Diana, manteniendo el canon como fuente de verdad única.

## Conceptos Clave

- **Engine SDD**: framework de ejecución que consume artefactos Diana y produce implementación
- **Handoff**: documento de traspaso que declara qué artefactos consume el engine y en qué orden
- **sdd-engine-matrix.yaml**: mapeo de etapas Diana ↔ etapas de cada engine
- **Integration Profile**: perfil de integración con decisiones de topología y orquestación

## Etapas por Engine

| Etapa Diana | Speckit | OpenSpec | Generic-SDD |
|------------|---------|----------|-------------|
| specify | speckit.specify | openspec.discovery | gsdd.architecture |
| plan | speckit.plan | openspec.architecture | gsdd.breakdown |
| tasks | speckit.tasks | openspec.decomposition | gsdd.delivery |
| implement | speckit.implement | openspec.build | gsdd.build |

## Regla de No-Omisión

El engine puede optimizar, ampliar y mejorar, pero NO puede omitir requisitos, decisiones o alcance ya validados por Diana.

## Patrón de Ejecución Multi-Engine

1. Diana produce artefactos canónicos (spec, plan, tasks)
2. Diana genera handoff específico por engine
3. Engine consume artefactos como input base
4. Engine reporta cobertura: preserved / expanded / merged / dropped
5. Si hay dropped no justificado → GAP blocking
