/*=============================================================================
 * ROTT_UI_Page_Mgmt_Window_Reset_Stats
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: Users are shown reset stat information through this interface.
 *===========================================================================*/
 
class ROTT_UI_Page_Mgmt_Window_Reset_Stats extends ROTT_UI_Page;

/** ============================== **/

enum ResetStatOptions {
  STATS_RESET_1,
  STATS_RESET_5,
  STATS_RESET_ALL,
};

/** ============================== **/

// Selector
var private UI_Selector selectionBox;

/*=============================================================================
 * Initialize Component
 *
 * Description: This event is called as the UI is loaded.
 *              Our initial scene is drawn here.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  super.initializeComponent(newTag);
  
  // Internal references
  selectionBox = UI_Selector(findComp("Selector"));
}

/*=============================================================================
 * refresh()
 *
 * Called to update the gold and gems
 *===========================================================================*/
public function refresh() {
  // Give cost display info to the displayer
  setCostValues(gameInfo.getResetStatCost());
}

/*============================================================================= 
 * onPushPageEvent()
 *
 * This event is called every time the page is pushed.
 *===========================================================================*/
event onPushPageEvent() {
  refresh();
  selectionBox.resetSelection();
}

/*============================================================================= 
 * onPopPageEvent()
 *
 * 
 *===========================================================================*/
event onPopPageEvent();

/*=============================================================================
 * onFocusMenu()
 *
 * Called when a menu is given focus.  Assign controls, and enable graphics.
 *===========================================================================*/
event onFocusMenu() {
  
}

/*=============================================================================
 * Button controls
 *===========================================================================*/
protected function navigationRoutineA() {
  local bool bResetSuccess, bResetAll;
  local ROTT_Combat_Hero hero;
  local byte selection;
  local int resetCount;
  local int i;
  
  // Get player's selection info
  hero = parentScene.getSelectedHero();
  selection = sceneManager.getSelectedStat();
  
  // Get player's investment choice
  switch (selectionBox.getSelection()) {
    case STATS_RESET_1: 
      resetCount = 1;
      break;
    case STATS_RESET_5: 
      resetCount = 5;
      break;
    case STATS_RESET_ALL: 
      bResetAll = true;
      break;
  }
  
  // Reset stats
  for (i = 0; i < resetCount || bResetAll; i++) {
    // Attempt to remove a point
    if (hero.removeStat(StatTypes(selection))) {
      bResetSuccess = true;
    } else {
      // Stop when reset maxed
      break;
    }
  }
  
  // Sfx
  if (bResetSuccess) {
    sfxBox.playSFX(SFX_MENU_UNINVEST_STAT);
  } else {
    sfxBox.playSFX(SFX_MENU_INSUFFICIENT);
  }
  
  // Update UI
  parentScene.refresh();
}

protected function navigationRoutineB() {
  parentScene.popPage();
  
  // Sfx
  gameInfo.sfxBox.playSfx(SFX_MENU_BACK);
}

/*=============================================================================
 * Assets
 *===========================================================================*/
defaultProperties
{
  // Culling
  cullTags.add("Game_Menu_Selector")
  
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
  // Reset panel
  begin object class=UI_Texture_Info Name=Reset_Cost_Window
    componentTextures.add(Texture2D'GUI.Reset_Cost_Window')
  end object
  
  // Window background
  begin object class=UI_Texture_Info Name=Service_Window
    componentTextures.add(Texture2D'GUI.Reset_Cost_Window_With_Skill')
  end object
  
  /** ===== UI Components ===== **/
  // Window background
  begin object class=UI_Sprite Name=Blessing_Cost_Panel
    tag="Blessing_Cost_Panel"
    posX=0
    posY=0
    images(0)=Service_Window
  end object
  componentList.add(Blessing_Cost_Panel)
  
  // Header label
  begin object class=UI_Label Name=Header_Label
    tag="Header_Label"
    posX=0
    posY=74
    posXEnd=720
    posYEnd=NATIVE_HEIGHT
    fontStyle=DEFAULT_LARGE_WHITE
    AlignX=CENTER
    AlignY=TOP
    labelText="Reset a stat point"
  end object
  componentList.add(Header_Label)
  
  // Gold Cost Displayer
  begin object class=ROTT_UI_Displayer_Cost Name=Gold_Cost
    tag="Gold_Cost"
    posX=0
    posY=130
    currencyType=class'ROTT_Inventory_Item_Gold'
    costDescriptionText="Gold cost per point:"
    costValue=100
  end object
  componentList.add(Gold_Cost)
  
  // Button textures
  begin object class=UI_Texture_Info Name=Button_Reset_1
    componentTextures.add(Texture2D'GUI.Button_Reset_1')
  end object
  begin object class=UI_Texture_Info Name=Button_Reset_5
    componentTextures.add(Texture2D'GUI.Button_Reset_5')
  end object
  begin object class=UI_Texture_Info Name=Button_Reset_All 
    componentTextures.add(Texture2D'GUI.Button_Reset_All')
  end object
  
  // Buttons
  begin object class=UI_Sprite Name=Button_Reset_1_Sprite
    tag="Button_Reset_1_Sprite"
    posX=132
    posY=544
    images(0)=Button_Reset_1
  end object
  componentList.add(Button_Reset_1_Sprite)
  
  begin object class=UI_Sprite Name=Button_Reset_5_Sprite
    tag="Button_Reset_5_Sprite"
    posX=132
    posY=624
    images(0)=Button_Reset_5
  end object
  componentList.add(Button_Reset_5_Sprite)
  
  begin object class=UI_Sprite Name=Button_Reset_All_Sprite
    tag="Button_Reset_All_Sprite"
    posX=132
    posY=704
    images(0)=Button_Reset_All
  end object
  componentList.add(Button_Reset_All_Sprite)
  
  // Mgmt Window Selection Box
  begin object class=UI_Selector Name=Selector
    tag="Selector"
    bEnabled=true
    posX=144
    posY=552
    selectionOffset=(x=0,y=80)
    numberOfMenuOptions=3
    hoverCoords(0)=(xStart=146,yStart=555,xEnd=580,yEnd=625)
    hoverCoords(1)=(xStart=146,yStart=635,xEnd=580,yEnd=705)
    hoverCoords(2)=(xStart=146,yStart=715,xEnd=580,yEnd=785)
    
    // Selection texture
    begin object class=UI_Texture_Info Name=Selection_Box_Texture
      componentTextures.add(Texture2D'GUI.Mgmt_Window_Selector')
    end object

    // Selector sprite
    begin object class=UI_Sprite Name=Selector_Sprite
      tag="Selector_Sprite"
      drawLayer=TOP_LAYER
      images(0)=Selection_Box_Texture
      activeEffects.add((effectType = EFFECT_ALPHA_CYCLE, lifeTime = -1, elapsedTime = 0, intervalTime = 0.4, min = 170, max = 255))
    end object
    componentList.add(Selector_Sprite)
    
  end object
  componentList.add(Selector)
}





