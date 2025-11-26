# Linux Limits Patcher

A comprehensive bash script to optimize Linux system limits for high-performance applications, VPN servers, containers, and databases. Fixes common "Resource temporarily unavailable" and "Too many open files" errors.

## Features

- 🚀 **Increases process and thread limits** - Prevents "Resource temporarily unavailable" errors
- 🌐 **Optimizes network socket limits** - Enhances connection handling capabilities (Critical for VPNs)
- 📁 **Configures file descriptor limits** - Eliminates "Too many open files" errors
- ⚡ **Applies systemd service limits** - Extends limits to systemd services
- 🔒 **Automatic backup** - Creates backups before making changes
- 🛡️ **Safe operations** - Non-destructive with comprehensive error checking
- 🎨 **User-friendly interface** - Color-coded logging and progress indicators

## Quick Installation & Usage

### Method 1: One-Line Auto Install (Recommended)
Run this command to download and apply the patch immediately. Supports Ubuntu, Debian, CentOS, and RHEL.

```bash
bash <(curl -Ls https://raw.githubusercontent.com/chainvpn/Linux-Limits-Patcher/refs/heads/main/linux-limits-patcher.sh)
````

### Method 2: Alternative (If curl is missing)

If your system only has `wget`, use this command:

```bash
wget -qO- [https://raw.githubusercontent.com/chainvpn/Linux-Limits-Patcher/refs/heads/main/linux-limits-patcher.sh](https://raw.githubusercontent.com/chainvpn/Linux-Limits-Patcher/refs/heads/main/linux-limits-patcher.sh) | bash
```

### Method 3: Manual / Git Clone

For users who want to review the code or contribute:

```bash
# Clone the repository
git clone [https://github.com/chainvpn/linux-limits-patcher.git](https://github.com/chainvpn/linux-limits-patcher.git)
cd linux-limits-patcher

# Make script executable and run
chmod +x linux-limits-patcher.sh
sudo ./linux-limits-patcher.sh
```

## Script Options

```bash
# Apply all optimizations (default behavior)
sudo ./linux-limits-patcher.sh

# Create backup only without applying changes
sudo ./linux-limits-patcher.sh --backup

# Show help message
./linux-limits-patcher.sh --help
```

## What Problems This Solves

✅ **"Resource temporarily unavailable" errors** ✅ **"Too many open files" errors** ✅ **Process creation failures** ✅ **Socket connection limits reached (VPN bottleneck)** ✅ **Thread creation limits** ✅ **High-performance application bottlenecks** ✅ **Database connection limits** ✅ **Web server connection limits** ✅ **Container runtime limitations** \#\# System Requirements

  - **Operating System**: Linux (Ubuntu, Debian, CentOS, RHEL, etc.)
  - **Privileges**: Root access required (Script checks automatically)
  - **Shell**: Bash 4.0 or newer
  - **Architecture**: x86\_64, arm64 (most architectures supported)

## Safety Features

  - 🔄 **Automatic backups** of all modified configuration files
  - 🎯 **Color-coded logging** for easy status monitoring
  - ⚠️ **Comprehensive error checking** and validation
  - 🔍 **Non-destructive operations** - never overwrites existing configs blindly
  - 📝 **Detailed logging** of all changes made

## Technical Details

The script optimizes the following system parameters:

### Process & Thread Limits

  - `kernel.threads-max`: Increases to 1,000,000
  - `vm.max_map_count`: Increases to 2,000,000
  - `kernel.pid_max`: Increases to 4,194,304
  - `fs.file-max`: Increases to 10,000,000

### Network Socket Limits

  - `net.core.somaxconn`: Increases to 65,535
  - `net.ipv4.ip_local_port_range`: Expands to 1024-65535
  - `net.core.netdev_max_backlog`: Increases to 100,000
  - Connection tracking limits optimized

### User Limits

  - File descriptors: 100,000 soft / 500,000 hard
  - Processes: 100,000 soft / 200,000 hard
  - Root user: Unlimited processes

## Verification

After running the script, verify the new limits:

```bash
# Check current limits
ulimit -a

# Check system-wide limits
cat /proc/sys/fs/file-max
cat /proc/sys/kernel/threads-max

# Check current usage
cat /proc/sys/fs/file-nr
```

## Post-Installation

### Recommended Steps:

1.  **Reboot your system** for all changes to take full effect:

    ```bash
    sudo reboot
    ```

2.  **Monitor system performance** after changes.

3.  **Adjust limits further** if needed for specific applications.

### Troubleshooting:

  - If issues occur, check the backup files in `/tmp/linux_limits_backup_*/`
  - Review system logs: `journalctl -xe --since "1 hour ago"`
  - Verify configuration files: `/etc/sysctl.conf` and `/etc/security/limits.conf`

## Project Structure

```
linux-limits-patcher/
├── linux-limits-patcher.sh  # Main patcher script
├── README.md                # This documentation
├── LICENSE                  # MIT License
└── .gitignore               # Git ignore rules
```

## License

MIT License - see [LICENSE](https://www.google.com/search?q=LICENSE) file for full details.

## Support

  - **Repository**: [github.com/chainvpn/linux-limits-patcher](https://github.com/chainvpn/linux-limits-patcher)
  - **Issues**: Please open an issue on GitHub for bug reports or feature requests.

-----

**Note**: Some limit changes require a system reboot to take full effect. The script will notify you if a reboot is recommended.

```
```
