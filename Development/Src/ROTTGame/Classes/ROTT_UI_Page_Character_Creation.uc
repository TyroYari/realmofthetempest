/*=============================================================================
 * ROTT_UI_Page_Character_Creation
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This page allows the player to select a character class for
 * a new character
 *===========================================================================*/
 
class ROTT_UI_Page_Character_Creation extends ROTT_UI_Page
dependsOn(ROTT_Combat_Hero);

/** ============================== **/

enum SelectionStates {
  INPUT_READY,
  BUSY_ANIMATING
};

var private SelectionStates selectionState;

enum QueuedInput {
  INPUT_EMPTY,
  INPUT_LEFT,
  INPUT_RIGHT
};

var private QueuedInput nextInput;

/** ============================== **/

// Input delay timer
var public ROTT_Timer inputDelayTimer; 
  
// Class list data structure
var private array<HeroClassEnum> characterClasses;
var private byte availableIndices[HeroClassEnum];
var private byte availableCount;
var private byte selectedIndex;

// Internal references
var private UI_Selector selectionArrows;
var private UI_Sprite characterPortraits[5];

// Parent scene
var private ROTT_UI_Scene_Character_Creation someScene;

/*============================================================================= 
 * initializeComponent
 *
 * Called once, when the scene is first initialized.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  local string className;
  local int i;
  
  super.initializeComponent(newTag);
  
  // Get internal references
  for (i = 0; i < characterClasses.length; i++) {
    // Get class name
    className = string(GetEnum(enum'HeroClassEnum', i+1));
    
    // Get reference
    characterPortraits[i] = findSprite("Selection_Portrait_" $ PCase(className));
    
    // Check the reference was successful (for robustness)
    if (characterPortraits[i] == none) {  
      yellowLog("Warning (!) Class portrait not found: " $ PCase(className));
    }
  }
  
  // Selection arrow reference
  selectionArrows = UI_Selector(findComp("Class_Selection_Arrows"));
  
  // set parent scene
  someScene = ROTT_UI_Scene_Character_Creation(outer);
  
}


/*============================================================================= 
 * initAvailableList()
 *
 * Given a party, this initializes the available classes remaining for 
 * selection
 *===========================================================================*/
private function initAvailableList(ROTT_Party party) {
  local int i;
  
  // Reset available count
  availableCount = 0;
  
  // Loop through all implemented character classes
  for (i = 0; i < characterClasses.length; i++) {
    // Check and remove classes that are already in party
    if (party.checkInParty(characterClasses[i]) == false) {
      availableIndices[availableCount] = characterClasses[i] - 1; // Offset for 'Unspecified'
      availableCount++;
    }
      
    // Initial portrait positions
    characterPortraits[i].resetLerp();
    characterPortraits[i].updatePosition(520+NATIVE_WIDTH, 150);
  }
  
  // Initial selection
  characterPortraits[availableIndices[selectedIndex]].updatePosition(520, 150);
}

/*============================================================================= 
 * debugAvailableList()
 *
 * Dumps the available list for a given party to the console for debug
 *===========================================================================*/
private function debugAvailableList(ROTT_Party party) {
  local int i;
  
  // Initialize list
  initAvailableList(party);
  
  // Debug output
  darkGreenLog("Available classes: ");
  for (i = 0; i < availableCount; i++) {
    greenLog(" - " $ string(GetEnum(enum'HeroClassEnum', availableIndices[i]+1)));
  }
}

/*============================================================================= 
 * onPushPageEvent
 *
 * Description: This event is called every time the page is pushed.
 *===========================================================================*/
event onPushPageEvent() {
  /// Test
  ///debugAvailableList(gameInfo.getActiveParty());
}

/*============================================================================= 
 * onSceneActivation
 *
 * Called every time the parent scene is loaded
 *===========================================================================*/
public function onSceneActivation() {
  // Initialize list
  initAvailableList(gameInfo.getActiveParty());
}

/*============================================================================= 
 * resetSelection()
 *
 * Called after confirming a hero selection.
 *===========================================================================*/
public function resetSelection() {
  selectedIndex = 0;
}

/*=============================================================================
 * onFocusMenu()
 *
 * Called when a menu is given focus.  Assign controls, and enable graphics.
 *===========================================================================*/
event onFocusMenu() {
  selectionArrows.setActive(true);
}

/*=============================================================================
 * D-Pad controls
 *===========================================================================*/
