
function scr_boss_criacao(){
	// Estado de criação do boss.
	
	if image_alpha >= 1 {
		alpha_add = -0.1;	
	} else if image_alpha <= 0 {
		alpha_add = 0.1;
	}
	
	image_alpha += alpha_add;
	
	if alarme_spawn > 0 {
		alarme_spawn -= 1;
	} else {
		image_alpha = 1;
	}
	
	if alarme_spawn > 0 {
		alarme_spawn -= 1;
	} else {
		estado = scr_abelha_escolha;
	}
}

function scr_abelha_escolha() {
	// Estado de escolha da abelha.
	
	if alarme_cooldown > 0 {
		alarme_cooldown -= 1;
	} else {
		// Escolha o próximo ataque.
		proximo_estado = choose(scr_boss_abelha_ferroes, scr_boss_abelha_avanco, scr_boss_abelha_abelhas);
	
		if proximo_estado == scr_boss_abelha_ferroes {
			dest_x = x;
			dest_y = y;
			tempo = 0;
			estado = scr_boss_abelha_ferroes;
			alarme_ferroes = duracao_ferroes;
		} else if proximo_estado == scr_boss_abelha_avanco {
			estado = scr_boss_abelha_avanco;
			repeticao_rush = 0;
		} else if proximo_estado == scr_boss_abelha_abelhas {
			repeat(3){
				var _x = x + irandom_range(-20,20);
				var _y = y + irandom_range(-20,20);
				instance_create_layer(_x,_y,"Instances",obj_abelhaboss);
				instance_create_layer(_x,_y,"Instances",obj_particula_morte);
			}
			estado = scr_boss_abelha_abelhas;
			alarme_abelhas = duracao_abelhas;
		}
	}
	
}

function scr_boss_abelha_avanco() {
	// Estado de ataque avanço da abelha.
	
	if alarme_cooldown > 0 {
		alarme_cooldown -= 1;
	} else {
		if repeticao_rush < 3 {
			dest_x = obj_personagem.x;
			dest_y = obj_personagem.y;
			veloc_dir = point_direction(x,y,dest_x,dest_y);
			estado = scr_boss_abelha_rush;
		} else {
			estado = scr_abelha_escolha;
			alarme_cooldown = duracao_cooldown;
		}
	}
}

function scr_boss_abelha_rush() {
	// Ataque de rush da abelha.
	
	var _dir_atualizada = point_direction(x,y,dest_x,dest_y)
	
	hveloc = lengthdir_x(veloc_avanco, veloc_dir);
	vveloc = lengthdir_y(veloc_avanco, veloc_dir);
	
	x += hveloc;
	y += vveloc;
	
	// Pare o avanço assim que chegar ao destino.
	if (round(_dir_atualizada) == round(veloc_dir-180) or
		round(_dir_atualizada) == round(veloc_dir+180)) or (x == dest_x and y == dest_y) {
		estado = scr_boss_abelha_avanco;
		alarme_cooldown = duracao_cooldown;
		repeticao_rush += 1;
	}
	
}

function scr_boss_abelha_abelhas() {
	// Estado de ataque em que a abelha spawna outras abelhinhas.
	
	if alarme_abelhas > 0 {
		alarme_abelhas -= 1;
	} else {
		estado = scr_abelha_escolha;
		alarme_cooldown = duracao_cooldown;
	}
}

function scr_boss_abelha_ferroes(){
	// Estado de ataque de ferrões da abelha.
	
	// Movimento.
	var _raio = 32;
	
	x = _raio*sin(4*pi*tempo/duracao_ferroes) + dest_x;
	y = _raio*cos(4*pi*tempo/duracao_ferroes)-_raio + dest_y;
	
	// Spawn dos projéteis.
	if alarme_spawn_ferroes > 0 {
		alarme_spawn_ferroes -= 1;
	} else {
		alarme_spawn_ferroes = duracao_spawn_ferroes;
		instance_create_layer(x,y-8,"Instances",obj_ferrao);
	}
	
	// Verifique o alarme.
	if alarme_ferroes > 0 {
		alarme_ferroes -= 1;
		tempo += 1;
	} else {
		estado = scr_abelha_escolha;
		alarme_cooldown = duracao_cooldown;
	}
	
}
	
function scr_boss_abelha_controle_sprite() {
	// Faz o controle de sprites do boss da abelha
	
	direcao = point_direction(x,y,obj_personagem.x,obj_personagem.y);
	
	if direcao >= 270 or direcao <= 90 {
		image_xscale = 1;
	} else {
		image_xscale = -1;
	}
	
	if estado == scr_boss_abelha_rush {
		sprite_index = spr_boss_abelha_avanco;
	} else {
		sprite_index = spr_boss_abelha_parada;
	}
}
	
function scr_boss_abelha_hit() {
	
	// Cheque o alarme de hit.
	if alarme_hit > 0 {
		alarme_hit -= 1;
	} else {
		estado = scr_abelha_escolha;
		alarme_cooldown = duracao_cooldown;
	}
	
}