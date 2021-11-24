/*=============================================================================
 * ROTT_Descriptor_Skill_Mastery_Armor
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * This is a mastery skill, providing a permanent boost to the hero.
 *===========================================================================*/

class ROTT_Descriptor_Skill_Mastery_Armor extends ROTT_Descriptor_Hero_Skill;

/*=============================================================================
 * initialize()
 *
 * this function should be called by the descriptor container to set headers
 * and paragraph formatting info
 *===========================================================================*/
public function setUI() {
  // Set header
  h1(
    "Armor",
  );
  
  // Set header
  h2(
    "",
  );
  
  // Set paragraph information
  p1(
    "Permanent boost to armor rating.",
    "",
    "",
  );
  
  // Set skill information for p2 and p3
  skillInfo(      
    "Required Strength: %req",
    "+%armor Armor rating",
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
    case MASTERY_REQ_STRENGTH:
      attribute = 18 + (level * 14);
      break;
    case PASSIVE_ARMOR_BOOST:
      attribute = 16 + ((level - 1) * 14);
      if (level > 3) {
        attribute *= 1.05 ** (level - 3);
        attribute = int(attribute / 5);
        attribute *= 5;
      }
      break;
  }
  
  return attribute;
}

/*=============================================================================
 * getStats()
 *===========================================================================*/
function int getStats(string StatType, int SkillLevel) {
  local int iArmor, iReq, i, j, k;
  
  if (SkillLevel == 0)
  {
    return 0;
  }
  
  iArmor = 0;
  iReq = 10;
  i = SkillLevel;
  j = 16;
  k = 19;
  
  do
  {
    //Do %SkillLEvel times
    i = i - 1;
    
    k = k + 3;
    iReq = iReq + k;
    
    if (iReq % 5 != 0 && iReq%2 != 0 )
    {
      Do
      {
        iReq = iReq + 1;
        k = k + 1;        
      } until (iReq%5 == 0 || iReq%2 == 0);
    }
    
    iArmor = iArmor + j;
    j = j + 8;
    
  } until (i <= 0);
  
  // Return type 
  switch (StatType)
  {
    case "Stat":
      return iArmor;
    case "Req":
      return iReq;
  }
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
  skillIndex=MASTERY_ARMOR
  parentTree=MASTERY_TREE

  // Skill Attributes
  skillAttributes.add((attributeSet=INACTIVE_SET,mechanicType=MASTERY_REQ_STRENGTH,tag="%req",font=DEFAULT_SMALL_RED,returnType=INTEGER));
  skillAttributes.add((attributeSet=PASSIVE_SET,mechanicType=PASSIVE_ARMOR_BOOST,tag="%armor",font=DEFAULT_SMALL_GREEN,returnType=INTEGER));
}












