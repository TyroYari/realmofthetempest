/*=============================================================================
 * ROTT_UI_Page_Mgmt_Window_Collectible
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This is the interface for skill management on a glyph skill.
 *===========================================================================*/
 
class ROTT_UI_Page_Mgmt_Window_Collectible extends ROTT_UI_Page_Mgmt_Window;

/*============================================================================= 
 * setDescriptor()
 *
 * This parses a descriptor to update the text displayed in this window
 *===========================================================================*/
public function setDescriptor(ROTT_Descriptor descriptor) {
  local ROTT_Descriptor_Hero_Skill heroScript;
  
  if (descriptor == none) {
    yellowLog("Warning (!) A descriptor still needs to be implemented.");
    return;
  }
  
  super.setDescriptor(descriptor);
  
  // Convert to hero skill script
  heroScript = ROTT_Descriptor_Hero_Skill(descriptor);
  if (heroScript == none) {
    yellowLog("Warning (!) Foreign descriptor provided to skills window. " $ descriptor);
    return;
  }
  
  // Show skill level boost
  if (heroScript.boostLevel != 0) {
    findLabel("Skill_Boost_Label").setText(" ( +" $ heroScript.boostLevel $ " )");
    findLabel("Skill_Boost_Label").setFont(DEFAULT_SMALL_GREEN);
  } else {
    findLabel("Skill_Boost_Label").setText("");
  }
}

/*=============================================================================
 * D-Pad controls
 *===========================================================================*/
public function onNavigateLeft();
public function onNavigateRight();

/*=============================================================================
 * Button controls
 *===========================================================================*/
protected function navigationRoutineA() {
  local ROTT_Combat_Hero hero;
  local byte selection;
  local byte tree;
  
  // Get player's selection info
  hero = parentScene.getSelectedHero();
  selection = someScene.getSelectedSkill();
  tree = someScene.getSelectedtree(); 
  
  // Execute player choice
  switch (selectionBox.getSelection()) {
    case SKILL_INVEST_1: investSkillPoint(hero, tree, selection); break;
  }
}

/*=============================================================================
 * Assets
 *===========================================================================*/
defaultProperties
{
  // Number of menu options
  selectOptionsCount=1
  
  /** ===== Input ===== **/
  begin object class=ROTT_Input_Handler Name=Input_A
    inputName="XBoxTypeS_A"
    buttonComponent=none
  end object
  inputList.add(Input_A)
  
  /** ===== Textures ===== **/
  // Buttons
  begin object class=UI_Texture_Info Name=Button_Invest_1
    componentTextures.add(Texture2D'GUI.Button_Invest_1')
  end object
  begin object class=UI_Texture_Info Name=Info_Button_Collectible
    componentTextures.add(Texture2D'GUI.Info_Button_Collectible')
  end object
  
  /** ===== UI Components ===== **/
  // Buttons
  begin object class=UI_Sprite Name=Button_Invest_1_Sprite
    tag="Button_Invest_1_Sprite"
    posX=132
    posY=544
    images(0)=Button_Invest_1
  end object
  componentList.add(Button_Invest_1_Sprite)
  
  // Info button - Collectible
  begin object class=UI_Sprite Name=Info_Button_Sprite
    tag="Info_Button_Sprite"
    posX=132
    posY=624
    images(0)=Info_Button_Collectible
  end object
  componentList.add(Info_Button_Sprite)
  
  // Skill boost display
  begin object class=UI_Label Name=Skill_Boost_Label
    tag="Skill_Boost_Label"
    posX=450
    posY=297
    posXEnd=720
    posYEnd=NATIVE_HEIGHT
    fontStyle=DEFAULT_SMALL_GREEN
    AlignX=LEFT
    AlignY=TOP
    labelText="(+1)"
  end object
  componentList.add(Skill_Boost_Label)
  
}
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  