/*=============================================================================
 * ROTT_UI_Stats_Selector
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This controls the selection boxes for stats inspection UI.
 *===========================================================================*/
 
class ROTT_UI_Stats_Selector extends UI_Container;

// Stat Selector Types
enum StatSelectorTypes {
  CURRENT_SELECTOR, // Index 0 reserved for current draw info
  
  // Invest stats
  SELECTOR_DEFAULT_BOX,
  SELECTOR_DEFAULT_ARROW,
  
  // Reset stats
  SELECTOR_UNINVEST_BOX,
  SELECTOR_UNINVEST_ARROW,
  
  // Bless stats
  SELECTOR_BLESSING_BOX,
  SELECTOR_BLESSING_ARROW,
};

var private StatSelectorTypes navigationType;

// Stats menu items
enum StatMenuItems {
  MENU_VITALITY,
  MENU_STRENGTH,
  MENU_COURAGE,
  MENU_FOCUS 
};

// Navigation variables
var private StatMenuItems statMenuSelection;

// Internal references
var private UI_Sprite_Array statsSelectors[StatMenuItems];

// Hover select
var editinline instanced array<HoverSelectionCoords> hoverCoords;

/*=============================================================================
 * Initialize Component
 *
 * Description: This event is called as the UI is loaded.
 *              Our initial scene is drawn here.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  super.initializeComponent(newTag);
  
  // Initial navigation settings
  navigationType = SELECTOR_DEFAULT_BOX;
  
  // Internal references
  statsSelectors[MENU_VITALITY] = UI_Sprite_Array(findComp("Stat_Selection_Box_Vitality"));
  statsSelectors[MENU_STRENGTH] = UI_Sprite_Array(findComp("Stat_Selection_Box_Strength"));
  statsSelectors[MENU_COURAGE] = UI_Sprite_Array(findComp("Stat_Selection_Box_Courage"));
  statsSelectors[MENU_FOCUS] = UI_Sprite_Array(findComp("Stat_Selection_Box_Focus"));
}

/*=============================================================================
 * setEnabled()
 *===========================================================================*/
public function setEnabled(bool bNewEnabled) {
  super.setEnabled(bNewEnabled);
  
  if (bNewEnabled == true) {
    // Initialize selector position
    statMenuSelection = MENU_VITALITY;
    statsSelectors[statMenuSelection].setEnabled(true);
  } else {
    // Disable old selection
    statsSelectors[statMenuSelection].setEnabled(false);
  }
}

/*=============================================================================
 * elapseTimer()
 *
 * Increments time every engine tick.
 *===========================================================================*/
public function elapseTimer(float deltaTime, float gameSpeedOverride) {
  local UI_Player_Input playerInput;
  local int i;
  
  super.elapseTimer(deltaTime, gameSpeedOverride);
  
  // Check if component is active
  if (!bEnabled) return;
  switch (navigationType) {
    case SELECTOR_DEFAULT_ARROW:
    case SELECTOR_UNINVEST_ARROW:
    case SELECTOR_BLESSING_ARROW:
      return;
  }
  
  // Get player input data
  playerInput = UI_Player_Input(getPlayerInput());
  if (hud.bHideCursor) return;
  
  // Scan through coordinate sets
  for (i = 0; i < hoverCoords.length; i++) {
    // Check X bounds
    if (playerInput.getMousePositionX() < hoverCoords[i].xEnd) {
      if (playerInput.getMousePositionX() > hoverCoords[i].xStart) {
        // Check Y bounds
        if (playerInput.getMousePositionY() < hoverCoords[i].yEnd) {
          if (playerInput.getMousePositionY() > hoverCoords[i].yStart) {
            // Update selection
            forceSelection(StatMenuItems(i));
            return;
          }
        }
      }
    }
  }
}

/*=============================================================================
 * selectPrevious()
 *===========================================================================*/
public function bool selectPrevious() {
  if (statMenuSelection > 0) {
    // Hide old selection
    statsSelectors[statMenuSelection].setEnabled(false);
    
    // Show selection
    statMenuSelection = StatMenuItems(statMenuSelection - 1);
    statsSelectors[statMenuSelection].setEnabled(true);
    setSelectorType(navigationType);
    return true;
  }
  return false;
}

/*=============================================================================
 * forceSelection()
 *===========================================================================*/
public function forceSelection(coerce StatMenuItems newSelection) {
  local int i;
  
  // Hide old selection
  for (i = 0; i < StatMenuItems.EnumCount; i++) { 
    statsSelectors[i].setEnabled(false);
  }
  
  // Show selection
  statMenuSelection = newSelection;
  statsSelectors[statMenuSelection].setEnabled(true);
  setSelectorType(navigationType);
  
  if (UI_Page(outer) != none) UI_Page(outer).refresh();
}

/*=============================================================================
 * selectNext()
 *===========================================================================*/
