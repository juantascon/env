#! /usr/bin/env python3

import sys
import os
import io
import argparse
import babelfish
import subliminal

def path_multi(video, lang):
  return "{}.{}.multisubs".format(os.path.splitext(video.name)[0], lang)

def path_sub(video, lang, index):
  return "{}.{}_{:02d}.srt".format(os.path.splitext(video.name)[0], lang, index)

parser = argparse.ArgumentParser()
parser.add_argument("dir", help="directory to be scanned")
parser.add_argument("-l", "--lang", default="es", help="2 char languange code, default: es")
args = parser.parse_args()

lang = babelfish.Language.fromietf(args.lang)
all_videos = subliminal.scan_videos(args.dir)
videos = [video for video in all_videos if not os.path.isfile(path_multi(video, args.lang))]

subliminal.region.configure("dogpile.cache.dbm", arguments={"filename": "/tmp/subtitler.cachefile.dbm"})
all_subs = subliminal.list_subtitles(videos, {lang})

for video in videos:
  subs = all_subs[video]
  subliminal.download_subtitles(subs)
  for i in range(0,len(subs)):
    sub = subs[i]
    if sub.text is None:
      continue
    path = path_sub(video, args.lang, i)
    with io.open(path, "w", encoding="utf-8") as f:
      f.write(sub.text)
  os.mknod(path_multi(video, args.lang))
