# Ticket Workflows — Diana SDK Knowledge

> **ID**: SDK-GOV-002
> **Scope**: SDK
> **Estado**: 🟢 Completo

## TL;DR

Flujos de trabajo para tickets de servicio en el contexto SDD: creación, priorización, vinculación a cambios y ciclo de vida.

## Conceptos Clave

- **Ticket de servicio**: solicitud formal de trabajo, puede ser independiente o vinculada a un UCC
- **Ciclo de vida**: OPEN → IN_PROGRESS → RESOLVED → CLOSED
- **Prioridad**: high / medium / low, con criterios de escalamiento
- **Modos de relación**: standalone, linked, reuse

## Estructura de Ticket

1. **Cabecera**: ID, proyecto, fecha, prioridad, estado
2. **Título**: descriptivo y accionable
3. **Solicitud**: descripción detallada del trabajo solicitado
4. **Relación UCC**: referencia cruzada cuando aplica
5. **Criterios de aceptación**: condiciones para considerar el ticket cerrado
6. **Notas**: observaciones, blockers, decisiones

## Flujo Recomendado

1. Detección de necesidad → crear UCC (`/diana.change`) o ticket standalone (`/diana.ticket`)
2. Priorización según impacto/urgencia
3. Vinculación a iniciativa SDD
4. Ejecución dentro del ciclo de la iniciativa
5. Cierre con validación contra criterios de aceptación
