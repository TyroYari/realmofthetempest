/*=============================================================================
 * ROTT_Descriptor_List_Wizard_Skills
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * This is the data structure responsible for providing information to the game
 * about wizard skills on hero units.
 *
 * The mgmt window uses this to render wizard skill info. 
 *===========================================================================*/

class ROTT_Descriptor_List_Wizard_Skills extends ROTT_Descriptor_List;

// A list of all skills in this set
enum WizardSkills {
  WIZARD_STARBOLT,
  WIZARD_STARDUST,
  WIZARD_SPECTRAL_SURGE,
  WIZARD_ARCANE_SIGIL,
  WIZARD_DEVOTION,
  WIZARD_PLASMA_SHROUD,
  WIZARD_BLACK_HOLE,
  WIZARD_ASTRAL_FIRE,
};

/*=============================================================================
 * descriptors
 *===========================================================================*/
defaultProperties 
{
  // List of skills in this set
  scriptClasses(WIZARD_STARBOLT)=class'ROTT_Descriptor_Skill_Wizard_Starbolt'
  scriptClasses(WIZARD_STARDUST)=class'ROTT_Descriptor_Skill_Wizard_Stardust'
  scriptClasses(WIZARD_SPECTRAL_SURGE)=class'ROTT_Descriptor_Skill_Wizard_Spectral_Surge'
  scriptClasses(WIZARD_ARCANE_SIGIL)=class'ROTT_Descriptor_Skill_Wizard_Arcane_Sigil'
  scriptClasses(WIZARD_DEVOTION)=class'ROTT_Descriptor_Skill_Wizard_Devotion'
  scriptClasses(WIZARD_PLASMA_SHROUD)=class'ROTT_Descriptor_Skill_Wizard_Plasma_Shroud'
  scriptClasses(WIZARD_BLACK_HOLE)=class'ROTT_Descriptor_Skill_Wizard_Black_Hole'
  scriptClasses(WIZARD_ASTRAL_FIRE)=class'ROTT_Descriptor_Skill_Wizard_Astral_Fire'
  
  /** ================================================================
  Do not attach static objects here, they need to know gameInfo, which
  makes garbage collection a nightmare if they arent dynamic objects
  **===============================================================**/
}







