/*=============================================================================
 * ROTT_Resource_Chest
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: A placeable chest that the player can open for loot.
 *===========================================================================*/

class ROTT_Resource_Chest extends Actor
  ClassGroup(ROTT_Resources)
  placeable;

// Looting delay
const CHEST_ANIMATION_DELAY = 1.4;
  
// Reference
var private ROTT_Game_Info gameInfo;

// Editor appearance
var const transient SpriteComponent editorSprite;

// Drop level
var() private int dropLevel;
var() private float dropAmplifier;

// Store custom drop rates
var() private array<ItemDropMod> itemDropRates;

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
 * openChest()
 *
 * Called when the player opens the chest to loot it.
 *===========================================================================*/
public function openChest() {
  gameInfo.pauseGame();
  
  // Perform animations and particle effects
  gameInfo.sfxBox.playSFX(SFX_WORLD_OPEN_CHEST);
  
  // Transfer chest loot
  gameInfo.openChest(
    dropLevel, 
    dropAmplifier, 
    itemDropRates,
    CHEST_ANIMATION_DELAY
  );
}

/*=============================================================================
 * Default properties
 *===========================================================================*/
defaultProperties
{
  
  // Increases the potential power of the drop
  dropLevel=1
  
  // Increases loot, but does not increase the potential drop power
  dropAmplifier=3.5
  
  // Editor sprite
  begin object class=SpriteComponent Name=Sprite
    sprite=Texture2D'ROTT_Resources.Resource_Icon_Chest'
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



















