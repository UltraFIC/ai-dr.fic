# Observability Patterns — Diana SDK Knowledge

> **ID**: SDK-TECH-005
> **Scope**: SDK
> **Estado**: 🟢 Completo

## TL;DR

Patrones de observabilidad (logging, métricas, tracing) que toda especificación y plan Diana debe considerar para garantizar visibilidad del sistema en producción.

## Conceptos Clave

- **Logging estructurado**: logs en formato JSON con campos consistentes (timestamp, level, service, trace_id)
- **Métricas**: RED (Rate, Errors, Duration) para cada servicio
- **Tracing distribuido**: trace única que cruza todos los componentes
- **Dashboards**: paneles por servicio y visión consolidada
- **Alertas**: basadas en SLOs, no en síntomas

## Patrón por Componente

| Componente | Logging | Métricas | Tracing |
|-----------|---------|----------|---------|
| API Gateway | requests, errores | RED por endpoint | trace_id header |
| Servicios | operaciones críticas | RED por operación | span por llamada |
| Base de datos | queries lentas | conexiones, latencia | db span |
| Workers | jobs procesados | queue depth, errors | job trace |

## Integración con el SDK

Usado por `diana.specify` (RNF de observabilidad), `diana.plan` (arquitectura de monitoreo) y `diana.tasks` (tareas de instrumentación).

## Fuentes Externas

- [Google SRE Book](https://sre.google/books/) — prácticas de ingeniería de confiabilidad
