/*=============================================================================
 * ROTT_UI_Page_Naming_Interface
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This page allows the player to name their profile
 *===========================================================================*/
 
class ROTT_UI_Page_Naming_Interface extends ROTT_UI_Page;

// Random names
var private array<string> randomNames;
var private int randomIndex;

// Internal references
var private UI_Selector_2D selector;
var private UI_Sprite selectorEnd;
var private UI_Label namingLabel;

// Parent scene
var private ROTT_UI_Scene_Npc_Dialog someScene;

/*============================================================================= 
 * initializeComponent()
 *
 * Called once, when the scene is first initialized.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  super.initializeComponent(newTag);
  
  // set parent scene
  someScene = ROTT_UI_Scene_Npc_Dialog(outer);
  
  // Internal references
  selector = UI_Selector_2D(findComp("Key_Selection_Box"));
  selectorEnd = findSprite("Selector_Large");
  namingLabel = findLabel("Name_Text_Label");
}

/*============================================================================= 
 * onPushPageEvent
 *
 * Description: This event is called every time the page is pushed.
 *===========================================================================*/
event onPushPageEvent() {
  randomIndex = rand(randomNames.length);
}

/*============================================================================= 
 * onPopPageEvent()
 *
 * This event is called when the page is removed
 *===========================================================================*/
event onPopPageEvent() {
  
}

/*============================================================================= 
 * refresh()
 *
 * This function should ensure that any data thats been changed will be 
 * correctly updated on the UI.
 *===========================================================================*/
public function refresh() {
  switch (selector.getSelection()) {
    case 28:
    case 29:
      selectorEnd.setEnabled(true);
      selector.setEnabled(false);
      break;
    default:
      selectorEnd.setEnabled(false);
      selector.setEnabled(true);
      break;
  }
}
  
/*============================================================================= 
 * onSceneActivation
 *
 * Called every time the parent scene is loaded
 *===========================================================================*/
public function onSceneActivation() {

}

/*=============================================================================
 * onFocusMenu()
 *
 * Called when a menu is given focus.  Assign controls, and enable graphics.
 *===========================================================================*/
event onFocusMenu();

/*=============================================================================
 * elapseTimers()
 *
 * Ticks every frame.  Used to check for joystick navigation.
 *===========================================================================*/
public function elapseTimers(float deltaTime) {
  super.elapseTimers(deltaTime);
}

/*=============================================================================
 * Controls
 *
 * ControllerId     the controller that generated this input key event
 * inputName        the name of the key which an event occured for
 * EventType        the type of event which occured
 * AmountDepressed  for analog keys, the depression percent.
 *
 * Returns: true to consume the key event, false to pass it on.
 *===========================================================================*/
function bool onInputKey
( 
  int ControllerId, 
  name inputName, 
  EInputEvent Event, 
  float AmountDepressed = 1.f, 
  bool bGamepad = false
) 
{
  // Pressed inputs
  if (Event == IE_Pressed) {
    switch (inputName) {
      case 'Tab':
      case 'XBoxTypeS_Y':
        // Randomize name
        randomIndex++;
        randomIndex = randomIndex % randomNames.length;
        namingLabel.setText(randomNames[randomIndex]);
        
        // Move selector to end
        selector.forceSelect(9, 2);
        break;
      case 'Enter':
        // Submit name
        submitName();
        selector.forceSelect(9, 2);
        break;
      case 'SpaceBar':
        if (namingLabel.getLength() < 16) {
          namingLabel.putChar(" ");
        }
        break;
      case 'BackSpace':
        namingLabel.removeChar();
        break;
      case 'XBoxTypeS_DPad_Up':    
      case 'XBoxTypeS_DPad_Down':  
      case 'XBoxTypeS_DPad_Left':  
      case 'XBoxTypeS_DPad_Right': 
        super.onInputKey(ControllerId, inputName, Event, AmountDepressed, bGamepad);
        refresh();
        return true;
      default:
        addChar(inputName);
        forceSelectKey(inputName);
        break;
    }
  } else if (Event == IE_Released) {
    switch (inputName) {
      case 'XBoxTypeS_A': 
      case 'XBoxTypeS_B':
        super.onInputKey(ControllerId, inputName, Event, AmountDepressed, bGamepad);
        refresh();
        return true;
      case 'LeftMouseButton':
        if (selector.getSelection() == 29) submitName();
        return true;
    }
  }
  
  // UI updates
  refresh();
  return true;
}

