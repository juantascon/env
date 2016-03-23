#! /usr/bin/env python3

import os, socket, sys, struct, argparse

PORT=5000
CHUNK_LEN=16384

parser = argparse.ArgumentParser(description="FBI cia send tool")
parser.add_argument("ip")
parser.add_argument("cia")

args = parser.parse_args()

sock = socket.socket()
sock.connect((args.ip, PORT))

print("sending cia info ...")
info = struct.pack("!q", os.stat(args.cia).st_size)
sock.send(info)

print("sending cia file ...")
with open(args.cia, "rb") as fd:
    while True:
        chunk = fd.read(CHUNK_LEN)
        if not chunk:
            break  # EOF
        sock.sendall(chunk)
print("done")

sock.close()
sys.exit()
