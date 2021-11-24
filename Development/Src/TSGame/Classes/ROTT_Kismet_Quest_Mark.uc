/*=============================================================================
 * ROTT_Kismet_Quest_Mark
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This is triggered to update quest info.
 *===========================================================================*/

class ROTT_Kismet_Quest_Mark extends SequenceAction
dependsOn(ROTT_Game_Player_Profile);

// Store target quest variable in kismet
var(Shrine) protectedwrite QuestMarks questMark;

// References
var private ROTT_Game_Info gameInfo;

// Include colored debug logs
`include(ROTTColorLogs.h)

/*=============================================================================
 * activated()
 *
 * Called when the kismet node recieves an impulse
 *===========================================================================*/
event activated() {
  // Get game reference
  gameInfo = ROTT_Game_Info(class'WorldInfo'.static.getWorldInfo().game);
  
  // Execute shrine behavior
  switch (questMark) {
    case HAXLYN_BRIDGE:
      // Open shrine offerings
      gameInfo.playerProfile.markQuest(HAXLYN_BRIDGE, QUEST_MARK_COMPLETE);
      break;
  }
}

/*=============================================================================
 * Default properties
 *===========================================================================*/
defaultProperties
{
  ObjName="QuestMark"
  ObjCategory="ROTT" 
}
















