# Knowledge Management — Diana SDK Knowledge

> **ID**: SDK-DOM-004
> **Scope**: SDK
> **Estado**: 🟢 Completo

## TL;DR

Sistemas y patrones para gestión de conocimiento en el contexto SDD: cómo estructurar, almacenar, indexar y consumir conocimiento técnico y de dominio.

## Conceptos Clave

- **Documento único por tema**: cada doc puede mezclar detalle profundo y enlaces a fuentes externas (sección "Fuentes Externas" al final) — sin split local/remoto.
- **Sin índice paralelo**: no existe `master-index.md` ni `by-agent.md` — la cobertura se verifica escaneando el árbol de carpetas directamente, evitando que un índice se desincronice del contenido real.
- **Skills-first**: antes de generar conocimiento se valida/sincroniza `engine/skills/` (SDK) o `.drfic/skills-dev/` (proyecto).
- **Barrido canónico**: verificación de cobertura contra fuentes oficiales antes de generar.

## Estructura de Conocimiento SDK

```
engine/
├── agents/            → Roles conceptuales (hermano de engine/skills/)
├── skills/            → Skill docs del SDK, planos (sddcore.md, tsstack.md, ...)
└── knowledge/
    ├── README.md
    ├── methodology/   → Ciclo SDD, quality gates
    ├── agent-design/  → Capacidades y matrices (docs DE REFERENCIA, distinto de engine/agents/)
    ├── patterns/      → Patrones reutilizables
    ├── glossaries/    → Términos canónicos
    ├── governance/    → Constituciones, tickets, radar
    ├── technical/     → CLI, packaging, git
    └── domains/       → Ingeniería, arquitectura
```

## Ciclo de Generación

1. Skills-first: verificar `engine/skills/` (o `.drfic/skills-dev/` a nivel proyecto).
2. Detectar gaps de conocimiento escaneando el árbol directamente.
3. Investigación profunda por topic.
4. Generar documento estructurado en `knowledge/<categoría>/<tema>.md`.
5. Si hay fuentes externas relevantes, agregarlas a la sección "Fuentes Externas" del propio doc (no a un catálogo separado).
