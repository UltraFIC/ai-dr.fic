# Documentation Authoring — Diana SDK Knowledge

> **ID**: SDK-DOM-008
> **Scope**: SDK
> **Estado**: 🟢 Completo

## TL;DR

Prácticas profesionales para autoría de documentación técnica y de ayuda en el contexto SDD: estructura, tono, ejemplos y mantenibilidad.

## Conceptos Clave

- **Documentación orientada a tareas**: responde "cómo hago X" no "qué es X"
- **Ejemplos ejecutables**: comandos listos para copiar/pegar
- **Tono técnico-neutral**: español técnico, imperativo, sin ambigüedad
- **Jerarquía de información**: resumen → detalle → referencia
- **Mantenibilidad**: documentación cerca del código/generada desde fuentes

## Estructura de Ayuda

1. **Resumen rápido**: 2-3 líneas con el propósito del comando
2. **Uso**: sintaxis con argumentos y defaults
3. **Ejemplos**: casos de uso comunes con output esperado
4. **Referencia**: tabla de argumentos, valores y descripciones
5. **Flujo sugerido**: cómo se integra en el pipeline SDD

## Reglas para Diana Help

1. Priorizar comandos listos para ejecutar
2. Incluir ejemplos por topología (single-dev / multi-team)
3. Diferenciar entre impacto global vs slice de equipo
4. Recordar reglas clave (cierre global solo por IDs canónicos)
