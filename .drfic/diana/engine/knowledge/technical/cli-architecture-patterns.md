# CLI Architecture Patterns — Diana SDK Knowledge

> **ID**: SDK-TECH-001
> **Scope**: SDK
> **Estado**: 🟢 Completo

## TL;DR

Patrones arquitectónicos para el diseño del CLI de Diana: separación de concerns, manejo de argumentos, validación y mensajes de error.

## Conceptos Clave

- **Entrypoint único**: `diana init` como comando principal, con extensibilidad futura
- **Separación de capas**: CLI (parser) → lógica de dominio → interacción con sistema de archivos
- **Assets embebidos**: los templates y SDK se empaquetan como datos del paquete Python
- **Modo dry-run**: simulación de operaciones sin escribir cambios

## Patrón de Comando

```python
# Capa CLI: parser de argumentos
# Capa dominio: lógica de inicialización
# Capa archivos: operaciones de copia/escritura
```

## Buenos Prácticas

- Usar `click` o `typer` para definición de comandos
- Argumentos con valores por defecto sensibles
- Mensajes de error en español técnico con acción sugerida
- Validación temprana de precondiciones
- Colores y formato para legibilidad en terminal

## Fuentes Externas

- [Click CLI](https://click.palletsprojects.com) — framework para CLIs Python
- [Typer CLI](https://typer.tiangolo.com) — CLI framework basado en tipos Python
