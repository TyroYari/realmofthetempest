/*=============================================================================
 * ROTT_UI_Displayer
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This object displays any kind of game information for a game
 * object. (e.g. Hero info in menus, enemy feedback in combat, item info, etc)
 *===========================================================================*/
// UI STATIC DISPLAYER (UI_CONTAINER?)
//  - A DISPLAY COMPOSED OF INTERNALLY REFERENCED UI PARAMETERS
//  - UI PARAMETERS AND CODE SET IN SUBCLASSES 
//  
// UI DYNAMIC DISPLAYER (ROTT_UI_DISPLAYER?)
//  - DISPLAYS INFO FOR A SINGLY SELECTED OBJECT ARGUMENT
//  - IMPLICITLY ENUMERATES ALL DISPLAY POSSIBILITIES FOR THE OBJECT
//  
// UI INTERACTIVE DISPLAYER (UI_WIDGET?)
//  - A COLLETION OF 1 OR MORE STATIC/DYNMIC DISPLAYERS
//  - SUPPORTS INTERACTION FROM THE USER
//  - DELEGATES ALLOW INPUT SET UP IN SUPER CLASS, DYNAMIC LINKS IN SUB.
class ROTT_UI_Displayer extends UI_Container
abstract;

// References
var privatewrite ROTT_Game_Info gameInfo;
var privatewrite ROTT_Game_Sfx sfxBox;
var privatewrite ROTT_Game_Music jukeBox;

// Store the object that is being displayed by this displayer
var protected ROTT_Object displayObject;
  
// Store the object as a combat unit if possible
var protected ROTT_Combat_Unit combatUnit;

// Store the object as hero if possible 
var protected ROTT_Combat_Hero hero;

// Store the object as enemy if possible
var protected ROTT_Combat_Enemy enemy;

// Store the object as a party if possible
var protected ROTT_Party party;

/*=============================================================================
 * These references can be linked during early game events (e.g. InitGame)
 *===========================================================================*/
public function linkReferences() {
  gameInfo = ROTT_Game_Info(class'WorldInfo'.static.getWorldInfo().game);
  sfxBox = ROTT_Game_Sfx(gameInfo.sfxBox);
  jukeBox = gameInfo.jukeBox;

  `assert(gameInfo != none);
}


/*============================================================================= 
 * initializeComponent()
 *
 * This is called as the UI is loaded.  Our initial scene is drawn here.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  super.initializeComponent();
  
  linkReferences(); /// test?
  /** UI Component ties would be set here in subclasses:
  
  ...
  
  **/
}

/*============================================================================= 
 * attachDisplayer()
 *
 * Used to link this displayer to a given game object
 *===========================================================================*/
public function attachDisplayer(ROTT_Object attachObject) {
  // Detatch if nothing given
  if (attachObject == none) { detachDisplayer(); return; }
  
  // Set the reference
  displayObject = attachObject;
  
  // Attempt to store specific unit types
  combatUnit = ROTT_Combat_Unit(attachObject);
  hero = ROTT_Combat_Hero(attachObject);
  enemy = ROTT_Combat_Enemy(attachObject);
  party = ROTT_Party(attachObject);
  
  // Check validity of attachment
  if (!validAttachment()) {
    yellowLog("Warning (!) Cannot attach \"" $ attachObject $ "\" to: " $ self);
    return;
  }
  
  // Update the displayer
  attachmentUpdate();
}

/*============================================================================= 
 * detachDisplayer()
 *
 * Used to unlink this displayer from its object attachment
 *===========================================================================*/
public function detachDisplayer() {
  // Remove the reference
  displayObject = none;
  
  // Clear subtype references
  hero = none;
  enemy = none;
  party = none;
  
  // Update the displayer
  attachmentUpdate();
}
  
/*=============================================================================
 * validAttachment()
 *
 * Called to check if the displayer attachment is valid. Returns true if it is.
 *===========================================================================*/
protected function bool validAttachment() {
  // Implement validity check in subclasses
  yellowLog("Warning (!) No validity check for displayer " $ self);
  return true;
}

/*=============================================================================
 * attachmentUpdate()
 *
 * Called when a new object is attached
 *===========================================================================*/
protected function attachmentUpdate() {
  local int i;
  
  // Copy the same attachment reference in children by default
  for (i = 0; i < componentList.length; i++) {
    if (ROTT_UI_Displayer(componentList[i]) != none) {
      ROTT_UI_Displayer(componentList[i]).attachDisplayer(displayObject);
    }
  }
  
  updateDisplay();
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
 * This updates the UI with the info of the attached object.  
 * Returns true when there actually exists a unit to display, false otherwise.
 *===========================================================================*/
public function bool updateDisplay() {
  local int i;
  
  // Show or hide based on the unit existing
  setEnabled(displayObject != none);
  
  // Exit if attached object does not exist
  if (displayObject == none) return false;
  
  // Update graphics for the units info
  for (i = 0; i < componentList.length; i++) {
    if (displayObject != none) { 
      if (ROTT_UI_Displayer(componentList[i]) != none) {
        ROTT_UI_Displayer(componentList[i]).updateDisplay();
      }
    }
  }
  
  // Successfully information
  return true;
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  
}














