/*=============================================================================
 * ROTT_Object
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This is the root of all our classes.
 *===========================================================================*/

class ROTT_Object extends object;

// Parameters used in ROTT_Timers:
const LOOP_OFF = false;     
const LOOP_ON  = true;

// Handy game related references
var privatewrite ROTT_Game_Info gameInfo;
var privatewrite ROTT_Game_Sfx sfxBox;
var privatewrite ROTT_Game_Music jukeBox;
var privatewrite ROTT_UI_Scene_Manager sceneManager;
  
// Include colored debug logs
`include(ROTTColorLogs.h)

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
 * These references must be linked after GUI initialization events
 *===========================================================================*/
public function linkGUIReferences(ROTT_UI_Scene_Manager sceneMgr) {
  sceneManager = sceneMgr;
}

/*=============================================================================
 * copyReferences
 *
 * When called on the leaves of the heap, this recurses upward to copy some
 * useful game references.  
 *
 * (sceneManager is none when this is first called, because the GUI hasnt been
 *  inititalized...)
 *===========================================================================
public function copyReferences(optional ROTT_Object parent = ROTT_Object(outer)) {
  if (parent == none) {
    redlog("(!) Failed to copy references");
    return;
  }
  
  // Recurse if parent has incomplete references
  if (parent.isRefComplete() == false) {
    parent.copyReferences();
  }
  
  // Assign references
  gameInfo = parent.GameInfo;
  sfxBox = parent.SfxBox;
  jukeBox = parent.JukeBox;
}
*/

public function bool isRefComplete() {
  return (gameInfo != none && sfxBox != none && jukeBox != none);
  // Commenting out scene manager check because i think it always fails
  // && sceneManager != none);
}

/*=============================================================================
 * pCase()
 *
 * Takes a string, and outputs the string in "Propercase"
 * https://english.stackexchange.com/questions/15910/what-is-the-verb-that-means-to-capitalize-the-first-letter-of-a-word
 *===========================================================================*/
protected function string pCase(coerce string msg) {
  return caps(left(msg, 1)) $ locs(right(msg, len(msg) - 1));
}

defaultProperties
{
  
}



/**
  Note to self:
  You can access world info like this from non-actors

  foreach class'WorldInfo'.static.GetWorldInfo().AllControllers(class'Controller', C)

**/
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 