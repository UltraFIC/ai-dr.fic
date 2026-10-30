#!/usr/bin/env bash
set -euo pipefail

TARGET_PATH="."
FORCE="false"
SKIP_ACTIONS="false"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --target)
      TARGET_PATH="$2"
      shift 2
      ;;
    --force)
      FORCE="true"
      shift
      ;;
    --skip-actions)
      SKIP_ACTIONS="true"
      shift
      ;;
    *)
      echo "Unknown option: $1"
      echo "Usage: install-diana.sh [--target <path>] [--force] [--skip-actions]"
      exit 1
      ;;
  esac
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIANA_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
TARGET_ROOT="$(cd "$TARGET_PATH" 2>/dev/null && pwd || true)"

if [[ -z "$TARGET_ROOT" ]]; then
  mkdir -p "$TARGET_PATH"
  TARGET_ROOT="$(cd "$TARGET_PATH" && pwd)"
fi

TARGET_DRFIC="$TARGET_ROOT/.drfic"
TARGET_DIANA_ROOT="$TARGET_DRFIC/diana"
TARGET_ENGINE="$TARGET_DIANA_ROOT/engine"
TARGET_PROJECTS="$TARGET_DIANA_ROOT/projects"

mkdir -p "$TARGET_DRFIC" "$TARGET_DIANA_ROOT" "$TARGET_PROJECTS" "$TARGET_ENGINE"

DRFIC_README="$TARGET_DRFIC/readme.md"
if [[ ! -f "$DRFIC_README" || "$FORCE" == "true" ]]; then
  cat > "$DRFIC_README" <<'EOF'
# DR.FIC Workspace

Estructura base de Diana SDK instalada.
EOF
fi

FLAT_README_TEXT='Organiza su contenido en subcarpetas libres por tema; si no existe una carpeta para el tema, se crea una nueva. Sin estructura de categorias fija.'
for SHARED_NAME in docs knowledge prompts skills-dev; do
  SHARED_DIR="$TARGET_DRFIC/$SHARED_NAME"
  mkdir -p "$SHARED_DIR"
  SHARED_README="$SHARED_DIR/README.md"
  if [[ ! -f "$SHARED_README" || "$FORCE" == "true" ]]; then
    printf '%s\n' "$FLAT_README_TEXT" > "$SHARED_README"
  fi
done

for SHARED_NAME in reports tickets; do
  SHARED_DIR="$TARGET_DRFIC/$SHARED_NAME"
  mkdir -p "$SHARED_DIR"
  SHARED_README="$SHARED_DIR/README.md"
  if [[ ! -f "$SHARED_README" || "$FORCE" == "true" ]]; then
    printf 'Organiza su contenido por proyecto, no por tema: .drfic/%s/<proyecto>/<tema>/. Cada proyecto mantiene sus propias subcarpetas de tema; no se mezcla contenido entre proyectos.\n' "$SHARED_NAME" > "$SHARED_README"
  fi
done

if [[ "$(cd "$SOURCE_DIANA_ROOT" && pwd)" != "$(cd "$TARGET_ENGINE" && pwd)" ]]; then
  if [[ "$FORCE" == "true" ]]; then
    rsync -a --delete --exclude 'integrations' "$SOURCE_DIANA_ROOT/" "$TARGET_ENGINE/"
  else
    rsync -a --ignore-existing --exclude 'integrations' "$SOURCE_DIANA_ROOT/" "$TARGET_ENGINE/"
  fi
fi

RADAR_DIR="$TARGET_PROJECTS/registry/indexes"
RADAR_FILE="$RADAR_DIR/projects-knowledge-radar.yaml"
mkdir -p "$RADAR_DIR"
if [[ ! -f "$RADAR_FILE" || "$FORCE" == "true" ]]; then
  cat > "$RADAR_FILE" <<'EOF'
version: 1.0.0
scope: projects-root
last_updated: 2026-04-29

policy:
  always_on_radar:
    - projects-root
    - project-active
  optional_layers:
    - sdk-shared

projects: []
EOF
fi

if [[ "$SKIP_ACTIONS" == "false" ]]; then
  mkdir -p "$TARGET_ROOT/.github/prompts" "$TARGET_ROOT/.github/agents"

  if [[ -d "$SOURCE_DIANA_ROOT/integrations/github/prompts" ]]; then
    for f in "$SOURCE_DIANA_ROOT"/integrations/github/prompts/diana.*.prompt.md; do
      [[ -e "$f" ]] || continue
      dest="$TARGET_ROOT/.github/prompts/$(basename "$f")"
      if [[ ! -f "$dest" || "$FORCE" == "true" ]]; then
        cp -f "$f" "$dest"
      fi
    done
  fi

  if [[ -d "$SOURCE_DIANA_ROOT/integrations/github/agents" ]]; then
    for f in "$SOURCE_DIANA_ROOT"/integrations/github/agents/diana.*.agent.md; do
      [[ -e "$f" ]] || continue
      dest="$TARGET_ROOT/.github/agents/$(basename "$f")"
      if [[ ! -f "$dest" || "$FORCE" == "true" ]]; then
        cp -f "$f" "$dest"
      fi
    done
  fi
fi

echo "Diana SDK instalado correctamente en: $TARGET_ROOT"
echo "- Core SDK: .drfic/diana/engine"
echo "- Radar base: .drfic/diana/projects/registry/indexes/projects-knowledge-radar.yaml"
echo "- Carpetas compartidas: .drfic/{docs,knowledge,prompts,reports,tickets,skills-dev}/"
if [[ "$SKIP_ACTIONS" == "false" ]]; then
  echo "- Acciones Diana: .github/prompts y .github/agents"
fi
