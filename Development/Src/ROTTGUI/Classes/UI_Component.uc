/*=============================================================================
 * UI_Component
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * The base class for any object that can be placed into the HUD.
 *===========================================================================*/

class UI_Component extends object
  abstract
  editinlinenew
  collapsecategories
  hidecategories(object)
  dependsOn(UI_Fade_System)
  dependsOn(UI_HUD);

// Parameters used in ROTTTimers:
const LOOP_OFF = false;
const LOOP_ON  = true;

// Default dimensions, same size as our mock up UI designs
const NATIVE_WIDTH  = 1440; 
const NATIVE_HEIGHT = 900;

// This determines whether the component is drawn to the screen or not
var privatewrite bool bEnabled;

// Used for search calls
var privatewrite string tag;

// The components attached to this component
var public editinline instanced array<UI_Component> componentList;

// Store time until display active
var public float activationDelay;

// If true, size changes will be oriented around the center point
var public bool bAnchor;
var public int anchorX, anchorY;

// This tells where to render the component in the HUD
var private int posX, posY, posXEnd, posYEnd;

// Data for center of screen
struct FloatPair {
  var float x;
  var float y;
};

// Center of the sprite relative to the screen
var protected FloatPair center;

// If true, this component always stretches to the window size (regardless of HUD stretch setting)
var public bool bMandatoryScaleToWindow;

// This forces the end coordinates to match the outer container, offset by posXEnd/posYEnd
var protected bool bRelativeEnd;

struct DimPair {
  var int width;
  var int height;
};

// Home position for posX and posY to return to, if changed
var protected IntPoint homePos; 

// Dimensions, to be preserved while interpolating
var protected DimPair homeDim;  

// A queue of effects
///var privatewrite EffectStruct effects[4];  
///var privatewrite int effectCount;

// Linear interpolation effect info
struct LerpEffect {
  var IntPoint origin;       // posX and posY we start at
  var IntPoint destination;  // Position to lerp to
  var float duration;        // Total lerping time  
  var float elapsedTime;     // Elapsed lerping time
};

var private LerpEffect lerpFx;

// Move speed
var private float moveSpeed;
var private bool bMoving;
var private IntPoint moveDestination;

// a countdown timer, for effects like fading components 
var private float countdownTime;  

// Dictates whether keyboard input will be handled 
var private bool bReceiveText;

// Duplicate fail safe
var privatewrite bool bInitialized;

// Positioning mode, relative when false
var private bool bAbsolute;

// Stores a list of components that will be culled by this component
var public array<string> cullTags;

// Stores a list of components that are culling this component
var public array<UI_Component> culledByList;

// Stores whether this element should be deleted after page pop events
var public bool bTemporaryUI;

// Manages the fade effects for this component
var public UI_Fade_System fadeSystem;

// Store the base color attribute for drawing visual components
var private Color baseColor;

// Store the real time draw color, modified by effects
var protected Color drawColor;

enum LayerList {
  BOTTOM_LAYER,
  DEFAULT_LAYER,
  TOP_LAYER
};
var public LayerList drawLayer;

// References
var public UI_Game_Info uiGameInfo;
var public UI_HUD hud;

/*===========================================================================*/

