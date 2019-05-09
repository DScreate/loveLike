default_color = {222, 222, 222}
background_color = {16, 16, 16}
ammo_color = {123, 200, 164}
boost_color = {76, 195, 217}
hp_color = {241, 103, 69}
skill_point_color = {255, 198, 93}

 default_colors = {default_color, hp_color, ammo_color, boost_color, skill_point_color}
 negative_colors = {
         {255-default_color[1], 255-default_color[2], 255-default_color[3]},
         {255-hp_color[1], 255-hp_color[2], 255-hp_color[3]},
         {255-ammo_color[1], 255-ammo_color[2], 255-ammo_color[3]},
         {255-boost_color[1], 255-boost_color[2], 255-boost_color[3]},
         {255-skill_point_color[1], 255-skill_point_color[2], 255-skill_point_color[3]}
     }
all_colors = M.append(default_colors, negative_colors)

PrimaryLightest =  { 110, 121, 119 }
PrimaryLighter =  { 88, 100, 98 }
Primary =  { 68, 82, 79 }
PrimaryDarker =  { 48, 61, 59 }
PrimaryDarkest =  { 29, 45, 42 }

SecondaryLightest =  { 116, 120, 126 }
SecondaryLighter =  { 93, 97, 105 }
Secondary =  { 72, 77, 85 }
SecondaryDarker =  { 51, 56, 64 }
SecondaryDarkest =  { 31, 38, 47 }

AlternateLightest =  { 190, 184, 174 }
AlternateLighter =  { 158, 151, 138 }
Alternate =  { 129, 121, 107 }
AlternateDarker =  { 97, 89, 75 }
AlternateDarkest =  { 71, 62, 45 }

ComplimentLightest =  { 190, 180, 174 }
ComplimentLighter =  { 158, 147, 138 }
Compliment =  { 129, 116, 107 }
ComplimentDarker =  { 97, 84, 75 }
ComplimentDarkest =  { 71, 56, 45 }

-- http://pixeljoint.com/forum/forum_posts.asp?TID=12795

DbDark =  { 20, 12, 28 }
DbOldBlood =  { 68, 36, 52 }
DbDeepWater =  { 48, 52, 109 }
DbOldStone =  { 78, 74, 78 }
DbWood =  { 133, 76, 48 }
DbVegetation =  { 52, 101, 36 }
DbBlood =  { 208, 70, 72 }
DbStone =  { 117, 113, 97 }
DbWater =  { 89, 125, 206 }
DbBrightWood =  { 210, 125, 44 }
DbMetal =  { 133, 149, 161 }
DbGrass =  { 109, 170, 44 }
DbSkin =  { 210, 170, 153 }
DbSky =  { 109, 194, 202 }
DbSun =  { 218, 212, 94 }
DbLight =  { 222, 238, 214 }
