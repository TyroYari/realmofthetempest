/*=============================================================================
 * ROTT_Descriptor_List_Valkyrie_Skills
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * This is the data structure responsible for providing information to the game
 * about valkyrie skills on hero units.
 *
 * The mgmt window uses this to render valkyrie skill info. 
 *===========================================================================*/

class ROTT_Descriptor_List_Valkyrie_Skills extends ROTT_Descriptor_List;

// A list of all skills in this set
enum ValkyrieSkills {
  VALKYRIE_VALOR_STRIKE,            
  VALKYRIE_THUNDER_SLASH,   
  VALKYRIE_SWIFT_STEP,      
  VALKYRIE_SPARK_FIELD,  
  VALKYRIE_VERMEIL_STITCHING,
  VALKYRIE_ELECTRIC_SIGIL,    
  VALKYRIE_SOLAR_SHOCK,
  VALKYRIE_VOLT_RETALIATION,
};

/*============================================================================= 
 * skillReset
 *
 * Called to reset skill data at the start of a new battle
 *===========================================================================*/
public function skillReset() {
  local int i;
  
  for (i = 0; i < ValkyrieSkills.enumCount; i++) {
    ROTT_Descriptor_Hero_Skill(scriptList[i]).skillReset();
  }
}

/*=============================================================================
 * descriptors
 *===========================================================================*/
defaultProperties 
{
  // List of skills in this set
  scriptClasses(VALKYRIE_VALOR_STRIKE)=class'ROTT_Descriptor_Skill_Valkyrie_Valor_Strike'
  scriptClasses(VALKYRIE_SWIFT_STEP)=class'ROTT_Descriptor_Skill_Valkyrie_Swift_Step'
  scriptClasses(VALKYRIE_ELECTRIC_SIGIL)=class'ROTT_Descriptor_Skill_Valkyrie_Electric_Sigil'
  scriptClasses(VALKYRIE_THUNDER_SLASH)=class'ROTT_Descriptor_Skill_Valkyrie_Thunder_Slash'
  scriptClasses(VALKYRIE_VERMEIL_STITCHING)=class'ROTT_Descriptor_Skill_Valkyrie_Vermeil_Stitching'
  scriptClasses(VALKYRIE_SPARK_FIELD)=class'ROTT_Descriptor_Skill_Valkyrie_Spark_Field'
  scriptClasses(VALKYRIE_SOLAR_SHOCK)=class'ROTT_Descriptor_Skill_Valkyrie_Solar_Shock'
  scriptClasses(VALKYRIE_VOLT_RETALIATION)=class'ROTT_Descriptor_Skill_Valkyrie_Volt_Retaliation'
  
  /** ================================================================
  Do not attach static objects here, they need to know gameInfo, which
  makes garbage collection a nightmare if they arent dynamic objects
  **===============================================================**/
}







