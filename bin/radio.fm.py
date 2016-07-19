#! /usr/bin/env python3

import subprocess, argparse, logging, os

logging.basicConfig(level=logging.DEBUG)

TUNES = [
    {"id": "ah", "url": "http://www.ah.fm/96k.m3u", "type": "list"},
    {"id": "pr", "url": "http://www.protonradio.com/itunes.pls", "type": "list"},
    {"id": "di", "url": "http://pub1.diforfree.org:8000/di_vocaltrance_hi", "type": "stream"},
    {"id": "fg", "url": "http://www.radiofg.com/streams/fg.pls", "type": "list"},
    {"id": "dt", "url": "http://www.discovertrance.com/DiscoverTrance-med.pls", "type": "list"},
    {"id": "etn", "url": "http://etn.fm/playlists/etn1-mp3-low.m3u", "type": "list"},
    {"id": "etnh", "url": "http://etn.fm/playlists/etn2-mp3-low.m3u", "type": "list"},
    {"id": "tm", "url": "http://www.technomusic.com/live/hi/pls", "type": "list"},
    {"id": "gr", "url": "http://www.grooveradio.com/streams/grooveradio-hb.pls", "type": "list"},
    {"id": "fr", "url": "http://www.friskyradio.com/frisky.m3u", "type": "list"},
    {"id": "hit", "url": "http://69.162.154.206:8232", "type": "list"},
    {"id": "rst", "url": "http://174.142.208.229:9467", "type": "list"}
]

parser = argparse.ArgumentParser(description = 'Radio.fm radio manager')
parser.add_argument('tune', choices=[t["id"] for t in TUNES], help = 'selects a tune')
parser.add_argument('-r', '--record', type=argparse.FileType('w'), metavar='FILE', default=None, help='records to FILE')

args, extra = parser.parse_known_args()

cmd = ["mpv"]

tune = next((t for t in TUNES if t["id"] == args.tune), False)
record = args.record

if tune:
    if tune["type"] == "list": cmd += ["--playlist"]
    cmd += [tune["url"]]

if record: cmd += ["--stream-dump", record.name]
if extra: cmd += extra

logging.info("running command: %s" % (" ".join(cmd)))

subprocess.call(cmd)
