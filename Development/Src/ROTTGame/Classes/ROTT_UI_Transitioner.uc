/*============================================================================= 
 * ROTT_UI_Page_Transition
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This page displays transition graphics for encounters and what
 * not
 *===========================================================================*/
 
class ROTT_UI_Transitioner extends ROTT_UI_Page
dependsOn(ROTT_UI_Scene_Manager);

// Tile count for transition effect
// 60x60 tiles, 1440x900 resolution, 1440/60 * 900/60
const TILE_COUNT = 360; 

const TILES_PER_ROW = 24;
const COLUMN_PER_ROW = 15;

// Defines whether or not controls will be consumed by this page, or pasesd on
var privatewrite bool bConsumeInput;

// Store color of tile
var private color tileColor;

// Transition effects
var private float delayTime;

// Transition delay (seconds)
var private float transitionDelay;

// Tag for what kind of transition is happening
var private string transitionTag;

// Transition direction, this is black to clear or clear to black
enum TransitionMode {
  TRANSITION_OUT,
  TRANSITION_IN
};
var private TransitionMode transitionStyle;

// Sorting direction (Not to be confused with transition direction)
var private bool bReverse;

// Tiles drawn per tick, (effectively the transition speed)
var private int tilesPerTick;

// Stores whether or not to render the transition effects
var privatewrite bool bTransitionEnabled;
var privatewrite bool bRenderingEnabled;

// Optional: Scene to switch into after transition
var public DisplayScenes destinationScene;

// Optional: Page to switch into after transition
var public ROTT_UI_Page destinationPage;

// Optional: Page to switch into after transition
var public string destinationWorld;

// Elapsed time for transition
var private float elapsedTime;

// Fade control
var private float fadeTime;

// Tile sorting information
struct TileInfo {
  var int index;
  var int distance;
};

var private array<TileInfo> blackTileIndices;

// Internal references
var private UI_Sprite squareTiles[TILE_COUNT];

// Tiles drawn so far
var private int tileCount;

// Whether or not to hold the final graphic state after transitioning
var private bool bHoldScreen;

// Config styles for sorter effects and transition styles
// (I guess we have to do this here because the constructors are fucking moronic)
enum EffectConfigs {
  INTO_COMBAT_TRANSITION,
  OUT_FROM_OVER_WORLD_TRANSITION,
  RIGHT_SWEEP_TRANSITION_IN,
  RIGHT_SWEEP_TRANSITION_OUT,
  PORTAL_TRANSITION,
  RANDOM_SORT_TRANSITION,
  RESPAWN_END_TRANSITION,
  RESPAWN_START_TRANSITION,
  NPC_TRANSITION_IN,
  NPC_TRANSITION_OUT,
  DOOR_PORTAL_TRANSITION_OUT,
};
var private EffectConfigs effectConfig;

// Effect functions
var private array<delegate<tileSorter> > sorterEffects;
delegate int tileSorter(int index);
delegate int tileComparator(TileInfo tile1, TileInfo tile2);

/*============================================================================= 
 * initializeComponent()
 *
 * Called once, when the scene is first initialized.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  local int i, j, index;
  
  // Draw each component
  super.initializeComponent(newTag);
  
  // Column iteration
  for (j = 0; j < COLUMN_PER_ROW; j++) {
    // Row iteration
    for (i = 0; i < TILES_PER_ROW; i++) {
      // Calculate index
      index = j * TILES_PER_ROW + i;
      
      // Create sprites
      squareTiles[index] = new class'UI_Sprite';
      squareTiles[index].images.addItem(new class'UI_Texture_Info');
      squareTiles[index].images[0].componentTextures.addItem(Texture2D'MyPackage.Materials.White');
      componentList.addItem(squareTiles[index]);
      squareTiles[index].bMandatoryScaleToWindow = true;
      squareTiles[index].setEnabled(false);
      squareTiles[index].initializeComponent("Tile_Color_" $ i $ "_" $ j);
      squareTiles[index].drawLayer = TOP_LAYER;
      
      // Set position
      squareTiles[index].updatePosition(i * 60, j * 60, (i+1)*60, (j+1)*60);
    }
  }
  
}

/*============================================================================= 
 * setTransition()
 *
 * Called to initiate a transition effect
 *===========================================================================*/
