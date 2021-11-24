/*=============================================================================
 * ROTT_Worlds_Safety_Zone
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This zone prevents enemy encounters from starting when the
 * player is inside
 *===========================================================================*/

class ROTT_Worlds_Safety_Zone extends Volume
  placeable;

// References
var privatewrite ROTT_Game_Info gameInfo;

/*=============================================================================
 * PostBeginPlay()
 *===========================================================================*/
simulated event postBeginPlay() {
  super.postBeginPlay();

  if (brushComponent != none)  {
    bProjTarget = brushComponent.blockZeroExtent;
  }
  
  // Link game info for convenience
  gameInfo = ROTT_Game_Info(class'WorldInfo'.static.GetWorldInfo().Game);
}

/*=============================================================================
 * touch()
 *
 * Called when any object collides with this volume.  Updates the encounter
 * list profile when touched by the player.
 *===========================================================================*/
simulated event touch
(
  Actor other, 
  PrimitiveComponent otherComp, 
  vector hitLocation, 
  vector hitNormal
)
{
  // ignore irrelevant events
  if (ROTT_Player_Pawn(other) == none) return;
  
  // Stops enemies from spawning
  gameInfo.setSafetyMode(true);
}

/*=============================================================================
 * untouch()
 *
 * Called when any object leaves this volume.  Removes enemies.
 *===========================================================================*/
simulated event untouch(Actor other) {
  // ignore irrelevant events
  if (ROTT_Player_Pawn(other) == none) return;
  
  // Stops enemies from spawning
  gameInfo.setSafetyMode(false);
}

// Disable projectile functionality
simulated function bool stopsProjectile(Projectile P) {  return false; }

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  BrushColor=(R=0,G=255,B=200,A=255)
  bColored=true
  
  bProjTarget=true
  SupportedEvents.Empty
  SupportedEvents(0)=class'SeqEvent_Touch'
  SupportedEvents(1)=class'SeqEvent_TakeDamage'
}














