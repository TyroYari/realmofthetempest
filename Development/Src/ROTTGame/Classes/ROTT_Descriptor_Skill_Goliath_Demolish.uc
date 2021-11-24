/*=============================================================================
 * ROTT_Descriptor_Skill_Goliath_Demolish
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * One of the valkyries skill descriptors.
 *===========================================================================*/

class ROTT_Descriptor_Skill_Goliath_Demolish extends ROTT_Descriptor_Hero_Skill;

/*=============================================================================
 * initialize()
 *
 * this function should be called by the descriptor container to set headers
 * and paragraph formatting info
 *===========================================================================*/
public function setUI() {
  // Set header
  h1(
    "Demolish"
  );
  
  // Set header
  h2(
    getHeader(targetingLabel)
  );
  
  // Set paragraph information
  p1(
    "A physical attack that deals high",
    "damage, but doubles the time until",
    "your next attack."
  );
  
  // Set skill information for p2 and p3
  skillInfo(      
    "Mana Cost: %mana",
    "%min to %max damage",
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
    case MANA_COST:
      attribute = getManaEquation(level, 1.2, 0.845, 2.33, 10.0, 30.0);
      break;
    case ADD_STANCE_COUNT:
      attribute = 1; // Length of attack time modifier
      break;
      
    case PHYSICAL_DAMAGE_MIN:
      attribute = hero.subStats[MIN_PHYSICAL_DAMAGE] * (2.6 + (1.3 * level));
      ///attribute = hero.subStats[MIN_PHYSICAL_DAMAGE] * (1.3 + (0.65 * level));
      //attribute = (5.0 / 3 * hero.subStats[MIN_PHYSICAL_DAMAGE]);
      //attribute += ((level * hero.subStats[MIN_PHYSICAL_DAMAGE]) / 10.0);
      break;
    case PHYSICAL_DAMAGE_MAX:
      attribute = hero.subStats[MAX_PHYSICAL_DAMAGE] * (3.9 + (1.7 * level));
      ///attribute = hero.subStats[MAX_PHYSICAL_DAMAGE] * (1.95 + (0.85 * level));
      //attribute = (8.0 / 3 * hero.subStats[MAX_PHYSICAL_DAMAGE]);
      //attribute += ((level * hero.subStats[MAX_PHYSICAL_DAMAGE]) / 4.0);
      break;
      
    case ATTACK_TIME_AMPLIFIER:
      attribute = 2;
      break;
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
  skillIndex=GOLIATH_DEMOLISH
  parentTree=CLASS_TREE

  // Sound effect
  combatSfx=SFX_COMBAT_ATTACK
  
  // Skill Attributes
  skillAttributes.add((attributeSet=COMBAT_ACTION_SET,mechanicType=MANA_COST,tag="%mana",font=DEFAULT_SMALL_BLUE,returnType=INTEGER));
  skillAttributes.add((attributeSet=COMBAT_ACTION_SET,mechanicType=ADD_STANCE_COUNT,tag="%stance",font=DEFAULT_SMALL_WHITE,returnType=INTEGER));
  
  skillAttributes.add((attributeSet=COMBAT_ACTION_SET,mechanicType=PHYSICAL_DAMAGE_MIN,tag="%min",font=DEFAULT_SMALL_ORANGE,returnType=INTEGER));
  skillAttributes.add((attributeSet=COMBAT_ACTION_SET,mechanicType=PHYSICAL_DAMAGE_MAX,tag="%max",font=DEFAULT_SMALL_ORANGE,returnType=INTEGER));
  
  skillAttributes.add((attributeSet=ADD_STANCE_SET,mechanicType=ATTACK_TIME_AMPLIFIER,tag="%atb",font=DEFAULT_SMALL_WHITE,returnType=DECIMAL));
  
  // Skill Icon
  begin object class=UI_Texture_Info Name=Encounter_Skill_Icon_Demolition
    componentTextures.add(Texture2D'GUI_Skills.Encounter_Skill_Icon_Demolition'
  end object
  
  // Skill Icon Container
  begin object class=UI_Texture_Storage Name=Skill_Icon_Container
    tag="Skill_Icon_Container"
    textureWidth=108
    textureHeight=108
    images(0)=Encounter_Skill_Icon_Demolition
  end object
  skillIcon=Skill_Icon_Container
  
  
  // Skill Animation
  begin object class=UI_Texture_Info Name=SkillAnim_Demolish_F1
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Demolish_F1')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Demolish_F2
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Demolish_F2')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Demolish_F3
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Demolish_F3')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Demolish_F4
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Demolish_F4')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Demolish_F5
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Demolish_F5')
  end object
  
  // Skill Animation Container
  begin object class=UI_Texture_Storage Name=Skill_Animation_Container
    tag="Skill_Animation_Container"
    textureWidth=240
    textureHeight=240
    images(0)=SkillAnim_Demolish_F1
    images(1)=SkillAnim_Demolish_F2
    images(2)=SkillAnim_Demolish_F3
    images(3)=SkillAnim_Demolish_F4
    images(4)=SkillAnim_Demolish_F5
  end object
  skillAnim=Skill_Animation_Container
  
}





















