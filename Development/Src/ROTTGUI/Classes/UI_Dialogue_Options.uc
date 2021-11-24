/*=============================================================================
 * UI_Dialogue_Options
 * 
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This class displays a set of 2x2 dialogue options.
 *===========================================================================*/

class UI_Dialogue_Options extends UI_Widget;

/** ============================== **/

// Menu selection types
enum SelectedDialogOption {
  TOP_LEFT,
  TOP_RIGHT,
  BOTTOM_LEFT,
  BOTTOM_RIGHT,
};

// Stores current option selection
var private SelectedDialogOption selectedOption;  

/** ============================== **/

// Internal references
var privatewrite UI_Selector selector; 
var privatewrite UI_Label optionText[4]; 

// Control
var private bool bOptionControls; // true if player may navigate option selections

/*============================================================================= 
 * Initialize Component
 *
 * Description: This event is called as the UI is loaded.
 *=========================================================================== */
public function initializeComponent(optional string newTag = "") {
  local int i;
  super.initializeComponent(newTag);
  
  // Option text references
  for (i = 0; i < 4; i++) {
    optionText[i] = UI_Label(findComp("NPC_Option_Label_" $ i+1));
  }
  
  // Selector image reference
  selector = UI_Selector(findComp("NPC_Dialogue_Selection_Box"));
}

/*=============================================================================
 * showSelector()
 *
 * This draws the selector to the screen
 *===========================================================================*/
public function showSelector() {
  selector.setEnabled(true);
  setActive(true);
  
  if (!isValidOption()) {
    selector.resetSelection();
    selectedOption = TOP_LEFT;
  }
}

/*=============================================================================
 * hideSelector()
 *
 * This hides the selector from the screen
 *===========================================================================*/
public function hideSelector() {
  selector.clearSelection();
  setActive(false);
}

/*=============================================================================
 * getSelectionIndex()
 *
 * Returns an index between 0-3 corresponding to a player's dialog selection
 *===========================================================================*/
public function int getSelectionIndex() {
  return selector.getSelection(); //int(selectedOption)
}

/*=============================================================================
 * selectDown()
 *===========================================================================*/
public function bool preNavigateDown() {
  local SelectedDialogOption oldSelection;
  selectedOption = SelectedDialogOption(selector.getSelection());
  oldSelection = selectedOption;
  
  // Check if input is allowed
  if (bEnabled == false) return false;
  
  // Calculate selection destination
  switch (selector.getSelection()) {
    case TOP_LEFT:      selectedOption = BOTTOM_LEFT;   break;
    case TOP_RIGHT:     selectedOption = BOTTOM_RIGHT;  break;
    default:
      return false;
  }
  
  // Check input validity
  if (isValidOption() == false) {
    selectedOption = oldSelection;
    return false;
  }
  
  return true;
}

/*=============================================================================
 * selectRight()
 *===========================================================================*/
public function bool preNavigateUp() {
  local SelectedDialogOption oldSelection;
  selectedOption = SelectedDialogOption(selector.getSelection());
  oldSelection = selectedOption;
  
  // Check if input is allowed
  if (bEnabled == false) return false;
  
  // Calculate selection destination
  switch (selector.getSelection()) {
    case BOTTOM_LEFT:   selectedOption = TOP_LEFT;      break;
    case BOTTOM_RIGHT:  selectedOption = TOP_RIGHT;     break;
    default:
      return false;
  }
  
  // Check input validity
  if (isValidOption() == false) {
    selectedOption = oldSelection;
    return false;
  }
  
  return true;
}

/*=============================================================================
 * selectRight()
 *===========================================================================*/
public function bool preNavigateRight() {
  local SelectedDialogOption oldSelection;
  selectedOption = SelectedDialogOption(selector.getSelection());
  oldSelection = selectedOption;
  
  // Check if input is allowed
  if (bEnabled == false) return false;
  
  // Calculate selection destination
  switch (selector.getSelection()) {
    case TOP_LEFT:      selectedOption = TOP_RIGHT;     break;
    case BOTTOM_LEFT:   selectedOption = BOTTOM_RIGHT;  break;
    default:
      return false;
  }
  
  // Check input validity
  if (isValidOption() == false) {
    selectedOption = oldSelection;
    return false;
  }
  
  return true;
}

/*=============================================================================
 * selectLeft()
 *===========================================================================*/
public function bool preNavigateLeft() {
  local SelectedDialogOption oldSelection;
  selectedOption = SelectedDialogOption(selector.getSelection());
  oldSelection = selectedOption;
  
  // Check if input is allowed
  if (bEnabled == false) return false;
  
  // Calculate selection destination
  switch (selector.getSelection()) {
    case TOP_RIGHT:     selectedOption = TOP_LEFT;      break;
    case BOTTOM_RIGHT:  selectedOption = BOTTOM_LEFT;   break;
    default:
      return false;
  }
  
  // Check input validity
  if (isValidOption() == false) {
    selectedOption = oldSelection;
    return false;
  }
  
  return true;
}

