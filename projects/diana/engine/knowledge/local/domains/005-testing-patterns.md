# Testing Patterns — Diana SDK Knowledge

> **ID**: SDK-DOM-005
> **Scope**: SDK
> **Estado**: 🟢 Completo

## TL;DR

Patrones de testing para el SDK Diana y para proyectos generados: pirámide de testing, tipos de prueba y cobertura mínima.

## Conceptos Clave

- **Tests unitarios**: validan lógica individual (CLI, validación de args, resolución de rutas)
- **Tests de integración**: validan interacción entre componentes (copia de assets, creación de estructura)
- **Tests de humo**: validan que el CLI responde y los comandos básicos funcionan
- **Calidad de assets**: validación de que templates y prompts están bien formados

## Pirámide de Testing para SDK

```
     /\
    /  \        ← Tests E2E (CLI completo + instalación)
   /    \
  /      \      ← Tests de integración (assets, templates)
 /________\
/ Unitary  \    ← Tests unitarios (lógica pura)
```

## Cobertura Mínima

- 80%+ en lógica de dominio (resolución de rutas, validación de args)
- 100% en paths críticos (inicialización, radar, estructura base)
- Validación de estructura generada contra expected tree

## Herramientas Recomendadas

- pytest para testing
- pytest-cov para cobertura
- pytest-mock para mocking de sistema de archivos
- tox para testing multi-version
