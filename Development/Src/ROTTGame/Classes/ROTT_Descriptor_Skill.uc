/*=============================================================================
 * ROTT_Descriptor_Skill
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * This class consolodates all information pertaining to a given skill.  
 * 
 * Usage:
 *  Provides the UI with skill information (see: ROTT_UI_Page_Mgmt_Window)
 *  Defines combat action behavior
 *===========================================================================*/
  
class ROTT_Descriptor_Skill extends ROTT_Descriptor
abstract;

const DEBUFF_CHANCE = 80;
const BUFF_CHANCE = 100;
  
/*
// Range for use in combat packets
struct FloatRange {
  var float min;
  var float max;
};

// Combat packet info
struct CombatMechanic {
  var MechanicTypes packetType;
  var float value;
  var FloatRange range;
};
*/
/**============================================================================= 
 * makePacket()
 *
 * This is used to create combat exchange info for a combat action
 *===========================================================================
protected function CombatMechanic makePacket
(
  MechanicTypes packetType,
  float value
) 
{
  local CombatMechanic packet;

  packet.packetType = packetType;
  packet.value = value;
  
  return packet;
}
*/
/**============================================================================= 
 * makeRangedPacket()
 *
 * This is used to create combat exchange info for a combat action
 *===========================================================================
protected function CombatMechanic makeRangedPacket
(
  MechanicTypes packetType,
  float min,
  float max
) 
{
  local CombatMechanic packet;
  local FloatRange range;
  
  range.min = min;
  range.max = max;
  
  packet.packetType = packetType;
  packet.range = range;
  
  return packet;
}
*/
/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties 
{
  
}
