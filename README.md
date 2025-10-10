# Linux Limits Patcher

A bash script to optimize Linux system limits for high-performance applications, containers, and servers.

## Features

- Increases process and thread limits
- Optimizes network socket limits
- Configures file descriptor limits
- Applies systemd service limits
- Automatic backup of existing configuration
- Safe and idempotent operations

## Usage

```bash
# Clone the repository
git clone https://github.com/chainvpn/linux-limits-patcher.git
cd linux-limits-patcher

# Make script executable
chmod +x linux-limits-patcher.sh

# Run the patcher
sudo ./linux-limits-patcher.sh
Options
bash
# Apply all optimizations (default)
sudo ./linux-limits-patcher.sh

# Create backup only
sudo ./linux-limits-patcher.sh --backup

# Show help
./linux-limits-patcher.sh --help
What It Fixes
"Resource temporarily unavailable" errors

"Too many open files" errors

Process creation failures

Socket connection limits

Thread creation limits

Requirements
Linux operating system

Root privileges

Bash 4.0+

Safety Features
Automatic backup of configuration files

Color-coded logging

Error checking and validation

Non-destructive operations

License
MIT License - see LICENSE file for details

text

## **Configuration Files**

### **.gitignore**
*.backup
*.tmp
backup/
logs/
.DS_Store
*.swp
*.swo

text

### **install.sh** (Optional installer)
```bash
#!/bin/bash
# Installation script for Linux Limits Patcher

set -e

SCRIPT_NAME="linux-limits-patcher.sh"
INSTALL_PATH="/usr/local/bin/linux-limits-patcher"

if [[ $EUID -ne 0 ]]; then
    echo "Please run as root for installation"
    exit 1
fi

cp "$SCRIPT_NAME" "$INSTALL_PATH"
chmod +x "$INSTALL_PATH"

echo "Linux Limits Patcher installed to $INSTALL_PATH"
echo "Usage: sudo linux-limits-patcher"
