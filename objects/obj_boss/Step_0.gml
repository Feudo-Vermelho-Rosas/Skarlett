// Sistema de pause.
if (global.pause) {
	image_speed = 0
	exit;
}

image_speed = 1;

// Cheque o alarme de hit.
if alarme_hit > 0 {
	estado = scr_boss_abelha_hit;
}

// Execute o estado atual.
script_execute(estado);

// Sempre controle a direção.
scr_boss_abelha_controle_sprite();