public function onNavigateLeft() {
  local IntPoint origin, destination;
  
  // Input delay handling
  if (selectionState == BUSY_ANIMATING) {
    nextInput = INPUT_LEFT;
    return;
  }
  selectionState = BUSY_ANIMATING;
  renderClassInfo(false);
  
  // Set scene to no input, until animation effects complete
  inputDelayTimer = gameInfo.Spawn(class'ROTT_Timer');
  inputDelayTimer.makeTimer(0.5, LOOP_OFF, allowInput);
  
  // Animate current selection to the right
  origin.x = 520; origin.y = 150; 
  destination.x = 520+NATIVE_WIDTH; destination.y = 150; 
  characterPortraits[availableIndices[selectedIndex]].setLerp(origin, destination, 0.5);
  
  // Select to the left
  selectedIndex--; 
  if (selectedIndex == -1) selectedIndex = availableCount - 1;
  
  // Animate new selection to the right
  origin.x = 520-NATIVE_WIDTH; origin.y = 150; 
  destination.x = 520; destination.y = 150; 
  characterPortraits[availableIndices[selectedIndex]].setLerp(origin, destination, 0.5);
}

public function onNavigateRight() {
  local IntPoint origin, destination;
  
  // Input delay handling
  if (selectionState == BUSY_ANIMATING) {
    nextInput = INPUT_RIGHT;
    return;
  }
  selectionState = BUSY_ANIMATING;
  renderClassInfo(false);
  
  // Set scene to no input, until animation effects complete
  inputDelayTimer = gameInfo.Spawn(class'ROTT_Timer');
  inputDelayTimer.makeTimer(0.5, LOOP_ON, allowInput);
  
  // Animate current selection to the right
  origin.x = 520; origin.y = 150; 
  destination.x = 520-NATIVE_WIDTH; destination.y = 150; 
  characterPortraits[availableIndices[selectedIndex]].setLerp(origin, destination, 0.5);
  
  // Select to the right
  selectedIndex = (selectedIndex + 1) % availableCount; 
  
  // Animate new selection to the right
  origin.x = 520+NATIVE_WIDTH; origin.y = 150; 
  destination.x = 520; destination.y = 150; 
  characterPortraits[availableIndices[selectedIndex]].setLerp(origin, destination, 0.5);
}

/*=============================================================================
 * Button controls
 *===========================================================================*/
protected function navigationRoutineA() {
  // Remove page
  parentScene.popPage();
  
  // Create character
  partySystem.getActiveParty().addHero(characterClasses[availableIndices[selectedIndex]]); 
  
  // Open menu for inspection of the new hero class
  sceneManager.switchScene(SCENE_GAME_MENU);
  ROTT_UI_Scene_Game_Menu(sceneManager.scene).enableCreationMode();
  
  // Sfx
  gameInfo.sfxBox.playSfx(SFX_MENU_ACCEPT);
}

protected function navigationRoutineB();

/*============================================================================= 
 * renderClassInfo()
 *
 * This function draws/hides class description info and selection arrows.
 *===========================================================================*/
private function renderClassInfo(bool bShow) { 
  // Show selection arrows
  ///selectionArrows.setEnabled(bShow);
  
  // Descriptor line?
  // ...
} 

/*============================================================================= 
 * allowInput()
 *
 * This function is delegated to a timer, thus no paramaters.
 * Re-enables selection input, and renders selected class info.
 *===========================================================================*/
private function allowInput() { 
  // Allow input
  selectionState = INPUT_READY;

  // Destroy invoking timer
  if (inputDelayTimer != none) inputDelayTimer.Destroy();
  
  // Check for queued input (allows smooth left / right spamming)
  switch (nextInput) {
    case INPUT_LEFT:  
      nextInput = INPUT_EMPTY;
      onNavigateLeft(); /// tell selector to select left
      return;
    case INPUT_RIGHT: 
      nextInput = INPUT_EMPTY;
      onNavigateRight(); /// tell selector to select right
      return;
  }
  
  // Draw affinity info and selection arrows
  renderClassInfo(true);
} 

/*=============================================================================
 * Assets
 *===========================================================================*/
