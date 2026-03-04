# Ghostty Config Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Add a minimal Ghostty Home Manager module that mirrors Alacritty’s font family and size while keeping both terminals enabled.

**Architecture:** Create a new terminal module file for Ghostty and import it from the existing terminal module entrypoint. Keep the configuration minimal to reduce risk while you evaluate Ghostty.

**Tech Stack:** NixOS, Home Manager

---

### Task 1: Add Ghostty module with font settings

**Files:**
- Create: `modules/apps/home/terminal/ghostty.nix`

**Step 1: Write the file with minimal settings**

```nix
{
  programs = {
    ghostty = {
      enable = true;
      settings = {
        font = {
          family = "FiraCode Nerd Font";
          size = 21;
        };
      };
    };
  };
}
```

**Step 2: Run Home Manager to verify evaluation**

Run: `home-manager switch`
Expected: activation succeeds with no evaluation errors

**Step 3: Commit**

```bash
git add modules/apps/home/terminal/ghostty.nix
git commit -m "feat: add Ghostty terminal module"
```

### Task 2: Wire Ghostty into terminal imports

**Files:**
- Modify: `modules/apps/home/terminal/default.nix`

**Step 1: Add the Ghostty import**

```nix
  imports = [
    ./alacritty.nix
    ./ghostty.nix
    ./fish.nix
    ./git.nix
  ];
```

**Step 2: Run Home Manager to verify evaluation**

Run: `home-manager switch`
Expected: activation succeeds with no evaluation errors

**Step 3: Commit**

```bash
git add modules/apps/home/terminal/default.nix
git commit -m "feat: enable Ghostty terminal config"
```
