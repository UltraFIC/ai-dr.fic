# Risk Management — Diana SDK Knowledge

> **ID**: SDK-DOM-006
> **Scope**: SDK
> **Estado**: 🟢 Completo

## TL;DR

Gestión de riesgos técnicos y de proyecto en el contexto SDD: identificación, análisis, mitigación y monitoreo.

## Conceptos Clave

- **Riesgo**: evento incierto que, si ocurre, tiene impacto negativo en el proyecto
- **Probabilidad**: baja / media / alta
- **Impacto**: bajo / medio / alto / crítico
- **Mitigación**: acción preventiva para reducir probabilidad o impacto
- **Contingencia**: acción reactiva si el riesgo se materializa

## Matriz de Riesgos

| Riesgo | Probabilidad | Impacto | Mitigación | Contingencia |
|--------|-------------|---------|------------|-------------|
| API externa cambia contrato | Media | Alto | Capa de abstracción + tests de integración | Versionado de API |
| Requisitos cambian | Alta | Medio | UCC + spec flexible | Proceso de cambio ágil |
| Dependencia no disponible | Baja | Crítico | Evaluación temprana + alternativas | Fallback a alternativa |

## Integración con el SDK

- `diana.change`: incluir análisis de riesgos en el UCC
- `diana.plan`: tabla de riesgos técnicos con mitigaciones
- `diana.specify`: restricciones y supuestos como riesgos implícitos
