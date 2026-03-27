# claudeman

A simple CLI tool to manage multiple [Claude Code](https://claude.ai/code) profiles — switch between different `CLAUDE_CONFIG_DIR` environments (e.g. work, personal, client projects) without manually changing environment variables.

## Requirements

- macOS / Linux
- `jq` (`brew install jq`)

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/huangqianrui/claudeman/main/install.sh | bash
```

After installation, add the following snippet to your `~/.zshrc` or `~/.bashrc`:

```bash
# claudeman - Claude Code profile manager
refresh-claude() { eval "$(command claudeman env)"; }

claudeman() {
    if [ "$1" = "sw" ]; then
        eval "$(command claudeman sw "${@:2}")"
    else
        command claudeman "$@"
    fi
}

refresh-claude
```

Then reload your shell:

```bash
source ~/.zshrc
```

## Usage

### Initialize

```bash
claudeman init
```

Creates `~/.claudeman/config.json` and sets up your first profile.

### Add a profile

```bash
claudeman add
```

### List profiles

```bash
claudeman list
```

```
┌─ Claude Profiles ───────────────────
│ Name: work  ✦
│ Desc: Work account
│ Path: /Users/you/.claudeman/work
├─────────────────────────────────────
│ Name: personal
│ Desc: Personal projects
│ Path: /Users/you/.claudeman/personal
└─────────────────────────────────────
Current: work
```

### Switch profile

```bash
claudeman sw personal
```

This updates `CLAUDE_CONFIG_DIR` in your current shell session immediately (via the shell wrapper).

## How it works

Each profile maps to a directory that Claude Code uses as its config root (`CLAUDE_CONFIG_DIR`). Switching profiles changes where Claude reads its settings, memory, and MCP configs from — letting you maintain completely separate environments.

The shell wrapper intercepts `claudeman sw` and runs `eval` so the environment variable is set in the current shell, not a subprocess.
