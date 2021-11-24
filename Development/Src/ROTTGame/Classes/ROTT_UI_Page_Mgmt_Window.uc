/*=============================================================================
 * ROTT_UI_Page_Mgmt_Window
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This management window allows player to allocate unspent stat 
 * points 
 *===========================================================================*/
 
class ROTT_UI_Page_Mgmt_Window extends ROTT_UI_Page;

// Number of lines of text in this window
const LINE_COUNT = 13;

// Parent scene information
var protected ROTT_UI_Scene_Game_Menu someScene;

// Navigation vars
var protected int selectOptionsCount;

// Internal references
var protected UI_Texture_Storage backgroundContainer;
var protected UI_Selector selectionBox;

var private UI_Label descriptionLabels[LINE_COUNT];

/*============================================================================= 
 * initializeComponent()
 *
 * Called once, when the scene is first initialized.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  local int i;
  
  super.initializeComponent(newTag);
  
  // Parent scene
  someScene = ROTT_UI_Scene_Game_Menu(outer);
  
  // Internal references
  backgroundContainer = UI_Texture_Storage(findComp("Background_Container"));
  selectionBox = UI_Selector(findComp("Mgmt_Window_Selection_Box"));
  
  for (i = 0; i < LINE_COUNT; i++) {
    descriptionLabels[i] = findLabel("Mgmt_Window_Label_" $ i);
  }
  
  // Navigation settings
  selectionBox.setNumberOfMenuOptions(selectOptionsCount);  
  
}

/*============================================================================= 
 * onPushPageEvent()
 *
 * This event is called every time the page is pushed.
 *===========================================================================*/
event onPushPageEvent() {
  
}

/*============================================================================= 
 * onPopPageEvent()
 *
 * This event is called when the page is removed
 *===========================================================================*/
event onPopPageEvent() {
  // Graphic update
  selectionBox.clearSelection();
}

/*=============================================================================
 * onFocusMenu()
 *
 * Called when a menu is given focus.  Assign controls, and enable graphics.
 *===========================================================================*/
event onFocusMenu() {
  // Check if control components exist, if not stop here
  if (selectOptionsCount == 0) return;
  
  // Graphic update
  selectionBox.setEnabled(true);
  selectionBox.setActive(true);
}

/*=============================================================================
 * onUnfocusMenu()
 *
 * Called when the menu loses focus, but is not popped from the page stack.
 * Disable controls and update graphics accordingly.
 *===========================================================================*/
event onUnfocusMenu() {
  // Check if control components exist, if not stop here
  if (selectOptionsCount == 0) return;
  
  // Graphic update
  selectionBox.clearSelection();
}

/*============================================================================= 
 * closeParagraphGaps()
 *
 * Used to remove the gaps between paragraphs
 *===========================================================================*/
public function closeParagraphGaps() {
  local int i;
  
  for (i = 5; i < LINE_COUNT; i++) {
    descriptionLabels[i].shiftY(-27);
  }
  for (i = 9; i < LINE_COUNT; i++) {
    descriptionLabels[i].shiftY(-18);
  }
}

/*============================================================================= 
 * clearDescriptor()
 *
 * Erases display info
 *===========================================================================*/
public function clearDescriptor() {
  local int i;
  
  // Iterate through lines
  for (i = 0; i < LINE_COUNT; i++) {
    descriptionLabels[i].setText("");
  }
}

/*============================================================================= 
 * setDescriptor()
 *
 * This parses a descriptor to update the text displayed in this window
 *===========================================================================*/
public function setDescriptor(ROTT_Descriptor descriptor) {
  local int i;
  if (descriptor == none) {
    yellowLog("Warning (!) A descriptor still needs to be implemented.");
    return;
  }
  
  // Copy display information to the label components from the descriptor
  for (i = 0; i < LINE_COUNT; i++) {
    descriptionLabels[i].setText(descriptor.displayInfo[i].labelText);
    descriptionLabels[i].setFont(descriptor.displayInfo[i].labelFont);
  }
}

/*=============================================================================
 * D-Pad controls
 *===========================================================================*/
public function onNavigateUp();
public function onNavigateDown();
public function onNavigateLeft();
public function onNavigateRight();

/*=============================================================================
 * Button controls
 *===========================================================================*/
protected function navigationRoutineA() {
  /** Delegate in subclasses **/
}

