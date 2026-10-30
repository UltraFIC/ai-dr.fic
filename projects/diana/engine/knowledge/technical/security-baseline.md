# Security Baseline — Diana SDK Knowledge

> **ID**: SDK-TECH-004
> **Scope**: SDK
> **Estado**: 🟢 Completo

## TL;DR

Criterios de seguridad mínimos que toda especificación, plan y backlog Diana debe considerar, independientemente del dominio del proyecto.

## Conceptos Clave

- **Defensa en profundidad**: múltiples capas de control de seguridad
- **Mínimo privilegio**: acceso mínimo necesario para cada rol/componente
- **Secure by design**: la seguridad se considera desde la spec, no al final
- **Threat modeling**: identificación sistemática de amenazas

## Criterios Mínimos por Artefacto

### Spec
- RF de autenticación y autorización
- RNF de cifrado en tránsito y reposo
- Restricciones de cumplimiento (GDPR, SOX, etc.)

### Plan
- Estrategia de secretos management
- Controles de acceso por capa
- Plan de respuesta a incidentes

### Tasks
- Tareas de verificación de seguridad
- Pruebas de penetración y SAST/DAST
- Review de seguridad antes de producción

## Fuentes Externas

- [OWASP Top 10](https://owasp.org/www-project-top-ten/) — riesgos de seguridad en aplicaciones