/*=============================================================================
 * isValidOption()
 *
 * Returns true if an option is not null
 *===========================================================================*/
private function bool isValidOption() {
  return (!optionText[selectedOption].isEmptyText());
}

/*=============================================================================
 * clearOptions()
 *===========================================================================*/
public function clearOptions() { setOptions(); }

/*=============================================================================
 * setOptions()
 *
 * Changes the option labels, clears the text by default. 
 *===========================================================================*/
public function setOptions
(
  optional string option1 = "",
  optional string option2 = "",
  optional string option3 = "",
  optional string option4 = ""
)
{
  optionText[0].setText(option1);
  optionText[1].setText(option2);
  optionText[2].setText(option3);
  optionText[3].setText(option4);
  
  if (option1 != "") selector.setNumberOfMenuOptions(1);
  if (option2 != "") selector.setNumberOfMenuOptions(2);
  if (option3 != "") selector.setNumberOfMenuOptions(3);
  if (option4 != "") selector.setNumberOfMenuOptions(4);
  
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  // Option Selection Box
  begin object class=UI_Selector Name=NPC_Dialogue_Selection_Box
    tag="NPC_Dialogue_Selection_Box"
    navigationType=SELECTION_2D
    bEnabled=false
    bActive=true
    posX=70
    posY=680
    hoverCoords(0)=(xStart=74,yStart=685,xEnd=712,yEnd=771)
    hoverCoords(1)=(xStart=733,yStart=681,xEnd=1372,yEnd=771)
    hoverCoords(2)=(xStart=74,yStart=786,xEnd=712,yEnd=871)
    hoverCoords(3)=(xStart=733,yStart=786,xEnd=1372,yEnd=871)
    
    // Pixel distance from neighboring selections
    selectionOffset=(x=660,y=104)  
    
    // Total size of 2d selection space
    gridSize=(x=2,y=2) 
    
    // Textures
    begin object class=UI_Texture_Info Name=NPC_Dialogue_Selection_Box_Texture
      componentTextures.add(Texture2D'GUI.NPC_Dialogue_Selection_Box')
    end object
    
    // Selector sprite
    begin object class=UI_Sprite Name=Selector_Sprite
      tag="Selector_Sprite"
      images(0)=NPC_Dialogue_Selection_Box_Texture
      
      // Selector effect
      activeEffects.add((effectType = EFFECT_ALPHA_CYCLE, lifeTime = -1, elapsedTime = 0, intervalTime = 0.4, min = 170, max = 255))
    end object
    componentList.add(Selector_Sprite)
    
  end object
  componentList.add(NPC_Dialogue_Selection_Box)
  
  // Dialogue option labels
  begin object class=UI_Label Name=NPC_Option_Label_1
    tag="NPC_Option_Label_1"
    posX=70
    posY=680 
    posXEnd=710
    posYEnd=772
    alignX=CENTER
    alignY=CENTER
    fontStyle=DEFAULT_MEDIUM_WHITE
    LabelText[0]=""
    //LabelText[0]="This text is a test, this is an option."
  end object
  componentList.add(NPC_Option_Label_1)
  
  begin object class=UI_Label Name=NPC_Option_Label_2
    tag="NPC_Option_Label_2"
    posX=730
    posY=680
    posXEnd=1370
    posYEnd=772
    alignX=CENTER
    alignY=CENTER
    fontStyle=DEFAULT_MEDIUM_WHITE
    LabelText[0]=""
    //LabelText[0]="Option number 2!"
  end object
  componentList.add(NPC_Option_Label_2)
  
  begin object class=UI_Label Name=NPC_Option_Label_3
    tag="NPC_Option_Label_3"
    posX=70
    posY=784
    posXEnd=710
    posYEnd=876
    alignX=CENTER
    alignY=CENTER
    fontStyle=DEFAULT_MEDIUM_WHITE
    LabelText[0]=""
    //LabelText[0]="Is this the longest sentence I can ask here?"
  end object
  componentList.add(NPC_Option_Label_3)
  
  begin object class=UI_Label Name=NPC_Option_Label_4
    tag="NPC_Option_Label_4"
    posX=730
    posY=784
    posXEnd=1370
    posYEnd=876
    alignX=CENTER
    alignY=CENTER
    fontStyle=DEFAULT_MEDIUM_WHITE
    LabelText[0]=""
    //LabelText[0]="Farewell"
  end object
  componentList.add(NPC_Option_Label_4)
}













