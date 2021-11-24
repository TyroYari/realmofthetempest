/*=============================================================================
 * ROTT_UI_Alchemy_Tile_Manager
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: Manages graphics and gameplay mechanics for an alchemy tile.
 *===========================================================================*/
 
class ROTT_UI_Alchemy_Tile_Manager extends UI_Container;

// Store the level to display for this round
var privatewrite int level;

// Store the tile claim count
var private int claimCount;

// Tiles
var privatewrite ROTT_UI_Alchemy_Tile tiles[25];

// Store pattern management
var privatewrite ROTT_Alchemy_Pattern_Manager patternManager;

// Combat action list
var private array<delegate<patternDelegate> > patternAlgorithms; 

// Pattern queue for better randomization
var private array<delegate<patternDelegate> > patternQueue;

// Reference
var private ROTT_Game_Info gameInfo;

delegate patternDelegate();

/*============================================================================= 
 * Initialize Component
 *
 * Description: This event is called as the UI is loaded.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  local int x, y, index;
  
  super.initializeComponent(newTag);
  
  // Create tiles
  for (x = 0; x < 5; x++) {
    for (y = 0; y < 5; y++) {
      index = x + y * 5;
      tiles[index] = new class'ROTT_UI_Alchemy_Tile';
      tiles[index].initializeComponent();
      tiles[index].updatePosition(getX() + 140 * x, getY() + 140 * y);
      tiles[index].tileManager = self;
      componentList.addItem(tiles[index]);
    }
  }
  
  // Create manager
  patternManager = new class'ROTT_Alchemy_Pattern_Manager';
  patternManager.alchemyManager = self;
  
  // Populate pattern algorithms
  patternAlgorithms.addItem(setPattern1);
  patternAlgorithms.addItem(setPattern2);
  patternAlgorithms.addItem(setPattern3);
  patternAlgorithms.addItem(setPattern4);
  patternAlgorithms.addItem(setPattern5);
  patternAlgorithms.addItem(setPattern6);
  
  gameInfo = ROTT_Game_Info(class'WorldInfo'.static.getWorldInfo().game);
}

/*=============================================================================
 * elapseTimer()
 *
 * Increments time every engine tick.
 *===========================================================================*/
public function elapseTimer(float deltaTime, float gameSpeedOverride) {
  super.elapseTimer(deltaTime, gameSpeedOverride);
  patternManager.elapseTimer(deltaTime);
}

/*============================================================================= 
 * claim()
 *
 * Called to imbue magic into a tile.
 *===========================================================================*/
public function claim(int tileIndex) {
  // Attempt to claim the selected tile
  if (tiles[tileIndex].claim()) {
    // If claim succeeded count it
    claimCount++;
    
    // Check if round completed
    if (claimCount == 25) {
      nextRound();
      gameInfo.sfxBox.playSfx(SFX_ALCHEMY_LEVEL_CLEAR);
    } else {
      // Collection sfx
      gameInfo.sfxBox.playSfx(SFX_ALCHEMY_COLLECT);
    }
  }
}

/*============================================================================= 
 * nextRound()
 *
 * Called to proceed to next round
 *===========================================================================*/
public function nextRound() {
  local int i;
  
  // Reset and progress level
  claimCount = 0;
  level++;
  
  // Reset tiles
  for (i = 0; i < 25; i++) {
    tiles[i].nextLevel();
  }
  
  // Clear pattern and randomly select a new one
  setRandomPattern();
}

/*============================================================================= 
 * patternCompleted()
 *
 * Called when a pattern completes.
 *===========================================================================*/
public function patternCompleted() {
  setRandomPattern();
}

/*============================================================================= 
 * setRandomPattern()
 *
 * Called to randomly select a pattern.
 *===========================================================================*/
