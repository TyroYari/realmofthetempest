/*=============================================================================
 * ROTT_Descriptor_Skill_Valkyrie_Vermeil_Stitching
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * One of the valkyries skill descriptors.
 *===========================================================================*/

class ROTT_Descriptor_Skill_Valkyrie_Vermeil_Stitching extends ROTT_Descriptor_Hero_Skill;

/*=============================================================================
 * initialize()
 *
 * this function should be called by the descriptor container to set headers
 * and paragraph formatting info
 *===========================================================================*/
public function setUI() {
  // Set header
  h1(
    "Vermeil Stitching"
  );
  
  // Set header
  h2(
    getHeader(targetingLabel)
  );
  
  // Set paragraph information
  p1(
    "Each time any hero uses the defend",
    "ability, they will recover health.",
    ""
  );
  
  // Set skill information for p2 and p3
  skillInfo(      
    "+%rejuv HP / sec while defending",
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
    case ADD_HEALTH_WHILE_DEFENDING:
      attribute = 1 * level;
      if (level > 20) attribute += (level - 20);
      if (level > 40) attribute += (level - 40) * 2;
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
  skillIndex=VALKYRIE_VERMEIL_STITCHING
  parentTree=CLASS_TREE

  // Skill Attributes
  skillAttributes.add((attributeSet=PASSIVE_PARTY_SET,mechanicType=ADD_HEALTH_WHILE_DEFENDING,tag="%rejuv",font=DEFAULT_SMALL_GREEN,returnType=INTEGER));
}





















