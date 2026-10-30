---
agent: diana.install-skill
description: Instala un borrador de skill desde .drfic/skills-dev/ hacia una o mas carpetas de skills de agente (claude, agents, gemini, opencode, github). Activar una skill es siempre una accion humana explicita.
---

# /diana.install-skill - Instalador de Skills Diana

## Uso

/diana.install-skill skill="dmac-indicator" agents="claude"
/diana.install-skill skill="dmac-indicator" agents="claude,agents"
/diana.install-skill skill="options-wheel-strategy" agents="claude,gemini,opencode,github"

## Argumentos

| Argumento | Valores | Default | Descripcion |
|-----------|---------|---------|-------------|
| skill | string (nombre de carpeta en `.drfic/skills-dev/`) | requerido | Skill a instalar. Debe existir `.drfic/skills-dev/<skill>/SKILL.md` |
| agents | lista de `claude` \| `agents` \| `gemini` \| `opencode` \| `github` (multi-select, separados por coma) | requerido, sin default | Destino(s) de instalacion. Instalar es siempre una decision humana explicita: no hay default implicito |

## Objetivo

Copiar un borrador ya listo en `.drfic/skills-dev/<skill>/` (SKILL.md + archivos de soporte) hacia la(s) carpeta(s) de skills activas del/los agente(s) seleccionados, sin mover ni alterar el borrador original. El borrador en `skills-dev/` sigue siendo la fuente editable; cada destino instalado es una copia activa independiente.

## Mapeo de Destinos

| `agents` value | Carpeta destino |
|-----------------|------------------|
| `claude` | `.claude/skills/<skill>/` |
| `agents` | `.agents/skills/<skill>/` |
| `gemini` | `.gemini/skills/<skill>/` |
| `opencode` | `.opencode/skills/<skill>/` |
| `github` | `.github/skills/<skill>/` |

## Precondiciones Obligatorias

1. `.drfic/skills-dev/<skill>/SKILL.md` debe existir. Si no existe, detener con error claro: "no existe borrador `<skill>` en `.drfic/skills-dev/`; generalo primero con `/diana.skills action=\"generate\"` o creandolo manualmente".
2. `agents` debe venir con al menos un valor valido. Si viene vacio o ausente, detener con error claro: "`agents` es requerido — instalar una skill es siempre una accion explicita, no hay destino por default".
3. Si `agents` incluye un valor fuera del mapeo conocido, detener con error claro indicando los valores validos.

## Reglas Canonicas

1. Nunca instalar sin que `agents` haya sido declarado explicitamente por el usuario en la invocacion.
2. Copiar la carpeta completa `.drfic/skills-dev/<skill>/` (SKILL.md + cualquier archivo de soporte: scripts, templates, assets) a cada destino seleccionado.
3. No eliminar ni mover el borrador original en `.drfic/skills-dev/<skill>/` bajo ninguna circunstancia — esta accion es puramente aditiva.
4. Si el destino ya existe (reinstalacion/actualizacion), sobrescribir su contenido con la version actual del borrador y reportarlo como "overwritten" en vez de "created".
5. Despues de instalar, buscar la skill por nombre en cualquier `capabilities/manifest.yaml` de cualquier proyecto bajo `.drfic/diana/projects/*/capabilities/manifest.yaml`:
   - Si se encuentra una entrada, actualizar `status: installed` y agregar los agentes recien instalados a `installed_in` (sin duplicar si ya estaban).
   - Si no se encuentra en ningun manifest, instalar igual y reportar explicitamente que la skill quedo "instalada pero no trackeada" (borrador de origen humano o externo que nunca paso por `/diana.skills`).

## Action=create (unica accion de esta prompt)

1. Validar precondiciones (ver arriba).
2. Resolver carpeta origen: `.drfic/skills-dev/<skill>/`.
3. Por cada valor en `agents`, resolver carpeta destino segun el mapeo y copiar el contenido completo.
4. Actualizar manifest(s) relacionados segun la regla 5 de "Reglas Canonicas".
5. Reportar:
   - Lista de rutas creadas/sobrescritas, una por agente seleccionado.
   - Confirmacion de exito (o error puntual) por cada destino.
   - Si la skill estaba trackeada: proyecto(s) y manifest(s) actualizados, nuevo `installed_in`.
   - Si no estaba trackeada: aviso explicito de "untracked" y sugerencia de registrarla via `/diana.skills action="generate"` si se quiere trazabilidad futura.

## Hooks de Extension

Antes de instalar, revisar `.specify/extensions.yml` en `hooks.before_install_skill`.
Despues de instalar, revisar `.specify/extensions.yml` en `hooks.after_install_skill`.
Manejar `optional` y `enabled` igual que otras acciones Diana/Speckit.

## Integracion Recomendada

Flujo tipico tras generar un borrador:
1. `/diana.skills action="generate"` (produce el borrador en `.drfic/skills-dev/<skill>/SKILL.md`)
2. Revision humana del contenido del borrador (edicion manual opcional antes de instalar)
3. `/diana.install-skill skill="<skill>" agents="claude"` (o la lista de agentes que corresponda)
4. Confirmar que el agente objetivo ya ve la skill activa (recarga de sesion si el agente lo requiere)
