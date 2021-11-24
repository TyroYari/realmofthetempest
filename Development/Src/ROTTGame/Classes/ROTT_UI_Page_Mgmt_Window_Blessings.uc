/*=============================================================================
 * ROTT_UI_Page_Mgmt_Window_Blessings
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: Interface for adding stat blessings.
 *===========================================================================*/
 
class ROTT_UI_Page_Mgmt_Window_Blessings extends ROTT_UI_Page;

// Button options
enum StatsMenuOptions {
  STATS_BLESS_1,
  STATS_BLESS_5,
  STATS_BLESS_ALL
};

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
  
  selectionBox = UI_Selector(findComp("Selector"));
}

/*=============================================================================
 * refresh()
 *
 * Called to update the gold and gems
 *===========================================================================*/
public function refresh() {
  // Set Blessing price tag
  setCostValues(gameInfo.getBlessingCost());
}

/*============================================================================= 
 * onPushPageEvent()
 *
 * This event is called every time the page is pushed.
 *===========================================================================*/
event onPushPageEvent() {
  selectionBox.resetSelection();
  refresh();
}

/*============================================================================= 
 * onPopPageEvent()
 *
 * 
 *===========================================================================*/
event onPopPageEvent() {
  
}

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
  local bool bBlessSuccess, bInvestAll;
  local ROTT_Combat_Hero hero;
  local byte selection;
  local int blessCount;
  
  // Get player's selection info
  hero = parentScene.getSelectedHero();
  selection = sceneManager.getSelectedStat();
  
  // Get player's investment choice
  switch (selectionBox.getSelection()) {
    case STATS_BLESS_1: 
      blessCount = 1;
      break;
    case STATS_BLESS_5: 
      blessCount = 5;
      break;
    case STATS_BLESS_ALL: 
      bInvestAll = true;
      break;
  }
  
  // Apply blessings
  bBlessSuccess = blessHero(hero, selection, blessCount, bInvestAll);
  
  // Sound effects
  if (bBlessSuccess) {
    sfxBox.playSFX(SFX_MENU_BLESS_STAT);
  } else {
    sfxBox.playSFX(SFX_MENU_INSUFFICIENT);
  }
  
  // UI update
  parentScene.refresh();
}

protected function navigationRoutineB() {
  parentScene.popPage();
  
  // Sfx
  gameInfo.sfxBox.playSfx(SFX_MENU_BACK);
}

/*=============================================================================
 * blessHero()
 *
 * Attempts to bless the given hero any number of times.
 *===========================================================================*/
public function bool blessHero
(
  ROTT_Combat_Hero hero, 
  byte selection, 
  int blessCount, 
  bool bInvestAll
)
{
  local bool bSuccess;
  local int i;
  
  for (i = 0; (i < blessCount || bInvestAll) && i <= 100; i++) {
    // Attempt to bless
    switch (hero.blessStat(StatTypes(selection))) {
      case 0:
        // Blessing added successfully
        bSuccess = true;
        break;
      case -1:
        // Insufficient funds for this point
        return bSuccess;
      case -2:
        // Maximum blessings reached
        if (!bSuccess) makeLabel("Maximum Blessings"); 
        return bSuccess;
    }
  }
  
  return bSuccess;
}
/*=============================================================================
 * Assets
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
    labelText="Add Stat Blessing"
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
  begin object class=UI_Texture_Info Name=Button_Blessing_Invest_1
    componentTextures.add(Texture2D'GUI.Button_Blessing_Invest_1')
  end object
  begin object class=UI_Texture_Info Name=Button_Blessing_Invest_5
    componentTextures.add(Texture2D'GUI.Button_Blessing_Invest_5')
  end object
  begin object class=UI_Texture_Info Name=Button_Blessing_Invest_All 
    componentTextures.add(Texture2D'GUI.Button_Blessing_Invest_All')
  end object
  
  // Buttons
  begin object class=UI_Sprite Name=Button_Invest_1_Sprite
    tag="Button_Invest_1_Sprite"
    posX=132
    posY=544
    images(0)=Button_Blessing_Invest_1
  end object
  componentList.add(Button_Invest_1_Sprite)
  
  begin object class=UI_Sprite Name=Button_Invest_5_Sprite
    tag="Button_Invest_5_Sprite"
    posX=132
    posY=624
    images(0)=Button_Blessing_Invest_5
  end object
  componentList.add(Button_Invest_5_Sprite)
  
  begin object class=UI_Sprite Name=Button_Invest_All_Sprite
    tag="Button_Invest_All_Sprite"
    posX=132
    posY=704
    images(0)=Button_Blessing_Invest_All
  end object
  componentList.add(Button_Invest_All_Sprite)
  
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





