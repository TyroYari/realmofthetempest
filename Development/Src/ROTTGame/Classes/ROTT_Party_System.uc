/*=============================================================================
 * ROTT_Party_System
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This object manages multiple parties of hero units.
 *  (See: ROTT_Party.uc)
 *
 * Features for party activities should be implemented here, if not
 * encapsulated in the parties themselves
 *===========================================================================*/

class ROTT_Party_System extends ROTT_Object;

// Parties belonging to this system are stored here
var privatewrite array<ROTT_Party> parties;

// The party controlled by the player is at this index
var privatewrite byte activePartyIndex;

/*=============================================================================
 * initSystem()
 *
 * This function prepares the party system data for a new party system.
 *===========================================================================*/
public function initSystem() {
  addParty();
}

/*=============================================================================
 * addParty()
 *
 * This function adds a party to the manager.
 *===========================================================================*/
public function addParty() {
  local ROTT_Party newParty;
  
  // Create a new party object
  newParty = new(self) class'ROTT_Party';
  newParty.initialize(parties.length);
  
  // Add to party list
  parties.addItem(newParty);
  
  // Set newest party as active party
  setActiveParty(parties.length - 1);
  
  // Unlock hyper glyphs with multi parties
  if (getNumberOfParties() > 1) {
    gameInfo.playerProfile.hyperUnlocked = true;
  }
}

/*=============================================================================
 * loadParty()
 *
 * This function adds a party to the manager from a save file.
 *===========================================================================*/
public function loadParty(ROTT_Party party) {
  parties.addItem(party);
}

/*=============================================================================
 * getNumberOfParties()
 *
 * This function returns the size of the party system.
 *===========================================================================*/
public function int getNumberOfParties() {
  return parties.length;
}

/*=============================================================================
 * setActiveParty()
 *
 * Sets a new active party index, and updates party status
 *===========================================================================*/
public function setActiveParty(int index) {
  if (index >= parties.Length) {
    grayLog("Warning (!) Active party index out of bounds");
    return;
  }
  
  // Filter out if no change
  if (index == activePartyIndex && parties[activePartyIndex].partyStatus == PARTY_ACTIVE) return;
  
  // Update new active party info
  parties[activePartyIndex].setPartyStatus(PARTY_IDLE);
  activePartyIndex = index;
  parties[activePartyIndex].setPartyStatus(PARTY_ACTIVE);
  
  // Check if defend settings are valid
  if (gameInfo.sceneManager != none) {
    if (gameInfo.sceneManager.sceneGameManager.gameOptionsExtendedPage != none) {
      if (!gameInfo.sceneManager.sceneGameManager.gameOptionsExtendedPage.isAlwaysDefendValid(, true)) {
        /// Temporary reset of first hero defend option
        gameInfo.optionsCookie.bAlwaysDefendHero1 = false;
        
        /// Prefer to have settings saved for each team, initialized as (0, 0, 0)
        /// Thus preserving the invariant across loading separate teams
      }
    }
  }
}

/**=============================================================================
 * activeNonempty()
 *
 * This function checks if a slot in the active party is empty or not.
 * 
 * Return:  True if not empty, False otherwise.
 *===========================================================================
public function bool activeNonempty(int slot) {
  return (parties[activePartyIndex].getHero(slot) != none);
}
*/

/*=============================================================================
 * getActiveParty()
 *
 * Accessor for the active party
 *===========================================================================*/
public function ROTT_Party getActiveParty() {
  return parties[activePartyIndex];
}

/*=============================================================================
 * getActiveHero()
 *
 * Accessor for a hero from the active party
 *===========================================================================*/
public function ROTT_Combat_Hero getActiveHero(int slot) {
  return parties[activePartyIndex].getHero(slot);
}

/*=============================================================================
 * getParty()
 *
 * Accessor for an arbitrary party
 *===========================================================================*/
public function ROTT_Party getParty(int slot) {
  if (slot >= parties.length) return none;
  return parties[slot];
}

/*=============================================================================
 * activePartySize()
 *
 * Active party size accessor
 *===========================================================================*/
public function int activePartySize() {
  return parties[activePartyIndex].getPartySize();
}

/*=============================================================================
 * getHeldItemEnchantment()
 *
 * Returns the sum of all held item boosts for a particular enchantment.
 *===========================================================================*/
public function int getHeldItemEnchantment(int enchantmentIndex) {
  local int i, j;
  local int bonus;
  
  // Scan every team
  for (i = 0; i < getNumberOfParties(); i++) {
    // Scan each hero in the team
    for (j = 0; j < getParty(i).getPartySize(); j++) {
      // Sum the bonuses
      bonus += getParty(i).getHero(j).getHeldItemEnchantment(enchantmentIndex);
    }
  }
  
  return bonus;
}


















