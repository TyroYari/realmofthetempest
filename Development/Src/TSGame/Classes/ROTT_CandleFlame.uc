class ROTT_CandleFlame extends Z_UTEmit_HitEffect;

var ParticleSystemComponent flameComp;

defaultProperties
{
  begin object class=ParticleSystemComponent Name=PSCFlameComp
    Translation=(X=0.0,Y=0.0,Z=0.0)
    Template=ParticleSystem'ROTT_Decorations.Candles.PS_CandleLight_1A';
    bAcceptsLights=false
    bAutoActivate=true
  end object
  flameComp=PSCFlameComp
  components.add(PSCFlameComp)
}