public function setTransition
(
  TransitionMode transitionDirection,
  EffectConfigs transitionConfig,
  optional bool patternReverse = false,
  optional DisplayScenes transitionScene = NO_SCENE,
  optional ROTT_UI_Page transitionPage,
  optional string transitionWorld,
  optional color transitionColor = MakeColor(0, 0, 0, 255),
  optional int tileSpeed = 20,
  optional float delay = 0.f,
  optional bool inputConsumed = true,
  optional string transTag,
  optional bool holdScreen = false,
  optional float fadeTileTime = 0.f
)
{
  local int i;
  
  removeVisibility();
  
  // Update transitioner status to enabled 
  bTransitionEnabled = true;
  bRenderingEnabled = true;
  
  // Transition direction (Full to empty, empty to full)
  transitionStyle = transitionDirection;
  
  // Pattern direction (Pattern sorting direction)
  bReverse = patternReverse;
  
  // Set destination for transition
  destinationScene = transitionScene;
  destinationPage = transitionPage;
  destinationWorld = transitionWorld;
  
  // Set color
  tileColor = transitionColor;
  
  // Initial render settings for each tile
  for (i = 0; i < TILE_COUNT; i++) {
    // Set transition color
    squareTiles[i].setColor(tileColor.r, tileColor.g, tileColor.b, tileColor.a);
    
    // Set visibility based on direction of transition
    squareTiles[i].setEnabled(transitionStyle != TRANSITION_OUT);
  }
  
  // Set pattern info
  effectconfig = transitionConfig;
  setTransitionConfig();
  
  // Set speed
  tilesPerTick = tileSpeed;
  
  // Select random sorting algorithm
  tileSort(sorterEffects[rand(sorterEffects.length)]);
  
  // Set whether or not to accept input
  bConsumeInput = inputConsumed;
  
  // Set delay
  transitionDelay = delay;
  
  // Set tag information
  transitionTag = transTag;
  
  // Set whether or not to clear final graphic state
  bHoldScreen = holdScreen;
  
  // Store tile fading settings
  fadeTime = fadeTileTime;
  
  // Remove temporal effect on game speed
  if (effectConfig == PORTAL_TRANSITION) {
    gameInfo.setGameSpeed(1);
  }
  
  // Initial transition data
  tileCount = 0;
  elapsedTime = 0;
  
  // Initialize delay, clearing previous transition data
  delayTime = 0;
}

/*============================================================================= 
 * setTransitionConfig()
 *
 * 
 *===========================================================================*/
private function setTransitionConfig() {
  // Reset sorters
  sorterEffects.length = 0;
  
  // Set up config style
  switch (effectConfig) {
    case RIGHT_SWEEP_TRANSITION_IN:
    case RIGHT_SWEEP_TRANSITION_OUT:
      // Sorter effects
      sorterEffects.addItem(sortMethod8);
      break;
      
    case RESPAWN_START_TRANSITION:
      // Sorter effects
      sorterEffects.addItem(sortMethod7);
      break;
      
    case RESPAWN_END_TRANSITION:
    case INTO_COMBAT_TRANSITION:
      // Sorter effects
      sorterEffects.addItem(sortMethod6);
      break;
      
    case OUT_FROM_OVER_WORLD_TRANSITION:
      // Sorter effects
      sorterEffects.addItem(sortMethod1);
      sorterEffects.addItem(sortMethod2);
      sorterEffects.addItem(sortMethod3);
      sorterEffects.addItem(sortMethod4);
      sorterEffects.addItem(sortMethod5);
      break;
    case PORTAL_TRANSITION:
      // Sorter effects (Circle)
      sorterEffects.addItem(sortMethod1);
      break;
    case RANDOM_SORT_TRANSITION:
      // Sorter effects (Random tiles)
      sorterEffects.addItem(sortMethod5);
      break;
    case NPC_TRANSITION_IN:
    case NPC_TRANSITION_OUT:
    case DOOR_PORTAL_TRANSITION_OUT:
      // Sorter effects (sortMethod9 is midline vertical)
      sorterEffects.addItem(sortMethod9);
      break;
    default:
      yellowLog("Warning (!) Transition page has no config.");
      break;
      
  }
}

/*============================================================================= 
 * onPopPageEvent()
 *
 * This event is called when the page is removed
 *===========================================================================*/
event onPopPageEvent();

/*=============================================================================
 * elapseTimers()
 *
 * Ticks every frame. 
 *===========================================================================*/
