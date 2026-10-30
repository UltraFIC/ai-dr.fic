# DIANA‑SDK by DRFIC
## Reglas Oficiales de Nomenclatura de Changes y Tickets por Proyecto

---

## 1. Propósito

Este documento define las reglas oficiales de DIANA‑SDK by DRFIC para:

- Aislamiento por proyecto de changes y tickets
- Organización de changes (unidad de canon) y tickets (unidad de intake)
- Convenciones obligatorias de identificación para artefactos SDD

Su objetivo es:
- Evitar mezcla de proyectos
- Garantizar consecutivos independientes por proyecto (tickets)
- Mantener trazabilidad clara origen → canon → ejecución
- Permitir operación segura de Speckit y agentes IA
- Facilitar auditoría y escalabilidad multi‑proyecto

Estas reglas son **obligatorias** para todos los proyectos DIANA‑SDK.

> **Nota de versión**: este documento reemplaza el modelo previo de "gobernanza" (`governance/change-requests` + `governance/tickets`) e "iniciativas" (`initiatives/<NNN-alias>/`) como dos jerarquías paralelas coordinadas por número y por `meta.md` en texto libre. Ese modelo fue colapsado en una sola jerarquía plana: `changes/<nombre>/` + `tickets/`. Las secciones marcadas **(NUEVO)** describen el modelo vigente; las marcadas **(ELIMINADO)** documentan qué dejó de existir, para referencia histórica.

---

## 2. Principio Rector

> **El proyecto es la unidad de aislamiento.**
> **El change es la unidad de canon.**
> **El ticket es la unidad de intake.**
> **Speckit solo ejecuta canon.**

Nunca se mezclan changes ni tickets entre proyectos.

---

## 3. Estructura Obligatoria por Proyecto (NUEVO)

Cada proyecto DIANA‑SDK **DEBE** contener, directamente en su raíz (sin carpeta envolvente):

```
projects/<project>/
├── context.md
├── constitution.md (si aplica)
├── changes/
│   ├── <name>/
│   │   ├── context.md
│   │   ├── spec.md
│   │   ├── plan.md
│   │   └── tasks.md
│   └── backup/
├── tickets/
│   └── tkt-<num_ticket_interno>-<1-4 palabras>.md
├── scrum/backlog/
└── knowledge/
```

Reglas:
- **(ELIMINADO)** No existe una carpeta `governance/` envolvente. `changes/` y `tickets/` viven directamente en la raíz del proyecto.
- **(ELIMINADO)** No existe carpeta `initiatives/`: fue reemplazada por `changes/`.
- No existe gobernanza global compartida entre proyectos.
- Cada proyecto mantiene su propio `changes/` y `tickets/`; no se comparten entre proyectos.
- La auditoría siempre se realiza a nivel proyecto.

---

## 4. Identificación de un Change (NUEVO)

**(ELIMINADO)** El esquema `<NNN>-<PROYECTO>-{CC,TKT,SPEC,PLAN,TASK}` y el alias de 3 letras para abreviar nombres de archivo (`NNN-alias-spec.md`, etc.) ya no existen.

Un change se identifica **únicamente por el nombre de su carpeta**: `changes/<name>/`.

Reglas:
- `<name>`: 1‑2 palabras significativas, lowercase, sin espacios.
- Sin numeración `NNN`, sin alias de proyecto, sin sufijos de tipo de artefacto (`-CC`, `-SPEC`, etc.) en el nombre.
- No existen identificadores compuestos tipo `001-DIANA-CC` ni `001-DIANA-SPEC`.
- `changes/<name>/` contiene los archivos canónicos `context.md`, `spec.md`, `plan.md`, `tasks.md`, y opcionalmente `teams/`, `speckit/`, `integrations/`, `knowledge/` (re-rooteados sin cambio de forma respecto al modelo anterior).
- `context.md` fusiona lo que antes eran dos archivos separados: el Control de Cambios (UCC, el "por qué" de negocio) y `meta.md` (el contexto organizacional: tipo de change, origen). Ambos viven ahora en un solo archivo por change.
- Todo proyecto nuevo puede iniciar con un change (p. ej. `changes/foundation/`), pero un change ya no se crea automáticamente al crear un ticket (ver sección 5).

---

## 5. Identificación de un Ticket (ajustado — la numeración interna se mantiene)

