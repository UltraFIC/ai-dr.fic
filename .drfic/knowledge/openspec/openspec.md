# OpenSpec: guia operativa y de referencia

**Investigacion actualizada:** 2026-10-07  
**Version instalada en este proyecto:** OpenSpec 1.14.1 (npm global)  
**Esquema local:** `spec-driven`

Esta guia resume el funcionamiento de OpenSpec y lo adapta al proyecto `ai-app`. Se contrasto la documentacion publicada por el proyecto OpenSpec y se comprobo el estado del CLI, la configuracion y los prompts generados localmente. El repositorio oficial cambia con frecuencia; consulta las fuentes al final antes de depender de opciones nuevas.

## Que es OpenSpec

OpenSpec es un marco de trabajo de desarrollo guiado por especificaciones para colaborar con agentes de programacion. Conserva en el propio proyecto el comportamiento acordado, las modificaciones propuestas, las decisiones tecnicas y las tareas de implementacion. Su objetivo es reducir la ambiguedad entre una solicitud y el codigo que finalmente se escribe.

No reemplaza al agente, al sistema de pruebas, a Git ni a la revision humana. El CLI organiza y valida artefactos; el agente de programacion que ya proporciona el editor interpreta las instrucciones y trabaja en el codigo; las pruebas y la revision confirman el comportamiento real. OpenSpec no es por si mismo un agente de IA ni un sistema que coordine subagentes.

La idea central es **acciones iterativas, no fases rigidas**. Los artefactos tienen dependencias para que el agente disponga de contexto, pero durante el trabajo se pueden revisar propuestas, especificaciones y disenos si el codigo o una investigacion revelan nueva informacion.

## Modelo mental

- `openspec/specs/` contiene las especificaciones vigentes del sistema, organizadas por dominio. Es la referencia de lo que el sistema debe hacer hoy.
- `openspec/changes/<nombre>/` contiene una propuesta de cambio y sus artefactos de planificacion. Cada cambio debe representar una unidad logica de trabajo.
- `openspec/changes/<nombre>/specs/` contiene **delta specs**: solo los requisitos que se agregan, modifican o eliminan. No se copia la especificacion completa del sistema.
- `openspec/changes/archive/` conserva los cambios finalizados como historial. Al archivar, OpenSpec puede integrar los delta specs en las especificaciones vigentes.

La especificacion vigente y el delta tienen funciones distintas: la primera describe el comportamiento completo actual de un dominio; el segundo documenta la diferencia que introduce un cambio concreto.

### Artefactos del esquema `spec-driven`

| Artefacto | Pregunta que responde | Contenido esperado |
| --- | --- | --- |
| `proposal.md` | Por que y que cambia? | Problema, intencion, alcance, exclusiones e impacto. |
| `specs/**/*.md` | Que comportamiento observable debe cambiar? | Requisitos y escenarios concretos bajo `ADDED`, `MODIFIED` o `REMOVED`. |
| `design.md` | Como se implementara? | Enfoque tecnico, componentes afectados, decisiones, riesgos e integraciones. |
| `tasks.md` | Que pasos verificables hacen falta? | Lista de trabajo ordenada, pequena y marcable, incluyendo pruebas. |

En el esquema por defecto, propuesta habilita especificaciones y diseno; las tareas dependen de las especificaciones y el diseno. Al completar tareas, el agente puede implementar. Es una guia de dependencias, no una prohibicion de volver atras.

## Flujo recomendado

### 1. Aclarar la idea

Usa la exploracion cuando el problema o la solucion no estan claros. En VS Code con GitHub Copilot, los prompts locales generados por OpenSpec tienen nombres `opsx-*.prompt.md`; segun la integracion, la invocacion aparece como `/opsx-explore`. Explorar sirve para inspeccionar el codigo existente, comparar alternativas y delimitar el problema antes de comprometer un plan. No implementa codigo. Puede crear o revisar artefactos de planificacion si el usuario lo pide o acepta expresamente esa propuesta; por tanto, no debe describirse como una accion que nunca escribe archivos.

### 2. Proponer el cambio

Inicia una propuesta con el comando OPSX de tu agente. En GitHub Copilot IDE, OpenSpec normalmente usa `/opsx-propose`; otras herramientas pueden usar `/opsx:propose`, `@opsx-propose` o el nombre de una skill. Describe el resultado y las restricciones, no solo la tecnologia que imaginas usar.

Revisa los artefactos generados antes de implementar. Comprueba que el problema es real, el alcance es acotado, las especificaciones describen resultados observables y las tareas incluyen las pruebas apropiadas. Corrige las suposiciones antes de dejar que el agente programe.

