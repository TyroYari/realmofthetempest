/*=============================================================================
 * ROTT_Descriptor_Enemy_Skill
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * This class consolodates all information pertaining to a given enemy skill. 
 *===========================================================================*/
  
class ROTT_Descriptor_Enemy_Skill extends ROTT_Descriptor_Skill
dependsOn(ROTT_Descriptor_Hero_Skill)
abstract;

/*=============================================================================
 * attributeInfo()
 *
 * This function should hold all equations pertaining to the skill's behavior.
 *===========================================================================*/
protected function float attributeInfo
(
  AttributeTypes type, 
  ROTT_Combat_Enemy enemy, 
  int level
) 
{
  local float attribute; attribute = 0; 
  
  switch (type) {
    // Relevant mechanic types should be filled out here in children classes
  }
  
  return attribute;
}

defaultProperties 
{
  
}