public function elapseTimers(float deltaTime) {
  if (delayTime > 0) {
    // Track elapsed delay time
    delayTime -= deltaTime;
    
    // Execute delayed scene switch from this transition
    if (delayTime <= 0) transitionComplete();
  }
  
  if (!bRenderingEnabled) return;
  
  // Ignore speed modifiers
  deltaTime /= gameInfo.gameSpeed;
  
  // Track time
  if (bRenderingEnabled) {
    elapsedTime += deltaTime;
  }
  if (bTransitionEnabled) {
    renderTiles();
  }
  super.elapseTimers(deltaTime);
  
}

/*============================================================================= 
 * onSceneActivation()
 *
 * This event is called every time the parent scene is activated
 *===========================================================================*/
public function onSceneActivation();

/*============================================================================= 
 * onSceneDeactivation()
 *
 * This event is called every time the parent scene is deactivated
 *===========================================================================*/
public function onSceneDeactivation();

/*=============================================================================
 * Controls
 *
 * ControllerId     the controller that generated this input key event
 * inputName        the name of the key which an event occured for
 * EventType        the type of event which occured
 * AmountDepressed  for analog keys, the depression percent.
 *
 * Returns: true to consume the key event, false to pass it on.
 *===========================================================================*/
function bool onInputKey
( 
  int ControllerId, 
  Name inputName, 
  EInputEvent Event, 
  float AmountDepressed = 1.f, 
  bool bGamepad = false
) 
{
  switch (inputName) {
    // Button inputs
    case 'XboxTypeS_LeftTrigger':
      super.onInputKey(ControllerId, inputName, Event, AmountDepressed, bGamepad);
      
      // Always accept input from speed change only for releases
      if (Event == IE_Released) gameinfo.setGameSpeed(1);
      
      // Otherwise, exclude input on portal transitions
      return (effectConfig == PORTAL_TRANSITION);
      
    case 'XBoxTypeS_Start':
      // Consume input
      return true;
  }
  
  return bConsumeInput;
}

/*============================================================================= 
 * tileSort()
 *
 * Sorts tiles for transition effect
 *===========================================================================*/
private function tileSort(delegate<tileSorter> sorter) {
  local TileInfo newTile;
  local int i;
  
  // Reset array
  blackTileIndices.length = 0;
  
  // Populate list
  for (i = 0; i < TILE_COUNT; i++) {
    newTile.index = i;
    newTile.distance = sorter(i);
    blackTileIndices.addItem(newTile);
  }
  
  blackTileIndices.sort(tileComparison);
  ///blackTileIndices = mySort(blackTileIndices, tileComparison);
  
  if (bReverse) {
    reverseArray(blackTileIndices);
  }
}

/*============================================================================= 
 * renderTiles()
 *
 * Timer allocated function for drawing tiles effects to the screen
 *===========================================================================*/
private function renderTiles() {
  local bool displayState;
  local int index, k, tileMax;
  
  // Transition direction
  displayState = (transitionStyle == TRANSITION_OUT);
  
  // Render tiles
  tileMax = (tilesPerTick) * (elapsedTime) / 0.025 - tileCount;
  for (k = 0; k < tileMax; k++) {
    // Check for remaining indices
    if (blackTileIndices.length == 0) {
      endTransition();
      break;
    }
    
    // Render a random batch from the sorted list 
    index = rand(30);
    if (index >= blackTileIndices.length) index = rand(blackTileIndices.length);
    squareTiles[blackTileIndices[index].index].setEnabled(displayState);
    
    // Check if fade time provided
    if (fadeTime != 0) {
      // Random scatter delay
      squareTiles[blackTileIndices[index].index].addEffectToQueue(DELAY, 0.005 * (rand(14)));
      
      // Fading in effect
      squareTiles[blackTileIndices[index].index].addEffectToQueue((displayState) ? FADE_IN : FADE_OUT, fadeTime);
      
      // Fade to black effect
      squareTiles[blackTileIndices[index].index].addEffectToQueue(FADE_BLACK, fadeTime);
    } 
    blackTileIndices.remove(index, 1);
  }
  tileCount += k;

}

/*============================================================================= 
 * endTransition()
 *
 * Called when the rendering of all the tiles is complete
 *===========================================================================*/
private function endTransition() {
  // Set effect timer
  delayTime = transitionDelay + fadeTime;
  
  // Disable tile sorting
  bTransitionEnabled = false;
  
  if (delayTime == 0) {
    transitionComplete();
  }
}

/*============================================================================= 
 * removeVisibility()
 *
 * Hides all tiles
 *===========================================================================*/
