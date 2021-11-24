/*=============================================================================
 * ROTT_Player_Pawn
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This is the actor controlled by the player in the over world
 *===========================================================================*/

class ROTT_Player_Pawn extends UDKPawn;

// Definitions for pawn behavior in overworld
const MAX_Z_SPEED = 800;
const CROUCH_SPEED = 190;

// A location outside of the map
`DEFINE NOWHERE_VECTOR vect(120000,120000,0)

// Controller reference
var private ROTT_Player_Controller rottController;

// Respawn info
var private int spawnPointIndex;
var private RespawnInfo defaultSpawnInfo;

// Camera settings 
var private bool bOverrideCam;   
var private vector overrideCamLoc; 
var private rotator overrideCamRot; 

// Launch pad mechanics
var private bool bAccelerateJump;
var private int jumpAcceleration; 
var private float speedAmp; 

// Pause mechanics
var privatewrite bool bPaused;
var privatewrite bool bRestorePhysics;
var privatewrite vector pausedVelocity;
var privatewrite vector pausedAccel;

// References
var private ROTT_Game_Info gameInfo;

// components
var private ParticleSystemComponent glideParticles;
var private ParticleSystemComponent stompParticles;

`include(ROTTColorLogs.h)

/*=============================================================================
 * PostBeginPlay()
 *
 * 
 *===========================================================================*/
simulated event postBeginPlay() {
  gameInfo = ROTT_Game_Info(WorldInfo.Game);
}

/*=============================================================================
 * setController()
 *
 * Assigns a controller reference
 *===========================================================================*/
public function setController(ROTT_Player_Controller newController) {
  rottController = newController;
}

/*=============================================================================
 * pausePawn()
 *
 * Pauses the pawn physics
 *===========================================================================*/
public function pausePawn() {
  bPaused = true;
  
  // Set physics mode
  if (Physics != PHYS_Walking) {
    setPhysics(PHYS_Flying);
    
    pausedVelocity = velocity;
    pausedAccel = acceleration;
  }
}

/*=============================================================================
 * unpausePawn()
 *
 * Resumes the pawn physics
 *===========================================================================*/
public function unpausePawn(optional bool bKeepVelocity = false) {
  bPaused = false;
  
  // Set physics mode
  if (Physics == PHYS_Flying) setPhysics(PHYS_Falling);
  
  // Skip resuming physics
  if (bKeepVelocity) bRestorePhysics = true;
}

/*=============================================================================
 * setRespawnIndex()
 * 
 * Called by the checkpoint zone when touched by the player.
 *===========================================================================*/
public function setRespawnIndex(int checkpointIndex) {
  spawnPointIndex = checkpointIndex;
}

/*=============================================================================
 * setArrivalCheckpoint()
 * 
 * Given a checkpoint index, this will set the initial checkpoint locaton.
 * (-1 is default location)
 *===========================================================================*/
public function setArrivalCheckpoint(int checkpointIndex) {
  if (!(checkpointIndex < gameInfo.checkPoints.length)) {
    yellowLog("Warning (!) Checkpoint out of bounds");
    scriptTrace();
    return;
  }
  // Copy and store checkpoint as spawn point
  spawnPointIndex = checkpointIndex;
  
  // Check if a checkpoint is specified
  if (checkpointIndex != -1) {
    setLocation(gameInfo.checkPoints[checkpointIndex].location);
    clientSetRotation(gameInfo.checkPoints[checkpointIndex].rotation);
  }
  
  // Copy current position as default aprrival position
  defaultSpawnInfo.location = location;
  defaultSpawnInfo.rotation = rotation;
}

/*=============================================================================
 * respawnPlayer()
 * 
 * Delegate function, must have no parameters.  Spawns player from timer tick.
 *===========================================================================*/
public function respawnPlayer() {
  // Reset physics
  resetVelocity();
  
  // Player placement
  setLocation(gameInfo.checkPoints[spawnPointIndex].location);
  clientSetRotation(gameInfo.checkPoints[spawnPointIndex].rotation);
}

/*=============================================================================
 * resetVelocity()
 *
 * Clears the velocity that is stored during pause mode.  Used to keep the 
 * player still after unpausing.
 *===========================================================================*/
public function resetVelocity() {
  // Set physics mode
  pausedVelocity = vect(0,0,0);
  pausedAccel = vect(0,0,0);
}

/*=============================================================================
 * activatePowerJump()
 *
 * Activates power jump ability from a jump pad utility
 *===========================================================================*/
