/*=============================================================================
 * TSNotifySequence
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Used to show gameplay notifications through kismet
 *===========================================================================*/
class TSNotifySequence extends SequenceAction;

// Message to display
var(ObjectiveRunParams) string sMessage;  

/*=============================================================================
 * Activated()
 *
 * Called when the sequence is activated in kismet
 *===========================================================================*/
event activated() {
  ROTT_Game_Info(class'WorldInfo'.static.GetWorldInfo().Game).showGameplayNotification(sMessage);
}

/*=============================================================================
 * Default properties
 *===========================================================================*/
defaultProperties
{
  ObjName="WorldNotification"
  ObjCategory="TSFunctions"

  sMessage="Hello world"
  bCallHandler=false
  //HandlerName="StartFuelDropRun"
  
}




