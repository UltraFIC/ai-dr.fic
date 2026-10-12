# Knowledge Management — Diana SDK Knowledge

> **ID**: SDK-DOM-004
> **Scope**: SDK
> **Estado**: 🟢 Completo

## TL;DR

Sistemas y patrones para gestión de conocimiento en el contexto SDD: cómo estructurar, almacenar, indexar y consumir conocimiento técnico y de dominio.

## Conceptos Clave

- **Conocimiento local**: documentos markdown en el repositorio del proyecto/SDK
- **Conocimiento remoto**: fuentes externas (documentación oficial, APIs, papers) referenciadas desde `remote/sources.md`
- **Índice maestro**: `master-index.md` catálogo de todo el conocimiento disponible
- **Skills-first**: el conocimiento se organiza alrededor de skills, no al revés
- **Barrido canónico**: verificación de cobertura contra fuentes oficiales antes de generar

## Estructura de Conocimiento SDK

```
knowledge/
├── README.md
├── indexes/
│   ├── master-index.md
│   ├── by-agent.md
│   └── shared-skills-manifest.yaml
├── skills/           → Skill docs (001-SDK-*.md)
├── local/
│   ├── methodology/  → Ciclo SDD, quality gates
│   ├── agents/       → Capacidades y matrices
│   ├── patterns/     → Patrones reutilizables
│   ├── glossaries/   → Términos canónicos
│   ├── governance/   → Constituciones, tickets
│   ├── technical/    → CLI, packaging, git
│   └── domains/      → Ingeniería, arquitectura
├── remote/
│   ├── sources.md    → Catálogo de fuentes externas
│   └── snapshots/    → Snapshots de fuentes
```

## Ciclo de Generación

1. Skills-first: verificar skills-manifest.yaml
2. Detectar gaps de conocimiento
3. Investigación profunda por topic
4. Generar documento estructurado
5. Actualizar índices (master-index, by-agent)
6. Registrar fuentes remotas si aplica
