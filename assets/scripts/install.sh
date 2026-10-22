#!/usr/bin/env bash
set -euo pipefail

# Ensure script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Error: This script must be run as root (sudo)."
  exit 1
fi

echo "=================================================="
echo "          NixOS Automatic Installer               "
echo "=================================================="

# List available disks to the user
lsblk -d -n -o NAME,SIZE,MODEL,TYPE | grep "disk"
echo "--------------------------------------------------"

# Prompt for the target disk (e.g., vda, sda, nvme0n1)
read -p "Enter the target disk name for installation (e.g., vda or sda): " DISK_NAME
DISK="/dev/$DISK_NAME"

if [ ! -b "$DISK" ]; then
  echo "Error: Device $DISK was not found!"
  exit 1
fi

echo ""
echo "WARNING: Disk $DISK will be COMPLETELY ERASED!"
read -p "Are you sure you want to proceed? (y/N): " CONFIRM
if [[ ! $CONFIRM =~ ^[Yy]$ ]]; then
  echo "Installation canceled."
  exit 0
fi

# Adjust partition prefix for NVMe/MMC drives (e.g., /dev/nvme0n1p1 vs /dev/sda1)
if [[ $DISK =~ "nvme" ]] || [[ $DISK =~ "mmcblk" ]]; then
  PART_PREFIX="${DISK}p"
else
  PART_PREFIX="${DISK}"
fi

BOOT_PART="${PART_PREFIX}1"
SWAP_PART="${PART_PREFIX}2"
ROOT_PART="${PART_PREFIX}3"

echo "==> Unmounting existing partitions (if any)..."
umount -R /mnt 2>/dev/null || true
swapoff -a 2>/dev/null || true

echo "==> Creating GPT partition table..."
parted -s "$DISK" -- mklabel gpt

echo "==> Creating Boot Partition (512MB / ESP)..."
parted -s "$DISK" -- mkpart ESP fat32 1MiB 513MiB
parted -s "$DISK" -- set 1 boot on

echo "==> Creating SWAP Partition (2GB)..."
parted -s "$DISK" -- mkpart primary linux-swap 513MiB 2561MiB

echo "==> Creating Root Partition / (Remaining space)..."
parted -s "$DISK" -- mkpart primary ext4 2561MiB 100%

echo "==> Formatting partitions..."
mkfs.fat -F32 -n boot "$BOOT_PART"
mkswap -L swap "$SWAP_PART"
mkfs.ext4 -L nixos -F "$ROOT_PART"

# Force kernel and udev to update device labels before mounting
echo "==> Updating device nodes..."
partprobe "$DISK"
udevadm settle
sleep 2

echo "==> Mounting partitions under /mnt..."
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot
swapon /dev/disk/by-label/swap

echo "==> Verifying mount setup..."
lsblk "$DISK"

echo "==> Generating initial NixOS configuration..."
nixos-generate-config --root /mnt

echo ""
echo "=================================================="
echo " Configuration generated in /mnt/etc/nixos/"
echo " You can now proceed with the installation by running:"
echo "   nixos-install"
echo "=================================================="
