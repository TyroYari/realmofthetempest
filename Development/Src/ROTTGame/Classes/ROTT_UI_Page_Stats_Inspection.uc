/*=============================================================================
 * ROTT_UI_Page_Stats_Inspection
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: Stats inspection displays primary stats, and substats, for a
 * hero selected from the party selection UI.
 *
 * (see: ROTT_UI_Page_Party_Selection.uc)
 * (see: ROTT_Combat_Hero.uc)
 *===========================================================================*/
 
class ROTT_UI_Page_Stats_Inspection extends ROTT_UI_Page_Hero_Info;

// Internal references
var private ROTT_UI_Character_Sheet_Header header;
var private UI_Sprite statsPageBackground;
var private UI_Sprite statsBoxes;
var private ROTT_UI_Stats_Selector statsSelector;
var private ROTT_UI_Statistic_Labels statisticLabels;
var private ROTT_UI_Statistic_Values statisticValues;
var private ROTT_UI_Displayer_Experience expInfo;
var private ROTT_UI_Displayer_Stat_Boosts statBoostDisplayer;

/*============================================================================= 
 * initializeComponent()
 *
 * Called once, when the scene is first initialized.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  super.initializeComponent(newTag);
  
  gameMenuScene = gameInfo.sceneManager.sceneGameMenu;
  
  // Internal references
  header = ROTT_UI_Character_Sheet_Header(findComp("Character_Sheet_Header"));
  statsPageBackground = findSprite("Stats_Page_Background");
  statsBoxes = findSprite("Stats_Border_Boxes");
  statsSelector = ROTT_UI_Stats_Selector(findComp("Stats_Selector"));
  
  statisticLabels = ROTT_UI_Statistic_Labels(findComp("Statistic_Labels"));
  statisticValues = ROTT_UI_Statistic_Values(findComp("Statistic_Values"));
  expInfo = ROTT_UI_Displayer_Experience(findComp("Experience_Bar_UI"));
  
  statBoostDisplayer = ROTT_UI_Displayer_Stat_Boosts(findComp("Stat_Boost_Displayer"));
  
  // Initial control state
  controlState = VIEW_MODE;
}

/*============================================================================= 
 * onPushPageEvent()
 *
 * This event is called every time the page is pushed.
 *===========================================================================*/
event onPushPageEvent() {
  // Render selected hero
  refresh();
  
  // Determine stat operations based on what kind of service or utility is up
  if (parentScene.pageTagIsUp("Reinvest_Stat_UI")) {
    // Selector graphics
    statsSelector.setSelectorType(SELECTOR_UNINVEST_BOX);
    statsSelector.setEnabled(true);
    
    // Enable reset stat operations
    controlState = RESET_SELECTION_MODE;
    return;
  } 
  
  // Determine stat operations based on what kind of service or utility is up
  if (parentScene.pageTagIsUp("Service_Info_Blessings")) {
    // Selector graphics
    statsSelector.setSelectorType(SELECTOR_BLESSING_BOX);
    statsSelector.setEnabled(true);
    
    // Enable blessing operations
    controlState = BLESS_SELECTION_MODE;
    return;
  }
  
  // Default stat selection mode
  statsSelector.setSelectorType(SELECTOR_DEFAULT_BOX);
}

/*=============================================================================
 * onFocusMenu()
 *
 * Called when a menu is given focus.  Assign controls, and enable graphics.
 *===========================================================================*/
event onFocusMenu() {
  super.onFocusMenu();
  
  // Change display based on control state
  switch (controlState) {
    case VIEW_MODE: 
      if (gameMenuScene != none) gameMenuScene.enablePageArrows(true);
      break;
  }
  
  // Determine stat operations based on what kind of service or utility is up
  if (parentScene.pageTagIsUp("Reinvest_Stat_UI")) {
    // Selector graphics
    statsSelector.setSelectorType(SELECTOR_UNINVEST_BOX);
    return;
  } 
  
  // Determine stat operations based on what kind of service or utility is up
  if (parentScene.pageTagIsUp("Service_Info_Blessings")) {
    // Selector graphics
    statsSelector.setSelectorType(SELECTOR_BLESSING_BOX);
    return;
  }
  
  // Default stat selection mode
  statsSelector.setSelectorType(SELECTOR_DEFAULT_BOX);
  
  // Check if player has already seen navigation tool tip
  if (!gameInfo.playerProfile.bHideHeroInfoToolTip) {
    // Show tool tip
    findComp("Tool_Tip_Container").setEnabled(true);
  }
}

/*============================================================================= 
 * onPopPageEvent()
 *
 * This event is called when the page is removed
 *===========================================================================*/
