# Diana SDK — Referencia Técnica Completa

> Generado a partir de investigación directa del código fuente en `projects/diana/` (ai-dr.fic) y de la instalación real en `ai_apps_dr.fic/.drfic/diana-sdk`.

## 1. Qué es Diana

Diana (DIANA‑SDK by DRFIC) es un framework propio de Spec-Driven Development (SDD), no un fork de SpecKit u OpenSpec. Su filosofía, declarada en `projects/diana/engine/rules/speckit-integration.md`:

> "DIANA‑SDK gobierna. Speckit ejecuta. El canon no se infiere."

Diana se posiciona como capa de **gobernanza y canon** por encima de motores de ejecución SDD intercambiables (Speckit, OpenSpec, Generic-SDD). Reglas clave:
- Speckit **solo opera a nivel de iniciativa** (lee `spec.md`/`plan.md`, genera derivados en `speckit/`), nunca crea/modifica `constitution.md`, nunca interpreta tickets o controles de cambio, nunca infiere requisitos ausentes.
- El canon se protege en una jerarquía estricta: **constitución > spec > plan > derivados**.
- Principio rector del lifecycle (`rules/lifecycle.md`): "No todo cambio genera una especificación. No toda especificación genera una constitución. Todo lo que se ejecuta debe tener canon explícito."
- Principio de calidad (`rules/sdd-quality-metrics.md`): "Un sistema SDD es de calidad cuando el código es consecuencia natural del canon. Si la IA necesita adivinar, la calidad es baja."

Diana es explícitamente **bilingüe en su diseño pero español como idioma oficial** de todos los artefactos (specs, planes, tareas); inglés técnico solo para identificadores/estándares.

## 2. Las 13 Acciones `diana.*`

Fuente: `projects/diana/engine/integrations/github/prompts/diana.*.prompt.md` (leídos completos). Cada acción tiene un agente respaldo en `.../agents/diana.*.agent.md`.

### 2.1 `/diana.new` — Inicializador de Proyecto
- **Args**: `action` (create|validate, default create), `project` (string, requerido), `initiative` (default `001-<project-sin-prefijo>`), `alias` (auto-derivado de las 3 primeras letras alfanuméricas), `force`.
- **Normaliza** el nombre a `diana-<project>` (si ya trae el prefijo, se conserva).
- **Valida no-colisión**: si la carpeta o el id ya existen en el radar, detiene con error.
- **Crea estructura base mínima**: `README.md`, `governance/decision-log.md`, `governance/change-requests/.gitkeep`, `governance/tickets/.gitkeep`, `initiatives/<initiative>/.gitkeep`, `knowledge/README.md`, `knowledge/indexes/.gitkeep`, `knowledge/skills/README.md`, `knowledge/local/.gitkeep`, `knowledge/remote/sources.md`, `knowledge/snapshots/.gitkeep`.
- **Registra** el proyecto en `projects/knowledge/indexes/projects-knowledge-radar.yaml` (id, alias, enabled, y placeholders null para knowledge_index/skills_manifest/agent_skill_matrix/sdd_engine_matrix).
- Soporta hooks `.specify/extensions.yml` (`hooks.before_new` / `hooks.after_new`).
- **Flujo siguiente recomendado**: `/diana.change` → `/diana.constitution` → `/diana.skills` → `/diana.knowledge` → `/diana.plan`.

### 2.2 `/diana.change` — Control de Cambios (UCC) + Ticket Relacionado
- **Args**: `action`, `project`, `alias`, `input` (ruta md), `title`, `description`, `content`, `create_ticket` (default **true**), `ticket_title`, `ticket_description`.
- Crea un UCC en `governance/change-requests/NNN-<alias>-ucc.md` con numeración secuencial automática (detecta el mayor `NNN` existente +1).
- Por **defecto crea también un ticket relacionado** con el mismo `NNN` (para trazabilidad 1:1 de alta) en `governance/tickets/NNN-<alias>-tkt.md` — único caso donde se fuerza el mismo número entre UCC y ticket.
- Resolución de contenido con prioridad: `--input` > `content` > plantilla mínima (`title`+`description`) > error.
- Plantilla mínima UCC: Título, Contexto, Alcance, Impacto Esperado, Riesgos, Estado (Draft).
- Plantilla mínima Ticket: Relación (UCC: NNN-alias-ucc), Título, Solicitud, Prioridad (medium), Estado (OPEN).

