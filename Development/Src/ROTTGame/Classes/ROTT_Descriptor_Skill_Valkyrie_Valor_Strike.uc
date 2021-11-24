/*=============================================================================
 * ROTT_Descriptor_Skill_Valkyrie_Valor_Strike
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * One of the valkyries skill descriptors.
 *===========================================================================*/

class ROTT_Descriptor_Skill_Valkyrie_Valor_Strike extends ROTT_Descriptor_Hero_Skill;

/*=============================================================================
 * initialize()
 *
 * this function should be called by the descriptor container to set headers
 * and paragraph formatting info
 *===========================================================================*/
public function setUI() {
  // Set header
  h1(
    "Valor Strike"
  );
  
  // Set header
  h2(
    getHeader(targetingLabel)
  );
  
  // Set paragraph information
  p1(
    "A physical attack with an increased",
    "chance of critical strike.",
    ""
  );
  
  // Set skill information for p2 and p3
  skillInfo(      
    "Mana Cost: %mana",
    "+%crit% Critical Strike Chance",
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
      //attribute = getManaEquation(level, 1.15, 0.8, 2.4, 8.0, 24.0);
      attribute = getManaEquation(level, 1.15, 0.8, 2.4, 8.0, 14.0);
      break;
      
    case PHYSICAL_DAMAGE_MIN:
      attribute = hero.subStats[MIN_PHYSICAL_DAMAGE];
      break;
    case PHYSICAL_DAMAGE_MAX:
      attribute = hero.subStats[MAX_PHYSICAL_DAMAGE];
      break;
      
    case INCREASED_CRIT_CHANCE:
      attribute = 40 * level + 20 * (level / 2); // integer division intended
      //attribute = 30 * level + 20 * (level / 2); // integer division intended
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
  skillIndex=VALKYRIE_VALOR_STRIKE
  parentTree=CLASS_TREE

  // Sound effect
  combatSfx=SFX_COMBAT_ATTACK
  
  // Skill Attributes
  skillAttributes.add((attributeSet=COMBAT_ACTION_SET,mechanicType=MANA_COST,tag="%mana",font=DEFAULT_SMALL_BLUE,returnType=INTEGER));
  
  skillAttributes.add((attributeSet=COMBAT_ACTION_SET,mechanicType=PHYSICAL_DAMAGE_MIN,tag="%min",font=DEFAULT_SMALL_ORANGE,returnType=INTEGER));
  skillAttributes.add((attributeSet=COMBAT_ACTION_SET,mechanicType=PHYSICAL_DAMAGE_MAX,tag="%max",font=DEFAULT_SMALL_ORANGE,returnType=INTEGER));
  
  skillAttributes.add((attributeSet=COMBAT_ACTION_SET,mechanicType=INCREASED_CRIT_CHANCE,tag="%crit",font=DEFAULT_SMALL_ORANGE,returnType=INTEGER));

  // Skill Icon
  begin object class=UI_Texture_Info Name=Encounter_Skill_Icon_Valor_Strike
    componentTextures.add(Texture2D'GUI_Skills.Encounter_Skill_Icon_Valor_Strike')
  end object
  
  // Skill Icon Container
  begin object class=UI_Texture_Storage Name=Skill_Icon_Container
    tag="Skill_Icon_Container"
    textureWidth=108
    textureHeight=108
    images(0)=Encounter_Skill_Icon_Valor_Strike
  end object
  skillIcon=Skill_Icon_Container
  
  // Skill Animation
  begin object class=UI_Texture_Info Name=SkillAnim_Valkyrie_Valor_Strike_F1
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Valkyrie_Valor_Strike_F1')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Valkyrie_Valor_Strike_F2
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Valkyrie_Valor_Strike_F2')
  end object
  
  // Skill Animation Container
  begin object class=UI_Texture_Storage Name=Skill_Animation_Container
    tag="Skill_Animation_Container"
    textureWidth=240
    textureHeight=240
    images(0)=SkillAnim_Valkyrie_Valor_Strike_F1
    images(1)=SkillAnim_Valkyrie_Valor_Strike_F2
  end object
  skillAnim=Skill_Animation_Container
  
  
}





















