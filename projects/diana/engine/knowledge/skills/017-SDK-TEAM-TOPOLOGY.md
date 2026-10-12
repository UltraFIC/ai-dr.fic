# 017-SDK-TEAM-TOPOLOGY — Team Topology & Coordination

## Objetivo

Dotar al agente `diana.teams` de patrones profesionales para definición de topología de trabajo, diseño organizacional basado en Conway's Law y coordinación multi-equipo.

## Knowledge docs

- local/patterns/002-multi-team-coordination.md
- local/domains/007-team-topology-patterns.md
- local/methodology/001-sdd-lifecycle.md

## Criterios de exito

- Decisión topológica temprana (single_person vs multi_team) registrada en integration-profile.
- scope_primario.md con división funcional basada en constitución/UCC.
- Team roster, task allocation y agent bootstrap generados.
- Cobertura completa del backlog sin huecos entre equipos.
- Artefactos canónicos globales preservados como fuente de división.

## Fallback

Si falta esta skill, asumir single_person y no generar estructura multi-equipo. Reportar gap 017-SDK-TEAM-TOPOLOGY.
