/*=============================================================================
 * ROTT_UI_Displayer_Victory_Hero
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This displayer shows a heroes combat results (i.e. experience)
 *===========================================================================*/

class ROTT_UI_Displayer_Victory_Hero extends ROTT_UI_Displayer;

// Internal references
var private ROTT_UI_Displayer_Experience expInfo;
var private UI_Sprite classLabel;
var private UI_Label expPoints;
var private UI_Label levelLabel;

/*============================================================================= 
 * initializeComponent
 *
 * This is called as the UI is loaded.  Our initial scene is drawn here.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  linkReferences();
  
  super.initializeComponent(newTag);
  
  // Internal references
  expInfo = ROTT_UI_Displayer_Experience(findComp("Experience_Bar_UI"));;
  classLabel = findSprite("Hero_Class_Label");
  expPoints = findLabel("Experience_Points_Label");
  levelLabel = findLabel("Level_Label");
}

/*=============================================================================
 * validAttachment()
 *
 * Called to check if the displayer attachment is valid. Returns true if it is.
 *===========================================================================*/
protected function bool validAttachment() {
  // This displayer requires a hero attachment
  return (hero != none);
}

/*=============================================================================
 * elapseTimer()
 *
 * Time is passed to non-actors through the scene that contains them
 *===========================================================================*/
public function elapseTimer(float deltaTime, float gameSpeedOverride) {
  super.elapseTimer(deltaTime, gameSpeedOverride);
}

/*=============================================================================
 * updateDisplay()
 *
 * This updates the UI with the info of the attached combat unit.  
 * Returns true when there actually exists a unit to display, false otherwise.
 *===========================================================================*/
public function bool updateDisplay() {
  // Check if parent displayer fails
  if (!super.updateDisplay()) return false;
  
  // Update display info
  classLabel.setDrawIndex(hero.myClass);
  levelLabel.setText("Level " $ hero.level);
  if (hero.bPrepExp) {
    expPoints.setText("+ " $ int(hero.pendingExp - hero.pendingExp * hero.elapsedExpTime));
  } else {
    expPoints.setText("+ 0");
  }
  
  // Successfully drew hero information
  return true;
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  bDrawRelative=true
  
  /** ===== Textures ===== **/
  // Class Names
  begin object class=UI_Texture_Info Name=Class_Label_Wizard
    componentTextures.add(Texture2D'GUI.Encounter_Wizard_Label')
  end object
  begin object class=UI_Texture_Info Name=Class_Label_Valkyrie
    componentTextures.add(Texture2D'GUI.Encounter_Valkyrie_Label')
  end object
  begin object class=UI_Texture_Info Name=Class_Label_Goliath
    componentTextures.add(Texture2D'GUI.Encounter_Goliath_Label')
  end object
  begin object class=UI_Texture_Info Name=Class_Label_Titan
    componentTextures.add(Texture2D'GUI.Encounter_Titan_Label')
  end object
  
  /** ===== UI Components ===== **/
  // Hero Class Label
  begin object class=UI_Sprite Name=Hero_Class_Label
    tag="Hero_Class_Label"
    posX=180
    posY=20
    images(0)=Class_Label_Wizard
    images(WIZARD)=Class_Label_Wizard
    images(TITAN)=Class_Label_Titan
    images(VALKYRIE)=Class_Label_Valkyrie
    images(GOLIATH)=Class_Label_Goliath
  end object
  componentList.add(Hero_Class_Label)
  
  // Exp bar
  begin object class=ROTT_UI_Displayer_Experience Name=Experience_Bar_UI
    tag="Experience_Bar_UI"
    posX=180
    posY=80
    posXend=900
  end object
  componentList.add(Experience_Bar_UI)
  
  // Level label
  begin object class=UI_Label Name=Level_Label
    tag="Level_Label"
    posX=205
    posY=172
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    AlignX=LEFT
    AlignY=TOP
    fontStyle=DEFAULT_SMALL_TAN
    labelText="Level 1"
  end object
  componentList.add(Level_Label)
  
  // Experience
  begin object class=UI_Label Name=Experience_Label
    tag="Experience_Label"
    posX=496
    posY=17
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    AlignX=LEFT
    AlignY=TOP
    fontStyle=DEFAULT_LARGE_TAN
    labelText="Experience Gained:"
  end object
  componentList.add(Experience_Label)
  
  // Experience Points
  begin object class=UI_Label Name=Experience_Points_Label
    tag="Experience_Points_Label"
    posX=0
    posY=17
    posXEnd=1030
    posYEnd=NATIVE_HEIGHT
    AlignX=RIGHT
    AlignY=TOP
    fontStyle=DEFAULT_LARGE_WHITE
    labelText="+ 51263"
  end object
  componentList.add(Experience_Points_Label)
  
  
}




















