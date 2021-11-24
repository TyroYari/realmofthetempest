/*=============================================================================
 * ROTT_UI_Page_Enchantments
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This class handles the UI and controls for viewing enchanted
 * enchantments, which are obtained from the Alchemist's minigame.
 *===========================================================================*/
 
class ROTT_UI_Page_Enchantments extends ROTT_UI_Page;

// Rainbow special effect controls
`define RAINBOW_EFFECT(time) activeEffects.add((effectType = EFFECT_HUE_SHIFT, lifeTime = -1, elapsedTime = `time, intervalTime = 1.25, min = 140, max = 220))

// Alpha special effect controls
`define ALPHA_EFFECT_BOTTOM() activeEffects.add((effectType = EFFECT_ALPHA_CYCLE, lifeTime = -1, elapsedTime = 0, intervalTime = 0.8, min = 31, max = 255))
`define ALPHA_EFFECT_TOP() activeEffects.add((effectType = EFFECT_ALPHA_CYCLE, lifeTime = -1, elapsedTime = 0, intervalTime = 0.8, min = 191, max = 255))

// Internal references
var private UI_Selector_2D enchantmentSelector;
var private UI_Label descriptorLabels[4];

// Timers
var private ROTT_Timer enchantmentAnimationTimer; // Used to animate enchantments

/*============================================================================= 
 * Initialize Component
 *
 * Description: This event is called as the UI is loaded.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  super.initializeComponent(newTag);
  
  // Hook up some internal references
  enchantmentSelector = UI_Selector_2D(findComp("Enchantment_Selection_Box"));
  
  descriptorLabels[0] = findLabel("Enchantment_Title");
  descriptorLabels[1] = findLabel("Enchantment_Description1");
  descriptorLabels[2] = findLabel("Enchantment_Description2");
  descriptorLabels[3] = findLabel("Enchantment_Description3");
  
}

/*=============================================================================
 * onFocusMenu()
 *
 * Called when a menu is given focus.  Assign controls, and enable graphics.
 *===========================================================================*/
event onFocusMenu() {
  UI_Selector(findComp("Input_Listener")).setActive(true);
}

/*============================================================================= 
 * onPushPageEvent()
 *
 * This event is called every time the page is pushed.
 *===========================================================================*/
event onPushPageEvent() {
  enchantmentSelector.resetSelection();
  renderEnchantmentInfo();
  enableEnchantmentHighlights();
}

/*============================================================================= 
 * refresh()
 *
 * This function should ensure that any data thats been changed will be 
 * correctly updated on the UI.
 *===========================================================================*/
public function refresh() {
  renderEnchantmentInfo();
}

/*============================================================================*
 * Button controls
 *===========================================================================*/
protected function navigationRoutineB() {
  parentScene.popPage();
  gameInfo.sfxBox.playSfx(SFX_MENU_BACK);
}

/*============================================================================*
 * D-Pad controls
 *===========================================================================*/
public function onNavigateDown() {
  enchantmentSelector.moveDown();
  renderEnchantmentInfo();
}

public function onNavigateUp() {
  enchantmentSelector.moveUp();
  renderEnchantmentInfo();
}

public function onNavigateLeft() {
  enchantmentSelector.moveLeft();
  renderEnchantmentInfo();
}

public function onNavigateRight() {
  enchantmentSelector.moveRight();
  renderEnchantmentInfo();
}

/*============================================================================*
 * renderEnchantmentInfo
 * 
 * This draws enchantment info to the screen
 *===========================================================================*/
private function renderEnchantmentInfo() {
  local int enchantmentIndex;
  local int enchantmentStat;
  local EnchantmentDescriptor descriptor;
  local string buffer;
  
  // Get enchantment descriptor
  enchantmentIndex = enchantmentSelector.getSelection();
  enchantmentIndex = convertEnchantmentIndex(enchantmentIndex);
  descriptor = class'ROTT_Descriptor_Enchantment_List'.static.getEnchantment(enchantmentIndex);
  
  enchantmentStat = gameInfo.playerProfile.getEnchantBoost(EnchantmentEnum(enchantmentIndex));
  
  // buffer stat information
  if (gameInfo.playerProfile.getEnchantBoost(enchantmentIndex) == 0) {
    buffer = "";
  } else {
    buffer = descriptor.displayText[ENCHANTMENT_STATS];
    buffer = Repl(buffer, "%x", enchantmentStat);
  }
  
  // Write info to screen
  descriptorLabels[ENCHANTMENT_NAME].setText(descriptor.displayText[ENCHANTMENT_NAME]);
  descriptorLabels[ENCHANTMENT_INFO_1].setText(descriptor.displayText[ENCHANTMENT_INFO_1]);
  descriptorLabels[ENCHANTMENT_INFO_2].setText(descriptor.displayText[ENCHANTMENT_INFO_2]);
  descriptorLabels[ENCHANTMENT_STATS].setText(buffer);
  
}

