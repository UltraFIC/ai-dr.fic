---
agent: diana.skills
description: Genera o sincroniza skills canónicas del proyecto Diana a partir de ticket, context.md del change, constitución y especificaciones. Úsalo antes de /diana.knowledge para asegurar cobertura completa.
---

# /diana.skills — Generador de Skills Canónicas Diana

## Uso

/diana.skills action="generate"
/diana.skills action="validate"
/diana.skills action="regenerate"

Opcional recomendado para multi-proyecto:

/diana.skills action="generate" scope="project" project="inversions" layer="both"

## Argumentos

| Argumento | Valores | Default | Descripción |
|-----------|---------|---------|-------------|
| action | generate | validate | regenerate | generate | Operación sobre skills |
| scope | project | change | sdk | project | Nivel de generación |
| project | id de proyecto en projects-knowledge-radar | inversions | Proyecto objetivo para enrutar fuentes y salidas |
| name | string (nombre de change ya existente) | auto-detect | Change objetivo cuando aplique |
| layer | general | project | both | both | `project` genera skills especificas del proyecto activo; `general` genera skills reutilizables entre proyectos; `both` hace ambos. Ambas capas comparten el mismo pool de borradores en `.drfic/skills-dev/` — no hay una carpeta `skills-dev` separada por capa, solo difiere el alcance de uso declarado en el manifest |

## Comportamiento por default (si omites argumentos)

- Si omites `scope`, se usa `scope="project"`.
- Si omites `project`, se usa `project="inversions"`.
- Si omites `layer`, se usa `layer="both"`.
- Resultado por default: generación de skills específicas de proyecto + habilidades reutilizables de capa general, ambas como borradores en el mismo pool `.drfic/skills-dev/`.

## Objetivo

Crear una capa intermedia de habilidades (skills) derivadas de fuentes oficiales, que luego guíe la generación de conocimiento profundo y el consumo por agentes Diana/Speckit. Esta acción NO instala skills activas por si sola — produce (a) metadata de tracking en `capabilities/` y (b) borradores reales en `.drfic/skills-dev/`. Activar una skill para que un agente la cargue requiere ejecutar `/diana.install-skill` explícitamente.

## Fuentes Oficiales Obligatorias

Para scope=project, resolver primero `project` desde:
- `.drfic/diana/projects/registry/indexes/projects-knowledge-radar.yaml`

Luego leer fuentes del proyecto objetivo en este orden (ejemplo inversions):
1. `.drfic/diana/projects/<project>/constitution.md`
2. `.drfic/diana/projects/<project>/changes/<name>/spec.md`
3. `specs/001-plataforma-inversiones-ia/spec.md`
4. `.drfic/diana/projects/<project>/changes/<name>/context.md`
5. `.drfic/tickets/<project>/` (ticket relacionado al change, si existe — pool compartido top-level, agrupado por proyecto)

## Salidas Obligatorias

1. skills manifest (tracking, no instalable):
   - `.drfic/diana/projects/<project>/capabilities/manifest.yaml`

2. matriz agente-skill:
   - `.drfic/diana/projects/<project>/capabilities/agent-skill-matrix.yaml`

3. borradores de skill reales (1 carpeta por skill, formato final instalable):
   - `.drfic/skills-dev/<skill-name>/SKILL.md` (+ archivos de soporte si aplica)

4. matriz de engines SDD:
   - `.drfic/diana/projects/<project>/capabilities/sdd-engine-matrix.yaml`

5. trazabilidad de IDs:
   - `.drfic/diana/projects/<project>/capabilities/traceability.md`

6. skills compartidas SDK (cuando aplique, escanear directamente el directorio, sin manifest intermedio):
   - `.drfic/diana/engine/skills/`

7. radar cross-project en raiz de projects:
   - `.drfic/diana/projects/registry/indexes/projects-knowledge-radar.yaml`

### Esquema de `capabilities/manifest.yaml`

El manifest referencia cada skill por nombre y declara su estado real de instalación — es tracking puro, la skill invocable vive en `.drfic/skills-dev/`:

```yaml
skills:
  - name: <skill-name-predictivo-en-minusculas>
    status: draft          # draft = solo existe en .drfic/skills-dev/<skill-name>/SKILL.md
    # status: installed    # installed = ademas fue copiada a uno o mas directorios de agente
    installed_in: []       # ej: [claude, agents] — poblado/actualizado por /diana.install-skill
    layer: project          # general | project
    source_of_truth: <ruta a constitucion/spec/context que origino la skill>
    knowledge_docs:
      - <ruta relativa dentro del arbol compartido .drfic/knowledge/>
    criticality: <alta|media|baja>
```

Campos clave:
- `status`: `draft` (default al crear) o `installed`. Solo `/diana.install-skill` puede mover una skill de `draft` a `installed`.
- `installed_in`: lista de destinos de agente (`claude`, `agents`, `gemini`, `opencode`, `github`) donde ya se instaló. Vacía mientras `status=draft`.
- `layer`: documenta si la skill es especifica de proyecto o reutilizable (`general`), pero no determina su ubicación fisica — todas las skills, sin importar `layer`, viven en el mismo pool `.drfic/skills-dev/`.

## Reglas de Generación

1. Toda skill debe trazarse a fuente canónica (source_of_truth).
2. Toda skill debe enlazar knowledge_docs existentes o por crear (rutas dentro del arbol compartido `.drfic/knowledge/`).
3. Toda etapa Speckit debe definir required_skills mínimas:
   - speckit.specify
   - speckit.clarify
   - speckit.plan
   - speckit.tasks
   - speckit.implement
