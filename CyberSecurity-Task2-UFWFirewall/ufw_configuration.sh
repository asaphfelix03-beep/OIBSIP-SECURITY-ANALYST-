#!/usr/bin/env bash
# ==================================================================
# Task 2 - Basic Firewall Configuration with UFW
# Oasis Infobyte SIP - Security Analyst track
# Author: Ojewumi Asaph Felix
#
# This script applies all firewall rules in sequence and enables UFW.
# Run as root:   sudo ./ufw_configuration.sh
#
# WARNING: run this on a LOCAL VM you own. The "allow ssh" rule is
# placed FIRST on purpose so you never lock yourself out of a remote
# session when enabling the firewall.
# ==================================================================
set -e

if [ "$(id -u)" -ne 0 ]; then
  echo "[!] Please run as root:  sudo $0"
  exit 1
fi

echo "[*] Installing UFW if needed..."
command -v ufw >/dev/null 2>&1 || apt-get install -y ufw

echo "[*] Resetting UFW to a clean state..."
ufw --force reset

echo "[*] Setting safe defaults: deny all incoming, allow all outgoing..."
ufw default deny incoming
ufw default allow outgoing

echo "[*] Rule 1: ALLOW SSH (port 22) - so remote admin keeps working"
ufw allow ssh

echo "[*] Rule 2: DENY HTTP (port 80) - block unencrypted web traffic"
ufw deny http

echo "[*] Rule 3: ALLOW HTTPS (port 443) - permit encrypted web traffic"
ufw allow https

echo "[*] Rule 4: DENY a specific IP range (192.168.100.0/24)"
ufw deny from 192.168.100.0/24

echo "[*] Enabling the firewall..."
ufw --force enable

echo
echo "[*] Final ruleset:"
ufw status verbose
