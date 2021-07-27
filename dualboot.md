# Dual booting Windows and Linux - Notes

## Timezone differences between Windows and Linux

By default, Windows stores time in the local timezone on hardware while Linux storse time in UTC on hardware.

[Windows may misbehave if forced to store time in UTC on
hardware.](https://www.howtogeek.com/323390/how-to-fix-windows-and-linux-showing-different-times-when-dual-booting/)
Hence, the recommended solution is to adjust Linux to store local time on hardware by issuing the command.
```
timedatectl set-local-rtc 1 --adjust-system-clock
```

This can be verified by running `timedatectl`.

To undo this change, do
```
imedatectl set-local-rtc 0 --adjust-system-clock
```



## WiFi not being enabled when booting Linux after booting Windows

1. Boot into Windows
2. Open Device Manager
3. WiFi Adapter > Properties
4. Disable 'Allow Windows to turn off this device to save power'
5. Reboot


## Bluetooth devices not being shared between Linux and Windows

Refer to [this](https://wiki.archlinux.org/title/Bluetooth#Dual_boot_pairing).

For BLE devices, follow
[this](https://wiki.archlinux.org/title/Bluetooth#Dual_boot_pairing).

Note that Windows must be fully shutdown (i.e. not in hibernation).


## Mounting Windows partitions in Linux

Note that Windows partitions should not be accessed if only hibernation was
done in Windows (instead of a full shutdown).

### Setup

1. Create a directory to act as a mount point.

2. Find which partition is NTFS by using:
    `sudo fdisk -l`

3. (Optional) Install `ntfs-3g` driver e.g. `apt install ntfs-3g`

### Manual mounting

4. Run `sudo mount -t ntfs[-3g] oi umask=PERMISSIONS PARTITION MOUNT-POINT`
    - PERMISSIONS is indicated in octal (e.g. 0222 for readonly, 0777 for rwx)
    - PARTITION is read from the first step (`sudo fdisk -l`)

5. Once done, `sudo umount MOUNT-POINT`

### Automatic mount on reboot

4. Edit `/etc/fstab`. [Reference](https://www.redhat.com/sysadmin/etc-fstab).
    - The first column, UUID is read from step 1.
    - The second column is the mount point.
    - The third column is the driver to be used (ntfs or ntfs-3g).
    - The fourth column is the permissions. (`auto`/`noauto` controls whether the partition is mounted automatically on
      boot; `exec`/`noexec` controls whether the partition can execute binaries - usually `noexec`; `ro`/`rw` controls
      read and write privileges; `nouser`/`user` controls whether the user has mounting privileges)
    - The fifth column is obsolete and should be set to `0`.
    - The sixth column is the filesystem check order. `0` means `fsck` will not check the filesystem. The root
      filesystem should be set to `1` and other partitions set to `2`.

```
UUID=xxxxxxxxx   /mnt/c    ntfs-3g auto,noexec,rw   0       2
```

