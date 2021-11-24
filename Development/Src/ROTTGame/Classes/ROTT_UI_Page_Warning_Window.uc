/*============================================================================= 
 * ROTT_UI_Page_Warning_Window
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This class displays a warning and a yes/no confirmation option
 * for the player.
 *=========================================================================== */

class ROTT_UI_Page_Warning_Window extends ROTT_UI_Page;

enum WarningOptions {
  WARNING_RESPONSE_NO,
  WARNING_RESPONSE_YES
};

// Customizable properties
var private string header;
var private string messageLine1;
var private string messageLine2;

// Internal references
var private UI_Label warningHeader;
var private UI_Label warningMessageLine1;
var private UI_Label warningMessageLine2;
var private UI_Selector warningSelectionBox;

// These delegates must be set through the invoking GUI Component
delegate closeWarningWindowDelegate();
delegate confirmWarningWindowDelegate();

/*============================================================================= 
 * Initialize Component
 *
 * Description: This event is called as the UI is loaded.
 *=========================================================================== */
public function initializeComponent(optional string newTag = "") {
  super.initializeComponent(newTag);
  
  warningHeader = findLabel("Warning_Header");
  warningMessageLine1 = findLabel("Warning_Message_Line_1");
  warningMessageLine2 = findLabel("Warning_Message_Line_2");
  warningSelectionBox = UI_Selector(findComp("Warning_Selection_Box"));
  
  warningHeader.setText(header);
  warningMessageLine1.setText(messageLine1);
  warningMessageLine2.setText(messageLine2);
}

/*=============================================================================
 * onFocusMenu()
 *
 * Called to enable window visuals, and initialize selector properties
 *===========================================================================*/
event onFocusMenu() {
  setEnabled(true);
  warningSelectionBox.resetSelection();
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
  local WarningOptions selection;
  
  selection = WarningOptions(warningSelectionBox.getSelection());
  
  switch (selection) {
    case WARNING_RESPONSE_NO:
      closeWarningWindowDelegate();
      // Sfx
      gameInfo.sfxBox.playSfx(SFX_MENU_ACCEPT);
      break;
    case WARNING_RESPONSE_YES:
      confirmWarningWindowDelegate();
      break;
  }
}

protected function navigationRoutineB() {
  closeWarningWindowDelegate();
  
  // Sfx
  gameInfo.sfxBox.playSfx(SFX_MENU_BACK);
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
    
    // Clickable sprite for this input
    buttonComponent=none
  end object
  inputList.add(Input_B)
  
  /** ===== Textures ===== **/
  // Warning window
  begin object class=UI_Texture_Info Name=Warning_Window_YES_NO
    componentTextures.add(Texture2D'GUI.Warning_Window_YES_NO')
  end object
  begin object class=UI_Texture_Info Name=Black_Square
    componentTextures.add(Texture2D'GUI.Black_Square')
  end object
  
  /** ===== UI Components ===== **/
  // Fade Layer
  begin object class=UI_Sprite Name=Fade_Layer
    tag="Fade_Layer"
    bMandatoryScaleToWindow=true
    bEnabled=true
    //bStretch=true
    posX=0
    posY=0
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    images(0)=Black_Square
    drawColor=(R=0,G=0,B=0,A=79)
  end object
  componentList.add(Fade_Layer)
  
  // Warning Window
  begin object class=UI_Sprite Name=Warning_Window_Background
    tag="Warning_Window_Background"
    bEnabled=true
    posX=420
    posY=150
    images(0)=Warning_Window_YES_NO
  end object
  componentList.add(Warning_Window_Background)
  
  // Warning components
  begin object class=UI_Label Name=Warning_Header
    tag="Warning_Header"
    bEnabled=true
    posX=0
    posY=225
    posXEnd=NATIVE_WIDTH
    posYEnd=280
    AlignX=CENTER
    AlignY=CENTER
    fontStyle=DEFAULT_LARGE_WHITE
    labelText=""
  end object
  componentList.add(Warning_Header)
  
  // Warning Window
  begin object class=UI_Label Name=Warning_Message_Line_1
    tag="Warning_Message_Line_1"
    bEnabled=true
    posX=0
    posY=320
    posXEnd=NATIVE_WIDTH
    posYEnd=360
    AlignX=CENTER
    AlignY=CENTER
    fontStyle=DEFAULT_SMALL_WHITE
    labelText=""
  end object
  componentList.add(Warning_Message_Line_1)
  
  begin object class=UI_Label Name=Warning_Message_Line_2
    tag="Warning_Message_Line_2"
    bEnabled=true
    posX=0
    posY=348
    posXEnd=NATIVE_WIDTH
    posYEnd=388
    AlignX=CENTER
    AlignY=CENTER
    fontStyle=DEFAULT_SMALL_WHITE
    labelText=""
  end object
  componentList.add(Warning_Message_Line_2)
  
  // Selection Box
  begin object class=UI_Selector Name=Warning_Selection_Box
    tag="Warning_Selection_Box"
    bEnabled=true
    posX=502
    posY=540
    selectionOffset=(x=0,y=70)
    numberOfMenuOptions=2
    hoverCoords(0)=(xStart=507,yStart=545,xEnd=939,yEnd=614)
    hoverCoords(1)=(xStart=507,yStart=615,xEnd=939,yEnd=684)
    
    // Selection texture
    begin object class=UI_Texture_Info Name=Selection_Box_Texture
      componentTextures.add(Texture2D'GUI.Mgmt_Window_Selector')
    end object

    // Selector sprite
    begin object class=UI_Sprite Name=Selector_Sprite
      tag="Selector_Sprite"
      images(0)=Selection_Box_Texture
      activeEffects.add((effectType = EFFECT_ALPHA_CYCLE, lifeTime = -1, elapsedTime = 0, intervalTime = 0.4, min = 170, max = 255))
    end object
    componentList.add(Selector_Sprite)
    
  end object
  componentList.add(Warning_Selection_Box)
}















