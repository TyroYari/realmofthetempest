/*=============================================================================
 * ROTT_UI_Bestiary_Opponent_Info
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * This class displays information for a bestiary opponent
 *===========================================================================*/

class ROTT_UI_Bestiary_Opponent_Info extends UI_Container;

// UI References
var private ROTT_UI_Displayer_Item costGraphics;
var private UI_Label opponentName;
var private UI_Label opponentText;

var private ROTT_Game_Info gameInfo;

/*============================================================================= 
 * Initialize Component
 *
 * Description: This event is called as the UI is loaded.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  super.initializeComponent(newTag);
  
  // Internal references
  costGraphics = ROTT_UI_Displayer_Item(findComp("Bestiary_Cost_Slot"));
  opponentName = UI_Label(findComp("Bestiary_Opponent_Name"));
  opponentText = UI_Label(findComp("Bestiary_Opponent_Info"));
  
  gameInfo = ROTT_Game_Info(class'WorldInfo'.static.getWorldInfo().game);
}

/*=============================================================================
 * renderInfo()
 *
 * Called to display bestiary opponent info.
 *===========================================================================*/
public function renderInfo(ROTT_Combat_Enemy bestiaryOpponent) {
  local ROTT_Inventory_Item itemInfo;
  
  if (bestiaryOpponent == none) return;
  
  // Setup gem cost display
  itemInfo = new class'ROTT_Inventory_Item_Gem';
  itemInfo.initialize();
  
  // Set quantity
  itemInfo.setQuantity(bestiaryOpponent.bestiaryCost);
  
  // Set font color
  if (gameInfo.getInventoryCount(class'ROTT_Inventory_Item_Gem') < bestiaryOpponent.bestiaryCost) {
    // Set red for insufficient gems
    costGraphics.setFont(DEFAULT_LARGE_RED);
  } else {
    costGraphics.setFont(DEFAULT_LARGE_WHITE);
  }
  
  // Show gem cost in displayer
  costGraphics.updateDisplay(itemInfo);
  
  // Set name and level info
  opponentName.setText(bestiaryOpponent.monsterName);
  opponentText.setText("Level " $ bestiaryOpponent.level $ " - " $ bestiaryOpponent.default.monsterName);
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  bDrawRelative=true
  
  // Header
  begin object class=UI_Label Name=Bestiary_Opponent_Name
    tag="Bestiary_Opponent_Name"
    posX=795
    posY=65
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    alignX=LEFT
    alignY=TOP
    fontStyle=DEFAULT_LARGE_ORANGE
    labelText="Champion Name"
  end object
  componentList.add(Bestiary_Opponent_Name)
  
  // Bestiary Opponent Info
  begin object class=UI_Label Name=Bestiary_Opponent_Info
    tag="Bestiary_Opponent_Info"
    posX=795
    posY=110
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    alignX=LEFT
    alignY=TOP
    fontStyle=DEFAULT_SMALL_WHITE
    labelText="Level 29 - Phantom Brute"
  end object
  componentList.add(Bestiary_Opponent_Info)
  
  // Textures
  begin object class=UI_Texture_Info Name=Inventory_Slot_Texture
    componentTextures.add(Texture2D'GUI.Cost_Inventory_Slot')
  end object
  
  // Inventory slot background
  begin object class=UI_Sprite Name=Inventory_Slot_Sprite
    tag="Inventory_Slot_Sprite"
    posX=613
    posY=33
    images(0)=Inventory_Slot_Texture
  end object
  componentList.add(Inventory_Slot_Sprite)
  
  // Inventory slot
  begin object class=ROTT_UI_Displayer_Item Name=Bestiary_Cost_Slot
    tag="Bestiary_Cost_Slot"
    bShowIfSingular=true
    posX=625
    posY=43
  end object
  componentList.add(Bestiary_Cost_Slot)
  
}


