`include(ROTTColorLogs.h)

/*=============================================================================
 * initializeEvent()
 *
 * Recursively calls the event on all components.
 *===========================================================================*/
public function initializeEvent() { 
  local int i;
  for (i = 0; i < componentList.length; i++) {
    componentList[i].initializeEvent();
  }
  
  // Call subroutines
  initialize();
}

/*=============================================================================
 * initialize()
 *
 * Called to initialize references for this component.
 *===========================================================================*/
public function initialize();

/*=============================================================================
 * startEvent()
 *
 * Recursively calls the event on all components.
 *===========================================================================*/
public function startEvent() { 
  local GamePlayerController pc;
  local int i;
  
  // Game reference
  uiGameInfo = UI_Game_Info(class'WorldInfo'.static.getWorldInfo().game);
  
  // HUD reference
  forEach class'WorldInfo'.static.GetWorldInfo().AllControllers(
    class'GamePlayerController', 
    pc
  )  {
    if (pc != none) hud = UI_HUD(pc.myHUD);
  }
  
  // Call start events
  for (i = 0; i < componentList.length; i++) {
    componentList[i].startEvent();
  }
  start();
}

/*=============================================================================
 * start()
 *
 * Called to start setting the initial variables for this component.
 *===========================================================================*/
public function start();

/*=============================================================================
 * updateEvent()
 *
 * Recursively calls the event on all components.
 *===========================================================================*/
final public function updateEvent() { 
  local int i;
  for (i = 0; i < componentList.length; i++) {
    componentList[i].updateEvent();
  }
  update();
}

/*=============================================================================
 * update()
 *
 * Called before rendering the canvas, which is drawn every frame.
 *===========================================================================*/
public function update();

/*=============================================================================
 * drawEvent()
 *
 * Recursively calls the event on all components.
 *===========================================================================*/
final public function drawEvent(Canvas canvas, LayerList layer) { 
  local int i;
  
  // Check visibility
  if (!isVisible()) return;
  
  // Draw UI components in post order traversal
  for (i = 0; i < componentList.length; i++) {
    componentList[i].drawEvent(canvas, layer);
  }
  if (layer == drawLayer) drawCanvas(canvas);
}

/*=============================================================================
 * drawCanvas()
 *
 * Called each frame to draw components.
 *===========================================================================*/
protected function drawCanvas(Canvas canvas) { }

/*=============================================================================
 * isVisible()
 *
 * Returns true if this component should be drawn
 *===========================================================================*/
protected function bool isVisible() { 
  return bEnabled && culledByList.length == 0;
}

/*=============================================================================
 * cullTag()
 *
 * Prevents the given tag from being drawn
 *===========================================================================*/
public function cullTag(string targetTag, UI_Component source) {
  local int i;
  
  // Pass cull to component list
  for (i = 0; i < componentList.length; i++) {
    componentList[i].cullTag(targetTag, source);
  }
  
  // If this component is the target of the cull, hide it
  if (targetTag == tag) {
    culledByList.addItem(source);
    getParentScene().cullReferences.addItem(source);
  }
}

/*=============================================================================
 * getParentScene()
 *
 * Returns the scene that contains this component
 *===========================================================================*/
public function UI_Scene getParentScene() {
  if (outer == none) return none;
  if (UI_Scene(outer) != none) return UI_Scene(outer);
  return UI_Component(outer).getParentScene();
}

/*=============================================================================
 * uncullTag()
 *
 * Removes a cull for the given tag.  (There may be more than one cull)
 *===========================================================================*/
public function uncullTag(UI_Component source) {
  local int i;
  
  // Pass uncull to component list
  for (i = 0; i < componentList.length; i++) {
    componentList[i].uncullTag(source);
  }
  
  // Removes culls
  for (i = culledByList.length - 1; i >= 0; i--) {
    if (culledByList[i] == source) {
      culledByList.remove(i, 1);
    }
  }
}

/*============================================================================= 
 * initializeComponent
 *
 * Called once from HUD's PostBeginPlay() when the scene is first initialized.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  if (bInitialized == true) {
    yellowLog("Warning (!) Duplicate initilization: " $ tag);
    scriptTrace();
    return;
  }
  
  if (tag == "") tag = newTag;
  
  bInitialized = true;
  
  // Calculate center
  center.x = (posXEnd - posX) / 2.0 + posX;
  center.y = (posYEnd - posY) / 2.0 + posY;
  
  // Initialize move destination
  moveDestination.x = posX;
  moveDestination.y = posY;
  
  // Create fade system
  fadeSystem = new class'UI_Fade_System';
  
  /// temporary pass
  initialize();
}

/*============================================================================= 
 * postInit
 *
 * Called at the end of initializeComponent() container calls
 *===========================================================================*/
event postInit() {
  // Save home position and dimension info
  homePos.x = posX;
  homePos.y = posY;
  
  // Save home (initial) dimensions
  homeDim.width = posXEnd - posX;
  homeDim.height = posYEnd - posY;
}

/*=============================================================================
 * Runtime events, implemented in children classes
 *===========================================================================*/
protected function eventOnEnabled();
protected function eventOnDisabled();

/*=============================================================================
 * setEnabled()
 *
 * This component is drawn when enabled, and hidden when disabled.
 *===========================================================================*/
public function setEnabled(bool enableState) {
  if (bEnabled == enableState) return;
  
  bEnabled = enableState;
  
  switch (enableState) {
    case true:  eventOnEnabled();
    case false: eventOnDisabled();
  }
}

/*=============================================================================
 * updatePosition()
 *
 * Places the sprite at the given coordinates, and optionally stretches it
 * to a given end point
 *===========================================================================*/
public function updatePosition
(
  optional int newX = posX,
  optional int newY = posY,
  optional int newXEnd = newX + (posXEnd - posX),
  optional int newYEnd = newY + (posYEnd - posY)
)
{
  posX = newX;
  posY = newY;
  posXEnd = newXEnd;
  posYEnd = newYEnd;
}

/*=============================================================================
 * getCenterX()
 *
 * Returns center coordinates
 *===========================================================================*/
public function float getCenterX() {
  return (posXEnd - posX) / 2.0 + posX;
}

/*=============================================================================
 * getCenterY()
 *
 * Returns center coordinates
 *===========================================================================*/
public function float getCenterY() {
  return (posYEnd - posY) / 2.0 + posY;
}

/*=============================================================================
 * elapseTimer()
 *
 * Increments time every engine tick.
 *===========================================================================*/
public function elapseTimer(float deltaTime, float gameSpeedOverride) {
  local float deltaX, deltaY;
  
  // Track delayed activation of this UI element
  if (activationDelay > 0) {
    // Track time
    activationDelay -= deltaTime;
    
    // Check for time completion
    if (activationDelay <= 0) {
      // Switch to visibility
      bEnabled = true;
    } else {
      // Remain hidden
      bEnabled = false;
      return;
    }
  }
  
  // Ignore effect calculations if disabled
  if (!bEnabled) return;
  
  // Movement
  lerpComponent(deltaTime);
  if (bMoving) {
    deltaX = moveDestination.x - posX;
    deltaY = moveDestination.y - posY;
    
    if (fMin(deltaX, moveSpeed * deltaTime) ~= 0 && fMin(deltaY, moveSpeed * deltaTime) ~= 0) {
      bMoving = false;
      return;
    }
    
    shiftX(fMin(deltaX, moveSpeed * deltaTime));
    shiftY(fMin(deltaY, moveSpeed * deltaTime));
  }
  
  // Fade
  fadeSystem.updateFadeTime(deltaTime / gameSpeedOverride);
}

/*=============================================================================
 * setLerp()
 *
 * Allows this component to performa a LERP animation
 *===========================================================================*/
public function setLerp(IntPoint origin, IntPoint destination, float duration) {
  lerpFx.origin = origin;
  lerpFx.destination = destination;
  lerpFx.duration = duration;
  lerpFx.elapsedTime = 0.f;  
}

/*=============================================================================
 * resetLerp()
 *
 * Removes lerp info
 *===========================================================================*/
public function resetLerp() {
  local IntPoint zero;
  zero.x = 0; zero.y = 0;
  
  lerpFx.origin = zero;
  lerpFx.destination = zero;
  lerpFx.duration = 0.f;
  lerpFx.elapsedTime = 0.f;  
}

/*=============================================================================
 * resetEffects()
 *
 * Removes all effects from this component
 *===========================================================================*/
public function resetEffects(optional bool bShow = true) {
  fadeSystem.clearEffects();
}
  
/*=============================================================================
 * removeByTag()
 *
 * Removes a component with the given tag
 *===========================================================================*/
public function removeByTag(string targetTag) {
  local int i;
  
  // Scan through components
  for (i = componentList.length - 1; i >= 0; i--) {
    // Check if tag matches
    if (componentList[i].tag == targetTag) {
      // Delete and remove
      componentList[i].deleteComp();
      componentList.remove(i, 1);
    }
  }
}

/*=============================================================================
 * removeByReference()
 *
 * Removes a component by reference
 *===========================================================================*/
public function removeByReference(object reference) {
  local int i;
  
  // Scan through components
  for (i = componentList.length - 1; i >= 0; i--) {
    // Check if tag matches
    if (componentList[i] == reference) {
      // Delete and remove
      componentList[i].deleteComp();
      componentList.remove(i, 1);
    }
  }
}

/*=============================================================================
 * Process an input key event routed through unrealscript from another object. 
 * This method is assigned as the value for the OnRecievedNativeInputKey 
 * delegate so that native input events are routed to this unrealscript function.
 *
 *    ControllerId    the controller that generated this input key event
 *    Key             the name of the key which an event occured for (KEY_Up, KEY_Down, etc.)
 *    EventType       the type of event which occured (pressed, released, etc.)
 *    AmountDepressed for analog keys, the depression percent.
 *
 * return true to consume the key event, false to pass it on.
 *===========================================================================*/
delegate bool onInputKey
( 
  int ControllerId, 
  name Key, 
  EInputEvent Event, 
  float AmountDepressed = 1.f, 
  bool bGamepad = false 
);
///{
///  return false;
///}
     
/*=============================================================================
 * Process a character input event (typing) routed through unrealscript from 
 * another object. This method is assigned as the value for the
 * OnRecievedNativeInputKey delegate so that native input events are routed to 
 * this unrealscript function.
 *
 * @param   ControllerId    the controller that generated this character input event
 * @param   Unicode         the character that was typed
 *
 * @return  True to consume the character, false to pass it on.
 *===========================================================================*/
function bool inputChar(int controllerId, string unicode) {
  `log(unicode);
  return bReceiveText;
}

