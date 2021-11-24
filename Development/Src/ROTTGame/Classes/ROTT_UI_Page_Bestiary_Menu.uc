/*=============================================================================
 * ROTT_UI_Page_Bestiary_Menu
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: The menu for using the Bestiary service.
 *===========================================================================*/
 
class ROTT_UI_Page_Bestiary_Menu extends ROTT_UI_Page;

// Internal references
var private UI_Selector selector;
var private ROTT_UI_Bestiary_Opponent_Info opponentInfo[6];

// External references
var privatewrite ROTT_UI_Scene_Service_Bestiary bestiaryScene;

// Stores true if input is ignored
var privatewrite bool bInputLock;

/*============================================================================= 
 * Initialize Component
 *
 * Description: This event is called as the UI is loaded.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  local int i;
  
  super.initializeComponent(newTag);
  
  // Internal references
  for (i = 0; i < 6; i++) {
    opponentInfo[i] = ROTT_UI_Bestiary_Opponent_Info(findComp("Bestiary_Opponent_Info_" $ i+1));
  }
  selector = UI_Selector(findComp("Bestiary_Enchantment_Selector"));
  selector.setActive(true);
  
  // Scene reference
  bestiaryScene = ROTT_UI_Scene_Service_Bestiary(parentScene);
}

/*=============================================================================
 * onFocusMenu()
 *
 * Called when a menu is given focus.  Assign controls, and enable graphics.
 *===========================================================================*/
event onFocusMenu() {
  selector.setActive(true);
}
event onUnfocusMenu() {
  
}

/*============================================================================= 
 * onPushPageEvent()
 *
 * This event is called every time the page is pushed.
 *===========================================================================*/
event onPushPageEvent() {
  // Reset Bestiary selection
  selector.resetSelection();
  selector.setActive(true);
  
  // Unlock controls
  bInputLock = false;
  
  // Update display
  refresh();
}

/*=============================================================================
 * refresh()
 *
 * Should be called when any changes occur to the UI.
 *===========================================================================*/
public function refresh() {
  local ROTT_Inventory_Item itemInfo;
  local int i;
  
  for (i = 0; i < 6; i++) {
    opponentInfo[i].renderInfo(bestiaryScene.enemyList[i]);
  }
  
  findSprite("Elite_Portrait").modifyTexture(
    bestiaryScene.enemyList[selector.getSelection()].getPortrait()
  );
  
  // Setup gem cost display
  itemInfo = new class'ROTT_Inventory_Item_Gem';
  itemInfo.initialize();
  
  // Set quantity
  itemInfo.setQuantity(gameInfo.getInventoryCount(class'ROTT_Inventory_Item_Gem'));
  ROTT_UI_Displayer_Item(findComp("Player_Inventory_Slot")).updateDisplay(itemInfo);
}

/*============================================================================*
 * Button controls
 *===========================================================================*/
protected function navigationRoutineA() {
  local ROTT_Combat_Enemy bestiaryOpponent;
  local array<ItemCost> opponentCosts;
  local ItemCost opponentCost;
  
  // Get selected opponent info
  bestiaryOpponent = bestiaryScene.enemyList[selector.getSelection()];
  
  // Store cost info
  opponentCost.currencyType = class'ROTT_Inventory_Item_Gem';
  opponentCost.quantity = bestiaryOpponent.bestiaryCost;
  opponentCosts.addItem(opponentCost);
  
  // Check sufficient gems
  if (!gameInfo.canDeductCosts(opponentCosts)) {
    // Play sfx
    sfxBox.playSFX(SFX_MENU_INSUFFICIENT);
    return;
  }
  
  // Lock input
  bInputLock = true;
  
  // Deduct gems
  gameInfo.deductCosts(opponentCosts);
  
  // Create new mob
  gameInfo.enemyEncounter = new(self) class'ROTT_Mob';
  gameInfo.enemyEncounter.linkReferences();
  gameInfo.enemyEncounter.addEnemy(bestiaryOpponent);
  violetLog("Added enemy " $ bestiaryOpponent);
  violetLog("Encounter count " $ gameInfo.enemyEncounter.getMobSize());
  gameInfo.enemyEncounter.bBestiarySummon = true;
  gameInfo.bEncounterPending = true;
  
  // Delay transition to combat
  gameInfo.startCombatTransition(0.1);
  
  // Disable selector movement
  selector.setActive(false);
}

protected function navigationRoutineB() {
  // Navigate back to NPC
  parentScene.popPage();
  sceneManager.switchScene(SCENE_NPC_DIALOG);
  
  // Sfx
  gameInfo.sfxBox.playSfx(SFX_MENU_BACK);
}

/*=============================================================================
 * Requirements
 *===========================================================================*/
protected function bool requirementRoutineA() { 
  return !bInputLock; 
}

/*============================================================================*
 * D-Pad controls
 *===========================================================================*/
public function onNavigateDown() {
  // Update display
  refresh();
}

