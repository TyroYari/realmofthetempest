/*=============================================================================
 * ROTT_UI_Page_Alchemy_Instructions
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: Displays the results of the alchemy mini-game.
 *===========================================================================*/
 
class ROTT_UI_Page_Alchemy_Instructions extends ROTT_UI_Page;


/*============================================================================= 
 * onPushPageEvent()
 *
 * This event is called every time the page is pushed.
 *===========================================================================*/
event onPushPageEvent() {
  findSprite("Instruction_Fade_In").clearEffects();
  addEffectToComponent(FADE_OUT, "Instruction_Fade_In", 0.5);
}

/*=============================================================================
 * continueToMenu()
 *
 * Called when any inputs given on the instruction page
 *===========================================================================*/
public function continueToMenu() {
  parentScene.popPage(tag);
  parentScene.pushPageByTag("Page_Alchemy_Menu");
}

/*============================================================================*
 * Button controls
 *===========================================================================*/
protected function navigationRoutineA() {
  continueToMenu();
}

protected function navigationRoutineB() {
  continueToMenu();
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
  
  /** ===== Texture ===== **/
  // Background
  begin object class=UI_Texture_Info Name=Instructions_Background
    componentTextures.add(Texture2D'ROTT_Alchemy.Service.Alchemy_Instructions_Background')
  end object
  
  /** ===== Components ===== **/
  // Background
  begin object class=UI_Sprite Name=Alchemy_Instructions_Background
    tag="Alchemy_Instructions_Background"
    posX=0
    posY=0
    images(0)=Instructions_Background
  end object
  componentList.add(Alchemy_Instructions_Background)
  
  // Black layer
  begin object class=UI_Texture_Info Name=Black_Texture
    componentTextures.add(Texture2D'GUI.Black_Square')
  end object
  
  // Fade effects
  begin object class=UI_Sprite Name=Background_Darkening
    tag="Background_Darkening"
    posX=0
    posY=0
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    images(0)=Black_Texture
    drawColor=(r=255,g=255,b=255,a=25)
  end object
  componentList.add(Background_Darkening)
  
  // 
  begin object class=UI_Label Name=Alchemy_Instruction_Label_H1
    tag="Alchemy_Instruction_Label_H1"
    posX=0
    posY=-124
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    fontStyle=DEFAULT_LARGE_GOLD
    labelText="Instructions"
    alignX=CENTER
    alignY=CENTER
  end object
  componentList.add(Alchemy_Instruction_Label_H1)
  
  // 
  begin object class=UI_Label Name=Alchemy_Instruction_Label_1
    tag="Alchemy_Instruction_Label_1"
    posX=0
    posY=8
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    fontStyle=DEFAULT_MEDIUM_PEACH
    labelText="You must imbue each tile with magic, while"
    alignX=CENTER
    alignY=CENTER
  end object
  componentList.add(Alchemy_Instruction_Label_1)
  
  // 
  begin object class=UI_Label Name=Alchemy_Instruction_Label_2
    tag="Alchemy_Instruction_Label_2"
    posX=0
    posY=128
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    fontStyle=DEFAULT_MEDIUM_PEACH
    labelText="avoiding tiles that overheat."
    alignX=CENTER
    alignY=CENTER
  end object
  componentList.add(Alchemy_Instruction_Label_2)
  
  // Fade effects
  begin object class=UI_Sprite Name=Instruction_Fade_In
    tag="Instruction_Fade_In"
    posX=0
    posY=0
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    images(0)=Black_Texture
    drawColor=(r=255,g=255,b=255,a=50)
  end object
  componentList.add(Instruction_Fade_In)
  
}























