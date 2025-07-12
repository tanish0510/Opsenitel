# 🛡️ OpsSentinel

**Self-Healing System Automation & DevOps Pipeline Toolkit**  
A modular Linux-based utility designed to diagnose and fix system-level issues like disk pressure, memory-intensive processes, and oversized logs — integrated with a secure CI/CD workflow for cloud-native deployment.

---

## 📸 Architecture

![OpsSentinel Architecture](https://github.com/tanish0510/Opsenitel/blob/main/http_server/arch.jpeg)

> _Add your system architecture diagram above — shows script flow, automation triggers, and CI/CD lifecycle._

---

## 🔧 Features

- Automated cleanup of `/tmp` and log files based on disk pressure thresholds.
- Dynamic system monitoring and audit report generation (`/opt/audit/summary.txt`).
- Modular Bash functions:
  - `check_disk_usage`
  - `clean_temp_files`
  - `report_large_logs`
  - `audit_user_activity`
- HTML dashboard (via NGINX/Python3 HTTP server) to view live audit results.
- Reverse debugging logic to catch automation failures.
- Error handling with timestamps and self-healing recovery.

---

## 🚀 DevOps Integration

- **CI/CD Pipeline** with GitHub Actions:
  - Build Docker image on push.
  - Run Trivy vulnerability scans.
  - Apply Terraform plans on PR merge.
  - Push final image to AWS ECR.

- **Infrastructure as Code (IaC):**
  - Terraform for cloud resource provisioning.
  - Shell scripts for system-level automation.

---

## ⚙️ Setup & Usage
```
# Setup your required secrets in Secrets and Variables > repo settings > your repo section

# 🔧 Run the script manually
bash ./tasks.sh

# 🌐 Serve the HTML report using NGINX

# 1. Clone the repository and run `pwd` to get the current directory path.
# 2. Update the NGINX configuration:
#    - Set the `root` directive to the output of `pwd`.
#    - Set `index` to `index.html`.
# 3. Restart NGINX and open: http://localhost:8080

# 🕒 Set up as a CRON job for daily automation
0 2 * * * /full/path/to/maintain.sh

