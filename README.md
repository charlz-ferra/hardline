# hardline

[![ci](https://github.com/charlz-ferra/hardline/actions/workflows/ci.yml/badge.svg)](https://github.com/charlz-ferra/hardline/actions/workflows/ci.yml)

> A dependency-free Linux hardening auditor in a single bash file.
> No pip, no apt, no agent, no daemon — `scp` it to a box, run it, read the grade.

`hardline` answers the 3am question every self-hoster eventually asks: _"is this
server actually locked down, or do I just feel safe?"_ It runs ~40 read-only
checks across SSH, kernel sysctls, firewall, accounts, filesystem and services,
then prints a colored report and a letter grade.

```text
── SSH
  [PASS] Root SSH login disabled — PermitRootLogin=no
  [PASS] Password auth disabled — keys only
  [WARN] SSH on default port 22 — noisy; not security but cuts log spam

── Firewall
  [FAIL] No active firewall detected — ufw/firewalld/nftables/iptables all idle
  [WARN] fail2ban not running — SSH brute-force goes unthrottled

── Summary
  PASS 31   WARN 5   FAIL 1   SKIP 3
  Score: 85/100   Grade: C
```

## Why

Most hardening tools are either a 4000-line compliance monster (Lynis, OpenSCAP)
or a config-management dependency you don't want on a throwaway VPS. `hardline`
is the in-between: one file you can read in five minutes, audit yourself, and
trust. It only **reads** — it never edits a config, restarts a service, or
phones home. Every finding tells you where to look; the fix stays your call.

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/charlz-ferra/hardline/main/hardline -o hardline
chmod +x hardline
./hardline
```

Or drop it in your `$PATH`:

```bash
sudo install -m 755 hardline /usr/local/bin/
```

## Usage

```bash
hardline                # full audit, human-readable report
sudo hardline           # also reads root-only files (/etc/shadow, sudoers)
hardline --json         # machine-readable, for CI / dashboards
hardline --quiet        # only WARN/FAIL lines + summary
hardline --no-color     # strip ANSI for logs and pipes
```

A few checks (empty-password scan, NOPASSWD sudo rules, full sshd config) need
root to read their source files — without `sudo` they report `SKIP`, never a
false `PASS`.

**Exit code:** `0` when there are no `FAIL`s, `1` if any check fails, `2` on a
bad argument. Drop it in cron or CI and alert on non-zero.

## What it checks

| Section            | Examples                                                                     |
| ------------------ | ---------------------------------------------------------------------------- |
| SSH                | root login, password auth, empty passwords, MaxAuthTries, X11, port          |
| Kernel / sysctl    | rp_filter, redirects, syncookies, ASLR, kptr/dmesg restrict, protected links |
| Firewall           | ufw / firewalld / nftables / iptables default-drop, fail2ban jails           |
| Accounts & sudo    | extra UID-0 accounts, empty passwords, NOPASSWD rules                        |
| Filesystem         | world-writable & unowned files, SUID baseline, `/tmp` noexec                 |
| Updates & services | unattended-upgrades, services bound to `0.0.0.0`, coredump handling          |

## Grading

Score is `(PASS + WARN×0.5) / total`. Letter grades run F→A+, **and any single
`FAIL` caps the grade at C** — because one open door undoes a lot of good locks.
`SKIP`s don't count against you; they just mean "couldn't read it, run me as
root."

## JSON

```bash
hardline --json | jq '.checks[] | select(.status=="FAIL")'
```

```json
{
  "version": "1.0.0",
  "score": 85,
  "grade": "C",
  "pass": 31,
  "warn": 5,
  "fail": 1,
  "skip": 3,
  "checks": [
    {
      "section": "SSH",
      "status": "PASS",
      "check": "Root SSH login disabled",
      "detail": "PermitRootLogin=no"
    }
  ]
}
```

## Scope & honesty

`hardline` is a fast first-pass sanity check, not a compliance certification.
It catches the things people actually get wrong, not every CIS line item. A
green grade means "no obvious doors left open," not "audited to a standard."
For deep compliance work, reach for Lynis or OpenSCAP — and then come back here
for the quick daily pulse.

## License

[MIT](LICENSE)