protected function navigationRoutineB() {
  // Pass focus down to previous page in the stack
  parentScene.focusBack();
  
  // Sfx
  gameInfo.sfxBox.playSfx(SFX_MENU_BACK);
}

/*=============================================================================
 * investSkillPoint()
 *
 * Called through the UI when attempting to invest a skill point
 *===========================================================================*/
protected function investSkillPoint
(
  ROTT_Combat_Hero hero,
  byte tree,
  byte selection
)
{
  switch (hero.investSkill(tree, selection)) {
    case 0:
      // Success
      parentScene.refresh();
      sfxBox.playSFX(SFX_MENU_INVEST_SKILL);
      break;
    case -1:
      // Insufficient skill points
      sfxBox.playSFX(SFX_MENU_INSUFFICIENT);
      break;
    case -2:
      // Insufficient mana
      makeLabel("Insufficient mana"); 
      sfxBox.playSFX(SFX_MENU_INSUFFICIENT);
      break;
    case -3:
      // Insufficient stat requirements
      sfxBox.playSFX(SFX_MENU_INSUFFICIENT);
      break;
  }
}

/*=============================================================================
 * setPrimarySkill()
 *
 * Called through the UI when attempting to set a new primary skill
 *===========================================================================*/
protected function setPrimarySkill
(
  ROTT_Combat_Hero hero,
  byte selection
)
{
  // Attempt to set primary
  if (hero.setPrimary(sceneManager.getSelectedSkill())) {
    // Sfx success
    sfxBox.playSFX(SFX_MENU_ACCEPT);
    parentScene.refresh();
  } else {
    // Sfx failure
    sfxBox.playSFX(SFX_MENU_INSUFFICIENT);
  }
  
}

/*=============================================================================
 * setSecondarySkill()
 *
 * Called through the UI when attempting to set a new secondary skill
 *===========================================================================*/
protected function setSecondarySkill
(
  ROTT_Combat_Hero hero,
  byte selection
)
{
  // Attempt to set primary
  if (hero.setSecondary(sceneManager.getSelectedSkill())) {
    // Sfx success
    sfxBox.playSFX(SFX_MENU_ACCEPT);
    parentScene.refresh();
  } else {
    // Sfx failure
    sfxBox.playSFX(SFX_MENU_INSUFFICIENT);
  }
  
}

/*=============================================================================
 * Assets
 *===========================================================================*/