/*=============================================================================
 * moveTo()
 *
 * Moves this component to a destination based on a movement speed
 *===========================================================================*/
public function moveTo(int newX, int newY, optional float newMovementSpeed = moveSpeed) {
  // Set destination
  moveDestination.x = newX;
  moveDestination.y = newY;
  
  // Set movement parameters
  bMoving = true;
  moveSpeed = newMovementSpeed;
}

/*=============================================================================
 * moveBy()
 *
 * Moves this component by a given distance
 *===========================================================================*/
public function moveBy(int newX, int newY, optional float newMovementSpeed = moveSpeed) {
  // Set destination
  moveDestination.x = moveDestination.x + newX;
  moveDestination.y = moveDestination.y + newY;
  
  // Set movement parameters
  bMoving = true;
  moveSpeed = newMovementSpeed;
}

/*=============================================================================
 * shiftX()
 *
 * Moves this component on the X axis
 *===========================================================================*/
public function shiftX(int offset) {
  updatePosition(posX + offset);
  anchorX += offset;
}

/*=============================================================================
 * shiftY()
 *
 * Moves this component on the Y axis
 *===========================================================================*/
public function shiftY(int offset) {
  updatePosition( , posY + offset);
  anchorY += offset;
}

/*=============================================================================
 * lerpComponent()
 *
 * This is called every engine tick, to perform linear interpolation.
 *===========================================================================*/