### 3. Implementar e iterar

Invoca la accion OPSX de aplicar, por ejemplo `/opsx-apply` en esta configuracion de Copilot. El agente debe leer el cambio, consultar el codigo relevante, ejecutar las tareas en orden razonable, actualizar las casillas y ejecutar comprobaciones.

Si la implementacion descubre un requisito que falta o un diseno incorrecto, pausa y actualiza los artefactos afectados; despues continua. No mantengas un plan que ya sabes que es falso. Si la intencion o el objetivo fundamental cambiaron, suele ser mas claro crear un cambio nuevo.

### 4. Verificar y archivar

Antes de cerrar, revisa que el codigo corresponda a la especificacion y que las tareas esten completas. Ejecuta pruebas y validacion. La accion de verificacion del agente ayuda a detectar diferencias de completitud, correccion y coherencia, pero no reemplaza las pruebas automatizadas ni la revision humana.

Sincronizar las especificaciones delta con `openspec/specs/` y archivar el cambio son acciones relacionadas pero distinguibles. El archivado suele ofrecer sincronizar primero si es necesario y mueve el cambio al historial. No archives un cambio solo para ocultar trabajo incompleto.

## Comandos: terminal y chat son distintos

Los comandos `openspec ...` se ejecutan en PowerShell o en el terminal de VS Code. Los comandos `/opsx...` se escriben en el chat del agente. No existe un modo interactivo separado que se deba iniciar para escribir codigo.

### CLI de terminal

| Comando | Uso |
| --- | --- |
| `openspec init` | Inicializar OpenSpec y seleccionar integraciones de agentes. |
| `openspec update` | Regenerar instrucciones, prompts o skills administrados por OpenSpec. |
| `openspec version` | Mostrar la version instalada y si hay una actualizacion disponible. |
| `openspec list` | Ver cambios activos; `openspec list --specs` lista especificaciones. |
| `openspec show <nombre>` | Mostrar informacion de un cambio o especificacion. |
| `openspec status --change <nombre>` | Consultar estado de artefactos del cambio. `--json` sirve para automatizacion. |
| `openspec validate <nombre> --strict` | Validar un cambio en modo estricto. `--all`, `--changes` y `--specs` permiten ampliar el alcance. |
| `openspec view` | Abrir el panel interactivo de especificaciones y cambios. |
| `openspec doctor` | Diagnosticar la salud del root OpenSpec y sus referencias. |
| `openspec context` | Mostrar el contexto OpenSpec resuelto para el directorio actual. |
| `openspec schemas` | Listar los esquemas disponibles. |
| `openspec instructions <artefacto> --change <nombre> --json` | Obtener instrucciones enriquecidas para un artefacto u operacion. |
| `openspec new change <nombre>` | Crear el directorio y metadatos de un cambio sin generar todos sus artefactos. |
| `openspec templates --schema <esquema>` | Consultar las rutas de las plantillas que resuelve el esquema. |
| `openspec version --check --json` | Consultar informacion estructurada de version/actualizacion; `openspec version` informa version y tipo de instalacion. |
| `openspec list --archived` / `--all` | Incluir cambios archivados o combinar activos y archivados. |
| `openspec validate --archived` | Comprobar que los cambios archivados tengan todas las tareas marcadas; no vuelve a validar sus deltas. |
| `openspec store ...` | Registrar y administrar repositorios OpenSpec independientes en esta maquina. |
| `openspec workset ...` | Crear, listar, abrir y quitar vistas de trabajo personales y locales. |
| `openspec schema ...` | Crear, bifurcar, validar y resolver esquemas personalizados. |
| `openspec completion ...` | Generar, instalar o quitar autocompletado del shell. |

`openspec change list` existe por compatibilidad, pero esta deprecado; usa `openspec list`. `store` y `workset` forman parte de la superficie beta documentada por OpenSpec: su forma y opciones pueden cambiar entre versiones. `store remove` elimina la carpeta local del store, mientras que `workset remove` solo quita la vista guardada, no sus carpetas miembro. Los comandos de esquema, perfil y configuracion tambien se administran desde el CLI. Consulta `openspec <comando> --help` para las opciones exactas de la version instalada.

### Acciones del agente

Los nombres canonicos de la documentacion no siempre coinciden con la sintaxis de cada editor. La documentacion de OpenSpec identifica GitHub Copilot IDE con prompts de la forma `/opsx-propose`, mientras que otros editores pueden exponer `/opsx:propose`. Usa la forma que aparece en el autocompletado y en los archivos locales del agente; no pegues una accion de chat en el terminal.

