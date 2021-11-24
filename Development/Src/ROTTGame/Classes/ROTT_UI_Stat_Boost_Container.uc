/*=============================================================================
 * ROTT_UI_Stat_Boost_Container
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This container shows stat boost icons, plus signs and chevrons
 * from left to right.
 *===========================================================================*/

class ROTT_UI_Stat_Boost_Container extends UI_Container;

// Types of icons displayable by this container
enum StatBoostIcons {
  STAT_BOOST_BLUE_CROSS,
  STAT_BOOST_GREEN_CROSS,
  STAT_BOOST_ORANGE_CROSS,
  STAT_BOOST_BLUE_CHEVRON,
  STAT_BOOST_GREEN_CHEVRON,
  STAT_BOOST_ORANGE_CHEVRON,
};

// Icon status
enum DisplayStatus {
  ICON_DISPLAYED,
  ICON_HIDDEN
};

// Store display status for each icon
var private DisplayStatus enabledIcons[StatBoostIcons];

// Store the count of how many icons are being displayed
var private int enabledIconCount;

// Internal references
var private UI_Sprite highlightIcon[6];
var private UI_Sprite baseIcon[6];

/*============================================================================= 
 * initializeComponent
 *
 * This is called as the UI is loaded.  Our initial scene is drawn here.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  local int i;
  super.initializeComponent(newTag);
  
  // Set internal references
  for (i = 0; i < 6; i++) {
    highlightIcon[i] = findSprite("Stat_Boost_Highlight_" $ i+1);
    baseIcon[i] = findSprite("Stat_Boost_Base_" $ i+1);
  }
}

/*=============================================================================
 * resetDisplay()
 *
 * Called to clear the icon list
 *===========================================================================*/
public function resetDisplay() {
  local int i;
  
  // Iterate through graphic list
  for (i = 0; i < 6; i++) {
    // Set all icon status to hidden
    enabledIcons[i] = ICON_HIDDEN;
    
    // Set display to hidden
    highlightIcon[i].setEnabled(false);
    baseIcon[i].setEnabled(false);
  }
  
  // Reset display count
  enabledIconCount = 0;
}

/*=============================================================================
 * enableIcon()
 *
 * Called to add an icon to the list.  Returns false if already enabled.
 *===========================================================================*/
