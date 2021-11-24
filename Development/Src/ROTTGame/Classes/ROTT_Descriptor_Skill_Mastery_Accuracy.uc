/*=============================================================================
 * ROTT_Descriptor_Skill_Mastery_Accuracy
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * This is a mastery skill, providing a permanent boost to the hero.
 *===========================================================================*/

class ROTT_Descriptor_Skill_Mastery_Accuracy extends ROTT_Descriptor_Hero_Skill;

/*=============================================================================
 * initialize()
 *
 * this function should be called by the descriptor container to set headers
 * and paragraph formatting info
 *===========================================================================*/
public function setUI() {
  // Set header
  h1(
    "Accuracy",
  );
  
  // Set header
  h2(
    "",
  );
  
  // Set paragraph information
  p1(
    "Permanent increase to accuracy rating.",
    "",
    "",
  );
  
  // Set skill information for p2 and p3
  skillInfo(      
    "Required Strength: %strength",
    "Required Focus: %focus",
    "+%accuracy Accuracy rating"
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
    case MASTERY_REQ_STRENGTH:
      attribute = 8 + (level * 4);
      break;
    case MASTERY_REQ_FOCUS:
      attribute = 12 + (level * 6);
      break;
    case PASSIVE_ACCURACY_BOOST:
      attribute = 48 * level + 10 * (level / 2);
      if (level > 4) attribute += 100 * (level - 4) * (1.1 ** (level / 4));
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
  skillIndex=MASTERY_ACCURACY
  parentTree=MASTERY_TREE

  // Skill Attributes
  skillAttributes.add((attributeSet=INACTIVE_SET,mechanicType=MASTERY_REQ_STRENGTH,tag="%strength",font=DEFAULT_SMALL_RED,returnType=INTEGER));
  skillAttributes.add((attributeSet=INACTIVE_SET,mechanicType=MASTERY_REQ_FOCUS,tag="%focus",font=DEFAULT_SMALL_RED,returnType=INTEGER));
  skillAttributes.add((attributeSet=PASSIVE_SET,mechanicType=PASSIVE_ACCURACY_BOOST,tag="%accuracy",font=DEFAULT_SMALL_GREEN,returnType=INTEGER));
}
