protected function lerpComponent(float deltaTime) {
  local int newX, newY;
  local float lerpRatio;
  
  // Check if lerp effect is active (hacky)
  if (lerpFx.duration == 0.0) {
    return;
  }
  
  // Lerping effect
  lerpFx.elapsedTime += deltaTime;
  if (lerpFx.elapsedTime > lerpFx.duration) {
    lerpFx.elapsedTime = lerpFx.duration; // Prevent extrapolation
  }
  
  lerpRatio = lerpFx.elapsedTime/lerpFx.duration;
  newX = (lerpFx.destination.x - lerpFx.origin.x) * lerpRatio + lerpFx.origin.x;
  newY = (lerpFx.destination.y - lerpFx.origin.y) * lerpRatio + lerpFx.origin.y;
  updatePosition(newX, newY);
  
  // Stop lerping effect upon completion
  if (lerpFx.elapsedTime == lerpFx.duration) {
    lerpFx.elapsedTime = 0.f;
    lerpFx.duration = 0.f;
  }
}

/*============================================================================
 * getPlayerInput()
 *===========================================================================*/
public function PlayerInput getPlayerInput() {
  return hud.playerOwner.playerInput;
}

/*=============================================================================
 * addEffectToQueue()
 *
 * Allows special effects to be queued
 *===========================================================================*/
public function addEffectToQueue(EffectStates state, float time) {
  fadeSystem.addEffectToQueue(state, time);
}

/*=============================================================================
 * setOffset()
 *
 * Set a new position offset from the original anchor
 *===========================================================================*/
protected function setOffset(int offsetX, int offsetY) {
  posX = homePos.x + offsetX;
  posY = homePos.y + offsetY;
  posXEnd = homePos.x + homeDim.width + offsetX;
  posYEnd = homePos.y + homeDim.height + offsetY;
}

/*=============================================================================
 * debugLerpDump()
 *
 * Debug information is dumped to the console window for LERP animation.
 *===========================================================================*/