### 2.3 `/diana.ticket` — Ticket de Servicio (independiente)
- **Args**: `action`, `project`, `alias`, `input`, `title`, `description`, `content`, `relation_mode` (standalone|linked|reuse, default **standalone**), `ucc_ref`, `priority` (default medium).
- Permite tickets **sin** UCC (`standalone`), tickets que referencian un UCC existente (`linked`, requiere `ucc_ref`), o múltiples tickets reutilizando el mismo UCC (`reuse`).
- Numeración propia e independiente del UCC (su propio `NNN+1` en `governance/tickets/`); solo `/diana.change` puede forzar coincidencia de número.

### 2.4 `/diana.constitution` — Generador de Constitución
- **Args**: `action` (generate|validate|regenerate), `scope` (project|initiative|sdk), `project`, `initiative`, `alias`, `input`, `context_input`, `input_mode` (authoritative|draft, default **draft**).
- Fuente primaria: UCC más reciente del proyecto (auto-resuelto) o `--input` explícito.
- `input_mode="authoritative"`: respeta el contenido fuente casi literal (solo normalización mínima, no inventa alcance).
- `input_mode="draft"`: enriquece/formaliza el borrador, complementando con `context_input` o fuente auto-resuelta.
- Carga obligatoriamente la plantilla física `sdk/diana/templates/constitution.md` como base estructural.
- Salida: `<alias>-constitution.md` en la raíz del proyecto, con reporte de trazabilidad UCC→constitución.
- Roles conceptuales: BULMA (constitution-architect), VEGETA (governance-reviewer), KRILIN (traceability-checker).

### 2.5 `/diana.skills` — Generador de Skills Canónicas
- **Args**: `action`, `scope` (default project), `project`, `layer` (general|project|both, default **both**).
- Debe ejecutarse **antes** de `/diana.knowledge` ("Skills First").
- Fuentes obligatorias en orden: constitución → spec de iniciativa → spec operativa `specs/.../spec.md` → UCC → ticket → meta.md.
- Salidas: `skills-manifest.yaml`, `agent-skill-matrix.yaml`, skills modulares en `knowledge/skills/` (convención de ID: `<NNN>-inv-<nombre-predictivo>`), `sdd-engine-matrix.yaml`, `skills-traceability.md`, y opcionalmente skills compartidas SDK en `sdk/diana/knowledge/indexes/shared-skills-manifest.yaml`.
- Reutilización cross-proyecto obligatoria: antes de crear una skill de proyecto, valida si ya existe una compartida en SDK o en el radar de `projects/knowledge`.

### 2.6 `/diana.knowledge` — Generador de Conocimiento Profundo
- **Args**: `topic` (default "all"), `scope` (sdk|project|initiative, default project), `project`, `layer` (general|project|both, default both), `type` (local|remote|both, default both), `source`.
- **Fase 0 (barrido canónico obligatorio)**: carga UCC, ticket, constitución, spec canónica, meta.md y spec operativa antes de generar nada; construye matriz tema→cobertura.
- **Fase 0.5 (Skills First obligatorio)**: valida/sincroniza skills antes de generar knowledge; si no existen, recomienda ejecutar `/diana.skills` primero.
- Genera documentos con estructura estándar (TL;DR, Conceptos Clave, secciones principales, Integración con el Proyecto, Decisiones de Diseño, Referencias, Siguiente Paso) guardados en `knowledge/local/<categoría>/[NNN-topic].md`.
- Principio explícito: "El conocimiento generado por /diana.knowledge enriquece la metodología de Speckit. No la reemplaza."

### 2.7 `/diana.specify` — Generador de Especificación Canónica
- **Args**: `action`, `project`, `alias`, `initiative` (auto-detect), `input`, `title`, `description`.
- La **constitución siempre se carga** aunque se use `--input` (este solo reemplaza la resolución del UCC, no la lectura constitucional). Si no hay constitución, se detiene y recomienda `/diana.constitution` primero.
- Fuente de cambio en orden: `--input` > UCC más reciente auto-resuelto > degradado (constitución+meta) > fallback con `title`/`description`.
- Auto-detecta la iniciativa de mayor prefijo `NNN-*`; si no existe ninguna, crea `001-<alias>/`.
- Salida: `initiatives/<initiative>/NNN-<alias>-spec.md`, con tabla de errores comunes documentada (constitución no encontrada, UCC no encontrado, iniciativa ambigua, spec ya existe).

