# Multi-Team Coordination Patterns — Diana SDK Knowledge

> **ID**: SDK-P-002
> **Scope**: SDK
> **Estado**: 🟢 Completo

## TL;DR

Patrones para coordinar múltiples equipos trabajando en una misma iniciativa SDD, basados en Conway's Law y división funcional por scope_primario.

## Conceptos Clave

- **scope_primario**: área funcional asignada a un equipo, derivada de constitución + UCC
- **TEAM-NN**: identificador canónico de equipo (TEAM-01, TEAM-02, ...)
- **Artefactos por equipo**: spec.md, plan.md, tasks.md dentro de `teams/TEAM-NN/`
- **Roster**: registro de integrantes, roles y branch prefix por equipo

## Patrones de División

1. **Por subsistema**: cada equipo toma un subsistema completo (frontend, backend, datos)
2. **Por capa**: cada equipo toma una capa arquitectónica (API, servicios, persisted)
3. **Por feature vertical**: cada equipo toma features completas end-to-end
4. **Por dominio**: cada equipo toma un dominio de negocio

## Reglas de Coordinación

- Los artefactos globales (001-inv-spec.md, 001-inv-plan.md) son la fuente de verdad para división
- Cada equipo opera sobre su copia en `teams/TEAM-NN/`
- Speckit ejecuta por equipo, leyendo artefactos de su carpeta
- La reconciliación global se hace vía `/diana.sync`

## Integración con el SDK

Usado por `diana.teams` para generar `scope_primario.md`, roster, task allocation y agent bootstrap.

## Fuentes Externas

- [Conway's Law](https://en.wikipedia.org/wiki/Conway%27s_law) — ley de Conway y su aplicación