event onPopPageEvent() {
  super.onPopPageEvent();
  
  // Hide tool tip (skipping if statement for efficiency)
  findComp("Tool_Tip_Container").setEnabled(false);
  gameInfo.playerProfile.bHideHeroInfoToolTip = true;
}

/*============================================================================= 
 * refresh()
 *
 * This function should ensure that any data thats been changed will be 
 * correctly updated on the UI.
 *===========================================================================*/
public function refresh() {
  // Draw info
  renderHeroData(parentScene.getSelectedHero());
  renderStatData();
  
  // Check if preview item window is up
  if (gameMenuScene.pageIsUp(gameMenuScene.previewWindowItem)) {
    
    // Update item replacement preview window
    gameMenuScene.updateItemWindow(
      gameMenuScene.getSelectedHero().heldItem.getItemDescriptor(
        gameMenuScene.getSelectedHero().heldItem
      )
    );
  }
}

/*=============================================================================
 * getSelectedStat()
 *
 * Returns an index for which stat the player has selected
 *===========================================================================*/
public function byte getSelectedStat() {
  return statsSelector.getSelection();
}

/*============================================================================= 
 * renderHeroData()
 *
 * Given a hero, this displays all of its information to the screen
 *===========================================================================*/
private function renderHeroData(ROTT_Combat_Hero hero) {
  local string h3;
  
  // Set third header, for extra hero information
  if (hero.bDead && gameInfo.playerProfile.gameMode == MODE_HARDCORE) {
    // Show the hero has fallen in hardcore
    h3 = "R.I.P.";
  } else if (hero.blessingCount > 0) {
    // Show blessings
    h3 = "Blessings: " $ hero.blessingCount;
  } else {
    // Blank otherwise
    h3 = "";
  }
  
  // Header
  header.setDisplayInfo
  (  
    pCase(hero.myClass), 
    "Level " $ hero.level,
    h3,
    (hero.unspentStatPoints != 0) ? "Stat Points" : "",
    (hero.unspentStatPoints != 0) ? string(hero.unspentStatPoints) : ""
  );
  
  // Stats
  statisticValues.renderHeroData(hero);
  expInfo.attachDisplayer(hero);
  
  // Boost icons
  statBoostDisplayer.attachDisplayer(hero);
}

/*============================================================================= 
 * renderStatData()
 *
 * This passes a stat descriptor to the mgmt window
 *===========================================================================*/
private function renderStatData() {
  local ROTT_Combat_Hero hero;
  local ROTT_Descriptor descriptor;
  
  hero = parentScene.getSelectedHero();
  
  // Fetch stat descriptor
  descriptor = hero.statDescriptors.getScript(
    statsSelector.getSelection(),
    hero
  );
  
  // Update descriptor if needed
  if (gameMenuScene != none) gameMenuScene.setMgmtDescriptor(descriptor);
}

/*============================================================================*
 * Controls
 *
 * ControllerId     the controller that generated this input key event
 * Key              the name of the key which an event occured for
 * EventType        the type of event which occured
 * AmountDepressed  for analog keys, the depression percent.
 *
 * Returns: true to consume the key event, false to pass it on.
 *===========================================================================*/
function bool onInputKey
( 
  int ControllerId, 
  name Key, 
  EInputEvent Event, 
  float AmountDepressed = 1.f, 
  bool bGamepad = false
) 
{
  // Check input event
  if (Event == IE_Pressed) { 
    // A button press
    if (Key == 'Z') navigationRoutineLB();
    if (Key == 'C') navigationRoutineRB();
    
    // Check input keys
    switch (Key) {
      case 'Tilde': 
      case 'XBoxTypeS_Y': 
        // Show item information
        if (controlState == VIEW_MODE) {
          // Show held item info
          gameMenuScene.toggleSideItemWindow(
            gameMenuScene.getSelectedHero().heldItem.getItemDescriptor(
              gameMenuScene.getSelectedHero().heldItem
            ),
            0
          );
          
          // Play Sound
          sfxBox.playSfx(SFX_MENU_ACCEPT);
        }
        break;
    }
  }
  
  return super.onInputKey(ControllerId, Key, Event, AmountDepressed, bGamepad);
}

/*=============================================================================
 * D-Pad controls
 *===========================================================================*/
public function bool preNavigateUp() {
  switch (controlState) {
    case SELECTION_MODE:
      if (statsSelector.selectPrevious()) { 
        renderStatData();
        return true;
      }
      break;
    case RESET_SELECTION_MODE:
    case BLESS_SELECTION_MODE:
      if (statsSelector.selectPrevious()) { 
        return true;
      }
      break;
  }
  return false;
}

public function bool preNavigateDown() {
  switch (controlState) {
    case SELECTION_MODE:
      if (statsSelector.selectNext()) { 
        renderStatData();
        return true;
      }
      break;
    case RESET_SELECTION_MODE:
    case BLESS_SELECTION_MODE:
      if (statsSelector.selectNext()) { 
        return true;
      }
      break;
  }
  return false;
}

