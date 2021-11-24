/*=============================================================================
 * UI_Game_Sfx
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This object may be instantiated to play sound effects.
 *===========================================================================*/
 
class UI_Game_Sfx extends object;

var protected float sfxVolume;

// A list of sound effects 
enum SoundEffectsEnum {
  // No sound
  NO_SFX,
  
  // Menu Navigation
  SFX_MENU_NAVIGATE,
  SFX_MENU_ACCEPT,
  SFX_MENU_BACK,
  SFX_MENU_CLICK,
  
  // Character Development
  SFX_MENU_INVEST_STAT,
  SFX_MENU_UNINVEST_STAT,
  SFX_MENU_BLESS_STAT,
  SFX_MENU_INVEST_SKILL,
  SFX_MENU_UNINVEST_SKILL,
  SFX_MENU_INSUFFICIENT,
  SFX_MENU_EXP_GAIN,
  SFX_MENU_LEVEL_UP,
  
  // World map
  SFX_OPEN_WORLD_MAP,
  SFX_CLOSE_WORLD_MAP,
  
  // Game Management
  SFX_MENU_SAVE_GAME,
  
  // A list of sound effects for the 3D World
  SFX_WORLD_GATHER_COIN,
  SFX_WORLD_GATHER_GEM,
  SFX_WORLD_OPEN_CHEST,
  SFX_WORLD_PORTAL,
  SFX_WORLD_SHRINE,
  SFX_WORLD_GAIN_LOOT,
  SFX_WORLD_JUMP_PAD,
  SFX_WORLD_TEMPORAL,
  SFX_WORLD_FALLING,
  SFX_WORLD_GLIDEWALK,
  SFX_WORLD_PRAYER,
  SFX_WORLD_SINGING,
  SFX_WORLD_DOOR,
  SFX_COMBAT_START,
  SFX_COMBAT_START_CHAMP,
  
  // A list of sound effects for combat
  SFX_COMBAT_ATTACK,
  SFX_COMBAT_AURA_ATTACK,
  SFX_COMBAT_DEBUFF,
  SFX_COMBAT_BUFF,
  SFX_COMBAT_MISS,
  
  SFX_COMBAT_GLYPH_COLLECT,
  SFX_COMBAT_ENEMY_DEATH,
  SFX_COMBAT_HERO_DEATH,
  
  // Alchemy
  SFX_ALCHEMY_DEATH,
  SFX_ALCHEMY_COLLECT,
  SFX_ALCHEMY_GAME_MOVE,
  SFX_ALCHEMY_GAME_OVER,
  SFX_ALCHEMY_LEVEL_CLEAR,
  
  // Npc
  SFX_NPC_TEXT,
  
  // Ambient
  SFX_AMBIENT_OMINOUS
  
};

// Sfx storange for menu sounds
var private AudioComponent soundEffects[SoundEffectsEnum];

// References
var public UI_Game_Info gameInfo;

// Glyph cyclic index
var private int glyphIndex;

/*=============================================================================
 * playSFX()
 *
 * This function plays menu sound effects
 *===========================================================================*/
public function playSFX(SoundEffectsEnum sfxName) {
  if (sfxName == NO_SFX) return;
  if (soundEffects[sfxName] == none) return;
  
  /// if (sfxName == SFX_MENU_INSUFFICIENT) scripttrace(); /// what the fuck
  
  // Play
  soundEffects[sfxName].stop();
  soundEffects[sfxName].adjustVolume(0, getSfxVolume());
  soundEffects[sfxName].play();
}

/**=============================================================================
 * playGlyphSFX()
 *
 * This function cycles through glyph sound effects
 *===========================================================================
public function playGlyphSFX() {
  local SoundEffectsEnum glyphSound;
  
  glyphIndex++;
  if (glyphIndex == 3) glyphIndex = 0;
  
  // Play sounds
  switch (glyphIndex) {
    case 0: glyphSound = SFX_COMBAT_GLYPH_COLLECT_1; break;
    case 1: glyphSound = SFX_COMBAT_GLYPH_COLLECT_2; break;
    case 2: glyphSound = SFX_COMBAT_GLYPH_COLLECT_3; break;
  }
  
  soundEffects[glyphSound].stop();
  soundEffects[glyphSound].adjustVolume(0, getSfxVolume());
  soundEffects[glyphSound].play();
}
*/
/*=============================================================================
 * getSfxVolume()
 *
 * Retrieves the volume from the options
 *===========================================================================*/
