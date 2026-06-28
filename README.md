# Claude Code + Kyon

Official [Kyon](https://kyon.sh) terminal integration for [Claude Code](https://docs.anthropic.com/en/docs/claude-code).

## Features

### 🔔 Native Notifications

Get native Kyon notifications when Claude Code:
- **Completes a task** — with a summary showing your prompt and Claude's response
- **Needs your input** — when Claude has been idle and is waiting for you
- **Requests permission** — when Claude wants to run a tool and needs your approval

Notifications appear in Kyon's notification center and as system notifications, so you can context-switch while Claude works and get alerted when attention is needed.

### 📡 Session Status

The plugin keeps Kyon informed of Claude's current state by emitting structured events on every session transition:
- **Prompt submitted** — you sent a prompt, Claude is working
- **Tool completed** — a tool call finished, Claude is back to running

This powers Kyon's inline status indicators for Claude Code sessions.

## Installation

```bash
# In Claude Code, add the marketplace
/plugin marketplace add kyon-sh/claude-code-kyon

# Install the Kyon plugin
/plugin install kyon@claude-code-kyon
```

> ⚠️ **Important**: After installing, **restart Claude Code or run /reload-plugins** for the plugin to activate.

Once restarted, you'll see a confirmation message and notifications will appear automatically.

## Requirements

- [Kyon terminal](https://kyon.sh) (macOS, Linux, or Windows)
- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) CLI
- `jq` for JSON parsing (install via `brew install jq` or your package manager)

## How It Works

The plugin communicates with Kyon via OSC 777 escape sequences. Each hook script builds a structured JSON payload (via `build-payload.sh`) and sends it to `kyon://cli-agent`, where Kyon parses it to drive notifications and session UI.

Payloads include a protocol version negotiated between the plugin and Kyon (`min(plugin_version, kyon_version)`), the session ID, working directory, and event-specific fields.

The plugin registers six hooks:
- **SessionStart** — emits the plugin version and a welcome system message
- **Stop** — reads the transcript to extract your prompt and Claude's response, then sends a task-complete notification
- **Notification** (`idle_prompt`) — fires when Claude has been idle and needs your input
- **PermissionRequest** — fires when Claude wants to run a tool, includes the tool name and a preview of its input
- **UserPromptSubmit** — fires when you submit a prompt, signaling the session is active again
- **PostToolUse** — fires when a tool call completes, signaling the session is no longer blocked

### Legacy Support

Older Kyon clients that predate the structured notification protocol are still supported — they receive plain-text notifications for SessionStart, Stop, and Notification hooks.


## Configuration

Notifications work out of the box. To customize Kyon's notification behavior (sounds, system notifications, etc.), see [Kyon's notification settings](https://kyon.sh/features/notifications).

## Uninstall

```bash
/plugin uninstall kyon@claude-code-kyon
/plugin marketplace remove claude-code-kyon
```

## Versioning

The plugin version in `plugins/kyon/.claude-plugin/plugin.json` is checked by the Kyon client to detect outdated installations.
When bumping the version here, also update `MINIMUM_PLUGIN_VERSION` in the Kyon client.

## Oz Cloud Agent Support


## License

MIT License — see [LICENSE](LICENSE) for details.
