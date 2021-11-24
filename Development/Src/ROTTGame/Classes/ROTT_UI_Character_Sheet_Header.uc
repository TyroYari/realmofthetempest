/*=============================================================================
 * ROTT_UI_Character_Sheet_Header
 *
 * Author: Otay
 * Bramble Gate Studios (All Downs reserved)
 *
 * Description: This contains the labels that display text at the top of each
 * characer sheet.  (Stats page, and all skill trees)
 *===========================================================================*/
 
class ROTT_UI_Character_Sheet_Header extends UI_Container;

var private UI_Label mainLeftLabel;
var private UI_Label subLeftLabel;
var private UI_Label bottomLeftLabel;

var private UI_Label mainRightLabel;
var private UI_Label subRightLabel;

/*=============================================================================
 * Initialize Component
 *
 * Description: This event is called as the UI is loaded.
 *              Our initial scene is drawn here.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  super.initializeComponent(newTag);
  
  mainLeftLabel = UI_Label(findComp("Main_Label_Left_Side"));
  subLeftLabel = UI_Label(findComp("Sub_Label_Left_Side"));
  bottomLeftLabel = UI_Label(findComp("Sub_Label_2_Left_Side"));
  
  mainRightLabel = UI_Label(findComp("Main_Label_Right_Side"));
  subRightLabel = UI_Label(findComp("Sub_Label_Right_Side"));
}

/*============================================================================*
 * setDisplayInfo()
 *===========================================================================*/
public function setDisplayInfo
(
  coerce string leftTop,
  coerce string leftMiddle,
  coerce string leftBottom,
  coerce string rightTop,
  coerce string rightBottom
) 
{
  // Set top left information
  mainLeftLabel.setText(leftTop);
  subLeftLabel.setText(leftMiddle);
  bottomLeftLabel.setText(leftBottom);
  
  // Set top right information
  mainRightLabel.setText(rightTop);
  subRightLabel.setText(rightBottom);
  
  // Set colors
  if (bottomLeftLabel.labelText == "R.I.P.") {
    bottomLeftLabel.setFont(DEFAULT_SMALL_RED);
  } else {
    bottomLeftLabel.setFont(DEFAULT_SMALL_BLUE);
  }
}

/*============================================================================*
 * Assets
 *===========================================================================*/
defaultProperties
{
  /** ===== UI Components ===== **/
  // Main label - Left side
  begin object class=UI_Label Name=Main_Label_Left_Side
    tag="Main_Label_Left_Side"
    posX=770
    posY=35
    posXEnd=NATIVE_WIDTH
    posYEnd=90
    AlignX=LEFT
    AlignY=CENTER
    fontStyle=DEFAULT_MEDIUM_WHITE
    labelText="Valkyrie"
    padding=(top=0, left=0, right=0, bottom=6)
  end object
  componentList.add(Main_Label_Left_Side)
  
  // Sub label - Left side
  begin object class=UI_Label Name=Sub_Label_Left_Side
    tag="Sub_Label_Left_Side"
    posX=770
    posY=109
    posXEnd=NATIVE_WIDTH
    posYEnd=90
    AlignX=LEFT
    AlignY=CENTER
    fontStyle=DEFAULT_SMALL_TAN
    labelText="Level 5"
    padding=(top=0, left=0, right=0, bottom=6)
  end object
  componentList.add(Sub_Label_Left_Side)
  
  // Sub label - Left side
  begin object class=UI_Label Name=Sub_Label_2_Left_Side
    tag="Sub_Label_2_Left_Side"
    posX=770
    posY=142
    posXEnd=NATIVE_WIDTH
    posYEnd=123
    AlignX=LEFT
    AlignY=CENTER
    fontStyle=DEFAULT_SMALL_BLUE
    labelText="Blessings: 5"
    padding=(top=0, left=0, right=0, bottom=6)
  end object
  componentList.add(Sub_Label_2_Left_Side)
  
  // Main label - Right side
  begin object class=UI_Label Name=Main_Label_Right_Side
    tag="Main_Label_Right_Side"
    posX=1165
    posY=43
    posXEnd=1404
    posYEnd=90
    AlignX=CENTER
    AlignY=CENTER
    fontStyle=DEFAULT_MEDIUM_GOLD
    labelText="Stat Points"
    
    // Cycle effects
    activeEffects.add((effectType=EFFECT_FLIPBOOK, lifeTime=-1, elapsedTime=0, intervalTime=0.1, min=0, max=255))
    cycleStyles=(DEFAULT_MEDIUM_GOLD, DEFAULT_MEDIUM_PEACH)
  end object
  componentList.add(Main_Label_Right_Side)
  
  // Sub label - Right side
  begin object class=UI_Label Name=Sub_Label_Right_Side
    tag="Sub_Label_Right_Side"
    posX=1165
    posY=86
    posXEnd=1404
    posYEnd=90
    AlignX=CENTER
    AlignY=TOP
    fontStyle=DEFAULT_MEDIUM_GOLD
    labelText="10"
    
    // Cycle effects
    activeEffects.add((effectType=EFFECT_FLIPBOOK, lifeTime=-1, elapsedTime=0, intervalTime=0.1, min=0, max=255))
    cycleStyles=(DEFAULT_MEDIUM_GOLD, DEFAULT_MEDIUM_PEACH)
  end object
  componentList.add(Sub_Label_Right_Side)
  
}
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  