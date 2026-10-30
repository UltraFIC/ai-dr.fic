---
agent: diana.specify
description: Genera, valida o regenera la especificacion canonica de un change Diana, usando como fuente principal la constitucion del proyecto y el context.md del change, enriquecida por skills y knowledge.
---

# /diana.specify — Generador de Especificacion Canonica Diana

## Uso

/diana.specify action="generate"
/diana.specify action="validate"
/diana.specify action="regenerate"
/diana.specify project="inversions"

Con entrada explicita:

/diana.specify action="generate" --input ".drfic/diana/projects/inversions/changes/mfa-accesos-criticos/context.md"

Con change especifico:

/diana.specify project="inversions" name="mfa-accesos-criticos" title="Plataforma de Inversiones con IA"

## Argumentos

| Argumento | Valores | Default | Descripcion |
|-----------|---------|---------|-------------|
| action | generate \| validate \| regenerate | generate | Operacion sobre la spec |
| project | id en projects-knowledge-radar | inversions | Proyecto objetivo |
| name | string (nombre de change ya existente) | auto-detect | Change objetivo dentro de `changes/`; se auto-detecta si se omite |
| input | ruta de archivo markdown | null | Override de fuente primaria para la spec |
| title | string | null | Titulo de la spec si no hay fuente disponible |
| description | string | null | Descripcion base si no hay fuente disponible |

## Comportamiento por default (si omites argumentos)

- Si omites `action`, se usa `action="generate"`.
- Si omites `project`, se usa `project="inversions"`.
- Si omites `name`, se auto-detecta el change leyendo las carpetas en `changes/`: si existe una sola, se usa esa; si hay varias, se usa la modificada mas recientemente (por `context.md`).
- Si no existe ningun change en `changes/`, detener con error y recomendar `/diana.change` (o `/diana.context scope="change"`) primero.

## Objetivo

Producir una especificacion funcional canonica, trazable y validable para un change del proyecto Diana, derivada principalmente de la constitucion y el `context.md` del change, enriquecida por knowledge y skills, coherente con la spec operativa en `specs/`.

## Regla de Fuentes (obligatoria, en orden de prioridad)

> La **constitucion canonica siempre se carga**, independientemente de si se pasa `--input` o no.
> `--input` reemplaza unicamente la resolucion automatica de `context.md`, no elimina la lectura de la constitucion.

**Fuente arquitectonica (siempre obligatoria)**:
- `.drfic/diana/projects/<project>/constitution.md` — base constitucional del proyecto.
  - Si no existe constitucion, detener con error y recomendar `/diana.constitution` primero.

**Fuente de cambio/alcance (en orden)**:
1. Si se pasa `--input`, usar ese archivo como el documento de cambio/contexto principal (en lugar del `context.md` auto-detectado).
2. Si no hay `--input`, auto-resolver el change:
   - `.drfic/diana/projects/<project>/changes/<name>/context.md`
   - Resolver `name` segun la regla de default (explicito, unico existente, o el modificado mas recientemente).
3. Si no existe ni input ni `context.md` del change, continuar solo con constitucion (degradado, reportar el gap).

**Fallback minimo**:
- Si no hay constitucion ni input ni `context.md`, usar `title` + `description` como contenido base.
- Si no hay suficiente informacion ni para esto, detener con error accionable.

## Fuentes de Enriquecimiento (no sustituyen fuente primaria)

Cargar como contexto adicional para mayor precision:

- `.drfic/diana/projects/<project>/capabilities/manifest.yaml`
- `.drfic/diana/projects/<project>/capabilities/agent-skill-matrix.yaml`
- `.drfic/knowledge/` (arbol compartido entre proyectos; escaneo directo del arbol de conocimiento, sin indice paralelo)
- `specs/*/spec.md` — spec operativa existente (si hay) para validacion cruzada y coherencia.

Si falta knowledge o skills, continuar con metodologia estandar y reportar gap.

## Reglas de Resolucion de Change

1. Buscar carpetas en `.drfic/diana/projects/<project>/changes/`.
2. Si se pasa `name` y existe `changes/<name>/`, usar ese directorio.
3. Si no se pasa `name`: si existe exactamente un change, usarlo; si hay varios, usar el modificado mas recientemente.
4. Si no existe ningun change, detener con error y recomendar `/diana.change` (o `/diana.context scope="change"`) primero — esta accion no crea changes nuevos.
5. El archivo de spec resultante: `spec.md` dentro de `changes/<name>/`.

## Salidas Obligatorias

1. Spec canonica del change:
   - `.drfic/diana/projects/<project>/changes/<name>/spec.md`

2. Reporte de trazabilidad constitucion/context.md → Spec (en salida):
   - Principios constitucionales reflejados en la spec.
   - Cambios del `context.md` incorporados como requisitos.
   - Gaps detectados y decision tomada.

3. Reporte de validacion (solo en `action=validate`):
   - `OK: [n]` — secciones consistentes.
   - `GAPS: [n]` — secciones con discrepancias.
   - Acciones sugeridas.

4. Reporte de coherencia con spec operativa (si existe `specs/*/spec.md`):
   - Divergencias detectadas entre spec canonica y spec operativa.
   - Recomendacion: alinear operativa o actualizar canonica.

## Plantilla Minima de Spec (resultado esperado)

El resultado debe incluir al menos:

```markdown
# Especificacion: <titulo>

**Change**: <name>
**Proyecto**: <project>
**Version**: 1.0
**Estado**: Draft
**Fuente**: <fuente primaria utilizada>

## Objetivo

<objetivo principal del change>

## Alcance Funcional

- RF-001: <requisito funcional>

## Alcance No Funcional

- RNF-001: <requisito no funcional>

## Restricciones

- <restriccion derivada de constitucion o context.md>

## Supuestos

- <supuesto clave>

## Criterios de Exito

- <criterio medible>

## Trazabilidad

- Principios constitucionales: <lista>
- Context.md de origen: <changes/<name>/context.md>
```

## Flujo de Integracion Diana

```
/diana.context   → Captura nombre y contexto inicial (proyecto o change)
/diana.new       → Bootstrap de estructura del proyecto
/diana.change    → Crear changes/<name>/context.md (+ ticket opcional)
/diana.constitution → Generar constitucion desde context.md
/diana.specify   ← (estas aqui) → Generar spec canonica desde constitucion + context.md
/diana.skills    → Generar skills desde constitucion + spec
/diana.knowledge → Enriquecer knowledge base
/diana.plan      → Generar plan tecnico desde spec + skills + knowledge
/speckit.plan    → Plan operativo de implementacion
```

## Errores Comunes y Soluciones

| Error | Causa | Solucion |
|-------|-------|----------|
| "Constitucion no encontrada" | No existe `constitution.md` | Ejecutar `/diana.constitution` primero |
| "Context.md no encontrado" | No existe `changes/<name>/context.md` | Ejecutar `/diana.change` (o `/diana.context scope="change"`) primero |
| "Change ambiguo" | Multiples changes y se quiere forzar uno distinto al mas reciente | Pasar `name="<nombre-del-change>"` explicitamente |
| "Spec ya existe" | Existe `spec.md` y `action=generate` | Usar `action="regenerate"` para sobrescribir |
