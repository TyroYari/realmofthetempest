/*=============================================================================
 * ROTT_UI_Page_NPC_Dialogue
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This class handles the UI and controls for all npc interaction.
 *===========================================================================*/
 
class ROTT_UI_Page_NPC_Dialogue extends ROTT_UI_Page; 

const NO_RESIZE = true;

/** ============================== **/

enum ControlState {
  IGNORE_INPUT,
  ACCEPT_INPUT
};

var public ControlState menuControl;

/** ============================== **/

// Parent scene
var private ROTT_UI_Scene_Npc_Dialog someScene;

// Some useful internal references
var private UI_Dialogue_Options dialogueOptions;
var private UI_Sprite npcSprite;
var private UI_Sprite dialogBackground;
var private UI_Label dialogTopLine;
var private UI_Label dialogBottomLine;

// Selector reference
///var privatewrite UI_Selector selector; 

// Dialog navigation vars
var privatewrite ROTT_NPC_Container npc;      // Stores the NPC Dialog data structure

// Input delay timer
var public ROTT_Timer inputDelayTimer; 

// Used to filter first A releast event
var private bool bUnlockA;

/*============================================================================= 
 * initializeComponent()
 *
 * Called once, when the scene is first initialized.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  super.initializeComponent(newTag);
  
  // Hook up some child references
  dialogBackground = findSprite("Dialogue_Background");
  npcSprite = findSprite("NPC_Character_Display");
  dialogTopLine = findLabel("NPC_Label_1");
  dialogBottomLine = findLabel("NPC_Label_2");
  dialogueOptions = UI_Dialogue_Options(findComp("NPC_Dialogue_Options"));
  
  // Scene reference
  someScene = ROTT_UI_Scene_Npc_Dialog(outer);
  
}

/*============================================================================= 
 * onPushPageEvent()
 *
 * This event is called every time the page is pushed.
 *===========================================================================*/
event onPushPageEvent() {
  clearUI();
}

/*============================================================================= 
 * clearUI()
 *
 * This resets the dialog text and options to prepare for a new dialog
 *===========================================================================*/