public function bool enableIcon(StatBoostIcons iconType) {
  // Check for valid addition to icon list
  if (enabledIcons[iconType] == ICON_DISPLAYED) {
    yellowLog("Warning (!) Stat boost icon already displayed. " $ iconType);
    return false;
  }
  
  // Set icon status to displayed
  enabledIcons[iconType] = ICON_DISPLAYED;
  
  // Set icon display info
  highlightIcon[enabledIconCount].setEnabled(true);
  baseIcon[enabledIconCount].setEnabled(true);
  highlightIcon[enabledIconCount].setDrawIndex(iconType);
  baseIcon[enabledIconCount].setDrawIndex(iconType);
  
  // Keep count of displayed icons
  enabledIconCount++;
  
  return true;
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  bDrawRelative=true
  
  /** ===== Textures ===== **/
  // Blue crosses and chevrons
  begin object class=UI_Texture_Info Name=Stat_Boost_Icon_Small_Plus_Blue_Highlight
    componentTextures.add(Texture2D'GUI.Stats.Stat_Boost_Icon_Small_Plus_Blue_Highlight')
  end object
  begin object class=UI_Texture_Info Name=Stat_Boost_Icon_Small_Plus_Blue
    componentTextures.add(Texture2D'GUI.Stats.Stat_Boost_Icon_Small_Plus_Blue')
  end object
  begin object class=UI_Texture_Info Name=Stat_Boost_Icon_Small_Chevron_Blue_Highlight
    componentTextures.add(Texture2D'GUI.Stats.Stat_Boost_Icon_Small_Chevron_Blue_Highlight')
  end object
  begin object class=UI_Texture_Info Name=Stat_Boost_Icon_Small_Chevron_Blue
    componentTextures.add(Texture2D'GUI.Stats.Stat_Boost_Icon_Small_Chevron_Blue')
  end object
    
  // Green crosses and chevrons
  begin object class=UI_Texture_Info Name=Stat_Boost_Icon_Small_Plus_Green_Highlight
    componentTextures.add(Texture2D'GUI.Stats.Stat_Boost_Icon_Small_Plus_Green_Highlight')
  end object
  begin object class=UI_Texture_Info Name=Stat_Boost_Icon_Small_Plus_Green
    componentTextures.add(Texture2D'GUI.Stats.Stat_Boost_Icon_Small_Plus_Green')
  end object
  begin object class=UI_Texture_Info Name=Stat_Boost_Icon_Small_Chevron_Green_Highlight
    componentTextures.add(Texture2D'GUI.Stats.Stat_Boost_Icon_Small_Chevron_Green_Highlight')
  end object
  begin object class=UI_Texture_Info Name=Stat_Boost_Icon_Small_Chevron_Green
    componentTextures.add(Texture2D'GUI.Stats.Stat_Boost_Icon_Small_Chevron_Green')
  end object
    
  // Orange crosses and chevrons
  begin object class=UI_Texture_Info Name=Stat_Boost_Icon_Small_Plus_Orange_Highlight
    componentTextures.add(Texture2D'GUI.Stats.Stat_Boost_Icon_Small_Plus_Orange_Highlight')
  end object
  begin object class=UI_Texture_Info Name=Stat_Boost_Icon_Small_Plus_Orange
    componentTextures.add(Texture2D'GUI.Stats.Stat_Boost_Icon_Small_Plus_Orange')
  end object
  begin object class=UI_Texture_Info Name=Stat_Boost_Icon_Small_Chevron_Orange_Highlight
    componentTextures.add(Texture2D'GUI.Stats.Stat_Boost_Icon_Small_Chevron_Orange_Highlight')
  end object
  begin object class=UI_Texture_Info Name=Stat_Boost_Icon_Small_Chevron_Orange
    componentTextures.add(Texture2D'GUI.Stats.Stat_Boost_Icon_Small_Chevron_Orange')
  end object
  
  /** ===== UI Components ===== **/
  // Base layer icon #1
  begin object class=UI_Sprite Name=Stat_Boost_Base_1
    tag="Stat_Boost_Base_1"
    posX=0
    posY=0
    images(STAT_BOOST_BLUE_CROSS)=Stat_Boost_Icon_Small_Plus_Blue
    images(STAT_BOOST_GREEN_CROSS)=Stat_Boost_Icon_Small_Plus_Green
    images(STAT_BOOST_ORANGE_CROSS)=Stat_Boost_Icon_Small_Plus_Orange
    images(STAT_BOOST_BLUE_CHEVRON)=Stat_Boost_Icon_Small_Chevron_Blue
    images(STAT_BOOST_GREEN_CHEVRON)=Stat_Boost_Icon_Small_Chevron_Green
    images(STAT_BOOST_ORANGE_CHEVRON)=Stat_Boost_Icon_Small_Chevron_Orange
  end object
  componentList.add(Stat_Boost_Base_1)
  
  // Top layer highlighted icon #1
  begin object class=UI_Sprite Name=Stat_Boost_Highlight_1
    tag="Stat_Boost_Highlight_1"
    posX=0
    posY=0
    images(STAT_BOOST_BLUE_CROSS)=Stat_Boost_Icon_Small_Plus_Blue_Highlight
    images(STAT_BOOST_GREEN_CROSS)=Stat_Boost_Icon_Small_Plus_Green_Highlight
    images(STAT_BOOST_ORANGE_CROSS)=Stat_Boost_Icon_Small_Plus_Orange_Highlight
    images(STAT_BOOST_BLUE_CHEVRON)=Stat_Boost_Icon_Small_Chevron_Blue_Highlight
    images(STAT_BOOST_GREEN_CHEVRON)=Stat_Boost_Icon_Small_Chevron_Green_Highlight
    images(STAT_BOOST_ORANGE_CHEVRON)=Stat_Boost_Icon_Small_Chevron_Orange_Highlight
    activeEffects.add((effectType=EFFECT_ALPHA_CYCLE, lifeTime=-1, elapsedTime=0, intervalTime=0.8, min=31, max=255))
  end object
  componentList.add(Stat_Boost_Highlight_1)
  
  // Base layer icon #2
  begin object class=UI_Sprite Name=Stat_Boost_Base_2
    tag="Stat_Boost_Base_2"
    posX=26
    posY=0
    images(STAT_BOOST_BLUE_CROSS)=Stat_Boost_Icon_Small_Plus_Blue
    images(STAT_BOOST_GREEN_CROSS)=Stat_Boost_Icon_Small_Plus_Green
    images(STAT_BOOST_ORANGE_CROSS)=Stat_Boost_Icon_Small_Plus_Orange
    images(STAT_BOOST_BLUE_CHEVRON)=Stat_Boost_Icon_Small_Chevron_Blue
    images(STAT_BOOST_GREEN_CHEVRON)=Stat_Boost_Icon_Small_Chevron_Green
    images(STAT_BOOST_ORANGE_CHEVRON)=Stat_Boost_Icon_Small_Chevron_Orange
  end object
  componentList.add(Stat_Boost_Base_2)
  
  // Top layer highlighted icon #2
  begin object class=UI_Sprite Name=Stat_Boost_Highlight_2
    tag="Stat_Boost_Highlight_2"
    posX=26
    posY=0
    images(STAT_BOOST_BLUE_CROSS)=Stat_Boost_Icon_Small_Plus_Blue_Highlight
    images(STAT_BOOST_GREEN_CROSS)=Stat_Boost_Icon_Small_Plus_Green_Highlight
    images(STAT_BOOST_ORANGE_CROSS)=Stat_Boost_Icon_Small_Plus_Orange_Highlight
    images(STAT_BOOST_BLUE_CHEVRON)=Stat_Boost_Icon_Small_Chevron_Blue_Highlight
    images(STAT_BOOST_GREEN_CHEVRON)=Stat_Boost_Icon_Small_Chevron_Green_Highlight
    images(STAT_BOOST_ORANGE_CHEVRON)=Stat_Boost_Icon_Small_Chevron_Orange_Highlight
    activeEffects.add((effectType=EFFECT_ALPHA_CYCLE, lifeTime=-1, elapsedTime=0, intervalTime=0.8, min=31, max=255))
  end object
  componentList.add(Stat_Boost_Highlight_2)
  
  // Base layer icon #3
  begin object class=UI_Sprite Name=Stat_Boost_Base_3
    tag="Stat_Boost_Base_3"
    posX=52
    posY=0
    images(STAT_BOOST_BLUE_CROSS)=Stat_Boost_Icon_Small_Plus_Blue
    images(STAT_BOOST_GREEN_CROSS)=Stat_Boost_Icon_Small_Plus_Green
    images(STAT_BOOST_ORANGE_CROSS)=Stat_Boost_Icon_Small_Plus_Orange
    images(STAT_BOOST_BLUE_CHEVRON)=Stat_Boost_Icon_Small_Chevron_Blue
    images(STAT_BOOST_GREEN_CHEVRON)=Stat_Boost_Icon_Small_Chevron_Green
    images(STAT_BOOST_ORANGE_CHEVRON)=Stat_Boost_Icon_Small_Chevron_Orange
  end object
  componentList.add(Stat_Boost_Base_3)
  
  // Top layer highlighted icon #3
  begin object class=UI_Sprite Name=Stat_Boost_Highlight_3
    tag="Stat_Boost_Highlight_3"
    posX=52
    posY=0
    images(STAT_BOOST_BLUE_CROSS)=Stat_Boost_Icon_Small_Plus_Blue_Highlight
    images(STAT_BOOST_GREEN_CROSS)=Stat_Boost_Icon_Small_Plus_Green_Highlight
    images(STAT_BOOST_ORANGE_CROSS)=Stat_Boost_Icon_Small_Plus_Orange_Highlight
    images(STAT_BOOST_BLUE_CHEVRON)=Stat_Boost_Icon_Small_Chevron_Blue_Highlight
    images(STAT_BOOST_GREEN_CHEVRON)=Stat_Boost_Icon_Small_Chevron_Green_Highlight
    images(STAT_BOOST_ORANGE_CHEVRON)=Stat_Boost_Icon_Small_Chevron_Orange_Highlight
    activeEffects.add((effectType=EFFECT_ALPHA_CYCLE, lifeTime=-1, elapsedTime=0, intervalTime=0.8, min=31, max=255))
  end object
  componentList.add(Stat_Boost_Highlight_3)
  
  // Base layer icon #4
  begin object class=UI_Sprite Name=Stat_Boost_Base_4
    tag="Stat_Boost_Base_4"
    posX=78
    posY=0
    images(STAT_BOOST_BLUE_CROSS)=Stat_Boost_Icon_Small_Plus_Blue
    images(STAT_BOOST_GREEN_CROSS)=Stat_Boost_Icon_Small_Plus_Green
    images(STAT_BOOST_ORANGE_CROSS)=Stat_Boost_Icon_Small_Plus_Orange
    images(STAT_BOOST_BLUE_CHEVRON)=Stat_Boost_Icon_Small_Chevron_Blue
    images(STAT_BOOST_GREEN_CHEVRON)=Stat_Boost_Icon_Small_Chevron_Green
    images(STAT_BOOST_ORANGE_CHEVRON)=Stat_Boost_Icon_Small_Chevron_Orange
  end object
  componentList.add(Stat_Boost_Base_4)
  
  // Top layer highlighted icon #4
  begin object class=UI_Sprite Name=Stat_Boost_Highlight_4
    tag="Stat_Boost_Highlight_4"
    posX=78
    posY=0
    images(STAT_BOOST_BLUE_CROSS)=Stat_Boost_Icon_Small_Plus_Blue_Highlight
    images(STAT_BOOST_GREEN_CROSS)=Stat_Boost_Icon_Small_Plus_Green_Highlight
    images(STAT_BOOST_ORANGE_CROSS)=Stat_Boost_Icon_Small_Plus_Orange_Highlight
    images(STAT_BOOST_BLUE_CHEVRON)=Stat_Boost_Icon_Small_Chevron_Blue_Highlight
    images(STAT_BOOST_GREEN_CHEVRON)=Stat_Boost_Icon_Small_Chevron_Green_Highlight
    images(STAT_BOOST_ORANGE_CHEVRON)=Stat_Boost_Icon_Small_Chevron_Orange_Highlight
    activeEffects.add((effectType=EFFECT_ALPHA_CYCLE, lifeTime=-1, elapsedTime=0, intervalTime=0.8, min=31, max=255))
  end object
  componentList.add(Stat_Boost_Highlight_4)
  
  // Base layer icon #5
  begin object class=UI_Sprite Name=Stat_Boost_Base_5
    tag="Stat_Boost_Base_5"
    posX=104
    posY=0
    images(STAT_BOOST_BLUE_CROSS)=Stat_Boost_Icon_Small_Plus_Blue
    images(STAT_BOOST_GREEN_CROSS)=Stat_Boost_Icon_Small_Plus_Green
    images(STAT_BOOST_ORANGE_CROSS)=Stat_Boost_Icon_Small_Plus_Orange
    images(STAT_BOOST_BLUE_CHEVRON)=Stat_Boost_Icon_Small_Chevron_Blue
    images(STAT_BOOST_GREEN_CHEVRON)=Stat_Boost_Icon_Small_Chevron_Green
    images(STAT_BOOST_ORANGE_CHEVRON)=Stat_Boost_Icon_Small_Chevron_Orange
  end object
  componentList.add(Stat_Boost_Base_5)
  
  // Top layer highlighted icon #5
  begin object class=UI_Sprite Name=Stat_Boost_Highlight_5
    tag="Stat_Boost_Highlight_5"
    posX=104
    posY=0
    images(STAT_BOOST_BLUE_CROSS)=Stat_Boost_Icon_Small_Plus_Blue_Highlight
    images(STAT_BOOST_GREEN_CROSS)=Stat_Boost_Icon_Small_Plus_Green_Highlight
    images(STAT_BOOST_ORANGE_CROSS)=Stat_Boost_Icon_Small_Plus_Orange_Highlight
    images(STAT_BOOST_BLUE_CHEVRON)=Stat_Boost_Icon_Small_Chevron_Blue_Highlight
    images(STAT_BOOST_GREEN_CHEVRON)=Stat_Boost_Icon_Small_Chevron_Green_Highlight
    images(STAT_BOOST_ORANGE_CHEVRON)=Stat_Boost_Icon_Small_Chevron_Orange_Highlight
    activeEffects.add((effectType=EFFECT_ALPHA_CYCLE, lifeTime=-1, elapsedTime=0, intervalTime=0.8, min=31, max=255))
  end object
  componentList.add(Stat_Boost_Highlight_5)
  
  // Base layer icon #6
  begin object class=UI_Sprite Name=Stat_Boost_Base_6
    tag="Stat_Boost_Base_6"
    posX=130
    posY=0
    images(STAT_BOOST_BLUE_CROSS)=Stat_Boost_Icon_Small_Plus_Blue
    images(STAT_BOOST_GREEN_CROSS)=Stat_Boost_Icon_Small_Plus_Green
    images(STAT_BOOST_ORANGE_CROSS)=Stat_Boost_Icon_Small_Plus_Orange
    images(STAT_BOOST_BLUE_CHEVRON)=Stat_Boost_Icon_Small_Chevron_Blue
    images(STAT_BOOST_GREEN_CHEVRON)=Stat_Boost_Icon_Small_Chevron_Green
    images(STAT_BOOST_ORANGE_CHEVRON)=Stat_Boost_Icon_Small_Chevron_Orange
  end object
  componentList.add(Stat_Boost_Base_6)
  
  // Top layer highlighted icon #6
  begin object class=UI_Sprite Name=Stat_Boost_Highlight_6
    tag="Stat_Boost_Highlight_6"
    posX=130
    posY=0
    images(STAT_BOOST_BLUE_CROSS)=Stat_Boost_Icon_Small_Plus_Blue_Highlight
    images(STAT_BOOST_GREEN_CROSS)=Stat_Boost_Icon_Small_Plus_Green_Highlight
    images(STAT_BOOST_ORANGE_CROSS)=Stat_Boost_Icon_Small_Plus_Orange_Highlight
    images(STAT_BOOST_BLUE_CHEVRON)=Stat_Boost_Icon_Small_Chevron_Blue_Highlight
    images(STAT_BOOST_GREEN_CHEVRON)=Stat_Boost_Icon_Small_Chevron_Green_Highlight
    images(STAT_BOOST_ORANGE_CHEVRON)=Stat_Boost_Icon_Small_Chevron_Orange_Highlight
    activeEffects.add((effectType=EFFECT_ALPHA_CYCLE, lifeTime=-1, elapsedTime=0, intervalTime=0.8, min=31, max=255))
  end object
  componentList.add(Stat_Boost_Highlight_6)
  
}
















