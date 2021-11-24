/**=============================================================================
 * ROTT_UI_Displayer_Party
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This object displays the players party status info at the top
 * of the 3D World HUD.
 * (See: ROTT_Party.uc)
 *
 *===========================================================================*/

class ROTT_UI_Displayer_Party extends ROTT_UI_Displayer;

// Dynamic class for portrait displays
var class<ROTT_UI_Displayer> displayerClass; 
 
// UI Component Info and Party Data
var private ROTT_UI_Displayer heroDisplays[3];
var private int xSeparator;
var private int ySeparator;

// Toggleable Lerping
var private bool bLerpToShow;       // true for forward, false for backward
var private int lerpStep;           // [Zero to maxLerpStep]
var private int maxLerpStep;        // Maximum number of frames to lerp
var private int lerpStepDistance;   // Length in pixels to lerp each step

/*=============================================================================
 * initializeComponent()
 *  
 * Sets up display positions
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  local int i;
  
  super.initializeComponent(newTag);
  
  for (i = 0; i < 3; i++) {
    // References
    heroDisplays[i] = new(self) displayerClass;
    componentList.addItem(heroDisplays[i]);
    heroDisplays[i].bMandatoryScaleToWindow = bMandatoryScaleToWindow;
    heroDisplays[i].initializeComponent("Over_World_Party_Displayer_" $ i + 1);
    
    // Positioning
    heroDisplays[i].updatePosition(
      getX() + (xSeparator*i),
      getY() + (ySeparator*i)
    );
  }
}

/*=============================================================================
 * validAttachment()
 *
 * Called to check if the displayer attachment is valid. Returns true if it is.
 *===========================================================================*/
protected function bool validAttachment() {
  // This displayer requires a party attachment
  return (party != none);
}

/*=============================================================================
 * attachmentUpdate()
 *
 * Called when a new object is attached
 *===========================================================================*/
protected function attachmentUpdate() {
  local int i;
  
  /* Warning: if other displayers are children they are being skipped here */
  
  // Attach this party's heroes to their displayers
  for (i = 0; i < 3; i++) {
    heroDisplays[i].attachDisplayer(party.getHero(i));
  }
  
  updateDisplay();
}

/*============================================================================= 
 * switchbLerpToShow
 *
 * 
 *===========================================================================*/
public function setLerpToShow(bool bShow) { 
  bLerpToShow = bShow;
}

/*============================================================================= 
 * doLerpStep
 *
 * 
 *===========================================================================*/
public function doLerpStep() { 
  switch (bLerpToShow) {
    case true: // Forward
      if (lerpStep < maxLerpStep) {
        lerpStep++;
        shiftY(lerpStepDistance);
      }
      break;
    case false: // Backward
      if (lerpStep > 0) {
        lerpStep--;
        shiftY(-lerpStepDistance);
      }
      break;
  }
}

/*=============================================================================
 * elapseTimer()
 *
 * Time is passed to non-actors through the scene that contains them
 *===========================================================================*/
public function elapseTimer(float deltaTime, float gameSpeedOverride) {
  super.elapseTimer(deltaTime, gameSpeedOverride);
  doLerpStep();
}

/*=============================================================================
 * Default properties
 *===========================================================================*/
defaultProperties 
{
  // Default positioning
  posX=361
  posY=25
  xSeparator=238
  ySeparator=0
  
  // Default Lerping
  lerpStepDistance=10
  maxLerpStep=15
  bLerpToShow=false
  
}







