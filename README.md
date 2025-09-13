# Homelab Configurations

These are all my docker-compose files for my homelab. I have hidden most configurations for most services because they contain sensitive information. It may be the case for some services that they don't contain sensitive information, but I don't really have the time to look through it in detail. I may do this later.

---

### Remote Access

I access my homelab externally with Tailscale. It's very easy, and you don't have to expose any ports on your router. I have previously always used Nextcloud tunnels, but it became an issue with Jellyfin and transcoding. 

---

### Hardware

I run everything on my Raspberry Pi 5. I'm currently looking to expand.

---

### Version Control & Backups

I use a local Gitea server on my Raspberry Pi as my main repository. For backups, i have a Git remote set up to automatically push all changes to this public github repo. 

Here's how i configured it:
'''
sander@raspberrypi:~/docker $ git remote -v
origin	http://localhost:3000/admin/homelab-config.git (fetch)
origin	http://raspberrypi:3000/admin/homelab-config.git (push)
origin	https://github.com/Sander-Mirck/homelab-config.git (push)
'''

If somebody has a tip of how i could implement this better. Feel free to contact me.