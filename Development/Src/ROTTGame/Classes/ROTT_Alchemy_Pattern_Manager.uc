/*=============================================================================
 * ROTT_Alchemy_Pattern_Manager
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: Manages an alchemy minigame pattern.
 *===========================================================================*/
 
class ROTT_Alchemy_Pattern_Manager extends object;

// Alchemy game info
var public ROTT_UI_Alchemy_Tile_Manager alchemyManager;

// Tile Group Info
struct TileGroup {
  var array<byte> tileIndices;
};

// Store next tile group to be added to pattern list
var private TileGroup nextTileGroup; 

// Pattern list
var private array<TileGroup> patternList;

// Pattern reglation info
var privatewrite float groupDelayTime;
var privatewrite float heatingStateTime;
var privatewrite float hotStateTime;

// Time tracking
var private float remainingGroupDelayTime;

// Pattern completion status
var private bool bCompleted;

/*============================================================================= 
 * setPatternParameters()
 *
 * Adds a tile by index to the next group in the pattern.
 *===========================================================================*/
public function setPatternParameters
(
  float timeBetweenGroups,
  float timeHeatingUp,
  float timeStayingHot
)
{
  // Set time parameters
  groupDelayTime = timeBetweenGroups * getSpeedAmp();
  heatingStateTime = timeHeatingUp * getSpeedAmp();
  hotStateTime = timeStayingHot * getSpeedAmp();
  
  // Set remaining time until next tile group
  remainingGroupDelayTime = groupDelayTime;
  
}

/*============================================================================= 
 * addTarget()
 *
 * Adds a tile by index to the next group in the pattern.
 *===========================================================================*/
public function addTarget(coerce byte tileIndex) {
  nextTileGroup.tileIndices.addItem(tileIndex);
}

/*============================================================================= 
 * submitTargets()
 *
 * Submits a tile group to the pattern.
 *===========================================================================*/
public function submitTargets() {
  // Move tile vector to pattern list
  patternList.addItem(nextTileGroup);
  
  // Reset tile vector
  nextTileGroup.tileIndices.length = 0;
}

/*=============================================================================
 * elapseTimer()
 *
 * Increments time every engine tick.
 *===========================================================================*/
public function elapseTimer(float deltaTime) {
  local int i;
  
  // Track time progression
  remainingGroupDelayTime -= deltaTime;
  
  // Check for group completed
  if (remainingGroupDelayTime < 0) {
    // Check if completed
    if (bCompleted) {
      alchemyManager.patternCompleted();
      return;
    }
    
    // Reset time tracking
    remainingGroupDelayTime += groupDelayTime;
    
    // Set heat pattern
    for (i = 0; i < patternList[0].tileIndices.length; i++) {
      alchemyManager.tiles[patternList[0].tileIndices[i] - 1].setHeatPattern(
        heatingStateTime, 
        hotStateTime
      );
    }
    
    // Remove completed pattern
    patternList.remove(0, 1);
    if (patternList.length == 0) {
      bCompleted = true;
    }
  }
}

/*============================================================================= 
 * reset()
 *
 * Clears all pattern information.
 *===========================================================================*/
public function reset() {
  bCompleted = false;
  patternList.length = 0;
}

/*============================================================================= 
 * getSpeedAmp()
 *
 * Returns a scalar to 
 *===========================================================================*/
private function float getSpeedAmp() {
  switch (alchemyManager.level)  {
    case 1:  return 1.0;  
    case 2:  return 0.6;  
    case 3:   return 0.4;  
    case 4:   return 0.3;  
    default: return 0.25;
  }
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  
}
