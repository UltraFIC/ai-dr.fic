---
agent: diana.knowledge
description: Genera conocimiento profundo para Diana SDK. Úsalo cuando necesites investigar un tema y guardarlo como conocimiento (detalle, enlaces o híbrido) en el árbol compartido `.drfic/knowledge/`.
---

# /diana.knowledge — Generador de Conocimiento Profundo Diana

## Uso

```
/diana.knowledge topic="[ruta-libre-opcional]" scope="[sdk|project|change]"
```

Modo multi-proyecto recomendado:

```
/diana.knowledge topic="[ruta-libre-opcional]" scope="project" project="[project-id]"
```

Prerequisito recomendado:

```
/diana.skills action="generate"
```

### Argumentos

| Argumento | Valores | Default | Descripción |
|-----------|---------|---------|-------------|
| `topic` | ruta relativa libre \| `all` | `all` | Ruta relativa dentro del árbol compartido `.drfic/knowledge/` (e.g. `"indicadores/dmac"`, `"core-estrategias/wheel"`). No hay categorías fijas, ni prefijo `NNN-`, ni carpeta por proyecto: el string que pases ES la ruta del archivo (se le agrega `.md`). Si se omite, se procesa `all` |
| `scope` | `sdk` \| `project` \| `change` | `project` | Nivel donde guardar el conocimiento (`sdk` es la única excepción que no usa `.drfic/knowledge/`) |
| `project` | id de proyecto en projects-knowledge-radar | `inversions` | Proyecto objetivo cuando `scope=project` o `scope=change`. No afecta la ruta de guardado (el árbol de knowledge es plano y compartido) — se usa como contexto para saber qué constitución/spec leer, y se anota como metadata dentro del documento generado |
| `name` | string (nombre de change ya existente) | auto-detect | Change objetivo cuando `scope=change` (el documento se guarda igual en el árbol compartido, no hay árbol separado por change ni por proyecto) |
| `source` | URL o nombre | opcional | Fuente específica a documentar; si se da, se referencia en la sección "Referencias y Fuentes" del mismo documento (no genera un archivo aparte) |

### Comportamiento por default (si omites argumentos)

- Si omites `topic`, se usa `topic="all"`.
- Si omites `scope`, se usa `scope="project"`.
- Un único tipo de documento: puede ser detalle, enlaces, o híbrido — la plantilla estándar (ver más abajo) ya cubre los tres casos vía su sección "Referencias y Fuentes".
- No existe split local/remote, ni capa general/project, ni carpeta por proyecto: todo el conocimiento vive junto en un único árbol compartido `.drfic/knowledge/` (plano, libre por tema).

### Resolución automática de tópicos cuando `topic="all"`

Orden de prioridad para construir la lista de tópicos:
1. Tópicos obligatorios declarados en **Fase 0** de este prompt (baseline mínimo).
2. Skills del proyecto en `capabilities/manifest.yaml` (mapear cada skill a su/sus `knowledge_docs`).
3. Escaneo directo del árbol compartido `.drfic/knowledge/` para detectar huecos y evitar duplicados (no hay índice maestro paralelo que consultar).

Si un tópico aparece en más de una fuente, procesarlo una sola vez.

### Ejemplos

```bash
# Conocimiento técnico de IBKR para el proyecto de inversiones
/diana.knowledge topic="ibkr-tws-api" scope="project" project="inversions"

# Ruta libre anidada (sin categoría fija, sin prefijo NNN-)
/diana.knowledge topic="indicadores/dmac" scope="project" project="inversions"

# Core de estrategias de opciones, anidado bajo una carpeta tematica propia
/diana.knowledge topic="core-estrategias/wheel" scope="project" project="inversions"

# Core técnico (soportes, resistencias, tendencias)
/diana.knowledge topic="technical-analysis-core" scope="project" project="inversions"

# Core fundamental
/diana.knowledge topic="fundamental-analysis-core" scope="project" project="inversions"

# Core de señales buy/sell
/diana.knowledge topic="buy-sell-signals-core" scope="project" project="inversions"

# Core de opciones (Wheel, Straddle, Iron Condor)
/diana.knowledge topic="options-strategies-core" scope="project" project="inversions"

# Core flujo institucional opciones
/diana.knowledge topic="institutional-options-flow-core" scope="project" project="inversions"

# Core noticias en tiempo real
/diana.knowledge topic="realtime-news-core" scope="project" project="inversions"

# Core confluencia IA
/diana.knowledge topic="ai-confluence-orchestrator-core" scope="project" project="inversions"

# Metodología SDD para el SDK (cross-proyecto, scope=sdk sin cambios)
/diana.knowledge topic="sdd-lifecycle" scope="sdk"

# Documentar una fuente remota especifica (se pliega en Referencias y Fuentes del doc del topic)
/diana.knowledge topic="alpaca-api" scope="project" project="inversions" source="https://docs.alpaca.markets/"

# Generacion en lote de todos los topicos obligatorios y mapeados
/diana.knowledge scope="project" project="inversions"

# Conocimiento disparado por un change especifico (igual se guarda en el arbol compartido de knowledge)
/diana.knowledge topic="order-lifecycle" scope="change" project="inversions" name="mfa-accesos-criticos"
```

