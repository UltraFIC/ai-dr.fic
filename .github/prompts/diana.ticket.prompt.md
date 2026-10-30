---
agent: diana.ticket
description: Crea tickets de servicio canonicos en el pool compartido .drfic/tickets/<project>/ (agrupados por proyecto, numeracion interna por proyecto) con 1-4 palabras descriptivas en el nombre de archivo; por defecto SIEMPRE produce o enlaza un change (standalone es un opt-out explicito).
---

# /diana.ticket - Ticket de Servicio

## Uso

/diana.ticket project="inversions" title="Validar flujo de pago" description="Revisar errores 500 en checkout"
/diana.ticket project="inversions" --input "docs/tickets/incidente-checkout.md"
/diana.ticket project="inversions" relation_mode="link" change_ref="mfa-accesos-criticos" title="Seguimiento MFA"
/diana.ticket project="inversions" relation_mode="create" title="Timeout en login" description="Sesion expira antes de tiempo"
/diana.ticket project="inversions" relation_mode="standalone" title="Pregunta de soporte sin seguimiento de ingenieria"

## Argumentos

| Argumento | Valores | Default | Descripcion |
|-----------|---------|---------|-------------|
| action | create \| validate | create | Crea o valida tickets |
| project | string | requerido | Proyecto Diana al que se relaciona el ticket (ya debe existir). Determina la subcarpeta de guardado dentro del pool compartido: `.drfic/tickets/<project>/` |
| input | ruta markdown | null | Fuente completa de contenido |
| title | string | null | Titulo del ticket (si no hay `input`) |
| description | string | null | Descripcion del ticket (si no hay `input`) |
| content | string | null | Cuerpo completo inline del ticket |
| relation_mode | link \| create \| standalone | **`link` si hay `change_ref`; `create` si no hay `change_ref`** | Ver "Modos de Relacion" |
| change_ref | string (nombre de change existente) | null | Requerido cuando `relation_mode=link` |
| priority | high \| medium \| low | medium | Prioridad del ticket |

## Objetivo

Crear tickets de servicio canonicos en el pool compartido `.drfic/tickets/` (carpeta top-level, hermana de `.drfic/diana/`, fuera del arbol de gobernanza de cada proyecto), agrupados en una subcarpeta por proyecto (`.drfic/tickets/<project>/`), garantizando por defecto que todo ticket produzca o enlace un change — un ticket "en el aire" sin change es la excepcion, no la regla.

## Modos de Relacion

1. `link` (default cuando se pasa `change_ref`):
   - Requiere `change_ref` apuntando a un change EXISTENTE (`changes/<change_ref>/context.md` ya debe existir).
   - El ticket referencia explicitamente a ese change.

2. `create` (default cuando NO se pasa `change_ref` ni `relation_mode="standalone"`):
   - Crea automaticamente un change nuevo (`changes/<name-derivado-del-ticket>/context.md`) sembrado desde el `title`/`description`/`input` del ticket (equivalente a invocar `/diana.context scope="change"` con ese contenido).
   - El ticket referencia al change recien creado.

3. `standalone` (opt-out explicito, debe pasarse manualmente):
   - No crea ni enlaza ningun change.
   - Ticket autonomo — reservado para casos que genuinamente no requieren seguimiento de ingenieria (ej. preguntas de soporte).

## Reglas de Resolucion de Contenido

Prioridad para contenido del ticket:

1. Si existe `--input`, usar el contenido completo del archivo.
2. Si no hay `input` y existe `content`, usar `content`.
3. Si no hay `input` ni `content`, usar plantilla minima con `title`, `description`, `priority`.
4. Si falta informacion minima, detener con error accionable.

## Reglas de Numeracion y Nombre de Archivo

1. Buscar en `.drfic/tickets/<project>/` (subcarpeta del proyecto dentro del pool compartido).
2. Detectar el mayor `num_ticket_interno` existente escaneando los archivos `tkt-<num>-*.md` DENTRO de esa subcarpeta de proyecto (la secuencia es por proyecto, no global al repo).
3. Usar `num_ticket_interno + 1` para el nuevo ticket.
4. Derivar 1-4 palabras descriptivas en kebab-case desde `title` (o desde `change_ref`/el change creado si no hay `title` claro).
5. Ticket resultante: `tkt-<num_ticket_interno>-<1-4 palabras>.md` (ej. `tkt-00123-fix-login-timeout.md`).

Nota: esta numeracion es exclusivamente del ticket, por proyecto (no tiene relacion con el nombre del change, a diferencia del modelo anterior que forzaba el mismo `NNN` entre UCC y ticket).

## Estructura de Salida

- `.drfic/tickets/<project>/tkt-<num_ticket_interno>-<palabras>.md` (pool compartido top-level, agrupado por proyecto — no `.drfic/diana/projects/<project>/tickets/`)
- Si `relation_mode=create`: ademas `.drfic/diana/projects/<project>/changes/<name-derivado>/context.md` (el change sigue viviendo dentro del proyecto correspondiente — solo la ubicacion del ticket cambio de raiz)

## Plantilla Minima Ticket (si no hay input)

```markdown
# Ticket de Servicio
## tkt-<num_ticket_interno>-<palabras>

## Titulo
<title>

## Solicitud
<description>

## Prioridad
<priority>

## Relacion
- project: <project>
- change: <change_ref o nombre del change creado, o "N/A" si standalone>

## Estado
- OPEN
```

## Action=create

- Resolver `project`.
- Resolver `relation_mode` segun regla de default (ver tabla de argumentos).
- Si `relation_mode=link`, validar que `change_ref` exista; si no, detener con error.
- Si `relation_mode=create`, crear el change enlazado primero (via la misma logica de `/diana.context scope="change"`).
- Resolver contenido del ticket.
- Crear ticket con numeracion interna secuencial (por proyecto) y nombre descriptivo.
- Reportar ruta, numero de ticket y change relacionado (si aplica).

## Action=validate

Verificar:
- Naming correcto `tkt-<num_ticket_interno>-<1-4 palabras>.md`.
- Si `relation_mode in (link,create)`, el change referenciado existe.
- Numeracion interna (por proyecto) sin colision.

Devolver:
- `OK: [n]`
- `GAPS: [n]`
- Acciones sugeridas.

## Hooks de Extension

Antes de crear, revisar `.specify/extensions.yml` en `hooks.before_ticket`.
Despues de crear, revisar `.specify/extensions.yml` en `hooks.after_ticket`.
Aplicar politica `optional/enabled` equivalente a otras acciones Diana.
