# 🔍 portexplain

> **Homeserver Port & Self-Hosted Software Intelligence Tool.**  
> Explain what ports are running what software, audit active listening network sockets, and manage a conflict-free homelab registry.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Python 3](https://img.shields.io/badge/Python-3.8+-3776AB.svg?logo=python&logoColor=white)](https://www.python.org/)
[![Homelab Ready](https://img.shields.io/badge/Homelab-Verified-success.svg)](https://github.com/Blianokoji/portexplain)

---

## 💡 Why `portexplain`?

When running dozens of Docker containers, systemd services, and reverse proxies, commands like `ss -tulpn` or `lsof -i` are frustrating:
* They show cryptic processes like `docker-proxy` or PID numbers without context.
* They don't tell you **which Compose stack** or **which volume directory** owns the service.
* They don't show the **Tailscale FQDN**, default access URLs, or Web UI paths.
* Port conflicts happen when deploying new applications without a central registry.

**`portexplain` solves this completely:**
1. **Correlates Live Sockets with Docker Metadata**: Maps raw listening TCP/UDP sockets to container names, health status, and compose working directories.
2. **Master Hit List**: Instant high-altitude overview of all 28+ self-hosted applications, their categories, host ports, and remote URLs.
3. **Deep-Dive Inspection**: Run `portexplain 8096` or `portexplain jellyfin` to inspect ports, configuration paths, container states, and endpoints.
4. **Collision Audit (`-a`)**: Scans for uncataloged listening ports and dead or unmounted services.
5. **Interactive Wizard (`--add`)**: Register new services interactively to prevent port conflicts before deployment.

---

## ⚡ Quickstart

### 1-Line Universal Install

```bash
curl -fsSL https://raw.githubusercontent.com/Blianokoji/portexplain/main/install.sh | bash
```

### Install with Python / Pip

```bash
git clone git@github.com:Blianokoji/portexplain.git
cd portexplain
pip install .
```

---

## 🖥️ Usage & Commands

```text
usage: portexplain [-h] [-l] [-p] [-j] [-a] [--add] [query]

positional arguments:
  query            Port number or service name to inspect (e.g. 8096, 2283, glance)

options:
  -h, --help       show this help message and exit
  -l, --hitlist    Display only the Self-Hosted Applications Master Hit List table
  -p, --listening  Display only the Active Listening Sockets table
  -j, --json       Export live system sockets & self-hosted registry as JSON
  -a, --audit      Run audit checks for uncataloged ports and dead services
  --add            Interactive wizard to add a new self-hosted app to registry
```

### Examples

#### 1. Full Server Network Audit
```bash
portexplain
```
Displays the server metadata banner, the complete Master Hit List table with live container status badges (`● UP`, `○ DOWN`), and the active listening sockets table.

#### 2. Deep-Dive Inspection by Port or Name
```bash
portexplain 8096
# or
portexplain immich
```

Output:
```text
================================================================================
  🔍 INSPECTING PORT / SERVICE: 8096
================================================================================
  Service Name   : 🎬 Jellyfin
  Category       : Media Streaming
  Host Port      : 8096 (HTTP)
  Container      : jellyfin (● UP)
  Compose Dir    : /mnt/storage/AppData/services
  Config Path    : /mnt/storage/AppData/jellyfin
  Local Access   : http://<lan-ip>:8096
  Tailscale FQDN : https://jellyfin.<tailscale-domain>
  Description    : Free Software Media System & GPU Transcoder
================================================================================
```

#### 3. Display Only the Master Hit List
```bash
portexplain -l
```

#### 4. Display Only Active Listening Sockets
```bash
portexplain -p
```

#### 5. Machine-Readable JSON Export
```bash
portexplain -j | jq '.selfhosted_services[] | {name, ports, category}'
```

#### 6. Register a New App (Conflict Prevention)
```bash
portexplain --add
```
Interactively prompts for port, container name, compose directory, and validates that the proposed port is not already claimed or listening.

---

## ⚙️ Configuration & Registry

The master port registry resides at:
```text
~/.config/portexplain/services.json
```

If missing, `portexplain` automatically seeds itself from the bundled defaults.

### Schema Example (`services.json`)
```json
{
  "id": "jellyfin",
  "name": "Jellyfin",
  "icon": "🎬",
  "category": "Media Streaming",
  "ports": [8096],
  "web_port": 8096,
  "protocol": "http",
  "container_names": ["jellyfin"],
  "service_type": "docker_compose",
  "compose_dir": "/mnt/storage/AppData/services",
  "config_path": "/mnt/storage/AppData/jellyfin",
  "description": "Hardware-accelerated media streaming server for movies, TV, and music",
  "default_creds": "Initial setup wizard"
}
```

---

## 📜 License

Released under the [MIT License](LICENSE).  
Created and maintained with ❤️ by [Blessen Eby (Blianokoji)](https://github.com/Blianokoji).
