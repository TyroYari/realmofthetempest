/*=============================================================================
 * ROTT HUD
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * This class connects the UI scene manager's display and controls with the
 * game's player controller.  This is also in charge of accessing game menu.
 *===========================================================================*/

class ROTT_UI_HUD extends UI_HUD;

// Game info stores high level game data and UI data structures
var privatewrite ROTT_Game_Info gameInfo;

// Over world gameplay references
var public ROTT_Player_Controller tempestPC;
var public ROTT_Player_Pawn tempestPawn;

// Menu control
var privatewrite bool bGameMenuIsOpen;

/*=============================================================================
 * postBeginPlay()
 * 
 * One of the first events called loading a map
 *===========================================================================*/
simulated event postBeginPlay() {
  super.PostBeginPlay();
  gameInfo = ROTT_Game_Info(worldInfo.game); 
  
  // Setup over world gameplay variables
  tempestPawn = ROTT_Player_Pawn(playerOwner.Pawn);
  tempestPC = ROTT_Player_Controller(playerOwner);
  
  // Load scale mode
  scaleMode = ScaleModes(gameInfo.optionsCookie.scaleModeType);
}

/*=============================================================================
 * postRender()
 *
 * Called afer drawing to the canvas. Nothing else should call the HUDs 
 * postRender directly, because it messes up lastHUDRenderTime and renderDelta.
 *===========================================================================*/
simulated event postRender() {
  super.postRender();
}

/*=============================================================================
 * tick()
 * 
 * As an actor subclass, the HUD can provide a sense of time to non-actors.
 *===========================================================================*/
public function tick(float deltaTime) {
  ROTT_UI_Scene_Manager(sceneManager).elapseSceneTime(deltaTime);
}

/*=============================================================================
 * showMenu()
 *
 * Opens menu via the start button
 *===========================================================================*/
exec function showMenu() {
  // Only allow the menu to be opened from the overworld scene
  if (!gameInfo.canOpenMenu()) return;
  
  // Open menu if it isnt already up
  if (bGameMenuIsOpen == false) {
    gameInfo.openGameMenu();
    bGameMenuIsOpen = true;
  }
}

/*=============================================================================
 * closeGameMenu()
 *
 * Sets the menu to closed
 *===========================================================================*/
public function closeGameMenu() {
  bGameMenuIsOpen = false;
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  sceneManagerClass=class'ROTT_UI_Scene_Manager'
}
















