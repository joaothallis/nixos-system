# Repository Guidelines

## Project Structure & Module Organization
This repository is a NixOS system configuration. Key files live at the repo root:
- `flake.nix`: Flake inputs/outputs and NixOS system definition.
- `configuration.nix`: Main system configuration (packages, services, users).
- `hardware-configuration.nix`: Auto-generated hardware settings (do not edit manually).
- `flake.lock`: Locked dependency versions for the flake.

There are no separate source/test directories; configuration is managed directly in these Nix files.

## Build, Test, and Development Commands
- `sudo nixos-rebuild switch --flake .#nixos`: Build and apply the system configuration.
- `nix flake update`: Update flake inputs in `flake.lock`.
- `nix flake check`: Validate the flake outputs.

## Coding Style & Naming Conventions
- Nix files use two-space indentation.
- Keep attribute names and module paths descriptive (e.g., `services.xserver.enable`).
- Prefer grouped lists for packages and modules, and keep comments succinct.

## Testing Guidelines
- Use `nix flake check` for basic validation.
- For rebuilds, rely on `nixos-rebuild` to surface evaluation or build errors.
- There are no unit tests in this repository.

## Commit & Pull Request Guidelines
- Commit messages follow a short, imperative style (examples from history: "Add git", "Enable flakes").
- Keep commits focused on a single change or feature.
- PRs should include a brief summary and note any system-level impact (services enabled, packages added).

## Security & Configuration Tips
- Do not edit `hardware-configuration.nix` manually; regenerate via `nixos-generate-config` if needed.
- Treat `configuration.nix` as the source of truth for system state.