En este proyecto existen prompts bajo `.github/prompts/` para `apply`, `archive`, `bulk-archive`, `continue`, `explore`, `ff`, `new`, `onboard`, `propose`, `sync` y `verify`. Hay skills correspondientes bajo `.github/skills/`. El perfil global esta configurado como `custom` y no incluye el workflow `update`, por eso no aparece un prompt o skill dedicado. `openspec update` solo regenera los workflows habilitados; para incluir `update`, selecciona un perfil o una configuracion de workflows que lo contenga mediante `openspec config profile` y luego ejecuta `openspec update`.

### Que son los agentes, las skills y las integraciones

- El agente es el producto de IA que ejecuta el flujo (en este proyecto, GitHub Copilot). OpenSpec le entrega instrucciones y herramientas deterministas del CLI; no incluye un agente conversacional propio ni crea o coordina subagentes.
- Las skills `openspec-*` son archivos de instrucciones que el CLI genera para que un agente compatible aprenda cada workflow. Los archivos de comandos/prompts son adaptadores propios de cada editor. No son procesos de IA independientes ni garantizan que el agente siga cada paso correctamente.
- OpenSpec integra muchos asistentes mediante archivos generados por `openspec init` y `openspec update`. La sintaxis depende de lo que lea cada herramienta: por ejemplo, las extensiones IDE de Copilot reconocen `.github/prompts/*.prompt.md` como comandos, mientras Copilot CLI no consume esos archivos directamente.
- En este proyecto, `delivery: both` significa que OpenSpec genera skills y prompts. Hay 11 de cada tipo, correspondientes a los 11 workflows configurados; no hay un workflow local `update` instalado. `githubCopilot.cloudAgent: true` habilita la configuracion del agente alojado de GitHub; esta es distinta del agente Copilot dentro del IDE. Sus archivos locales detectados son `.github/agents/openspec.agent.md` y `.github/workflows/copilot-setup-steps.yml`.
- OpenSpec no proporciona una integracion MCP nativa documentada en la version comprobada. La busqueda en la documentacion y el repositorio oficial solo encontro una propuesta archivada sobre MCP, no una capacidad publicada. Un servidor MCP puede ser ofrecido por Copilot, una extension u otra herramienta externa; eso no lo convierte en una funcion de OpenSpec. Verifica el servidor y su configuracion por separado.
- Skills de terceros pueden coexistir en el mismo agente, pero OpenSpec no las administra ni las invoca automaticamente como subagentes. Hay esquemas comunitarios que conectan workflows con herramientas externas, por ejemplo `superpowers-bridge`; son proyectos independientes, con requisitos y mantenimiento propios. Revisa el esquema y su procedencia antes de instalarlo.

## Especificar bien

Un requisito util describe una capacidad o regla observable, no una receta de codigo. Los escenarios concretan el comportamiento con condiciones, accion y resultado; el formato habitual es Given/When/Then (Dado/Cuando/Entonces).

Ejemplo de delta spec:

```markdown
## ADDED Requirements

### Requirement: Guardar una puntuacion
El sistema MUST conservar la puntuacion mas alta del jugador.

#### Scenario: Nueva puntuacion supera el record
- GIVEN que el jugador tiene un record de 120 puntos
- WHEN termina una partida con 150 puntos
- THEN el nuevo record es 150 puntos
```

Usa `## MODIFIED Requirements` para reemplazar un requisito existente con su nueva version, y `## REMOVED Requirements` para retirar uno obsoleto. Asegura que el nombre del requisito modificado corresponda a uno existente y que los escenarios describan de forma verificable el cambio.

Para cambios en proyectos existentes, inspecciona primero la implementacion y las especificaciones actuales. Agrega o corrige especificaciones por dominio conforme sea necesario; no hace falta documentar todo el producto antes de proponer una mejora puntual.

## Configuracion y personalizacion

La configuracion local esta en `openspec/config.yaml`:

Este extracto muestra la forma de las claves principales; las reglas y guias reales de este proyecto son mas extensas:

```yaml
schema: spec-driven
context: |
  Contexto estable del proyecto que OpenSpec inyecta en las instrucciones.
rules:
  proposal:
    - Reglas especificas para propuestas
  specs:
    - Reglas especificas para especificaciones
operations:
  apply:
    guidance:
      - Orientacion para la implementacion
  archive:
    guidance:
      - Orientacion para archivar
githubCopilot:
  cloudAgent: true
```

