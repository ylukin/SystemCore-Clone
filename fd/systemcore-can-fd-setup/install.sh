#!/bin/bash
# Install the DIY SystemCore CAN bring-up onto a SystemCore-base image.
# Idempotent: safe to re-run. Run as root (sudo).
set -e

if [ "$(id -u)" != "0" ]; then
  echo "Please run as root:  sudo ./install.sh" >&2
  exit 1
fi

DIR="$(cd "$(dirname "$0")" && pwd)"

echo "==> Installing /usr/local/sbin/diy-can-setup.sh"
mkdir -p /usr/local/sbin
install -m 0755 "$DIR/diy-can-setup.sh" /usr/local/sbin/diy-can-setup.sh

echo "==> Installing /etc/systemd/system/can-bringup.service"
install -m 0644 "$DIR/can-bringup.service" /etc/systemd/system/can-bringup.service

# The stock limelight_canbusprocess assumes all of can_s0..can_s4 are real controllers. On our
# vcan dummies "ip link set ... type can bitrate" fails, so it leaves can_s2 DOWN and restarts
# every 5s, bouncing the physical buses each time. Override it to skip the vcan buses.
echo "==> Installing /usr/local/sbin/diy-canbusprocess.sh + limelight_canbusprocess drop-in"
install -m 0755 "$DIR/diy-canbusprocess.sh" /usr/local/sbin/diy-canbusprocess.sh
mkdir -p /etc/systemd/system/limelight_canbusprocess.service.d
install -m 0644 "$DIR/limelight_canbusprocess-diy.conf" /etc/systemd/system/limelight_canbusprocess.service.d/diy.conf

# robot.service waits for every can_s* to report "state UP", but vcan reports "state UNKNOWN",
# so each robot start logged "can_sX down" / "could not find can bus interfaces" for 15s.
echo "==> Installing robot.service drop-in (accept vcan UNKNOWN state)"
mkdir -p /etc/systemd/system/robot.service.d
install -m 0644 "$DIR/robot-diy.conf" /etc/systemd/system/robot.service.d/diy.conf

# robot_heartbeat must NOT auto-load from modules-load.d: it runs before any CAN
# interface exists and fails ("No such device"). Our service loads it at the right time.
if [ -e /etc/modules-load.d/robot_heartbeat.conf ]; then
  echo "==> Removing premature robot_heartbeat from /etc/modules-load.d/"
  rm -f /etc/modules-load.d/robot_heartbeat.conf
fi

echo "==> Enabling can-bringup.service"
systemctl daemon-reload
systemctl enable can-bringup.service

echo
echo "Done. Apply now with:   sudo systemctl restart can-bringup limelight_canbusprocess && sudo systemctl restart robot"
echo "...or just reboot. Verify with:   ls /dev/mrccan/ ; ip -br link show | grep can_s"
