"""Hatchling build hook: stage ../engine into a local assets/ folder.

`engine/` (projects/diana/engine) es la unica fuente editable de Diana.
Este hook copia su contenido a `assets/` en build time para que el
force-include declarativo existente ("assets" = "assets") lo empaquete sin
cambios. `assets/` es un artefacto de build: se regenera siempre, nunca se
edita a mano ni se commitea (ver .gitignore).
"""
from hatchling.builders.hooks.plugin.interface import BuildHookInterface
from pathlib import Path
import shutil


class CustomBuildHook(BuildHookInterface):
    """Stage projects/diana/engine/** into local assets/ before packaging."""

    PLUGIN_NAME = 'custom'

    def initialize(self, version, build_data):
        project_root = Path(self.root)
        engine_dir = project_root.parent / "engine"
        assets_dir = project_root / "assets"

        if not engine_dir.exists():
            self.app.display_warning(f"engine directory not found at {engine_dir}")
            return

        if assets_dir.exists():
            shutil.rmtree(assets_dir)

        core_target = assets_dir / "drfic" / "diana-sdk" / "sdk" / "diana"
        core_target.mkdir(parents=True, exist_ok=True)
        for item in engine_dir.iterdir():
            if item.name == "integrations":
                continue
            dest = core_target / item.name
            if item.is_dir():
                shutil.copytree(item, dest)
            else:
                shutil.copy2(item, dest)

        github_src = engine_dir / "integrations" / "github"
        if github_src.exists():
            for sub in ("agents", "prompts"):
                src = github_src / sub
                if src.exists():
                    dest = assets_dir / "github" / sub
                    dest.parent.mkdir(parents=True, exist_ok=True)
                    shutil.copytree(src, dest)

        self.app.display_info(f"Staged Diana engine assets from {engine_dir} into {assets_dir}")