public function onNavigateUp() {
  // Update display
  refresh();
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  /** ===== Input ===== **/
  begin object class=ROTT_Input_Handler Name=Input_A
    inputName="XBoxTypeS_A"
    buttonComponent=none
  end object
  inputList.add(Input_A)
  
  begin object class=ROTT_Input_Handler Name=Input_B
    inputName="XBoxTypeS_B"
    buttonComponent=none
  end object
  inputList.add(Input_B)
  
  /** ===== Textures ===== **/
  // Background
  begin object class=UI_Texture_Info Name=Menu_Background
    componentTextures.add(Texture2D'GUI.Bestiary.Bestiary_Service_Background')
  end object
  
  /** ===== Components ===== **/
  // Background
  begin object class=UI_Sprite Name=Bestiary_Menu_Background
    tag="Bestiary_Menu_Background"
    posX=0
    posY=0
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    images(0)=Menu_Background
  end object
  componentList.add(Bestiary_Menu_Background)
  
  // Bestiary Info
  begin object class=ROTT_UI_Bestiary_Opponent_Info Name=Bestiary_Opponent_Info_1
    tag="Bestiary_Opponent_Info_1"
    posX=0
    posY=0
  end object
  componentList.add(Bestiary_Opponent_Info_1)
  
  begin object class=ROTT_UI_Bestiary_Opponent_Info Name=Bestiary_Opponent_Info_2
    tag="Bestiary_Opponent_Info_2"
    posX=0
    posY=138
  end object
  componentList.add(Bestiary_Opponent_Info_2)
  
  begin object class=ROTT_UI_Bestiary_Opponent_Info Name=Bestiary_Opponent_Info_3
    tag="Bestiary_Opponent_Info_3"
    posX=0
    posY=276
  end object
  componentList.add(Bestiary_Opponent_Info_3)
  
  begin object class=ROTT_UI_Bestiary_Opponent_Info Name=Bestiary_Opponent_Info_4
    tag="Bestiary_Opponent_Info_4"
    posX=0
    posY=414
  end object
  componentList.add(Bestiary_Opponent_Info_4)
  
  begin object class=ROTT_UI_Bestiary_Opponent_Info Name=Bestiary_Opponent_Info_5
    tag="Bestiary_Opponent_Info_5"
    posX=0
    posY=552
  end object
  componentList.add(Bestiary_Opponent_Info_5)
  
  begin object class=ROTT_UI_Bestiary_Opponent_Info Name=Bestiary_Opponent_Info_6
    tag="Bestiary_Opponent_Info_6"
    posX=0
    posY=690
  end object
  componentList.add(Bestiary_Opponent_Info_6)
  
  // Selector
  begin object class=UI_Selector Name=Bestiary_Enchantment_Selector
    tag="Bestiary_Enchantment_Selector"
    bEnabled=true
    bActive=true
    bWrapAround=true
    numberOfMenuOptions=6
    posX=770
    posY=41
    navigationType=SELECTION_VERTICAL
    selectionOffset=(x=0,y=138)
    hoverCoords(0)=(xStart=773,yStart=41,xEnd=1369,yEnd=172)
    hoverCoords(1)=(xStart=773,yStart=179,xEnd=1369,yEnd=310)
    hoverCoords(2)=(xStart=773,yStart=317,xEnd=1369,yEnd=448)
    hoverCoords(3)=(xStart=773,yStart=455,xEnd=1369,yEnd=586)
    hoverCoords(4)=(xStart=773,yStart=593,xEnd=1369,yEnd=724)
    hoverCoords(5)=(xStart=773,yStart=731,xEnd=1369,yEnd=862)
    
    // Selection texture
    begin object class=UI_Texture_Info Name=Selection_Box_Texture
      componentTextures.add(Texture2D'GUI.Bestiary.Bestiary_Selector')
    end object

    // Selector sprite
    begin object class=UI_Sprite Name=Selector_Sprite
      tag="Selector_Sprite"
      images(0)=Selection_Box_Texture
    end object
    componentList.add(Selector_Sprite)
    
  end object
  componentList.add(Bestiary_Enchantment_Selector)
  
  // Enemy sprite
  begin object class=UI_Texture_Info Name=Place_Holder_360
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Placeholder_360')
  end object
  
  // Elite Portrait
  begin object class=UI_Sprite Name=Elite_Portrait
    tag="Elite_Portrait"
    bAnchor=true
    anchorX=280
    anchorY=450
    images(0)=Place_Holder_360
  end object
  componentList.add(Elite_Portrait)
  
  // Gem Inventory Label
  begin object class=UI_Label Name=Gem_Inventory_Label
    tag="Gem_Inventory_Label"
    posX=15
    posY=685
    posXEnd=561
    posYEnd=NATIVE_HEIGHT
    fontStyle=DEFAULT_SMALL_TAN
    labelText="Gems in Inventory"
    alignX=CENTER
    alignY=TOP
  end object
  componentList.add(Gem_Inventory_Label)
  
  // Textures
  begin object class=UI_Texture_Info Name=Inventory_Slot_Texture
    componentTextures.add(Texture2D'GUI.Cost_Inventory_Slot')
  end object
  
  // Inventory slot background
  begin object class=UI_Sprite Name=Inventory_Slot_Sprite
    tag="Inventory_Slot_Sprite"
    posX=211
    posY=723
    images(0)=Inventory_Slot_Texture
  end object
  componentList.add(Inventory_Slot_Sprite)
  
  // Inventory slot
  begin object class=ROTT_UI_Displayer_Item Name=Player_Inventory_Slot
    tag="Player_Inventory_Slot"
    bShowIfSingular=true
    posX=223
    posY=733
  end object
  componentList.add(Player_Inventory_Slot)
  
}





