/*=============================================================================
 * ROTT_UI_Page_World_Map
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This page shows the world map (Opened with the select button)
 *===========================================================================*/
 
class ROTT_UI_Page_World_Map extends ROTT_UI_Page;

// Internal references
var private UI_Container worldMap;
var private UI_Sprite worldMapSprite;
var private UI_Sprite playerMarker;
var private UI_Label gameVersionText;

// Store reference to input
var private UI_Player_Input rottInput;

// Parent scene
var private ROTT_UI_Scene_World_Map someScene;

// Map controls
var private float mapSpeed;

/*============================================================================= 
 * initializeComponent()
 *
 * Called once, when the scene is first initialized.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  super.initializeComponent(newTag);
  
  // set parent scene
  someScene = ROTT_UI_Scene_World_Map(outer);
  
  // Internal references
  worldMap = UI_Container(findComp("World_Map_Container"));
  worldMapSprite = UI_Sprite(worldMap.findComp("Background_Sprite"));
  playerMarker = UI_Sprite(worldMap.findComp("Player_Marker_Sprite"));
  gameVersionText = findLabel("Game_Version_Text");
  
  // Draw version info
  gameVersionText.setText(gameInfo.getVersionInfo()); 
}

/*============================================================================= 
 * onPushPageEvent
 *
 * Description: This event is called every time the page is pushed.
 *===========================================================================*/
event onPushPageEvent() {
}

/*============================================================================= 
 * onPopPageEvent()
 *
 * This event is called when the page is removed
 *===========================================================================*/
event onPopPageEvent() {
  
}

/*============================================================================= 
 * refresh()
 *
 * This function should ensure that any data thats been changed will be 
 * correctly updated on the UI.
 *===========================================================================*/
