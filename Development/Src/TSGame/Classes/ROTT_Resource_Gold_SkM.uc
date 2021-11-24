/*============================================================================= 
 * ROTT_Resource_Gold_SkM
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: A skeletal mesh with a particle system for a collectible coin.
 *===========================================================================*/

class ROTT_Resource_Gold_SkM extends Actor;

// Graphics internal references
var private skeletalMeshComponent coinSkeleton;
var private ParticleSystemComponent coinSparkle;

function postBeginPlay() {
  super.postBeginPlay();
  
  coinSkeleton.attachComponentToSocket(coinSparkle, 'Sparkle_Socket');
  
  coinSparkle.activateSystem();
}

simulated function tick(float deltaTime) {
  setRotation(
    RInterpTo(
      rotation, 
      rotation + rot(0, 25000, 0), 
      deltaTime, 
      0.7
    )
  );
}

/*============================================================================= 
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  // Coin skeletal mesh
  begin object Class=SkeletalMeshComponent Name=Coin_Skeletal_Mesh
    SkeletalMesh=SkeletalMesh'ROTT_Resources.Resource_Coin'
    LightingChannels=(Cinematic_8=True)
  end object
  coinSkeleton=Coin_Skeletal_Mesh
  components.add(Coin_Skeletal_Mesh)
  
  // Coin Sparkle
  begin object Class=ParticleSystemComponent Name=PSC_Coin_Sparkle
    Template=ParticleSystem'ROTT_Resources.PS_Resource_Gold'
  end object
  coinSparkle=PSC_Coin_Sparkle
  components.add(PSC_Coin_Sparkle)
  
}
