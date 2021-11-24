/*=============================================================================
 * ROTT_Descriptor_Skill_Mastery_Mana
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * This is a mastery skill, providing a permanent boost to the hero.
 *===========================================================================*/

class ROTT_Descriptor_Skill_Mastery_Mana extends ROTT_Descriptor_Hero_Skill;

/*=============================================================================
 * initialize()
 *
 * this function should be called by the descriptor container to set headers
 * and paragraph formatting info
 *===========================================================================*/
public function setUI() {
  // Set header
  h1(
    "Mana",
  );
  
  // Set header
  h2(
    "",
  );
  
  // Set paragraph information
  p1(
    "Permanent increase to mana.",
    "",
    "",
  );
  
  // Set skill information for p2 and p3
  skillInfo(      
    "Required Focus: %focus",
    "+%mana Max mana",
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
  local float attribute; attribute = 0; 
  
  switch (type) {
    case MASTERY_REQ_FOCUS:
      attribute = 14 + 10 * (level-1);
      break;
    case PASSIVE_MANA_BOOST:
      attribute = 48 + 72 * (level-1) + 2 * (level-1) * (level-1);
      if (level >= 4) attribute += 40 * (level-3);
      break;
  }
  
  return attribute;
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
  // Level lookup info
  skillIndex=MASTERY_MANA
  parentTree=MASTERY_TREE

  // Skill Attributes
  skillAttributes.add((attributeSet=INACTIVE_SET,mechanicType=MASTERY_REQ_FOCUS,tag="%focus",font=DEFAULT_SMALL_RED,returnType=INTEGER));
  skillAttributes.add((attributeSet=PASSIVE_SET,mechanicType=PASSIVE_MANA_BOOST,tag="%mana",font=DEFAULT_SMALL_GREEN,returnType=INTEGER));
}













