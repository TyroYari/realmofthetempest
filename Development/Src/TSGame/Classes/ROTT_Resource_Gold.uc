/*=============================================================================
 * ROTT_World_Collectible_Gold
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: A 3d world collectible item
 *===========================================================================*/

class ROTT_Resource_Gold extends Actor
  ClassGroup(ROTT_Resources)
  placeable;

// References
var private ROTT_Game_Info gameInfo;

// 3D World info
var private ROTT_Resource_Gold_SkM SkMesh;
var private PointLightComponent LightComponent1, LightComponent2;
var  private CylinderComponent CylinderComponent;

// Editor info
var const transient SpriteComponent EditorSprite;

// Gameplay item info
var() int goldValue;

/*=============================================================================
 * postBeginPlay()
 *
 * Called when the game has started
 *===========================================================================*/
event postBeginPlay() {
  super.postBeginPlay();
  
  // Set up graphics element
  activateEmitter();
  
  // Link to game info
  gameInfo = ROTT_Game_Info(worldInfo.game);
}

simulated event Touch(Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal)
{
  if (ROTT_Player_Pawn(Other) == None) {
    return;
  }
  
  // Remove the coin from the world
  SkMesh.Destroy();
  Destroy();
  LightComponent1 = None;
  LightComponent2 = None;
  
  // Give gold to player
  gameInfo.playerProfile.addCurrency(class'ROTT_Inventory_Item_Gold', goldValue);
  gameInfo.sfxBox.PlaySFX(SFX_WORLD_GATHER_COIN);
  
  // Add Notification to screen
  gameInfo.showGameplayNotification("+" $ goldValue $ " " $ class'ROTT_Inventory_Item_Gold'.default.itemName);
}

function activateEmitter()
{
  LightComponent1 = new(self) class'ROTT_PickupLight1';
  self.AttachComponent(LightComponent1);
  LightComponent2 = new(self) class'ROTT_PickupLight2';
  self.AttachComponent(LightComponent2);
  
  SkMesh = Spawn(class'ROTT_Resource_Gold_SkM', self, , Location, Rotation);
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  goldValue=10

  begin object Class=SpriteComponent Name=Sprite
    Sprite=Texture2D'ROTT_Resources.Resource_Icon'
    HiddenGame=true
    HiddenEditor=false
    AlwaysLoadOnClient=false
    AlwaysLoadOnServer=false
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
