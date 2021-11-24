/*=============================================================================
 * UI_HUD
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: A HUD base class that is filled out more at the ROTT level
 *===========================================================================*/

class UI_HUD extends HUD;

// Default dimensions, same size as our mock up UI designs
const NATIVE_WIDTH  = 1440; 
const NATIVE_HEIGHT = 900;

// Window scaling options
enum ScaleModes {
  FIXED_SCALE,
  NO_STRETCH_SCALE,
  STRETCH_SCALE,
};

// Selected scaling mode
var public ScaleModes scaleMode;

// The scene manager, which controls switching between UI scenes 
var(HUD) editinline UI_Scene_Manager sceneManager; 

// The custom sceneManager class that we use as template.
var(HUD) editconst class<UI_Scene_Manager> sceneManagerClass; 

enum CursorTypes {
  Cursor_Default,
  Cursor_Hot,
  Cursor_Blocked
};

// Cursor default sprite texture
var const Texture2D cursorGraphics[CursorTypes];

// The color of the cursor
var const Color cursorColor;

// The color of the cursor
var privatewrite bool bHideCursor;

// If set false, the cursor is always hidden
var protectedwrite bool bCursorActive;

// Store player input reference
var UI_Player_Input uiPlayerInput;

var bool bMouseInitialized;

/*===========================================================================*/

