/*=============================================================================
 *  HealVolume
 *
 *  Author: Otay
 *  Bramble Gate Studios (All rights reserved)
 *
 *  Description: Heals active party when touched by player.
 *===========================================================================*/
class HealVolume extends Volume
  placeable;

simulated event Touch(Actor Other, PrimitiveComponent OtherComp, 
  vector HitLocation, vector HitNormal) 
{
  // Placeholder
  ROTT_Game_Info(WorldInfo.Game).showGameplayNotification("A calm wind rests around you");
  ROTT_Game_Info(WorldInfo.Game).sfxBox.playSFX(SFX_MENU_BLESS_STAT);
  
  // Healing is obsolete
  ///ROTT_Game_Info(WorldInfo.Game).playerProfile.healActiveParty();
}

defaultProperties
{
  bStatic = false;
  bCollideActors=true
  CollisionType = COLLIDE_TouchAll
}
