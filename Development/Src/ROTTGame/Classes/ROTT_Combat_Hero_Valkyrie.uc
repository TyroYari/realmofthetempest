/*=============================================================================
 * Valkyrie Unit
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: The valkyrie is a player-controlled combat unit.
 *===========================================================================*/

class ROTT_Combat_Hero_Valkyrie extends ROTT_Combat_Hero;

/*=============================================================================
 * setInitialStats()
 *
 * Called when a new hero is added to a team, and sets initial exp
 *===========================================================================*/
public function setInitialStats(int slot) {
  // Starting skill points
  classSkillPts[VALKYRIE_VALOR_STRIKE] = 1;
  classSkillPts[VALKYRIE_SWIFT_STEP] = 1;
  
  // Initial skill IDs
  primarySkill = VALKYRIE_VALOR_STRIKE;
  secondarySkill = VALKYRIE_SWIFT_STEP;
  
  // Parent class initializes skill trees first
  super.setInitialStats(slot);
}

/*=============================================================================
 * Hero Properties
 *===========================================================================*/
defaultProperties 
{
  // Hero class
  myClass=VALKYRIE
  
  // Affinities
  statAffinities[PRIMARY_VITALITY]=MAJOR
  statAffinities[PRIMARY_STRENGTH]=AVERAGE
  statAffinities[PRIMARY_COURAGE]=MAJOR
  statAffinities[PRIMARY_FOCUS]=AVERAGE
  
  baseMinDamage=6
  baseMaxDamage=8
  baseCritChance=10
  
  // Skill set
  skillTreeType=ROTT_Descriptor_List_Valkyrie_Skills
  
}



















