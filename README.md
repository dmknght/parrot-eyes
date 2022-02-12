Try to make a process watcher for Parrot OS (or any Debian's based distro)
Idea:
1. All installed packages are having checksum at `/var/lib/dpkg/info`. File ext md5sums. It's "trusted by package manager"
2. When new binary is executed, we compare it with database. Goal: warn user about untrusted binaries

Questionable:
1. LD_PRELOAD or lib*.so loads by binary
2. Custom script files run by interpreters
3. API to bypass
4. More?


This scripts uses execsnoop from https://github.com/iovisor/bcc/blob/master/tools/execsnoop.py to monitor new exec files

Comment from description: This won't catch all new processes: an application may fork() but not exec().

Requires: Nim >= 1.6.0, python3, python3-bpfcc
Nim lib: nimble install nimpy

TODO: build Nim to a lib and py script calls function from the lib