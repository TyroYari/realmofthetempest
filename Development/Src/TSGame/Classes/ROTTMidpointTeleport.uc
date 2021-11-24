class ROTTMidpointTeleport extends SequenceAction;

var() Vector EndPos;
var() Actor StartPos;
var() Actor targetActor;
var() float MidPointMultiplier;
 
function Activated()
{
  //RotatedVector=Normal(EndPos.Location - StartPos.Location);   
 
  //targetActor.SetLocation(vector(((StartPos.Location.X + EndPos.Location.X) / 2.0) ((StartPos.Location.Y + EndPos.Location.Y) / 2.0) ((StartPos.Location.Z + EndPos.Location.Z) / 2.0)));

  targetActor.SetLocation(((EndPos - targetActor.Location) / MidPointMultiplier) + (targetActor.Location));

}
 
static event int GetObjClassVersion()
{
  return Super.GetObjClassVersion() + 1;
}

defaultProperties
{
  bCallHandler=false

  ObjColor=(R=255,G=0,B=255,A=255)
  ObjName="MidpointTeleport"
  ObjCategory="TSFunctions"

  VariableLinks.Empty
  VariableLinks(0)=(ExpectedType=class'SeqVar_Vector',LinkDesc="EndPos",PropertyName=EndPos)
  VariableLinks(1)=(ExpectedType=class'SeqVar_Object',LinkDesc="StartPos",PropertyName=StartPos)
  VariableLinks(2)=(ExpectedType=class'SeqVar_Object',LinkDesc="targetActor",bWriteable=TRUE,PropertyName=targetActor)

}