/*=============================================================================
 * ROTT_UI_Page_Alchemy_Game_Over
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: Displays the results of the alchemy mini-game.
 *===========================================================================*/
 
class ROTT_UI_Page_Alchemy_Game_Over extends ROTT_UI_Page;

// Internal references
var private UI_Label enchantmentText[7];

// External references
var privatewrite ROTT_UI_Scene_Service_Alchemy alchemyScene;

/*============================================================================= 
 * Initialize Component
 *
 * Description: This event is called as the UI is loaded.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  super.initializeComponent(newTag);
  
  // Internal references
  enchantmentText[0] = UI_Label(findComp("Alchemy_Game_Over_Enchantment_Name"));
  enchantmentText[1] = UI_Label(findComp("Alchemy_Game_Over_Enchantment_Description_1"));
  enchantmentText[2] = UI_Label(findComp("Alchemy_Game_Over_Enchantment_Description_2"));
  enchantmentText[3] = UI_Label(findComp("Alchemy_Game_Over_Enchantment_Round_Bonus_Label"));
  enchantmentText[4] = UI_Label(findComp("Alchemy_Game_Over_Enchantment_Bonus_Label"));
  enchantmentText[5] = UI_Label(findComp("Alchemy_Game_Over_Enchantment_Added_Boost"));
  enchantmentText[6] = UI_Label(findComp("Alchemy_Game_Over_Enchantment_Total_Boost"));
  
  // Scene reference
  alchemyScene = ROTT_UI_Scene_Service_Alchemy(parentScene);
}

/*=============================================================================
 * onFocusMenu()
 *
 * Called when a menu is given focus.  Assign controls, and enable graphics.
 *===========================================================================*/
event onFocusMenu() {
  
}

/*============================================================================= 
 * onPushPageEvent()
 *
 * This event is called every time the page is pushed.
 *===========================================================================*/
event onPushPageEvent() {
  local EnchantmentDescriptor script;
  local int level;
  local int index;
  local int i;
  
  // Get script
  script = class'ROTT_Descriptor_Enchantment_List'.static.getEnchantment(
    ROTT_UI_Scene_Service_Alchemy(parentScene).selectedEnchantment
  );
  
  // Get number of rounds cleared in minigame
  index = ROTT_UI_Scene_Service_Alchemy(parentScene).selectedEnchantment;
  
  // Move to selected enchantment
  UI_Sprite(findComp("Enchantment_Selection_List")).updatePosition(
    364 - 120 * index,
    203,
    2664 - 120 * index,
    303
  );
  
  level = alchemyScene.enchantmentLevel;
  
  // Set display text
  for (i = 0; i < 3; i++) {
    enchantmentText[i].setText(script.displayText[i]);
  }
  enchantmentText[3].setText(script.displayText[ENCHANTMENT_ROUND_BONUS]);
  enchantmentText[4].setText("Level Bonus: " $ level);
  enchantmentText[5].setText(script.displayText[ENCHANTMENT_ADDED]);
  enchantmentText[6].setText(script.displayText[ENCHANTMENT_TOTAL]);
  
  // Replacement codes
  enchantmentText[3].replaceText("%bonus", script.bonusPerLevel * alchemyScene.minigameMultiplier);
  enchantmentText[5].replaceText("%add", script.bonusPerLevel * level * alchemyScene.minigameMultiplier);
  enchantmentText[6].replaceText(
    "%total", 
    script.bonusPerLevel * level * alchemyScene.minigameMultiplier + gameInfo.playerProfile.getEnchantBoost(index)
  );
}

/*=============================================================================
 * refresh()
 *
 * Called when the UI changes.
 *===========================================================================*/
public function refresh() {
  
}

/*=============================================================================
 * promptConfirmation()
 *
 * Called after displaying game results to ask player if they want to retry.
 *===========================================================================*/
public function promptConfirmation() {
  // Increase enchantment level
  /// temp
  ROTT_UI_Scene_Service_Alchemy(parentScene).submitAlchemyResult();
  
  // Push confirm or retry window
  /// to do ...
  
  parentScene.popPage();
  parentScene.pushPageByTag("Page_Alchemy_Menu");
}

/*============================================================================*
 * Button controls
 *===========================================================================*/
protected function navigationRoutineA() {
  promptConfirmation();
}

protected function navigationRoutineB() {
  promptConfirmation();
}

/*============================================================================*
 * D-Pad controls
 *===========================================================================*/
public function onNavigateDown();

public function onNavigateUp();

public function onNavigateLeft();