protected function debugLerpDump() {
  grayLog("Lerp info (" $ tag $ ")");
  
  greenlog("  origin (x=" $ lerpFx.origin.x $",y=" $ lerpFx.origin.y $ ")");
  greenlog("  destination (x=" $ lerpFx.destination.x $ ",y=" $ lerpFx.destination.y $ ")");
  cyanlog("  duration: " $ lerpFx.duration);
  cyanlog("  elapsedTime" $ lerpFx.elapsedTime);
  goldlog("  homePos (x=" $ homePos.x $ ",y=" $ homePos.y $ ")");
}

/*=============================================================================
 * debugHierarchy()
 *
 * Shows the hierarchy as a tree, tabbed in console.
 *===========================================================================*/
public function debugHierarchy(int tabLength, bool bEnabledParent) {
  local int i;
  local string tabs;
  
  for (i = 0; i < tabLength; i++) {
    tabs $= "  ";
  }
  
  if (bEnabled && bEnabledParent) {
    greenLog(tabs $ "+ " $ tag $ "               <" $ self $ ">", DEBUG_HIERARCHY); 
  } else {
    grayLog(tabs $ "+ " $ tag, DEBUG_HIERARCHY);
  }
}

/*=============================================================================
 * getX()
 *
 * Returns the x-start coordinate for this components position.
 *===========================================================================*/
public function float getX() {
  return posX;
}

/*=============================================================================
 * getY()
 *
 * Returns the Y-start coordinate for this components position.
 *===========================================================================*/
public function float getY() {
  return posY;
}

/*=============================================================================
 * getXEnd()
 *
 * Returns the x-end coordinate for this components position.
 *===========================================================================*/
public function float getXEnd() {
  return posXEnd;
}

/*=============================================================================
 * getYEnd()
 *
 * Returns the y-end coordinate for this components position.
 *===========================================================================*/
public function float getYEnd() {
  return posYEnd;
}

/*=============================================================================
 * getStartPosition()
 *
 * Returns the starting position for the upper left point of this component.
 *===========================================================================*/
public function vector2d getStartPosition() {
  local vector2d topLeft;
  local float scaleX, scaleY, scaleMin;
  local float xOffset, yOffset;
  
  // Get window scale
  scaleX = hud.sizeX / NATIVE_WIDTH;
  scaleY = hud.sizeY / NATIVE_HEIGHT;
  
  // Check if stretch to fit is mandatory
  if (bMandatoryScaleToWindow) {
    // Stretch draw position
    topLeft.x = getX() * scaleX; 
    topLeft.y = getY() * scaleY; 
    return topLeft;
  }
  
  // Scaling mode
  switch (hud.scaleMode) {
    case FIXED_SCALE:
      // Calculate offset for unscaled UI
      xOffset = NATIVE_WIDTH * scaleX - NATIVE_WIDTH;
      yOffset = NATIVE_HEIGHT * scaleY - NATIVE_HEIGHT;
      
      // Set draw position
      topLeft.x = getX() + xOffset / 2; 
      topLeft.y = getY() + yOffset / 2; 
      break;
    case STRETCH_SCALE:
      // Stretch draw position
      topLeft.x = getX() * scaleX; 
      topLeft.y = getY() * scaleY; 
      break;
    case NO_STRETCH_SCALE:
      // Use smallest scaler
      scaleMin = (scaleX < scaleY) ? scaleX : scaleY;
      
      // Get offset
      xOffset = (scaleX - scaleMin) * NATIVE_WIDTH / 2;
      yOffset = (scaley - scaleMin) * NATIVE_HEIGHT / 2;
      
      // Use uniform scale
      topLeft.x = getX() * scaleMin + xOffset; 
      topLeft.y = getY() * scaleMin + yOffset; 
      break;
  }
  
  return topLeft;
}

/*=============================================================================
 * getEndPosition()
 *
 * Returns the end position for the bottom right point of this component.
 *===========================================================================*/
