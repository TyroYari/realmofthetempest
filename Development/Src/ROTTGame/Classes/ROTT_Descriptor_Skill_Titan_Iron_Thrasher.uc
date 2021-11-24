/*=============================================================================
 * ROTT_Descriptor_Skill_Titan_Iron_Thrasher
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * One of the valkyries skill descriptors.
 *===========================================================================*/

class ROTT_Descriptor_Skill_Titan_Iron_Thrasher extends ROTT_Descriptor_Hero_Skill;

/// frozen, freezing, icy, ice, frigid, frost, arctic, chilling, winter,
/// snow, cold

/*=============================================================================
 * initialize()
 *
 * this function should be called by the descriptor container to set headers
 * and paragraph formatting info
 *===========================================================================*/
public function setUI() {
  // Set header
  h1(
    "Iron Thrasher"
  );
  
  // Set header
  h2(
    getHeader(targetingLabel)
  );
  
  // Set paragraph information
  p1(
    "This physical attack drains extra mana",
    "from the caster, but deals high damage",
    "to an enemy."
  );
  
  // Set skill information for p2 and p3
  skillInfo(      
    "Mana Cost: %mana",
    "%min to %max damage",
    "-%amp Mana / sec for %time seconds"
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
    case MANA_COST:
      //attribute = getManaEquation(level, 1.14, 0.785, 2.42, 48.0, 7.0);
      attribute = getManaEquation(level, 1.14, 0.785, 2.38, 25.0, 8.0);
      break;
      
    case PHYSICAL_DAMAGE_MIN:
      //attribute = hero.subStats[MIN_PHYSICAL_DAMAGE] * (1.45 + (0.23 * (level - 1)));
      //attribute = hero.subStats[MIN_PHYSICAL_DAMAGE] * (2.75 + (0.25 * (level - 1)));
      attribute = hero.subStats[MIN_PHYSICAL_DAMAGE] * (2.75 + (0.35 * (level - 1)));
      break;
    case PHYSICAL_DAMAGE_MAX:
      //attribute = hero.subStats[MAX_PHYSICAL_DAMAGE] * (1.45 + (0.23 * (level - 1)));
      //attribute = hero.subStats[MAX_PHYSICAL_DAMAGE] * (2.5 + (0.65 * (level - 1)));
      attribute = hero.subStats[MAX_PHYSICAL_DAMAGE] * (2.75 + (0.85 * (level - 1)));
      break;
      
    case TEMP_MANA_DRAIN_TIME:
      attribute = 5 + level / 4;
      break;
    case TEMP_MANA_DRAIN_AMOUNT:
      attribute = 5 + level * 10;
      break;
      
    //case SELF_DEMORALIZE_RATING:
    //  attribute = 60 + 15 * level;
    //  break;
  }
  
  return attribute;
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties 
{
  targetingLabel=SINGLE_TARGET_ATTACK
  
  // Level lookup info
  skillIndex=TITAN_THRASHER
  parentTree=CLASS_TREE

  // Sound effect
  combatSfx=SFX_COMBAT_ATTACK
  
  // Skill Attributes
  skillAttributes.add((attributeSet=COMBAT_ACTION_SET,mechanicType=MANA_COST,tag="%mana",font=DEFAULT_SMALL_BLUE,returnType=INTEGER));
  
  skillAttributes.add((attributeSet=COMBAT_ACTION_SET,mechanicType=PHYSICAL_DAMAGE_MIN,tag="%min",font=DEFAULT_SMALL_ORANGE,returnType=INTEGER));
  skillAttributes.add((attributeSet=COMBAT_ACTION_SET,mechanicType=PHYSICAL_DAMAGE_MAX,tag="%max",font=DEFAULT_SMALL_ORANGE,returnType=INTEGER));
  
  skillAttributes.add((attributeSet=COMBAT_ACTION_SET,mechanicType=TEMP_MANA_DRAIN_TIME,tag="%time",font=DEFAULT_SMALL_BLUE,returnType=INTEGER));
  skillAttributes.add((attributeSet=COMBAT_ACTION_SET,mechanicType=TEMP_MANA_DRAIN_AMOUNT,tag="%amp",font=DEFAULT_SMALL_BLUE,returnType=INTEGER));
  
  // Skill Icon
  begin object class=UI_Texture_Info Name=Encounter_Skill_Icon_Iron_Thrasher
    componentTextures.add(Texture2D'GUI_Skills.Encounter_Skill_Icon_Iron_Thrasher')
  end object
  
  // Skill Icon Container
  begin object class=UI_Texture_Storage Name=Skill_Icon_Container
    tag="Skill_Icon_Container"
    textureWidth=108
    textureHeight=108
    images(0)=Encounter_Skill_Icon_Iron_Thrasher
  end object
  skillIcon=Skill_Icon_Container
  
  
  // Skill Animation
  begin object class=UI_Texture_Info Name=SkillAnim_Thrasher_F1
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Thrasher_F1')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Thrasher_F2
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Thrasher_F2')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Thrasher_F3
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Thrasher_F3')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Thrasher_F4
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Thrasher_F4')
  end object
  
  // Skill Animation Container
  begin object class=UI_Texture_Storage Name=Skill_Animation_Container
    tag="Skill_Animation_Container"
    textureWidth=240
    textureHeight=240
    images(0)=SkillAnim_Thrasher_F1
    images(1)=SkillAnim_Thrasher_F2
    images(2)=SkillAnim_Thrasher_F3
    images(3)=SkillAnim_Thrasher_F4
  end object
  skillAnim=Skill_Animation_Container
  
}





















