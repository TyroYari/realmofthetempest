/*=============================================================================
 * ROTT_UI_Status_Label
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * This label displays the status of a combat unit, cycling if multiple status
 *===========================================================================*/

class ROTT_UI_Status_Label extends ROTT_UI_Displayer;

// Internal references
var private UI_Label statusLabel;

struct StatusInfo {
  var string statusText;
  var FontStyles statusColor;
};

// Display mechanics
var private array<StatusInfo> statusList;
var private int displayIndex;

// Status cycling timer
var private float effectTime; 
var private float displayTime; 

// Display alignment
var private bool bAlignXCenter; 

/*============================================================================= 
 * initializeComponent
 *
 * This is called as the UI is loaded.  Our initial scene is drawn here.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  super.initializeComponent(newTag);
  
  // Internal references
  statusLabel = UI_Label(findComp("Status_Label"));
  
  // Fit label to displayer bounds
  statusLabel.updatePosition(getX(), getY(), getXEnd(), getYEnd());
  
  if (bAlignXCenter) {
    statusLabel.alignX = CENTER;
  } else {
    statusLabel.alignX = LEFT;
    statusLabel.alignY = BOTTOM;
  }
}

/*============================================================================= 
 * reset()
 *
 * Called to clear all information on this component
 *===========================================================================*/
public function reset() {
  // Reset timers
  effectTime = 0;
  displayTime = 0;
  
  // Clear effects
  statusLabel.resetEffects();
  statusLabel.setText("");
  
  // Empty status display
  statusList.length = 0;
}
 
/*=============================================================================
 * validAttachment()
 *
 * Called to check if the displayer attachment is valid. Returns true if it is.
 *===========================================================================*/
protected function bool validAttachment() {
  // This displayer requires a hero or enemy attachment
  return (combatUnit != none);
}

/*=============================================================================
 * checkStatus()
 *
 * Returns true if the given tag is already up
 *===========================================================================*/
public function bool checkStatus(string statusTag) {
  local int i;
  
  // Search for status tag
  for (i = 0; i < statusList.length; i++) {
    if (statusList[i].statusText == statusTag) return true;
  }
  
  return false;
}

/*=============================================================================
 * addStatus()
 *
 * Called to add a status to be displayed in by this label
 *===========================================================================*/
public function addStatus(string statusTag, FontStyles statusColor) {
  local StatusInfo status;
  
  // Filter empty status info
  if (statusTag == "") return;
  if (checkStatus(statusTag)) {
    yellowLog("Warning (!) Duplicate status attempt on " $ statusTag);
    return;
  }
  
  // Assemble status info
  status.statusText = statusTag;
  status.statusColor = statusColor;
  
  // Add status to the list
  statusList.addItem(status);
  if (statusList.length == 1) displayNextStatus();
  
  // Check if the cycle timer is inactive
  if (!(effectTime > 0)) {
    startEffectCycle();
  }
}

/*=============================================================================
 * removeStatus()
 *
 * Called to remove a status from being displayed by this label
 *===========================================================================*/
public function removeStatus(ROTT_Descriptor_Hero_Skill skillInfo) {
  // Ignore empty requests
  if (skillInfo == none) return;
  if (skillInfo.statusTag == "") return;
  
  // Remove status manually
  removeStatusManually(skillInfo.statusTag);
}

/*=============================================================================
 * removeStatusManually()
 *
 * Removes a status given the tag, rather than the skill descriptor
 *===========================================================================*/
public function removeStatusManually(string statusTag) {
  local int i;
  
  // Ignore empty requests
  if (statusTag == "") return;
  
  // Loop through each status
  for (i = 0; i < statusList.length; i++) {
    // Check if status matches
    if (statusList[i].statusText == statusTag) {
      // Remove status
      statusList.remove(i, 1);
      
      // Check if this status was being displayed
      if (i == displayIndex) {
        // Clear effects
        statusLabel.resetEffects();
        
        // Move display index forward
        displayNextStatus();
        
        // Check if more effects should be applied
        if (statusList.length > 0) {
          startEffectCycle();
        }
      }
      
      // Remove effect timers if no status left
      if (statusList.length == 0) {
        reset();
      }
      return;
    }
  }
  yellowLog("Warning (!) failed to find status: " $ statusTag);
}

/*=============================================================================
 * removeAllStatus()
 *
 * Called to remove a status from being displayed by this label
 *===========================================================================*/
public function removeAllStatus() {
  // Remove status
  statusList.length = 0;
  reset();
}

/*=============================================================================
 * elapseTimer()
 *
 * Increments time every engine tick.
 *===========================================================================*/
public function elapseTimer(float deltaTime, float gameSpeedOverride) {
  super.elapseTimer(deltaTime, gameSpeedOverride);
  
  // Track timers
  if (effectTime > 0) {
    effectTime -= deltaTime;
    if (effectTime <= 0) effectTimerTick();
  }
  if (displayTime > 0) {
    displayTime -= deltaTime;
    if (displayTime <= 0) displayTimerTick();
  }
  
}

/*=============================================================================
 * startEffectCycle()
 *
 * Called when effect to fade in begins
 *===========================================================================*/
public function startEffectCycle() {
  if (statusList.length == 0) return;
  
  // Check if we need to cycle
  if (statusList.length > 1) {
    // Start effects
    statusLabel.addEffectToQueue(FADE_OUT, 0.5);
    statusLabel.addEffectToQueue(FADE_IN, 0.5);
    statusLabel.addEffectToQueue(DELAY, 1);
    
    // Start timer
    effectTime = 2.0;
    
    // Display switch timer
    displayTime = 0.5;
  } else {
    // Start effects
    ///statusLabel.setAlpha(0);
    statusLabel.addEffectToQueue(FADE_IN, 0.5);
    statusLabel.addEffectToQueue(DELAY, 1);
    
    // Start timer
    effectTime = 1.5;
  }
}


/*=============================================================================
 * effectTimerTick()
 *
 * Called when an effect timer completes.
 *===========================================================================*/
public function effectTimerTick() {
  // Do nothing if no cycling is needed
  if (statusList.length == 1) return;

  // Start effects
  statusLabel.addEffectToQueue(FADE_OUT, 0.5);
  statusLabel.addEffectToQueue(FADE_IN, 0.5);
  statusLabel.addEffectToQueue(DELAY, 1);
  
  // Start timer
  effectTime = 2.0;
  
  // Display switch timer
  displayTime = 0.5;

}

/*=============================================================================
 * displayTimerTick()
 *
 * Called when the display timer ticks
 *===========================================================================*/
public function displayTimerTick() {
  // Draw next status
  displayNextStatus();
}

/*=============================================================================
 * displayNextStatus()
 *
 * Changes the status text to the next status
 *===========================================================================*/
public function displayNextStatus() {
  // Clear label if no status
  if (statusList.length == 0) {
    statusLabel.setText("");
    displayIndex = 0;
    return;
  }
  
  // Move index forward
  displayIndex++;
  displayIndex = displayIndex % statusList.length;
  
  // Set status text
  statusLabel.setText(statusList[displayIndex].statusText);
  
  // Set status font
  statusLabel.setFont(statusList[displayIndex].statusColor);
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
  
  // Successfully drew hero information
  return true;
}

  
/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  bAlignXCenter=true
  
  // Status label
  begin object class=UI_Label Name=Status_Label
    tag="Status_Label"
    alignX=CENTER
    alignY=CENTER
  end object
  componentList.add(Status_Label)
  
}




































