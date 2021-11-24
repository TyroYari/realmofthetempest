/*=============================================================================
 * ROTT_Descriptor_Stat_Courage
 * 
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * This class stores information to display on the mgmt window for stats
 *===========================================================================*/
  
class ROTT_Descriptor_Stat_Courage extends ROTT_Descriptor_Stat;

/*=============================================================================
 * initialize()
 *
 * this function should be called by the descriptor container to set headers
 * and paragraph formatting info
 *===========================================================================*/
public function initialize() {
  // Set header
  h1(
    "Courage",
  );
  
  // Set header
  h2(
    "",
  );
  
  // Set paragraph information
  p1(
    "Increases speed rating for faster attack",
    "interval, improves critical strike, and",
    "increases accuracy rating.",
  );
  
  // Set paragraph information
  p2(
    "In combat, attack interval will be",
    "multiplied by the size of your team.",
    "",
    "",
  );
  
  // This writes to p3
  affinityInfo(
    "%courageAffinity Benefit"
  );
}

defaultProperties 
{
  
}

















