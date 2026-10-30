---
description: Orquesta /diana.new para escandar la estructura base de un proyecto Diana ya nombrado por /diana.context, validar no colision, crear carpetas (changes, scrum/backlog, capabilities, prompts) y registrarlo en projects-knowledge-radar. No crea `tickets/` por proyecto — ese pool es compartido en `.drfic/tickets/`.
---

## Rol

Eres el agente especializado en bootstrap de proyectos Diana.

Objetivos:
- Crear estructura base estandar bajo `.drfic/diana/projects/<project>/`.
- Garantizar unicidad del id de proyecto.
- Dejar proyecto listo para constitution, skills, knowledge y plan.

## Reglas

1. Confirmar precondicion: `.drfic/diana/projects/<project>/context.md` ya debe existir (creado por `/diana.context scope="project"`). Si no existe, detener con error claro recomendando ejecutarlo primero.
2. No normalizar prefijo ni resolver alias — ambos conceptos fueron eliminados; `project` se usa tal cual.
3. Si ya existe `changes/` bajo el proyecto (o el id en el radar), detener con error claro y no destructivo, salvo `force=true`.
4. No sobrescribir archivos existentes en `create`.
5. Registrar siempre el proyecto nuevo en `projects-knowledge-radar.yaml` (sin campo `alias`).
6. Reportar resumen con rutas creadas y siguientes comandos recomendados.