/*=============================================================================
 * D-Pad controls
 *===========================================================================*/
public function onNavigateLeft() {
  selector.moveLeft();
  refresh();
}

public function onNavigateRight() {
  selector.moveRight();
  refresh();
}

public function onNavigateDown() {
  selector.moveDown();
  refresh();
}

public function onNavigateUp() {
  selector.moveUp();
  refresh();
}

/*=============================================================================
 * submitName()
 *===========================================================================*/
private function submitName() {
  // Remove trailing spaces
  removeSpaces();
  
  // Check if name is valid
  if (namingLabel.getLength() == 0) {
    sfxBox.playSfx(SFX_MENU_INSUFFICIENT);
    return;
  }
  
  // Sound effect
  sfxBox.playSfx(SFX_MENU_CLICK);
  
  // Give name to profile
  gameInfo.playerProfile.nameProfile(namingLabel.labelText);
  
  // Navigate back to dialog
  parentScene.popPage();
  someScene.sceneManager.sceneNpcDialog.npcDialoguePage.npc.dialogTraversal();
}

/*=============================================================================
 * forceSelectKey()
 *===========================================================================*/
private function forceSelectKey(name selectKey) {
  // Key input
  switch (selectKey) {
    case 'Q': selector.forceSelect(0, 0); break;
    case 'W': selector.forceSelect(1, 0); break;
    case 'E': selector.forceSelect(2, 0); break;
    case 'R': selector.forceSelect(3, 0); break;
    case 'T': selector.forceSelect(4, 0); break;
    case 'Y': selector.forceSelect(5, 0); break;
    case 'U': selector.forceSelect(6, 0); break;
    case 'I': selector.forceSelect(7, 0); break;
    case 'O': selector.forceSelect(8, 0); break;
    case 'P': selector.forceSelect(9, 0); break;
    case 'A': selector.forceSelect(0, 1); break;
    case 'S': selector.forceSelect(1, 1); break;
    case 'D': selector.forceSelect(2, 1); break;
    case 'F': selector.forceSelect(3, 1); break;
    case 'G': selector.forceSelect(4, 1); break;
    case 'H': selector.forceSelect(5, 1); break;
    case 'J': selector.forceSelect(6, 1); break;
    case 'K': selector.forceSelect(7, 1); break;
    case 'L': selector.forceSelect(8, 1); break;
    case ' ': selector.forceSelect(0, 2); break;
    case 'Z': selector.forceSelect(1, 2); break;
    case 'X': selector.forceSelect(2, 2); break;
    case 'C': selector.forceSelect(3, 2); break;
    case 'V': selector.forceSelect(4, 2); break;
    case 'B': selector.forceSelect(5, 2); break;
    case 'N': selector.forceSelect(6, 2); break;
    case 'M': selector.forceSelect(7, 2); break;
  }
}

/*=============================================================================
 * Button controls
 *===========================================================================*/
protected function navigationRoutineA() {
  // Check for "end" input
  switch (selector.getSelection()) {
    case 28:
    case 29:
      submitName();
      return;
  }
  
  // Check for max length limit
  if (namingLabel.getLength() >= 16) { 
    sfxBox.playSfx(SFX_MENU_INSUFFICIENT);
    return;
  }
  
  // Key input
  switch (selector.getSelection()) {
    case 0: addChar('Q'); break;
    case 1: addChar('W'); break;
    case 2: addChar('E'); break;
    case 3: addChar('R'); break;
    case 4: addChar('T'); break;
    case 5: addChar('Y'); break;
    case 6: addChar('U'); break;
    case 7: addChar('I'); break;
    case 8: addChar('O'); break;
    case 9: addChar('P'); break;
    case 10: addChar('A'); break;
    case 11: addChar('S'); break;
    case 12: addChar('D'); break;
    case 13: addChar('F'); break;
    case 14: addChar('G'); break;
    case 15: addChar('H'); break;
    case 16: addChar('J'); break;
    case 17: addChar('K'); break;
    case 18: addChar('L'); break;
    case 19:               break;
    case 20: addChar(' '); break;
    case 21: addChar('Z'); break;
    case 22: addChar('X'); break;
    case 23: addChar('C'); break;
    case 24: addChar('V'); break;
    case 25: addChar('B'); break;
    case 26: addChar('N'); break;
    case 27: addChar('M'); break;
  }
}

protected function navigationRoutineB() {
  // Backspace
  namingLabel.removeChar();
}

