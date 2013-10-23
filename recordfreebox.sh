#!/bin/sh
#Ce script permet de regarder les chaînes de la freebox à partir du terminal
#Copyright (C) 2010 Michaël Malter
#This program is free software: you can redistribute it and/or modify
#it under the terms of the GNU General Public License version 3 as
#published by the Free Software Foundation.

#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.

#You should have received a copy of the GNU General Public License
#along with this program.  If not, see <http://www.gnu.org/licenses/>.

mkdir $HOME/.freeboxtv
mkdir $HOME/.freeboxtv/videos
rm $HOME/.freeboxtv/.playlistfbx 2> /dev/null
rm $HOME/.freeboxtv/.playlistfbxidx 2> /dev/null
rm $HOME/.freeboxtv/.playlistfbxadr 2> /dev/null
rm $HOME/.freeboxtv/.newplaylistfbxadr 2> /dev/null
rm $HOME/.freeboxtv/.newplaylistfbxidx 2> /dev/null
wget "http://mafreebox.freebox.fr/freeboxtv/playlist.m3u" -O "$HOME/.freeboxtv/.playlistfbx"
grep "^#EXTINF" $HOME/.freeboxtv/.playlistfbx | cut -d"-" -f2 >> $HOME/.freeboxtv/.playlistfbxidx
grep "^rtsp" $HOME/.freeboxtv/.playlistfbx >> $HOME/.freeboxtv/.playlistfbxadr
nb=`wc -l $HOME/.freeboxtv/.playlistfbxidx | awk '{ print $1 }'`
while [ $nb -ne 0 ]
do
	nomchaine=`head -n $nb $HOME/.freeboxtv/.playlistfbxidx | tail -n 1`
	echo "$nb - $nomchaine" >> $HOME/.freeboxtv/.newplaylistfbxidx
	nb=$(($nb - 1))
done

nomchaine=`head -n $1 $HOME/.freeboxtv/.playlistfbxidx | tail -n 1 | sed 's/ //g'`
date=`date +%d-%m-%Y-%H%M`
mplayer -cache 3000 -dumpstream `head -n $1 $HOME/.freeboxtv/.playlistfbxadr | tail -n 1` -dumpfile $HOME/.freeboxtv/videos/$nomchaine-$date 2> $HOME/.freeboxtv/$nombchaine-$date.log &
sleep $2
kill $!
rm $HOME/.freeboxtv/.playlistfbx 2> /dev/null
rm $HOME/.freeboxtv/.playlistfbxidx 2> /dev/null
rm $HOME/.freeboxtv/.playlistfbxadr 2> /dev/null
rm $HOME/.freeboxtv/.newplaylistfbxadr 2> /dev/null
rm $HOME/.freeboxtv/.newplaylistfbxidx 2> /dev/null
exit
