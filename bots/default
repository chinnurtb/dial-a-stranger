#!/usr/bin/env python

import sys, struct

# ErlangPort by thanos vassilakis
class ErlangPort(object):
    PACK = '>H'
    def __init__(self):
        self._in = sys.stdin
        self._out = sys.stdout
        
    def recv(self):
        buf = self._in.read(2)
        (sz,) = struct.unpack(self.PACK, buf)
        return self._in.read(sz)
        
    def send(self, what):
        sz = len(what)
        buf = struct.pack(self.PACK, sz)
        self._out.write(buf)
        self._out.write(what)
        self._out.flush()

port = ErlangPort()
while True:
    request = port.recv()
    port.send(request)

