attacks = {
  Neutral = {attack_speed = 2, ammo_cost = 0, abbreviation = 'N', color = default_color},
  Double = {attack_speed = 1, ammo_cost = 2, abbreviation = '2', color = ammo_color},
  Big = {attack_speed = 1, ammo_cost = 3, abbreviation = 'B', color = hp_color}
}

AttackActions = {

  Neutral = function(player)
    local d = 1.2 * player.w

    player.zone:addGameObject('ShootEffect', player.x + d*math.cos(player.r),
    player.y + d*math.sin(player.r), {player = player, d = d})

    player.zone:addGameObject('Projectile', player.x + 1.5* d * math.cos(player.r),
    player.y + 1.5*d*math.sin(player.r), {r = player.r, v = 100})
  end,

  Double = function(player)
    local d = 1.2 * player.w

    player.ammo = player.ammo - attacks[player.attack].ammo_cost
    player.zone:addGameObject('Projectile',
    player.x + 1.5*d*math.cos(player.r + math.pi/12),
    player.y + 1.5*d*math.sin(player.r + math.pi/12),
    {r = player.r + math.pi/12, attack = player.attack})

    player.zone:addGameObject('Projectile',
    player.x + 1.5*d*math.cos(player.r - math.pi/12),
    player.y + 1.5*d*math.sin(player.r - math.pi/12),
    {r = player.r - math.pi/12, attack = player.attack})
  end,

  Big = function(player)
    local d = 1.2 * player.w

    player.zone:addGameObject('ShootEffect', player.x + d*math.cos(player.r),
    player.y + d*math.sin(player.r), {player = player, d = d})

    player.zone:addGameObject('Projectile', player.x + 2.5* d * math.cos(player.r),
    player.y + 2.5*d*math.sin(player.r), {r = player.r, v = 15, s = 6.0, damage = 250, color = hp_color})
  end,

}
