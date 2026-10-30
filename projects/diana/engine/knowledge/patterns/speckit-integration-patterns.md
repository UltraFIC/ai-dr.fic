# Speckit Integration Patterns — Diana SDK Knowledge

> **ID**: SDK-P-001
> **Generado**: 2026-10-11 | **Estado**: 🟢 Completo
> **Scope**: SDK-level
> **Fuentes internas**: `engine/rules/speckit-integration.md`, `engine/rules/governance-and-naming.md`, `engine/templates/integration-profile.md`, `engine/templates/engine-handoff.md`

---

## Resumen

Este documento define **cómo conectar cualquier dominio de negocio a Speckit (o a cualquier engine SDD) bajo gobierno Diana**, sin que ese dominio contamine el canon genérico del SDK. Cubre: el patrón de conexión dominio→engine, la arquitectura de 3 capas de knowledge que un engine debe consumir, el patrón de prompts de agentes, y el diseño standalone/híbrido ya presente en el SDK vía `integration-profile.md`.

---

## 1. Principio rector de integración

> **DIANA-SDK gobierna. Speckit ejecuta. El canon no se infiere.**

Speckit **no es un framework de decisión**: es un motor de ejecución SDD que opera bajo reglas explícitas definidas por Diana. Esto aplica igual si el engine es OpenSpec, Kiro-style o un futuro engine propietario — el patrón de integración es **engine-agnostic por diseño**.

## 2. Nivel de operación permitido para el engine

El engine **solo puede operar a nivel de change**, nunca a nivel de proyecto o portafolio:

```
.drfic/diana/projects/<proyecto>/changes/<nombre>/
├── context.md               # origen organizacional + tipo, NO ejecutable
├── spec.md                  # el engine la LEE y debe cumplirla estrictamente (constitution.md vive en la raiz del proyecto, el engine la LEE, nunca la modifica)
├── plan.md                  # el engine puede estructurar, no redefinir
└── speckit/                 # (o equivalente del engine activo)
    ├── plan.md (derivado)
    ├── research.md
    ├── data-model.md
    ├── contratos/
    ├── quickstart.md
    └── tasks.md
```

Todo lo dentro de la subcarpeta del engine es **derivado**: regenerable, sin autoridad sobre el canon. Si el engine detecta ambigüedad, información incompleta o conflicto entre artefactos, debe **detener ejecución, reportar el problema y solicitar intervención humana o del agente Diana correspondiente** — nunca inferir.

## 3. Patrón de conexión de un dominio de negocio a Speckit

Para que un proyecto nuevo (ej. `inversions`, o cualquier app futura construida con Diana) conecte su dominio al engine sin romper el canon genérico del SDK:

1. **Inicializar el proyecto** (`/diana.context scope="project"` → `/diana.new`): `.drfic/diana/projects/<proyecto>/{context.md, constitution.md, changes/, tickets ya no van aqui -> .drfic/tickets/<proyecto>/, scrum/, capabilities/, prompts/}`. Nunca se comparte gobernanza entre proyectos (cada uno con su propia carpeta).
2. **Flujo greenfield oficial**: `/diana.change` (o `/diana.context scope="change"`) → `/diana.constitution` → `/diana.specify` → `/diana.plan` → *entonces* entra el engine (`speckit.constitution` → `speckit.specification` → `speckit.clarify` → `speckit.plan`). El engine **nunca entra antes de que exista `spec.md`**.
3. **Registrar el perfil de integración** (`templates/integration-profile.md`) para el change: motor SDD elegido, orquestación manual/automática, topología de desarrollo (`single_dev`/`multi_team`), política de autoridad (`diana_canon_strict`).
4. **Cargar conocimiento** antes de generar cualquier artefacto (ver sección 4) — un solo árbol compartido, no capas por proyecto.
5. **Generar/sincronizar skills** con `/diana.skills` antes de invocar al engine — las skills quedan como borradores en `.drfic/skills-dev/`, el tracking en `capabilities/` del proyecto.
6. **Emitir un `engine-handoff.md`** por cada combinación change×engine×stage, declarando exactamente qué consume el engine, en qué orden, y cuándo debe detenerse (ver `templates/engine-handoff.md`).

