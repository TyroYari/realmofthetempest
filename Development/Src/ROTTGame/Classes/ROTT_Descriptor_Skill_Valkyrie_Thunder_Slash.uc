/*=============================================================================
 * ROTT_Descriptor_Skill_Valkyrie_Thunder_Slash
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * One of the valkyries skill descriptors.
 *===========================================================================*/

class ROTT_Descriptor_Skill_Valkyrie_Thunder_Slash extends ROTT_Descriptor_Hero_Skill;

/// name ideas for electric skill theme
// valor, electric, sigil, mark, arc, flash, stroke, wave

/*=============================================================================
 * initialize()
 *
 * this function should be called by the descriptor container to set headers
 * and paragraph formatting info
 *===========================================================================*/
public function setUI() {
  // Set header
  h1(
    "Thunder Slash"
  );
  
  // Set header
  h2(
    getHeader(targetingLabel)
  );
  
  // Set paragraph information
  p1(
    "An elemental attack that damages the",
    "entire enemy team.",
    ""
  );
  
  // Set skill information for p2 and p3
  skillInfo(      
    "Mana Cost: %mana",
    "%min to %max damage to all enemies",
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
      attribute = getManaEquation(level, 1.165, 0.825, 2.5, 18.0, 32.0);
      break;
      
    case ELEMENTAL_DAMAGE_MIN:
      attribute = 1;
      break;
    case ELEMENTAL_DAMAGE_MAX:
      attribute = 2 + (level * 64) * (1 + int(level / 2.f) / 3.f);
      //attribute = level * 26 + 2;
      ///attribute = level * 12 + 6;
      //attribute = level * 10 + 4;
      break;
      
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
  skillIndex=VALKYRIE_THUNDER_SLASH
  parentTree=CLASS_TREE

  // Sfx
  combatSfx=SFX_COMBAT_ATTACK
  
  // Skill Attributes
  skillAttributes.add((attributeSet=COMBAT_ACTION_SET,mechanicType=MANA_COST,tag="%mana",font=DEFAULT_SMALL_BLUE,returnType=INTEGER));
  
  skillAttributes.add((attributeSet=COMBAT_ACTION_SET,mechanicType=ELEMENTAL_DAMAGE_MIN,tag="%min",font=DEFAULT_SMALL_ORANGE,returnType=INTEGER));
  skillAttributes.add((attributeSet=COMBAT_ACTION_SET,mechanicType=ELEMENTAL_DAMAGE_MAX,tag="%max",font=DEFAULT_SMALL_ORANGE,returnType=INTEGER));

  // Skill Icon
  begin object class=UI_Texture_Info Name=Encounter_Skill_Icon_Thunder_Slash
    componentTextures.add(Texture2D'GUI_Skills.Encounter_Skill_Icon_Thunder_Slash')
  end object
  
  // Skill Icon Container
  begin object class=UI_Texture_Storage Name=Skill_Icon_Container
    tag="Skill_Icon_Container"
    textureWidth=108
    textureHeight=108
    images(0)=Encounter_Skill_Icon_Thunder_Slash
  end object
  skillIcon=Skill_Icon_Container
  
  
  // Skill Animation
  begin object class=UI_Texture_Info Name=Skill_Animation_Lightning_Diagonal_F1
    componentTextures.add(Texture2D'GUI_Skills.Lightning_Diagonal.Skill_Animation_Lightning_Diagonal_F1')
  end object
  begin object class=UI_Texture_Info Name=Skill_Animation_Lightning_Diagonal_F2
    componentTextures.add(Texture2D'GUI_Skills.Lightning_Diagonal.Skill_Animation_Lightning_Diagonal_F2')
  end object
  begin object class=UI_Texture_Info Name=Skill_Animation_Lightning_Diagonal_F3
    componentTextures.add(Texture2D'GUI_Skills.Lightning_Diagonal.Skill_Animation_Lightning_Diagonal_F3')
  end object
  begin object class=UI_Texture_Info Name=Skill_Animation_Lightning_Diagonal_F4
    componentTextures.add(Texture2D'GUI_Skills.Lightning_Diagonal.Skill_Animation_Lightning_Diagonal_F4')
  end object
  begin object class=UI_Texture_Info Name=Skill_Animation_Lightning_Diagonal_F5
    componentTextures.add(Texture2D'GUI_Skills.Lightning_Diagonal.Skill_Animation_Lightning_Diagonal_F5')
  end object
  
  // Skill Animation Container
  begin object class=UI_Texture_Storage Name=Skill_Bnimation_Container
    tag="Skill_Bnimation_Container"
    textureWidth=240
    textureHeight=240
    images(0)=Skill_Animation_Lightning_Diagonal_F1
    images(1)=Skill_Animation_Lightning_Diagonal_F2
    images(2)=Skill_Animation_Lightning_Diagonal_F3
    images(3)=Skill_Animation_Lightning_Diagonal_F4
    images(4)=Skill_Animation_Lightning_Diagonal_F5
  end object
  skillAnim=Skill_Bnimation_Container
  
}





















