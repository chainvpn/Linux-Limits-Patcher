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
git clone https://github.com/yourusername/linux-limits-patcher.git
cd linux-limits-patcher

# Make script executable
chmod +x linux-limits-patcher.sh

# Run the patcher
sudo ./linux-limits-patcher.sh
