if !audio_is_playing(global.musica_bg) {
	audio_stop_all();
	audio_play_sound(global.musica_bg,1000,true);
	audio_sound_gain(global.musica_bg,0,0);
	audio_sound_gain(global.musica_bg,global.volume_musica,5000);
}