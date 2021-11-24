/*=============================================================================
 * ROTT_Descriptor_Skill_Goliath_Earthquake
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * One of the valkyries skill descriptors.
 *===========================================================================*/

class ROTT_Descriptor_Skill_Goliath_Earthquake extends ROTT_Descriptor_Hero_Skill;

/*=============================================================================
 * initialize()
 *
 * this function should be called by the descriptor container to set headers
 * and paragraph formatting info
 *===========================================================================*/
public function setUI() {
  // Set header
  h1(
    "Earthquake"
  );
  
  // Set header
  h2(
    getHeader(targetingLabel)
  );
  
  // Set paragraph information
  p1(
    "An elemental attack that may reduce",
    "enemy dodge, even if it misses.",
    ""
  );
  
  // Set skill information for p2 and p3
  skillInfo(      
    "Mana Cost: %mana",
    "-%dodge Dodge Rating",
    "%min to %max damage"
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
      attribute = getManaEquation(level, 1.2, 0.8, 2.6, 7.0, 34.0);
      break;
      
    case ELEMENTAL_DAMAGE_MIN:
      attribute = (level * 10) * (1 + int(level / 2.f) / 10.f);
      break;
    case ELEMENTAL_DAMAGE_MAX:
      attribute = (level * 20) * (1 + int(level / 2.f) / 10.f);
      break;
      
    case DECREASE_DODGE_RATING: /// need to make this separate % chance to hit
      attribute = level * 10;
      break;
      
    ///case HIT_CHANCE_OVERRIDE:
    ///  attribute = DEBUFF_CHANCE;
    ///  break;
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
  skillIndex=GOLIATH_EARTHQUAKE
  parentTree=CLASS_TREE

  // Sound effect
  combatSfx=SFX_COMBAT_ATTACK
  
  // Secondary effect script
  secondaryScriptIndex=GOLIATH_EARTHQUAKE_DEBUFF
  
  // Skill Attributes
  // Mana cost
  skillAttributes.add((attributeSet=COMBAT_ACTION_SET,mechanicType=MANA_COST,tag="%mana",font=DEFAULT_SMALL_BLUE,returnType=INTEGER));
  
  // Elemental damage
  skillAttributes.add((attributeSet=COMBAT_ACTION_SET,mechanicType=ELEMENTAL_DAMAGE_MIN,tag="%min",font=DEFAULT_SMALL_ORANGE,returnType=INTEGER));
  skillAttributes.add((attributeSet=COMBAT_ACTION_SET,mechanicType=ELEMENTAL_DAMAGE_MAX,tag="%max",font=DEFAULT_SMALL_ORANGE,returnType=INTEGER));
  
  // Secondary debuff script
  skillAttributes.add((attributeSet=COMBAT_ACTION_SET,mechanicType=QUEUED_SECONDARY_EFFECT,tag="%none",font=DEFAULT_SMALL_WHITE,returnType=INTEGER));
  
  // Dodge reduction
  skillAttributes.add((attributeSet=INACTIVE_SET,mechanicType=DECREASE_DODGE_RATING,tag="%dodge",font=DEFAULT_SMALL_ORANGE,returnType=INTEGER));
  ///skillAttributes.add((attributeSet=COMBAT_SECONDARY_SET,mechanicType=HIT_CHANCE_OVERRIDE,tag="%chance",font=DEFAULT_SMALL_WHITE,returnType=INTEGER));
  
  // Skill Icon
  begin object class=UI_Texture_Info Name=Encounter_Skill_Icon_Earthquake
    componentTextures.add(Texture2D'GUI_Skills.Encounter_Skill_Icon_Earthquake')
  end object
  
  // Skill Icon Container
  begin object class=UI_Texture_Storage Name=Skill_Icon_Container
    tag="Skill_Icon_Container"
    textureWidth=108
    textureHeight=108
    images(0)=Encounter_Skill_Icon_Earthquake
  end object
  skillIcon=Skill_Icon_Container
  
  // Skill Animation
  begin object class=UI_Texture_Info Name=SkillAnim_Earthquake_F1
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Earthquake_F1')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Earthquake_F2
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Earthquake_F2')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Earthquake_F3
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Earthquake_F3')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Earthquake_F4
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Earthquake_F4')
  end object
  
  // Skill Animation Container
  begin object class=UI_Texture_Storage Name=Skill_Animation_Container
    tag="Skill_Animation_Container"
    textureWidth=240
    textureHeight=240
    images(0)=SkillAnim_Earthquake_F1
    images(1)=SkillAnim_Earthquake_F2
    images(2)=SkillAnim_Earthquake_F3
    images(3)=SkillAnim_Earthquake_F4
  end object
  skillAnim=Skill_Animation_Container
  
}





















