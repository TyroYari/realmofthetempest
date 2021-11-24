/*=============================================================================
 * ROTT_Descriptor_List_Stats
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * This is the data structure responsible for providing information to the game
 * about primary stats on combat units.
 *
 * The mgmt window uses this to render stat info. 
 *===========================================================================*/
  
class ROTT_Descriptor_List_Stats extends ROTT_Descriptor_List;

enum StatSetEnum {
  PRIMARY_STAT_VITALITY,
  PRIMARY_STAT_STRENGTH,
  PRIMARY_STAT_COURAGE,
  PRIMARY_STAT_FOCUS,
};

/*=============================================================================
 * descriptors
 *===========================================================================*/
defaultProperties 
{
  scriptClasses(PRIMARY_STAT_VITALITY)=class'ROTT_Descriptor_Stat_Vitality'
  scriptClasses(PRIMARY_STAT_STRENGTH)=class'ROTT_Descriptor_Stat_Strength'
  scriptClasses(PRIMARY_STAT_COURAGE)=class'ROTT_Descriptor_Stat_Courage'
  scriptClasses(PRIMARY_STAT_FOCUS)=class'ROTT_Descriptor_Stat_Focus'
}
















