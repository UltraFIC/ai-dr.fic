# Contexto
## <nombre>

> Plantilla unica de contexto Diana. Aplica tanto a scope=project (`projects/<project>/context.md`) como a scope=change (`projects/<project>/changes/<name>/context.md`). Reemplaza las antiguas plantillas separadas de UCC y de `meta.md`: no existen archivos `meta.md` ni `NNN-<alias>-ucc.md` en el modelo actual.

---

## Titulo
<title>

## Contexto
<description>

## Alcance
- Definir alcance funcional

## Impacto Esperado
- Impacto en procesos, sistema o usuarios

## Riesgos
- Riesgo 1

## Estado
- Draft

---

## Tipo (solo scope=change)

- [ ] Proyecto nuevo (Greenfield)
- [ ] Evolucion funcional (Brownfield)
- [ ] Correccion de errores (Bugfix)

## Origen (solo scope=change)

- Ticket relacionado: <tkt-ref o "N/A">
- Decision estrategica: <si aplica>

---

## Reglas

- Este archivo es la fuente canonica de contexto de su scope (proyecto o change).
- No es ejecutable por herramientas SDD; no define alcance tecnico detallado (eso vive en `spec.md`/`plan.md`).
- No usar alias ni numeracion secuencial para nombrar este archivo: su identidad es el nombre de carpeta del proyecto o change.
