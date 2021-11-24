/*=============================================================================
 * Titan Unit
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: The wizard is a player-controlled combat unit.
 *===========================================================================*/

class ROTT_Combat_Hero_Titan extends ROTT_Combat_Hero;

/*=============================================================================
 * setInitialStats()
 *
 * Called when a new hero is added to a team, and sets initial exp
 *===========================================================================*/
public function setInitialStats(int slot) {
  // Starting skill points
  classSkillPts[TITAN_SIPHON] = 1;
  classSkillPts[TITAN_THRASHER] = 1;
  
  // Initial skill IDs
  primarySkill = TITAN_SIPHON;
  secondarySkill = TITAN_THRASHER;
  
  // Parent class initializes skill trees first
  super.setInitialStats(slot);
}

/*=============================================================================
 * battlePrep()
 *
 * This function is called right before a battle starts
 *===========================================================================*/
public function battlePrep() {
  local int i;
  
  super.battlePrep();
  
  for (i = 0; i < ROTT_Party(outer).getPartySize(); i++) {
    if (ROTT_Party(outer).getHero(i) != none) {
      ROTT_Party(outer).getHero(i).meditationInfo = ROTT_Descriptor_Hero_Skill(getSkillScript(TITAN_MEDITATION));
    }
  }
}



/*=============================================================================
 * Hero Properties
 *===========================================================================*/
defaultProperties 
{
  // Hero class
  myClass=TITAN
  
  // Affinities
  statAffinities[PRIMARY_VITALITY]=AVERAGE
  statAffinities[PRIMARY_STRENGTH]=AVERAGE
  statAffinities[PRIMARY_COURAGE]=AVERAGE
  statAffinities[PRIMARY_FOCUS]=MAJOR
  
  baseMinDamage=6
  baseMaxDamage=8
  baseCritChance=10
  
  // Skill set
  skillTreeType=ROTT_Descriptor_List_Titan_Skills
  
}



















