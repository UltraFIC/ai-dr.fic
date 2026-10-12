# 003-SDK-PYTHON-PKG — Python Package Development for SDK Core

## Objetivo

Definir patrones reutilizables para empaquetar, distribuir y mantener el core SDK de Diana como paquete Python instalable vía `uvx`/`pip`.

## Knowledge docs

- local/technical/002-python-packaging.md
- local/patterns/001-speckit-integration-patterns.md

## Criterios de exito

- SDK empaquetado correctamente con hatchling.
- Entrypoint CLI funcional (`diana init`).
- Assets embebidos correctamente en el paquete (MANIFEST.in / hatch_build.py).
- Compatibilidad con `uvx` sin instalación manual.

## Fallback

Si falta esta skill, usar setup.py tradicional y embeber assets manualmente. Reportar gap 003-SDK-PYTHON-PKG.