Reglas:
- Los tickets viven en `tickets/` (ya no en `governance/tickets/`).
- Nombre de archivo obligatorio: `tkt-<num_ticket_interno>-<1-4 palabras>.md` (ej. `tkt-00123-fix-login-timeout.md`).
- `num_ticket_interno` es una secuencia propia de `tickets/` dentro del proyecto — **reinicia por proyecto, igual que antes** — pero **ya no comparte número con el change** relacionado (a diferencia del modelo anterior, que forzaba el mismo `NNN` entre CC y ticket).
- Por defecto, **todo ticket produce o enlaza un change** (modos `link`/`create` de `/diana.ticket`); un ticket sin change (`standalone`) es la excepción explícita, no la regla.
- El ticket declara su relación mediante un campo `Relación -> change: <nombre-del-change>`, no mediante número compartido ni carpeta común.

---

## 6. Constitución del Proyecto (ajustado — sin alias)

Identificador y nombre obligatorio: `constitution.md` (sin prefijo de alias de proyecto).

Ubicación: `projects/<project>/constitution.md`.

Reglas (sin cambio respecto al modelo anterior):
- Existe una sola constitución activa por proyecto.
- Nace únicamente en proyectos greenfield.
- Cambia solo por decisión explícita de alto nivel.
- Speckit la lee como contexto, nunca la modifica.

---

## 7. Relación entre Change y Canon (reemplaza la antigua sección de `meta.md`)

**(ELIMINADO)** La relación CC ↔ Ticket ↔ Canon ya no se declara en un archivo `meta.md` libre y separado, coordinado solo por convención de número.

**(NUEVO)** La relación se declara dentro de `changes/<name>/context.md`, en su sección `Origen` (ticket relacionado, decisión estratégica si aplica) — es la misma fuente que `spec.md`/`plan.md` referencian, no un archivo aparte sin ejecutar.

Reglas:
- `context.md` es informativo en su sección de Origen/Tipo; no es ejecutable por Speckit.
- Speckit NO interpreta la sección Origen/Tipo de `context.md`, igual que antes no interpretaba `meta.md`.

---

## 8. Flujo Oficial en Proyectos Nuevos (Greenfield) — actualizado

1. `/diana.context scope="project"` — crea `context.md` del proyecto.
2. `/diana.new` — crea la estructura base (`changes/`, `tickets/`, `scrum/backlog/`, `knowledge/`, `prompts/`).
3. `/diana.context scope="change"` (o `/diana.change` directo) — crea `changes/<name>/context.md`.
4. `/diana.constitution` — crea `constitution.md`.
5. Entra Speckit:
   - `speckit.specify`
   - `speckit.clarify`
   - `speckit.plan`
   - `speckit.tasks`

Speckit NUNCA entra antes del paso 5.

---

## 9. Flujo en Evolución / Mantenimiento — actualizado

1. Un ticket o una decisión estratégica dispara un nuevo change.
2. `/diana.change` (o `/diana.ticket` con `relation_mode=create`) crea `changes/<name>/context.md`.
3. Se crea `spec.md` dentro de ese change (si cambia el "qué").
4. Se crea `plan.md`.
5. Speckit ejecuta.

Bugfix:
- No crea `spec.md` nuevo.
- No crea `constitution.md`.

---

## 10. Regla Final (actualizada)

Un proyecto aísla sus changes y tickets.
Un change gobierna su propio canon (`context`, `spec`, `plan`, `tasks`).
Un ticket es intake: produce o enlaza un change por defecto.
Los nombres de carpeta son los identificadores; ya no existen números `NNN` compuestos ni alias.
Speckit ejecuta exactamente lo definido en `changes/<name>/`.

---

## 11. Qué sigue igual vs. qué cambió (resumen explícito)

**Sigue igual:**
- Cada proyecto tiene su propia numeración — ahora aplica únicamente a la secuencia interna de `tickets/` (`num_ticket_interno`), no a los changes.
- Un proyecto no comparte canon con otro.
- Speckit solo ejecuta canon explícito, nunca infiere.

**Cambió / se eliminó:**
- Carpeta `governance/` (eliminada; `changes/` y `tickets/` van directo en la raíz del proyecto).
- Carpeta `initiatives/` (reemplazada por `changes/`).
- Esquema `<NNN>-<PROYECTO>-{CC,TKT,SPEC,PLAN,TASK}` (eliminado).
- Alias de 3 letras para nombrar archivos (eliminado por completo).
- `meta.md` como archivo libre separado (fusionado dentro de `context.md`).
- `governance/decision-log.md` (eliminado, no se conserva — no aportaba valor en el modelo actual).

---

## 12. Estado

Este documento define las Reglas Oficiales de Nomenclatura de Changes y Tickets por Proyecto en DIANA‑SDK by DRFIC. Es vinculante para todos los proyectos actuales y futuros.