### 2.8 `/diana.plan` — Generador de Plan Técnico
- **Args**: `action`, `scope`, `project` (default diana-inversions), `initiative` (default 001-inversions).
- "Skills + Knowledge First" obligatorio antes de generar o validar; si faltan, no bloquea, degrada a metodología estándar y reporta gap.
- Fuentes oficiales: radar, constitución, spec canónica, spec operativa, UCC, ticket, meta.md.
- Salida: `initiatives/<initiative>/001-inv-plan.md`, listo para `/speckit.plan`.
- Roles: BULMA (plan-architect), VEGETA (canon-reviewer), KRILIN (task-readiness).

### 2.9 `/diana.tasks` — Generador de Backlog Canónico
- **Args**: `action`, `scope`, `project`, `initiative`, `team` (TEAM-01..99, solo en topología multi_team).
- Lee `meta.md` de la iniciativa para determinar topología **antes** de generar.
  - `single_person`: genera `<initiative>/001-inv-tasks.md`.
  - `multi_team`: lee `scope_primario.md`, genera `teams/TEAM-XX/tasks.md` por equipo (solo pendientes si no se especifica `team`), preservando literalidad de checkboxes al derivar por equipo desde el backlog global si existe.
- Template core obligatoria: `sdk/diana/templates/initiative-tasks.md`.

### 2.10 `/diana.teams` — Topología y Coordinación Multi-equipo
- **Args**: `action` (topology|generate|validate|regenerate, default **topology**), `project`, `initiative`, `team`.
- **Precondiciones obligatorias**: ticket completado, UCC completado, `/diana.integrate action="bootstrap"` completado, constitución creada.
- `action="topology"` **debe ejecutarse antes** de `/diana.specify`, `/diana.plan` y `/diana.tasks`.
- La decisión de topología (single_dev/multi_team) vive primero en `integration-profile.md` (generado por `/diana.integrate bootstrap`); `diana.teams` la lee y materializa, no la vuelve a preguntar salvo inconsistencia.
- Si `multi`: crea `initiatives/<initiative>/teams/TEAM-NN/` y `scope_primario.md` (tabla team_id/alias/scope_primario/carpeta).
- `action="generate"`: produce `speckit/team-roster.md`, `speckit/team-task-allocation.md`, `speckit/team-agent-bootstrap.md`.
- Roles: BULMA (team-architect), VEGETA (dependency-reviewer), KRILIN (execution-readiness).

### 2.11 `/diana.integrate` — Handoff Multi-Framework (Diana↔Speckit/OpenSpec/Generic-SDD)
- Acción más compleja del set. **Args**: `action` (bootstrap|generate|validate|regenerate|run|all, default generate), `scope`, `project`, `initiative`, `engine` (speckit|openspec|generic_sdd, default speckit), `stage`/`run_only` (specify|clarify|plan|tasks|implement|...), `from`/`until` (para pipelines parciales), `team`, `language` (es|en, default es), `orchestration` (manual|automatic), `topology` (single_dev|multi_team), `sync_mode`.
- `action="bootstrap"` es **Fase 0 obligatoria**: crea/actualiza `integration-profile.md` con decisiones de engine, orquestación, topología y política de autoridad ("Diana canon strict"). Se recomienda justo después de `/diana.change` y antes de `/diana.constitution`.
- `action="run"` ejecuta **una sola etapa** Speckit (`run_only=specify|plan|tasks|implement`), siempre cargando primero el artefacto canónico `teams/TEAM-XX/<etapa>.md`.
- `action="all"` ejecuta pipeline multi-equipo completo o parcial (`from`/`until`), con precondición de topología multi_team validada contra `scope_primario.md`; reporta cobertura `preserved|expanded|merged|dropped` por equipo y etapa — si hay `dropped` no justificado, se detiene y marca GAP.
- **Regla de entrada canónica y no-omisión**: Speckit puede optimizar/ampliar el artefacto Diana de `TEAM-XX`, pero nunca omitir contenido ya validado.
- Templates: `engine-handoff.md`, `integration-profile.md`.