`include(ROTTColorLogs.h)

/*=============================================================================
 * postBeginPlay()
 *===========================================================================*/
simulated event postBeginPlay() {
  super(HUD).postBeginPlay();

  // Instantiate a scene manager
  if (sceneManager == none) {
    sceneManager = new(self) sceneManagerClass;
  }
  
  // Initialize scene manager
  sceneManager.initSceneManager();

  // Cast to get the UI_Player_Input
  uiPlayerInput = UI_Player_Input(PlayerOwner.PlayerInput);
  
}

/*=============================================================================
 * initMousePosition()
 *
 * This has to be called after playerinput's mouse is initialized?
 *===========================================================================*/
public function initMousePosition() {
  local vector2D ViewportSize;
  local PlayerController PC;

  PC = class'WorldInfo'.static.GetWorldInfo().GetALocalPlayerController();

  LocalPlayer(PC.Player).ViewportClient.GetViewportSize(ViewportSize);

  // Set initial mouse position
  if (uiPlayerInput != none) {
    uiPlayerInput.setMousePosition(ViewportSize.x / 2, ViewportSize.y / 2);
  }
  
  bMouseInitialized = true;
}

/*=============================================================================
 * postRender()
 *
 * Called afer drawing to the canvas. Nothing else should call the HUDs 
 * postRender directly, because it messes up LastHUDRenderTime and RenderDelta.
 *===========================================================================*/
simulated event postRender() {
  if (!bMouseInitialized) initMousePosition();
  
  // Old Scaleform?
  // PreCalcValues is a function which can detect if the resolution of the screen has changed.
  ///if (sizeX != canvas.sizeX || sizeY != canvas.sizeY) {
  ///  preCalcValues();
  ///}
  
  // Old Benchmarks
  // Set up delta time
  ///renderDelta = worldInfo.timeSeconds - lastHUDRenderTime;
  ///lastHUDRenderTime = worldInfo.timeSeconds;
  
  // Call the render routine on the scene to render its UI components
  if (sceneManager != none) {
    sceneManager.renderScene(canvas);
  }
  
  super.postRender();
  
  // Cursor visibility check
  if (bHideCursor) return;
  
  // Cursor rendering
  if (playerOwner != none) {
    if (uiPlayerInput != none) {
      // Set the canvas position to the mouse position
      canvas.setPos(
        uiPlayerInput.mousePosition.x, 
        uiPlayerInput.mousePosition.y
      );
      
      // Draw the cursor
      renderCursor(
        sceneManager.getCursorType(),
        uiPlayerInput.mousePosition.x, 
        uiPlayerInput.mousePosition.y
      );
    }
  }
  
}

/*============================================================================= 
 * renderCursor()
 *
 * Draws the cursor icon to the screen
 *===========================================================================*/
protected function renderCursor(byte cursorIndex, int x, int y) {
  local bool bShowDebug;
  bShowDebug = false;
  
  // Set the cursor color
  canvas.drawColor = cursorColor;
  canvas.drawColor.A = 240 + 15 * cos(worldInfo.timeSeconds * 10);
  
  // Debug log
  if (bShowDebug) {
    greenlog("Drawing the mouse at (" $ x $ ", " $ y $ ")");
  }
  
  // Draw the texture on the screen
  canvas.drawTile(
    cursorGraphics[cursorIndex], 
    cursorGraphics[cursorIndex].sizeX, 
    cursorGraphics[cursorIndex].sizeY, 
    0.f, 
    0.f, 
    cursorGraphics[cursorIndex].sizeX, 
    cursorGraphics[cursorIndex].sizeY,
    , 
    true
  );
}

/*=============================================================================
 * 
 *===========================================================================*/
function onInputKey(name Key) {
  switch (Key) {
    case 'XBoxTypeS_A':
    case 'XBoxTypeS_B':
    case 'XBoxTypeS_X':
    case 'XBoxTypeS_Y':
    case 'XboxTypeS_LeftShoulder': 
    case 'XboxTypeS_RightShoulder': 
      lockCursorHidden();
      break;
  }
}

/*============================================================================= 
 * getScaleX()
 *
 * 
 *===========================================================================*/
///public function float getScaleX() { 
///  local float scaleX, scaleY;
///
///  // Get window scale
///  scaleX = sizeX;
///  scaleY = sizeY;
///  
///  // Scaling mode
///  switch (scaleMode) {
///    case NO_STRETCH_SCALE:
///      // Return smallest scaler
///      return (scaleX < scaleY) ? scaleX : scaleY;
///  }
///  return scaleX;
///}
///
////*============================================================================= 
/// * getScaleY()
/// *
/// * 
/// *===========================================================================*/
///public function float getScaleY() { 
///  local float scaleX, scaleY;
///
///  // Get window scale
///  scaleX = sizeX;
///  scaleY = sizeY;
///  
///  // Scaling mode
///  switch (scaleMode) {
///    case NO_STRETCH_SCALE:
///      // Return smallest scaler
///      return (scaleX < scaleY) ? scaleX : scaleY;
///  }
///  return scaleY;
///}

/*============================================================================= 
 * lockCursorHidden()
 *
 * 
 *===========================================================================*/
public function lockCursorHidden() { 
  hideCursor();
  bCursorActive = true;
}

/*============================================================================= 
 * unlockCursorHidden()
 *
 * 
 *===========================================================================*/
public function unlockCursorHidden() { 
  bCursorActive = false;
  
  showMouseMenus();
}

/*============================================================================= 
 * hideCursor()
 *
 * Called when controller input is given.  Hides mouse UI. 
 *===========================================================================*/
public function hideCursor() {
  bHideCursor = true;
}

/*============================================================================= 
 * showMouseMenus()
 *
 * Called when keyboard and mouse input is given.  Shows mouse UI.
 *===========================================================================*/
public function showMouseMenus() {
  if (bCursorActive) return;
  bHideCursor = false;
}

// This must be stubbed to prevent scaleform menus from opening
function togglePauseMenu();
function drawHud();
function checkViewPortAspectRatio();

event destroyed() {
  super.destroyed();
  
  if (sceneManager != none) {
    sceneManager.deleteSceneManager();
    sceneManager = none;
  }
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  // Menu and interface manager
  sceneManagerClass=class'UI_Scene_Manager'
  
  // Scale mode
  scaleMode=NO_STRETCH_SCALE
  
  // Cursor settings
  cursorColor=(R=255,G=255,B=255,A=255)
  cursorGraphics(Cursor_Default)=Texture2D'UI_Cursor_Support.Cursor_Sprite_Default'
  cursorGraphics(Cursor_Hot)=Texture2D'UI_Cursor_Support.Cursor_Sprite_Red'
  //cursorGraphics(Cursor_Blocked)=Texture2D'UI_Cursor_Support.Cursor_Sprite_Gray'
  
  // Cursor visibility
  bHideCursor=false
}










