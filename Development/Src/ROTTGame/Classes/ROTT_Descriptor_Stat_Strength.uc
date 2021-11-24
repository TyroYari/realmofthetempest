/*=============================================================================
 * ROTT_Descriptor_Stat_Strength
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * This class stores information to display on the mgmt window for stats
 *===========================================================================*/
  
class ROTT_Descriptor_Stat_Strength extends ROTT_Descriptor_Stat;

/*=============================================================================
 * initialize()
 *
 * this function should be called by the descriptor container to set headers
 * and paragraph formatting info
 *===========================================================================*/
public function initialize() {
  // Set header
  h1(
    "Strength",
  );
  
  // Set header
  h2(
    "",
  );
  
  // Set paragraph information
  p1(
    "Increases physical damage.",
    "",
    "",
  );
  
  // Set paragraph information
  p2(
    "",
    "",
    "",
    "",
  );
  
  // Set paragraph information
  affinityInfo(
    "%strengthAffinity Benefit"
  );
  
}

defaultProperties 
{
  
}


















