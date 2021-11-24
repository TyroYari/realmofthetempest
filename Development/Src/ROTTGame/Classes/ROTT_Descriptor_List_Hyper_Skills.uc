/*=============================================================================
 * ROTT_Descriptor_List_Hyper_Skills
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * This is the data structure responsible for providing information to the game
 * about hyper glyph skills.
 *
 * The mgmt window uses this to render glyph skill info. 
 *===========================================================================*/
 
class ROTT_Descriptor_List_Hyper_Skills extends ROTT_Descriptor_List;

/*=============================================================================
 * descriptors
 *===========================================================================*/
defaultProperties 
{
  // List of skills in this set
  scriptClasses(GLYPH_TREE_ARMOR)=class'ROTT_Descriptor_Skill_Hyper_Armor'
  scriptClasses(GLYPH_TREE_HEALTH)=class'ROTT_Descriptor_Skill_Hyper_Health'
  scriptClasses(GLYPH_TREE_DAMAGE)=class'ROTT_Descriptor_Skill_Hyper_Damage'
  scriptClasses(GLYPH_TREE_MANA)=class'ROTT_Descriptor_Skill_Hyper_Mana'
  scriptClasses(GLYPH_TREE_SPEED)=class'ROTT_Descriptor_Skill_Hyper_Speed'
  scriptClasses(GLYPH_TREE_MP_REGEN)=class'ROTT_Descriptor_Skill_Hyper_Mana_Regen'
  scriptClasses(GLYPH_TREE_ACCURACY)=class'ROTT_Descriptor_Skill_Hyper_Accuracy'
  scriptClasses(GLYPH_TREE_DODGE)=class'ROTT_Descriptor_Skill_Hyper_Dodge'
}







