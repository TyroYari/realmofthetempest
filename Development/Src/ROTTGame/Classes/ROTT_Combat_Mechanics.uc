/*=============================================================================
 * ROTT_Combat_Mechanics
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * This class maintains an array of combat mechanics from a combat action
 *===========================================================================*/

class ROTT_Combat_Mechanics extends ROTT_Combat_Object;

// Used to store a list of mechanics
var public MechanicRange list[MechanicTypes];

// Used to force all incoming values to flip from positive to negative
var private int negateAmp;

/*=============================================================================
 * addMechanic
 *
 * Used to add (or subtract) a value to a mechanic at the given index
 *===========================================================================*/
public function addMechanic
(
  MechanicTypes index,
  float min,
  optional float max = min
)
{
  list[index].enabled = true;
  
  switch (index) {
    case ADD_ATTACK_TIME_PERCENT:
      // Set value to inverse... to the power of -1
      list[index].min = min ** -1;
      list[index].max = max ** -1;
      break;
    default:
      list[index].min += min * negateAmp;
      list[index].max += max * negateAmp;
      break;
  }
}
 
/*=============================================================================
 * multiplyMechanic
 *
 * Used to multiply the mechanic at the given index
 *===========================================================================*/
public function multiplyMechanic
(
  MechanicTypes index,
  float amp
)
{
  list[index].min *= amp;
  list[index].max *= amp;
}

/*=============================================================================
 * negateValues
 *
 * This inverts the mechanic lists behavior from positive to negative
 *===========================================================================*/
public function negateValues() { 
  local int i;
  
  // Flip any existing values
  for (i = 0; i < MechanicTypes.enumCount; i++) {
    switch (i) {
      case ADD_ATTACK_TIME_PERCENT:
        list[i].min = list[i].min ** -1;
        list[i].max = list[i].max ** -1;
        break;
      default:
        multiplyMechanic(MechanicTypes(i), -1);
        break;
    }
  }
  
  // Flip all incoming values from now on
  negateAmp *= -1;
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  negateAmp=1
  
  // 100 percent: 1x multiplier by default
  list(TARGET_DEMORALIZED_AMP)=(min=100,max=100)
}