public function refresh() {
  switch(gameInfo.getCurrentMap()) {
    case MAP_TALONOVIA_TOWN:
      playerMarker.updatePosition(
        0.017 * gameInfo.tempestPawn.location.y + 1466 + worldMap.getX(),
        -0.017 * gameInfo.tempestPawn.location.x + 1260.375 + worldMap.getY()
      );
      break;
    case MAP_RHUNIA_WILDERNESS:
      playerMarker.updatePosition(
        0.0086685 * gameInfo.tempestPawn.location.y + 1511 + worldMap.getX(),
        -0.0086685 * gameInfo.tempestPawn.location.x + 840 + worldMap.getY()
      );
      break;
    case MAP_RHUNIA_CITADEL:
      playerMarker.updatePosition(
        0.015131 * gameInfo.tempestPawn.location.y + 1084 + worldMap.getX(),
        -0.015131 * gameInfo.tempestPawn.location.x + 213 + worldMap.getY()
      );
      break;
    case MAP_RHUNIA_OUTSKIRTS: //////////////////////////////////////
      playerMarker.updatePosition(
        0.0077979 * gameInfo.tempestPawn.location.y + 1911+25-16 + worldMap.getX(),
        -0.0077979 * gameInfo.tempestPawn.location.x + 840+136-10 + worldMap.getY()
      );
      break;
    case MAP_ETZLAND_WILDERNESS:
      playerMarker.updatePosition(
        0.00571555 * gameInfo.tempestPawn.location.y + 1024 + worldMap.getX(),
        -0.00571555 * gameInfo.tempestPawn.location.x + 809 + worldMap.getY()
      );
      break;
    case MAP_ETZLAND_CITADEL:
      playerMarker.updatePosition(
        0.015 * gameInfo.tempestPawn.location.y + 1322 + worldMap.getX(),
        -0.015 * gameInfo.tempestPawn.location.x + 372 + worldMap.getY()
      );
      break;
    case MAP_ETZLAND_OUTSKIRTS:
      playerMarker.updatePosition(
        0.0054896 * gameInfo.tempestPawn.location.y + 938 + worldMap.getX(),
        -0.0054896 * gameInfo.tempestPawn.location.x + 457 + worldMap.getY()
      );
      break;
    case MAP_HAXLYN_WILDERNESS:
      playerMarker.updatePosition(
        0.0092 * gameInfo.tempestPawn.location.y + 206 + worldMap.getX(),
        -0.0092 * gameInfo.tempestPawn.location.x + 923 + worldMap.getY()
      );
      break;
    case MAP_HAXLYN_CITADEL:
      playerMarker.updatePosition(
        0.021 * gameInfo.tempestPawn.location.y + -84 + worldMap.getX(),
        -0.021 * gameInfo.tempestPawn.location.x + 441 + worldMap.getY()
      );
      break;
    case MAP_HAXLYN_BACKLANDS:
      playerMarker.updatePosition(
        0.008758447 * gameInfo.tempestPawn.location.y + 252+203+82 + worldMap.getX(),
        -0.008758447 * gameInfo.tempestPawn.location.x + 330+192+78 + worldMap.getY()
      );
      break;
    case MAP_HAXLYN_OUTSKIRTS:
      playerMarker.updatePosition(
        0.011378 * gameInfo.tempestPawn.location.y + 875 + worldMap.getX(),
        -0.011378 * gameInfo.tempestPawn.location.x + 1485 + worldMap.getY()
      );
      break;
    case MAP_TALONOVIA_BACKLANDS:
      playerMarker.updatePosition(
        0.00741425 * gameInfo.tempestPawn.location.y + 1199 + worldMap.getX(),
        -0.00741425 * gameInfo.tempestPawn.location.x + 1472 + worldMap.getY()
      );
      break;
    case MAP_TALONOVIA_OUTSKIRTS:
      playerMarker.updatePosition(
        0.00747 * gameInfo.tempestPawn.location.y + 1699 + worldMap.getX(),
        -0.00747 * gameInfo.tempestPawn.location.x + 1441 + worldMap.getY()
      );
      break;
    case MAP_VALIMOR_WILDERNESS:
      playerMarker.updatePosition(
        0.006507 * gameInfo.tempestPawn.location.y + 1982 + worldMap.getX(),
        -0.006507 * gameInfo.tempestPawn.location.x + 632 + worldMap.getY()
      );
      break;
    case MAP_VALIMOR_BACKLANDS:
      playerMarker.updatePosition(
        0.0069776447 * gameInfo.tempestPawn.location.y + 2392 + worldMap.getX(),
        -0.0069776447 * gameInfo.tempestPawn.location.x + 442 + worldMap.getY()
      );
      break;
    case MAP_VALIMOR_CITADEL:
      playerMarker.updatePosition(
        0.01641298 * gameInfo.tempestPawn.location.y + 3032 + worldMap.getX(),
        -0.01641298 * gameInfo.tempestPawn.location.x + 670 + worldMap.getY()
      );
      break;
    case MAP_KALROTH_WILDERNESS:
      playerMarker.updatePosition(
        0.00686793 * gameInfo.tempestPawn.location.y + 2203 + worldMap.getX(),
        -0.00686793 * gameInfo.tempestPawn.location.x + 1136 + worldMap.getY()
      );
      break;
  }
}
  
/*============================================================================= 
 * onSceneActivation
 *
 * Called every time the parent scene is loaded
 *===========================================================================*/
public function onSceneActivation() {
  // Update the player location
  refresh();
  
  // Center to play location
  worldMap.ShiftX(
    (NATIVE_WIDTH / 2) - (playerMarker.getX() + 32)
  );
  
  worldMap.ShiftY(
    (NATIVE_HEIGHT / 2) - (playerMarker.getY() + 32)
  );
  
  rottInput = UI_Player_Input(getPlayerInput());
}

/*=============================================================================
 * onFocusMenu()
 *
 * Called when a menu is given focus.  Assign controls, and enable graphics.
 *===========================================================================*/
event onFocusMenu();

/*=============================================================================
 * elapseTimers()
 *
 * Ticks every frame.  Used to check for joystick navigation.
 *===========================================================================*/