public function vector2d getEndPosition() {
  local vector2d bottomRight;
  local float scaleX, scaleY, scaleMin;
  local float xOffset, yOffset;
  
  // Get window scale
  scaleX = hud.sizeX / NATIVE_WIDTH;
  scaleY = hud.sizeY / NATIVE_HEIGHT;
  
  // Check if stretch to fit is mandatory
  if (bMandatoryScaleToWindow) {
    // Stretch draw position
    bottomRight.x = getXEnd() * scaleX; 
    bottomRight.y = getYEnd() * scaleY;
    return bottomRight;
  } 
  
  // Scaling mode
  switch (hud.scaleMode) {
    case FIXED_SCALE:
      // Calculate offset for unscaled UI
      xOffset = NATIVE_WIDTH * scaleX - NATIVE_WIDTH;
      yOffset = NATIVE_HEIGHT * scaleY - NATIVE_HEIGHT;
      
      // Set draw position
      bottomRight.x = getXEnd() + xOffset / 2; 
      bottomRight.y = getYEnd() + yOffset / 2;
      break;
    case STRETCH_SCALE:
      // Stretch draw position
      bottomRight.x = getXEnd() * scaleX; 
      bottomRight.y = getYEnd() * scaleY;
      break;
    case NO_STRETCH_SCALE:
      // Use smallest scaler
      scaleMin = (scaleX < scaleY) ? scaleX : scaleY;
      
      // Get offset
      xOffset = (scaleX - scaleMin) * NATIVE_WIDTH / 2;
      yOffset = (scaley - scaleMin) * NATIVE_HEIGHT / 2;
      
      // Use uniform scale
      bottomRight.x = getXEnd() * scaleMin + xOffset; 
      bottomRight.y = getYEnd() * scaleMin + yOffset; 
      break;
  }
  return bottomRight;
}

/*============================================================================= 
 * multiplyAlpha()
 *
 * Multiplies the alpha component of a color by a given scalar.
 *============================================================================*/
public function Color multiplyAlpha(Color c, float alphaScalar) {
  local Color returnColor;
  
  returnColor.r = c.r;
  returnColor.g = c.g;
  returnColor.b = c.b;
  returnColor.a = c.a * alphaScalar;
  
  return returnColor;
}

/*============================================================================= 
 * multiplyColors()
 *
 * Multiplies colors component wise
 *============================================================================*/
public static function Color multiplyColors(Color c1, Color c2) {
  local Color returnColor;
  
  returnColor.r = 255 * (c1.r / 255.f * c2.r / 255.f);
  returnColor.g = 255 * (c1.g / 255.f * c2.g / 255.f);
  returnColor.b = 255 * (c1.b / 255.f * c2.b / 255.f);
  returnColor.a = 255 * (c1.a / 255.f * c2.a / 255.f);
  
  return returnColor;
}

/*=============================================================================
 * getColor()
 *
 * Returns the draw Color for the visual component
 *===========================================================================*/
protected function Color getColor() { 
  local Color returnColor;
  
  returnColor.r = drawColor.r * fadeSystem.getFadeToBlackScalar();
  returnColor.g = drawColor.g * fadeSystem.getFadeToBlackScalar();
  returnColor.b = drawColor.b * fadeSystem.getFadeToBlackScalar();
  returnColor.a = drawColor.a * fadeSystem.getFadeScalar() + (255 - drawColor.a * fadeSystem.getFadeScalar()) * (1 - fadeSystem.getFadeToBlackScalar());
  
  return returnColor;
}

/*=============================================================================
 * raveHighwindCall()
 *
 * Called by a cheat that enables rave mode graphics on selectors.
 *===========================================================================*/
public function raveHighwindCall() {
  local int i;
  
  // Pass call to children
  for (i = 0; i < componentList.length; i++) {
    componentList[i].raveHighwindCall();
  }
}

/*=============================================================================
 * getLayerCount()
 *
 * Returns the number of layers
 *===========================================================================*/
public static function int getLayerCount() {
  return LayerList.enumCount;
}

/*============================================================================= 
 * debugPosition()
 *
 * 
 *===========================================================================*/
public function debugPosition() {
  `log(posx);
  `log(posy);
  `log(posxend);
  `log(posyend);
}

/*=============================================================================
 * deleteComp()
 *
 * Called by the sceneManager when it's about to get unreferenced by the HUD 
 * for garbage collection.
 *===========================================================================*/
event deleteComp();

/*=============================================================================
 * Default settings
 *===========================================================================*/
defaultProperties
{
  // Draw settings
  bEnabled=true
  
  // Draw layer
  drawLayer=DEFAULT_LAYER
  
  // Anchor
  bAnchor=false
  
  // Positioning
  posX=0
  posY=0
  posXEnd=NATIVE_WIDTH
  posYEnd=NATIVE_HEIGHT
  bRelativeEnd=false
  
  // Default linear interpolation movement info
  lerpFx=(origin=(x=0,y=0), destination=(x=0,y=0), duration=0.f, elapsedTime=0.f)    
  
  drawColor=(r=255,g=255,b=255,a=255)
}






















