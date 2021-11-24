/*=============================================================================
 * ROTT_Descriptor_Skill_Mastery_Damage
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * This is a mastery skill, providing a permanent boost to the hero.
 *===========================================================================*/

class ROTT_Descriptor_Skill_Mastery_Damage extends ROTT_Descriptor_Hero_Skill;

/*=============================================================================
 * initialize()
 *
 * this function should be called by the descriptor container to set headers
 * and paragraph formatting info
 *===========================================================================*/
public function setUI() {
  // Set header
  h1(
    "Damage",
  );
  
  // Set header
  h2(
    "",
  );
  
  // Set paragraph information
  p1(
    "Permanent increase to physical damage.",
    "",
    "",
  );
  
  // Set skill information for p2 and p3
  skillInfo(
    "Required Strength: %strength",
    "Required Focus: %focus",
    "+%min to %max physical damage"
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
      attribute = getStats("Req1", level); // requirement(1,3,level);
      break;
    case MASTERY_REQ_FOCUS:
      attribute = getStats("Req2", level); // requirement(2,3,level);
      break;
    case PASSIVE_ADD_PHYSICAL_MIN:
      attribute = getStats("Stat1", level); // 2 + level * ((1 + 14 * level) / level + 1);
      break;
    case PASSIVE_ADD_PHYSICAL_MAX:
      attribute = getStats("Stat2", level); // level * (1 + level * 14);
      break;
  }
  
  return attribute;
}

/*=============================================================================
 * requirement()
 *===========================================================================*/
private function int requirement(float a, float b, int level) {
  local int req, ReqTotal, i;
  local float k;
  
  ReqTotal = 32;
  k = 1.1;
  
  for (i = 0; i < level; i++) {
    k = k * 1.006;
    k = k + 0.22;

    ReqTotal = round(ReqTotal * k);
    
    req = round(ReqTotal * (a/b));
    
    if (req % 5 != 0 && req%2 != 0)  {
      do {
        req++;      
        k += 0.012;
      } until (req%5 == 0 || req%2 == 0);
    }
  }
  
  return req;
}

/*=============================================================================
 * getStats()
 *===========================================================================*/
function int getStats(string StatType, int SkillLevel) {

  local int iStat1, iStat2, iReq1, iReq2, ReqTotal, i, j;
  local float k;
  
  iStat1 = 2;
  iStat2 = 14;
  
  ReqTotal = 32;
  i = SkillLevel;
  j = 1;
  k = 1.1;
  
  do
  {
    //Do %SkillLEvel times
    i = i - 1;
    
    k = k * 1.006;
    k = k + 0.22;

    ReqTotal = round(ReqTotal * k);
    
    iReq1 = round(ReqTotal * (1.0/3.0));
    iReq2 = round(ReqTotal * (2.0/3.0));
    
    
    if (iReq1 % 5 != 0 && iReq1%2 != 0 )
    {
      Do
      {
        iReq1 = iReq1 + 1;    
        k = k + 0.012;        
      } until (iReq1%5 == 0 || iReq1%2 == 0);
    }
    if (iReq2 % 5 != 0 && iReq2%2 != 0 )
    {
      Do
      {
        iReq2 = iReq2 + 1;      
        k = k + 0.012;
      } until (iReq2%5 == 0 || iReq2%2 == 0);
    }
    
    j = j + 14;
    iStat1 = iStat1 + (j / skillLevel + 1);
    iStat2 = iStat2 + j;
    

    
  } until (i <= 0);
    
    
  switch (StatType)  {
    case "Stat1":  return iStat1; // getStats("Stat1", level);
    case "Stat2":  return iStat2; // getStats("Stat2", level);
    case "Req1":  return iReq1;  // getStats("Req1", level);
    case "Req2":  return iReq2;  // getStats("Req2", level);
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
  skillIndex=MASTERY_DAMAGE
  parentTree=MASTERY_TREE

  // Skill Attributes
  skillAttributes.add((attributeSet=INACTIVE_SET,mechanicType=MASTERY_REQ_STRENGTH,tag="%strength",font=DEFAULT_SMALL_RED,returnType=INTEGER));
  skillAttributes.add((attributeSet=INACTIVE_SET,mechanicType=MASTERY_REQ_FOCUS,tag="%focus",font=DEFAULT_SMALL_RED,returnType=INTEGER));
  skillAttributes.add((attributeSet=PASSIVE_SET,mechanicType=PASSIVE_ADD_PHYSICAL_MIN,tag="%min",font=DEFAULT_SMALL_ORANGE,returnType=INTEGER));
  skillAttributes.add((attributeSet=PASSIVE_SET,mechanicType=PASSIVE_ADD_PHYSICAL_MAX,tag="%max",font=DEFAULT_SMALL_ORANGE,returnType=INTEGER));
}