defaultProperties
{  
  // Available hero list
  characterClasses=(VALKYRIE, GOLIATH, WIZARD, TITAN) // ASSASSIN
  
  /** ===== Input ===== **/
  begin object class=ROTT_Input_Handler Name=Input_A
    inputName="XBoxTypeS_A"
    buttonComponent=none
  end object
  inputList.add(Input_A)
  
  /** ===== Textures ===== **/
  // Left menu backgrounds
  begin object class=UI_Texture_Info Name=Character_Selection_Background
    componentTextures.add(Texture2D'GUI.Character_Selection_Background')
  end object
  
  // Header image
  begin object class=UI_Texture_Info Name=Select_A_Class
    componentTextures.add(Texture2D'GUI.Select_A_Class')
  end object
  
  // Character Selection Portraits
  begin object class=UI_Texture_Info Name=Character_Portrait_Valkyrie
    componentTextures.add(Texture2D'GUI.Character_Selection_Valkyrie')
  end object
  begin object class=UI_Texture_Info Name=Character_Portrait_Goliath
    componentTextures.add(Texture2D'GUI.Character_Selection_Goliath')
  end object
  begin object class=UI_Texture_Info Name=Character_Portrait_Wizard
    componentTextures.add(Texture2D'GUI.Character_Selection_Wizard')
  end object
  begin object class=UI_Texture_Info Name=Character_Portrait_Titan
    componentTextures.add(Texture2D'GUI.Character_Selection_Titan')
  end object
  begin object class=UI_Texture_Info Name=Character_Portrait_Assassin
    componentTextures.add(Texture2D'GUI.Character_Selection_Assassin')
  end object
  
  /** ===== UI Components ===== **/
  // Background
  begin object class=UI_Sprite Name=Background_Sprite
    tag="Background_Sprite"
    bEnabled=true
    posX=0
    posY=0
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    images(0)=Character_Selection_Background
  end object
  componentList.add(Background_Sprite)
  
  // Header: Select class label
  begin object class=UI_Sprite Name=Selection_Header
    tag="Selection_Header"
    bEnabled=true
    posX=428
    posY=44
    images(0)=Select_A_Class
  end object
  componentList.add(Selection_Header)
  
  // Selection Portraits
  // Valkyrie
  begin object class=UI_Sprite Name=Selection_Portrait_Valkyrie
    tag="Selection_Portrait_Valkyrie"
    bEnabled=true
    posX=520
    posY=150
    images(0)=Character_Portrait_Valkyrie
  end object
  componentList.add(Selection_Portrait_Valkyrie)
  
  begin object class=UI_Sprite Name=Selection_Portrait_Goliath
    tag="Selection_Portrait_Goliath"
    bEnabled=true
    posX=520
    posY=150
    images(0)=Character_Portrait_Goliath
  end object
  componentList.add(Selection_Portrait_Goliath)
  
  begin object class=UI_Sprite Name=Selection_Portrait_Wizard
    tag="Selection_Portrait_Wizard"
    bEnabled=true
    posX=520
    posY=150
    images(0)=Character_Portrait_Wizard
  end object
  componentList.add(Selection_Portrait_Wizard)
  
  begin object class=UI_Sprite Name=Selection_Portrait_Titan
    tag="Selection_Portrait_Titan"
    bEnabled=true
    posX=520
    posY=150
    images(0)=Character_Portrait_Titan
  end object
  componentList.add(Selection_Portrait_Titan)
  
  // Selection arrows
  begin object class=UI_Selector Name=Class_Selection_Arrows
    tag="Class_Selection_Arrows"
    navigationType=SELECTION_HORIZONTAL
    bEnabled=true
    posX=380
    posY=396
    
    // Selection arrows
    begin object class=UI_Texture_Info Name=Selection_Arrows_Texture
      componentTextures.add(Texture2D'GUI.Class_Selection_Arrows')
    end object
    
    // Selector sprite
    begin object class=UI_Sprite Name=Selector_Sprite
      tag="Selector_Sprite"
      images(0)=Selection_Arrows_Texture
      activeEffects.add((effectType = EFFECT_ALPHA_CYCLE, lifeTime = -1, elapsedTime = 0, intervalTime = 0.4, min = 170, max = 255))
    end object
    componentList.add(Selector_Sprite)
    
  end object
  componentList.add(Class_Selection_Arrows)
  
  // Additional info label
  begin object class=UI_Label Name=Additional_Info_Label
    tag="Additional_Info_Label"
    posX=0
    posY=735
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    alignX=CENTER
    alignY=CENTER
    fontStyle=DEFAULT_SMALL_ORANGE
    labelText="Additional information on next page"
  end object
  componentList.add(Additional_Info_Label)
  
  // Additional info label
  begin object class=UI_Label Name=Additional_Info_Label_Effect
    tag="Additional_Info_Label_Effect"
    posX=0
    posY=735
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    alignX=CENTER
    alignY=CENTER
    fontStyle=DEFAULT_SMALL_TAN
    labelText="Additional information on next page"
    
    // Cycle effects
    activeEffects.add((effectType=EFFECT_ALPHA_CYCLE, lifeTime=-1, elapsedTime=0, intervalTime=1.0, min=20, max=140))
  end object
  componentList.add(Additional_Info_Label_Effect)
  
}