En OpenSpec, `schema` elige el flujo predeterminado. El campo opcional `context` agrega contexto estable del proyecto a las instrucciones de los artefactos; `rules` permite reglas por artefacto; `operations.apply.guidance` y `operations.archive.guidance` aportan orientacion para esas operaciones. Mantener estas reglas breves y especificas evita sobrecargar los prompts. `githubCopilot.cloudAgent` registra la decision de habilitar la configuracion del agente de codificacion alojado de GitHub Copilot.

La resolucion del esquema da prioridad a una opcion explicita del CLI, despues al metadato del cambio, luego a `openspec/config.yaml` y finalmente al esquema predeterminado. Si el equipo necesita otro proceso, se puede crear o bifurcar un esquema con `schema.yaml` y plantillas Markdown bajo `openspec/schemas/<nombre>/`; valida el esquema antes de adoptarlo.

Los archivos generados por OpenSpec son instrucciones para el agente, no una especificacion infalible. Evita modificar archivos administrados directamente si `openspec update` los va a regenerar; para cambiar el flujo, edita la configuracion, el esquema o las plantillas segun corresponda. La documentacion de requisito admite hasta 500 caracteres como guia; desde OpenSpec 1.14.1, uno que exceda ese limite genera una advertencia y `openspec validate --strict` falla. La validacion estructural no demuestra que el requisito sea correcto ni que la implementacion lo cumpla.

## Validacion y limites

- `openspec validate` encuentra problemas de formato o estructura en cambios y especificaciones. No demuestra por si solo que la funcionalidad sea correcta.
- El estado de tareas es una lista de seguimiento escrita en `tasks.md`; una casilla marcada no prueba que el comportamiento se haya probado.
- La verificacion del agente compara artefactos e implementacion, pero puede pasar por alto defectos. Complementala con pruebas, lint, build, revision de diff y comprobacion de requisitos relevantes.
- La sincronizacion/archivado afecta las especificaciones vigentes. Revisa los delta specs antes de aceptar el merge, especialmente si hay cambios paralelos sobre el mismo dominio.
- Las especificaciones son documentacion de comportamiento, no una copia del codigo ni una lista exhaustiva de detalles internos.
- Para una correccion trivial y autoevidente, el costo de un cambio formal puede ser mayor que su beneficio. Usa el proceso completo cuando el alcance, las expectativas o el impacto necesiten acuerdo y trazabilidad.

## Buenas practicas

1. Mantener un cambio centrado en una sola unidad de trabajo que pueda revisarse y cerrarse por separado.
2. Usar exploracion antes de proponer cuando haya incertidumbre; pasar a propuesta cuando problema, objetivo y limites esten claros.
3. Escribir escenarios observables, incluyendo errores y casos limite importantes, y vincular tareas con requisitos y pruebas.
4. Revisar los artefactos antes de implementar y hacer preguntas ante supuestos ambiguos; no aceptar requisitos inventados por el agente.
5. Durante la implementacion, mantener coherentes el codigo, las tareas y los documentos de planificacion.
6. Verificar con comandos reales y pruebas enfocadas antes de sincronizar y archivar.
7. Usar nombres descriptivos para cambios, por ejemplo `guardar-puntuaciones` o `corregir-redireccion-login`.
8. En cambios paralelos, coordinar modificaciones a los mismos archivos de especificacion para evitar merges semanticos contradictorios.

## Resolucion rapida de problemas

- **El comando no aparece en Copilot:** comprueba `.github/prompts/` y `.github/skills/`; ejecuta `openspec update` desde el root; revisa el autocompletado y reinicia la ventana de chat si Copilot no recargo instrucciones.
- **La accion se escribio en el lugar equivocado:** `openspec ...` va en terminal; `/opsx...` va en el chat del agente.
- **Se uso el esquema equivocado:** inspecciona `openspec/config.yaml`, metadatos del cambio y las opciones `openspec schemas` / `openspec schema`.
- **Un cambio parece bloqueado:** ejecuta `openspec status --change <nombre>`; revisa si falta un artefacto que sea dependencia.
- **Validacion falla:** lee el detalle del artefacto señalado, corrige la estructura o el delta y vuelve a validar el mismo cambio.
- **Configuracion sospechosa:** ejecuta `openspec doctor --json`, `openspec context` y el comando especifico con `--help`.
- **La documentacion y el CLI discrepan:** la version instalada y su salida `--help` rigen el comportamiento local; confirma los cambios recientes en las notas de version oficiales.

## Estado comprobado de este proyecto

