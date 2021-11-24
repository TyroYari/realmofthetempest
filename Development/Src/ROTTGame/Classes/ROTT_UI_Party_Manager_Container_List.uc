/*=============================================================================
 * ROTT_UI_Party_Manager_Container_List
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This class displays any number of parties.  At most 4 are on
 * screen at any time, but a scrolling feature allow an entire list to be
 * displayed.
 *===========================================================================*/
 
class ROTT_UI_Party_Manager_Container_List extends UI_Container;

// Container Positioning
const POS_X = 765;
const POS_Y = 42;

// Animation controls
const LERP_TIME = 0.4;
const LERP_DISTANCE = 280;

// Indices for containers that were hidden
var private array<int> hiddenIndices;

// The containers to display on screen, 3 + 1 extra for transitioning effects
var private ROTT_UI_Party_Manager_Container containers[4];

// Internal references
var private UI_Sprite conscriptionButton;

// Lerping variables
var private float pendingLerpTime;
var private float pendingLerpDistance;

// Tracks which parties will be rendered on screen
var private int partyIndexes[4];

// A reference to the system to be rendered
var private ROTT_Party_System partySys;

/*=============================================================================
 * Initialize Component
 *
 * Description: This event is called as the UI is loaded.
 *              Our initial scene is drawn here.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  local int i;
  
  super.initializeComponent(newTag);
  
  // Search loop for finding party containers
  for (i = 0; i < 4; i++) {
    containers[i] = ROTT_UI_Party_Manager_Container(
      findComp("Party_Manager_Container_" $ i+1)
    );
  }
  
  // Conscription
  conscriptionButton = findSprite("Party_Mgmt_Conscription_Button");
}

/*=============================================================================
 * refreshParties()
 *
 * Refreshes party information
 *===========================================================================*/
public function refreshParties() {
  local int i;
  
  if (partySys == none) return;
  
  // Refresh each party displayer
  for (i = 0; i < 4; i++) {
    if (i < partySys.getNumberOfParties()) {
      containers[i].renderPartyInfo(partySys.getParty(partyIndexes[i]));
    }
  }
}

/*=============================================================================
 * displayParties()
 *
 * The party list passed to this function will be drawn on the screen
 *===========================================================================*/
public function displayParties(ROTT_Party_System partySystem) {
  local int numberOfParties;
  local int i;
  
  partySys = partySystem;
  numberOfParties = partySys.getNumberOfParties();
  
  // Reset custom lerp
  pendingLerpTime = 0;
  pendingLerpDistance = 0;
  
  // Set which containers are enabled
  for (i = 0; i < 4; i++) {
    // Initial positioning
    containers[i].updatePosition(POS_X, POS_Y + LERP_DISTANCE * i);
    partyIndexes[i] = i;
    conscriptionButton.updatePosition( , 46 + (280 * numberOfParties));
    
    // Hide unused containers
    if (i < numberOfParties) {
      containers[i].setEnabled(true);
      containers[i].renderPartyInfo(partySys.getParty(partyIndexes[i]));
    } else {
      containers[i].setEnabled(false);
    }
  }
  
  // Hide offscreen containers
  cullContainers();
}

/*=============================================================================
 * lerpUp()
 *
 * Linear interpolation animation for the entire component upward
 *===========================================================================*/
public function bool lerpUp() {
  // Prevents input from stacking up more than "twice"
  if (pendingLerpDistance <= -LERP_DISTANCE) return false;
  
  pendingLerpTime += LERP_TIME;
  pendingLerpDistance -= LERP_DISTANCE;
  return true;
}

/*=============================================================================
 * lerpDown()
 *
 * Linear interpolation animation for the entire component upward
 *===========================================================================*/
public function bool lerpDown() {
  // Prevents input from stacking up more than "twice"
  if (pendingLerpDistance >= LERP_DISTANCE) return false;
  
  // Set animation info
  pendingLerpTime += LERP_TIME;
  pendingLerpDistance += LERP_DISTANCE;
  return true;
}

