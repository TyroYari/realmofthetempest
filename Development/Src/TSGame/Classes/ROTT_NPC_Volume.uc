/*=============================================================================
 * ROTT_NPC_Volume
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This object allows players to access NPC interactions
 * (See: ROTT_NPC_Container.uc and ROTT_UI_Page_NPC_Dialogue.uc)
 *===========================================================================*/

class ROTT_NPC_Volume extends Volume
  placeable;

// Rotation constants
const FOURTY_FIVE_DEGREES = 8192;
const THREE_SIXTY_DEGREES = 65536;

// Npc class list
var() public class<ROTT_NPC_Container> npcType;

// Directions for NPC Exit
enum CardinalDirection {
  NORTH,
  NORTH_EAST,
  EAST,
  SOUTH_EAST,
  SOUTH,
  SOUTH_WEST,
  WEST,
  NORTH_WEST
};

// Player direction after leaving NPC
var() private CardinalDirection exitDirection;  

// Service content
var() public ROTT_Resource_Bestiary bestiaryContent;
var() public ROTT_Resource_Bartering barteringContent;

// References
var private ROTT_Game_Info gameInfo;

`include(ROTTColorLogs.h)

/*=============================================================================
 * postBeginPlay()
 *  
 * Just sets up references
 *===========================================================================*/
event postBeginPlay() {
  gameInfo = ROTT_Game_Info(class'WorldInfo'.static.getWorldInfo().game);
}

/*=============================================================================
 * touch()
 * 
 * This function launches an NPC interaction when touched by the player
 *===========================================================================*/
simulated event touch
(
  Actor other, 
  PrimitiveComponent OtherComp, 
  vector HitLocation, 
  vector HitNormal
)
{
  // Filter out irrelevant objects
  if (ROTT_Player_Pawn(other) == none) return;
  
  // Stop player movement
  gameInfo.pauseGame();
  
  // Start transition to NPC
  gameInfo.sceneManager.sceneOverworld.startTransitionToNPC();
  
  // Queue the dialog
  gameInfo.queuedNPC = openNPCDialog;
  
  // Send over service content
  if (bestiaryContent != none) {
    // Bestiary content
    gameInfo.sceneManager.sceneBestiary.loadBestiary(bestiaryContent);
  }
  if (barteringContent != none) {
    // Bartering content
    gameInfo.sceneManager.sceneBarter.loadBartering(barteringContent);
  }
  
  // Door sound
  gameInfo.sfxBox.playSfx(SFX_WORLD_DOOR);
}

/*=============================================================================
 * openNPCDialog()
 *   
 * Opens the npc dialog
 *===========================================================================*/
private function openNPCDialog() {
  local rotator direction;      // This turns the player around for their exit
  local vector posOffset;       // places the player away from the house
  
  // Display npc interface
  gameInfo.openNPCDialog(npcType);
  
  // Rotate player to exiting direction
  direction = MakeRotator(0, int(exitDirection) * FOURTY_FIVE_DEGREES, 0);
  gameInfo.tempestPC.ClientSetRotation(direction, true);
  
  // Move player to their exit position
  posOffset.X = 200 * cos(toRadians(int(exitDirection) * FOURTY_FIVE_DEGREES));
  posOffset.Y = 200 * sin(toRadians(int(exitDirection) * FOURTY_FIVE_DEGREES));
  posOffset.Z = 0;
  gameInfo.tempestPawn.setLocation(gameInfo.tempestPawn.location + posOffset);
}

/*=============================================================================
 * toRadians()
 *   
 * simply converts unreal rotator units to radians
 *===========================================================================*/
private function float toRadians(int unrealUnits) {
  return float(unrealUnits) / (THREE_SIXTY_DEGREES / (2 * pi));
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  // NPC settings
  exitDirection=NORTH
  
  // Volume settings
  bStatic=false
  bCollideActors=true
  CollisionType=COLLIDE_TouchAll
}
























