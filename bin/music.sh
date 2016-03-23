#!/bin/bash

mpvfifo="$XDG_RUNTIME_DIR"/mpv.fifo

case "$1" in
    "toggle")
        qdbus org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause ;
        echo "cycle pause" >> $mpvfifo;;
    "next")
        qdbus org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next ;
        echo "playlist_next" >> $mpvfifo;;
    "prev")
        qdbus org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous ;
        echo "playlist_prev" >> $mpvfifo;;
    *) echo "usage: $0 <toggle|next|prev>";;
esac