public function onNavigateLeft() {
  if (gameMenuScene == none) return;
  switch (controlState) {
    case VIEW_MODE:
      // Change view to master tree
      parentScene.popPage("Preview_Window_Item");
      gameMenuScene.switchPage(MASTERY_SKILLTREE);
      break;
  }
}

public function onNavigateRight() {
  if (gameMenuScene == none) return;
  switch (controlState) {
    case VIEW_MODE:
      // Change view to class tree
      parentScene.popPage("Preview_Window_Item");
      gameMenuScene.switchPage(CLASS_SKILLTREE);
      break;
  }
}

/*=============================================================================
 * Button controls
 *===========================================================================*/
protected function navigationRoutineA() {
  // Check if tool tip info is up
  if (!gameInfo.playerProfile.bHideHeroInfoToolTip) {
    // Show tool tip
    findComp("Tool_Tip_Container").addEffectToQueue(FADE_OUT, 0.6);
    gameInfo.playerProfile.bHideHeroInfoToolTip = true;
    return;
  }
  
  switch (controlState) {
    case VIEW_MODE:
      // Hide item preview if up
      gameMenuScene.popPage("Preview_Window_Item");
      
      // Switch from page selection, to stat inspection
      controlState = SELECTION_MODE;
      gameMenuScene.enablePageArrows(false);
      statsSelector.setEnabled(true);
      gameMenuScene.pushMenu(MGMT_WINDOW_STATS);
      renderStatData();
      
      // Sfx
      gameinfo.sfxBox.playSFX(SFX_MENU_ACCEPT);
      break;
    case SELECTION_MODE:
      // Give to control to management window
      statsSelector.setSelectorType(SELECTOR_DEFAULT_ARROW);
      parentScene.focusTop();
      
      // Sfx
      gameinfo.sfxBox.playSFX(SFX_MENU_ACCEPT);
      break;
    case RESET_SELECTION_MODE:
      // Focus reset manager
      parentScene.pushPageByTag("Reset_Stat_Manager_UI"); 
      statsSelector.setSelectorType(SELECTOR_DEFAULT_ARROW);
      
      // Sfx
      gameinfo.sfxBox.playSFX(SFX_MENU_ACCEPT);
      break;
    case BLESS_SELECTION_MODE:
      // Focus blessing manager
      parentScene.pushPageByTag("Blessing_Management_UI"); 
      statsSelector.setSelectorType(SELECTOR_DEFAULT_ARROW);
      
      // Sfx
      gameinfo.sfxBox.playSFX(SFX_MENU_ACCEPT);
      break;
  }
}