defaultProperties
{
  // Culling
  cullTags.add("Game_Menu_Selector")
  
  /** ===== Input ===== **/
  begin object class=ROTT_Input_Handler Name=Input_B  
    inputName="XBoxTypeS_B"
    buttonComponent=none
  end object
  inputList.add(Input_B)
  
  /** ===== Textures ===== **/
  // Window background
  begin object class=UI_Texture_Info Name=Mgmt_Window_Default
    componentTextures.add(Texture2D'GUI.Mgmt_Window_Default')
  end object
  begin object class=UI_Texture_Info Name=Mgmt_Window_Shadowless
    componentTextures.add(Texture2D'GUI.Party_Mgmt_Window')
  end object
  
  /** ===== UI Components ===== **/
  // Window mgmt background
  begin object class=UI_Sprite Name=Mgmt_Window_Background
    tag="Mgmt_Window_Background"
    posX=0
    posY=0
    images(0)=Mgmt_Window_Default
    images(1)=Mgmt_Window_Shadowless
  end object
  componentList.add(Mgmt_Window_Background)
  
  // Mgmt Window - Title Label
  begin object class=UI_Label Name=Mgmt_Window_Label_0
    tag="Mgmt_Window_Label_0"
    posX=0
    posY=112
    posXEnd=720
    posYEnd=NATIVE_HEIGHT
    AlignX=CENTER
    AlignY=TOP
    labelText=""
  end object
  componentList.add(Mgmt_Window_Label_0)
  
  // Mgmt Window - Description Labels
  begin object class=UI_Label Name=Mgmt_Window_Label_1
    tag="Mgmt_Window_Label_1"
    posX=0
    posY=151
    posXEnd=720
    posYEnd=NATIVE_HEIGHT
    AlignX=CENTER
    AlignY=TOP
    labelText=""
  end object
  componentList.add(Mgmt_Window_Label_1)
  
  begin object class=UI_Label Name=Mgmt_Window_Label_2
    tag="Mgmt_Window_Label_2"
    posX=0
    posY=189
    posXEnd=720
    posYEnd=NATIVE_HEIGHT
    AlignX=CENTER
    AlignY=TOP
    labelText=""
  end object
  componentList.add(Mgmt_Window_Label_2)
  
  begin object class=UI_Label Name=Mgmt_Window_Label_3
    tag="Mgmt_Window_Label_3"
    posX=0
    posY=216
    posXEnd=720
    posYEnd=NATIVE_HEIGHT
    AlignX=CENTER
    AlignY=TOP
    labelText=""
  end object
  componentList.add(Mgmt_Window_Label_3)
  
  begin object class=UI_Label Name=Mgmt_Window_Label_4
    tag="Mgmt_Window_Label_4"
    posX=0
    posY=243
    posXEnd=720
    posYEnd=NATIVE_HEIGHT
    AlignX=CENTER
    AlignY=TOP
    labelText=""
  end object
  componentList.add(Mgmt_Window_Label_4)
  
  begin object class=UI_Label Name=Mgmt_Window_Label_5
    tag="Mgmt_Window_Label_5"
    posX=0
    posY=297
    posXEnd=720
    posYEnd=NATIVE_HEIGHT
    AlignX=CENTER
    AlignY=TOP
    labelText="Skill Level: 1"
  end object
  componentList.add(Mgmt_Window_Label_5)
  
  begin object class=UI_Label Name=Mgmt_Window_Label_6
    tag="Mgmt_Window_Label_6"
    posX=0
    posY=324
    posXEnd=720
    posYEnd=NATIVE_HEIGHT
    AlignX=CENTER
    AlignY=TOP
    labelText="Mana Cost: 5"
  end object
  componentList.add(Mgmt_Window_Label_6)
  
  begin object class=UI_Label Name=Mgmt_Window_Label_7
    tag="Mgmt_Window_Label_7"
    posX=0
    posY=351
    posXEnd=720
    posYEnd=NATIVE_HEIGHT
    AlignX=CENTER
    AlignY=TOP
    labelText="Damage: 1 - 3"
  end object
  componentList.add(Mgmt_Window_Label_7)
  
  begin object class=UI_Label Name=Mgmt_Window_Label_8
    tag="Mgmt_Window_Label_8"
    posX=0
    posY=378
    posXEnd=720
    posYEnd=NATIVE_HEIGHT
    AlignX=CENTER
    AlignY=TOP
    labelText="Critical Srike: 5%"
  end object
  componentList.add(Mgmt_Window_Label_8)
  
  begin object class=UI_Label Name=Mgmt_Window_Label_9
    tag="Mgmt_Window_Label_9"
    posX=0
    posY=423
    posXEnd=720
    posYEnd=NATIVE_HEIGHT
    AlignX=CENTER
    AlignY=TOP
    labelText="Next Level"
  end object
  componentList.add(Mgmt_Window_Label_9)
  
  begin object class=UI_Label Name=Mgmt_Window_Label_10
    tag="Mgmt_Window_Label_10"
    posX=0
    posY=450
    posXEnd=720
    posYEnd=NATIVE_HEIGHT
    AlignX=CENTER
    AlignY=TOP
    labelText="Mana Cost: 6"
  end object
  componentList.add(Mgmt_Window_Label_10)
  
  begin object class=UI_Label Name=Mgmt_Window_Label_11
    tag="Mgmt_Window_Label_11"
    posX=0
    posY=477
    posXEnd=720
    posYEnd=NATIVE_HEIGHT
    AlignX=CENTER
    AlignY=TOP
    labelText="Damage: 4 - 9"
  end object
  componentList.add(Mgmt_Window_Label_11)
  
  begin object class=UI_Label Name=Mgmt_Window_Label_12
    tag="Mgmt_Window_Label_12"
    posX=0
    posY=504
    posXEnd=720
    posYEnd=NATIVE_HEIGHT
    AlignX=CENTER
    AlignY=TOP
    labelText="Critical Chance: 10%"
  end object
  componentList.add(Mgmt_Window_Label_12)
  
  // Mgmt Window Selection Box
  begin object class=UI_Selector Name=Mgmt_Window_Selection_Box
    tag="Mgmt_Window_Selection_Box"
    bEnabled=false
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
  componentList.add(Mgmt_Window_Selection_Box)
  
}
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  