public function activatePowerJump(int zAcceleration, float xySpeedAmp) {
  bAccelerateJump = true;
  jumpAcceleration = zAcceleration;  
  speedAmp = xySpeedAmp; 
  
  // Jump pad sfx when already in mid jump
  if (velocity.Z > 0) {
    gameInfo.sfxBox.playSfx(SFX_WORLD_JUMP_PAD);
  }
}

/*=============================================================================
 * doJump()
 *
 * Player jump ability
 *===========================================================================*/
function bool doJump(bool bUpdating) {
  // Sfx when on jump pad
  if (bAccelerateJump) gameInfo.sfxBox.playSfx(SFX_WORLD_JUMP_PAD);
  
  return super.doJump(bUpdating);
}

/*=============================================================================
 * deactivatePowerJump()
 *
 * Deactivates power jump ability
 *===========================================================================*/
public function deactivatePowerJump() {
  bAccelerateJump = false;
  jumpAcceleration = 0;  
  speedAmp = 1.0; 
}

/*=============================================================================
 * landed()
 *
 * Called when the Actor has physically landed onto FloorActor 
 *===========================================================================*/
event landed(vector hitNormal, Actor floorActor) {
  super.landed(hitNormal, floorActor);
  
  // Reset glide lock
  rottController.bGlideLockUntilGround = false;
  if (rottController.bStomping) rottController.releaseStomp();
}

/*=============================================================================
 * overrideCamera()
 *
 * Forces camera to view a specified location, rotation
 *===========================================================================*/
public function overrideCamera(
  optional vector camLoc = overrideCamLoc, 
  optional rotator camRot = overrideCamRot) 
{
  bOverrideCam = true;
  overrideCamLoc = camLoc;  
  overrideCamRot = camRot; 
}

/*=============================================================================
 * releaseCamera()
 *
 * Releases camera override, attaches camera back on player
 *===========================================================================*/
public function releaseCamera() {
  bOverrideCam = false;
}

/*=============================================================================
 * tick()
 *
 * functions that use an element of time are placed here
 *===========================================================================*/
simulated event tick(float deltaTime) {
  // Stop all motion if game menu is up
  if (bPaused == true) { 
    // Clear physics
    velocity = vect(0,0,0);
    acceleration = vect(0,0,0);
    return;
  }
  
  // Restore physics after unpausing
  if (bRestorePhysics == true) { 
    bRestorePhysics = false;
    
    // Restore velocity
    velocity = pausedVelocity;
    acceleration = pausedAccel;
    
    // Clear pause data
    pausedVelocity = vect(0,0,0);
    pausedAccel = vect(0,0,0);
    return;
  }
  
  // Add chance to encounter enemies
  if (velocity != vect(0,0,0)) {
    gameInfo.addEncounterTick();
  }
  
  // Exponentially cuts down velocity (without delta time)
  if (velocity.Z > 0) cutVelocity(deltaTime); // Hacky! 
  
  // Ground pound physics
  if (rottController.bStomping) { 
    if (velocity.z > 0) velocity.Z = 0;
    if (Physics == PHYS_Falling) velocity.z += 10 * deltaTime * velocity.z;
  }
  
  // Glide physics
  if (rottController.bGliding) { 
    if (velocity.z > 0) velocity.Z = 0;
    
    // Modify gravity
    velocity.z = -120;
    
    // Track glide time
    rottController.trackGlideTime(deltaTime);
  }
  
  // Lerp crouch
  if (rottController.bCrouching && baseEyeheight > 34) {
    baseEyeheight -= CROUCH_SPEED * deltaTime;
    if (baseEyeHeight < 34) baseEyeheight = 34;
  }
  if (!rottController.bCrouching && baseEyeheight < 140) {
    baseEyeheight += CROUCH_SPEED * deltaTime;
    if (baseEyeHeight > 140) baseEyeheight = 140;
  }
} 

/*=============================================================================
 * onGlide()
 *
 * 
 *===========================================================================*/
public function onGlide() {
  if (rottController.bStomping) return;
  
  // Start glide effects
  glideParticles.activateSystem();
}

/*=============================================================================
 * onGlideRelease()
 *
 * 
 *===========================================================================*/
public function onGlideRelease() {
  // Start glide effects
  glideParticles.deactivateSystem();
  
  // Physics adjustment for satisfying gameplay
  velocity.z -= 250;
}

