# Don't flash in recovery!
if ! $BOOTMODE; then
    ui_print "*********************************************************"
    ui_print "! Install from recovery is NOT supported"
    ui_print "! Recovery sucks"
    ui_print "! Please install from Magisk / KernelSU / APatch app"
    abort    "*********************************************************"
fi

# Error on < Android 8
if [ "$API" -lt 26 ]; then
    abort "! You can't use this module on Android < 8.0"
fi

check_zygisk() {
    local ZYGISK_MODULE="/data/adb/modules/zygisksu"
    local REZYGISK_MODULE="/data/adb/modules/rezygisk"
    local MAGISK_DIR="/data/adb/magisk"
    local ZYGISK_MSG="Zygisk is not enabled. Please either:
    - Enable Zygisk in Magisk settings
    - Install ZygiskNext or ReZygisk module"

    # Check if Zygisk module directory exists
    if [ -d "$ZYGISK_MODULE" ] || [ -d "$REZYGISK_MODULE" ]; then
        return 0
    fi

    # If Magisk is installed, check Zygisk settings
    if [ -d "$MAGISK_DIR" ]; then
        # Query Zygisk status from Magisk database
        local ZYGISK_STATUS
        ZYGISK_STATUS=$(magisk --sqlite "SELECT value FROM settings WHERE key='zygisk';")

        # Check if Zygisk is disabled
        if [ "$ZYGISK_STATUS" = "value=0" ]; then
            abort "$ZYGISK_MSG"
        fi
    else
        abort "$ZYGISK_MSG"
    fi
}

# Module requires Zygisk to work
check_zygisk

# safetynet-fix module is obsolete and it's incompatible with PIF
SNFix="/data/adb/modules/safetynet-fix"
if [ -d "$SNFix" ]; then
    ui_print "! safetynet-fix module is obsolete and it's incompatible with PIF, it will be removed on next reboot"
    ui_print "! Do not install it"
    touch "$SNFix"/remove
fi

# playcurl warn
if [ -d "/data/adb/modules/playcurl" ]; then
    ui_print "! playcurl may overwrite fingerprint with invalid one, be careful!"
fi

# MagiskHidePropsConf module is obsolete in Android 8+ but it shouldn't give issues
if [ -d "/data/adb/modules/MagiskHidePropsConf" ]; then
    ui_print "! WARNING, MagiskHidePropsConf module may cause issues with PIF."
fi

# Preserve previous setting
if [ -f "/data/adb/modules/playintegrityfix/pif.prop" ]; then
    spoofConfig="spoofBuild spoofProvider spoofProps spoofSignature DEBUG spoofVendingSdk"
    for config in $spoofConfig; do
        grep -q "$config" "/data/adb/modules/playintegrityfix/pif.prop" || continue
        if grep -q "$config=true" "/data/adb/modules/playintegrityfix/pif.prop"; then
            sed -i "s/$config=.*/$config=true/" "$MODPATH/pif.prop"
        else
            sed -i "s/$config=.*/$config=false/" "$MODPATH/pif.prop"
        fi
    done
fi

# Restore previous settings
[ -f "/data/adb/modules/playintegrityfix/uninstall.sh" ] && cp -af /data/adb/modules/playintegrityfix/uninstall.sh "$MODPATH/uninstall.sh"

# Check custom fingerprint
if [ -f "/data/adb/pif.prop" ]; then
    ui_print "- Backup custom pif.prop"
    mv -f /data/adb/pif.prop /data/adb/pif.prop.old
fi

# give exec perm to autopif.sh
chmod +x "$MODPATH/autopif.sh"
chmod +x "$MODPATH/autopif_ota.sh"