private function float getSfxVolume() { 
  return gameInfo.optionsCookie.sfxVolume; 
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  /** ===== Sound Cues ===== **/
  // Menu navigation
  begin object class=AudioComponent Name=AC_Menu_Navigate
    SoundCue=SoundCue'ROTT_Sound_Effects.TS-SFXCUE-Basic_Input_Beep_01'    
  end object
  begin object class=AudioComponent Name=AC_Menu_Accept
    SoundCue=SoundCue'ROTT_Sound_Effects.TS-SFXCUE-Basic_Input_Beep_02'         
  end object 
  begin object class=AudioComponent Name=AC_Menu_Back
    SoundCue=SoundCue'ROTT_Sound_Effects.TS-SFXCUE-Basic_Input_Beep_03'         
  end object
  
  // Character Development
  begin object class=AudioComponent Name=AC_Investment
    SoundCue=SoundCue'ROTT_Sound_Effects.TS-SFXCUE-InvestPoint'
  end object
  begin object class=AudioComponent Name=AC_Uninvest
    SoundCue=SoundCue'ROTT_Sound_Effects.TS-SFXCUE-UninvestPoint'
  end object
  begin object class=AudioComponent Name=AC_Insufficient
    SoundCue=SoundCue'ROTT_Sound_Effects.TS-SFXCUE-Insufficient'
  end object
  begin object class=AudioComponent Name=AC_Level_Up 
    SoundCue=SoundCue'ROTT_Sound_Effects.TS-SFXCUE-Level_Up'
  end object
  begin object class=AudioComponent Name=AC_Exp_Gain
    SoundCue=SoundCue'ROTT_Sound_Effects.TS-SFXCUE-Exp_Gain'
  end object
  
  // World map
  begin object class=AudioComponent Name=AC_Open_Map
    SoundCue=SoundCue'ROTT_Sound_Effects.Open_Map_SFX_Cue'
  end object
  begin object class=AudioComponent Name=AC_Close_Map
    SoundCue=SoundCue'ROTT_Sound_Effects.Close_Map_SFX_Cue'
  end object
  
  // 3D World
  begin object class=AudioComponent Name=AC_Coin_Collection
    SoundCue=SoundCue'ROTT_Sound_Effects.TS-SFXCUE-CoinCollection'
  end object
  begin object class=AudioComponent Name=AC_Open_Chest
    SoundCue=SoundCue'ROTT_Sound_Effects.OpenChest_SFX_Cue'
  end object
  begin object class=AudioComponent Name=AC_Portal_Use
    SoundCue=SoundCue'ROTT_Sound_Effects.ROTT-SFXCUE-Portal'
  end object
  begin object class=AudioComponent Name=AC_Shrine_Activated
    SoundCue=SoundCue'ROTT_Sound_Effects.ROTT-SFXCUE-Shrine_Ignited'
  end object
  begin object class=AudioComponent Name=AC_Blessing
    SoundCue=SoundCue'ROTT_Sound_Effects.TS-SFXCUE-Heal'
  end object
  begin object class=AudioComponent Name=AC_Loot_Gain
    SoundCue=SoundCue'ROTT_Sound_Effects.TS-SFXCUE-Loot_Gain'
  end object
  begin object class=AudioComponent Name=AC_Jump_Pad
    SoundCue=SoundCue'ROTT_Sound_Effects.Jump_Pad_SFX_Cue'
  end object
  begin object class=AudioComponent Name=AC_Temporal
    SoundCue=SoundCue'ROTT_Sound_Effects.Temporal_SFX_Cue'
  end object
  begin object class=AudioComponent Name=AC_Falling
    SoundCue=SoundCue'ROTT_Sound_Effects.ROTT-SFXCUE-Falling'
  end object
  begin object class=AudioComponent Name=AC_Glidewalk
    SoundCue=SoundCue'ROTT_Sound_Effects.Glidewalk_SFX_Cue'
  end object
  begin object class=AudioComponent Name=AC_Prayer
    SoundCue=SoundCue'ROTT_Sound_Effects.ROTT-SFXCUE-Prayer'
  end object
  begin object class=AudioComponent Name=AC_Singing
    SoundCue=SoundCue'ROTT_Sound_Effects.ROTT-SFXCUE-Singing'
  end object
  begin object class=AudioComponent Name=AC_Door
    SoundCue=SoundCue'ROTT_Sound_Effects.ROTT-SFXCUE-Door'
  end object
  begin object class=AudioComponent Name=AC_Combat_Start
    SoundCue=SoundCue'ROTT_Sound_Effects.ROTT-SFXCUE-Combat_Start'
  end object
  begin object class=AudioComponent Name=AC_Combat_Start_Champ
    SoundCue=SoundCue'ROTT_Sound_Effects.ROTT-SFXCUE-Combat_Start_Champ'
  end object
  
  // Combat Actions
  begin object class=AudioComponent Name=AC_Combat_Attack
    SoundCue=SoundCue'ROTT_Sound_Effects.TS-SFXCUE-Attack_01'
  end object
  begin object class=AudioComponent Name=AC_Combat_Aura
    SoundCue=SoundCue'ROTT_Sound_Effects.TS-SFXCUE-Aura'
  end object
  begin object class=AudioComponent Name=AC_Combat_Debuff
    SoundCue=SoundCue'ROTT_Sound_Effects.TS-SFXCUE-Debuff'
  end object
  begin object class=AudioComponent Name=AC_Combat_Click
    SoundCue=SoundCue'ROTT_Sound_Effects.ROTT-SFXCUE-Clasp'
  end object
  begin object class=AudioComponent Name=AC_Combat_Miss
    SoundCue=SoundCue'ROTT_Sound_Effects.TS-SFXCUE-Miss'
  end object
  
  // Glyphs
  begin object class=AudioComponent Name=AC_Collect_Glyph
    SoundCue=SoundCue'ROTT_Sound_Effects.ROTT-SFXCUE-Alchemy_Claim'
  end object
  
  // Combat Events
  begin object class=AudioComponent Name=AC_Combat_Enemy_Death
    SoundCue=SoundCue'ROTT_Sound_Effects.TS-SFXCUE-Enemy_Death'
  end object
  begin object class=AudioComponent Name=AC_Combat_Hero_Death
    SoundCue=SoundCue'ROTT_Sound_Effects.TS-SFXCUE-Hero_Death'
  end object
  
  // Alchemy
  begin object class=AudioComponent Name=AC_Alchemy_Death
    SoundCue=SoundCue'ROTT_Sound_Effects.TS-SFXCUE-CraftDeath'
  end object
  begin object class=AudioComponent Name=AC_Alchemy_Game_Over
    SoundCue=SoundCue'ROTT_Sound_Effects.TS-SFXCUE-CraftGameOver'
  end object
  begin object class=AudioComponent Name=AC_Claim_Tile
    SoundCue=SoundCue'ROTT_Sound_Effects.ROTT-SFXCUE-Alchemy_Claim' 
  end object
  
  // Npc
  begin object class=AudioComponent Name=AC_NPC_Text
    SoundCue=SoundCue'ROTT_Sound_Effects.ROTT-SFXCUE-NPC_Text'
  end object
  
  // Ambient
  begin object class=AudioComponent Name=AC_Ambient_Ominous
    SoundCue=SoundCue'ROTT_Sound_Effects.ROTT-SFXCUE-Ambient_Ominous'
  end object
  
  
  /** ===== Audio Components ===== **/
  // Menu navigation
  soundEffects[SFX_MENU_NAVIGATE] = AC_Menu_Navigate
  soundEffects[SFX_MENU_ACCEPT] = AC_Menu_Accept
  soundEffects[SFX_MENU_BACK] = AC_Menu_Back
  soundEffects[SFX_MENU_CLICK] = AC_Combat_Click
  
  // Character Development
  soundEffects[SFX_MENU_INVEST_STAT] = AC_Investment
  soundEffects[SFX_MENU_UNINVEST_STAT] = AC_Uninvest
  soundEffects[SFX_MENU_BLESS_STAT] = AC_Blessing
  soundEffects[SFX_MENU_INVEST_SKILL] = AC_Investment
  soundEffects[SFX_MENU_UNINVEST_SKILL] = AC_Uninvest
  soundEffects[SFX_MENU_INSUFFICIENT] = AC_Insufficient
  soundEffects[SFX_MENU_EXP_GAIN] = AC_Exp_Gain
  soundEffects[SFX_MENU_LEVEL_UP] = AC_Level_Up 
  
  // World map
  soundEffects[SFX_OPEN_WORLD_MAP] = AC_Open_Map
  soundEffects[SFX_CLOSE_WORLD_MAP] = AC_Close_Map
  
  // Game Management
  soundEffects[SFX_MENU_SAVE_GAME] = AC_Investment
  
  // A list of sound effects for the 3D World
  soundEffects[SFX_WORLD_GATHER_COIN] = AC_Coin_Collection
  soundEffects[SFX_WORLD_GATHER_GEM] = AC_Coin_Collection
  soundEffects[SFX_WORLD_OPEN_CHEST] = AC_Open_Chest
  soundEffects[SFX_WORLD_PORTAL] = AC_Portal_Use
  soundEffects[SFX_WORLD_SHRINE] = AC_Shrine_Activated
  soundEffects[SFX_WORLD_GAIN_LOOT] = AC_Loot_Gain
  soundEffects[SFX_WORLD_JUMP_PAD] = AC_Jump_Pad
  soundEffects[SFX_WORLD_TEMPORAL] = AC_Temporal
  soundEffects[SFX_WORLD_FALLING] = AC_Falling
  soundEffects[SFX_WORLD_GLIDEWALK] = AC_Glidewalk
  soundEffects[SFX_WORLD_PRAYER] = AC_Prayer
  soundEffects[SFX_WORLD_SINGING] = AC_Singing
  soundEffects[SFX_WORLD_DOOR] = AC_Door
  soundEffects[SFX_COMBAT_START] = AC_Combat_Start
  soundEffects[SFX_COMBAT_START_CHAMP] = AC_Combat_Start_Champ
  
  // A list of sound effects for combat
  // Combat
  soundEffects[SFX_COMBAT_ATTACK] = AC_Combat_Attack
  soundEffects[SFX_COMBAT_AURA_ATTACK] = AC_Combat_Aura
  soundEffects[SFX_COMBAT_DEBUFF] = AC_Combat_Debuff
  soundEffects[SFX_COMBAT_BUFF] = AC_Combat_Click
  soundEffects[SFX_COMBAT_MISS] = AC_Combat_Miss
  
  // Glyph collect
  soundEffects[SFX_COMBAT_GLYPH_COLLECT] = AC_Collect_Glyph
  ///soundEffects[SFX_COMBAT_GLYPH_COLLECT_1] = AC_Collect_Glyph_1
  ///soundEffects[SFX_COMBAT_GLYPH_COLLECT_2] = AC_Collect_Glyph_2
  ///soundEffects[SFX_COMBAT_GLYPH_COLLECT_3] = AC_Collect_Glyph_3
  soundEffects[SFX_COMBAT_ENEMY_DEATH] = AC_Combat_Enemy_Death
  soundEffects[SFX_COMBAT_HERO_DEATH] = AC_Combat_Hero_Death
  
  // Alchemy
  soundEffects[SFX_ALCHEMY_DEATH] = AC_Alchemy_Death
  soundEffects[SFX_ALCHEMY_COLLECT] = AC_Claim_Tile
  soundEffects[SFX_ALCHEMY_GAME_MOVE] = none
  soundEffects[SFX_ALCHEMY_GAME_OVER] = AC_Alchemy_Game_Over
  soundEffects[SFX_ALCHEMY_LEVEL_CLEAR] = AC_Exp_Gain
  
  // Npc
  soundEffects[SFX_NPC_TEXT] = AC_NPC_Text
  
  // Ambient
  soundEffects[SFX_AMBIENT_OMINOUS] = AC_Ambient_Ominous
  
  
}
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  