/*=============================================================================
 * ROTT_Kismet_Event_Shrine_Use
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This kismet event is triggered through using the shrine.
 * It should connect to a is done in ROTT_Kismet_Event_Shrine_Use for dependency 
 * reasons.
 *===========================================================================*/

class ROTT_Kismet_Event_Shrine_Use extends SequenceEvent;

// Include colored debug logs
`include(ROTTColorLogs.h)

/*=============================================================================
 * activated()
 *
 * Called when the kismet node is called from the player
 *===========================================================================*/
event activated()
{
  darkgreenlog("Executing shrine event operations");
}

/*=============================================================================
 * Default properties
 *===========================================================================*/
defaultProperties
{
  objName="ShrineEvent"
  objCategory="ROTT" 
  
  bPlayerOnly=false
  maxTriggerCount=0
}
