/*============================================================================*
 * enableEnchantmentHighlights()
 * 
 * This enables enchantment highlights for unlocked enchantments
 *===========================================================================*/
private function enableEnchantmentHighlights() {
  local UI_Sprite comp;
  local int level;
  local int i;
  
  for (i = 0; i < class'ROTT_Descriptor_Enchantment_List'.static.countEnchantmentEnum(); i++) {
    level = gameInfo.playerProfile.getEnchantBoost(i);
    comp = findSprite("Enchantment_Highlight_" $ i+1);
    comp.setEnabled(level != 0);
    comp = findSprite("Enchantment_Highlight_" $ i+1 $ "_White");
    comp.setEnabled(level != 0);
  }
}

/*============================================================================*
 * convertEnchantmentIndex
 * 
 * This function maps selection indices to enchantment enumeration indices
 *===========================================================================*/
private function int convertEnchantmentIndex(int index) {
  switch (index) {
    case 12:
      return OMNI_SEEKER;
    case 0:
    case 6:
      return SERPENTS_ANCHOR;
    case 13:
      return GRIFFINS_TRINKET;
    case 14:
      return GHOSTKINGS_BRANCH;
    case 1:
    case 7:
      return OATH_PENDANT;
    case 8:
      return ETERNAL_SPELLSTONE;
    case 2:
      return MYSTIC_MARBLE;
    case 3:
      return ARCANE_BLOODPRISM;
    case 9:
      return ROSEWOOD_PENDANT;
    case 4:
    case 10:
      return INFINITY_JEWEL;
    case 15:
      return EMPERORS_TALISMAN;
    case 16:
      return SCORPION_TALON;
    case 5:
    case 11:
      return SOLAR_CHARM;
    case 17:
      return DREAMFIRE_RELIC;
      
  }
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  /** ===== Input ===== **/
  begin object class=ROTT_Input_Handler Name=Input_B
    inputName="XBoxTypeS_B"
    buttonComponent=none
  end object
  inputList.add(Input_B)
  
  /** Texture Components **/
  // Background
  begin object class=UI_Texture_Info Name=Texture_Enchantment_Map
    componentTextures.add(Texture2D'GUI.Enchantments.Enchantment_Page_Background')
  end object
  
  // Enchantment Highlighters
  begin object class=UI_Texture_Info Name=Texture_Enchantment_Highlight_White
    componentTextures.add(Texture2D'GUI.Relic_Highlight_White')
  end object
  begin object class=UI_Texture_Info Name=Texture_Enchantment_Highlight_1
    componentTextures.add(Texture2D'GUI.Relic_Highlight_Green')
  end object
  begin object class=UI_Texture_Info Name=Texture_Enchantment_Highlight_2
    componentTextures.add(Texture2D'GUI.Relic_Highlight_Green')
  end object
  begin object class=UI_Texture_Info Name=Texture_Enchantment_Highlight_3
    componentTextures.add(Texture2D'GUI.Relic_Highlight_Green')
  end object
  begin object class=UI_Texture_Info Name=Texture_Enchantment_Highlight_4
    componentTextures.add(Texture2D'GUI.Relic_Highlight_Green')
  end object
  begin object class=UI_Texture_Info Name=Texture_Enchantment_Highlight_5
    componentTextures.add(Texture2D'GUI.Relic_Highlight_Green')
  end object
  begin object class=UI_Texture_Info Name=Texture_Enchantment_Highlight_6
    componentTextures.add(Texture2D'GUI.Relic_Highlight_Green')
  end object
  begin object class=UI_Texture_Info Name=Texture_Enchantment_Highlight_7
    componentTextures.add(Texture2D'GUI.Relic_Highlight_Green')
  end object
  begin object class=UI_Texture_Info Name=Texture_Enchantment_Highlight_8
    componentTextures.add(Texture2D'GUI.Relic_Highlight_Green')
  end object
  begin object class=UI_Texture_Info Name=Texture_Enchantment_Highlight_9
    componentTextures.add(Texture2D'GUI.Relic_Highlight_Green')
  end object
  begin object class=UI_Texture_Info Name=Texture_Enchantment_Highlight_10
    componentTextures.add(Texture2D'GUI.Relic_Highlight_Green')
  end object
  begin object class=UI_Texture_Info Name=Texture_Enchantment_Highlight_11
    componentTextures.add(Texture2D'GUI.Relic_Highlight_Green')
  end object
  begin object class=UI_Texture_Info Name=Texture_Enchantment_Highlight_12
    componentTextures.add(Texture2D'GUI.Relic_Highlight_Green')
  end object
  begin object class=UI_Texture_Info Name=Texture_Enchantment_Highlight_13
    componentTextures.add(Texture2D'GUI.Relic_Highlight_Green')
  end object
  begin object class=UI_Texture_Info Name=Texture_Enchantment_Highlight_14
    componentTextures.add(Texture2D'GUI.Relic_Highlight_Green')
  end object
  
  // Selection Box
  begin object class=UI_Texture_Info Name=Craft_Selection_Box
    componentTextures.add(Texture2D'GUI.Skill_Selection_Box')
  end object
  
  /** Visual Page Setup **/
  tag="Enchantment_Page"
  posX=0
  posY=0
  posXEnd=NATIVE_WIDTH
  posYEnd=NATIVE_HEIGHT
  
  begin object class=UI_Sprite Name=Enchantment_Map_Background
    tag="Enchantment_Map_Background"
    posX=0
    posY=0
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    images(0)=Texture_Enchantment_Map
  end object
  componentList.add(Enchantment_Map_Background)
  
  /** Highlights **/
  // OMNI_SEEKER
  begin object class=UI_Sprite Name=Enchantment_Highlight_1
    tag="Enchantment_Highlight_1"
    posX=85
    posY=447
    images(0)=Texture_Enchantment_Highlight_1
    
    // Alpha Effects
    `ALPHA_EFFECT_BOTTOM()
    
    // Rainbow Effects
    `RAINBOW_EFFECT(0.1375)
    
  end object
  componentList.add(Enchantment_Highlight_1)
  begin object class=UI_Sprite Name=Enchantment_Highlight_1_White
    tag="Enchantment_Highlight_1_White"
    posX=85
    posY=447
    images(0)=Texture_Enchantment_Highlight_White
    
    // Alpha Effects
    `ALPHA_EFFECT_TOP()
    
  end object
  componentList.add(Enchantment_Highlight_1_White)
  
  // SERPENTS_ANCHOR
  begin object class=UI_Sprite Name=Enchantment_Highlight_2
    tag="Enchantment_Highlight_2"
    posX=85
    posY=15
    images(0)=Texture_Enchantment_Highlight_2
    
    // Alpha Effects
    `ALPHA_EFFECT_BOTTOM()
    
    // Rainbow Effects
    `RAINBOW_EFFECT(0.1275)
    
  end object
  componentList.add(Enchantment_Highlight_2)
  begin object class=UI_Sprite Name=Enchantment_Highlight_2_White
    tag="Enchantment_Highlight_2_White"
    posX=85
    posY=15
    images(0)=Texture_Enchantment_Highlight_White
    
    // Alpha Effects
    `ALPHA_EFFECT_TOP()
    
  end object
  componentList.add(Enchantment_Highlight_2_White)
  
  // GRIFFINS_TRINKET
  begin object class=UI_Sprite Name=Enchantment_Highlight_3
    tag="Enchantment_Highlight_3"
    posX=301
    posY=339
    images(0)=Texture_Enchantment_Highlight_3
    
    // Alpha Effects
    `ALPHA_EFFECT_BOTTOM()
    
    // Rainbow Effects
    `RAINBOW_EFFECT(0.26)
    
  end object
  componentList.add(Enchantment_Highlight_3)
  begin object class=UI_Sprite Name=Enchantment_Highlight_3_White
    tag="Enchantment_Highlight_3_White"
    posX=301
    posY=339
    images(0)=Texture_Enchantment_Highlight_White
    
    // Alpha Effects
    `ALPHA_EFFECT_TOP()
    
  end object
  componentList.add(Enchantment_Highlight_3_White)
  
  // GHOSTKINGS_BRANCH
  begin object class=UI_Sprite Name=Enchantment_Highlight_4
    tag="Enchantment_Highlight_4"
    posX=518
    posY=447
    images(0)=Texture_Enchantment_Highlight_4
    
    // Alpha Effects
    `ALPHA_EFFECT_BOTTOM()
    
    // Rainbow Effects
    `RAINBOW_EFFECT(0.3875)
    
  end object
  componentList.add(Enchantment_Highlight_4)
  begin object class=UI_Sprite Name=Enchantment_Highlight_4_White
    tag="Enchantment_Highlight_4_White"
    posX=518
    posY=447
    images(0)=Texture_Enchantment_Highlight_White
    
    // Alpha Effects
    `ALPHA_EFFECT_TOP()
    
  end object
  componentList.add(Enchantment_Highlight_4_White)
  
  // OATH_PENDANT
  begin object class=UI_Sprite Name=Enchantment_Highlight_5
    tag="Enchantment_Highlight_5"
    posX=301
    posY=123
    images(0)=Texture_Enchantment_Highlight_5
    
    // Alpha Effects
    `ALPHA_EFFECT_BOTTOM()
    
    // Rainbow Effects
    `RAINBOW_EFFECT(0.255)
    
  end object
  componentList.add(Enchantment_Highlight_5)
  begin object class=UI_Sprite Name=Enchantment_Highlight_5_White
    tag="Enchantment_Highlight_5_White"
    posX=301
    posY=123
    images(0)=Texture_Enchantment_Highlight_White
    
    // Alpha Effects
    `ALPHA_EFFECT_TOP()
    
  end object
  componentList.add(Enchantment_Highlight_5_White)
  
  // ETERNAL_SPELLSTONE
  begin object class=UI_Sprite Name=Enchantment_Highlight_6
    tag="Enchantment_Highlight_6"
    posX=518
    posY=231
    images(0)=Texture_Enchantment_Highlight_6
    
    // Alpha Effects
    `ALPHA_EFFECT_BOTTOM()
    
    // Rainbow Effects
    `RAINBOW_EFFECT(0.3825)
    
  end object
  componentList.add(Enchantment_Highlight_6)
  begin object class=UI_Sprite Name=Enchantment_Highlight_6_White
    tag="Enchantment_Highlight_6_White"
    posX=518
    posY=231
    images(0)=Texture_Enchantment_Highlight_White
    
    // Alpha Effects
    `ALPHA_EFFECT_TOP()
    
  end object
  componentList.add(Enchantment_Highlight_6_White)
  
  // MYSTIC_MARBLE
  begin object class=UI_Sprite Name=Enchantment_Highlight_7
    tag="Enchantment_Highlight_7"
    posX=518
    posY=15
    images(0)=Texture_Enchantment_Highlight_7
    
    // Alpha Effects
    `ALPHA_EFFECT_BOTTOM()
    
    // Rainbow Effects
    `RAINBOW_EFFECT(0.3775)
    
  end object
  componentList.add(Enchantment_Highlight_7)
  begin object class=UI_Sprite Name=Enchantment_Highlight_7_White
    tag="Enchantment_Highlight_7_White"
    posX=518
    posY=15
    images(0)=Texture_Enchantment_Highlight_White
    
    // Alpha Effects
    `ALPHA_EFFECT_TOP()
    
  end object
  componentList.add(Enchantment_Highlight_7_White)
  
  // ARCANE_BLOODPRISM
  begin object class=UI_Sprite Name=Enchantment_Highlight_8
    tag="Enchantment_Highlight_8"
    posX=734
    posY=15
    images(0)=Texture_Enchantment_Highlight_8
    
    // Alpha Effects
    `ALPHA_EFFECT_BOTTOM()
    
    // Rainbow Effects
    `RAINBOW_EFFECT(0.5025)
    
  end object
  componentList.add(Enchantment_Highlight_8)
  begin object class=UI_Sprite Name=Enchantment_Highlight_8_White
    tag="Enchantment_Highlight_8_White"
    posX=734
    posY=15
    images(0)=Texture_Enchantment_Highlight_White
    
    // Alpha Effects
    `ALPHA_EFFECT_TOP()
    
  end object
  componentList.add(Enchantment_Highlight_8_White)
  
  // ROSEWOOD_PENDANT
  begin object class=UI_Sprite Name=Enchantment_Highlight_9
    tag="Enchantment_Highlight_9"
    posX=734
    posY=231
    images(0)=Texture_Enchantment_Highlight_9
    
    // Alpha Effects
    `ALPHA_EFFECT_BOTTOM()
    
    // Rainbow Effects
    `RAINBOW_EFFECT(0.5075)
    
  end object
  componentList.add(Enchantment_Highlight_9)
  begin object class=UI_Sprite Name=Enchantment_Highlight_9_White
    tag="Enchantment_Highlight_9_White"
    posX=734
    posY=231
    images(0)=Texture_Enchantment_Highlight_White
    
    // Alpha Effects
    `ALPHA_EFFECT_TOP()
    
  end object
  componentList.add(Enchantment_Highlight_9_White)
  
  // INFINITY_JEWEL
  begin object class=UI_Sprite Name=Enchantment_Highlight_10
    tag="Enchantment_Highlight_10"
    posX=950
    posY=123
    images(0)=Texture_Enchantment_Highlight_10
    
    // Alpha Effects
    `ALPHA_EFFECT_BOTTOM()
    
    // Rainbow Effects
    `RAINBOW_EFFECT(0.63)
    
  end object
  componentList.add(Enchantment_Highlight_10)
  begin object class=UI_Sprite Name=Enchantment_Highlight_10_White
    tag="Enchantment_Highlight_10_White"
    posX=950
    posY=123
    images(0)=Texture_Enchantment_Highlight_White
    
    // Alpha Effects
    `ALPHA_EFFECT_TOP()
    
  end object
  componentList.add(Enchantment_Highlight_10_White)
  
  // EMPERORS_TALISMAN
  begin object class=UI_Sprite Name=Enchantment_Highlight_11
    tag="Enchantment_Highlight_11"
    posX=734
    posY=447
    images(0)=Texture_Enchantment_Highlight_11
    
    // Alpha Effects
    `ALPHA_EFFECT_BOTTOM()
    
    // Rainbow Effects
    `RAINBOW_EFFECT(0.5125)
    
  end object
  componentList.add(Enchantment_Highlight_11)
  begin object class=UI_Sprite Name=Enchantment_Highlight_11_White
    tag="Enchantment_Highlight_11_White"
    posX=734
    posY=447
    images(0)=Texture_Enchantment_Highlight_White
    
    // Alpha Effects
    `ALPHA_EFFECT_TOP()
    
  end object
  componentList.add(Enchantment_Highlight_11_White)
  
  // SCORPION_TALON
  begin object class=UI_Sprite Name=Enchantment_Highlight_12
    tag="Enchantment_Highlight_12"
    posX=950
    posY=339
    images(0)=Texture_Enchantment_Highlight_12
    
    // Alpha Effects
    `ALPHA_EFFECT_BOTTOM()
    
    // Rainbow Effects
    `RAINBOW_EFFECT(0.635)
    
  end object
  componentList.add(Enchantment_Highlight_12)
  begin object class=UI_Sprite Name=Enchantment_Highlight_12_White
    tag="Enchantment_Highlight_12_White"
    posX=950
    posY=339
    images(0)=Texture_Enchantment_Highlight_White
    
    // Alpha Effects
    `ALPHA_EFFECT_TOP()
    
  end object
  componentList.add(Enchantment_Highlight_12_White)
  
  // SOLAR_CHARM
  begin object class=UI_Sprite Name=Enchantment_Highlight_13
    tag="Enchantment_Highlight_13"
    posX=1166
    posY=15
    images(0)=Texture_Enchantment_Highlight_13
    
    // Alpha Effects
    `ALPHA_EFFECT_BOTTOM()
    
    // Rainbow Effects
    `RAINBOW_EFFECT(0.7525)
    
  end object
  componentList.add(Enchantment_Highlight_13)
  begin object class=UI_Sprite Name=Enchantment_Highlight_13_White
    tag="Enchantment_Highlight_13_White"
    posX=1166
    posY=15
    images(0)=Texture_Enchantment_Highlight_White
    
    // Alpha Effects
    `ALPHA_EFFECT_TOP()
    
  end object
  componentList.add(Enchantment_Highlight_13_White)
  
  // DREAMFIRE_RELIC
  begin object class=UI_Sprite Name=Enchantment_Highlight_14
    tag="Enchantment_Highlight_14"
    posX=1166
    posY=447
    images(0)=Texture_Enchantment_Highlight_14
    
    // Alpha Effects
    `ALPHA_EFFECT_BOTTOM()
    
    // Rainbow Effects
    `RAINBOW_EFFECT(0.7625)
    
  end object
  componentList.add(Enchantment_Highlight_14)
  begin object class=UI_Sprite Name=Enchantment_Highlight_14_White
    tag="Enchantment_Highlight_14_White"
    posX=1166
    posY=447
    images(0)=Texture_Enchantment_Highlight_White
    
    // Alpha Effects
    `ALPHA_EFFECT_TOP()
    
  end object
  componentList.add(Enchantment_Highlight_14_White)
  
  // Enchantment Selector
  begin object class=UI_Selector Name=Input_Listener
    tag="Input_Listener"
    navigationType=SELECTION_2D
    bEnabled=true
    bActive=true
  end object
  componentList.add(Input_Listener)
  
  begin object class=UI_Selector_2D Name=Enchantment_Selection_Box
    tag="Enchantment_Selection_Box"
    bEnabled=true
    posX=118
    posY=47
    selectOffset=(x=216,y=216)  // Distance from neighboring spaces
    selectionCoords=(x=0,y=0)   // The space which this selector occupies
    gridSize=(x=6,y=3)          // Total size of 2d selection space
    
    // Visual offsets
    renderOffsets(0)=(xCoord=1,yCoord=0,xOffset=0,yOffset=108)
    renderOffsets(1)=(xCoord=4,yCoord=0,xOffset=0,yOffset=108)
    renderOffsets(2)=(xCoord=1,yCoord=1,xOffset=0,yOffset=-108)
    renderOffsets(3)=(xCoord=4,yCoord=1,xOffset=0,yOffset=-108)
    renderOffsets(4)=(xCoord=0,yCoord=1,xOffset=0,yOffset=-216)
    renderOffsets(5)=(xCoord=5,yCoord=1,xOffset=0,yOffset=-216)
    renderOffsets(6)=(xCoord=1,yCoord=2,xOffset=0,yOffset=-108)
    renderOffsets(7)=(xCoord=4,yCoord=2,xOffset=0,yOffset=-108)
    
    // Navigation skips
    navSkips(0)=(xCoord=0,yCoord=0,skipDirection=NAV_DOWN)
    navSkips(1)=(xCoord=1,yCoord=0,skipDirection=NAV_DOWN)
    navSkips(2)=(xCoord=0,yCoord=2,skipDirection=NAV_UP)
    navSkips(3)=(xCoord=1,yCoord=2,skipDirection=NAV_UP)
    navSkips(4)=(xCoord=5,yCoord=0,skipDirection=NAV_DOWN)
    navSkips(5)=(xCoord=4,yCoord=0,skipDirection=NAV_DOWN)
    navSkips(6)=(xCoord=5,yCoord=2,skipDirection=NAV_UP)
    navSkips(7)=(xCoord=4,yCoord=2,skipDirection=NAV_UP)
    
    images(0)=Craft_Selection_Box
    
    // Alpha Effects
    activeEffects.add((effectType = EFFECT_ALPHA_CYCLE, lifeTime = -1, elapsedTime = 0, intervalTime = 0.4, min = 170, max = 255))
    
    // Hover coordinates
    hoverCoords(0)=(xStart=135,yStart=64,xEnd=224,yEnd=152)
    hoverCoords(1)=(xStart=351,yStart=172,xEnd=440,yEnd=260)
    hoverCoords(2)=(xStart=568,yStart=64,xEnd=656,yEnd=152)
    hoverCoords(3)=(xStart=784,yStart=64,xEnd=872,yEnd=152)
    hoverCoords(4)=(xStart=1000,yStart=172,xEnd=1088,yEnd=260)
    hoverCoords(5)=(xStart=1216,yStart=64,xEnd=1304,yEnd=152)
    
    hoverCoords(8)=(xStart=568,yStart=280,xEnd=656,yEnd=368)
    hoverCoords(9)=(xStart=784,yStart=280,xEnd=872,yEnd=368)
    
    hoverCoords(12)=(xStart=135,yStart=496,xEnd=224,yEnd=584)
    hoverCoords(13)=(xStart=351,yStart=388,xEnd=440,yEnd=475)
    hoverCoords(14)=(xStart=568,yStart=496,xEnd=656,yEnd=584)
    hoverCoords(15)=(xStart=784,yStart=496,xEnd=872,yEnd=584)
    hoverCoords(16)=(xStart=1000,yStart=388,xEnd=1088,yEnd=475)
    hoverCoords(17)=(xStart=1216,yStart=496,xEnd=1304,yEnd=584)
    
  end object
  componentList.add(Enchantment_Selection_Box)
  
  // Enchantment Title
  begin object class=UI_Label Name=Enchantment_Title
    tag="Enchantment_Title"
    posX=0
    posY=658
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    AlignX=CENTER
    AlignY=TOP
    fontStyle=DEFAULT_LARGE_TAN
    labelText="Enchantment Title"
  end object
  componentList.add(Enchantment_Title)
  
  // Enchantment description (line 1)
  begin object class=UI_Label Name=Enchantment_Description1
    tag="Enchantment_Description1"
    posX=0
    posY=702
    posXEnd=NATIVE_WIDTH
    posYEnd=540
    AlignX=CENTER
    AlignY=TOP
    fontStyle=DEFAULT_SMALL_WHITE
    labelText="Enchantment description (line 1)"
  end object
  componentList.add(Enchantment_Description1)
  
  // Enchantment description (line 2)
  begin object class=UI_Label Name=Enchantment_Description2
    tag="Enchantment_Description2"
    posX=0
    posY=729
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    AlignX=CENTER
    AlignY=TOP
    fontStyle=DEFAULT_SMALL_WHITE
    labelText="Enchantment description (line 2)"
  end object
  componentList.add(Enchantment_Description2)
    
  // Enchantment description (line 3)
  begin object class=UI_Label Name=Enchantment_Description3
    tag="Enchantment_Description3"
    posX=0
    posY=786
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    AlignX=CENTER
    AlignY=TOP
    fontStyle=DEFAULT_SMALL_GREEN
    labelText="Enchantment description (line 3)"
  end object
  componentList.add(Enchantment_Description3)
}





