/*=============================================================================
 * ROTT_World_Collectible_Gem
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: A 3d world collectible item
 *===========================================================================*/

class ROTT_Resource_Gem extends Actor
  ClassGroup(ROTT_Resources)
  placeable;

// References
var private ROTT_Game_Info gameInfo;

// 3D World info
var ROTT_Resource_Gem_SkM SkMesh;
var PointLightComponent LightComponent1, LightComponent2, LightComponent3;
var PointLightComponent LightComponent4, LightComponent5, LightComponent6;
var  CylinderComponent CylinderComponent;

// Editor info
var const transient SpriteComponent EditorSprite;

// Gameplay item info
var() int Gem_Bonus;

/*=============================================================================
 * postBeginPlay()
 *
 * Called when the game has started
 *===========================================================================*/
function PostBeginPlay() {
  super.PostBeginPlay();
  
  // Set up graphics element
  activateEmitter();
  
  // Link to gameinfo
  gameInfo = ROTT_Game_Info(Worldinfo.game);
}

simulated event Touch(Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal)
{
  if (ROTT_Player_Pawn(Other) == None) {
    return;
  }
  
  // Remove the coin from the world
  skMesh.Destroy();
  destroy();
  lightComponent1 = None;
  lightComponent2 = None;
  lightComponent3 = None;
  lightComponent4 = None;
  lightComponent5 = None;
  lightComponent6 = None;
  
  // Give gems to player
  gameInfo.playerProfile.addCurrency(class'ROTT_Inventory_Item_Gem', Gem_Bonus);
  gameInfo.sfxBox.PlaySFX(SFX_WORLD_GATHER_GEM);
  
  // Add Notification to screen
  gameInfo.showGameplayNotification("+" $ Gem_Bonus $ " " $ class'ROTT_Inventory_Item_Gem'.default.itemName);
}

function activateEmitter()
{
  LightComponent1 = new(self) class'ROTT_PickupLight1';
  self.AttachComponent(LightComponent1);
  LightComponent2 = new(self) class'ROTT_PickupLight2';
  self.AttachComponent(LightComponent2);
  
  LightComponent3 = new(self) class'ROTT_PickupLight1';
  //LightComponent3.SetTranslation(vect(13.39502,-30.765625,36.186645));
  LightComponent3.SetTranslation(vect(25.39502,-25.765625,35.186645));
  self.AttachComponent(LightComponent3);
  
  LightComponent4 = new(self) class'ROTT_PickupLight1';
  LightComponent4.SetTranslation(vect(25.39502,25.765625,35.186645));
  self.AttachComponent(LightComponent4);
  
  LightComponent5 = new(self) class'ROTT_PickupLight1';
  LightComponent5.SetTranslation(vect(-25.39502,25.765625,35.186645));
  self.AttachComponent(LightComponent5);
  
  LightComponent6 = new(self) class'ROTT_PickupLight1';
  LightComponent6.SetTranslation(vect(-25.39502,-25.765625,35.186645));
  self.AttachComponent(LightComponent6);
  
  SkMesh = Spawn(class'ROTT_Resource_Gem_SkM', self, , Location, Rotation);
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  Gem_Bonus=1

  begin object Class=SpriteComponent Name=Sprite
    Sprite=Texture2D'ROTT_Resources.Resource_Icon_Rare'
    HiddenGame=true
    HiddenEditor=false
    AlwaysLoadOnClient=False
    AlwaysLoadOnServer=False
    SpriteCategoryName="Navigation"
    Scale=2.0
  end object
  Components.Add(Sprite)
  EditorSprite=Sprite
  
  begin object Class=CylinderComponent Name=CollisionCylinder LegacyClassName=NavigationPoint_NavigationPointCylinderComponent_Class
    CollisionRadius=+0050.000000
    CollisionHeight=+0120.000000
    CollideActors=true
  end object
  CollisionComponent=CollisionCylinder
  CylinderComponent=CollisionCylinder
  Components.Add(CollisionCylinder)

  bCollideActors=true
  CollisionType = COLLIDE_TouchAll
  bCollideWhenPlacing=true
  
  SupportedEvents(0)=class'SeqEvent_Touch'
}