public function setRandomPattern() {
  local array<delegate<patternDelegate> > tempPatternList;
  local delegate<patternDelegate> nextPattern;
  local int randomIndex;
  local int i;
  patternManager.reset();
  
  // Check if pattern queue is empty
  if (patternQueue.length == 0) {
    // Add two of each algorithm
    for (i = 0; i < patternAlgorithms.length; i++) {
      tempPatternList.addItem(patternAlgorithms[i]);
      tempPatternList.addItem(patternAlgorithms[i]);
    }
    
    // Shuffle
    while (tempPatternList.length > 0) {
      randomIndex = rand(tempPatternList.length);
      patternQueue.addItem(tempPatternList[randomIndex]);
      tempPatternList.remove(randomIndex, 1);
    }
  }
  
  // Call next pattern
  nextPattern = patternQueue[0];
  patternQueue.remove(0, 1);
  nextPattern();
}

/*============================================================================= 
 * reset()
 *
 * Called to reset all time manager information.
 *===========================================================================*/
public function reset() {
  local int i;
  
  claimCount = 0;
  level = 1;
  
  // Reset all tile info
  for (i = 0; i < 25; i++) {
    tiles[i].reset();
  }
  
  patternManager.reset();
}

/*============================================================================= 
 * addTarget()
 *
 * Adds a tile by index to the next group in the pattern.
 *===========================================================================*/
private function addTarget(int tileIndex) {
  patternManager.addTarget(tileIndex);
}

/*============================================================================= 
 * submitTargets()
 *
 * Submits a tile group to the pattern.
 *===========================================================================*/
private function submitTargets() {
  patternManager.submitTargets();
}

/*============================================================================= 
 * setPatternParameters()
 *
 * Sets interval times
 *===========================================================================*/
private function setPatternParameters
(
  float timeBetweenGroups,
  float timeHeatingUp,
  float timeStayingHot
)
{
  patternManager.setPatternParameters(
    timeBetweenGroups, 
    timeHeatingUp, 
    timeStayingHot
  );
}

/*============================================================================= 
 * setPattern1()
 *
 * Heat spirals from outside to inside.  
 *===========================================================================*/
public function setPattern1() {
  // Outer ring
  addTarget(1);
  addTarget(25);
  submitTargets();
  addTarget(2);
  addTarget(24);
  submitTargets();
  addTarget(3);
  addTarget(23);
  submitTargets();
  addTarget(4);
  addTarget(22);
  submitTargets();
  addTarget(5);
  addTarget(21);
  submitTargets();
  addTarget(10);
  addTarget(16);
  submitTargets();
  addTarget(15);
  addTarget(11);
  submitTargets();
  addTarget(20);
  addTarget(6);
  submitTargets();
  
  // Inner ring
  addTarget(19);
  addTarget(7);
  submitTargets();
  addTarget(18);
  addTarget(8);
  submitTargets();
  addTarget(17);
  addTarget(9);
  submitTargets();
  addTarget(12);
  addTarget(14);
  submitTargets();
  
  // Midpoint
  addTarget(13);
  submitTargets();
  
  ///
  submitTargets();
  submitTargets();
  submitTargets();
  
  // Pattern settings: time between groups, time heating up, time staying hot
  setPatternParameters(0.6, 2.0, 1.0); /// timeBetweenGroups, timeHeatingUp, timeStayingHot
}
  
/*============================================================================= 
 * setPattern2()
 *
 * Plus sign expand pattern
 *===========================================================================*/
public function setPattern2() {
  // Delay
  submitTargets();
  
  // Center
  addTarget(13);
  submitTargets();
  
  // Plus sign expansion
  addTarget(12);
  addTarget(8);
  addTarget(18);
  addTarget(14);
  submitTargets();
  
  // Plus sign expansion
  addTarget(11);
  addTarget(3);
  addTarget(23);
  addTarget(15);
  submitTargets();
  
  // Delay
  submitTargets();
  
  // Outer squares
  addTarget(1);
  addTarget(2);
  addTarget(6);
  addTarget(7);
  addTarget(4);
  addTarget(5);
  addTarget(9);
  addTarget(10);
  addTarget(16);
  addTarget(17);
  addTarget(21);
  addTarget(22);
  addTarget(19);
  addTarget(20);
  addTarget(24);
  addTarget(25);
  submitTargets();
  
  // Delay
  submitTargets();
  
  // Pattern settings: time between groups, time heating up, time staying hot
  setPatternParameters(1.0, 1.5, 0.75);
}
  