---

## Instrucciones para el Agente

Cuando el usuario ejecute este comando:

### Fase 0: Barrido Canónico Obligatorio (no omitir)

Antes de generar cualquier documento, cargar y resumir cobertura desde estas fuentes oficiales:

1. Context del change (necesidad de negocio y origen, incluyendo ticket relacionado si aplica):
   - `.drfic/diana/projects/inversions/changes/<name>/context.md`
2. Constitución del Proyecto (reglas no negociables):
   - `.drfic/diana/projects/inversions/constitution.md`
3. Spec Canónica (fuente funcional completa):
   - `.drfic/diana/projects/inversions/changes/<name>/spec.md`
4. Spec operativa activa (clarificaciones vigentes):
   - `.specify/feature.json` -> `specs/001-plataforma-inversiones-ia/spec.md`

Construir una matriz temporal `tema -> cobertura actual` y detectar gaps obligatorios.

Temas obligatorios de cobertura minima para este proyecto:
- Analisis tecnico (soportes, resistencias, tendencia)
- Analisis fundamental
- Senales buy/sell
- Estrategias de opciones (Wheel, Straddle, Iron Condor)
- Flujo institucional por strike/expiracion
- Noticias en tiempo real
- Confluencia IA entre cores activos por usuario

Si falta cualquiera de estos temas, generar/actualizar los documentos correspondientes antes de terminar.

### Fase 0.5: Skills First (obligatorio)

Antes de generar o actualizar conocimiento profundo, validar y sincronizar skills en:

- `.drfic/diana/projects/registry/indexes/projects-knowledge-radar.yaml`
- `.drfic/diana/projects/inversions/capabilities/manifest.yaml`
- `.drfic/diana/projects/inversions/capabilities/agent-skill-matrix.yaml`
- `.drfic/diana/projects/inversions/capabilities/sdd-engine-matrix.yaml`
- `.drfic/skills-dev/` (borradores reales de skill, pool compartido entre proyectos — ver `/diana.skills`)

Reglas:
1. Derivar skills desde fuentes canonicas (no desde opinion ad-hoc).
2. Para cada skill, enlazar al menos un `knowledge_doc` (ruta dentro del árbol compartido `.drfic/knowledge/`).
3. Si un tema canonico no tiene skill asociada, crear skill nueva.
4. Si una skill no tiene documento de conocimiento completo, generarlo/actualizarlo.
5. Mantener mapeo de skills requeridas por agente Diana y por etapa Speckit.
6. Mantener mapeo por engine SDD (Speckit, OpenSpec, Generic-SDD).

Si los archivos de capabilities no existen, generarlos primero con:

```
/diana.skills action="generate"
```

### Fase 1: Cargar Contexto

1. Leer la **constitución del proyecto activo**:
   - Si `scope=project` o `change`: leer `.drfic/diana/projects/<project>/constitution.md` (ej. `.drfic/diana/projects/inversions/constitution.md`)
   - Si `scope=sdk`: leer `.drfic/diana/engine/constitution.md`

2. Leer el **spec activo** (si existe): `.specify/feature.json` → cargar `spec.md` correspondiente

3. Detectar cobertura existente:
   - `scope=project` o `scope=change`: escanear directamente el árbol compartido `.drfic/knowledge/` (no hay `master-index.md` paralelo que mantener para estos scopes — la existencia/gap-checking se hace leyendo la estructura de carpetas y archivos tal cual).
   - `scope=sdk`: escanear directamente `.drfic/diana/engine/knowledge/<categoría>/` (tampoco hay `master-index.md` paralelo que mantener para este scope — la existencia/gap-checking se hace leyendo la estructura de carpetas y archivos tal cual, igual que los demás scopes).