public function bool selectNext() {
  if (statMenuSelection + 1 < StatMenuItems.EnumCount) {
    // Hide old selection
    statsSelectors[statMenuSelection].setEnabled(false);
    
    // Show selection
    statMenuSelection = StatMenuItems(statMenuSelection + 1);
    statsSelectors[statMenuSelection].setEnabled(true);
    setSelectorType(navigationType);
    return true;
  }
  return false;
}


/*=============================================================================
 * setSelectorType()
 *
 * Changes the selector based on a given selection mode
 *===========================================================================*/
public function setSelectorType(StatSelectorTypes newType) {
  local int i;
  
  // Track selector type
  navigationType = newType;
  
  // Update selector graphics
  for (i = 0; i < StatMenuItems.EnumCount; i++) {
    statsSelectors[i].setDrawIndex(navigationType);
  }
  
  // Update selector effects
  switch (navigationType) {
    case SELECTOR_DEFAULT_BOX: 
    case SELECTOR_UNINVEST_BOX: 
    case SELECTOR_BLESSING_BOX: 
      statsSelectors[statMenuSelection].clearEffects();
      statsSelectors[statMenuSelection].addAlphaEffect(-1, 0.4, , 170, 255);
      break;
    case SELECTOR_DEFAULT_ARROW:
    case SELECTOR_UNINVEST_ARROW: 
    case SELECTOR_BLESSING_ARROW: 
      statsSelectors[statMenuSelection].clearEffects();
      statsSelectors[statMenuSelection].addFlickerEffect(-1, 0.1, , 200, 255);
      break;
  }
}

/*=============================================================================
 * getSelection()
 *
 * returns an index of which item is selected
 *===========================================================================*/
public function int getSelection() {
  return int(statMenuSelection);
}

/*=============================================================================
 * addAlphaEffect()
 *===========================================================================*/
private function addAlphaEffect() {
  statsSelectors[statMenuSelection].addAlphaEffect();
}

/*=============================================================================
 * addFlickerEffect()
 *===========================================================================*/
private function addFlickerEffect() {
  statsSelectors[statMenuSelection].addFlickerEffect();
}

/*=============================================================================
 * raveHighwindCall()
 *
 * Called by a cheat that enables rave mode graphics on selectors.
 *===========================================================================*/
public function raveHighwindCall() {
  super.raveHighwindCall();
  
  /// to do: addHueEffect();
}

/*=============================================================================
 * Assets
 *===========================================================================*/
