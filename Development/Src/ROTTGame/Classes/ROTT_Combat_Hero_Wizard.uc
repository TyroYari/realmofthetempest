/*=============================================================================
 * Wizard Unit
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: The wizard is a player-controlled combat unit.
 *===========================================================================*/

class ROTT_Combat_Hero_Wizard extends ROTT_Combat_Hero;

/*=============================================================================
 * setInitialStats()
 *
 * Called when a new hero is added to a team, and sets initial exp
 *===========================================================================*/
public function setInitialStats(int slot) {
  // Starting skill points
  classSkillPts[WIZARD_STARBOLT] = 1;
  classSkillPts[WIZARD_STARDUST] = 1;
  
  // Initial skill IDs
  primarySkill = WIZARD_STARBOLT;
  secondarySkill = WIZARD_STARDUST;
  
  // Parent class initializes skill trees first
  super.setInitialStats(slot);
}

/*=============================================================================
 * Hero Properties
 *===========================================================================*/
defaultProperties 
{
  // Hero class
  myClass=WIZARD
  
  // Affinities
  statAffinities[PRIMARY_VITALITY]=AVERAGE
  statAffinities[PRIMARY_STRENGTH]=MINOR
  statAffinities[PRIMARY_COURAGE]=MINOR
  statAffinities[PRIMARY_FOCUS]=MAJOR
  
  baseMinDamage=4
  baseMaxDamage=6
  baseCritChance=5
  
  // Skill set
  skillTreeType=ROTT_Descriptor_List_Wizard_Skills
}



