### 2.12 `/diana.sync` — Reconciliación de Tareas Diana↔Speckit
- **Args**: `action` (tasks), `mode` (dry-run|apply, default dry-run), `scope`, `project`, `initiative`, `team`, `feature`, `since`, `extension_policy` (mirror-team|conflict-on-unmapped, default mirror-team), `global_close_policy` (canonical-only).
- Los IDs canónicos (T001, T002...) son la llave de mapeo obligatoria; el backlog global **nunca crea IDs nuevos** por sync, solo cierra por mapeo existente.
- `dry-run` nunca escribe cambios; `apply` actualiza primero slices de equipo, luego recalcula el backlog global.
- Script operativo real: `pwsh .../scripts/powershell/diana-sync-team.ps1 -Team TEAM-01 -Feature <feature> -Mode dry-run|apply`.

### 2.13 `/diana.help` — Centro de Ayuda
- **Args**: `topic` (commands|sdd|sync|new-project|troubleshoot|all, default all), `mode` (quick|detailed), `topology` (single_dev|multi_team, default multi_team).
- Contiene el **tutorial SDD canónico recomendado** (ver sección 2.14 abajo) y el flujo de sync Speckit→Diana TEAM.

### 2.14 Orden/Dependencias Canónicas entre Acciones (consolidado de `diana.help`, `diana.new`, `diana.teams`, `diana.specify`)

Multi-team (recomendado):
```
/diana.new
  → /diana.change  (crea UCC + ticket)
    → /diana.integrate action="bootstrap"   (declara engine/topología/orquestación)
      → /diana.constitution
        → /diana.teams action="topology"    (OBLIGATORIO antes de specify/plan/tasks)
          → /diana.skills action="validate|generate"
            → /diana.knowledge
              → /diana.specify   (por equipo si multi_team)
                → /diana.plan
                  → /diana.tasks
                    → /diana.teams action="generate"  (roster/allocation/bootstrap)
                      → /diana.integrate action="run|all" (invoca speckit.specify→plan→tasks→implement)
                        → /diana.sync action="tasks" mode="dry-run" → mode="apply"
```
Single-dev: igual pero sin `/diana.teams` de división de equipos, usando artefactos únicos `NNN-inv-spec/plan/tasks.md`.

## 3. Los 6 Agentes (`projects/diana/engine/prompts/agent-*.md`)

| Archivo | Rol técnico | Responsabilidad | Prohibiciones clave |
|---|---|---|---|
| `agent-spec-writer.md` | Spec Writer (alias narrativo: **PICCOLO**) | Generar/refinar `spec.md` sin inferir requisitos, respetando constitución | No diseña arquitectura, no propone implementación, no genera tareas |
| `agent-plan-architect.md` | Plan Architect (**BULMA**) | Generar `plan.md` que implemente la spec sin redefinir alcance | No redefine el producto ni crea funcionalidades nuevas |
| `agent-reviewer.md` | Canon Reviewer (**VEGETA**) | Detectar inconsistencias entre constitución/spec/plan/derivados | No corrige automáticamente, no modifica archivos |
| `agent-task-generator.md` | Task Generator (**KRILIN**) | Transformar plan aprobado en tareas atómicas y verificables | No inventa tareas fuera del plan |
| `agent-qa-validator.md` | QA Validator (**GOHAN**) | Validar cumplimiento de implementación/plan contra spec | No aprueba por inferencia |
| `agent-copilot.md` | Copilot (**GOKU**) | Asistir humanos: comprensión, navegación, resúmenes, reportes | No actúa como autoridad, no ejecuta cambios sin autorización |

Nota: `rules/agents.md` documenta un séptimo rol opcional, **TRUNKS** (Evolution/Refactor Agent), sin archivo `agent-*.md` propio todavía. El mapping narrativo completo (Dragon Ball) es: PICCOLO→Spec Writer, BULMA→Plan Architect, VEGETA→Canon Reviewer, KRILIN→Task Generator, GOHAN→QA Validator, GOKU→Copilot, TRUNKS→Evolution.

