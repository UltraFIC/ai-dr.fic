# File: engine/checklists/initiative-audit-checklist.md
# DIANA‑SDK by DRFIC
## Checklist Automático de Auditoría de Change (VEGETA + GOKU)

Propósito:
Asegurar que un change es auditable y que el flujo negocio→canon→ejecución está íntegro.

---

## 1. Origen (WARN → BLOCKER en entornos regulados)

[ ] context.md incluye origen organizacional (ticket, change relacionado o decisión estratégica)  
[ ] context.md declara tipo de change: greenfield / brownfield / bugfix  
[ ] context.md aclara que la sección de origen es informativa y no ejecutable

---

## 2. Canon limpio (BLOCKER)

[ ] spec.md no contiene referencias a tickets como requisitos  
[ ] plan.md no contiene “mandatos” de negocio no presentes en la spec  
[ ] Speckit artifacts están separados y no contaminan el canon

---

## 3. Versionado (WARN)

[ ] El change indica si reemplaza una spec previa (cuando aplica)  
[ ] Si hay reemplazo, se declara “reemplaza SPEC-xxx” en la spec o en context.md

---

## 4. Reproducibilidad (WARN)

[ ] Se puede regenerar speckit/ sin cambiar el canon  
[ ] No hay dependencia de “memoria de chat” para entender decisiones críticas

---

## Resultado

- Estado:
  - [ ] AUDITORÍA OK
  - [ ] AUDITORÍA CON RIESGOS
  - [ ] AUDITORÍA BLOQUEADA

Notas:
- Riesgos:
- Acciones sugeridas:
``