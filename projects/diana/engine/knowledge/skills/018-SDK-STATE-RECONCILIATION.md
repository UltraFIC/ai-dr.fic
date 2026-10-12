# 018-SDK-STATE-RECONCILIATION — State Reconciliation & Sync

## Objetivo

Dotar al agente `diana.sync` de patrones profesionales para reconciliación de estados entre engines de implementación y el canon Diana, con trazabilidad y modos seguros.

## Knowledge docs

- local/patterns/006-state-synchronization.md
- local/methodology/002-sdd-quality-gates-deep.md
- local/glossaries/001-diana-terms.md

## Criterios de exito

- Reconciliación en modo dry-run antes de aplicar cambios.
- IDs canónicos como única llave de sincronización.
- Mapeo explícito Speckit → Diana (many-to-one, one-to-many).
- Política de extensión (mirror-team vs conflict-on-unmapped) aplicada.
- Cierre global solo por IDs canónicos existentes.
- Reporte de sincronizadas, pendientes y conflictos.

## Fallback

Si falta esta skill, realizar sync manual sin validación de conflictos. Reportar gap 018-SDK-STATE-RECONCILIATION.
