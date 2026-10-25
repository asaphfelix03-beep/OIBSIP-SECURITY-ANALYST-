# OIBSIP — Security Analyst — Task 1

## Basic Network Scanning with Nmap

This folder contains my submission for **Task 1** of the Oasis Infobyte SIP
**Security Analyst** track.

- **Author:** Ojewumi Asaph Felix
- **Track:** Security Analyst
- **Task:** Task 1 — Basic Network Scanning with Nmap
- **Target scanned:** `127.0.0.1` (localhost — a machine I own and control)

---

## 📁 Files in this folder
| File | Purpose |
|------|---------|
| `nmap_scan_results.txt` | Full output of the three Nmap scans (basic, `-sV`, `-O`) |
| `run_scans.sh` | Runnable script that reproduces all three scans |
| `README.md` | This file — explanation, port analysis, and ethics |
| `screenshots/` | *(add your own terminal screenshots here for the demo)* |

---

## 1. What is Nmap?

**Nmap** ("Network Mapper") is a free, open-source tool for **network discovery and
security auditing**. It sends specially crafted packets to a target and analyses the
responses to answer questions like: *Which hosts are online? Which TCP/UDP ports are
open? What services and versions are running? What operating system is the host likely
using?* It is the de-facto standard tool used by network administrators and security
analysts to understand and inventory a network.

## 2. Why does network scanning matter?

You cannot secure what you cannot see. Network scanning gives defenders **visibility**:

- **Asset & service inventory** — know exactly what is exposed on each machine.
- **Attack-surface reduction** — find unexpected open ports or forgotten services and
  close them before an attacker finds them.
- **Vulnerability context** — knowing the exact service *version* lets you check it
  against known CVEs.
- **Verification** — confirm that firewall rules and hardening actually work.

Attackers perform the same reconnaissance as their **first step**; defenders scan their
own networks to find and fix weaknesses first.

## 3. Installation (steps I used)

This was performed on Ubuntu/Debian Linux:

```bash
sudo apt-get update
sudo apt-get install -y nmap
nmap --version      # confirm installation
```

*(On Kali Linux, Nmap is pre-installed.)*

## 4. Scans performed

All scans target `127.0.0.1` (localhost). Full output is in
[`nmap_scan_results.txt`](./nmap_scan_results.txt).

| # | Purpose | Command |
|---|---------|---------|
| 1 | Basic port scan | `nmap 127.0.0.1` |
| 2 | Service / version detection | `nmap -sV 127.0.0.1` |
| 3 | OS detection | `sudo nmap -O 127.0.0.1` |

> **Note on the test environment:** to produce a meaningful scan, two local test web
> servers were started on this machine (`python3 -m http.server 80` and `... 8080`)
> before scanning. They are local services on a machine I own — nothing external was
> scanned. On a Kali/Ubuntu VM you will typically see other services (e.g. SSH on 22).

## 5. Open ports found and analysis

The scans found **2 open ports**:

| Port | State | Service | Version detected |
|------|-------|---------|------------------|
| 80/tcp | open | http | SimpleHTTPServer 0.6 (Python 3.13) |
| 8080/tcp | open | http-proxy | SimpleHTTPServer 0.6 (Python 3.13) |

### Port 80 — HTTP
- **What the service does:** Port 80 is the standard port for **HTTP**, the protocol
  that serves unencrypted web pages. Here it is a Python `http.server` test instance.
- **Security risk:** **Medium.** HTTP traffic is **unencrypted**, so anything sent over
  it (form data, cookies, credentials) can be read by anyone intercepting the traffic
  (see MITM attacks). A simple development server like `SimpleHTTPServer` is also not
  hardened for production (directory listing, no access control). *Mitigation:* serve
  over **HTTPS (443)** with TLS, put a real hardened web server (nginx/Apache) in front,
  and never expose a development server to the internet.

### Port 8080 — HTTP-proxy / alternate HTTP
- **What the service does:** Port 8080 is a common **alternate HTTP port**, often used
  for proxies, admin consoles, or secondary web apps. Here it is a second Python test
  web server.
- **Security risk:** **Medium.** Same concerns as port 80 (unencrypted, unhardened).
  Alternate ports like 8080 are also frequently **overlooked** in firewall rules and can
  expose admin interfaces unintentionally. *Mitigation:* restrict access with a firewall
  (allow only trusted IPs), require authentication, and use TLS.

> **General note:** an open port is not automatically a vulnerability — the risk depends
> on *what* is listening, *whether it is patched*, and *who can reach it*. The goal of
> scanning is to make an informed decision about each one.

## 6. ⚠️ Ethical use guidelines

- **Only scan systems you own or have explicit written permission to scan.**
  Unauthorised scanning of third-party or production systems can be **illegal** and is
  against this task's rules.
- This task was performed exclusively against **`127.0.0.1` (my own local machine)**.
- Use a **local VM** (e.g. VirtualBox + Kali/Ubuntu) as your lab — never point scans at
  external websites, your ISP, a university network, or any system you do not control.
- Aggressive scans (`-O`, `-A`, fast timing) generate noticeable traffic and may trip
  intrusion-detection systems — another reason to stay within your own lab.

---

## How to reproduce (for the demo video)

On your own Linux VM, run:

```bash
chmod +x run_scans.sh
./run_scans.sh
```

Record your screen while it runs, starting the video with a 2-second title card showing
your **Full Name + Track (Security Analyst) + Task 1**, then narrate the output.
