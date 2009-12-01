aica adpcm <-> wave converter;

(c) 2002 BERO <bero@geocities.co.jp>
under GPL or notify me

aica adpcm seems same as YMZ280B adpcm
adpcm->pcm algorithm can found MAME/src/sound/ymz280b.c by Aaron Giles

this code is for little endian machine

Modified by Dan Potter to read/write ADPCM WAV files, and to
handle stereo (though the stereo is very likely KOS specific
since we make no effort to interleave it). Please see README.GPL
in the KOS docs dir for more info on the GPL license.