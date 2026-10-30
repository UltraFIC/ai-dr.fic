# Scaffolding Patterns — Diana SDK Knowledge

> **ID**: SDK-P-004
> **Scope**: SDK
> **Estado**: 🟢 Completo

## TL;DR

Patrones para scaffolding de proyectos Diana, estructura de directorios canónica y registro en radar de conocimiento.

## Conceptos Clave

- **Estructura base**: conjunto mínimo de carpetas y archivos para que un proyecto sea funcional
- **Radar**: `projects-knowledge-radar.yaml` como registro maestro de proyectos activos
- **Alias**: identificador corto (3+ letras) para nombrar archivos canónicos del proyecto
- **Prefijo diana-**: normalización automática de nombres de proyecto

## Estructura Base Canónica

```
.drfic/diana-sdk/projects/diana-<project>/
├── README.md
├── governance/
│   ├── decision-log.md
│   ├── change-requests/
│   └── tickets/
├── initiatives/
│   └── NNN-<alias>/
├── knowledge/
│   ├── README.md
│   ├── indexes/
│   ├── skills/
│   ├── local/
│   ├── remote/
│   └── snapshots/
```

## Reglas de Scaffolding

1. Validar no colisión (carpeta + radar) antes de crear
2. No sobrescribir archivos existentes
3. Alias persistido en radar para reuso entre acciones
4. Iniciativa inicial `001-<alias>` creada por defecto
