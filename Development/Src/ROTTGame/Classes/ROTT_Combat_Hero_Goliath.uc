/*=============================================================================
 * Goliath Unit
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: The goliath is a player-controlled combat unit.
 *===========================================================================*/

class ROTT_Combat_Hero_Goliath extends ROTT_Combat_Hero;

/*=============================================================================
 * setInitialStats()
 *
 * Called when a new hero is added to a team, and sets initial exp
 *===========================================================================*/
public function setInitialStats(int slot) {
  // Starting skill points
  classSkillPts[GOLIATH_STONE_STRIKE] = 1;
  classSkillPts[GOLIATH_INTIMIDATION] = 1;
  
  // Initial skill IDs
  primarySkill = GOLIATH_STONE_STRIKE;
  secondarySkill = GOLIATH_INTIMIDATION;
  
  // Parent class initializes skill trees first
  super.setInitialStats(slot);
}

/*=============================================================================
 * Hero Properties
 *===========================================================================*/
defaultProperties 
{
  // Hero class
  myClass=GOLIATH
  
  // Affinities
  statAffinities[PRIMARY_VITALITY]=MAJOR
  statAffinities[PRIMARY_STRENGTH]=MAJOR
  statAffinities[PRIMARY_COURAGE]=AVERAGE
  statAffinities[PRIMARY_FOCUS]=MINOR
  
  baseMinDamage=6
  baseMaxDamage=10
  baseCritChance=15
  
  // Skill set
  skillTreeType=ROTT_Descriptor_List_Goliath_Skills
  
}



















