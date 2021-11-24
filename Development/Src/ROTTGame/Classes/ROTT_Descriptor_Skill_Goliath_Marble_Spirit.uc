/*=============================================================================
 * ROTT_Descriptor_Skill_Goliath_Marble_Spirit
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * One of the valkyries skill descriptors.
 *===========================================================================*/

class ROTT_Descriptor_Skill_Goliath_Marble_Spirit extends ROTT_Descriptor_Hero_Skill;

/*=============================================================================
 * initialize()
 *
 * this function should be called by the descriptor container to set headers
 * and paragraph formatting info
 *===========================================================================*/
public function setUI() {
  // Set header
  h1(
    "Marble Spirit"
  );
  
  // Set header
  h2(
    getHeader(targetingLabel)
  );
  
  // Set paragraph information
  p1(
    "An ability that drains the life of",
    "the caster, but provides a buff",
    "to all stats for all heroes."
  );
  
  // Set skill information for p2 and p3
  skillInfo(      
    "-%rejuv HP / sec (Passive)",
    "+%stats to all stats",
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
    case HEALTH_LOSS_OVER_TIME:
      attribute = 1 + int((level - 1) * 2.0 / 5.0);
      if (level % 2 == 0) attribute += level / 2;
      break;
      
    case INCREASE_ALL_STATS:
      attribute = 0.5 * level + 1;
      break;
      
    ///case INCREASE_STRENGTH_PERCENT:
    ///  attribute = 50 * level;
    ///  //attribute = 12 + ((8 + (level / 2)) + 8) * level;
    ///  break;
    ///case INCREASE_COURAGE_PERCENT:
    ///  attribute = 50 * level;
    ///  //attribute = 12 + ((8 + (level / 2)) + 8) * level;
    ///  break;
    ///  
  }
  
  return attribute;
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  targetingLabel=MULTI_TARGET_BUFF
  
  // Sound effect
  combatSfx=SFX_COMBAT_BUFF
  
  // Level lookup info
  skillIndex=GOLIATH_MARBLE_SPIRIT
  parentTree=CLASS_TREE

  // Skill Attributes
  skillAttributes.add((attributeSet=PASSIVE_SET,mechanicType=HEALTH_LOSS_OVER_TIME,tag="%rejuv",font=DEFAULT_SMALL_RED,returnType=INTEGER));
  
  skillAttributes.add((attributeSet=COMBAT_ACTION_SET,mechanicType=INCREASE_ALL_STATS,tag="%stats",font=DEFAULT_SMALL_GREEN,returnType=INTEGER));
  
  ///skillAttributes.add((attributeSet=COMBAT_ACTION_SET,mechanicType=INCREASE_STRENGTH_PERCENT,tag="%str",font=DEFAULT_SMALL_ORANGE,returnType=INTEGER));
  ///skillAttributes.add((attributeSet=COMBAT_ACTION_SET,mechanicType=INCREASE_COURAGE_PERCENT,tag="%crg",font=DEFAULT_SMALL_ORANGE,returnType=INTEGER));
  
  // Skill Icon
  begin object class=UI_Texture_Info Name=Encounter_Skill_Icon_Marble_Spirit
    componentTextures.add(Texture2D'GUI_Skills.Encounter_Skill_Icon_Marble_Spirit')
  end object
  
  // Skill Icon Container
  begin object class=UI_Texture_Storage Name=Skill_Icon_Container
    tag="Skill_Icon_Container"
    textureWidth=108
    textureHeight=108
    images(0)=Encounter_Skill_Icon_Marble_Spirit
  end object
  skillIcon=Skill_Icon_Container
  
}