/*=============================================================================
 * elapseTimer()
 *
 * Time is passed to non-actors through the scene that contains them.  We also
 * animate containers here.
 *===========================================================================*/
public function elapseTimer(float deltaTime, float gameSpeedOverride) {
  local float deltaY;
  local int i;
  
  super.elapseTimer(deltaTime, gameSpeedOverride);
  
  // Ignore routine if no animation is needed
  if (pendingLerpDistance == 0) return;
  
  // Calculate animation distance for this frame
  deltaY = deltaTime / LERP_TIME * LERP_DISTANCE;
  
  // Cap animation distance as needed
  if (deltaY > Abs(pendingLerpDistance)) {
    deltaY = Abs(pendingLerpDistance);
  }
  
  // Set animation direction
  if (pendingLerpDistance < 0) deltaY *= -1;
  
  // Animate conscription button
  conscriptionButton.shiftY(deltaY);
  
  // Animate containers
  for (i = 0; i < 4; i++) {
    containers[i].shiftY(deltaY);
    
    // Perform cycling effect
    if (containers[i].getY() < POS_Y - LERP_DISTANCE) {
      containers[i].shiftY(LERP_DISTANCE * 4);
      partyIndexes[i] += 4;
    }
    if (containers[i].getY() > POS_Y + LERP_DISTANCE * 3) {
      containers[i].shiftY(-LERP_DISTANCE * 4);
      partyIndexes[i] -= 4;
    }
    containers[i].renderPartyInfo(partySys.getParty(partyIndexes[i]));
  }
  
  // Track progress
  pendingLerpDistance -= int(deltaY);
  
  // Hide offscreen containers
  cullContainers();
}

/*=============================================================================
 * cullContainers()
 *
 * Hides off screen containers
 *===========================================================================*/
public function cullContainers() {
  local int i;
  
  // Check to hide conscription button
  conscriptionButton.setEnabled(conscriptionButton.getY() < 886);
  
  // Check to hide offscreen containers
  for (i = 0; i < 4; i++) {
    if (containers[i].getY() == -238 || containers[i].getY() == 882) {
      containers[i].setEnabled(false);
    } else {
      if (containers[i].bEnabled == true) containers[i].setEnabled(true);
    }
  }
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  /** ===== Textures ===== **/
  // Conscription button
  begin object class=UI_Texture_Info Name=Conscription_Button
    componentTextures.add(Texture2D'GUI.Conscription_Button')
  end object
  
  /** ===== UI Components ===== **/
  // Party Management Display Containers
  begin object class=ROTT_UI_Party_Manager_Container Name=Party_Manager_Container_1
    tag="Party_Manager_Container_1" 
    posX=756
    posY=42
  end object
  componentList.add(Party_Manager_Container_1)
  
  begin object class=ROTT_UI_Party_Manager_Container Name=Party_Manager_Container_2
    tag="Party_Manager_Container_2" 
    posX=756
    posY=322
  end object
  componentList.add(Party_Manager_Container_2)
  
  begin object class=ROTT_UI_Party_Manager_Container Name=Party_Manager_Container_3
    tag="Party_Manager_Container_3" 
    posX=756
    posY=602
  end object
  componentList.add(Party_Manager_Container_3)
  
  begin object class=ROTT_UI_Party_Manager_Container Name=Party_Manager_Container_4
    tag="Party_Manager_Container_4" 
    posX=756
    posY=882
  end object
  componentList.add(Party_Manager_Container_4)
  
  // Conscription Option
  begin object class=UI_Sprite Name=Party_Mgmt_Conscription_Button
    tag="Party_Mgmt_Conscription_Button"
    posX=59
    posY=46
    images(0)=Conscription_Button
  end object
  componentList.add(Party_Mgmt_Conscription_Button)
  
}