Cada una de las 13 acciones `diana.*` tiene además su propio `agent.md` de ejecución en `integrations/github/agents/diana.<accion>.agent.md` (13 archivos, 1:1 con los prompts), que es un nivel distinto: ese es el "agente ejecutor VS Code" de la acción, mientras que los 6 `agent-*.md` de `engine/prompts/` son los **roles conceptuales SDD** que gobiernan el comportamiento (p.ej. `/diana.constitution` invoca conceptualmente a BULMA+VEGETA+KRILIN).

## 4. Reglas de Gobernanza (`projects/diana/engine/rules/*.md`)

### 4.1 `governance-and-naming.md`
Principio rector: *"La gobernanza pertenece al proyecto. El canon pertenece a la iniciativa. Speckit solo ejecuta canon."* Cada proyecto DEBE tener su propio `governance/{change-requests,tickets,decision-log.md}` — **no existe gobernanza global compartida entre proyectos**; cada proyecto tiene su propia numeración `<NNN>` reiniciada. Convenciones de ID: `<NNN>-<PROYECTO>-CC` (control de cambios), `<NNN>-<PROYECTO>-TKT` (ticket), `<PROYECTO>-CONSTITUTION` (única, nace solo en greenfield), `<NNN>-<PROYECTO>-SPEC`, `<NNN>-<PROYECTO>-PLAN`, `<NNN>-<PROYECTO>-TASK`. La relación CC↔Ticket↔Canon se declara siempre en `meta.md` (informativo, no ejecutable, Speckit no lo interpreta). Flujo greenfield oficial: CC → TKT → CONSTITUTION → SPEC → PLAN → (recién ahí) Speckit.

*(Nota: este documento de reglas usa nomenclatura `<PROYECTO>-CC/TKT` en mayúsculas mientras los prompts `.prompt.md` reales usan `NNN-<alias>-ucc.md`/`NNN-<alias>-tkt.md` en minúsculas — es la convención que de facto implementan el CLI/prompts, ver §6 drift).*

### 4.2 `naming-conventions.md`
Jerarquía canónica obligatoria: **DRFIC (organización) → Proyecto → Iniciativa → Artefactos SDD**. Proyecto: `<dominio>-<producto>` (sin espacios/mayúsculas/versiones/tickets). Iniciativa: `NNN-descripcion-corta` (el número es orden histórico, no versión). Archivos canónicos fijos por iniciativa: `meta.md`, `constitution.md` (solo si aplica), `spec.md`, `plan.md`. Idioma oficial: español; inglés solo para identificadores técnicos/estándares.

### 4.3 `lifecycle.md`
Tres eventos de origen válidos (no ejecutables por sí mismos): Control de cambios, Ticket de usuario, Decisión estratégica. Tres tipos de iniciativa, cada uno determina qué artefactos nacen:
- **Greenfield**: nace `constitution.md` + `spec.md` (SPEC-001) + `plan.md`. Convención: `001-foundation`.
- **Brownfield** (evolución): nace `spec.md` nueva + `plan.md`; NO nace constitución nueva.
- **Bugfix**: nace solo `plan.md` correctivo + `tasks/`; NO nace spec ni constitución.
Constitución = "evento raro, consciente y deliberado". `meta.md` obligatorio por iniciativa, nunca ejecutable.

### 4.4 `spec-versioning.md`
Principio: *"La especificación versiona el 'qué', no el 'cómo'."* Modelo de **versionado secuencial por iniciativa** (SPEC-001, SPEC-002...), no semver. Regla fundamental: **cada nueva versión de spec vive en una nueva iniciativa** (nunca `spec-v1.md`/`spec-v2.md` dentro de la misma carpeta); el archivo siempre se llama `spec.md`, la versión se declara en el contenido. Estados posibles: Borrador, Activa, Deprecada, Archivada — solo "Activa" es ejecutable por Speckit. Bugfix nunca versiona spec. Trazabilidad entre versiones se declara explícitamente ("Esta especificación reemplaza a SPEC-001").