4. Todo agente Diana debe declarar primary_skills y secondary_skills.
5. Si una skill canónica no existe (ni como entrada en el manifest ni como borrador en `.drfic/skills-dev/`), crearla: entrada en el manifest con `status: draft` + borrador real en `.drfic/skills-dev/<skill-name>/SKILL.md`.
6. Si una skill existe pero sin knowledge_doc completo, marcar gap y recomendar /diana.knowledge topic="...".
7. Toda skill debe tener su borrador real en `.drfic/skills-dev/<skill-name-predictivo-en-minusculas>/SKILL.md`, con frontmatter `description:` y contenido en formato final instalable (ver estructura de un SKILL.md real en `.github/skills/` o `.agents/skills/` de este mismo repo como referencia de forma).
8. Registrar required_skills por engine/etapa para Speckit, OpenSpec y Generic-SDD.
9. Convención obligatoria de IDs de skill: `<skill-name-predictivo-en-minusculas>`.
10. Usar palabras clave completas cuando no hagan el nombre excesivo; evitar abreviaturas opacas.
11. Mantener tabla de trazabilidad cuando cambien IDs (old_id -> new_id) en `capabilities/traceability.md`.
12. Nunca copiar un borrador a una carpeta de skills de agente (`.claude/skills/`, `.agents/skills/`, etc.) desde esta acción — eso es responsabilidad exclusiva de `/diana.install-skill`, que es siempre un paso explícito separado.

## Reuso Cross-Proyecto (obligatorio cuando aplique)

Antes de crear una skill nueva, validar en este orden:
1. ¿Ya existe un borrador con ese nombre en `.drfic/skills-dev/<skill-name>/`? Si existe, reusarlo (o extenderlo) en vez de crear uno nuevo — el pool de borradores es compartido entre todos los proyectos.
2. ¿Ya existe una skill SDK equivalente en `.drfic/diana/engine/skills/` (listar los archivos del directorio directamente; no hay manifest paralelo que consultar)?
3. ¿Ya existe registrada en el radar cross-project `.drfic/diana/projects/registry/indexes/projects-knowledge-radar.yaml`?

Regla de resolución:
1. Reusar borrador existente en `.drfic/skills-dev/` cuando exista, en vez de duplicar.
2. Cargar skill compartida del SDK si aplica.
3. Extender/override (sobre el mismo borrador en `skills-dev/`) solo si hay diferencias de dominio relevantes.
4. Evitar duplicar skills de frameworks/metodologías generales por proyecto — un borrador compartido sirve a varios proyectos a la vez.

## Action=generate

- Crear o actualizar `capabilities/manifest.yaml`.
- Crear o actualizar `capabilities/agent-skill-matrix.yaml`.
- Crear o actualizar borradores reales en `.drfic/skills-dev/<skill-name>/SKILL.md` (reusando los existentes cuando el nombre ya exista en el pool).
- Crear o actualizar `capabilities/sdd-engine-matrix.yaml`.
- Sincronizar IDs, nombres, criticality y referencias de fuente.
- Si `layer=general` o `layer=both`, generar o actualizar borradores reutilizables en el mismo pool `.drfic/skills-dev/` (marcados `layer: general` en el manifest, sin ubicación física distinta).
- Si `layer=project` o `layer=both`, mantener salidas del proyecto activo en:
   - `.drfic/diana/projects/<project>/capabilities/`
   - (los borradores de skill del proyecto viven igual en `.drfic/skills-dev/`, el manifest del proyecto solo los referencia por nombre)

## Action=validate

Verificar:
- Que cada required_skill de Speckit exista en capabilities/manifest.yaml.
- Que cada required_skill de OpenSpec exista en capabilities/manifest.yaml.
- Que cada required_skill de Generic-SDD exista en capabilities/manifest.yaml.
- Que cada skill tenga al menos un knowledge_doc.
- Que cada skill tenga su borrador real en `.drfic/skills-dev/<skill-name>/SKILL.md`.
- Que cada knowledge_doc exista en el arbol compartido `.drfic/knowledge/`.
- Que no existan skills huérfanas sin agente/etapa usuaria.
- Que `installed_in` en el manifest sea consistente con lo realmente presente en `.claude/skills/`, `.agents/skills/`, `.gemini/skills/`, `.opencode/skills/`, `.github/skills/` (reportar discrepancias, no corregirlas automáticamente).

Devolver resumen:
- OK: [n]
- GAPS: [n]
- Lista de acciones recomendadas.

## Action=regenerate

- Releer todas las fuentes oficiales.
- Recalcular skills desde cero.
- Reescribir `capabilities/manifest.yaml`, `capabilities/agent-skill-matrix.yaml` y `capabilities/sdd-engine-matrix.yaml` manteniendo compatibilidad con IDs existentes cuando sea posible.
- Regenerar borradores reales en `.drfic/skills-dev/<skill-name>/SKILL.md` (preservar `status`/`installed_in` existentes si la skill ya estaba instalada — no revertir a `draft`).

## Integración con /diana.knowledge

Flujo recomendado:
1. /diana.skills action="generate"
2. /diana.knowledge topic="..." scope="project"
3. /diana.plan action="generate" scope="project"
4. /speckit.plan

/diana.knowledge debe usar `capabilities/manifest.yaml` y `capabilities/agent-skill-matrix.yaml` como entrada obligatoria de contexto antes de investigación profunda.

## Integración con /diana.install-skill

Cuando un borrador en `.drfic/skills-dev/<skill-name>/` esté listo y el usuario decida activarlo para uno o más agentes:

```
/diana.install-skill skill="<skill-name>" agents="claude"
```

Esto copia el borrador a `.claude/skills/<skill-name>/` y actualiza `status: installed` + `installed_in` en el/los manifest(s) que referencian esa skill (best-effort si la skill no está trackeada en ningún manifest).
