/*=============================================================================
 * ROTT_Descriptor_List_Goliath_Skills
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * This is the data structure responsible for providing information to the game
 * about goliath skills on hero units.
 *
 * The mgmt window uses this to render goliath skill info. 
 *===========================================================================*/

class ROTT_Descriptor_List_Goliath_Skills extends ROTT_Descriptor_List;

// A list of all skills in this set
enum GoliathSkills {
  GOLIATH_STONE_STRIKE,
  GOLIATH_INTIMIDATION,
  GOLIATH_EARTHQUAKE,
  GOLIATH_DEMOLISH,         
  GOLIATH_OBSIDIAN_SPIRIT,           
  GOLIATH_COUNTER_GLYPHS,
  GOLIATH_MARBLE_SPIRIT, 
  GOLIATH_AVALANCHE,
  
  GOLIATH_EARTHQUAKE_DEBUFF,
};

/*============================================================================= 
 * skillReset
 *
 * Called to reset skill data at the start of a new battle
 *===========================================================================*/
///public function skillReset() {
///  local int i;
///  
///  for (i = 0; i < GoliathSkills.enumCount; i++) {
///    ROTT_Descriptor_Hero_Skill(scriptList[i]).skillReset();
///  }
///}

/*=============================================================================
 * descriptors
 *===========================================================================*/
defaultProperties 
{
  // List of skills in this set
  scriptClasses(GOLIATH_STONE_STRIKE)=class'ROTT_Descriptor_Skill_Goliath_Stone_Strike'
  scriptClasses(GOLIATH_INTIMIDATION)=class'ROTT_Descriptor_Skill_Goliath_Intimidation'
  scriptClasses(GOLIATH_EARTHQUAKE)=class'ROTT_Descriptor_Skill_Goliath_Earthquake'
  scriptClasses(GOLIATH_DEMOLISH)=class'ROTT_Descriptor_Skill_Goliath_Demolish'
  scriptClasses(GOLIATH_COUNTER_GLYPHS)=class'ROTT_Descriptor_Skill_Goliath_Counter_Glyph'
  scriptClasses(GOLIATH_OBSIDIAN_SPIRIT)=class'ROTT_Descriptor_Skill_Goliath_Obsidian_Spirit'
  scriptClasses(GOLIATH_AVALANCHE)=class'ROTT_Descriptor_Skill_Goliath_Avalanche'
  scriptClasses(GOLIATH_MARBLE_SPIRIT)=class'ROTT_Descriptor_Skill_Goliath_Marble_Spirit'
  scriptClasses(GOLIATH_EARTHQUAKE_DEBUFF)=class'ROTT_Descriptor_Skill_Goliath_Earthquake_Debuff'
  
  /** ================================================================
  Do not attach static objects here, they need to know gameInfo, which
  makes garbage collection a nightmare if they arent dynamic objects
  **===============================================================**/
}







