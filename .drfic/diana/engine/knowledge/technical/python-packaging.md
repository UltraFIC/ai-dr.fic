# Python Packaging — Diana SDK Knowledge

> **ID**: SDK-TECH-002
> **Scope**: SDK
> **Estado**: 🟢 Completo

## TL;DR

Prácticas de empaquetado Python para el SDK Diana: hatchling, assets embebidos, entrypoints y distribución vía uvx/pip.

## Conceptos Clave

- **Hatchling**: build backend moderno para Python packages
- **MANIFEST.in**: declara archivos no-Python que deben incluirse en el paquete
- **hatch_build.py**: hook personalizado para embeber assets del SDK
- **Entrypoint CLI**: registrado en `pyproject.toml` bajo `[project.scripts]`
- **uvx**: ejecución directa sin instalación manual

## Estructura del Paquete

```
diana-sdk-installer/
├── src/diana_cli/
│   ├── __init__.py
│   └── main.py
├── assets/
│   ├── drfic/diana/engine/
│   └── github/
│       ├── prompts/
│       └── agents/
├── pyproject.toml
├── hatch_build.py
├── MANIFEST.in
└── setup.py
```

## Reglas de Empaquetado

1. Assets deben ser descubribles en tiempo de ejecución (variable env o path relativo)
2. `DIANA_SDK_ASSETS_DIR` como override para desarrollo local
3. Los prompts y agents se copian al proyecto destino, no se ejecutan desde el paquete
4. Versionado semver sincronizado con CHANGELOG.md

## Fuentes Externas

- [Hatch Packaging](https://hatch.pypa.io) — build backend hatchling para Python
