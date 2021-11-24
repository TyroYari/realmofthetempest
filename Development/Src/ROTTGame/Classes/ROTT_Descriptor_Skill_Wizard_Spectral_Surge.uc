/*=============================================================================
 * ROTT_Descriptor_Skill_Wizard_Spectral_Surge
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * One of the wizards skill descriptors.
 *===========================================================================*/

class ROTT_Descriptor_Skill_Wizard_Spectral_Surge extends ROTT_Descriptor_Hero_Skill;

/*=============================================================================
 * initialize()
 *
 * this function should be called by the descriptor container to set headers
 * and paragraph formatting info
 *===========================================================================*/
public function setUI() {
  // Set header
  h1(
    "Spectral Surge"
  );
  
  // Set header
  h2(
    getHeader(targetingLabel)
  );
  
  // Set paragraph information
  p1(
    "An elemental attack that damages",
    "an enemy based on the number of",
    "Surge Glyphs collected"
  );
  
  // Set skill information for p2 and p3
  skillInfo(
    "Mana Cost: %mana",
    "Chance to spawn glyph: %chance%",
    "%min to %max damage per glyph"
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
      attribute = getManaEquation(level, 1.12, 0.74, 2.3, 5.0, 11.0);
      break;
      
    case GLYPH_SPAWN_CHANCE:
      attribute = 75; // was 60 in 1.2.1
      break;
      
    case ELEMENTAL_DAMAGE_MIN:
      attribute = 1 + 4 * level;
      //attribute = 0.6 * level;
      break;
    case ELEMENTAL_DAMAGE_MAX:
      attribute = 2 + (6 * level);
      //attribute = 1.2 + (1 * level);
      break;
      
    case REQUIRES_GLYPH:
      attribute = 1;
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
  skillIndex=WIZARD_SPECTRAL_SURGE
  parentTree=CLASS_TREE

  // Sfx
  combatSfx=SFX_COMBAT_ATTACK
  
  // Skill Attributes
  skillAttributes.add((attributeSet=COMBAT_ACTION_SET,mechanicType=MANA_COST,tag="%mana",font=DEFAULT_SMALL_BLUE,returnType=INTEGER));
  
  skillAttributes.add((attributeSet=GLYPH_SET,mechanicType=GLYPH_SPAWN_CHANCE,tag="%chance",font=DEFAULT_SMALL_BLUE,returnType=INTEGER));
  
  skillAttributes.add((attributeSet=COMBAT_ACTION_SET,mechanicType=ELEMENTAL_DAMAGE_MIN,tag="%min",font=DEFAULT_SMALL_ORANGE,returnType=DECIMAL));
  skillAttributes.add((attributeSet=COMBAT_ACTION_SET,mechanicType=ELEMENTAL_DAMAGE_MAX,tag="%max",font=DEFAULT_SMALL_ORANGE,returnType=DECIMAL));
  
  skillAttributes.add((attributeSet=COMBAT_ACTION_SET,mechanicType=GLYPH_COUNT_AMP,tag="%amp",font=DEFAULT_SMALL_WHITE,returnType=INTEGER));
  skillAttributes.add((attributeSet=COMBAT_ACTION_SET,mechanicType=REQUIRES_GLYPH,tag="%req",font=DEFAULT_SMALL_WHITE,returnType=INTEGER));
  
  // Skill Icon
  begin object class=UI_Texture_Info Name=Encounter_Skill_Icon_Spectral_Surge
    componentTextures.add(Texture2D'GUI_Skills.Encounter_Skill_Icon_Spectral_Surge')
  end object
  
  // Skill Icon Container
  begin object class=UI_Texture_Storage Name=Skill_Icon_Container
    tag="Skill_Icon_Container"
    textureWidth=108
    textureHeight=108
    images(0)=Encounter_Skill_Icon_Spectral_Surge
  end object
  skillIcon=Skill_Icon_Container
  
  // Skill Animation
  begin object class=UI_Texture_Info Name=Skill_Animation_Spectral_Surge_F1
    componentTextures.add(Texture2D'GUI_Skills.Skill_Animation_Spectral_Surge_F1')
  end object
  begin object class=UI_Texture_Info Name=Skill_Animation_Spectral_Surge_F2
    componentTextures.add(Texture2D'GUI_Skills.Skill_Animation_Spectral_Surge_F2')
  end object
  begin object class=UI_Texture_Info Name=Skill_Animation_Spectral_Surge_F3
    componentTextures.add(Texture2D'GUI_Skills.Skill_Animation_Spectral_Surge_F3')
  end object
  begin object class=UI_Texture_Info Name=Skill_Animation_Spectral_Surge_F4
    componentTextures.add(Texture2D'GUI_Skills.Skill_Animation_Spectral_Surge_F4')
  end object
  
  // Skill Animation Container
  begin object class=UI_Texture_Storage Name=Skill_Animation_Container
    tag="Skill_Animation_Container"
    textureWidth=240
    textureHeight=240
    images(0)=Skill_Animation_Spectral_Surge_F1
    images(1)=Skill_Animation_Spectral_Surge_F2
    images(2)=Skill_Animation_Spectral_Surge_F3
    images(3)=Skill_Animation_Spectral_Surge_F4
  end object 
  skillAnim=Skill_Animation_Container
  
}





















