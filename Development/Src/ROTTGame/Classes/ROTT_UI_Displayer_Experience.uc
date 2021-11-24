/*=============================================================================
 * ROTT_UI_Displayer_Experience
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This class displays the experience information for a hero.
 *===========================================================================*/

class ROTT_UI_Displayer_Experience extends ROTT_UI_Displayer;

// Internal references
var private ROTT_UI_Displayer_Stat_Bar expBar;   
var private UI_Label expCurrent; 
var private UI_Label expNextLevel; 

/*============================================================================= 
 * Initialize Component
 *
 * Description: This event is called as the UI is loaded.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  super.initializeComponent(newTag);
  
  expCurrent = findLabel("Experience_Current_Label");
  expNextLevel = findLabel("Experience_To_Next_Level_Label");
  expBar = ROTT_UI_Displayer_Stat_Bar(findComp("Experience_Bar"));
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
 * updateDisplay()
 *
 * This updates the UI with the info of the attached combat unit.  
 * Returns true when there actually exists a unit to display, false otherwise.
 *===========================================================================*/
public function bool updateDisplay() {
  // Check if parent displayer fails
  if (!super.updateDisplay()) return false;
  
  // Update exp text
  expCurrent.setText(int(hero.getScreenExp()));
  expNextLevel.setText(hero.getNextLvlExp());
  
  // Successfully drew hero information
  return true;
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  // Container draw settings
  bDrawRelative=true
  
  /** ===== Textures ===== **/
  // Frame graphics
  begin object class=UI_Texture_Info Name=Experience_Bar_Back_Texture
    componentTextures.add(Texture2D'GUI.Experience_Bar_Back')
  end object
  begin object class=UI_Texture_Info Name=Experience_Bar_Frame_Texture
    componentTextures.add(Texture2D'GUI.Experience_Bar_Frame')
  end object
  
  // Bar graphics
  begin object class=UI_Texture_Info Name=Stat_Tube_EXP
    componentTextures.add(Texture2D'GUI.Stat_Tube_EXP')
  end object
  
  /** ===== Components ===== **/
  // Backing graphic
  begin object class=UI_Sprite Name=Experience_Bar_Back
    tag="Experience_Bar_Back"
    bEnabled=true
    posX=63
    posY=28
    //bStretch=false
    images(0)=Experience_Bar_Back_Texture
  end object
  componentList.add(Experience_Bar_Back)
  
  // Bar graphic
  begin object class=ROTT_UI_Displayer_Stat_Bar Name=Experience_Bar
    tag="Experience_Bar"
    bEnabled=true
    posX=75
    posY=42
    statBarLength=576
    statBarHeight=16
    statType=HERO_EXP_BAR
  end object
  componentList.add(Experience_Bar)
  
  // Frame overlay
  begin object class=UI_Sprite Name=Experience_Bar_Frame
    tag="Experience_Bar_Frame"
    posX=63
    posY=28
    //bStretch=false
    images(0)=Experience_Bar_Frame_Texture
  end object
  componentList.add(Experience_Bar_Frame)
  
  // Next level info
  begin object class=UI_Label Name=Experience_To_Next_Level_Label
    tag="Experience_To_Next_Level_Label"
    bRelativeEnd=true
    posX=25 
    posY=0
    posXEnd=-29
    posYEnd=0
    AlignX=RIGHT
    AlignY=TOP
    fontStyle=DEFAULT_SMALL_WHITE
    labelText="31,658"
  end object
  componentList.add(Experience_To_Next_Level_Label)
  
  // Current exp info
  begin object class=UI_Label Name=Experience_Current_Label
    tag="Experience_Current_Label"
    posX=0
    posY=70
    posXEnd=720
    AlignX=CENTER
    AlignY=TOP
    fontStyle=DEFAULT_SMALL_WHITE
    labelText="16,341"
  end object
  componentList.add(Experience_Current_Label)
  
  // "Experience" Label
  begin object class=UI_Label Name=Experience_Heading_Label
    tag="Experience_Heading_Label"
    posX=25
    posY=0
    AlignX=LEFT
    AlignY=TOP
    fontStyle=DEFAULT_SMALL_WHITE
    labelText="Experience"
  end object
  componentList.add(Experience_Heading_Label)
  
}