private function removeVisibility() { 
  local int i;
  
  // Hide all tiles
  for (i = 0; i < TILE_COUNT; i++) {
    squareTiles[i].setEnabled(false);
  }
}

/*============================================================================= 
 * transitionComplete()
 *
 * Called when the transition effect and delay are complete
 *===========================================================================*/
private function transitionComplete() { 
  // Hide all tiles unless a hold is requested
  if (!bHoldScreen) {
    removeVisibility();
    bRenderingEnabled = false;
  }
  
  // Trigger on completion event
  if (gameInfo.sceneManager.sceneOverWorld != none) {
    gameInfo.sceneManager.sceneOverWorld.transitionCompletion(transitionTag);
  }
  
  // Handle world transfer
  if (destinationWorld != "") {
    gameInfo.consoleCommand("open " $ destinationWorld);
    return;
  }
  
  // Switch scene if transitioning out from a scene
  if (destinationScene != NO_SCENE) { 
    sceneManager.switchScene(destinationScene);
  }
  
  // Push page if specified
  if (destinationPage != none) {
    sceneManager.scene.pushPage(destinationPage);
  }
  
}

/*============================================================================= 
 * mySort()
 *
 * Mergesort, since epic is fucknretarded 
 https://www.reddit.com/r/xcom2mods/comments/5kecht/unrealscripts_sort_a_tragedy/
 *===========================================================================*/
private function array<TileInfo> mySort
(
  array<TileInfo> sortArray,
  delegate< tileComparator > delegateComparator,
  optional int startIndex = 0,
  optional int endIndex = sortArray.length + startIndex
) 
{
  local array<TileInfo> L1, L2, L3;
  local int i, j;
  
  // Check for base case of recursion
  if (startIndex == endIndex) {
    L1.addItem(sortArray[startIndex]);
    return L1;
  }
  
  // Recurse on both halves of given array
  L1 = mySort(sortArray, delegateComparator, startIndex, startIndex + ((endIndex - startIndex) / 2));
  if (startIndex + ((endIndex - startIndex) / 2) + 1 < TILE_COUNT) {
    L2 = mySort(sortArray, delegateComparator, startIndex + ((endIndex - startIndex) / 2) + 1, endIndex);
  }
  
  // Finger method incremented sort
  j = 0;
  for (i = 0; i < L1.length && j < L2.length; i += 0) {
    switch (delegateComparator(L1[i], L2[j])) {
      case 1:
        L3.addItem(L1[i]);
        i++;
        break;
      case -1:
        L3.addItem(L2[j]);
        j++;
        break;
      case 0:
        L3.addItem(L1[i]);
        L3.addItem(L2[j]);
        i++; j++;
        break;
    }
  }
  
  // Add leftover ends
  while (i < L1.length) {
    L3.addItem(L1[i]);
    i++;
  }
  while (j < L2.length) {
    L3.addItem(L2[j]);
    j++;
  }
  
  return L3;
}

/*============================================================================= 
 * tileComparison()
 *
 * Compares distance between tiles.  Negative result signifies out of order.
 *===========================================================================*/
private function int tileComparison(TileInfo a, TileInfo b) {
  if (a.distance < b.distance) {
    return -1;
  } else if (a.distance > b.distance) {
    return 1;
  } else {
    return 0;
  }
}

/*============================================================================= 
 * sortMethod1()
 *
 * Circle effect
 *===========================================================================*/
private function int sortMethod1(int index) {
  // Distance to x=1/2, y=1/2
  return distanceFormula(
    squareTiles[index].getX(), 
    squareTiles[index].getY(), 
    NATIVE_WIDTH / 2,
    NATIVE_HEIGHT / 2
  );
}

/*============================================================================= 
 * sortMethod2()
 *
 * Four corners effect
 *===========================================================================*/
private function int sortMethod2(int index) {
  local float d1, d2, d3, d4;
  
  // Distance to MIN(four corners)
  d1 = distanceFormula(
    squareTiles[index].getX(), 
    squareTiles[index].getY(), 
    0,
    0
  );
  
  d2 = distanceFormula(
    squareTiles[index].getX(), 
    squareTiles[index].getY(), 
    NATIVE_WIDTH,
    0
  );
  
  d3 = distanceFormula(
    squareTiles[index].getX(), 
    squareTiles[index].getY(), 
    0,
    NATIVE_HEIGHT
  );
  
  d4 = distanceFormula(
    squareTiles[index].getX(), 
    squareTiles[index].getY(), 
    NATIVE_WIDTH,
    NATIVE_HEIGHT
  );
  
  d1 = fMin(d1, d2);
  d2 = fMin(d3, d4);
  
  return fMin(d1, d2);
}