public function clearUI() {
  // Clear UI
  dialogTopLine.setText("");
  dialogBottomLine.setText("");
  clearOptions();
  bUnlockA = false;
  
  // Delay controller input
  menuControl = IGNORE_INPUT;
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
function bool onInputKey( 
  int ControllerId, 
  name Key, 
  EInputEvent Event, 
  float AmountDepressed = 1.f, 
  bool bGamepad = false) 
{
  // Filter input when controls are locked
  if (menuControl != ACCEPT_INPUT) return true;
  
  switch (Key) {
    // Button inputs
    case 'XBoxTypeS_A':          
      if (Event == IE_Pressed) {
        bUnlockA = true;
      } else if (Event == IE_Released && bUnlockA) {
        // Traverse dialog
        navigationRoutineA(); 
      }
      return false;
      
    case 'XBoxTypeS_B':
      if (Event == IE_Released) {
        // Skip dialog
        navigationRoutineB();
      }
      return true;
      
    case 'LeftMouseButton':
    case 'SpaceBar':
    case 'Q':
    
    case 'XBoxTypeS_DPad_Down':
    case 'XBoxTypeS_DPad_Up':
    case 'XBoxTypeS_DPad_Left':
    case 'XBoxTypeS_DPad_Right':
      return super.onInputKey(ControllerId, Key, Event, AmountDepressed, bGamepad);
  }
  
  //super.onInputKey(ControllerId, Key, Event, AmountDepressed, bGamepad);
  return false;
}

/*============================================================================*
 * launchNPC()
 *
 * This function starts a conversation between the player and an NPC
 *===========================================================================*/
public function launchNPC(class<ROTT_NPC_Container> npcType) {
  // Console info 
  whitelog("----- Launching NPC: " $ npcType $ " -----");
  
  // Reset all UI data
  clearUI();
  
  // Check argument validity
  if (npcType == none) { yellowLog("Warning (!): No NPC Type"); scriptTrace();}
  
  // Load npc
  npc = new npcType;
  npc.initDialogue();
  
  // Ignore input until timer is ready
  if (npc.bFadeIn) {
    inputDelayTimer = gameInfo.spawn(class'ROTT_Timer');
    inputDelayTimer.makeTimer(1.4, LOOP_OFF, allowInput);
    findSprite("Dialogue_Fade_Screen").setEnabled(true);
  } else {
    inputDelayTimer = gameInfo.spawn(class'ROTT_Timer');
    inputDelayTimer.makeTimer(1.0, LOOP_OFF, allowInput);
    findSprite("Dialogue_Fade_Screen").setEnabled(false);
  }
  
  // Load sprite sheet
  npcSprite.modifyTexture(npc.npcSprites.images[0]);
  
  // Handle dialog traversal
  npc.startConversation(self);
  
  // Set dialog background
  dialogBackground.copySprite(npc.npcBackground, 0, NO_RESIZE);
  
  // Keep count of goodnights
  gameInfo.playerProfile.nightCounter++;
  
}

/*=============================================================================
 * exitDialog()
 *
 * Called when an NPC dialog is complete, and the player returns to the
 * overworld.
 *===========================================================================*/
public function exitDialog() {
  gameInfo.tempestPawn.resetVelocity();
  gameInfo.sceneManager.switchScene(SCENE_OVER_WORLD);
  gameInfo.sceneManager.sceneOverWorld.npcExitTransition();
}

/*=============================================================================
 * setTextColor()
 *
 * 
 *===========================================================================*/
public function setTextColor(FontStyles newFont) {
  dialogTopLine.setFont(newFont);
  dialogBottomLine.setFont(newFont);
}

/*=============================================================================
 * isTextUp()
 *
 * Returns true if the complete dialog message is written to the screen
 *===========================================================================*/
public function bool isTextUp() {
  // When neither line is scrolling then the text is up
  return (dialogTopLine.scrollTime == -1 && dialogBottomLine.scrollTime == -1);
}
 
/*=============================================================================
 * skipScrollEffect()
 *
 * Forces the text to fully appear
 *===========================================================================*/
public function skipScrollEffect() {
  dialogTopLine.clearScrollEffect();
  dialogBottomLine.clearScrollEffect();
}
 
/*=============================================================================
 * bufferText()
 *
 * Replaces special replacement codes in dialog text
 *===========================================================================*/
public function bufferText(out DialogText text) {
  // Buffer text
  text.topline = repl(text.topline, "%n", gameInfo.playerProfile.username);
  text.bottomline = repl(text.bottomline, "%n", gameInfo.playerProfile.username);
}
 
/*=============================================================================
 * renderDialog()
 *
 * Draws text to dialog screen from an NPC dialog
 *===========================================================================*/
public function renderDialog(DialogText text) {
  // Buffer text
  bufferText(text);
  
  // Render dialog to screen
  dialogTopLine.setText(text.topline);
  dialogBottomLine.setText(text.bottomline);
  
  // Activate scrolling text effects
  dialogTopLine.startScrollEffect();
  dialogBottomLine.startScrollEffect(dialogTopLine.getDelayTime());
  
  // Sfx
  sfxBox.playSFX(SFX_NPC_TEXT);
}
 
/*=============================================================================
 * renderOptions()
 *
 * Draws dialog options to the screen from an NPC dialog
 *===========================================================================*/
public function renderOptions(OptionText options) {
  // Display options now, with selector
  dialogueOptions.showSelector();
  dialogueOptions.setOptions(
    options.options[0], options.options[1], 
    options.options[2], options.options[3]
  );
  
}
 
/*=============================================================================
 * getOptionSelection()
 *
 * Returns the index of the selected option
 *===========================================================================*/
public function int getOptionSelection() {
  return dialogueOptions.getSelectionIndex();
}

/*=============================================================================
 * clearOptions()
 *
 * Clears options UI
 *===========================================================================*/
public function clearOptions() {
  dialogueOptions.hideSelector();
  dialogueOptions.clearOptions();
}

/*============================================================================= 
 * allowInput()
 *
 * This function is delegated to a timer, thus no paramaters.
 * Re-enables selection input, and renders selected class info.
 *===========================================================================*/
private function allowInput() { 
  // Allow input
  menuControl = ACCEPT_INPUT;
  
  // Draw first message
  npc.renderCurrentNode();
  
  // Destroy invoking timer
  if (inputDelayTimer != none) inputDelayTimer.destroy();
} 

/*=============================================================================
 * selectDown()
 *===========================================================================*/
public function bool preNavigateDown() {
  return dialogueOptions.preNavigateDown();
}

/*=============================================================================
 * selectRight()
 *===========================================================================*/
public function bool preNavigateUp() {
  return dialogueOptions.preNavigateUp();
}

/*=============================================================================
 * selectRight()
 *===========================================================================*/
public function bool preNavigateRight() {
  return dialogueOptions.preNavigateRight();
}

/*=============================================================================
 * selectLeft()
 *===========================================================================*/
public function bool preNavigateLeft() {
  return dialogueOptions.preNavigateLeft();
}

/*============================================================================*
 * Button inputs
 *===========================================================================*/
protected function navigationRoutineA() {
  // Handle dialog traversal
  npc.dialogTraversal();
}

protected function navigationRoutineB() {
  // Skip dialog
  npc.dialogTraversal(true);
}

/*=============================================================================
 * Default Properties
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
  
  // Backgrounds
  begin object class=UI_Texture_Info Name=NPC_Background_Blue
    componentTextures.add(Texture2D'GUI_NPC_Dialog.NPC_Background_Blue')
  end object
  
  // This is used to fade in the NPC scene
  begin object class=UI_Sprite Name=Dialogue_Background
    tag="Dialogue_Background" 
    posX=0
    posY=0
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    images(0)=NPC_Background_Blue
  end object
  componentList.add(Dialogue_Background)
  
  // Texture components
  begin object class=UI_Texture_Info Name=Black_Texture
    componentTextures.add(Texture2D'GUI.Black_Square')
  end object
  begin object class=UI_Texture_Info Name=NPC_Frame_Texture
    componentTextures.add(Texture2D'GUI.NPC_Frame')
  end object
  begin object class=UI_Texture_Info Name=NPC_Frame_B
    componentTextures.add(Texture2D'GUI.NPC_Frame_B')
  end object
  
  // This is used to fade in the NPC scene
  ///begin object class=UI_Sprite Name=Dialogue_Fade_Screen
  ///  tag="Dialogue_Fade_Screen"
  ///  bEnabled=false
  ///  posX=0
  ///  posY=0
  ///  posXEnd=NATIVE_WIDTH
  ///  posYEnd=NATIVE_HEIGHT
  ///  images(0)=Black_Texture
  ///end object
  ///componentList.add(Dialogue_Fade_Screen)
  
  // Back frame of the NPC interaction
  begin object class=UI_Sprite Name=NPC_Frame
    tag="NPC_Frame"
    posX=0
    posY=0
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    images(0)=NPC_Frame_Texture
  end object
  componentList.add(NPC_Frame)
  
  // Portrait
  begin object class=UI_Texture_Info Name=Place_Holder_360
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Placeholder_360')
  end object
  
  // The character display component
  begin object class=UI_Sprite Name=NPC_Character_Display
    tag="NPC_Character_Display"
    bAnchor=true
    anchorX=720
    anchorY=281
    images(0)=Place_Holder_360
  end object
  componentList.add(NPC_Character_Display)
  
  // Front frame of the NPC interaction
  begin object class=UI_Sprite Name=NPC_Frame2
    tag="NPC_Frame2"
    posX=0
    posY=0
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    images(0)=NPC_Frame_B
  end object
  componentList.add(NPC_Frame2)
  
  // NPC Dialogue Options
  begin object class=UI_Dialogue_Options Name=NPC_Dialogue_Options
    tag="NPC_Dialogue_Options"
  end object
  componentList.add(NPC_Dialogue_Options)
  
  // NPC Intro Fader
  begin object class=UI_Sprite Name=Dialogue_Fade_Screen
    tag="Dialogue_Fade_Screen"
    posX=0
    posY=0
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    images(0)=Black_Texture
  end object
  componentList.add(Dialogue_Fade_Screen)
  
  // Dialog text
  begin object class=UI_Label Name=NPC_Label_1
    tag="NPC_Label_1"
    posX=0
    posY=562
    posXEnd=NATIVE_WIDTH
    posYEnd=612
    alignX=CENTER
    alignY=TOP
    fontStyle=DEFAULT_MEDIUM_WHITE
    labelText="[PLACEHOLDER DIALOG: LINE 1]"
  end object
  componentList.add(NPC_Label_1)
  
  begin object class=UI_Label Name=NPC_Label_2
    tag="NPC_Label_2"
    posX=0
    posY=600
    posXEnd=NATIVE_WIDTH
    posYEnd=621
    alignX=CENTER
    alignY=TOP
    fontStyle=DEFAULT_MEDIUM_WHITE
    labelText="[PLACEHOLDER DIALOG: LINE 2]"
  end object
  componentList.add(NPC_Label_2)
  
}











