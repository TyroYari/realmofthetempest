/*=============================================================================
 * ROTT_Descriptor_List_Glyph_Skills
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * This is the data structure responsible for providing information to the game
 * about glyph skills on hero units.
 *
 * The mgmt window uses this to render glyph skill info. 
 *===========================================================================*/
 
class ROTT_Descriptor_List_Glyph_Skills extends ROTT_Descriptor_List;

/*=============================================================================
 * descriptors
 *===========================================================================*/
defaultProperties 
{
  // List of skills in this set
  scriptClasses(GLYPH_TREE_ARMOR)=class'ROTT_Descriptor_Skill_Glyph_Armor'
  scriptClasses(GLYPH_TREE_HEALTH)=class'ROTT_Descriptor_Skill_Glyph_Health'
  scriptClasses(GLYPH_TREE_DAMAGE)=class'ROTT_Descriptor_Skill_Glyph_Damage'
  scriptClasses(GLYPH_TREE_MANA)=class'ROTT_Descriptor_Skill_Glyph_Mana'
  scriptClasses(GLYPH_TREE_SPEED)=class'ROTT_Descriptor_Skill_Glyph_Speed'
  scriptClasses(GLYPH_TREE_MP_REGEN)=class'ROTT_Descriptor_Skill_Glyph_MpRegen'
  scriptClasses(GLYPH_TREE_ACCURACY)=class'ROTT_Descriptor_Skill_Glyph_Accuracy'
  scriptClasses(GLYPH_TREE_DODGE)=class'ROTT_Descriptor_Skill_Glyph_Dodge'
  
  /** ================================================================
  Do not attach static objects here, they need to know gameInfo, which
  makes garbage collection a nightmare if they arent dynamic objects
  **===============================================================**/
}







