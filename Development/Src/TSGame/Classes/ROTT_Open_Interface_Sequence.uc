/*=============================================================================
 * ROTT_Open_Interface_Sequence
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This kismet sequence opens the interface for shrines.
 *===========================================================================*/

class ROTT_Open_Interface_Sequence extends SequenceAction;
 
var(Shrine) protectedwrite RitualTypes donationType;

// Interface arguments
var(Interface) string interfaceTextLine1;
var(Interface) string interfaceTextLine2;

/*=============================================================================
 * activated()
 *
 * Called when the kismet node recieves an impulse, e.g. a trigger is used.
 *===========================================================================*/
event activated() {
  local ROTT_Game_Info gameInfo;
  
  // Get reference
  gameInfo = ROTT_Game_Info(class'WorldInfo'.static.getWorldInfo().game);
  
  if (InputLinks[0].bHasImpulse) {
    // Open interface
    gameInfo.sceneManager.sceneOverWorld.enableMonumentInterface(
      interfaceTextLine1,
      interfaceTextLine2
    );
    
    // Store ritual info
    gameInfo.queuedRitual = donationType;
    
  } else {    
    // Hide interface
    gameInfo.sceneManager.sceneOverWorld.disableMonumentInterface();
  }
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  ObjName="Open_Interface_Sequence"
  ObjCategory="ROTT"
  
  bCallHandler=false
  
  // Input links
  InputLinks(0)=(LinkDesc="Show")
  InputLinks(1)=(LinkDesc="Hide")
}













