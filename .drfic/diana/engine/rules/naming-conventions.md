
# DIANA‑SDK by DRFIC
## Reglas Oficiales de Nomenclatura (SDD)

---

## 1. Propósito

Este documento define las reglas oficiales de nomenclatura de DIANA‑SDK by DRFIC.

Su objetivo es:
- Garantizar coherencia documental
- Evitar ambigüedades para agentes IA
- Permitir escalabilidad a múltiples proyectos
- Mantener compatibilidad con frameworks SDD como Speckit

Estas reglas son de cumplimiento obligatorio en todos los proyectos
que adopten DIANA‑SDK.

---

## 2. Principio Rector

En DIANA‑SDK, los nombres indican autoridad y contexto, no solo orden.

La nomenclatura define:
- Qué documento manda
- Qué artefacto es ejecutable
- Qué información es solo referencial

---

## 3. Jerarquía Canónica

La jerarquía obligatoria es:

DRFIC (organización / programa)
→ Proyecto
→ Change
→ Artefactos SDD

Cada nivel tiene responsabilidades distintas y no intercambiables.

---

## 4. Organización / Programa (DRFIC)

Representa:
- La empresa
- El programa estratégico
- El dueño de la metodología DIANA‑SDK

Reglas:
- No representa proyectos
- No contiene especificaciones ejecutables
- Contiene únicamente gobernanza transversal

---

## 5. Proyecto

Un proyecto es un producto o sistema con ciclo de vida propio.

**Convención obligatoria de nombre (NUEVO):**

1‑2 palabras significativas, lowercase, sin prefijo forzado.

Ejemplos válidos:
- inversions
- market lab -> `market-lab`
- risk engine -> `risk-engine`
- sdk core -> `sdk-core`

Reglas:
- Sin espacios (usar guion si son dos palabras)
- Sin mayúsculas
- Sin versiones
- Sin tickets
- **(ELIMINADO)** Ya no se exige el prefijo forzado `diana-<proyecto>` ni la convención `<dominio>-<producto>`. El nombre del proyecto es la única identidad; no lleva prefijo de programa ni de dominio.

---

## 6. Change (Unidad SDD) — antes "Iniciativa"

El **change** es la unidad fundamental de trabajo en DIANA‑SDK. Este concepto reemplaza por completo a la antigua "iniciativa" (`initiatives/<NNN-alias>/`).

**Identidad (NUEVO):**

La identidad de un change es, exclusivamente, el **nombre de su carpeta** bajo `changes/`: `changes/<name>/`.

Reglas:
- `<name>`: 1‑2 palabras significativas, lowercase, que describen el propósito del change.
- **(ELIMINADO)** No existe numeración `NNN-descripcion-corta`. Un change no lleva número secuencial ni alias de proyecto en su nombre.
- No usar tickets, CR ni fechas en el nombre.
- Un change pertenece a un solo proyecto.

Ejemplos válidos (antes `001-foundation`, `002-user-auth`, ahora):
- `foundation`
- `user-auth`
- `chat-ia`
- `fix-login-timeout`

---

## 7. Archivos Canónicos de un Change

Los nombres de archivos dentro de `changes/<name>/` son fijos:

```
context.md
spec.md
plan.md
tasks.md
```

Significado:
- `context.md`: contexto organizacional y de negocio (tipo de change, origen, alcance, riesgos). **No ejecutable.** Reemplaza tanto a la antigua plantilla de UCC como a `meta.md` — **(ELIMINADO)** `meta.md` ya no existe como archivo separado; sus campos ("Tipo de Iniciativa", "Origen Organizacional") ahora son secciones dentro de `context.md`.
- `spec.md`: autoridad funcional.
- `plan.md`: autoridad técnica.
- `tasks.md`: backlog canónico derivado del plan.

`constitution.md` sigue existiendo, pero vive en la **raíz del proyecto** (`projects/<project>/constitution.md`), no dentro de un change — ver sección 8.

---

## 8. Proyecto Nuevo vs Mantenimiento

Proyecto nuevo:
- Se crea `constitution.md` en la raíz del proyecto.
- El primer change suele llamarse `foundation` (sin número).

Evolución funcional:
- No se crea nueva constitución.
- Se crea un nuevo change.

Corrección de errores:
- No se crea constitución.
- No se crea `spec.md` funcional nueva.
- El change es técnico (solo `plan.md`/`tasks.md`).

---

## 9. Idioma Oficial

Idioma principal:
- Español

Permitido en inglés:
- Identificadores técnicos
- Acrónimos
- Estándares

Los nombres de carpetas se mantienen en inglés técnico
por compatibilidad con tooling.

---

## 10. Regla Final

Proyecto define el sistema.
Change define el cambio.
Canon define la verdad.
Herramientas ejecutan, no deciden.

---