## 4. Cómo estructurar knowledge para consumo por el engine

El modelo actual es **un solo árbol compartido**, no capas separadas por proyecto:

| Nivel | Ubicación | Contenido |
|------|-----------|-----------|
| **SDK-level (motor)** | `engine/knowledge/` | Metodología SDD genérica, agentes, patrones de integración, glosario. Cross-proyecto, sin dominio de negocio. Auto-conocimiento de Diana mismo. |
| **Proyectos construidos con Diana** | `.drfic/knowledge/<tema>/` | Todo el conocimiento profundo de cualquier proyecto (finanzas, brokers, UI, compliance, etc.), plano por tema, sin carpeta de proyecto ni split local/remoto. |

Orden de carga obligatorio para cualquier etapa SDD (`specify`, `clarify`, `plan`, `tasks`):

1. `.drfic/diana/projects/registry/indexes/projects-knowledge-radar.yaml` (radar cross-project).
2. `.drfic/knowledge/<tema>/` relevante al dominio del change activo.
3. `engine/knowledge/<categoría>/` como capa adicional de metodología compartida (sin índice paralelo que mantener en ninguno de los dos niveles).

Regla de conflicto: si una skill de proyecto y una skill de SDK se superponen, **prevalece la skill del proyecto activo** por contexto de dominio — la capa SDK nunca fuerza una convención que el dominio active contradiga explícitamente. Fallback obligatorio en todos los niveles: si faltan skills o knowledge, el engine SDD **continúa con su metodología propia** (no bloquea el plan por falta de conocimiento local — esto es explícito en el propio `README.md` de `engine/knowledge/`).

Para generar conocimiento en cualquier nivel se usa el mismo comando con distinto `scope`:

```
/diana.knowledge topic="<tema>" scope="sdk"       # auto-conocimiento del motor
/diana.knowledge topic="<tema>" scope="project"   # conocimiento de un proyecto construido con Diana
```

## 5. Patrón de prompts de agentes que respetan la metodología SDD

Todo prompt de agente Diana (ver los 6 existentes en `engine/agents/`) sigue una estructura fija que cualquier nuevo agente — SDK-level o específico de proyecto — debe replicar:

```markdown
# Agent: <Nombre Rol>
## Rol: <Descripción corta>

Eres un agente IA especializado en <responsabilidad> bajo DIANA-SDK.

### Responsabilidad
<Qué debe producir, en una frase>

### Reglas Obligatorias
- <restricciones de comportamiento, siempre incluyendo "no inferir">

### Entradas Permitidas
- <lista cerrada de artefactos que puede leer>

### Salida Esperada
- <artefactos/formatos que debe producir>

### Prohibiciones
- <qué tiene explícitamente vetado, incluso si parece útil>
```

Esta estructura es lo que permite que el engine "reconozca el rol e ignore la narrativa": un engine que lee un prompt de agente Diana puede extraer mecánicamente Entradas/Salida/Prohibiciones sin necesitar entender el alias narrativo.

## 6. Extensiones y hooks (gap de implementación)

El objetivo original de este documento incluía documentar el uso de `.specify/extensions.yml` y patrones de instrucciones en `.github/instructions/`. **Verificado**: ninguno de los dos existe hoy en este repo bajo el scope de Diana (no hay `.specify/` en la raíz del SDK, y `.github/instructions/` pertenece a la app de inversiones, no al motor). Patrón recomendado, basado en cómo Spec Kit soporta extensibilidad (Presets/Extensions con 270+ contribuciones community) y en cómo Diana ya modela extensibilidad de agentes (`rules/agents.md` §8):