public function onNavigateRight();

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
  
  /** ===== Texture ===== **/
  // Background
  begin object class=UI_Texture_Info Name=Menu_Background
    componentTextures.add(Texture2D'ROTT_Alchemy.Alchemy_Menu_Background')
  end object
  begin object class=UI_Texture_Info Name=Window_Background
    componentTextures.add(Texture2D'ROTT_Alchemy.Service.Alchemy_Game_Over_Window')
  end object
  
  // Enchantment list
  begin object class=UI_Texture_Info Name=Enchantment_List
    componentTextures.add(Texture2D'ROTT_Alchemy.Service.Enchantment_List')
  end object
  
  /** ===== Components ===== **/
  // Enchantment list (under background)
  begin object class=UI_Sprite Name=Enchantment_Selection_List
    tag="Enchantment_Selection_List" 
    posX=364
    posY=203
    posXEnd=2664
    posYEnd=303
    images(0)=Enchantment_List
  end object
  componentList.Add(Enchantment_Selection_List)
  
  // Background
  begin object class=UI_Sprite Name=Alchemy_Game_Over_Background
    tag="Alchemy_Game_Over_Background"
    posX=0
    posY=0
    images(0)=Menu_Background
  end object
  componentList.add(Alchemy_Game_Over_Background)
  
  // Background
  begin object class=UI_Sprite Name=Alchemy_Game_Over_Window
    tag="Alchemy_Game_Over_Window"
    posX=370
    posY=100
    images(0)=Window_Background
  end object
  componentList.add(Alchemy_Game_Over_Window)
  
  // Header
  begin object class=UI_Label Name=Alchemy_Game_Over_Enchantment_Name
    tag="Alchemy_Game_Over_Enchantment_Name"
    posX=0
    posY=125
    posXEnd=NATIVE_WIDTH
    posYEnd=161
    alignX=CENTER
    alignY=TOP
    fontStyle=DEFAULT_LARGE_WHITE
    labelText="Mystic Marble"
  end object
  componentList.add(Alchemy_Game_Over_Enchantment_Name)
  
  // Enchantment effect description (Line #1)
  begin object class=UI_Label Name=Alchemy_Game_Over_Enchantment_Description_1
    tag="Alchemy_Game_Over_Enchantment_Description_1"
    posX=0
    posY=340
    posXEnd=NATIVE_WIDTH
    posYEnd=361
    alignX=CENTER
    alignY=TOP
    fontStyle=DEFAULT_SMALL_WHITE
    labelText="Increasese maximum mana for every"
  end object
  componentList.add(Alchemy_Game_Over_Enchantment_Description_1)
  
  // Enchantment effect description (Line #2)
  begin object class=UI_Label Name=Alchemy_Game_Over_Enchantment_Description_2
    tag="Alchemy_Game_Over_Enchantment_Description_2"
    posX=0
    posY=367
    posXEnd=NATIVE_WIDTH
    posYEnd=388
    alignX=CENTER
    alignY=TOP
    fontStyle=DEFAULT_SMALL_WHITE
    labelText="party of heroes"
  end object
  componentList.add(Alchemy_Game_Over_Enchantment_Description_2)
    
  // Enchantment effect label
  begin object class=UI_Label Name=Alchemy_Game_Over_Enchantment_Round_Bonus_Label
    tag="Alchemy_Game_Over_Enchantment_Round_Bonus_Label"
    posX=0
    posY=440
    posXEnd=NATIVE_WIDTH
    posYEnd=498
    fontStyle=DEFAULT_SMALL_GREEN
    labelText="+2 Health Regen for each round cleared"
    alignX=CENTER
    alignY=TOP
  end object
  componentList.add(Alchemy_Game_Over_Enchantment_Round_Bonus_Label)
  
  // Enchantment level bonus
  begin object class=UI_Label Name=Alchemy_Game_Over_Enchantment_Bonus_Label
    tag="Alchemy_Game_Over_Enchantment_Bonus_Label"
    posX=0
    posY=517
    posXEnd=NATIVE_WIDTH
    posYEnd=575
    fontStyle=DEFAULT_SMALL_WHITE
    labelText="Level Bonus: 1"
    alignX=CENTER
    alignY=TOP
  end object
  componentList.add(Alchemy_Game_Over_Enchantment_Bonus_Label)
  
  // Enchantment level bonus
  begin object class=UI_Label Name=Alchemy_Game_Over_Enchantment_Added_Boost
    tag="Alchemy_Game_Over_Enchantment_Added_Boost"
    posX=0
    posY=594
    posXEnd=NATIVE_WIDTH
    posYEnd=652
    fontStyle=DEFAULT_SMALL_GREEN
    labelText="Adding +12 Health Regen"
    alignX=CENTER
    alignY=TOP
  end object
  componentList.add(Alchemy_Game_Over_Enchantment_Added_Boost)
  
  // Enchantment level bonus
  begin object class=UI_Label Name=Alchemy_Game_Over_Enchantment_Total_Boost
    tag="Alchemy_Game_Over_Enchantment_Total_Boost"
    posX=0
    posY=671
    posXEnd=NATIVE_WIDTH
    posYEnd=729
    fontStyle=DEFAULT_SMALL_ORANGE
    labelText="New Total: +22 Health Regen"
    alignX=CENTER
    alignY=TOP
  end object
  componentList.add(Alchemy_Game_Over_Enchantment_Total_Boost)
  
}