defaultProperties
{
  /** ===== Textures ===== **/
  // Stat Selection Boxes
  begin object class=UI_Texture_Info Name=Stat_Selection_Box_1
    componentTextures.add(Texture2D'GUI.Stat_Selection_Box_1')
  end object
  begin object class=UI_Texture_Info Name=Stat_Selection_Box_2
    componentTextures.add(Texture2D'GUI.Stat_Selection_Box_2')
  end object
  begin object class=UI_Texture_Info Name=Stat_Selection_Box_3
    componentTextures.add(Texture2D'GUI.Stat_Selection_Box_3')
  end object
  begin object class=UI_Texture_Info Name=Stat_Selection_Box_4
    componentTextures.add(Texture2D'GUI.Stat_Selection_Box_4')
  end object
  //-----------------------------------------------------------------
  begin object class=UI_Texture_Info Name=Stat_Selection_Box_1_Red
    componentTextures.add(Texture2D'GUI.Stat_Selection_Box_1_Red')
  end object
  begin object class=UI_Texture_Info Name=Stat_Selection_Box_2_Red
    componentTextures.add(Texture2D'GUI.Stat_Selection_Box_2_Red')
  end object
  begin object class=UI_Texture_Info Name=Stat_Selection_Box_3_Red
    componentTextures.add(Texture2D'GUI.Stat_Selection_Box_3_Red')
  end object
  begin object class=UI_Texture_Info Name=Stat_Selection_Box_4_Red
    componentTextures.add(Texture2D'GUI.Stat_Selection_Box_4_Red')
  end object
  //-----------------------------------------------------------------
  begin object class=UI_Texture_Info Name=Stat_Selection_Box_1_Blue
    componentTextures.add(Texture2D'GUI.Stat_Selection_Box_1_Blue')
  end object
  begin object class=UI_Texture_Info Name=Stat_Selection_Box_2_Blue
    componentTextures.add(Texture2D'GUI.Stat_Selection_Box_2_Blue')
  end object
  begin object class=UI_Texture_Info Name=Stat_Selection_Box_3_Blue
    componentTextures.add(Texture2D'GUI.Stat_Selection_Box_3_Blue')
  end object
  begin object class=UI_Texture_Info Name=Stat_Selection_Box_4_Blue
    componentTextures.add(Texture2D'GUI.Stat_Selection_Box_4_Blue')
  end object
  
  // Mini arrow navigation markers
  begin object class=UI_Texture_Info Name=Mini_Selection_Arrow_Texture
    componentTextures.add(Texture2D'GUI.Menu_Selection_Arrow')
  end object
  
  /** ===== UI Components ===== **/
  // Stats Selection Boxes
  begin object class=UI_Sprite_Array Name=Stat_Selection_Box_Vitality
    tag="Stat_Selection_Box_Vitality"
    bEnabled=false
    posX=755
    posY=192
    images(0)=Stat_Selection_Box_1
    images(SELECTOR_DEFAULT_BOX)    = Stat_Selection_Box_1
    images(SELECTOR_DEFAULT_ARROW)  = Mini_Selection_Arrow_Texture
    images(SELECTOR_UNINVEST_BOX)   = Stat_Selection_Box_1_Red
    images(SELECTOR_UNINVEST_ARROW) = Mini_Selection_Arrow_Texture
    images(SELECTOR_BLESSING_BOX)   = Stat_Selection_Box_1_Blue
    images(SELECTOR_BLESSING_ARROW) = Mini_Selection_Arrow_Texture
    
    //overrideCoords(0)=(index=SELECTOR_DEFAULT_ARROW,posX=745,posY=205)
    overrideCoords.add((index=SELECTOR_DEFAULT_ARROW,posX=712,posY=171))
  
  end object
  componentList.add(Stat_Selection_Box_Vitality)
  
  begin object class=UI_Sprite_Array Name=Stat_Selection_Box_Strength
    tag="Stat_Selection_Box_Strength"
    bEnabled=false
    posX=755
    posY=252
    images(0)=Stat_Selection_Box_2
    images(SELECTOR_DEFAULT_BOX)    = Stat_Selection_Box_2
    images(SELECTOR_DEFAULT_ARROW)  = Mini_Selection_Arrow_Texture
    images(SELECTOR_UNINVEST_BOX)   = Stat_Selection_Box_2_Red
    images(SELECTOR_UNINVEST_ARROW) = Mini_Selection_Arrow_Texture
    images(SELECTOR_BLESSING_BOX)   = Stat_Selection_Box_2_Blue
    images(SELECTOR_BLESSING_ARROW) = Mini_Selection_Arrow_Texture
    
    //overrideCoords(0)=(index=SELECTOR_DEFAULT_ARROW,posX=745,posY=265)
    overrideCoords(0)=(index=SELECTOR_DEFAULT_ARROW,posX=712,posY=231)
  
  end object
  componentList.add(Stat_Selection_Box_Strength) 
  
  begin object class=UI_Sprite_Array Name=Stat_Selection_Box_Courage
    tag="Stat_Selection_Box_Courage"
    bEnabled=false
    posX=755
    posY=336
    images(0)=Stat_Selection_Box_3
    images(SELECTOR_DEFAULT_BOX)    = Stat_Selection_Box_3
    images(SELECTOR_DEFAULT_ARROW)  = Mini_Selection_Arrow_Texture
    images(SELECTOR_UNINVEST_BOX)   = Stat_Selection_Box_3_Red
    images(SELECTOR_UNINVEST_ARROW) = Mini_Selection_Arrow_Texture
    images(SELECTOR_BLESSING_BOX)   = Stat_Selection_Box_3_Blue
    images(SELECTOR_BLESSING_ARROW) = Mini_Selection_Arrow_Texture
    
    //overrideCoords(0)=(index=SELECTOR_DEFAULT_ARROW,posX=745,posY=349)
    overrideCoords(0)=(index=SELECTOR_DEFAULT_ARROW,posX=712,posY=315)
    
  end object
  componentList.add(Stat_Selection_Box_Courage)
  
  begin object class=UI_Sprite_Array Name=Stat_Selection_Box_Focus
    tag="Stat_Selection_Box_Focus"
    bEnabled=false
    posX=755
    posY=566
    images(0)=Stat_Selection_Box_4
    images(SELECTOR_DEFAULT_BOX)    = Stat_Selection_Box_4
    images(SELECTOR_DEFAULT_ARROW)  = Mini_Selection_Arrow_Texture
    images(SELECTOR_UNINVEST_BOX)   = Stat_Selection_Box_4_Red
    images(SELECTOR_UNINVEST_ARROW) = Mini_Selection_Arrow_Texture
    images(SELECTOR_BLESSING_BOX)   = Stat_Selection_Box_4_Blue
    images(SELECTOR_BLESSING_ARROW) = Mini_Selection_Arrow_Texture
    
    //overrideCoords(0)=(index=SELECTOR_DEFAULT_ARROW,posX=745,posY=579)
    overrideCoords(0)=(index=SELECTOR_DEFAULT_ARROW,posX=712,posY=545)
  
  end object
  componentList.add(Stat_Selection_Box_Focus)
}
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  