# ai-dr.fic

Monorepo oficial de DR.FIC. Primer y unico producto hoy: **DIANA**, el
framework de Spec-Driven Development propio (ver `openspec/config.yaml` para
el contexto completo de vision, estructura y reglas).

## Estructura

```
projects/
└── diana/
    ├── engine/     # motor Diana: fuente unica de verdad (rules, templates, prompts, knowledge, checklists, scripts)
    ├── cli/        # instalador publicable (paquete pip `diana-sdk-installer`) - ver projects/diana/cli/README.md
    ├── pwa/        # demo web construida con Diana (dogfooding)
    └── rest-api/   # demo de servicios Express construida con Diana (dogfooding)
```

Un producto futuro distinto a Diana viviria en `projects/<producto>/` sin
tocar nada de `projects/diana/`.

## Instalar Diana en un proyecto

Ver [`projects/diana/cli/README.md`](projects/diana/cli/README.md) para el
comando `uvx` exacto y las opciones de `diana init`.