- Un **Preset** Diana equivaldría a un conjunto de reglas obligatorias adicionales aplicadas a todas las iniciativas de un proyecto (p. ej. "requiere revisión de seguridad antes de `/speckit.plan`") — declarado en la constitución del proyecto, no en el SDK.
- Una **Extension** Diana equivaldría a un hook que añade una fase o integración nueva (p. ej. sincronización con Jira) — debe declararse en `integration-profile.md` bajo una futura clave `extensiones:` y resolverse vía `engine-handoff.md` para el stage correspondiente.
- Hasta que este mecanismo se implemente formalmente, cualquier extensión de facto debe documentarse como skill en `engine/skills/<nombre>.md` con su propio "Fallback" explícito (patrón ya usado por `sddcore.md` y `tsstack.md`).

## 7. Modo standalone vs. híbrido con OpenSpec/Spec Kit

Diana ya soporta esto de forma nativa vía `templates/integration-profile.md` → clave `motor_sdd`:

- `diana_only` — sin engine externo.
- `speckit` — Speckit como único engine de ejecución.
- `openspec` — OpenSpec como único engine de ejecución (mapeo de fases: specify≈propose, plan≈design, tasks≈tasks, implement≈apply, cierre de iniciativa≈archive).
- `hybrid` — más de un engine convive; `engine-handoff.md` declara, por iniciativa y por stage, qué engine aplica. La regla `conflicto_sin_mapeo: block_global_close` impide cerrar una iniciativa si dos engines reclaman el mismo stage sin resolución explícita.

Orden de ejecución recomendado para cualquier modo (`templates/engine-handoff.md`): (1) skill loading, (2) knowledge loading (3 capas, sección 4), (3) validación de canon, (4) consumo del stage objetivo por el engine. El handoff siempre queda subordinado, en orden de autoridad, a: constitución → spec canónica → plan canónico → tasks canónicas.

### Patrones de interoperabilidad observados en la industria (2026) aplicables a este diseño

- **ADR como capa persistente separada de la spec** (patrón `spec-driven-with-adr` de OpenSpec): specs capturan el "qué" vigente, ADRs capturan el "por qué" de decisiones técnicas y sobreviven al archivo de cambios individuales. Diana ya separa esto conceptualmente (`spec.md` vs. `plan.md`), pero no tiene un artefacto ADR explícito y versionado fuera de `plan.md` — candidato a incorporar como `adr/NNN-<decision>.md` dentro de la iniciativa.
- **Reconciliación spec↔código como comando explícito** (`/opsx:sync` en OpenSpec, `/speckit.reconcile` en Spec Kit, ninguno 100% automático todavía en la industria): Diana no tiene hoy un comando equivalente; la responsabilidad recae implícitamente en GOHAN sin artefacto de salida estandarizado (gap también anotado en `knowledge/agent-design/agent-roles-deep.md`).
- **Constitution como prompt fragment cargado por comando, no como contexto ambiental** (Spec Kit): Diana ya sigue este patrón más estricto — la constitución es canon casi inmutable, leída explícitamente, no un archivo de reglas ambientales tipo `CLAUDE.md`/`AGENTS.md`. Mantener esta distinción es intencional: separa reglas de vida larga (constitución) de specs de vida finita (por iniciativa).
- **Portabilidad entre engines sin vendor lock-in** (posicionamiento de OpenSpec vs. Kiro/IDE-locked): el diseño `motor_sdd` de Diana ya logra esto a nivel de perfil de integración; el gap es que no existe todavía documentación operativa de cómo migrar una iniciativa de un `motor_sdd` a otro a mitad de ciclo.

## 8. Gaps abiertos

- Mecanismo formal de `extensiones:`/hooks en `integration-profile.md` no implementado aún (sección 6).
- No existe comando de reconciliación spec↔código propio de Diana.
- No existe guía operativa de migración de `motor_sdd` a mitad de iniciativa.
- No existe aún un artefacto ADR explícito separado de `plan.md`.

## 9. Fuentes Externas

- [Speckit Documentation](https://speckit.dev/docs) — documentación oficial del engine Speckit
- [OpenSpec Specification](https://openspec.dev) — framework OpenSpec para SDD