- OpenSpec `1.14.1`, instalado globalmente mediante npm.
- Root resuelto: raiz de `ai-app`; `openspec doctor --json` informa `healthy: true` y sin problemas.
- `openspec/config.yaml` selecciona `spec-driven` y `githubCopilot.cloudAgent: true`; no declara `context` ni reglas personalizadas.
- La configuracion global de OpenSpec usa el perfil `custom`, con workflows `propose`, `explore`, `new`, `continue`, `apply`, `ff`, `sync`, `archive`, `bulk-archive`, `verify` y `onboard`; no incluye `update`.
- Hay prompts OPSX y skills de GitHub Copilot en `.github/prompts/` y `.github/skills/`; los nombres concretos estan enumerados en la seccion de acciones.
- Al investigar, `openspec list` no encontro cambios activos y `openspec context` no declaro referencias externas.
- `diana/knowledge/openspec.md` es la guia local de conocimiento. OpenSpec no la descubre ni la inyecta automaticamente. Para que un agente la consulte de forma sistematica, enlazala desde las instrucciones persistentes que ese agente realmente carga (por ejemplo, instrucciones del repositorio o una skill propia); no la copies entera a `openspec/config.yaml`, cuyo contexto se inyecta en las instrucciones de los artefactos y debe mantenerse conciso.
- OpenSpec puede declarar `references` a stores registrados para aportar un indice de especificaciones externas en las instrucciones. Son referencias de solo lectura a otro repositorio OpenSpec, no una forma de cargar automaticamente Markdown arbitrario como `diana/knowledge/openspec.md`. Este proyecto no declara referencias.
- La comprobacion de `openspec doctor --json` del 2026-10-07 devolvio `healthy: true`, sin problemas, stores ni referencias. `openspec context` resolvio solamente la raiz local `ai-app`.
- El perfil global `custom` tiene `delivery: both` y selecciona exactamente `propose`, `explore`, `new`, `continue`, `apply`, `ff`, `sync`, `archive`, `bulk-archive`, `verify` y `onboard`. No selecciona `update`. Los 11 prompts y las 11 skills locales concuerdan con esa seleccion. La documentacion oficial llama `core` al perfil predeterminado, pero esta instalacion no usa el predeterminado.
- La configuracion local declara `context`, reglas para proposal/specs/design/tasks, guias para apply/archive y `githubCopilot.cloudAgent: true`; este contexto local si se agrega a las instrucciones OpenSpec. La carpeta `diana/knowledge/` no se agrega por esa configuracion.
- `openspec templates --json` resolvio las cuatro plantillas de `spec-driven` (`proposal`, `specs`, `design`, `tasks`) desde la instalacion npm global. `openspec list --archived --json` fue aceptado y no reporto cambios archivados.
- La version `1.14.1` incluye, entre otras mejoras, una advertencia para requisitos mayores de 500 caracteres (error en modo estricto), escritura progresiva de specs durante `/opsx:continue`, mejor verificacion de esquemas personalizados y cambios archivados fuera del panel principal `openspec view`. Consulta las notas de version antes de asumir este comportamiento en otra version.

## Fuentes oficiales

Todas las referencias se consultaron el 2026-10-07. Las paginas del branch `main` pueden cambiar despues de esta fecha.

- Inicio y filosofia: https://github.com/Fission-AI/OpenSpec
- Documentacion principal: https://github.com/Fission-AI/OpenSpec/tree/main/docs
- Guia de inicio: https://github.com/Fission-AI/OpenSpec/blob/main/docs/getting-started.md
- Conceptos esenciales: https://github.com/Fission-AI/OpenSpec/blob/main/docs/overview.md
- Flujo OPSX: https://github.com/Fission-AI/OpenSpec/blob/main/docs/opsx.md
- Patrones de workflow: https://github.com/Fission-AI/OpenSpec/blob/main/docs/workflows.md
- CLI frente a acciones de chat: https://github.com/Fission-AI/OpenSpec/blob/main/docs/how-commands-work.md
- Referencia completa del CLI: https://github.com/Fission-AI/OpenSpec/blob/main/docs/cli.md
- Referencia de acciones y skills: https://github.com/Fission-AI/OpenSpec/blob/main/docs/commands.md
- Herramientas compatibles y formas de invocacion: https://github.com/Fission-AI/OpenSpec/blob/main/docs/supported-tools.md
- Personalizacion y esquemas: https://github.com/Fission-AI/OpenSpec/blob/main/docs/customization.md
- Stores y worksets (funciones beta): https://github.com/Fission-AI/OpenSpec/blob/main/docs/stores-beta/user-guide.md
- Cambios de version: https://github.com/Fission-AI/OpenSpec/releases
- Notas de OpenSpec 1.14.1: https://github.com/Fission-AI/OpenSpec/releases/tag/v1.14.1
- Sitio oficial: https://openspec.dev/