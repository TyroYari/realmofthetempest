/*=============================================================================
 * ROTT_Descriptor_Skill_Mastery_Omni_Seeker
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * This is a mastery skill, providing a permanent boost to the hero.
 *===========================================================================*/

class ROTT_Descriptor_Skill_Mastery_Omni_Seeker extends ROTT_Descriptor_Hero_Skill;

/*=============================================================================
 * initialize()
 *
 * this function should be called by the descriptor container to set headers
 * and paragraph formatting info
 *===========================================================================*/
public function setUI() {
  // Set header
  h1(
    "Omni Seeker",
  );
  
  // Set header
  h2(
    "",
  );
  
  // Set paragraph information
  p1(
    "Skill points spent here will add to",
    "the loot luck enchantment.",
    "",
  );
  
  // Set skill information for p2 and p3
  skillInfo(      
    "Omni Seeker +%omni",
    "",
    ""
  );
}


/*=============================================================================
 * attributeInfo()
 *
 * This function should hold all equations pertaining to the skill's behavior.
 *===========================================================================*/
protected function float attributeInfo
(
  AttributeTypes type, 
  ROTT_Combat_Hero hero, 
  int level
) 
{
  switch (type) {
    case OMNI_SEEKER_HARDCORE: return level;
  }
  
  return 0;
  
  ///return gameInfo.playerProfile.enchantmentLevels[OMNI_SEEKER];
}

/*=============================================================================
 * addManaOverflow()
 *
 * Called to track mana that overflows beyond a combat unit's max mana value
 *===========================================================================*/
public function addManaOverflow(float manaOverflow);

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties 
{
  // Status info
  statusColor=COMBAT_SMALL_RED
  
  // Skill attributes
  skillAttributes.add((attributeSet=,mechanicType=OMNI_SEEKER_HARDCORE,tag="%omni",font=DEFAULT_SMALL_GREEN,returnType=INTEGER));
  
  // Level lookup info
  skillIndex=MASTERY_OMNI_SEEKER
  parentTree=MASTERY_TREE

}















