class ROTT_Player_Camera extends Camera;

var Vector mCameraPosition;
var Rotator mCameraOrientation;
var float mCustomFOV;

function InitializeFor(PlayerController PC) {
  Super.InitializeFor(PC);
  mCameraPosition = Vect(0,0,0);
}

function UpdateViewTarget(out TViewTarget OutVT, float DeltaTime) {
  super.UpdateViewTarget(OutVT, DeltaTime);
  //OutVT.POV.Location = mCameraPosition;
  //OutVT.POV.Rotation = mCameraOrientation;
  OutVT.POV.FOV = mCustomFOV;
}

defaultProperties
{
  mCustomFOV=80 // in version [1.0.5] this was 75
}

 