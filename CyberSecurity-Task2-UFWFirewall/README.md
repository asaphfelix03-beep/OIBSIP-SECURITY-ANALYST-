# OIBSIP — Security Analyst — Task 2

## Basic Firewall Configuration with UFW

This folder contains my submission for **Task 2** of the Oasis Infobyte SIP
**Security Analyst** track.

- **Author:** Ojewumi Asaph Felix
- **Track:** Security Analyst
- **Task:** Task 2 — Basic Firewall Configuration with UFW
- **System:** Ubuntu/Debian Linux (UFW 0.36.2)

---

## 📁 Files in this folder
| File | Purpose |
|------|---------|
| `ufw_configuration.sh` | Runnable script that applies all rules and enables UFW |
| `ufw_status.txt` | Real output of `ufw status verbose` / `numbered` + the iptables proof |
| `README.md` | This file — explanation of the firewall, each rule, and testing |
| `screenshots/` | *(add your own terminal screenshots here for the demo)* |

---

## 1. What does a firewall do?

A **firewall** is a security control that filters network traffic according to a set of
**rules**, deciding which packets are allowed in or out of a system. It acts as a
gatekeeper between your machine and the network: legitimate traffic passes, unwanted or
dangerous traffic is blocked. A host firewall reduces the **attack surface** by ensuring
that only the services you explicitly intend to expose are reachable.

**UFW (Uncomplicated Firewall)** is a user-friendly front-end for Linux's underlying
`iptables`/`netfilter` system. It lets you write simple commands like `ufw allow ssh`
instead of long raw iptables rules, while still generating those real iptables rules
under the hood (see the proof in `ufw_status.txt`).

## 2. Installation

```bash
sudo apt-get update
sudo apt-get install -y ufw
ufw --version        # confirm installation (0.36.2 here)
```

## 3. Rules configured (and why)

The script applies a **default-deny** posture, then opens only what is needed:

| # | Rule | Command | Why it was chosen |
|---|------|---------|-------------------|
| — | Default incoming = **deny** | `ufw default deny incoming` | Secure baseline: block everything, then allow exceptions |
| — | Default outgoing = **allow** | `ufw default allow outgoing` | Let the host reach the internet (updates, DNS, etc.) |
| 1 | **ALLOW SSH** (22/tcp) | `ufw allow ssh` | Keep remote administration working — applied *first* to avoid locking yourself out |
| 2 | **DENY HTTP** (80/tcp) | `ufw deny http` | Block unencrypted web traffic (this task's requirement) |
| 3 | **ALLOW HTTPS** (443) | `ufw allow https` | Permit encrypted web traffic (my extra rule #1) |
| 4 | **DENY an IP range** | `ufw deny from 192.168.100.0/24` | Block a whole untrusted subnet (my extra rule #2) |

> **Rule order matters:** SSH is allowed *before* enabling the firewall so an
> administrator on a remote session is never cut off — a classic real-world mistake.

### Verified result (`sudo ufw status verbose`)
```
Status: active
Logging: on (low)
Default: deny (incoming), allow (outgoing), disabled (routed)

To                         Action      From
--                         ------      ----
22/tcp                     ALLOW IN    Anywhere
80/tcp                     DENY IN     Anywhere
443                        ALLOW IN    Anywhere
Anywhere                   DENY IN     192.168.100.0/24
```

## 4. How I tested that denied traffic is blocked

**Testing method:** with the firewall active, I confirmed the rules two ways:

1. **Rule presence (iptables proof):** `sudo iptables -L ufw-user-input -n` shows UFW
   generated a real `DROP` rule for `tcp dpt:80` and for the `192.168.100.0/24` source
   (see `ufw_status.txt`). This is the authoritative evidence that the DENY is enforced
   by the kernel.

2. **Connectivity test:** start a web server on port 80 and try to connect to it.

   ⚠️ **Honest finding / important subtlety:** connecting to port 80 **from the same
   machine** (via `127.0.0.1` *or* the host's own IP) still succeeds — because UFW
   **allows all loopback (`lo`) traffic by default**, and Linux delivers packets sent to
   a host's own IP over the loopback path. **The DENY rule therefore only takes effect
   for traffic arriving from another machine.** The correct way to prove the block is to
   attempt the connection **from a second VM/host** on the same network:

   ```bash
   # From a SECOND machine on the network (replace with the target's IP):
   curl -v --max-time 5 http://TARGET_IP:80/     # -> connection refused / timeout (blocked)
   curl -v --max-time 5 https://TARGET_IP:443/   # -> reaches the service (allowed)
   ```

   On the firewalled host you can also watch blocked packets in the log:
   ```bash
   sudo tail -f /var/log/ufw.log   # shows [UFW BLOCK] entries for denied traffic
   ```

## 5. ⚠️ Ethics / safety note

- Perform this on a **local VM you own**. Misconfiguring a firewall on a remote machine
  can lock you out.
- Always add the **ALLOW SSH** rule *before* enabling UFW on any remote system.

---

## How to reproduce (for the demo video)

On your own Ubuntu/Kali VM:

```bash
chmod +x ufw_configuration.sh
sudo ./ufw_configuration.sh
sudo ufw status verbose
```

Record your screen, starting with a 2-second title card showing your **Full Name +
Track (Security Analyst) + Task 2**, then narrate each rule and the final status. For
the blocking test, demonstrate the `curl` from a second machine (or show the
`[UFW BLOCK]` lines in `/var/log/ufw.log`).

## References
- Official UFW community docs: https://help.ubuntu.com/community/UFW
- `man ufw`
