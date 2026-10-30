
# DIANA‑SDK by DRFIC
## Reglas Oficiales de Ciclo de Vida (Lifecycle)

---

## 1. Propósito

Este documento define las reglas oficiales de ciclo de vida de los artefactos
en DIANA‑SDK by DRFIC.

Su objetivo es:
- Evitar ambigüedad sobre cuándo crear o no crear documentos
- Distinguir proyectos nuevos, evolución y mantenimiento
- Proteger el canon de contaminación por tickets o cambios operativos
- Dar certeza a humanos y agentes IA sobre qué ejecutar

Estas reglas son obligatorias para todos los proyectos que adopten DIANA‑SDK.

> **Nota de versión**: la lógica de decisión de este documento (qué tipo de change es, qué artefactos nacen) **no cambia**. Lo único que cambia es dónde viven esos artefactos: ya no bajo `initiatives/<NNN-alias>/`, sino bajo `changes/<name>/` (para `spec.md`/`plan.md`/`tasks.md`); y los campos que antes vivían en `meta.md` ahora son secciones dentro de `changes/<name>/context.md`. `constitution.md` sigue en la raíz del proyecto, solo sin prefijo de alias.

---

## 2. Principio Rector del Ciclo de Vida

> **No todo cambio genera una especificación.**
> **No toda especificación genera una constitución.**
> **Todo lo que se ejecuta debe tener canon explícito.**

El ciclo de vida privilegia estabilidad del canon sobre velocidad improvisada.

---

## 3. Eventos de Origen (Qué detona trabajo)

En DIANA‑SDK existen únicamente tres eventos de origen válidos:

1. Ticket de usuario
2. Decisión estratégica explícita
3. Necesidad de proyecto nuevo (greenfield)

Estos eventos:
- Pertenecen a la dimensión organizacional
- No son ejecutables
- No definen por sí mismos artefactos SDD

---

## 4. Tipos de Change

Todo change pertenece exactamente a uno de los siguientes tipos:

- Proyecto nuevo (Greenfield)
- Evolución o mejora funcional (Brownfield)
- Corrección de errores (Bugfix)

El tipo de change **determina qué artefactos nacen**. Este tipo se declara dentro de la sección "Tipo" de `changes/<name>/context.md` (antes era un campo de `meta.md`).

---

## 5. Proyecto Nuevo (Greenfield)

### 5.1 Condiciones

Un change es considerado proyecto nuevo cuando:
- No existe sistema previo
- No existe canon funcional
- Se requiere definir visión, límites y principios

---

### 5.2 Artefactos que NACEN

Obligatorios:
- `constitution.md` (constitución del proyecto — vive en la raíz del proyecto: `projects/<project>/constitution.md`, sin prefijo de alias)
- `spec.md` (especificación canónica inicial — vive en `changes/<name>/spec.md`, p. ej. `changes/foundation/spec.md`)
- `plan.md` (plan técnico inicial — vive en `changes/<name>/plan.md`)

Opcionales:
- Artefactos de investigación
- Prototipos conceptuales

---

### 5.3 Artefactos que NO NACEN

- No existen changes previos
- No existen specs derivadas
- No existen tareas históricas

---

### 5.4 Convención recomendada

El change fundacional puede nombrarse, por ejemplo:

```
foundation
```

(Sin numeración `NNN`, sin alias — el nombre de carpeta `changes/foundation/` es la identidad completa.)

---

## 6. Evolución o Mejora Funcional (Brownfield)

### 6.1 Condiciones

Un change es evolución funcional cuando:
- El sistema ya existe
- Se solicita nuevo comportamiento o modificación
- Existe un ticket y/o una decisión estratégica asociada

---

### 6.2 Artefactos que NACEN

Obligatorios:
- `spec.md` (nueva especificación derivada — vive en `changes/<name>/spec.md`)
- `plan.md` (plan técnico del change — vive en `changes/<name>/plan.md`)

Opcionales:
- Ajustes al modelo de datos
- Nuevos contratos técnicos

---

### 6.3 Artefactos que NO NACEN

- NO nace nueva constitución
- NO se reescribe el canon fundacional

La constitución existente **se respeta y se referencia**.

---

### 6.4 Nombre del Change

Cada evolución funcional genera un nuevo change, identificado únicamente por su nombre de carpeta (sin numeración compartida):

```
changes/nueva-funcionalidad/
changes/mejora-ia/
```

---

## 7. Corrección de Errores (Bugfix)

### 7.1 Condiciones

Un change es bugfix cuando:
- Existe un ticket de error
- No cambia el comportamiento esperado
- El problema es de implementación, no de alcance

---

### 7.2 Artefactos que NACEN

Obligatorios:
- `plan.md` (plan técnico correctivo — vive en `changes/<name>/plan.md`)
- `tasks.md` (tareas de corrección — vive en `changes/<name>/tasks.md`)

Opcionales:
- Documento técnico de análisis del bug

---

### 7.3 Artefactos que NO NACEN

- NO nace constitución
- NO nace nueva especificación funcional
- NO se redefine el canon

El bugfix **corrige el código para cumplir el canon existente**.

---

## 8. Constitución de Proyecto

### 8.1 Cuándo NACE una constitución

Una constitución solo nace cuando:
- El proyecto es nuevo
- O existe un cambio explícito de filosofía, alcance o principios

Vive siempre en `projects/<project>/constitution.md` (raíz del proyecto, nunca dentro de `changes/`).

---

### 8.2 Cuándo NO nace una constitución

- Cambios funcionales
- Mejoras incrementales
- Corrección de errores
- Optimización técnica

La constitución es un evento **raro, consciente y deliberado**.

---

## 9. Especificación Canónica

### 9.1 Cuándo NACE una especificación

- En proyectos nuevos (`changes/foundation/spec.md`)
- En cambios funcionales autorizados
- Cuando el "qué" del sistema cambia

---

### 9.2 Cuándo NO nace una especificación

- Bugfix
- Refactor interno
- Ajustes técnicos sin impacto funcional

---

## 10. Plan Técnico

### 10.1 Cuándo NACE un plan técnico

- Siempre que exista un change
- Puede ser humano, generado o híbrido
- Vive en `changes/<name>/plan.md`

---

### 10.2 Relación con la especificación

- El plan implementa la spec
- El plan NO redefine alcance
- El plan puede evolucionar sin cambiar la spec

---

## 11. Relación con Herramientas (Speckit)

Reglas obligatorias:
- Speckit solo ejecuta changes
- Speckit no interpreta tickets ni decisiones estratégicas directamente
- Speckit opera únicamente sobre artefactos canónicos dentro de `changes/<name>/`
- Speckit no infiere requisitos ausentes

---

## 12. Contexto y Trazabilidad

Todo change debe incluir, dentro de su `context.md`, información que:
- Referencie el ticket relacionado (si aplica)
- Explique el contexto organizacional
- Declare el tipo de change (Greenfield/Brownfield/Bugfix)

Estos campos — antes agrupados en un archivo separado `meta.md` — **ahora viven dentro de `changes/<name>/context.md`** (secciones "Origen" y "Tipo"). Al igual que antes, esta información **nunca es ejecutable** por Speckit.

---

## 13. Regla Final del Ciclo de Vida

No todo problema genera una spec.
No toda spec genera una constitución.
Todo lo que se ejecuta debe respetar el canon.

---

## 14. Estado

Este documento define el **ciclo de vida oficial de DIANA‑SDK by DRFIC**
y es vinculante para todos los proyectos que adopten este framework.

---
