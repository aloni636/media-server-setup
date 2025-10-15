# TODOs
- [ ] Add [decluttarr](https://github.com/ManiMatter/decluttarr)
- [ ] Add [Raspberry Pi V4L2 hardware acceleration](https://docs.linuxserver.io/images/docker-jellyfin/?utm_source=chatgpt.com#v4l2-raspberry-pi)
- [ ] Add docker rollout for zero downtime deployments

## Security
- [ ] Segment network between arr and jellyfin

# Security
## Docker Container Capabilities
- `CHOWN` capability is necessary for root directories permission modification as startup (like `/app` for Jellyfin, etc).

# Mounting Hard Drives
- On Rapberry Pi OS disable automount with `sudo systemctl disable udisks2.service` to have explicit contorl over mounting.
- Run `lsblk -f` to gather details about the hard drive.
- Fill the details (devide UUID and fstype) in a new `/etc/fstab` entry. Fill the rest of the options for your liking: 
    `<device>   <mountpoint>   <fstype>   <options>   <dump>   <pass>`  
    I use: `defaults,noexec,nodev,nosuid,noatime,nofail,x-systemd.automount,x-systemd.device-timeout=10s`
- Reload systemd cached fstab entries: `sudo systemctl daemon-reload`
- Mount (first time) using `sudo mount -a` or (after modifying fstab) `sudo mount -o remount <mountpoint>`
- For filesystems which store ownership and permissions, setup permissions for the mount point by using: `sudo chown -R <user id>:<user group> <mountpoint>`

# Config
Use `.env.example` for the list of **cross compose services** configuration. Create a `.env`

# Setup Hints
- **Qbittorrent** uses `admin` username and generates a one time admin password for first time login.