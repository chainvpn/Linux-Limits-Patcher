#!/bin/bash
#
# Linux Limits Patcher
# Optimizes system limits for high-performance applications
# GitHub: https://github.com/yourusername/linux-limits-patcher
#
# Usage: sudo ./linux-limits-patcher.sh

set -euo pipefail

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
check_root() {
    if [[ $EUID -ne 0 ]]; then
        log_error "This script must be run as root"
        exit 1
    fi
}

# Backup configuration files
backup_files() {
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local backup_dir="/tmp/linux_limits_backup_${timestamp}"
    
    log_info "Creating backup in ${backup_dir}"
    mkdir -p "$backup_dir"
    
    cp -f /etc/sysctl.conf "${backup_dir}/sysctl.conf" 2>/dev/null || true
    cp -f /etc/security/limits.conf "${backup_dir}/limits.conf" 2>/dev/null || true
    
    log_success "Backup created at ${backup_dir}"
}

# Apply process and thread limits
apply_process_limits() {
    log_info "Applying process and thread limits..."
    
    cat >> /etc/sysctl.conf << 'EOF'

# High-performance tuning - Added by linux-limits-patcher
kernel.threads-max = 1000000
vm.max_map_count = 2000000
kernel.pid_max = 4194304
kernel.thread-keys-max = 2000000
fs.file-max = 10000000
fs.nr_open = 10000000
EOF
}

# Apply network socket limits
apply_network_limits() {
    log_info "Applying network socket limits..."
    
    cat >> /etc/sysctl.conf << 'EOF'

# Network performance tuning - Added by linux-limits-patcher
net.core.rmem_max = 134217728
net.core.wmem_max = 134217728
net.core.rmem_default = 65536
net.core.wmem_default = 65536
net.core.optmem_max = 65536
net.core.netdev_max_backlog = 100000
net.core.somaxconn = 65535
net.core.dev_weight = 64

# IPv4 tuning
net.ipv4.tcp_rmem = 4096 65536 134217728
net.ipv4.tcp_wmem = 4096 65536 134217728
net.ipv4.tcp_mem = 786432 1048576 1572864
net.ipv4.tcp_max_syn_backlog = 65535
net.ipv4.ip_local_port_range = 1024 65535
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_slow_start_after_idle = 0
net.ipv4.tcp_max_tw_buckets = 2000000

# Connection tracking
net.netfilter.nf_conntrack_max = 1000000
net.nf_conntrack_max = 1000000

# Memory management
vm.swappiness = 10
vm.dirty_ratio = 15
vm.dirty_background_ratio = 5
EOF
}

# Apply user limits
apply_user_limits() {
    log_info "Applying user limits..."
    
    cat >> /etc/security/limits.conf << 'EOF'

# High limits for all users - Added by linux-limits-patcher
* soft nofile 100000
* hard nofile 500000
* soft nproc 100000
* hard nproc 200000
* soft memlock unlimited
* hard memlock unlimited
root soft nofile 1000000
root hard nofile 1000000
root soft nproc unlimited
root hard nproc unlimited
root soft memlock unlimited
root hard memlock unlimited
EOF
}

# Apply systemd limits
apply_systemd_limits() {
    if [[ -d /etc/systemd ]]; then
        log_info "Applying systemd limits..."
        
        mkdir -p /etc/systemd/system.conf.d
        
        cat > /etc/systemd/system.conf.d/99-linux-limits-patcher.conf << 'EOF'
# Systemd limits - Added by linux-limits-patcher
[Manager]
DefaultLimitNOFILE=500000
DefaultLimitNPROC=200000
DefaultTasksMax=100000
EOF
    fi
}

# Reload configuration
reload_configuration() {
    log_info "Reloading system configuration..."
    
    # Reload sysctl
    if sysctl -p > /dev/null 2>&1; then
        log_success "Sysctl configuration reloaded"
    else
        log_warning "Some sysctl parameters might need manual review"
    fi
    
    # Reload systemd if available
    if command -v systemctl >/dev/null 2>&1; then
        systemctl daemon-reload
        log_success "Systemd configuration reloaded"
    fi
}

# Display current limits
show_current_limits() {
    log_info "Current system limits:"
    echo "----------------------------------------"
    echo "File max: $(cat /proc/sys/fs/file-max)"
    echo "Threads max: $(cat /proc/sys/kernel/threads-max)"
    echo "Max map count: $(cat /proc/sys/vm/max_map_count)"
    echo "Somaxconn: $(cat /proc/sys/net/core/somaxconn)"
    echo "----------------------------------------"
}

# Display usage information
show_usage() {
    cat << EOF
Linux Limits Patcher

Usage: $0 [OPTIONS]

Options:
  -h, --help     Show this help message
  -b, --backup   Create backup only
  -r, --restore  Restore from backup (not implemented)

Examples:
  sudo $0          # Apply all optimizations
  sudo $0 --backup # Create backup only

GitHub: https://github.com/yourusername/linux-limits-patcher
EOF
}

# Main function
main() {
    local backup_only=false
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_usage
                exit 0
                ;;
            -b|--backup)
                backup_only=true
                shift
                ;;
            *)
                log_error "Unknown option: $1"
                show_usage
                exit 1
                ;;
        esac
    done
    
    log_info "Starting Linux Limits Patcher"
    
    check_root
    backup_files
    
    if [[ "$backup_only" == true ]]; then
        log_success "Backup completed. Exiting."
        exit 0
    fi
    
    apply_process_limits
    apply_network_limits
    apply_user_limits
    apply_systemd_limits
    reload_configuration
    
    log_success "All optimizations applied successfully!"
    log_warning "Some changes may require a reboot to take full effect"
    
    show_current_limits
    
    echo
    log_info "Next steps:"
    echo "1. Review the changes in /etc/sysctl.conf and /etc/security/limits.conf"
    echo "2. Reboot the system for all changes to take effect: sudo reboot"
    echo "3. Verify limits with: ulimit -a && cat /proc/sys/fs/file-max"
}

# Run main function with all arguments
main "$@"
