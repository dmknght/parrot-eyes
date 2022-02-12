#!/usr/bin/python
# @lint-avoid-python-3-compatibility-imports
#
# Port from:
# execsnoop Trace new processes via exec() syscalls.
#           For Linux, uses BCC, eBPF. Embedded C.
#
# This currently will print up to a maximum of 19 arguments, plus the process
# name, so 20 fields in total (MAXARG).
#
# This won't catch all new processes: an application may fork() but not exec().
#
# Copyright 2016 Netflix, Inc.
# Licensed under the Apache License, Version 2.0 (the "License")
#
# 07-Feb-2016   Brendan Gregg   Created this.

from bcc import BPF
from parrot_eyes import *
import libeyes


class EyesWatcher:
    def __init__(self):
        self.b = BPF(text=self.get_bff_config())
        self.setup_hook()
        self.checksum_db = libeyes.eyesParseDb()

    def get_bff_config(self):
        uid = ""
        text = bpf_text
        text = text.replace("MAXARG", "20")
        if uid:
            text = text.replace("UID_FILTER", "if (uid != %s) { return 0; }" % uid)
        else:
            text = text.replace("UID_FILTER", "")
        # text = filter_by_containers(args) + text
        return text

    def setup_hook(self):
        execve_fnname = self.b.get_syscall_fnname("execve")
        self.b.attach_kprobe(event=execve_fnname, fn_name="syscall__execve")
        self.b.attach_kretprobe(event=execve_fnname, fn_name="do_ret_sys_execve")

    def setup_callback(self, func):
        self.b["events"].open_perf_buffer(func)

    def setup_default_callback(self):
        self.b["events"].open_perf_buffer(self.default_watcher_calback)

    def default_watcher_calback(self, cpu, data, size):
        event = self.b["events"].event(data)

        if event.type == EventType.EVENT_ARG:
            path = event.argv.decode()
            checksum = libeyes.eyesGetMD5(path)
            print(f"{path} {checksum}")
            if not libeyes.eyesCmpDb(checksum, self.checksum_db):
                print(f"Untrusted {checksum} {path}")

    def run(self):
        while 1:
            try:
                self.b.perf_buffer_poll()
            except KeyboardInterrupt:
                exit()
