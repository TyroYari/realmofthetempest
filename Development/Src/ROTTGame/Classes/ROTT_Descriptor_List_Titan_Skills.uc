/*=============================================================================
 * ROTT_Descriptor_List_Titan_Skills
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * This is the data structure responsible for providing information to the game
 * about titan skills on hero units.
 *
 * The mgmt window uses this to render titan skill info. 
 *===========================================================================*/

class ROTT_Descriptor_List_Titan_Skills extends ROTT_Descriptor_List;

// A list of all skills in this set
enum TitanSkills {
  TITAN_SIPHON,
  TITAN_THRASHER,
  TITAN_ICE_STORM,
  TITAN_BLIZZARD,
  TITAN_OATH,
  TITAN_MEDITATION,
  TITAN_AURORA_FANGS,
  TITAN_FUSION
};

/*============================================================================= 
 * skillReset
 *
 * Called to reset skill data at the start of a new battle
 *===========================================================================*/
public function skillReset() {
  local int i;
  
  for (i = 0; i < TitanSkills.enumCount; i++) {
    ROTT_Descriptor_Hero_Skill(scriptList[i]).skillReset();
  }
}

/*=============================================================================
 * descriptors
 *===========================================================================*/
defaultProperties 
{
  // List of skills in this set
  scriptClasses(TITAN_SIPHON)=class'ROTT_Descriptor_Skill_Titan_Siphon'
  scriptClasses(TITAN_THRASHER)=class'ROTT_Descriptor_Skill_Titan_Iron_Thrasher'
  scriptClasses(TITAN_ICE_STORM)=class'ROTT_Descriptor_Skill_Titan_Ice_Storm'
  scriptClasses(TITAN_BLIZZARD)=class'ROTT_Descriptor_Skill_Titan_Blizzard'
  scriptClasses(TITAN_OATH)=class'ROTT_Descriptor_Skill_Titan_Oath'
  scriptClasses(TITAN_MEDITATION)=class'ROTT_Descriptor_Skill_Titan_Meditation'
  scriptClasses(TITAN_AURORA_FANGS)=class'ROTT_Descriptor_Skill_Titan_Aurora_Fangs'
  scriptClasses(TITAN_FUSION)=class'ROTT_Descriptor_Skill_Titan_Fusion'
  
  /** ================================================================
  Do not attach static objects here, they need to know gameInfo, which
  makes garbage collection a nightmare if they arent dynamic objects
  **===============================================================**/
}







