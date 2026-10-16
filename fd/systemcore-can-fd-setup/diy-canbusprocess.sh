#!/bin/bash
# DIY SystemCore replacement for limelight_canbusprocess's ExecStart.
# The stock service assumes can_s0..can_s4 are all real CAN controllers; on vcan dummies
# "ip link set ... type can bitrate" fails, aborting the chain with can_s2 left DOWN and
# restarting every 5s (bouncing the real buses each time). Tune physical buses only and
# just keep the vcan dummies up.
cfg(){ ethtool "$@"; rc=$?; [ $rc -eq 0 ] || [ $rc -eq 80 ]; }
BUSES="can_s0 can_s1 can_s2 can_s3 can_s4"

for i in $(seq 1 50); do
  ok=1
  for b in $BUSES; do ip link show $b >/dev/null 2>&1 || ok=0; done
  [ $ok = 1 ] && break
  sleep 0.1
done

for b in $BUSES; do
  if ip -d link show $b | grep -qw vcan; then
    ip link set $b up || exit 1
  else
    ip link set $b down && \
    ip link set $b type can bitrate 1000000 fd off && \
    cfg -G $b rx 32 tx 8 && \
    cfg -C $b rx-frames-irq 16 rx-usecs-irq 500 && \
    ip link set $b txqueuelen 1000 && \
    ip link set $b up || exit 1
  fi
done

modprobe robot_heartbeat && modprobe i2c-dev