/** ============================ Design notes ============================ **/

  // Enchantments:    darkhand
  //
  //  charm, trinket, pendant, amulet, stone, talisman, relic
  //
  //  Oak, rose, skull, heart, Chaos Aura
  //  Gold, Glass, Air, Wind, Eye, arctic
  //  Talon, Dream, Bamboo, barbed, dragon
  //  cutthroat, tooth, chain, dagger, emperor
  //  branch, Electric, earth, eagle, fang
  //  feather, flame, tail, Ghost, Giant, Goblin
  //  Glowlight, grave, Half Moon, Hammer, Jaw
  //  Hand, Fist, Hawk, Horn, Tusk, Ice, Misty 
  //  King's, Queen's, Jewel, Labyrinth, White,
  //  Lizard, Lion, Leopard, Lantern, Leaf,
  //  Bear, Marble, MoonEye, star, vine, viper, saber
  //  scorpion
  //
  //  Ghost Needle
  //  Dream Lantern
  //  Goblins Prism 
  //  
  //  HP+ , 
  //  MP+ , 
  //  HP+ / time, King's Oak 
  //  MP+ / time, 
  //  
  //  Phys+, 
  //  Speed+, 
  //  All Stats+, 
  //  Class Skills+, 
  //  
  //  Glyph Skills+, 
  //  Dmg Aura+, 
  //  EXP Boost+, 
  //  Armor
  //  
  //  Slow Enemies, 
  //  Loot %+, 
  
  