/*=============================================================================
 * removeSpaces()
 *
 * Removes all trailing spaces from a profile name
 *===========================================================================*/
public function removeSpaces() {
  // Check if theres a trailing space
  if (right(namingLabel.labelText, 1) != " ") return;
  
  // Remove space
  namingLabel.removeChar();
  
  // Recurse
  removeSpaces();
}

/*=============================================================================
 * addChar()
 *
 * Inserts a character to the end of the profile name if theres room
 *===========================================================================*/
public function addChar(name key) {
  // Ignore leading spaces
  if (namingLabel.getLength() == 0 && key == ' ') return;
  
  // Check if name is less than max length
  if (namingLabel.getLength() < 16) {
    if (namingLabel.getLength() == 0) {
      // Capitalize first letter
      namingLabel.putChar(Caps(key));
    } else if (right(namingLabel.labelText, 1) == " ") {
      // Capitalize letters after spaces
      namingLabel.putChar(Caps(key));
    } else {
      // Lower case otherwise
      namingLabel.putChar(Locs(key));
    }
  }
  
  if (namingLabel.getLength() == 16) {
    // Move selector to end
    selector.forceSelect(9, 2);
  }
  
  // UI updates
  refresh();
}

/*=============================================================================
 * Assets
 *===========================================================================*/
defaultProperties
{
  bPageForcesCursorOff=true
  
  // Random names
  randomNames=("Yufko", "Quria", "Rhexio", "Shujie", "Mox Mox")
  
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
  // Left menu backgrounds
  begin object class=UI_Texture_Info Name=Background
    componentTextures.add(Texture2D'GUI.Profile_Naming_Interface')
  end object
  
  /** ===== UI Components ===== **/
  // Background
  begin object class=UI_Sprite Name=Background_Sprite
    tag="Background_Sprite"
    bEnabled=true
    posX=0
    posY=0
    images(0)=Background
  end object
  componentList.add(Background_Sprite)
  
  begin object class=UI_Selector Name=Selection_Input
    tag="Selection_Input"
    navigationType=SELECTION_2D
    bEnabled=true
    bActive=true
  end object
  componentList.add(Selection_Input)
  
  // Selector texture
  begin object class=UI_Texture_Info Name=Selection_Box
    componentTextures.add(Texture2D'GUI.Key_Selector')
  end object
  
  // Key Selector
  begin object class=UI_Selector_2D Name=Key_Selection_Box
    tag="Key_Selection_Box"
    bEnabled=true
    wrapSelection=true
    posX=152
    posY=378
    selectOffset=(x=115,y=115)  // Distance from neighboring spaces
    homeCoords=(x=0,y=0)        // The default space for the selector to start
    gridSize=(x=10,y=3)         // Total size of 2d selection space
    
    // Draw Textures
    images(0)=Selection_Box
    
    // Navigation skips
    navSkips(0)=(xCoord=9,yCoord=2,skipDirection=NAV_LEFT)
    navSkips(1)=(xCoord=7,yCoord=2,skipDirection=NAV_RIGHT)
    navSkips(2)=(xCoord=8,yCoord=2,skipDirection=NAV_RIGHT)
    
    // Alpha Effects
    activeEffects.add((effectType = EFFECT_ALPHA_CYCLE, lifeTime = -1, elapsedTime = 0, intervalTime = 0.4, min = 170, max = 255))
  end object
  componentList.add(Key_Selection_Box)
  
  
  // Large selector
  begin object class=UI_Texture_Info Name=Key_Selector_Large
    componentTextures.add(Texture2D'GUI.Key_Selector_Large')
  end object
  
  // Large selector
  begin object class=UI_Sprite Name=Selector_Large
    tag="Selector_Large"
    bEnabled=false
    posX=1071
    posY=608
    images(0)=Key_Selector_Large
    
    // Alpha Effects
    activeEffects.add((effectType = EFFECT_ALPHA_CYCLE, lifeTime = -1, elapsedTime = 0, intervalTime = 0.4, min = 170, max = 255))
  end object
  componentList.add(Selector_Large)
  
  
  
  // Name text label
  begin object class=UI_Label Name=Name_Text_Label
    tag="Name_Text_Label"
    posX=280
    posY=202
    posXEnd=1160
    posYEnd=294
    fontStyle=DEFAULT_LARGE_TAN
    AlignX=LEFT
    AlignY=CENTER
    labelText=""
  end object
  componentList.add(Name_Text_Label)
  
}
