/*============================================================================= 
 * sortMethod3()
 *
 * Vertical lines effect
 *===========================================================================*/
private function int sortMethod3(int index) {
  local float d1, d2;
  
  // Distance to MIN(x=1/3, x=2/3)
  d1 = abs(squareTiles[index].getX() - (NATIVE_WIDTH / 4));
  d2 = abs(squareTiles[index].getX() - (3 * NATIVE_WIDTH / 4));
  return fMin(d1, d2);
}

/*============================================================================= 
 * sortMethod4()
 *
 * Horizontal midline effect
 *===========================================================================*/
private function int sortMethod4(int index) {
  // Distance to Y = 1/2
  return abs(squareTiles[index].getY() - (NATIVE_HEIGHT / 2));
}

/*============================================================================= 
 * sortMethod5()
 *
 * Randomized effect
 *===========================================================================*/
private function int sortMethod5(int index) {
  // Random method
  return rand(10);
}

/*============================================================================= 
 * sortMethod6()
 *
 * Vertical curtain effect downward
 *===========================================================================*/
private function int sortMethod6(int index) {
  // Distance to Y = 1
  return abs(squareTiles[index].getY() - NATIVE_HEIGHT);
}

/*============================================================================= 
 * sortMethod7()
 *
 * Vertical curtain effect upward
 *===========================================================================*/
private function int sortMethod7(int index) {
  // Distance to Y = 0
  return abs(squareTiles[index].getY());
}

/*============================================================================= 
 * sortMethod8()
 *
 * Horizontal curtain effect
 *===========================================================================*/
private function int sortMethod8(int index) {
  // Distance to X = 1
  return abs(squareTiles[index].getX() - NATIVE_WIDTH);
}

/*============================================================================= 
 * sortMethod9()
 *
 * Vertical midline effect
 *===========================================================================*/
private function int sortMethod9(int index) {
  // Distance to X = 1/2
  return abs(squareTiles[index].getX() - (NATIVE_WIDTH / 2));
}

/*============================================================================= 
 * distanceFormula()
 *
 * Returns the distance between two points on a cartesian plane
 *===========================================================================*/
private function float distanceFormula(float x1, float y1, float x2, float y2) {
  local float x, y;
  
  x = abs(x2 - x1);
  y = abs(y2 - y1);
  
  return sqrt(y * y + x * x);
}

/*============================================================================= 
 * distanceFormula()
 *
 * Returns the distance between two points on a cartesian plane
 *===========================================================================*/
private function reverseArray(out array<TileInfo> tileSet) {
  local TileInfo tempSet[TILE_COUNT];
  local int i;
  
  // Move all tileSet entries to temp array
  for (i = 0; i < TILE_COUNT; i++) {
    tempSet[i] = tileSet[i];
  }
  // Move back in reverse order
  for (i = 0; i < TILE_COUNT; i++) {
    tileSet[i] = tempSet[tileSet.length - i - 1];
  }
}

public function onNavigateLeft();
public function onNavigateRight();

/*============================================================================= 
 * deleteComp
 *===========================================================================*/
event deleteComp() {
  local int i;
  
  super.deleteComp();
  destinationPage = none;
  gameInfo = none;
  uiGameInfo = none;
  partySystem = none;
  
  // Delete all tiles
  for (i = 0; i < TILE_COUNT; i++) {
    squareTiles[i].deleteComp();
    squareTiles[i] = none;
  }
  
  componentList.length = 0;
}

/*============================================================================= 
 * defaultProperties
 *===========================================================================*/
defaultProperties
{
  bMandatoryScaleToWindow=true
  
  // Transition delay
  transitionDelay=0.5
  
  // "Speed" of transition
  tilesPerTick=7
  
  // Transition direction
  transitionStyle=TRANSITION_OUT
  
  // Transition destination
  destinationScene=SCENE_COMBAT_ENCOUNTER
  destinationWorld="none"
  
  // Fade option
  fadeTime=0
  
  // Tile color
  tileColor=(R=0,G=187,B=255,A=130)
  
  /** ===== UI Components ===== **/
  tag="Transitioner"
  posX=0
  posY=0
  posXEnd=NATIVE_WIDTH
  posYEnd=NATIVE_HEIGHT
  
}








