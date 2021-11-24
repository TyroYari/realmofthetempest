/*============================================================================= 
 * ROTT_Candle
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: A candle object that will automatically light a flame at the 
 * wick.
 *===========================================================================*/

class ROTT_Candle extends Actor
  ClassGroup(ROTT_Objects)
  placeable;

// Graphics internal references
var private SkeletalMeshComponent candleSkeleton;
var private ParticleSystemComponent candleLight;

function postBeginPlay() {
  super.postBeginPlay();
  
  activateEmitter();
}

function activateEmitter() {
  candleSkeleton.attachComponentToSocket(candleLight, 'Flame_Socket');
  
  candleLight.activateSystem();
}

/*============================================================================= 
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  // Candle skeletal mesh
  begin object class=SkeletalMeshComponent Name=Candle_Skeletal_Mesh
    SkeletalMesh=SkeletalMesh'ROTT_Decorations.Candles.SK_Candle_1A'
  end object
  candleSkeleton=Candle_Skeletal_Mesh
  components.add(Candle_Skeletal_Mesh)
  
  // Flame
  begin object class=ParticleSystemComponent Name=PSC_Candle_Light
    Template=ParticleSystem'ROTT_Decorations.Candles.PS_CandleLight_1A'
  end object
  candleLight=PSC_Candle_Light
  components.add(PSC_Candle_Light)
  
}
