protected function navigationRoutineB() {
  switch (controlState) {
    case VIEW_MODE:
      // Close menu
      parentScene.popPage("Preview_Window_Item");
      parentScene.popPage(tag);
      break;
    case SELECTION_MODE:
      // Change to view mode
      controlState = VIEW_MODE;
      
      // Remove Selection box
      statsSelector.setEnabled(false);
      
      // Close the mgmt window
      parentScene.popPage();
      break;
    case RESET_SELECTION_MODE:
      // Return to party selection
      statsSelector.setEnabled(false);
      parentScene.popPage();
      controlState = VIEW_MODE;
      break;
    case BLESS_SELECTION_MODE:
      // Return to party selection
      statsSelector.setEnabled(false);
      parentScene.popPage();
      break;
  }
  // Sfx
  gameinfo.sfxBox.playSFX(SFX_MENU_BACK);
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
  // Stats Background
  begin object class=UI_Texture_Info Name=Menu_Background_Stats
    componentTextures.add(Texture2D'GUI.Menu_Background_Stats')
  end object
  
  // Stat boxes background
  begin object class=UI_Texture_Info Name=Stat_Boxes_Background
    componentTextures.add(Texture2D'GUI.Stats_MainStat_Boxes')
  end object
  
  /** ===== UI Components ===== **/
  // Stats Page Background
  begin object class=UI_Sprite Name=Stats_Page_Background
    tag="Stats_Page_Background"
    posX=720
    posY=0
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    images(0)=Menu_Background_Stats
  end object
  componentList.add(Stats_Page_Background)

  // Header
  begin object class=ROTT_UI_Character_Sheet_Header Name=Character_Sheet_Header
    tag="Character_Sheet_Header"
  end object
  componentList.add(Character_Sheet_Header)
  
  // Stat Selection Boxes
  begin object class=UI_Sprite Name=Stats_Border_Boxes
    tag="Stats_Border_Boxes"
    posX=757
    posY=194
    images(0)=Stat_Boxes_Background
  end object
  componentList.add(Stats_Border_Boxes)
  
  // Stats Selection Component
  begin object class=ROTT_UI_Stats_Selector Name=Stats_Selector
    tag="Stats_Selector"
    bEnabled=false
    posX=757
    posY=194
    hoverCoords(0)=(xStart=754,yStart=194,xEnd=1001,yEnd=244)
    hoverCoords(1)=(xStart=754,yStart=251,xEnd=1001,yEnd=326)
    hoverCoords(2)=(xStart=754,yStart=338,xEnd=1001,yEnd=557)
    hoverCoords(3)=(xStart=754,yStart=567,xEnd=1001,yEnd=727)
  end object
  componentList.add(Stats_Selector)
  
  // Statistic Labels
  begin object class=ROTT_UI_Statistic_Labels Name=Statistic_Labels
    tag="Statistic_Labels"
    posX=759
    posY=0
    posXEnd=1344
    posYEnd=765
  end object
  componentList.add(Statistic_Labels)
  
  // Statistic Values
  begin object class=ROTT_UI_Statistic_Values Name=Statistic_Values
    tag="Statistic_Values"
    posX=0
    posY=0
    posXEnd=1397
    posYEnd=NATIVE_HEIGHT
  end object
  componentList.add(Statistic_Values)
  
  // Experience Bar
  begin object class=ROTT_UI_Displayer_Experience Name=Experience_Bar_UI
    tag="Experience_Bar_UI"
    posX=720
    posY=737
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
  end object
  componentList.add(Experience_Bar_UI)
  
  /** ===================================================================== **/
  
  // Stat Boost Icons
  begin object class=ROTT_UI_Displayer_Stat_Boosts Name=Stat_Boost_Displayer
    tag="Stat_Boost_Displayer"
    posX=0
    posY=0
  end object
  componentList.add(Stat_Boost_Displayer)
  
  /** ===================================================================== **/
  
  // Tool tip container
  begin object class=UI_Container Name=Tool_Tip_Container
    tag="Tool_Tip_Container"
    bEnabled=false
      
    // Black texture
    begin object class=UI_Texture_Info Name=Black_Texture
      componentTextures.add(Texture2D'GUI.Black_Square')
      drawColor=(R=255,G=255,B=255,A=220)
    end object
    
    // Tool tip fader 
    begin object class=UI_Sprite Name=Tool_Tip_Fader 
      tag="Tool_Tip_Fader"
      posX=720
      posY=0
      posXEnd=NATIVE_WIDTH
      posYEnd=NATIVE_HEIGHT
      images(0)=Black_Texture
    end object
    componentList.add(Tool_Tip_Fader)
    
    // Black texture
    begin object class=UI_Texture_Info Name=Tool_Tip_Box
      componentTextures.add(Texture2D'GUI.Tool_Tip_Box')
    end object
    
    // Tool Tip Box Sprite
    begin object class=UI_Sprite Name=Tool_Tip_Box_Sprite
      tag="Tool_Tip_Box_Sprite"
      posX=884
      posY=360
      images(0)=Tool_Tip_Box
    end object
    componentList.add(Tool_Tip_Box_Sprite)
    
    // Navigation tooltip
    begin object class=UI_Label Name=Navigation_Tooltip_h1
      tag="Navigation_Tooltip_h1"
      posX=730
      posY=0
      posXEnd=NATIVE_WIDTH
      posYEnd=850
      AlignX=CENTER
      AlignY=CENTER
      fontStyle=DEFAULT_MEDIUM_WHITE
      labelText="Hero Info Navigation"
    end object
    componentList.add(Navigation_Tooltip_h1)
    
    // Navigation tooltip
    begin object class=UI_Label Name=Navigation_Tooltip_h2
      tag="Navigation_Tooltip_h2"
      posX=730
      posY=100
      posXEnd=NATIVE_WIDTH
      posYEnd=NATIVE_HEIGHT
      AlignX=CENTER
      AlignY=CENTER
      fontStyle=DEFAULT_SMALL_TAN
      labelText="Select pages left and right"
    end object
    componentList.add(Navigation_Tooltip_h2)
    
    // Navigation tooltip
    begin object class=UI_Label Name=Navigation_Tooltip
      tag="Navigation_Tooltip"
      posX=730
      posY=826
      posXEnd=NATIVE_WIDTH
      posYEnd=866
      AlignX=CENTER
      AlignY=CENTER
      fontStyle=DEFAULT_SMALL_TAN
      labelText="- Left -                                                     - Right -"
      
      activeEffects.add((effectType = EFFECT_ALPHA_CYCLE, lifeTime = -1, elapsedTime = 0, intervalTime = 0.6, min = 200, max = 255))
    end object
    componentList.add(Navigation_Tooltip)
    
  end object
  componentList.add(Tool_Tip_Container)

}











