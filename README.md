# Problems
- grafana, prometheus, qbittorrent-exporter services restarts every minute
- qbittorrent can't be logged in

# Solutions
- read the docs for each malfunctioned service
    - grafana
    - prometheus
    - qbittorrent-exporter

## qbittorrent
```
qbittorrent           | ******** Information ********
qbittorrent           | To control qBittorrent, access the WebUI at: http://localhost:8080
qbittorrent           | The WebUI administrator username is: admin
qbittorrent           | The WebUI administrator password was not set. A temporary password is provided for this session: uaetVnq66
qbittorrent           | You should set your own password in program preferences.
qbittorrent           | Connection to localhost (::1) 8080 port [tcp/http-alt] succeeded!
```
Q: Looks like qbittorrent username and password were not registered.
A: From the docker image docs: "The web UI is at <your-ip>:8080 and a temporary password for the admin user will be printed to the container log on startup."

Q: Looks like I cannot change the default admin password
A: 


## grafana
Q: Looks like we have permissions problems:
```
grafana               | mkdir: can't create directory '/var/lib/grafana/plugins': Permission denied
grafana exited with code 1
```

```
grafana               | GF_PATHS_DATA='/var/lib/grafana' is not writable.
grafana               | You may have issues with file permissions, more information here: http://docs.grafana.org/installation/docker/#migrate-to-v51-or-later
```
A: Fixed with permissions managed by docker using volumes

```
grafana               | /run.sh: line 59: /run/secrets/gf_security_admin_password: Permission denied
grafana               | Getting secret GF_SECURITY_ADMIN_PASSWORD from /run/secrets/gf_security_admin_password
grafana               | Getting secret GF_SECURITY_ADMIN_PASSWORD from /run/secrets/gf_security_admin_password
grafana               | /run.sh: line 59: /run/secrets/gf_security_admin_password: Permission denied
grafana exited with code 1
grafana               | Getting secret GF_SECURITY_ADMIN_PASSWORD from /run/secrets/gf_security_admin_password
grafana               | /run.sh: line 59: /run/secrets/gf_security_admin_password: Permission denied
grafana               | /run.sh: line 59: /run/secrets/gf_security_admin_password: Permission denied
grafana               | Getting secret GF_SECURITY_ADMIN_PASSWORD from /run/secrets/gf_security_admin_password
grafana               | Getting secret GF_SECURITY_ADMIN_PASSWORD from /run/secrets/gf_security_admin_password
grafana               | /run.sh: line 59: /run/secrets/gf_security_admin_password: Permission denied
grafana               | Getting secret GF_SECURITY_ADMIN_PASSWORD from /run/secrets/gf_security_admin_password
grafana               | /run.sh: line 59: /run/secrets/gf_security_admin_password: Permission denied
grafana               | Getting secret GF_SECURITY_ADMIN_PASSWORD from /run/secrets/gf_security_admin_password
grafana               | /run.sh: line 59: /run/secrets/gf_security_admin_password: Permission denied
grafana               | Getting secret GF_SECURITY_ADMIN_PASSWORD from /run/secrets/gf_security_admin_password
grafana               | /run.sh: line 59: /run/secrets/gf_security_admin_password: Permission denied
grafana               | Getting secret GF_SECURITY_ADMIN_PASSWORD from /run/secrets/gf_security_admin_password
grafana               | /run.sh: line 59: /run/secrets/gf_security_admin_password: Permission denied
grafana               | Getting secret GF_SECURITY_ADMIN_PASSWORD from /run/secrets/gf_security_admin_password
grafana               | /run.sh: line 59: /run/secrets/gf_security_admin_password: Permission denied
grafana               | Getting secret GF_SECURITY_ADMIN_PASSWORD from /run/secrets/gf_security_admin_password
grafana               | /run.sh: line 59: /run/secrets/gf_security_admin_password: Permission denied
grafana               | Getting secret GF_SECURITY_ADMIN_PASSWORD from /run/secrets/gf_security_admin_password
grafana               | /run.sh: line 59: /run/secrets/gf_security_admin_password: Permission denied
grafana               | /run.sh: line 59: /run/secrets/gf_security_admin_password: Permission denied
grafana               | Getting secret GF_SECURITY_ADMIN_PASSWORD from /run/secrets/gf_security_admin_password
grafana               | Getting secret GF_SECURITY_ADMIN_PASSWORD from /run/secrets/gf_security_admin_password
grafana               | /run.sh: line 59: /run/secrets/gf_security_admin_password: Permission denied
grafana               | Getting secret GF_SECURITY_ADMIN_PASSWORD from /run/secrets/gf_security_admin_password
grafana               | /run.sh: line 59: /run/secrets/gf_security_admin_password: Permission denied
grafana               | Getting secret GF_SECURITY_ADMIN_PASSWORD from /run/secrets/gf_security_admin_password
grafana               | /run.sh: line 59: /run/secrets/gf_security_admin_password: Permission denied
grafana               | Getting secret GF_SECURITY_ADMIN_PASSWORD from /run/secrets/gf_security_admin_password
grafana               | /run.sh: line 59: /run/secrets/gf_security_admin_password: Permission denied
grafana               | Getting secret GF_SECURITY_ADMIN_PASSWORD from /run/secrets/gf_security_admin_password
grafana               | /run.sh: line 59: /run/secrets/gf_security_admin_password: Permission denied
grafana               | Getting secret GF_SECURITY_ADMIN_PASSWORD from /run/secrets/gf_security_admin_password
grafana               | /run.sh: line 59: /run/secrets/gf_security_admin_password: Permission denied
grafana               | Getting secret GF_SECURITY_ADMIN_PASSWORD from /run/secrets/gf_security_admin_password
grafana               | /run.sh: line 59: /run/secrets/gf_security_admin_password: Permission denied
```
Q: Looks like grafana encounter problems accessing secrets

## prometheus
I have error loading config in:
```
prometheus            | time=2025-06-27T05:26:27.569Z level=ERROR source=main.go:631 msg="Error loading config (--config.file=/etc/prometheus/prometheus.yml)" file=/etc/prometheus/prometheus.yml err="open /etc/prometheus/prometheus.yml: no such file or directory"
```

# TODOs
- [ ] Consider pairing up `ffsubsync` with Bazarr