/*=============================================================================
 * onStomp()
 *
 * 
 *===========================================================================*/
public function onStomp() {
  stompParticles.activateSystem();
  
  // Cancel glide
  if (rottController.bGliding) rottController.releaseGlide();
}

/*=============================================================================
 * onStompRelease()
 *
 *
 *===========================================================================*/
public function onStompRelease() {
  stompParticles.deactivateSystem();
  
  // Uncrouch
  rottController.releaseCrouch();
}

/*=============================================================================
 * onCrouch()
 *
 * 
 *===========================================================================*/
public function onCrouch() {
  // Set stomp if in air
  if (Physics == PHYS_Falling) rottController.setStomp();
  
  // Set pawn attributes
  groundSpeed = rottController.const.PLAYER_CROUCH_SPEED;
  ///baseEyeheight = 34.0;
  airControl = 0.05;
}
/*=============================================================================
 * onCrouchRelease()
 *
 * 
 *===========================================================================*/
public function onCrouchRelease() {
  // Set pawn attributes
  groundSpeed = rottController.const.PLAYER_SPRINT_SPEED;
  ///baseEyeheight = 140.0; /// 96
  airControl = 0.45;
}

/*=============================================================================
 * cutVelocity()
 *
 * This is called to abruptly curb a players vertical acceleration
 *===========================================================================*/
private function cutVelocity(float deltaTime) {
  // Critical issue - this doesnt scale well with lagg its not real time
  if (velocity.Z > MAX_Z_SPEED)  {
    velocity.Z /= 1.5;
  }
  
  if (bAccelerateJump) {
    velocity.Z = jumpAcceleration;
    velocity.X *= speedAmp;
    velocity.Y *= speedAmp;
  }
  
}

/*=============================================================================
 * Invincibility
 *===========================================================================*/
public function takeDamage
(
  int DamageAmount, Controller EventInstigator, object.Vector HitLocation, 
  object.Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, 
  optional Actor DamageCauser
);

/*=============================================================================
 * calcCamera()
 *
 * Used to place the camera
 *===========================================================================*/
simulated function bool calcCamera
(
  float fDeltaTime, 
  out vector out_CamLoc, 
  out rotator out_CamRot, 
  out float out_FOV
) 
{
  if (bOverrideCam)  {
    // Override camera placement
    out_CamLoc = overrideCamLoc;
    out_CamRot = overrideCamRot;
  } else {
    // By default place the camera at the Pawn's eyes
    GetActorEyesViewPoint(out_CamLoc, out_CamRot);
  }
  
  return true; // no idea what the return value does
}

/*=============================================================================
 * forceTouchEvents()
 *
 * This function is a hacky solution to triggering initial touch() events
 *===========================================================================*/
public function forceTouchEvents() {
  local vector tempReturnLoc;
  
  // Store current location
  tempReturnLoc = location;
  
  // Move to nowhere
  setLocation(`NOWHERE_VECTOR);
  
  // Return
  setLocation(tempReturnLoc);
}

/*=============================================================================
 * Default properties
 *===========================================================================*/
defaultProperties
{
  jumpZ=1620//420
  airControl=0.45
  groundSpeed=0 // See: ROTTPlayerController
  airSpeed=150
  
  baseEyeHeight=140.0
  eyeHeight=96.0
  
  accelRate=2248.0
  maxFallSpeed=5000
  
  maxStepHeight=12
  walkableFloorZ=0.01
  
  bAccelerateJump=false
  speedAmp=1.0f
  
  spawnPointIndex=-1
  
  //WorldViewLoc=(X=249122, Y=-143140, Z=30)
  //WorldViewRot=(Pitch=-72000, Yaw=-169500, Roll=-130500)
  
  
  // Glide particles
  begin object class=ParticleSystemComponent Name=Glide_Particles
    bAutoActivate=false
    Template=ParticleSystem'ROTT_Utilities.Player_Abilities.PS_Player_Glide_Effect'
    SecondsBeforeInactive=1
  end object
  components.Add(Glide_Particles)
  glideParticles=Glide_Particles
  
  // Stomp particles
  begin object class=ParticleSystemComponent Name=Stomp_Particles
    bAutoActivate=false
    Template=ParticleSystem'ROTT_Utilities.Player_Abilities.PS_Player_Stomp_Effect'
    SecondsBeforeInactive=1
  end object
  components.Add(Stomp_Particles)
  stompParticles=Stomp_Particles
  
}























