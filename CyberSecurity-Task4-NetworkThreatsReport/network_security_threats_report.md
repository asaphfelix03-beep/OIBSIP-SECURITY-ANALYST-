# Research Report: Common Network Security Threats

**Author:** Ojewumi Asaph Felix
**Track:** Security Analyst
**Task:** Task 4 — Research Report: Common Network Security Threats
**Organisation:** Oasis Infobyte — Student Internship Programme (SIP)
**Date:** October 2026

---

## Table of Contents

1. [Introduction](#1-introduction)
2. [DoS / DDoS Attacks](#2-dos--ddos-attacks)
3. [Man-in-the-Middle (MITM) Attacks](#3-man-in-the-middle-mitm-attacks)
4. [IP Spoofing](#4-ip-spoofing)
5. [DNS Poisoning / Spoofing](#5-dns-poisoning--spoofing)
6. [Comparison Table](#6-comparison-table)
7. [Conclusion — Key Takeaways for a Network Administrator](#7-conclusion--key-takeaways-for-a-network-administrator)
8. [References](#8-references)

---

## 1. Introduction

Modern organisations run on connected infrastructure: every email, payment, medical record and industrial control signal travels across a network. That same connectivity is what makes networks the primary battleground of information security. A single exposed service, an intercepted session or a forged packet can cascade into data theft, financial loss, regulatory penalties and lasting reputational damage. Network security threats matter today more than ever because the attack surface keeps expanding — cloud workloads, remote work, IoT devices and third-party integrations all widen the perimeter — while attackers have access to cheap, automated tooling that lowers the skill required to launch an assault. Understanding how the most common network attacks work is the first step toward defending against them: you cannot mitigate what you do not understand. This report examines four of the most prevalent network threats — Denial-of-Service, Man-in-the-Middle, IP Spoofing and DNS Poisoning — explaining the mechanism of each, a documented real-world incident, its impact, and specific, actionable mitigation strategies.

---

## 2. DoS / DDoS Attacks

### How it works
A **Denial-of-Service (DoS)** attack aims to make a system, service or network unavailable to its legitimate users by overwhelming it with traffic or by exploiting a flaw that exhausts its resources. A **Distributed Denial-of-Service (DDoS)** attack is the same concept carried out from many sources at once — typically a *botnet* of thousands or millions of compromised devices (PCs, routers, IoT cameras) all directed at a single target simultaneously.

DDoS attacks generally fall into three categories:

- **Volumetric attacks** (e.g. UDP floods, DNS/NTP amplification) saturate the target's bandwidth with sheer traffic volume, measured in Gbps/Tbps.
- **Protocol attacks** (e.g. SYN floods) exhaust server-side resources such as connection state tables by exploiting weaknesses in the TCP/IP handshake.
- **Application-layer attacks** (e.g. HTTP floods) send seemingly legitimate requests to resource-expensive endpoints, draining CPU and memory with comparatively little traffic.

### Real-world example
In **October 2016**, the **Dyn DNS attack** used the *Mirai* botnet — a network of hundreds of thousands of compromised IoT devices such as IP cameras and home routers — to flood Dyn, a major DNS provider, with traffic peaking around 1.2 Tbps. Because so many popular platforms (Twitter, Netflix, Reddit, Spotify, GitHub) relied on Dyn for DNS resolution, large portions of the internet became unreachable across North America and Europe for hours (Krebs on Security, 2016; US-CERT/CISA advisories on Mirai).

### Impact
- **Loss of availability and revenue:** every minute of downtime for an e-commerce or SaaS business translates directly into lost sales and SLA penalties.
- **Reputational harm and loss of customer trust** when services are repeatedly unreachable.
- **Operational cost and distraction:** DDoS is often used as a *smokescreen* to occupy the security team while a stealthier intrusion (data theft) proceeds in parallel.

### Mitigation strategies
1. **Deploy a cloud-based DDoS scrubbing / CDN service** (e.g. a provider that absorbs and filters traffic upstream) so volumetric floods are cleaned before they reach your origin infrastructure.
2. **Rate limiting and traffic shaping** at the firewall / load balancer, combined with SYN cookies to defend against SYN-flood protocol attacks without keeping half-open connections.
3. **Over-provision bandwidth and build redundancy** (anycast routing, multiple data centres, auto-scaling) and maintain a tested incident-response runbook so the team reacts fast instead of improvising.

---

## 3. Man-in-the-Middle (MITM) Attacks

### How it works
In a **Man-in-the-Middle** attack, the attacker secretly positions themselves *between* two communicating parties — for example between a user's laptop and the Wi-Fi gateway — so that all traffic flows through the attacker. The victim believes they are talking directly to the legitimate server, while the attacker can **eavesdrop** on the data, **steal credentials or session tokens**, or **modify** the messages in transit.

Common techniques include:

- **ARP spoofing / ARP poisoning** on a local network, where the attacker sends forged ARP replies to associate their MAC address with the gateway's IP, redirecting LAN traffic through their machine.
- **Rogue / "evil twin" Wi-Fi access points** that impersonate a legitimate hotspot so victims connect to the attacker.
- **SSL stripping**, which downgrades an HTTPS connection to plain HTTP so the attacker can read it.

### Real-world example
The **Superfish** incident (2014–2015) is a well-documented MITM case: Lenovo shipped consumer laptops with pre-installed *Superfish Visual Discovery* adware that inserted its own self-signed root certificate authority into the machine's trust store to inject advertisements into HTTPS pages. Because the same private key was reused across all machines and was quickly extracted by researchers, **any attacker could use it to intercept and decrypt the HTTPS traffic** of affected Lenovo users on shared networks. US-CERT issued alert TA15-051A, and Lenovo was later subject to an FTC settlement (US-CERT, 2015; FTC, 2017).

### Impact
- **Confidentiality breach:** credentials, session cookies, banking details and private messages can be captured.
- **Integrity breach:** the attacker can alter transactions or inject malicious content/malware into the response stream.
- **Account takeover:** stolen session tokens let the attacker impersonate the victim even without the password.

### Mitigation strategies
1. **Enforce strong encryption everywhere** — TLS 1.2/1.3 on all services, and **HSTS (HTTP Strict Transport Security)** to prevent SSL-stripping downgrades to plain HTTP.
2. **Use a VPN on untrusted networks** (public Wi-Fi, hotels) so that even if traffic is intercepted it is encrypted end-to-end, and prefer **certificate pinning** in mobile/critical apps to reject forged certificates.
3. **Harden the local network against ARP spoofing** with *Dynamic ARP Inspection (DAI)* and *DHCP snooping* on managed switches, plus **802.1X network access control** so rogue devices cannot silently join the LAN.

---

## 4. IP Spoofing

### How it works
**IP spoofing** is the creation of IP packets with a forged (fake) **source IP address** so that the packet appears to come from a different, trusted host. Because the basic IPv4 protocol does not verify that the source address of a packet is genuine, an attacker can simply write whatever source address they choose into the packet header.

IP spoofing rarely works alone — it is a *building block* for larger attacks:

- **DDoS amplification/reflection:** the attacker spoofs the *victim's* IP as the source, then sends small requests to open DNS/NTP servers; those servers send their large replies to the victim, flooding them.
- **Bypassing IP-based trust / access control:** forging the address of a whitelisted internal host to reach a protected service.
- **Session hijacking / TCP sequence prediction** in older or poorly randomised stacks.

### Real-world example
IP spoofing was central to the record-breaking **GitHub DDoS of February 2018**, a *memcached amplification* attack. Attackers spoofed GitHub's IP address as the source of thousands of small requests to exposed, misconfigured memcached servers on the public internet; those servers reflected enormous responses (an amplification factor of up to ~51,000×) back toward GitHub, peaking at **1.35 Tbps** — at the time the largest DDoS ever recorded. The attack was only possible because the source IP could be forged and because intermediate networks did not filter spoofed packets (Cloudflare / Akamai post-incident analyses, 2018).

### Impact
- **Enables massive reflection/amplification DDoS** that is hard to trace back to the real attacker.
- **Defeats weak, address-based authentication**, allowing unauthorised access to services that "trust" certain IPs.
- **Attribution is difficult:** because the source is forged, incident responders cannot easily identify or block the true origin.

### Mitigation strategies
1. **Ingress and egress filtering (BCP 38 / RFC 2827):** network operators should drop packets whose source address could not legitimately originate from that interface — this is the single most effective systemic defence against spoofing.
2. **Do not rely on source IP for authentication;** use cryptographic authentication (mutual TLS, signed tokens, IPsec) instead of trusting an address that can be forged.
3. **Harden/limit amplifiers** by disabling or restricting open UDP services (memcached, open DNS resolvers, NTP monlist) and deploy anti-spoofing features and modern, randomised TCP sequence numbers on network devices.

---

## 5. DNS Poisoning / Spoofing

> *Included as a bonus fourth threat for a stronger submission.*

### How it works
The **Domain Name System (DNS)** translates human-readable names (`example.com`) into IP addresses. **DNS poisoning** (also called **DNS cache poisoning** or **DNS spoofing**) is an attack in which false DNS records are injected into a resolver's cache so that the resolver returns an **attacker-controlled IP address** for a legitimate domain name. Users who type the correct address are silently redirected to a malicious server — typically a convincing phishing clone — without any visible sign that anything is wrong.

The classic technique exploits the fact that DNS traditionally runs over **UDP** with only a 16-bit transaction ID: an attacker races the legitimate response by flooding the resolver with forged replies carrying guessed transaction IDs. The *Kaminsky attack* (2008) showed how dramatically this could be accelerated, forcing an industry-wide emergency patch.

### Real-world example
The **Dan Kaminsky DNS vulnerability (2008)** is the defining case study. Kaminsky demonstrated that weak transaction-ID randomisation let an attacker poison a recursive resolver's cache for an *entire domain* in seconds, redirecting all users of that resolver to malicious hosts. The disclosure triggered a coordinated, simultaneous patch by virtually every major DNS vendor (adding **source-port randomisation**) — one of the largest synchronised security patches in internet history (US-CERT VU#800113; ICANN/IETF response, 2008). More recently, large-scale **DNS hijacking campaigns** (e.g. the "Sea Turtle" / "DNSpionage" operations reported 2018–2019 and flagged in a CISA Emergency Directive) showed nation-state actors manipulating DNS to intercept traffic for espionage.

### Impact
- **Credential theft and malware delivery** via pharming: users land on a perfect-looking fake of their bank or webmail and enter their credentials.
- **Large blast radius:** poisoning one shared resolver can silently affect *every* user behind it.
- **Interception of email and traffic** when attackers redirect mail or service endpoints, enabling espionage and data exfiltration.

### Mitigation strategies
1. **Deploy DNSSEC (DNS Security Extensions)**, which cryptographically signs DNS records so resolvers can verify that a response is authentic and has not been forged or tampered with.
2. **Use source-port randomisation and transaction-ID randomisation** on resolvers (the post-Kaminsky baseline), and adopt **encrypted DNS** such as **DNS-over-HTTPS (DoH)** or **DNS-over-TLS (DoT)** to stop on-path forgery and eavesdropping.
3. **Harden and monitor DNS infrastructure:** run trusted, patched resolvers; restrict who can make recursive queries; lock registrar accounts with MFA and registry locks to prevent hijacking; and monitor for unexpected changes to DNS records.

---

## 6. Comparison Table

| Threat | Attack Vector | Who Is at Risk | Difficulty to Execute | Ease of Mitigation |
|---|---|---|---|---|
| **DoS / DDoS** | Flooding bandwidth or exhausting server resources, usually via a botnet | Any internet-facing service: websites, APIs, DNS, online games, SaaS | **Low–Medium** — booter/stresser services and botnets are rented cheaply | **Medium–Hard** — needs upstream scrubbing/CDN; hard to stop volumetric floods at the origin alone |
| **MITM** | Intercepting traffic on a shared path (ARP spoofing, rogue Wi-Fi, SSL stripping) | Users on untrusted/shared networks; anyone using unencrypted or poorly configured services | **Medium** — easy on open LAN/Wi-Fi, harder against properly deployed TLS/HSTS | **Medium** — strong TLS + HSTS + VPN + switch hardening largely closes it |
| **IP Spoofing** | Forging the source IP in packets to impersonate or reflect | DDoS targets; services relying on IP-based trust; whole networks lacking filtering | **Medium** — trivial to forge a header, but harder to make a full session work | **Medium** — fixed systemically by BCP 38 filtering, but requires operator cooperation |
| **DNS Poisoning / Spoofing** | Injecting forged DNS records into a resolver's cache to redirect users | Users of an affected resolver; organisations without DNSSEC; registrar accounts | **Medium–Hard** — easier pre-patch (Kaminsky era); modern defences raise the bar | **Medium** — DNSSEC + port randomisation + encrypted DNS are effective but underdeployed |

---

## 7. Conclusion — Key Takeaways for a Network Administrator

1. **Assume the network is hostile and encrypt everything.** The majority of MITM and DNS attacks succeed because traffic is unauthenticated or unencrypted. Enforce TLS 1.2/1.3 with HSTS, deploy DNSSEC and encrypted DNS, and never trust a bare source IP address for authentication — identity must be cryptographic, not address-based.

2. **Defence in depth beats any single control.** No one tool stops all four threats. Combine perimeter defences (DDoS scrubbing, rate limiting, BCP 38 ingress/egress filtering) with internal segmentation and switch hardening (DHCP snooping, Dynamic ARP Inspection, 802.1X) so that a failure at one layer is caught by another.

3. **Visibility and preparation are what turn an attack into a non-event.** Continuous monitoring, logging and alerting let you detect spoofed traffic, poisoned caches or a DDoS smokescreen early; a tested, written incident-response runbook — plus disciplined patch management of DNS and network devices — ensures the team reacts in minutes, not hours.

---

## 8. References

1. **NIST SP 800-61 Rev. 2 — *Computer Security Incident Handling Guide*.** National Institute of Standards and Technology. https://csrc.nist.gov/publications/detail/sp/800-61/rev-2/final
2. **NIST SP 800-81-2 — *Secure Domain Name System (DNS) Deployment Guide*.** National Institute of Standards and Technology. https://csrc.nist.gov/publications/detail/sp/800-81/2/final
3. **CISA — *Understanding Denial-of-Service Attacks* (ST04-015)** and **CISA Emergency Directive 19-01, *Mitigate DNS Infrastructure Tampering*.** Cybersecurity and Infrastructure Security Agency. https://www.cisa.gov/
4. **US-CERT Technical Alert TA15-051A — *Lenovo Superfish Adware Vulnerable to HTTPS Spoofing*** and **US-CERT VU#800113 — *Multiple DNS implementations vulnerable to cache poisoning* (Kaminsky).** https://www.cisa.gov/news-events/alerts
5. **IETF BCP 38 / RFC 2827 — *Network Ingress Filtering: Defeating Denial of Service Attacks which employ IP Source Address Spoofing*.** P. Ferguson, D. Senie. https://www.rfc-editor.org/info/bcp38
6. **MITRE ATT&CK — *Network Denial of Service* (T1498), *Adversary-in-the-Middle* (T1557).** The MITRE Corporation. https://attack.mitre.org/
7. **Krebs on Security — *KrebsOnSecurity Hit With Record DDoS* and reporting on the Mirai botnet / Dyn attack (2016).** Brian Krebs. https://krebsonsecurity.com/
8. **Cloudflare Learning Center & post-incident analysis of the February 2018 memcached amplification DDoS against GitHub.** https://www.cloudflare.com/learning/ddos/
