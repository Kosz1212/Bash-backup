# AutoBackup

🗂️ **Automated Bash Backup Script – Timestamped Archives + Cleanup + Logging**

---

## 📁 About

**AutoBackup** is a Bash script that creates compressed backups (`.tar.gz`) of selected directories. It’s designed to run automatically (e.g., daily at 22:00), stores backups in a dedicated folder, logs each action, and automatically deletes archives older than 7 days.

> 🐧 **Built and tested on [NixOS](https://nixos.org/)** – compatible with most other Linux distributions with minimal changes.

---

## 📦 What It Does

- 🔄 Compresses multiple folders using `tar`
- 🕒 Names each archive using the current date and time (e.g., `2025-04-02-22-00.tar.gz`)
- 💾 Saves backups to:  
  ```bash
  $HOME/Backups
  ```
- 🧹 Deletes archives older than 7 days
- 📝 Logs actions to:

```bash
$HOME/Logs/sorter-YYYY-MM-DD.log
```
---
## ⚙️ Setup & Usage
1. Clone or copy the script to your machine
2. Make it executable:
```bash
chmod +x backup.sh
```
3. Run manually to test:
```bash
./backup.sh
```
---
## 🕒 Automate with systemd (recommended for NixOS)
To run the script daily at 22:00, use a `systemd timer`.

`~/.config/systemd/user/backup.service`

```ini
[Unit]
Description=Run backup script

[Service]
Type=oneshot
ExecStart=%h/path/to/backup.sh
```
`~/.config/systemd/user/backup.timer`
```ini
[Unit]
Description=Daily backup at 22:00

[Timer]
OnCalendar=*-*-* 22:00:00
Persistent=true

[Install]
WantedBy=timers.target
```
Enable with:

```bash
systemctl --user daemon-reload
systemctl --user enable --now backup.timer
```
---
## 📋 Notes
- ❗ Be careful not to include the folder where the script lives in your backups – this may cause an infinite loop
- ✅ You can customize which directories are backed up inside the script (`source_dir=(...)`)
- 🔍 Logs are rotated automatically (you can modify the retention period)

---

**Maintained by [Kosz1212](https://github.com/Kosz1212)**