/*============================================================================= 
 * setPattern3()
 *
 * Checker pattern
 *===========================================================================*/
public function setPattern3() {
  addTarget(1);
  addTarget(3);
  addTarget(5);
  addTarget(7);
  addTarget(9);
  addTarget(11);
  addTarget(13);
  addTarget(15);
  addTarget(17);
  addTarget(19);
  addTarget(21);
  addTarget(23);
  addTarget(25);
  submitTargets();
  submitTargets();
  
  addTarget(1+5);
  addTarget(1+15);
  addTarget(2);
  addTarget(2+10);
  addTarget(2+20);
  addTarget(3+5);
  addTarget(3+15);
  addTarget(4);
  addTarget(4+10);
  addTarget(4+20);
  addTarget(5+5);
  addTarget(5+15);
  submitTargets();
  submitTargets();
  
  addTarget(1);
  addTarget(1+10);
  addTarget(1+20);
  addTarget(2+5);
  addTarget(2+15);
  addTarget(3);
  addTarget(3+10);
  addTarget(3+20);
  addTarget(4+5);
  addTarget(4+15);
  addTarget(5);
  addTarget(5+10);
  addTarget(5+20);
  submitTargets();
  submitTargets();
  
  addTarget(1+5);
  addTarget(1+15);
  addTarget(2);
  addTarget(2+10);
  addTarget(2+20);
  addTarget(3+5);
  addTarget(3+15);
  addTarget(4);
  addTarget(4+10);
  addTarget(4+20);
  addTarget(5+5);
  addTarget(5+15);
  submitTargets();
  submitTargets();
  
  // Delay
  submitTargets();
  
  // Pattern settings: time between groups, time heating up, time staying hot
  setPatternParameters(1.25, 2.0, 0.3);
}

/*============================================================================= 
 * setPattern4()
 *
 * X pattern
 *===========================================================================*/
public function setPattern4() {
  addTarget(1);
  addTarget(7);
  addTarget(13);
  addTarget(19);
  addTarget(25);
  addTarget(5);
  addTarget(9);
  addTarget(17);
  addTarget(21);
  submitTargets();
  
  addTarget(6);
  addTarget(11);
  addTarget(16);
  addTarget(2);
  addTarget(12);
  addTarget(22);
  addTarget(3);
  addTarget(8);
  addTarget(18);
  addTarget(23);
  addTarget(4);
  addTarget(14);
  addTarget(24);
  addTarget(10);
  addTarget(15);
  addTarget(20);
  submitTargets();
  
  
  addTarget(1);
  addTarget(7);
  addTarget(13);
  addTarget(19);
  addTarget(25);
  addTarget(5);
  addTarget(9);
  addTarget(17);
  addTarget(21);
  submitTargets();
  
  addTarget(6);
  addTarget(11);
  addTarget(16);
  addTarget(2);
  addTarget(12);
  addTarget(22);
  addTarget(3);
  addTarget(8);
  addTarget(18);
  addTarget(23);
  addTarget(4);
  addTarget(14);
  addTarget(24);
  addTarget(10);
  addTarget(15);
  addTarget(20);
  submitTargets();
  
  // Pattern settings: time between groups, time heating up, time staying hot
  setPatternParameters(2.5, 1.8, 0.4);
}

/*============================================================================= 
 * setPattern5()
 *
 * "Two bombs" pattern
 *===========================================================================*/
