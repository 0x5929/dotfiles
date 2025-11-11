#!/usr/bin/env bash
# Fix SYNA32E2 (HP Omen) I2C-HID when IRQ/DMA timeout kills the controller.
# - Drops idma64 (DMA engine), bounces DesignWare controller(s), rebinds i2c_hid_acpi
# - No-ops if the touchpad is already present
# Logs to journal with tag 'fix-syna32e2'

set -euo pipefail

TAG="fix-syna32e2"
log(){ logger -t "$TAG" -- "$*"; echo "[$TAG] $*"; }

# Quick presence check: is the SYNA device already registered?
if grep -q 'SYNA32E2:00' /proc/bus/input/devices 2>/dev/null; then
  log "SYNA32E2 already present; nothing to do."
  exit 0
fi

log "SYNA32E2 missing; attempting recovery..."

# 1) Disable DMA engine (prevents IRQ 27 storm/timeout in some kernels)
if lsmod | grep -q '^idma64'; then
  log "Unloading idma64…"
  modprobe -r idma64 || true
else
  log "idma64 not loaded; continuing."
fi

# 2) Bounce I2C-HID layer cleanly
for m in i2c_hid_acpi i2c_hid; do
  if lsmod | awk '{print $1}' | grep -qx "$m"; then
    log "Unloading $m…"
    modprobe -r "$m" || true
  fi
done

# 3) Rebind all DesignWare controllers found
DRV_DIR="/sys/bus/platform/drivers/i2c_designware"
if [[ -d "$DRV_DIR" ]]; then
  for dev in /sys/bus/platform/devices/i2c_designware.*; do
    [ -e "$dev" ] || continue
    name="$(basename "$dev")"
    if [[ -w "$DRV_DIR/unbind" && -w "$DRV_DIR/bind" ]]; then
      log "Unbind $name…"; echo "$name" > "$DRV_DIR/unbind" || true
      sleep 1
      log "Bind $name…"; echo "$name" > "$DRV_DIR/bind" || true
    else
      log "WARN: $DRV_DIR not writable; skipping bind/unbind."
    fi
  done
else
  log "WARN: DesignWare driver path not found."
fi

# 4) Bring I2C-HID back
log "Loading i2c_hid_acpi…"
modprobe i2c_hid_acpi || true

# 5) Keep device awake during/after probe (ignore if path absent)
DEV_KERN="i2c-SYNA32E2:00"
POW_CTRL="/sys/bus/i2c/devices/${DEV_KERN}/power/control"
if [[ -w "$POW_CTRL" ]]; then
  echo on > "$POW_CTRL" || true
  log "Set ${POW_CTRL} = on"
fi

# 6) (Re)bind just the SYNA node if driver path exists
DRV_I2C_HID="/sys/bus/i2c/drivers/i2c_hid_acpi"
if [[ -w "${DRV_I2C_HID}/unbind" && -w "${DRV_I2C_HID}/bind" ]]; then
  log "Rebinding ${DEV_KERN} to i2c_hid_acpi…"
  echo -n "${DEV_KERN}" > "${DRV_I2C_HID}/unbind" 2>/dev/null || true
  sleep 1
  echo -n "${DEV_KERN}" > "${DRV_I2C_HID}/bind"  2>/dev/null || true
fi

# 7) Report status
if grep -q 'SYNA32E2:00' /proc/bus/input/devices 2>/dev/null; then
  log "SUCCESS: SYNA32E2 is present again."
  # Show the key lines in the journal for debugging
  dmesg --ctime | grep -Ei "idma64|i2c_designware|i2c_hid|syna|irq.*27|nobody cared|probe" | tail -n 50 | while read -r L; do log "$L"; done
  exit 0
else
  log "FAIL: SYNA32E2 still missing after recovery attempt."
  dmesg --ctime | grep -Ei "idma64|i2c_designware|i2c_hid|syna|irq.*27|nobody cared|probe" | tail -n 100 | while read -r L; do log "$L"; done
  exit 1
fi

