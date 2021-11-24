/*=============================================================================
 * ROTT_Descriptor_Skill_Titan_Siphon
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * One of the valkyries skill descriptors.
 *===========================================================================*/

class ROTT_Descriptor_Skill_Titan_Siphon extends ROTT_Descriptor_Hero_Skill;

/*=============================================================================
 * initialize()
 *
 * this function should be called by the descriptor container to set headers
 * and paragraph formatting info
 *===========================================================================*/
public function setUI() {
  // Set header
  h1(
    "Siphon Strike"
  );
  
  // Set header
  h2(
    getHeader(targetingLabel)
  );
  
  // Set paragraph information
  p1(
    "This elemental attack can demoralize",
    "enemies, and will deal 50% extra damage",
    "if an enemy is already demoralized."
  );
  
  // Set skill information for p2 and p3
  skillInfo(      
    "Mana Cost: %mana",
    "%min to %max damage",
    "+%dmrl demoralization power"
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
    case MANA_COST:
      attribute = getManaEquation(level, 1.148, 0.795, 2.45, 38.0, 5.0);
      break;
      
    case ELEMENTAL_DAMAGE_MIN:
      attribute = 12 * level * (1 + (level - 1) / 4.f) - 2;
      //attribute = (5 + (2 * level)) * (((level - 1) * 0.08) + 0.6);
      //attribute = (4 + (2 * level)) * (((level - 1) * 0.08) + 0.6);
      break;
    case ELEMENTAL_DAMAGE_MAX:
      attribute = 14 * level * (1 + (level - 1) / 3.5f) - 2;
      //attribute = (10 + (4 * level)) * (((level - 1) * 0.08) + 0.6);
      //attribute = (8 + (4 * level)) * (((level - 1) * 0.08) + 0.6);
      break;
      
    case DEMORALIZED_ELEMENTAL_AMP:
      attribute = 150;
      break;
      
    case DEMORALIZE_RATING_NO_STACKING:
      attribute = level * 15 + 40;
      break;
      
    //case ADD_ELEMENTAL_MIN_IF_DEMORALIZED:
    //  attribute = attributeInfo(ELEMENTAL_DAMAGE_MIN, hero, level) * 1.35;
    //  break;
    //case ADD_ELEMENTAL_MAX_IF_DEMORALIZED:
    //  //attribute = (10 + (4 * level)) * (((level - 1) * 0.095) + 0.7);
    //  //attribute -= attributeInfo(ELEMENTAL_DAMAGE_MAX, hero, level);
    //  break;
  }
  
  return attribute;
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties 
{
  targetingLabel=MULTI_TARGET_ATTACK
  
  // Level lookup info
  skillIndex=TITAN_SIPHON
  parentTree=CLASS_TREE

  // Sound effect
  combatSfx=SFX_COMBAT_ATTACK
  
  // Skill Attributes
  skillAttributes.add((attributeSet=COMBAT_ACTION_SET,mechanicType=MANA_COST,tag="%mana",font=DEFAULT_SMALL_BLUE,returnType=INTEGER));
  
  skillAttributes.add((attributeSet=COMBAT_ACTION_SET,mechanicType=ELEMENTAL_DAMAGE_MIN,tag="%min",font=DEFAULT_SMALL_ORANGE,returnType=INTEGER));
  skillAttributes.add((attributeSet=COMBAT_ACTION_SET,mechanicType=ELEMENTAL_DAMAGE_MAX,tag="%max",font=DEFAULT_SMALL_ORANGE,returnType=INTEGER));
  
  skillAttributes.add((attributeSet=COMBAT_ACTION_SET,mechanicType=DEMORALIZE_RATING_NO_STACKING,tag="%dmrl",font=DEFAULT_SMALL_ORANGE,returnType=INTEGER));
  skillAttributes.add((attributeSet=COMBAT_ACTION_SET,mechanicType=DEMORALIZED_ELEMENTAL_AMP,tag="%amp",font=DEFAULT_SMALL_WHITE,returnType=INTEGER));
  
  // Skill Icon
  begin object class=UI_Texture_Info Name=Encounter_Skill_Icon_Siphon_Strike
    componentTextures.add(Texture2D'GUI_Skills.Encounter_Skill_Icon_Siphon_Strike')
  end object
  
  // Skill Icon Container
  begin object class=UI_Texture_Storage Name=Skill_Icon_Container
    tag="Skill_Icon_Container"
    textureWidth=108
    textureHeight=108
    images(0)=Encounter_Skill_Icon_Siphon_Strike
  end object
  skillIcon=Skill_Icon_Container
  
  
  // Skill Animation
  begin object class=UI_Texture_Info Name=SkillAnim_Debuff_Blue_F1
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Debuff_Blue_F1')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Debuff_Blue_F2
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Debuff_Blue_F2')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Debuff_Blue_F3
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Debuff_Blue_F3')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Debuff_Blue_F4
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Debuff_Blue_F4')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Debuff_Blue_F5
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Debuff_Blue_F5')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Debuff_Blue_F6
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Debuff_Blue_F6')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Debuff_Blue_F7
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Debuff_Blue_F7')
  end object
  
  // Skill Animation Container
  begin object class=UI_Texture_Storage Name=Skill_Animation_Container
    tag="Skill_Animation_Container"
    textureWidth=240
    textureHeight=240
    images(0)=SkillAnim_Debuff_Blue_F1
    images(1)=SkillAnim_Debuff_Blue_F2
    images(2)=SkillAnim_Debuff_Blue_F3
    images(3)=SkillAnim_Debuff_Blue_F4
    images(4)=SkillAnim_Debuff_Blue_F5
    images(5)=SkillAnim_Debuff_Blue_F6
    images(6)=SkillAnim_Debuff_Blue_F7
  end object
  skillAnim=Skill_Animation_Container
  
}





















