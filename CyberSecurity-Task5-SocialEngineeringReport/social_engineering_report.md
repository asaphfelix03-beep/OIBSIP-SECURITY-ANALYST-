# Research Report: Social Engineering Attacks

**Author:** Ojewumi Asaph Felix
**Track:** Security Analyst
**Task:** Task 5 — Research Report: Social Engineering Attacks
**Organisation:** Oasis Infobyte — Student Internship Programme (SIP)
**Date:** October 2026

---

## Table of Contents

1. [Introduction](#1-introduction)
2. [Phishing](#2-phishing)
3. [Pretexting](#3-pretexting)
4. [Baiting](#4-baiting)
5. [Quid Pro Quo (Bonus)](#5-quid-pro-quo-bonus)
6. [Comparison Table](#6-comparison-table)
7. [Organisational Recommendations — Employee Awareness Training Checklist](#7-organisational-recommendations--employee-awareness-training-checklist)
8. [References](#8-references)

---

## 1. Introduction

**Social engineering** is the art of manipulating people into performing actions or divulging confidential information, rather than breaking through technical defences. Instead of exploiting a software bug, the attacker exploits *human* psychology — trust, fear, curiosity, urgency, respect for authority and the desire to be helpful. It is considered one of the most effective attack vectors in all of cybersecurity for a simple reason: you can patch a server, but you cannot patch a person. Even an organisation with world-class firewalls, encryption and intrusion detection can be compromised the moment one employee clicks a malicious link or hands over a password to a convincing impostor.

The data confirms how central the human element has become. Verizon's widely cited *Data Breach Investigations Report (DBIR)* has repeatedly found that the large majority of breaches involve a human element — such as error, misuse, or falling for social engineering — and phishing remains one of the most common initial-access techniques year after year. Industry reporting (e.g. IBM, CISA and the FBI's Internet Crime Complaint Center) consistently ranks phishing and Business Email Compromise (BEC) among the costliest and most frequent attacks, with BEC losses alone running into billions of dollars annually. This report examines the main families of social engineering — **phishing, pretexting, baiting** and the bonus **quid pro quo** — explaining how each works, a documented real-world case, and concrete prevention measures, before setting out an organisational awareness-training checklist.

> **Note on figures:** the exact percentages and dollar amounts in DBIR, IBM and IC3 reports change every year. Cite the specific edition you consult (e.g. "Verizon 2024 DBIR") when you reuse a number, rather than quoting a figure as timeless.

---

## 2. Phishing

### How it works
**Phishing** is a social engineering attack in which an attacker sends a fraudulent message — most often email, but also SMS or voice — designed to trick the recipient into revealing sensitive information (credentials, card numbers), clicking a malicious link, or opening a weaponised attachment. The message impersonates a trusted entity (a bank, an employer, a delivery service, a colleague) and manufactures a sense of **urgency or fear** ("Your account will be suspended in 24 hours") so the victim acts before thinking.

### Main types of phishing
- **Spear phishing:** a highly targeted phish aimed at a specific individual or organisation, using personalised details (name, role, recent activity) to appear credible.
- **Whaling:** spear phishing that targets senior executives ("big fish") such as a CEO or CFO, often to authorise fraudulent wire transfers (a form of Business Email Compromise).
- **Vishing (voice phishing):** the attack is carried out by phone, with the attacker posing as IT support, a bank or a government agency.
- **Smishing (SMS phishing):** phishing delivered via text message, e.g. a fake parcel-delivery or bank-alert SMS containing a malicious link.

### Real-world case study
The **2016 US Democratic National Committee / John Podesta breach** is a textbook spear-phishing case. Podesta, chairman of Hillary Clinton's presidential campaign, received an email crafted to look like a Google security alert urging him to reset his password via a link. The link led to an attacker-controlled page that harvested his real credentials, giving the attackers access to years of email, which were later leaked. A single convincing email — not a technical exploit — opened the door (widely documented; see SANS and mainstream security reporting).

### Prevention recommendations
1. **Deploy email authentication and filtering:** implement **SPF, DKIM and DMARC** to reduce spoofing, plus a modern secure email gateway that flags external senders and known-malicious links/attachments.
2. **Enable phishing-resistant multi-factor authentication (MFA):** even if a password is stolen, MFA (ideally FIDO2/hardware keys rather than SMS codes) blocks the attacker from logging in.
3. **Train staff to verify and report:** teach users to hover over links, check sender addresses, treat urgency as a red flag, and use a one-click "report phishing" button; never act on an unexpected "reset your password" email by clicking its link — go to the site directly.
4. **Verify financial/credential requests out-of-band:** any request to move money or change payment details must be confirmed through a second, independent channel (a known phone number), which defeats whaling/BEC.

---

## 3. Pretexting

### How it works
**Pretexting** is an attack in which the adversary invents a believable **scenario (the "pretext")** and assumes a false identity to persuade the victim to hand over information or perform an action. Where phishing relies on a lure message, pretexting relies on a **fabricated story and role-play**, often over a sustained conversation. The attacker builds the false scenario carefully: they research the target (job titles, vendors, internal jargon), then pose as someone with a legitimate reason to ask — an IT technician needing to "verify" your login, an auditor, a new employee, a supplier, or a senior manager. Because the request seems to come from a plausible authority and fits a routine situation, the victim's guard drops.

### Real-world case study
The **2020 Twitter hack** combined pretexting and vishing. Attackers phoned Twitter employees while posing as the company's own IT department, walking them through a fake "VPN problem" and directing them to a credential-harvesting page that mimicked Twitter's internal login. Using the stolen credentials and internal access, the attackers took over high-profile accounts (Obama, Musk, Apple and others) to run a Bitcoin scam. Twitter's own post-incident statements and the subsequent New York Department of Financial Services report confirmed the attack began with social engineering of staff — not a software flaw.

### Prevention measures
1. **Enforce strict identity verification for sensitive requests:** staff must authenticate callers/requesters through an established procedure (call-back to an official number, ticket verification) before sharing information or resetting access — "I'm from IT" is never sufficient.
2. **Apply least privilege and segregation of duties:** limit how much any single employee can do or access, so a successful pretext yields little, and require a second approver for high-impact actions.
3. **Train staff on authority- and urgency-based manipulation:** run awareness sessions (and simulated vishing calls) so employees recognise pretexting tactics and feel empowered to say "I'll call you back" without fear of seeming unhelpful.

---

## 4. Baiting

### How it works
**Baiting** lures victims with the promise of something enticing, exploiting **curiosity or greed**. It comes in two forms:

- **Physical baiting:** the attacker leaves **malware-infected USB drives** (sometimes labelled "Payroll" or "Confidential") in car parks, lobbies or restrooms. A curious employee plugs one into a company machine to see what's on it — and silently installs malware or a device that acts as a keyboard to run attacker commands.
- **Digital baiting:** victims are offered **free downloads** — pirated software, films, games, "free" gift cards — that are actually bundled with malware, or are directed to fake download sites.

### Real-world case study
Security researchers have repeatedly demonstrated how effective baiting is. In well-known **USB-drop experiments** — including a widely reported 2016 University of Illinois study — researchers scattered hundreds of USB sticks across a campus; a large proportion were picked up and plugged into computers, with many users opening the files on them. The experiment proved that attackers can reliably get malicious USBs onto target machines simply by relying on human curiosity. Real attacks follow the same logic, and the FBI has warned of criminal campaigns mailing malicious "BadUSB" devices to organisations disguised as gifts or invoices.

### Prevention measures
1. **Disable or control removable media:** use endpoint policies that block auto-run and restrict or whitelist USB devices; where USB access isn't needed, disable the ports.
2. **Deploy endpoint protection and application whitelisting:** modern EDR/antivirus and allow-listing stop unknown executables (from a USB or a download) from running even if a user tries to open them.
3. **Educate users never to use untrusted media or downloads:** teach employees to hand any found USB device to IT/security rather than plugging it in, and to download software only from official, approved sources.

---

## 5. Quid Pro Quo (Bonus)

### Explanation
**Quid pro quo** ("something for something") is a variant of social engineering in which the attacker offers a **service or benefit in exchange** for information or access. The classic example is an attacker cold-calling employees across a company claiming to be IT support offering to "fix a problem" or "speed up your computer." Sooner or later they reach someone who genuinely has an issue; in "helping," the attacker instructs the grateful victim to disable security software, install a "tool" (malware), or read out their password. Unlike baiting (which dangles a tempting item) the lure here is a **helpful service** and reciprocity — the victim feels they are getting value in return.

### Prevention
- **Strict policy that IT never asks for passwords** and never cold-calls to "fix" unrequested issues — and make sure every employee knows it, so an unsolicited offer of help is itself the red flag.
- **Verified support channels only:** require that all technical support flow through an official ticketing/help-desk process with caller verification, so employees can confirm a "helper" is genuine.
- **Awareness training on reciprocity manipulation** and clear, blame-free reporting so staff report suspicious "support" offers immediately.

---

## 6. Comparison Table

| Attack Type | Primary Target | Psychological Lever Exploited | Best Countermeasure |
|---|---|---|---|
| **Phishing** | Mass users or specific individuals (spear/whaling) via email/SMS/voice | Urgency, fear, trust in a known brand/authority | Phishing-resistant MFA + email filtering (SPF/DKIM/DMARC) + report-and-verify training |
| **Pretexting** | Employees with access to data/systems (help-desk, finance, staff) | Trust in authority, desire to be helpful, plausibility of a routine scenario | Strict identity verification / call-back procedures before acting on any sensitive request |
| **Baiting** | Curious employees; anyone seeking "free" items | Curiosity, greed | Block/control removable media + endpoint protection + "never use untrusted media/downloads" training |
| **Quid Pro Quo** | Employees with a genuine problem to solve | Reciprocity ("help in exchange for access") | Policy that IT never asks for passwords + verified official support channels |

---

## 7. Organisational Recommendations — Employee Awareness Training Checklist

A 5-point security awareness training programme every organisation should implement:

1. **Run regular, mandatory awareness training** for all staff (at onboarding and at least annually), covering phishing, pretexting, baiting and quid pro quo with concrete, up-to-date examples relevant to their roles.
2. **Conduct simulated phishing and vishing campaigns** throughout the year to measure susceptibility, then provide immediate, *non-punitive* coaching to anyone who falls for a simulation — the goal is learning, not blame.
3. **Establish and publicise clear reporting procedures** — a one-click "Report Phishing" button and a known security contact — and praise reporting, so employees raise the alarm fast instead of hiding mistakes.
4. **Define and enforce verification policies** for sensitive actions: out-of-band confirmation for any payment, payment-detail change or credential/access request; IT never asks for passwords; always verify a caller's identity via an official channel.
5. **Reinforce technical controls that back up the human layer:** deploy phishing-resistant MFA, email authentication and filtering, least-privilege access, and removable-media/endpoint controls — so that when training inevitably fails for one person, technology limits the damage.

---

## 8. References

1. **Verizon — *Data Breach Investigations Report (DBIR)*** (latest annual edition). https://www.verizon.com/business/resources/reports/dbir/
2. **CISA — *Avoiding Social Engineering and Phishing Attacks* (ST04-014)** and related guidance. Cybersecurity and Infrastructure Security Agency. https://www.cisa.gov/news-events/news/avoiding-social-engineering-and-phishing-attacks
3. **FBI Internet Crime Complaint Center (IC3) — *Internet Crime Report*** (Business Email Compromise statistics). https://www.ic3.gov/
4. **NIST SP 800-50 / SP 800-61 — *Building an Information Technology Security Awareness and Training Program* / *Computer Security Incident Handling Guide*.** National Institute of Standards and Technology. https://csrc.nist.gov/
5. **MITRE ATT&CK — *Phishing* (T1566), *Phishing for Information* (T1598).** The MITRE Corporation. https://attack.mitre.org/
6. **SANS Institute — Security Awareness & reading-room papers on social engineering.** https://www.sans.org/
7. **New York State Department of Financial Services — *Twitter Investigation Report* (October 2020).** https://www.dfs.ny.gov/
