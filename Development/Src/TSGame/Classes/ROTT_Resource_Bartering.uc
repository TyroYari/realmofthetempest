/*=============================================================================
 * ROTT_Resource_Bartering
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: 
 *===========================================================================*/

class ROTT_Resource_Bartering extends ROTT_Resource_Bartering_Seed
  ClassGroup(ROTT_Resources)
  placeable;

// Editor appearance
var const transient SpriteComponent editorSprite;

/*=============================================================================
 * postBeginPlay()
 *
 * Called when the game has started
 *===========================================================================*/
event postBeginPlay() {
  super.postBeginPlay();
  
  // Set references
  gameInfo = ROTT_Game_Info(Worldinfo.game);
  
}

/*=============================================================================
 * Default properties
 *===========================================================================*/
defaultProperties
{
  // Editor sprite
  begin object class=SpriteComponent Name=Sprite
    sprite=Texture2D'ROTT_Resources.Resource_Icon_Barter'
    hiddenGame=true
    hiddenEditor=false
    alwaysLoadOnClient=false
    alwaysLoadOnServer=false
    spriteCategoryName="Navigation"
    scale=2.0
  end object
  components.add(Sprite)
  editorSprite=Sprite
  
}



















