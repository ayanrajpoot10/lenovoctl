# lenovoctl

A lightweight CLI tool to control Lenovo laptop features on Linux.

## Requirements

- A compatible Lenovo laptop with the `ideapad_laptop` kernel module.
- `sudo` access to modify settings (status checks run as normal user).

## Installation

### Arch Linux
You can install `lenovoctl` from the AUR using an AUR helper like `yay`:
```bash
yay -S lenovoctl
```

### Universal Script (Any Linux)
Run the following command to automatically download and install the latest version:
```bash
curl -fsSL https://raw.githubusercontent.com/ayanrajpoot10/lenovoctl/main/install.sh | sudo bash
```

## Usage

```bash
lenovoctl <command> <action>
```

Settings changes require `sudo` (e.g., `sudo lenovoctl conservation on`).

### Commands

| Command | Description | Supported Actions |
|---|---|---|
| `conservation` | Battery conservation mode | `status`, `on`, `off` |
| `fan` | Fan mode profile | `status`, `0` (silent), `1` (standard), `2` (dust), `4` (efficient) |
| `usb` | Always-on USB charging | `status`, `on`, `off` |
| `fnlock` | Function key lock | `status`, `on`, `off` |
| `camera` | Built-in webcam power | `status`, `on`, `off` |
| `touchpad` | Internal touchpad | `status`, `on`, `off` |
