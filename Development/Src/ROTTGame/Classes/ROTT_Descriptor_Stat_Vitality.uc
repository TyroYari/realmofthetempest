/*=============================================================================
 * ROTT_Descriptor_Stat_Vitality
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * This class stores information to display on the mgmt window for stats
 *===========================================================================*/
  
class ROTT_Descriptor_Stat_Vitality extends ROTT_Descriptor_Stat;

/*=============================================================================
 * initialize()
 *
 * this function should be called by the descriptor container to set headers
 * and paragraph formatting info
 *===========================================================================*/
public function initialize() {
  // Set header
  h1(
    "Vitality",
  );
  
  // Set header
  h2(
    "",
  );
  
  // Set paragraph information
  p1(
    "Increases max health.",
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
  
  // This writes to p3
  affinityInfo(
    "%vitalityAffinity Benefit"
  );
  
}

defaultProperties 
{
  
}




