### 4.5 `speckit-integration.md`
Ya resumido en §1 (principio rector). Agrega el flujo de agentes: PICCOLO define/valida spec → BULMA define/valida plan → VEGETA revisa coherencia → Speckit ejecuta `/speckit.plan` → KRILIN genera tareas (`/speckit.tasks`) → GOHAN valida cumplimiento → GOKU asiste humanos. Ante ambigüedad, Speckit debe **detenerse y reportar**, nunca inferir.

### 4.6 `agents.md`
Mapping narrativo Dragon Ball ↔ rol técnico (tabla en §3). Principio: *"El rol técnico manda. El alias comunica. El canon no se negocia."* Convención de nombre de archivo de prompt: `<alias>-<rol-tecnico>.md` (ej. `piccolo-spec-writer.md`) — **nota de drift**: los archivos reales en `engine/prompts/` usan en cambio `agent-<rol>.md` genérico (`agent-spec-writer.md`), no el patrón `<alias>-<rol>.md` que esta regla documenta.

### 4.7 `sdd-quality-metrics.md`
5 dimensiones de calidad: Canon, Claridad/No-ambigüedad, Trazabilidad, Ejecución con IA, Estabilidad evolutiva. Umbral para "lista para ejecución": Canon alto, Ambigüedad baja, Inferencias cero/mínimas, Trazabilidad completa, Determinismo IA alto — si falla una, la iniciativa NO debe ejecutarse. Se complementa con `checklists/checklists.md`, que define **cuándo** correr cada checklist (gate antes de `/speckit.plan`, antes de `/speckit.tasks`, antes de implementación, antes de cierre/auditoría) y los 4 estados posibles: APROBADO, APROBADO CON RIESGOS, REQUIERE AJUSTES, BLOQUEADO.

## 5. Qué genera el CLI (`diana init`)

Fuente: `projects/diana/cli/src/diana_cli/main.py` + `hatch_build.py` + `pyproject.toml` (paquete `diana-sdk-installer`, entry point `diana = diana_cli.main:main`).

**Origen del nombre "diana-sdk"**: no viene de main.py sino del *build hook* `hatch_build.py` líneas 31 (`core_target = assets_dir / "drfic" / "diana-sdk" / "sdk" / "diana"`), que empaqueta `projects/diana/engine/**` (excluyendo `integrations/`) dentro de `assets/drfic/diana-sdk/sdk/diana/`, y `integrations/github/{agents,prompts}` en `assets/github/{agents,prompts}`. En `main.py`, `_resolve_assets_root()` localiza ese `assets/` (vía `DIANA_SDK_ASSETS_DIR` o relativo al módulo) y `_init_project()` (líneas 77-135) copia:
- `assets/drfic/diana-sdk/sdk/diana` → `<target>/.drfic/diana-sdk/sdk/diana` (el "core SDK").
- `assets/github/prompts` → `<target>/.github/prompts/diana.*.prompt.md` (salvo `--skip-actions`).
- `assets/github/agents` → `<target>/.github/agents/diana.*.agent.md` (salvo `--skip-actions`).

Estructura creada siempre por `diana init --target <ruta>`:
```
<target>/.drfic/readme.md                                   (si no existe o --force)
<target>/.drfic/diana-sdk/sdk/diana/{rules,templates,prompts,checklists,scripts,knowledge}/...  (copia íntegra del engine)
<target>/.drfic/diana-sdk/projects/                          (carpeta vacía, lista para proyectos)
<target>/.drfic/diana-sdk/projects/knowledge/indexes/projects-knowledge-radar.yaml  (radar base, si no existe o --force)
<target>/.drfic/diana-sdk/memory/                            (carpeta vacía)
```
Con `--skip-actions`: **no** se copian `.github/prompts/diana.*` ni `.github/agents/diana.*` (el usuario no tendrá los slash-commands disponibles en VS Code, pero sí el core SDK en `.drfic`).
Con `--force`: sobrescribe archivos existentes al copiar (tanto el core como prompts/agents/readme/radar); sin `--force`, solo completa lo que falta.

**Importante**: el CLI **no crea** `governance/`, `change-requests/`, `tickets/`, `initiatives/`, ni el prefijo `diana-<project>` — todo eso lo crea la **acción** `/diana.new` (ejecutada después por un agente IA en VS Code leyendo el `.prompt.md`), no el instalador Python. El CLI solo deja el SDK compartido y el radar vacío; `/diana.new` es quien construye cada proyecto individual bajo `projects/`.

