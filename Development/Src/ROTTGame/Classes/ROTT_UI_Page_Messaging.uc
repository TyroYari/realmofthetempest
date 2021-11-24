/*============================================================================= 
 * ROTT_UI_Page_Messaging
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This class displays a page that allows the player to type.
 *===========================================================================*/
 
class ROTT_UI_Page_Messaging extends ROTT_UI_Page;

// Parent scene
var private ROTT_UI_Scene_Over_World someScene;

// Internal references
var private UI_Label playerMessageLabel;

/*============================================================================= 
 * Initialize Component (might change to onSceneCreation?)
 *
 * Description: This event is called as the UI is loaded.
 *              Our initial scene is drawn here.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  // Draw each component
  super.initializeComponent(newTag);
  
  // Parent scene
  someScene = ROTT_UI_Scene_Over_World(outer);
  
  // UI references
  playerMessageLabel = findLabel("Player_Input_Message_Label");
}

/*============================================================================= 
 * onPushPageEvent()
 *
 * This event is called every time the page is pushed.
 *===========================================================================*/
event onPushPageEvent() {
  playerMessageLabel.setText("");
}

/*=============================================================================
 * Controls
 *
 * ControllerId     the controller that generated this input key event
 * Key              the name of the key which an event occured for
 * EventType        the type of event which occured
 * AmountDepressed  for analog keys, the depression percent.
 *
 * Returns: true to consume the key event, false to pass it on.
 *===========================================================================*/
function bool onInputKey( 
  int ControllerId, 
  name Key, 
  EInputEvent Event, 
  float AmountDepressed = 1.f, 
  bool bGamepad = false) 
{
  // Pressed inputs
  if (Event == IE_Pressed) {
    switch (Key) {
      case 'Enter':
        // Send message to system, and disable message mode 
        someScene.submitMessage(playerMessageLabel.labelText);
        break;
      case 'SpaceBar':
        playerMessageLabel.putChar(" ");
        break;
      case 'BackSpace':
        playerMessageLabel.removeChar();
        break;
      default:
        // Allow player to type message
        playerMessageLabel.putChar(Locs(Key));
        break;
    }
  }
  
  return true;
}

/*============================================================================= 
 * defaultProperties
 *===========================================================================*/
defaultProperties
{
  bMandatoryScaleToWindow=true
  
  /** ===== UI Components ===== **/
  // Message Label
  begin object class=UI_Label Name=Message_Label
    tag="Message_Label"
    posX=328
    posY=810
    posYend=874
    alignX=LEFT
    alignY=CENTER
    fontStyle=DEFAULT_MEDIUM_WHITE
    labelText="Message:"
  end object
  componentList.add(Message_Label)
  
  // Player Input Message Label
  begin object class=UI_Label Name=Player_Input_Message_Label
    tag="Player_Input_Message_Label"
    posX=488
    posY=810
    posXEnd=NATIVE_WIDTH
    posYend=874
    alignX=LEFT
    alignY=CENTER
    fontStyle=DEFAULT_MEDIUM_WHITE
    labelText="This is the players message"
  end object
  componentList.add(Player_Input_Message_Label)
  
}