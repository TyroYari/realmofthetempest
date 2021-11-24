/*=============================================================================
 * ROTT_UI_Page_Journal
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This page displays quest entries on journal pages
 *===========================================================================*/

class ROTT_UI_Page_Journal extends ROTT_UI_Page;

/*============================================================================= 
 * Initialize Component
 *
 * Description: This event is called as the UI is loaded.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  super.initializeComponent(newTag);
  
}

/*============================================================================= 
 * onPushPageEvent
 *
 * Description: This event is called every time the page is pushed.
 *===========================================================================*/
event onPushPageEvent() {
  local int journalEntries;
  local int i;
  
  // Fetch number of journal entries, cap at 3
  journalEntries = gameInfo.playerProfile.journalEntries.length;
  if (journalEntries > 3) journalEntries = 3;
  
  // Clear journal text
  findLabel("Journal_Text_1").setText("");
  findLabel("Journal_Text_2").setText("");
  findLabel("Journal_Text_3").setText("");
  
  // Read journal entries
  for (i = 0; i < journalEntries; i++) {
    findLabel("Journal_Text_" $ i + 1).setText(
      gameInfo.playerProfile.journalEntries[i]
    );
  }
}

/*=============================================================================
 * onFocusMenu()
 *
 * Called when a menu is given focus.  Assign controls, and enable graphics.
 *===========================================================================*/
event onFocusMenu() {
  
}
event onUnfocusMenu() {
  
}

/*============================================================================= 
 * onSceneActivation
 *
 * Called when the parent scene is activated
 *===========================================================================*/
public function onSceneActivation() {
  
}

protected function navigationRoutineA() {
  
}

protected function navigationRoutineB() {
  // Update menu status to 'closed'
  ///gameInfo.closeGameMenu();
  parentScene.popPage();
  
  gameInfo.sfxBox.playSfx(SFX_MENU_BACK);
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  ///bMandatoryScaleToWindow=true
  
  /** ===== Input ===== **/
  ///begin object class=ROTT_Input_Handler Name=Input_A
  ///  inputName="XBoxTypeS_A"
  ///  buttonComponent=none
  ///end object
  ///inputList.add(Input_A)
  
  begin object class=ROTT_Input_Handler Name=Input_B
    inputName="XBoxTypeS_B"
    buttonComponent=none
  end object
  inputList.add(Input_B)
  
  // Scene frame
  begin object class=ROTT_UI_Screen_Frame Name=Screen_Frame
    tag="Screen_Frame"
    bEnabled=true
  end object
  componentList.add(Screen_Frame)
  
  /** ===== Textures ===== **/
  // Background
  begin object class=UI_Texture_Info Name=Journal_Background
    componentTextures.add(Texture2D'GUI.Journal.Journal_Background')
  end object
  ///begin object class=UI_Texture_Info Name=Background_Fade
  ///  drawColor=(R=0,G=0,B=0,A=165) 
  ///  componentTextures.add(Texture2D'EngineResources.Black')
  ///end object
  
  /** Visual Page Setup **/
  tag="Journal_Page"
  posX=0
  posY=0
  posXEnd=NATIVE_WIDTH
  posYEnd=NATIVE_HEIGHT
  
  /** ===== UI Components ===== **/
  // Fade
  ///begin object class=UI_Sprite Name=Fade_Sprite
  ///  tag="Fade_Sprite"
  ///  posX=-1440
  ///  posY=-900
  ///  posXEnd=2880
  ///  posYEnd=1800
  ///  images(0)=Background_Fade
  ///end object
  ///componentList.add(Fade_Sprite)
  
  // Background
  begin object class=UI_Sprite Name=Journal_Background_Sprite
    tag="Journal_Background_Sprite"
    posX=0
    posY=0
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    images(0)=Journal_Background
  end object
  componentList.add(Journal_Background_Sprite)
  
  // Text
  begin object class=UI_Label Name=Journal_Text_1
    tag="Journal_Text_1"
    posX=758
    posY=120
    posXEnd=1440
    posYEnd=NATIVE_HEIGHT
    fontStyle=JOURNAL_22_BROWN
    AlignX=LEFT
    AlignY=TOP
    labelText=""
  end object
  componentList.add(Journal_Text_1)
  
  // Text
  begin object class=UI_Label Name=Journal_Text_2
    tag="Journal_Text_2"
    posX=758
    posY=320
    posXEnd=1440
    posYEnd=NATIVE_HEIGHT
    fontStyle=JOURNAL_22_BROWN
    AlignX=LEFT
    AlignY=TOP
    labelText=""
  end object
  componentList.add(Journal_Text_2)
  
  // Text
  begin object class=UI_Label Name=Journal_Text_3
    tag="Journal_Text_3"
    posX=758
    posY=520
    posXEnd=1440
    posYEnd=NATIVE_HEIGHT
    fontStyle=JOURNAL_22_BROWN
    AlignX=LEFT
    AlignY=TOP
    labelText=""
  end object
  componentList.add(Journal_Text_3)
  
}











