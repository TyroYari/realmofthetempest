/*=============================================================================
 * ROTT_Jump_Booster
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: A utility for the 3D world that gives the player an extra
 * powerful jump.
 *===========================================================================*/

class ROTT_Jump_Booster extends Volume
  placeable;

// Jump settings
var() int VolumeAcceleration;
var() float speedAmp;

/*=============================================================================
 * postBeginPlay()
 *===========================================================================*/
simulated event postBeginPlay() {
  super.PostBeginPlay();

  if (BrushComponent != none)  {
    bProjTarget = BrushComponent.BlockZeroExtent;
  }
}

/*=============================================================================
 * touch()
 *===========================================================================*/
simulated event touch
(
  Actor Other, 
  PrimitiveComponent OtherComp, 
  vector HitLocation, 
  vector HitNormal
) 
{
  // Skip non player objects
  if (ROTT_Player_Pawn(Other) == none) return;
  
  // Activate a powerful jump
  ROTT_Player_Pawn(Other).activatePowerJump(VolumeAcceleration, speedAmp);
}

/*=============================================================================
 * untouch()
 *===========================================================================*/
simulated event untouch(Actor Other) {
  // Skip non player objects
  if (ROTT_Player_Pawn(Other) == none) return;
  
  // Deactivate power jump
  ROTT_Player_Pawn(Other).deactivatePowerJump();
}

/*=============================================================================
 * StopsProjectile()
 *===========================================================================*/
simulated function bool stopsProjectile(Projectile P) {  return false; }

/*=============================================================================
 * Default properties
 *===========================================================================*/
defaultProperties
{
  // Brush appearance
  bColored=true
  BrushColor=(R=180,G=50,B=250,A=255)

  // Collision
  bCollideActors=true
  bProjTarget=true
  SupportedEvents.Empty
  SupportedEvents(0)=class'SeqEvent_Touch'
}













