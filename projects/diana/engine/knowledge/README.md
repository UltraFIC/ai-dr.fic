# Diana SDK Knowledge — Nivel Motor (Cross-Proyecto)

## Propósito

Este directorio contiene el conocimiento profundo sobre **Diana como motor SDD** (Software-Driven Development).
Su contenido aplica a **todos los proyectos** gobernados por Diana, sin importar el dominio de negocio.

> **NO poner aquí**: conocimiento de inversiones, fintech, brokers, compliance, ni nada específico de un proyecto.
> **SÍ poner aquí**: metodología SDD, cómo funcionan los agentes, patrones genéricos, glosario del SDK.

## Estructura

Plano, por categoría, sin índice paralelo ni split local/remoto (las fuentes externas viven dentro de cada doc, sección "Fuentes Externas"):

```
knowledge/
├── methodology/   → Cómo funciona SDD, el ciclo de vida de Diana, fases de Speckit
├── agent-design/  → Capacidades profundas de cada agente Diana (docs de referencia; distinto de engine/agents/, que son las definiciones de los roles)
├── patterns/      → Patrones genéricos aplicables a cualquier dominio
├── glossaries/    → Glosario canónico del SDK (términos Diana/Speckit)
├── governance/     → Constituciones, tickets, radar
├── technical/      → CLI, packaging, git, seguridad, observabilidad
└── domains/        → Ingeniería de requisitos, arquitectura, testing, etc.
```

Las skills propias del SDK (frameworks, metodologías, prácticas transversales reutilizables entre proyectos) **no viven aquí** — son un concepto hermano en `engine/skills/` (ver ese directorio), referenciadas desde cada doc de knowledge donde aplique.

## Cómo usa Speckit este conocimiento

Durante `/speckit.plan` Phase 0, Speckit:
1. Escanea directamente el árbol `knowledge/<categoría>/` relevante para la feature activa (sin índice intermedio que mantener).
2. Identifica gaps no cubiertos por el conocimiento local.
3. Para los gaps: ejecuta su propia investigación (razonamiento + fuentes).
4. El conocimiento local **enriquece** pero nunca **reemplaza** la metodología de Speckit.

## Cómo generar conocimiento

Usa el comando `/diana.knowledge`:

```
/diana.knowledge topic="sdd-lifecycle" scope="sdk"
```

Ver `.github/prompts/diana.knowledge.prompt.md` para documentación completa.

## Convenciones de nombres

- Archivos: `nombre-descriptivo.md` plano, sin numeración ni prefijo.
- Idioma: inglés para términos técnicos, español para explicaciones (bilingual-friendly).
- Encabezado obligatorio: `# [Tema] — Diana SDK Knowledge`.