4. Verificar si ya existe un documento sobre este `topic` (es decir, si `.drfic/knowledge/<topic>.md` ya existe). Si existe y está 🟢 Completo, notificar al usuario y preguntar si quiere regenerar.

   Si `topic="all"`:
   - Construir lista consolidada de tópicos con la sección "Resolución automática de tópicos".
   - Iterar tema por tema aplicando la misma lógica de existencia/regeneración (chequeando la ruta de archivo correspondiente en el árbol).

5. Verificar cobertura contra la matriz de Fase 0:
   - Si el `topic` solicitado depende de otros temas obligatorios no cubiertos, sugerir generarlos en lote.
   - Si el usuario pidió generación completa de proyecto, producir todos los temas obligatorios faltantes.

### Fase 2: Investigación Profunda

1. **Investigar el tema** usando:
   - Tu conocimiento del modelo (conocimiento interno profundo)
   - El contexto de la constitución y spec cargados
   - Razonamiento sobre el dominio específico del proyecto
   - Si se paso `source`, incorporar esa fuente como referencia primaria en el documento

2. **Generar un documento completo** con estructura estándar (un único tipo de documento: puede ser detalle, solo enlaces/resumen de fuentes, o híbrido — la sección "Referencias y Fuentes" cubre los tres casos):

```markdown
# [Tema Capitalizado] — Diana [Nivel] Knowledge

> **Generado**: [fecha actual]
> **Scope**: [scope indicado]
> **Proyecto**: [project, si `scope=project` o `scope=change`; "N/A" si `scope=sdk`]
> **Estado**: 🟢 Completo

## TL;DR

[2-3 oraciones: qué es, por qué importa, cuándo usar]

## Conceptos Clave

[lista de conceptos fundamentales con definición breve]

## [Sección Principal 1]

[contenido detallado]

## [Sección Principal 2]

[contenido detallado]

## Integración con el Proyecto

[cómo aplica específicamente a inversions o al scope indicado]

## Decisiones de Diseño

[tradeoffs conocidos, alternativas consideradas]

## Referencias y Fuentes

[URLs, documentación oficial, papers — si el documento es principalmente de enlaces, esta sección puede ser el grueso del contenido]

## Siguiente Paso

[qué investigar o generar a continuación]
```

3. **Determinar la ruta de guardado**:
   - `scope=sdk`: `engine/knowledge/<categoría>/<topic>.md` — plano, sin `local/`, sin prefijo `NNN-` (es el auto-conocimiento de Diana).
   - `scope=project` o `scope=change`: `.drfic/knowledge/<topic>.md` — `topic` ES la ruta relativa completa dentro del árbol compartido (sin categoría forzada, sin prefijo `NNN-`, sin carpeta por proyecto). Ej.: `topic="indicadores/dmac"` → `.drfic/knowledge/indicadores/dmac.md`. Si `topic` no incluye subcarpetas, el archivo se guarda directo en la raíz del árbol compartido (`.drfic/knowledge/<topic>.md`). `project` (y `name` si `scope=change`) no afectan esta ruta — son solo contexto de investigación, anotado en el metadata del documento (ver plantilla de Fase 2).

4. **Guardar el documento** en la ruta correspondiente. Crear las carpetas intermedias si `topic` incluye segmentos anidados (e.g. `indicadores/`).

   Para ningún scope (`sdk`, `project` o `change`) existe un paso de mantenimiento de índice maestro: la cobertura se verifica escaneando el árbol directamente (ver Fase 1, punto 3).

### Fase 3: Confirmación

Reportar al usuario:
- Documento(s) generado(s) y su ruta completa dentro de `.drfic/knowledge/` (o de `engine/knowledge/<categoría>/` si `scope=sdk`)
- Topicos procesados (generados, actualizados y omitidos por ya estar completos)
- Lista de temas obligatorios cubiertos vs pendientes
- Skills creadas/actualizadas y agentes afectados
- Siguiente comando sugerido (e.g., siguiente documento a generar o `/speckit.plan`)

---

## Principio Fundamental

> El conocimiento generado por `/diana.knowledge` **enriquece** la metodología de Speckit.
> **No la reemplaza.** Si Speckit encuentra gaps no cubiertos en el knowledge local,
> debe continuar con su propia investigación y razonamiento (Phase 0 normal).
> El objetivo es que Speckit llegue al plan con más contexto experto, más rápido.