public function setPattern5() {
  // Delay
  submitTargets();
  
  // Start bomb in top left
  addTarget(7);
  submitTargets();
  
  // Crawl out from previous location
  addTarget(6);
  addTarget(2);
  addTarget(8);
  addTarget(12);
  submitTargets();
  
  // Crawl out further
  addTarget(9);
  addTarget(17);
  submitTargets();
  
  // Crawl out further
  addTarget(22);
  addTarget(10);
  submitTargets();
  
  // Start bomb in bottom right
  addTarget(19);
  submitTargets();
  
  // Crawl out from previous location
  addTarget(14);
  addTarget(18);
  addTarget(24);
  addTarget(20);
  submitTargets();
  
  // Crawl out further
  addTarget(17);
  addTarget(9);
  submitTargets();
  
  // Crawl out further
  addTarget(16);
  addTarget(4);
  submitTargets();
  
  // Delay
  submitTargets();
  
  // Cross pattern
  addTarget(1);
  addTarget(11);
  addTarget(21);
  addTarget(3);
  addTarget(13);
  addTarget(23);
  addTarget(5);
  addTarget(15);
  addTarget(25);
  submitTargets();
  
  // Delay
  submitTargets();
  
  // Pattern settings: time between groups, time heating up, time staying hot
  setPatternParameters(1.0, 1.5, 0.75);
}

/*============================================================================= 
 * setPattern6()
 *
 * Left wall, right wall pattern
 *===========================================================================*/
public function setPattern6() {
  // Randomly select which side first
  if (rand(100) % 2 == 0) {
    // Top left
    bomb3x3(7);
    submitTargets();
    
    // Top right
    bomb3x3(9);
    submitTargets();
    
    // Bottom right
    bomb3x3(19);
    submitTargets();
    
    // Bottom left
    bomb3x3(17);
    submitTargets();
    submitTargets();
  } else {
    // Bottom right
    bomb3x3(19);
    submitTargets();
    
    // Bottom left
    bomb3x3(17);
    submitTargets();
    
    // Top left
    bomb3x3(7);
    submitTargets();
    
    // Top right
    bomb3x3(9);
    submitTargets();
    submitTargets();
  }
  
  // Pattern settings: time between groups, time heating up, time staying hot
  setPatternParameters(3.12, 2.75, 0.35);
}

/*============================================================================= 
 * bomb3x3()
 *
 * Creates a 3x3 pattern, centered on the given index
 *===========================================================================*/
public function bomb3x3(int centerIndex) {
  local int i, j;
  
  // 3x3 bomb area
  for (i = -1; i < 2; i++) {
    for (j = -1; j < 2; j++) {
      // Check valid indices
      if (centerIndex + i + j * 5 < 1 || centerIndex + i + j * 5 > 25) {
        yellowLog("Warning (!) bomb3x3 out of bounds");
        return;
      }
      // Add indices
      addTarget(centerIndex + i + j * 5);
    }
  }
}

/// /*============================================================================= 
///  * rightWall()
///  *
///  * Creates a 3 column pattern hugging the right side of the board
///  *===========================================================================*/
/// public function rightWall() {
///   // Right wall
///   addTarget(5);
///   addTarget(10);
///   addTarget(15);
///   addTarget(20);
///   addTarget(25);
///   addTarget(4);
///   addTarget(9);
///   addTarget(14);
///   addTarget(19);
///   addTarget(24);
///   addTarget(3);
///   addTarget(8);
///   addTarget(13);
///   addTarget(18);
///   addTarget(23);
///   submitTargets();
/// }

/*============================================================================= 
 * getSpeedAmp()
 *
 * Returns a scalar to 
 *===========================================================================*/
private function float getSpeedAmp() {
  switch (level)  {
    case 1:  return 1.0;  
    case 2:  return 0.6;  
    case 3:   return 0.4;  
    case 4:   return 0.325;  
    case 5:   return 0.275;
    default: return 0.25;
  }
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  bDrawRelative=true
}
