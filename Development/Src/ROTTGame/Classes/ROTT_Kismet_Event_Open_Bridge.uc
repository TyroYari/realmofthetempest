/*=============================================================================
 * ROTT_Kismet_Event_Open_Bridge
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: Used to open bridge in Haxlyn
 *===========================================================================*/

class ROTT_Kismet_Event_Open_Bridge extends SequenceEvent;

// Include colored debug logs
`include(ROTTColorLogs.h)

/*=============================================================================
 * activated()
 *
 * Called when the kismet node is called from the player
 *===========================================================================*/
event activated()
{
  darkgreenlog("Checking Quest mark");
}

/*=============================================================================
 * Default properties
 *===========================================================================*/
defaultProperties
{
  objName="QuestHaxlynBridge"
  objCategory="ROTT" 
  
  bPlayerOnly=false
  maxTriggerCount=0
}
















