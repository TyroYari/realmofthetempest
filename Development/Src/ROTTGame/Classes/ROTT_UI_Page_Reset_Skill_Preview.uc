/*=============================================================================
 * ROTT_UI_Page_Reset_Skill_Preview
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This shows skill info when resetting skill points
 *===========================================================================*/
 
class ROTT_UI_Page_Reset_Skill_Preview extends ROTT_UI_Page;

// Number of lines of text in this window
const LINE_COUNT = 13;

// Internal references
var private UI_Label descriptionLabels[LINE_COUNT];

/*============================================================================= 
 * initializeComponent()
 *
 * Called once, when the scene is first initialized.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  local int i;
  super.initializeComponent(newTag);
  
  for (i = 0; i < LINE_COUNT; i++) {
    descriptionLabels[i] = findLabel("Mgmt_Window_Label_" $ i);
  }
}

/*============================================================================= 
 * onPushPageEvent()
 *
 * This event is called every time the page is pushed.
 *===========================================================================*/
event onPushPageEvent() {
  refresh();
}

/*============================================================================= 
 * refresh()
 *
 * This should be called when data changes are made that might impact the UI.
 *===========================================================================*/
public function refresh() {
  local ROTT_Descriptor descriptor;
  local ROTT_Combat_Hero hero;
  local int skillID;
  
  // Get skill ID based on selection box
  skillID = parentScene.getSelectedSkill();
  
  // Get hero
  hero = parentScene.getSelectedHero();
  
  // Get skill descriptor
  if (parentScene.isPageInStack("Class_Skilltree_UI")) descriptor = hero.getSkillScript(skillID);
  if (parentScene.isPageInStack("Glyph_Skilltree_UI")) descriptor = hero.getGlyphScript(skillID);
  if (parentScene.isPageInStack("Mastery_Skilltree_UI")) descriptor = hero.getMasteryScript(skillID);
  
  // Set preview info
  setDescriptor(descriptor);
  
}

/*============================================================================= 
 * setDescriptor()
 *
 * This parses a descriptor to update the text displayed in this window
 *===========================================================================*/
public function setDescriptor(ROTT_Descriptor descriptor) {
  local int i;
  if (ROTT_Descriptor_Hero_Skill(descriptor) == none) {
    yellowLog("Warning (!) Descriptor not found.");
    return;
  }
  
  ROTT_Descriptor_Hero_Skill(descriptor).setShowPrevious(true);
  
  // Copy display information to the label components from the descriptor
  for (i = 0; i < LINE_COUNT; i++) {
    descriptionLabels[i].setText(descriptor.displayInfo[i].labelText);
    descriptionLabels[i].setFont(descriptor.displayInfo[i].labelFont);
  }
}

/*=============================================================================
 * Assets
 *===========================================================================*/
defaultProperties
{
  
  /** ===== Textures ===== **/
  // Menu background
  begin object class=UI_Texture_Info Name=Menu_Background
    componentTextures.add(Texture2D'GUI.Blank_Menu_Background')
  end object
  
  // Window background
  begin object class=UI_Texture_Info Name=Service_Window
    componentTextures.add(Texture2D'GUI.Reset_Cost_Window_With_Skill')
  end object
  
  /** ===== UI Components ===== **/
  // Window background
  begin object class=UI_Sprite Name=Menu_Background_Sprite
    tag="Menu_Background_Sprite"
    posX=0
    posY=0
    images(0)=Menu_Background
  end object
  componentList.add(Menu_Background_Sprite)
  begin object class=UI_Sprite Name=Window_Background
    tag="Window_Background"
    posX=0
    posY=0
    images(0)=Service_Window
  end object
  componentList.add(Window_Background)
  
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
  
}