public function elapseTimers(float deltaTime) {
  super.elapseTimers(deltaTime);
  
  // Map movement
  if (UI_Player_Input(getPlayerInput()).bGamepadActive) {
    worldMap.shiftX(mapSpeed * rottInput.RawJoyRight * -1);
    worldMap.shiftY(mapSpeed * rottInput.RawJoyUp);
  } else {
    // Map movement
    worldMap.shiftX(mapSpeed * rottInput.isKeyDown('XBoxTypeS_DPad_Left'));
    worldMap.shiftX(mapSpeed * rottInput.isKeyDown('XBoxTypeS_DPad_Right') * -1);
    worldMap.shiftY(mapSpeed * rottInput.isKeyDown('XBoxTypeS_DPad_Up'));
    worldMap.shiftY(mapSpeed * rottInput.isKeyDown('XBoxTypeS_DPad_Down') * -1);
  }
  
  // Left-right bounds
  if (worldMap.getX() < -1 * NATIVE_WIDTH) {
    worldMap.updatePosition(
      -1 * NATIVE_WIDTH
    );
  } else if (worldMap.getX() > 0) {
    worldMap.updatePosition(
      0
    );
  }
  
  // Up-down bounds
  if (worldMap.getY() < -1 * NATIVE_HEIGHT) {
    worldMap.updatePosition(
      ,
      -1 * NATIVE_HEIGHT
    );
  } else if (worldMap.getY() > 0) {
    worldMap.updatePosition(
      ,
      0
    );
  }
  
  refresh();
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
function bool onInputKey
( 
  int ControllerId, 
  name inputName, 
  EInputEvent Event, 
  float AmountDepressed = 1.f, 
  bool bGamepad = false
) 
{
  // Remap
  ///switch (inputName) {
  ///  // Mouse and keyboard
  ///  case 'W': case 'Up':      inputName = 'XBoxTypeS_DPad_Up'; break;   
  ///  case 'A': case 'Left':    inputName = 'XBoxTypeS_DPad_Left'; break;   
  ///  case 'S': case 'Down':    inputName = 'XBoxTypeS_DPad_Down'; break;   
  ///  case 'D': case 'Right':   inputName = 'XBoxTypeS_DPad_Right'; break;
  ///}
  
  // Process input
  switch (inputName) {
    case 'M': 
    case 'XboxTypeS_Back': 
      // World map
      if (Event == IE_Pressed) {
        gameinfo.sceneManager.switchScene(SCENE_OVER_WORLD);
        
        // Sfx
        sfxBox.playSFX(SFX_CLOSE_WORLD_MAP);
      }
      break;
    default:
      return super.onInputKey(ControllerId, inputName, Event, AmountDepressed, bGamepad);
  }
  
  return false;
}

/*=============================================================================
 * D-Pad controls
 *===========================================================================*/
public function onNavigateLeft();
public function onNavigateRight();

/*=============================================================================
 * Button controls
 *===========================================================================*/
protected function navigationRoutineA();

protected function navigationRoutineB() {
  gameInfo.sceneManager.switchScene(SCENE_OVER_WORLD);
  
  // Sfx
  sfxBox.playSFX(SFX_CLOSE_WORLD_MAP);
}

/*=============================================================================
 * Assets
 *===========================================================================*/
defaultProperties
{
  // Map controls
  mapSpeed=12.f
  
  /** ===== Input ===== **/
  begin object class=ROTT_Input_Handler Name=Input_B
    inputName="XBoxTypeS_B"
    buttonComponent=none
  end object
  inputList.add(Input_B)
  
  /** ===== UI Components ===== **/
  begin object class=UI_Container Name=World_Map_Container
    tag="World_Map_Container"
    bEnabled=true
    bDrawRelative=true
    posX=-720
    posY=-450
    posXEnd=2160
    posYEnd=1350
    
    // Left menu backgrounds
    begin object class=UI_Texture_Info Name=World_Map
      componentTextures.add(Texture2D'GUI_Overworld.World_Map')
    end object
    
    // Background
    begin object class=UI_Sprite Name=Background_Sprite
      tag="Background_Sprite"
      bEnabled=true
      posX=0
      posY=0
      posXEnd=2880
      posYEnd=1800
      images(0)=World_Map
    end object
    componentList.add(Background_Sprite)
      
    // Map Markers
    begin object class=UI_Texture_Info Name=Player_Marker_Texture
      componentTextures.add(Texture2D'GUI_Overworld.Map_Markers.World_Map_Player_Marker')
    end object
    begin object class=UI_Texture_Info Name=Blue_Marker_Texture
      componentTextures.add(Texture2D'GUI_Overworld.Map_Markers.World_Map_Blue_Marker')
    end object
    begin object class=UI_Texture_Info Name=Cyan_Marker_Texture
      componentTextures.add(Texture2D'GUI_Overworld.Map_Markers.World_Map_Cyan_Marker')
    end object
    begin object class=UI_Texture_Info Name=Green_Marker_Texture
      componentTextures.add(Texture2D'GUI_Overworld.Map_Markers.World_Map_Green_Marker')
    end object
    begin object class=UI_Texture_Info Name=Purple_Marker_Texture
      componentTextures.add(Texture2D'GUI_Overworld.Map_Markers.World_Map_Purple_Marker')
    end object
    begin object class=UI_Texture_Info Name=Red_Marker_Texture
      componentTextures.add(Texture2D'GUI_Overworld.Map_Markers.World_Map_Red_Marker')
    end object
    
    // Azra Marker
    begin object class=UI_Sprite Name=Azra_Marker_Sprite
      tag="Azra_Marker_Sprite"
      bEnabled=true
      posX=1531
      posY=139
      images(0)=Red_Marker_Texture
      activeEffects.add((effectType = EFFECT_ALPHA_CYCLE, lifeTime = -1, elapsedTime = 0, intervalTime = 0.4, min = 170, max = 255))
    end object
    componentList.add(Azra_Marker_Sprite)
  
    // Hyrix Marker
    begin object class=UI_Sprite Name=Hyrix_Marker_Sprite
      tag="Hyrix_Marker_Sprite"
      bEnabled=true
      posX=1191
      posY=98
      images(0)=Green_Marker_Texture
      activeEffects.add((effectType = EFFECT_ALPHA_CYCLE, lifeTime = -1, elapsedTime = 0, intervalTime = 0.4, min = 170, max = 255))
    end object
    componentList.add(Hyrix_Marker_Sprite)
  
    // Khomat Marker
    begin object class=UI_Sprite Name=Khomat_Marker_Sprite
      tag="Khomat_Marker_Sprite"
      bEnabled=true
      posX=114
      posY=32
      images(0)=Blue_Marker_Texture
      activeEffects.add((effectType = EFFECT_ALPHA_CYCLE, lifeTime = -1, elapsedTime = 0, intervalTime = 0.4, min = 170, max = 255))
    end object
    componentList.add(Khomat_Marker_Sprite)
  
    // ??? Marker
    begin object class=UI_Sprite Name=P_Marker_Sprite
      tag="P_Marker_Sprite"
      bEnabled=true
      posX=2620
      posY=66
      images(0)=Purple_Marker_Texture
      activeEffects.add((effectType = EFFECT_ALPHA_CYCLE, lifeTime = -1, elapsedTime = 0, intervalTime = 0.4, min = 170, max = 255))
    end object
    componentList.add(P_Marker_Sprite)
  
    // ??? Marker
    begin object class=UI_Sprite Name=C_Marker_Sprite
      tag="C_Marker_Sprite"
      bEnabled=false
      posX=450
      posY=450
      images(0)=Cyan_Marker_Texture
      activeEffects.add((effectType = EFFECT_ALPHA_CYCLE, lifeTime = -1, elapsedTime = 0, intervalTime = 0.4, min = 170, max = 255))
    end object
    componentList.add(C_Marker_Sprite)
  
    // Player Marker
    begin object class=UI_Sprite Name=Player_Marker_Sprite
      tag="Player_Marker_Sprite"
      bEnabled=true
      posX=0
      posY=0
      images(0)=Player_Marker_Texture
      activeEffects.add((effectType = EFFECT_ALPHA_CYCLE, lifeTime = -1, elapsedTime = 0, intervalTime = 0.4, min = 170, max = 255))
    end object
    componentList.add(Player_Marker_Sprite)
  
  end object
  componentList.add(World_Map_Container)
  
  // Frame Texture
  begin object class=UI_Texture_Info Name=World_Map_Frame
    componentTextures.add(Texture2D'GUI_Overworld.World_Map_Frame')
  end object
  
  // Frame
  begin object class=UI_Sprite Name=Frame_Sprite
    tag="Frame_Sprite"
    bEnabled=true
    posX=0
    posY=0
    posXEnd=1440
    posYEnd=900
    images(0)=World_Map_Frame
  end object
  componentList.add(Frame_Sprite)
  
  // Version label
  begin object class=UI_Label Name=Game_Version_Text
    tag="Game_Version_Text"
    posX=25
    posY=25
    posXEnd=1415
    posYEnd=875
    alignX=LEFT
    alignY=BOTTOM
    fontStyle=DEFAULT_SMALL_BROWN
    labelText=""
  end object
  componentList.add(Game_Version_Text)
  
}
















