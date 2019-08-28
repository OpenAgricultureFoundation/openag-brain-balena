import dbus
import time

print("Restarting avahi-daemon via dbus")
time.sleep(5)
sysbus = dbus.SystemBus()
print("restart_mdns: Got system Bus")
systemd1 = sysbus.get_object('org.freedesktop.systemd1', '/org/freedesktop/systemd1')
print("restart_mdns: Got systemd")
manager = dbus.Interface(systemd1, 'org.freedesktop.systemd1.Manager')
print("restart_mdns: restarting avahi-daemon.service")
#manager.RestartUnit('avahi-daemon.service','replace')
manager.StopUnit('avahi-daemon.service','replace')
time.sleep(5)
manager.StartUnit('avahi-daemon.service','replace')
time.sleep(5)
print("Done")