## 6. Instalación Real (`ai_apps_dr.fic/.drfic/diana-sdk`) y Drift vs. lo declarado

Árbol real observado (resumen):
```
.drfic/diana-sdk/
├── memory/
├── sdk/diana/{checklists,knowledge,prompts,rules,scripts,templates,constitution.md}
└── projects/
    ├── knowledge/ (radar general + indexes/skills/snapshots)
    ├── tickets/                      ← carpeta extra en la RAÍZ de projects, no declarada en ningún prompt/CLI
    ├── diana-inversions/
    │   ├── inv-constitution.md, README (no visto)
    │   ├── governance/{change-requests,tickets}/   ← confirma estructura de diana.new
    │   ├── initiatives/001-inversions/
    │   │   ├── 001-inv-{spec,plan,tasks}.md
    │   │   ├── meta.md, scope_primario.md, monorepo-structure.md  ← archivo extra no documentado
    │   │   ├── speckit/{README,team-roster,team-task-allocation,team-agent-bootstrap}.md
    │   │   ├── integrations/{integration-profile.md, speckit-handoff*.md, diana-sync-*.md, TEAM-03-speckit-coverage-report.md}  ← varios artefactos de sync/handoff no listados explícitamente como "salidas obligatorias" en diana.integrate (solo integration-profile.md y <engine>-handoff.md están documentados; speckit-handoff.md y los reportes de sync parecen nombres alternos/reales usados en producción)
    │   │   └── teams/TEAM-01..TEAM-09/{spec,plan,tasks}.md + varios TEAM-03/sync-*.md (evidencia real de uso de /diana.sync en modo dry-run/apply)
    │   └── knowledge/{indexes,local/{brokers,compliance,cores,domain,patterns},remote,skills,snapshots}
    ├── diana-demoapp/   (misma forma, con governance/change-requests y tickets poblados: 001-demo-ucc.md, 001-demo-tkt.md)
    └── diana-sdk-core/  (tiene SOLO governance/tickets/001-dianacore-tkt.md, sin UCC — confirma que un ticket standalone sin UCC es un flujo real soportado)
```

**Drift detectado frente al código fuente/prompts**:
1. `projects/tickets/` en la raíz (fuera de cualquier proyecto) existe en la instalación real pero **no está declarado** en `diana.new.prompt.md` ni en `main.py` — probablemente vestigio de una convención anterior o un experimento manual.
2. `initiatives/001-inversions/monorepo-structure.md` es un artefacto ad-hoc sin plantilla ni mención en ningún prompt — la instalación real creció orgánicamente más allá de lo canónico.
3. Los nombres de archivos de sync/integración reales (`speckit-handoff.md`, `diana-sync-TEAM-03-apply-2026-05-25.md`, `TEAM-03-speckit-coverage-report.md`) no coinciden 1:1 con los nombres de "Salidas Obligatorias" documentados en `diana.integrate.prompt.md` (que solo declara `<engine>-handoff.md` e `integration-profile.md`) ni en `diana.sync.prompt.md` (que no define un nombre de archivo de salida, solo "resumen de reconciliación" y actualización de slices) — en la práctica el agente generó nombres de archivo con fecha/sufijo libremente.
4. La constitución real (`inv-constitution.md`, 423 líneas, versión 1.1.0 con Sync Impact Report, stack tecnológico, gobierno de agentes, versionado semver) es **mucho más rica** que la plantilla mínima de 5 secciones en `templates/constitution.md` — confirma que `/diana.constitution` con `input_mode="draft"` realmente "profesionaliza y amplía" el contenido, tal como describe el prompt, llegando bastante más allá del esqueleto.
5. El UCC real (`001-inv-ucc.md`) usa una plantilla **distinta y mucho más extensa** ("PLANTILLA DE CONTROL DE CAMBIOS (UCC)" corporativa con folio, responsables, SAP, aprobaciones) que la "Plantilla Mínima UCC" de 6 secciones definida inline en `diana.change.prompt.md` — es decir, en producción se usó `--input` con una plantilla corporativa externa en vez de la plantilla mínima del prompt, consistente con la regla de prioridad de contenido (`--input` > `content` > plantilla mínima).
6. **No se encontró** la carpeta `sdk/diana-sdk-installer/` dentro de `.drfic/diana-sdk/sdk/` en la instalación real — solo existe `sdk/diana/`. La premisa de que `git status`/`git diff --stat` muestran eliminaciones de `CHANGELOG.md`, `MANIFEST.in`, `README.md`, `assets/...` bajo esa ruta **no se confirmó**: `git status --short` en `ai_apps_dr.fic` solo reporta un archivo nuevo sin trackear (`docs/promts/diana-folders-actions-restructuring.md`) y `git diff --stat` no devuelve nada — el working tree está limpio salvo ese documento. Posiblemente la información de deleciones corresponde a un estado anterior ya resuelto/commiteado, o a otra copia local no inspeccionada.

