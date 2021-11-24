/*=============================================================================
 * ROTT_Descriptor_Stat_Focus
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * This class stores information to display on the mgmt window for stats
 *===========================================================================*/

class ROTT_Descriptor_Stat_Focus extends ROTT_Descriptor_Stat;

/*=============================================================================
 * initialize()
 *
 * this function should be called by the descriptor container to set headers
 * and paragraph formatting info
 *===========================================================================*/
public function initialize() {
  // Set header
  h1(
    "Focus",
  );
  
  // Set header
  h2(
    "",
  );
  
  // Set paragraph information
  p1(
    "Increases max mana and dodge rating,",
    "and improves morale.",
    "",
  );
  
  // Set paragraph information
  p2(
    "When health drops below morale",
    "threshold, luck and speed are",
    "reduced.",
    "",
  );
  
  // Set paragraph information
  affinityInfo(
    "%focusAffinity Benefit"
  );
  
}

defaultProperties 
{
  
}



















