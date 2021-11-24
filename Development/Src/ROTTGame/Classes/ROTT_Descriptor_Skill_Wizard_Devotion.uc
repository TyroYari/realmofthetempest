/*=============================================================================
 * ROTT_Descriptor_Skill_Wizard_Devotion
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * One of the wizards skill descriptors.
 *===========================================================================*/

class ROTT_Descriptor_Skill_Wizard_Devotion extends ROTT_Descriptor_Hero_Skill;

/*=============================================================================
 * initialize()
 *
 * this function should be called by the descriptor container to set headers
 * and paragraph formatting info
 *===========================================================================*/
public function setUI() {
  // Set header
  h1(
    "Devotion"
  );
  
  // Set header
  h2(
    getHeader(targetingLabel)
  );
  
  // Set paragraph information
  p1(
    "Each time any hero uses the defend",
    "ability, they will recover mana.",
    ""
  );
  
  // Set skill information for p2 and p3
  skillInfo(
    "+%regen MP / sec while defending",
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
  local float attribute;  
  
  switch (type) {
    case ADD_MANA_WHILE_DEFENDING:
      attribute = 5 * level;
      break;
  }
  
  return attribute;
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties 
{
  targetingLabel=PASSIVE_PARTY_BUFF
  
  // Level lookup info
  skillIndex=WIZARD_DEVOTION
  parentTree=CLASS_TREE

  // Skill Attributes
  skillAttributes.add((attributeSet=PASSIVE_PARTY_SET,mechanicType=ADD_MANA_WHILE_DEFENDING,tag="%regen",font=DEFAULT_SMALL_BLUE,returnType=INTEGER));
}





















