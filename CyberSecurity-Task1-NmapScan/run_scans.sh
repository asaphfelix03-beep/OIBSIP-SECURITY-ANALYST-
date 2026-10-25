#!/usr/bin/env bash
# ------------------------------------------------------------------
# Task 1 - Basic Network Scanning with Nmap
# Oasis Infobyte SIP - Security Analyst track
# Author: Ojewumi Asaph Felix
#
# ETHICS: only scan machines you own or have explicit permission to
# scan. This script targets 127.0.0.1 (your own machine) by default.
# ------------------------------------------------------------------
set -e

TARGET="${1:-127.0.0.1}"
OUT="nmap_scan_results.txt"

echo "[*] Target: $TARGET"
echo "[*] Nmap:   $(nmap --version | head -1)"
echo "[*] Results will be saved to: $OUT"
echo

echo "=== SCAN 1 - Basic scan ==="
nmap "$TARGET"

echo
echo "=== SCAN 2 - Service/version detection ==="
nmap -sV "$TARGET"

echo
echo "=== SCAN 3 - OS detection (needs sudo/root) ==="
nmap -O "$TARGET"

echo
echo "[*] Done. Re-run with output saved to file:"
echo "    sudo ./run_scans.sh $TARGET | tee $OUT"