## 7. Templates Disponibles (`projects/diana/engine/templates/`)

| Template | Propósito |
|---|---|
| `constitution.md` | Esqueleto mínimo de constitución (Propósito, Alcance, Principios Rectores, Reglas Técnicas, Relación con IA, Evolución) |
| `spec.md` | Spec canónica con RF/RNF, Contrato de Experiencia y Controles (UI), Fuentes de Datos y Modos de Operación, Configurabilidad Evolutiva, Restricciones, Supuestos, Fuera de Alcance, Criterios de Aceptación |
| `initiative-plan.md` | Plan técnico con Autoridad (subordinado a constitución+spec), Skills Requeridas, Arquitectura por capas, Fases, Riesgos, Criterios de Validación, Integración con Speckit |
| `initiative-tasks.md` | Backlog canónico con formato `[ID] [P?] [Historia] Descripción`, Fases, Dependencias, Congruencia con Speckit |
| `meta.md` | Origen organizacional (CC/ticket/decisión), checkbox de Tipo de Iniciativa (greenfield/brownfield/bugfix), explícitamente "no ejecutable" |
| `initiative-readme.md` | Resumen de iniciativa: artefactos canónicos vs derivados, estado |
| `engine-handoff.md` | Handoff formal Diana→engine SDD: autoridad, engine/stage objetivo, artefactos de entrada obligatorios, orden de ejecución, reglas de consumo, multi-equipo, reconciliación |
| `integration-profile.md` | Decisiones de integración (motor_sdd, orquestación, topología, política de autoridad), política de automatización por etapa y de sync de tareas |
| `team-roster.md` | Tabla de equipos (team_id/alias/scope_primario/branch_prefix/lead/integration_owner) + integrantes por equipo con roles |
| `team-task-allocation.md` | Matriz de asignación tarea→equipo con `blocked_by`, `contract_review_required`, vista por equipo |
| `team-agent-bootstrap.md` | Bootstrap de agentes por equipo: fuentes globales, skills/knowledge requeridos por fase, checklist de precondiciones |

**No existe un template dedicado de UCC ni de Ticket** en `templates/` — sus plantillas mínimas viven *inline* dentro de `diana.change.prompt.md` y `diana.ticket.prompt.md` (ver §2.2/§2.3), y en la práctica real se reemplazan por plantillas corporativas vía `--input` (ver §6.5).

## 8. Checklists de Calidad (`projects/diana/engine/checklists/`)

| Checklist | Gate / Momento | Responsable conceptual |
|---|---|---|
| `checklists.md` | Reglas meta: cuándo/cómo ejecutar cada checklist | — |
| `sdd-quality-gate.md` | Antes de `/speckit.plan` y `/speckit.tasks` — identidad/estructura, idioma, canon/autoridad, ambigüedad/inferencia, criterios medibles (todo BLOCKER) | VEGETA |
| `spec-quality-checklist.md` | Antes de aprobar spec para planificar | PICCOLO + VEGETA |
| `plan-quality-checklist.md` | Antes de generar tareas | BULMA + VEGETA |
| `tasks-quality-checklist.md` | Antes de implementación | KRILIN + GOHAN |
| `initiative-audit-checklist.md` | Cierre/auditoría de iniciativa | VEGETA + GOKU |

Cada checklist usa 3-4 estados de salida (APROBADO / APROBADO CON RIESGOS / REQUIERE AJUSTES / BLOQUEADO) y ningún BLOCKER permite avanzar.
