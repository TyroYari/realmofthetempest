/*=============================================================================
 * ROTT_Descriptor_Skill_Valkyrie_Electric_Sigil
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * One of the valkyries skill descriptors.
 *===========================================================================*/

class ROTT_Descriptor_Skill_Valkyrie_Electric_Sigil extends ROTT_Descriptor_Hero_Skill;

/*=============================================================================
 * initialize()
 *
 * this function should be called by the descriptor container to set headers
 * and paragraph formatting info
 *===========================================================================*/
public function setUI() {
  // Set header
  h1(
    "Electric Sigil"
  );
  
  // Set header
  h2(
    getHeader(targetingLabel)
  );
  
  // Set paragraph information
  p1(
    "When this hero uses the defend ability,",
    "all members of this team will deal more",
    "elemental damage."
  );
  
  // Set skill information for p2 and p3
  skillInfo(
    "+%amp% Elemental Damage",
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
    case PARTY_ELEMENTAL_AMPLIFIER:
      attribute = level * 10;
      if (level > 10) attribute -= (level - 10) * 5;
      break;
  }
  
  return attribute;
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  targetingLabel=PASSIVE_DEFEND_PERK
  
  // Level lookup info
  skillIndex=VALKYRIE_ELECTRIC_SIGIL
  parentTree=CLASS_TREE

  // Skill Attributes
  skillAttributes.add((attributeSet=ON_DEFEND_PARTY_SET,mechanicType=PARTY_ELEMENTAL_AMPLIFIER,tag="%amp",font=DEFAULT_SMALL_GREEN,returnType=INTEGER));
}





















