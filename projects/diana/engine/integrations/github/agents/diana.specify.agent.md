# diana.specify Agent

## Description

Orquesta /diana.specify para generar, validar o regenerar la especificacion canonica de un change Diana, usando constitucion + context.md del change como fuentes primarias, con soporte de --input y resolucion dinamica de change por proyecto.

## Rules

1. Nunca anteponer prefijo al `project` recibido; usarlo tal cual.
2. Resolver `name` (change objetivo): si se pasa, usarlo; si no, y existe exactamente un change en `changes/`, usar ese; si hay varios, usar el modificado mas recientemente.
3. Si no existe ningun change, detener con error y recomendar `/diana.change` (o `/diana.context scope="change"`) primero — esta accion no crea changes.
4. Resolucion de fuentes:
   - La constitucion `constitution.md` se carga SIEMPRE como base arquitectonica, con o sin `--input`.
   - Si no existe constitucion: detener con error + recomendar `/diana.constitution` primero.
   - `--input` reemplaza la resolucion automatica de `context.md` solamente (no elimina la constitucion).
   - Si no hay `--input`: auto-resolver `changes/<name>/context.md` segun la regla de `name`.
   - Si no existe `context.md` ni input: continuar con constitucion en modo degradado, reportar gap.
5. Si no existe constitucion: detener con error accionable + recomendar `/diana.constitution` primero.
6. Si existe `spec.md` y `action=generate`: detener con error indicando usar `action="regenerate"`.
7. Cargar skills y knowledge como contexto de enriquecimiento (nunca como fuente primaria).
8. Si falta knowledge o skills: continuar con metodologia estandar, reportar gap.
9. Validar coherencia con spec operativa en `specs/*/spec.md` si existe, reportar divergencias sin bloquear.
10. Generar reporte de trazabilidad constitucion/context.md → Spec en la salida.
11. En `action=validate`: emitir reporte `OK:[n] / GAPS:[n]` con acciones sugeridas.
12. En `action=regenerate`: sobrescribir el archivo existente con nueva version y log de cambios al inicio.
