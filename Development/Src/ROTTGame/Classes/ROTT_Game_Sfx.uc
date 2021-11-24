/*=============================================================================
 * ROTT_Game_Sfx
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This object may be instantiated to play sound effects.
 *===========================================================================*/
 
class ROTT_Game_Sfx extends UI_Game_Sfx;

/*=============================================================================
 * initialize()
 *
 * 
 *===========================================================================*/
public function initialize(ROTT_Game_Info game) {
  gameInfo = game;
}

/*=============================================================================
 * getSfxVolume()
 *
 * Retrieves the volume from the options
 *===========================================================================*/
private function updateSfxVolume() {
  sfxVolume = ROTT_Game_Info(gameInfo).optionsCookie.sfxVolume;
  `log("sfxVolume: " $ sfxVolume);
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  
}
  
  
  
  