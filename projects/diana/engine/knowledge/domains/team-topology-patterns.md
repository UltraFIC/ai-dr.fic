# Team Topology Patterns — Diana SDK Knowledge

> **ID**: SDK-DOM-007
> **Scope**: SDK
> **Estado**: 🟢 Completo

## TL;DR

Patrones de topología de equipos basados en Conway's Law y adaptados al flujo SDD: cómo dividir equipos, asignar scope_primario y coordinar dependencias.

## Conceptos Clave

- **Conway's Law**: las organizaciones diseñan sistemas que reflejan su estructura de comunicación
- **Inverse Conway Maneuver**: reestructurar equipos para lograr la arquitectura deseada
- **Scope primario**: área funcional asignada a un equipo
- **Dependencia entre equipos**: acoplada (necesitan coordinar) o desacoplada (independientes)
- **Stream-aligned team**: equipo alineado a un flujo de valor

## Patrones de Topología

1. **Stream-aligned**: cada equipo cubre un flujo de valor completo (recomendado SDD)
2. **Platform team**: equipo provee plataforma/servicios a otros equipos
3. **Enabling team**: equipo ayuda a otros a adquirir capacidades
4. **Complicated subsystem**: equipo especializado en subsistema complejo

## Reglas para SDD

1. La topología se decide ANTES de spec/plan/tasks
2. Se basa en constitución + UCC, no en opiniones
3. Cada equipo tiene scope_primario documentado
4. Los artefactos globales son la fuente de división
5. Speckit ejecuta por equipo con artefactos de su carpeta

## Fuentes Externas

- [Team Topologies](https://teamtopologies.com) — patrones de topología de equipos
