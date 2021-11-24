/*=============================================================================
 * ROTT_Descriptor_Stat
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * This class stores information to display on the mgmt window for stats
 *===========================================================================*/

class ROTT_Descriptor_Stat extends ROTT_Descriptor 
abstract;
 
// Affinity information, used to generate display text
var protected string affinityText;

/*=============================================================================
 * formatScript()
 *
 * This must be called when the script is accessed from the descriptor list
 * container.  
 *===========================================================================*/
public function formatScript(ROTT_Combat_Hero hero) {
  
  // Revert p3 with replacement codes
  p3(
    affinityText,
    "",
    "",
    ""
  );
  
  // Replacement codes
  replace("%vitalityAffinity", PCase(hero.statAffinities[PRIMARY_VITALITY]));
  replace("%strengthAffinity", PCase(hero.statAffinities[PRIMARY_STRENGTH]));
  replace("%courageAffinity", PCase(hero.statAffinities[PRIMARY_COURAGE]));
  replace("%focusAffinity", PCase(hero.statAffinities[PRIMARY_FOCUS]));
  
  // Highlight colors
  highlight("Minor Benefit", DEFAULT_SMALL_YELLOW);
  highlight("Average Benefit", DEFAULT_SMALL_CYAN);
  highlight("Major Benefit", DEFAULT_SMALL_GREEN);
  
}

/*=============================================================================
 * affinityInfo()
 *
 * this function sets text that describes the affinity for p3
 *===========================================================================*/
final protected function affinityInfo(string affinityStr)
{
  affinityText = affinityStr;
}

defaultProperties 
{
  
}


















