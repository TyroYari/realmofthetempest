/*=============================================================================
 * ROTT_Descriptor_Skill_Titan_Oath
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * One of the valkyries skill descriptors.
 *===========================================================================*/

class ROTT_Descriptor_Skill_Titan_Oath extends ROTT_Descriptor_Hero_Skill;

/*=============================================================================
 * initialize()
 *
 * this function should be called by the descriptor container to set headers
 * and paragraph formatting info
 *===========================================================================*/
public function setUI() {
  // Set header
  h1(
    "Oath"
  );
  
  // Set header
  h2(
    getHeader(targetingLabel)
  );
  
  // Set paragraph information
  p1(
    "Each time any hero uses the defend",
    "ability, they will gain mana",
    "regeration."
  );
  
  // Set skill information for p2 and p3
  skillInfo(
    "Each Defend adds +%mana MP / sec",
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
    case MANA_REGEN_ADDED_ON_DEFEND:
      attribute = level * 2;
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
  skillIndex=TITAN_OATH
  parentTree=CLASS_TREE

  // Skill Attributes
  skillAttributes.add((attributeSet=PASSIVE_PARTY_SET,mechanicType=MANA_REGEN_ADDED_ON_DEFEND,tag="%mana",font=DEFAULT_SMALL_BLUE,returnType=INTEGER));
  
}





















