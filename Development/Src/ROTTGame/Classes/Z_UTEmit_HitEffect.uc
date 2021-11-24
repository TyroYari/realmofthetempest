class Z_UTEmit_HitEffect extends Z_UTEmitter;

simulated function AttachTo(Pawn P, name NewBoneName)
{
  if (NewBoneName == '') {
    SetBase(P);
  }  else {
    SetBase(P,, P.Mesh, NewBoneName);
  }
}

simulated function PawnBaseDied()
{
  if (ParticleSystemComponent != None) {
    ParticleSystemComponent.DeactivateSystem();
  }
}

defaultProperties
{
  
}
