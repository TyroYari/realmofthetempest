/*=============================================================================
 * ROTT_Descriptor_List_Mastery_Skills
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * This is the data structure responsible for providing information to the game
 * about mastery skills on hero units.
 *
 * The mgmt window uses this to render mastery skill info. 
 *===========================================================================*/

class ROTT_Descriptor_List_Mastery_Skills extends ROTT_Descriptor_List;

// Mastery Skills
enum MasterySkills {
  MASTERY_ARMOR,
  MASTERY_LIFE,
  MASTERY_MANA,
  MASTERY_DAMAGE,
  MASTERY_REJUV,
  MASTERY_SPEED,
  MASTERY_DODGE,
  MASTERY_ACCURACY,
  MASTERY_RESURRECT,
  MASTERY_OMNI_SEEKER,
};

/*=============================================================================
 * descriptors
 *===========================================================================*/
defaultProperties 
{
  // List of skills in this set
  scriptClasses(MASTERY_ARMOR)=class'ROTT_Descriptor_Skill_Mastery_Armor'
  scriptClasses(MASTERY_LIFE)=class'ROTT_Descriptor_Skill_Mastery_Life'
  scriptClasses(MASTERY_MANA)=class'ROTT_Descriptor_Skill_Mastery_Mana'
  scriptClasses(MASTERY_DAMAGE)=class'ROTT_Descriptor_Skill_Mastery_Damage'
  scriptClasses(MASTERY_REJUV)=class'ROTT_Descriptor_Skill_Mastery_Rejuv'
  scriptClasses(MASTERY_SPEED)=class'ROTT_Descriptor_Skill_Mastery_Speed'
  scriptClasses(MASTERY_DODGE)=class'ROTT_Descriptor_Skill_Mastery_Dodge'
  scriptClasses(MASTERY_ACCURACY)=class'ROTT_Descriptor_Skill_Mastery_Accuracy'
  scriptClasses(MASTERY_RESURRECT)=class'ROTT_Descriptor_Skill_Mastery_Resurrect'
  scriptClasses(MASTERY_OMNI_SEEKER)=class'ROTT_Descriptor_Skill_Mastery_Omni_Seeker'
  
  /** ================================================================
  Do not attach static objects here, they need to know gameInfo, which
  makes garbage collection a nightmare if they arent dynamic objects
  **===============================================================**/
}







