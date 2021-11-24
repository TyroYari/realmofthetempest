/*=============================================================================
 * ROTT_UI_Page_Guide
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: 
 *
 *===========================================================================*/
 
class ROTT_UI_Page_Guide extends ROTT_UI_Page;

// Internal references
var private UI_Label header;

/*============================================================================= 
 * initializeComponent()
 *
 * Called once, when the scene is first initialized.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  super.initializeComponent(newTag);
  
  // Internal references
  header = UI_Label(findComp("Guide_Info_Labels"));
}

/*============================================================================= 
 * onPushPageEvent()
 *
 * This event is called every time the page is pushed.
 *===========================================================================*/
event onPushPageEvent() {
  // Render profile information
  refresh();
}

/*=============================================================================
 * onFocusMenu()
 *
 * Called when a menu is given focus.  Assign controls, and enable graphics.
 *===========================================================================*/
event onFocusMenu() {
  
}

/*============================================================================= 
 * refresh()
 *
 * This function should ensure that any data thats been changed will be 
 * correctly updated on the UI.
 *===========================================================================*/
public function refresh() {
  // Render profile information
  ///...
}

/*=============================================================================
 * D-Pad controls
 *===========================================================================*/
public function bool preNavigateUp();
public function bool preNavigateDown();

public function onNavigateLeft();
public function onNavigateRight();

/*=============================================================================
 * Button controls
 *===========================================================================*/
protected function navigationRoutineA() {
  
}

protected function navigationRoutineB() {
  // Sfx
  gameinfo.sfxBox.playSFX(SFX_MENU_BACK);
  
  // Pop this page
  parentScene.popPage();
}

 
/*=============================================================================
 * Assets
 *===========================================================================*/
defaultProperties
{
  bDrawRelative=true
  posX=0
  
  /** ===== Input ===== **/
  begin object class=ROTT_Input_Handler Name=Input_B
    inputName="XBoxTypeS_B"
    buttonComponent=none
  end object
  inputList.add(Input_B)
  
  /** ===== Textures ===== **/
  // Guide Background
  begin object class=UI_Texture_Info Name=Guide_Background
    componentTextures.add(Texture2D'GUI.Guide_Background')
  end object
  
  /** ===== UI Components ===== **/
  // Background
  begin object class=UI_Sprite Name=Background
    tag="Background"
    posX=0
    posY=0
    images(0)=Guide_Background
  end object
  componentList.add(Background)

  // Info
  begin object class=UI_Container Name=Guide_Container
    tag="Guide_Container"
    posX=0
    posY=-32
    bDrawRelative=true
    
    // Info
    begin object class=UI_Label Name=Guide_Info_Labels1A
      tag="Guide_Info_Labels1A"
      posX=40
      posY=201
      AlignX=Left
      AlignY=Top
      fontStyle=DEFAULT_SMALL_RED
      labelText="Recommended Strategy:"
    end object
    componentList.add(Guide_Info_Labels1A)
    
    begin object class=UI_Label Name=Guide_Info_Labels1B
      tag="Guide_Info_Labels1B"
      posX=40
      posY=233
      AlignX=Left
      AlignY=Top
      fontStyle=DEFAULT_SMALL_TAN
      labelText="    Pick your lead skill, note whether damage\n    is physical or elemental."
    end object
    componentList.add(Guide_Info_Labels1B)
    
    begin object class=UI_Label Name=Guide_Info_Labels2A
      tag="Guide_Info_Labels2A"
      posX=40
      posY=301
      AlignX=Left
      AlignY=Top
      fontStyle=DEFAULT_SMALL_GREEN
      labelText="Glyph Recipes"
    end object
    componentList.add(Guide_Info_Labels2A)
    
    begin object class=UI_Label Name=Guide_Info_Labels2B
      tag="Guide_Info_Labels2B"
      posX=40
      posY=333
      AlignX=Left
      AlignY=Top
      fontStyle=DEFAULT_SMALL_TAN
      labelText="    When glyph work becomes a chore,\n    compensate with higher skill levels."
    end object
    componentList.add(Guide_Info_Labels2B)
    
    begin object class=UI_Label Name=Guide_Info_Labels3A
      tag="Guide_Info_Labels3A"
      posX=40
      posY=401
      AlignX=Left
      AlignY=Top
      fontStyle=DEFAULT_SMALL_BLUE
      labelText="Encounter rates:"
    end object
    componentList.add(Guide_Info_Labels3A)
    
    begin object class=UI_Label Name=Guide_Info_Labels3B
      tag="Guide_Info_Labels3B"
      posX=40
      posY=433
      AlignX=Left
      AlignY=Top
      fontStyle=DEFAULT_SMALL_TAN
      labelText="    If troubled by frequent encounters, be sure to\n    enable prayer, and try temporal magick."
    end object
    componentList.add(Guide_Info_Labels3B)
    
    
    begin object class=UI_Label Name=Guide_Info_Labels4A
      tag="Guide_Info_Labels4A"
      posX=40
      posY=501
      AlignX=Left
      AlignY=Top
      fontStyle=DEFAULT_SMALL_PURPLE
      labelText="Teammates:"
    end object
    componentList.add(Guide_Info_Labels4A)
    
    begin object class=UI_Label Name=Guide_Info_Labels4B
      tag="Guide_Info_Labels4B"
      posX=40
      posY=533
      AlignX=Left
      AlignY=Top
      fontStyle=DEFAULT_SMALL_TAN
      labelText="    Complement your lead skill with matching\n    buffs.  (Try Arcane Sigil, Electric Sigil, Fusion,\n    Marble Spirit.)"
    end object
    componentList.add(Guide_Info_Labels4B)
    
    begin object class=UI_Label Name=Guide_Info_Labels5A
      tag="Guide_Info_Labels5A"
      posX=40
      posY=631
      AlignX=Left
      AlignY=Top
      fontStyle=DEFAULT_SMALL_CYAN
      labelText="Enchantments"
    end object
    componentList.add(Guide_Info_Labels5A)
    
    begin object class=UI_Label Name=Guide_Info_Labels5B
      tag="Guide_Info_Labels5B"
      posX=40
      posY=663
      AlignX=Left
      AlignY=Top
      fontStyle=DEFAULT_SMALL_TAN
      labelText="    Be sure to visit the alchemist for a minigame\n    that boosts stat and skill levels."
    end object
    componentList.add(Guide_Info_Labels5B)
    
    begin object class=UI_Label Name=Guide_Info_Labels6A
      tag="Guide_Info_Labels6A"
      posX=40
      posY=733
      AlignX=Left
      AlignY=Top
      fontStyle=DEFAULT_SMALL_WHITE
      labelText="Equipment & Rituals"
    end object
    componentList.add(Guide_Info_Labels6A)
    
    begin object class=UI_Label Name=Guide_Info_Labels6B
      tag="Guide_Info_Labels6B"
      posX=40
      posY=765
      AlignX=Left
      AlignY=Top
      fontStyle=DEFAULT_SMALL_TAN
      labelText="    Items may be given to team members as\n    equipment, or offered at shrines for\n    various stat boosts."
    end object
    componentList.add(Guide_Info_Labels6B)
    
  end object
  componentList.add(Guide_Container)
  
}











