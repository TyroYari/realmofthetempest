/*=============================================================================
 * ROTT_UI_Alchemy_Tile
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: Manages graphics and gameplay mechanics for an alchemy tile.
 *===========================================================================*/
 
class ROTT_UI_Alchemy_Tile extends UI_Container;

// Tile states
enum ClaimStates {
  TILE_UNCLAIMED,
  TILE_CLAIMED,
};

// Store whether tile is claimed by magic imbuement
var private ClaimStates claimState;

// Reference to outer tile set container
var public ROTT_UI_Alchemy_Tile_Manager tileManager;

// Tile states
enum HeatStates {
  NO_HEAT,
  HEATING,
  HEATED,
};

// Heat state pattern info
struct StateInfo {
  var HeatStates heatState;
  var float timeRemaining;
};

// Store heat pattern information
var private array<StateInfo> stateQueue;

// Internal references
var private UI_Sprite levelMarkerLit;  
var private UI_Sprite levelMarkerUnlit; 
var private UI_Sprite heatMarker;    
var private UI_Sprite tileMagicBackground; 

/*============================================================================= 
 * Initialize Component
 *
 * Description: This event is called as the UI is loaded.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  super.initializeComponent(newTag);
  
  // Internal references
  levelMarkerLit = UI_Sprite(findComp("Level_Marker_Lit"));
  levelMarkerUnlit = UI_Sprite(findComp("Level_Marker_Unlit"));
  heatMarker = UI_Sprite(findComp("Heat_Marker"));
  tileMagicBackground = UI_Sprite(findComp("Tile_Magic_Background"));
  
}

/*============================================================================= 
 * setHeatPattern()
 *
 * Provides state switching information for heating
 *===========================================================================*/
public function setHeatPattern(float heatUpTime, float hotStateTime) {
  local StateInfo newState;
  
  // Set state info for heating up
  newState.heatState = HEATING;
  newState.timeRemaining = heatUpTime;
  
  // Add state
  stateQueue.addItem(newState);
  
  // Set state info for hot state
  newState.heatState = HEATED;
  newState.timeRemaining = hotStateTime;
  
  // Add state
  stateQueue.addItem(newState);
  
  // Update UI
  heatMarker.resetEffects();
  heatMarker.addEffectToQueue(FADE_IN, tileManager.patternManager.heatingStateTime / 2);
  refresh();
}

/*=============================================================================
 * getHeatState()
 *
 * Retrieves the current heat state.
 *===========================================================================*/
public function HeatStates getHeatState() {
  if (stateQueue.length == 0) return No_Heat;
  
  return stateQueue[0].heatState;
}

/*=============================================================================
 * elapseTimer()
 *
 * Increments time every engine tick.
 *===========================================================================*/
public function elapseTimer(float deltaTime, float gameSpeedOverride) {
  super.elapseTimer(deltaTime, gameSpeedOverride);
  
  if (stateQueue.length > 0) {
    stateQueue[0].timeRemaining -= deltaTime;
    if (stateQueue[0].timeRemaining < 0) {
      stateQueue.remove(0, 1);
      refresh();
    }
  }
}

/*=============================================================================
 * claim()
 *
 * Attempts to mark the tile claimed, returns true on success.
 *===========================================================================*/
public function bool claim() {
  if (claimState == TILE_UNCLAIMED) {
    claimState = TILE_CLAIMED;
    
    // Refresh display
    tileMagicBackground.clearEffects();
    tileMagicBackground.addEffectToQueue(DELAY, 0.1);
    tileMagicBackground.addEffectToQueue(FADE_IN, 0.1);
    refresh();
    return true;
  } else {
    return false;
  }
}

/*=============================================================================
 * nextLevel()
 *
 * Called by the manager when the level is cleared.
 *===========================================================================*/
public function nextLevel() {
  reset();
}

/*============================================================================= 
 * reset()
 *
 * Called to reset the tile info
 *===========================================================================*/
public function reset() {
  // Reset claim state
  claimState = TILE_UNCLAIMED;
  
  // Reset pattern
  stateQueue.length = 0;
  
  // Refresh display
  refresh();
}

/*============================================================================= 
 * refresh()
 *
 * This should be called when display data changes.
 *===========================================================================*/
public function refresh() {
  // Level marker graphics
  levelMarkerLit.setEnabled(claimState == TILE_CLAIMED);
  levelMarkerUnlit.setEnabled(claimState == TILE_UNCLAIMED);
  levelMarkerLit.setDrawIndex(getMarkerIndexLit());
  levelMarkerUnlit.setDrawIndex(getMarkerIndexUnlit());
  
  // Tile graphics
  tileMagicBackground.setEnabled(claimState == TILE_CLAIMED);
  
  // Heat graphics
  switch (getHeatState()) {
    case No_Heat:
      heatMarker.setEnabled(false);
      break;
    case HEATING:
      heatMarker.setEnabled(true);
      heatMarker.setdrawIndex(HEATING);
      break;
    case HEATED:
      heatMarker.setEnabled(true);
      heatMarker.setdrawIndex(HEATED);
      break;
  }
}

/*============================================================================= 
 * getMarkerIndexLit()
 *
 * Returns the index for claimed level marker
 *===========================================================================*/
public function byte getMarkerIndexLit() {
  if (tileManager.level > 8) return 8;
  return ((tileManager.level - 1) % 8) + 1;
}

/*============================================================================= 
 * getMarkerIndexUnlit()
 *
 * Returns the index for unclaimed level marker
 *===========================================================================*/
public function byte getMarkerIndexUnlit() {
  if (tileManager.level > 8) return 4;
  return ((tileManager.level - 1) % 4) + 1;
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  bDrawRelative=true
  
  /** ===== Textures ===== **/
  // Tile backgrounds
  begin object class=UI_Texture_Info Name=Tile_Background_Default
    componentTextures.add(Texture2D'ROTT_Alchemy.Game.Alchemy_Game_Tile_Background_Default')
  end object
  begin object class=UI_Texture_Info Name=Tile_Background_Imbued
    componentTextures.add(Texture2D'ROTT_Alchemy.Game.Alchemy_Game_Tile_Background_Imbued')
  end object
  
  // Heat markers
  begin object class=UI_Texture_Info Name=Alchemy_Game_Tile_Heating_Up
    componentTextures.add(Texture2D'ROTT_Alchemy.Game.Alchemy_Game_Tile_Heating_Up')
  end object
  begin object class=UI_Texture_Info Name=Alchemy_Game_Tile_Heated
    componentTextures.add(Texture2D'ROTT_Alchemy.Game.Alchemy_Game_Tile_Heated')
  end object
  
  // Level markers (Gold)
  begin object class=UI_Texture_Info Name=Alchemy_Game_Level_1_Marker_Gold
    componentTextures.add(Texture2D'ROTT_Alchemy.Game.Alchemy_Game_Level_1_Marker_Gold')
  end object
  begin object class=UI_Texture_Info Name=Alchemy_Game_Level_2_Marker_Gold
    componentTextures.add(Texture2D'ROTT_Alchemy.Game.Alchemy_Game_Level_2_Marker_Gold')
  end object
  begin object class=UI_Texture_Info Name=Alchemy_Game_Level_3_Marker_Gold
    componentTextures.add(Texture2D'ROTT_Alchemy.Game.Alchemy_Game_Level_3_Marker_Gold')
  end object
  begin object class=UI_Texture_Info Name=Alchemy_Game_Level_4_Marker_Gold
    componentTextures.add(Texture2D'ROTT_Alchemy.Game.Alchemy_Game_Level_4_Marker_Gold')
  end object
  
  // Level markers (Crimson)
  begin object class=UI_Texture_Info Name=Alchemy_Game_Level_1_Marker_Crimson
    componentTextures.add(Texture2D'ROTT_Alchemy.Game.Alchemy_Game_Level_1_Marker_Crimson')
  end object
  begin object class=UI_Texture_Info Name=Alchemy_Game_Level_2_Marker_Crimson
    componentTextures.add(Texture2D'ROTT_Alchemy.Game.Alchemy_Game_Level_2_Marker_Crimson')
  end object
  begin object class=UI_Texture_Info Name=Alchemy_Game_Level_3_Marker_Crimson
    componentTextures.add(Texture2D'ROTT_Alchemy.Game.Alchemy_Game_Level_3_Marker_Crimson')
  end object
  begin object class=UI_Texture_Info Name=Alchemy_Game_Level_4_Marker_Crimson
    componentTextures.add(Texture2D'ROTT_Alchemy.Game.Alchemy_Game_Level_4_Marker_Crimson')
  end object
  
  // Level markers (Empty)
  begin object class=UI_Texture_Info Name=Alchemy_Game_Level_1_Marker_Empty
    componentTextures.add(Texture2D'ROTT_Alchemy.Game.Alchemy_Game_Level_1_Marker_Empty')
  end object
  begin object class=UI_Texture_Info Name=Alchemy_Game_Level_2_Marker_Empty
    componentTextures.add(Texture2D'ROTT_Alchemy.Game.Alchemy_Game_Level_2_Marker_Empty')
  end object
  begin object class=UI_Texture_Info Name=Alchemy_Game_Level_3_Marker_Empty
    componentTextures.add(Texture2D'ROTT_Alchemy.Game.Alchemy_Game_Level_3_Marker_Empty')
  end object
  begin object class=UI_Texture_Info Name=Alchemy_Game_Level_4_Marker_Empty
    componentTextures.add(Texture2D'ROTT_Alchemy.Game.Alchemy_Game_Level_4_Marker_Empty')
  end object
  
  /** ===== Components ===== **/
  // Tile Background
  begin object class=UI_Sprite Name=Tile_Background
    tag="Tile_Background" 
    posX=0
    posY=0
    images(0)=Tile_Background_Default
  end object
  componentList.Add(Tile_Background)
  
  begin object class=UI_Sprite Name=Tile_Magic_Background
    tag="Tile_Magic_Background" 
    posX=0
    posY=0
    images(0)=Tile_Background_Imbued
  end object
  componentList.Add(Tile_Magic_Background)
  
  // Level Marker (Unlit)
  begin object class=UI_Sprite Name=Level_Marker_Unlit
    tag="Level_Marker_Unlit" 
    bEnabled=true
    posX=0
    posY=0
    images(0)=Tile_Background_Default
    images(1)=Alchemy_Game_Level_1_Marker_Empty
    images(2)=Alchemy_Game_Level_2_Marker_Empty
    images(3)=Alchemy_Game_Level_3_Marker_Empty
    images(4)=Alchemy_Game_Level_4_Marker_Empty
  end object
  componentList.Add(Level_Marker_Unlit)
  
  // Heat Marker
  begin object class=UI_Sprite Name=Heat_Marker
    tag="Heat_Marker"
    bEnabled=false
    posX=0
    posY=0
    images(0)=Tile_Background_Default
    images(HEATING)=Alchemy_Game_Tile_Heating_Up
    images(HEATED)=Alchemy_Game_Tile_Heated
  end object
  componentList.Add(Heat_Marker)
  
  // Level Marker (Lit)
  begin object class=UI_Sprite Name=Level_Marker_Lit
    tag="Level_Marker_Lit" 
    bEnabled=true
    posX=0
    posY=0
    images(0)=Tile_Background_Imbued
    images(1)=Alchemy_Game_Level_1_Marker_Gold
    images(2)=Alchemy_Game_Level_2_Marker_Gold
    images(3)=Alchemy_Game_Level_3_Marker_Gold
    images(4)=Alchemy_Game_Level_4_Marker_Gold
    images(5)=Alchemy_Game_Level_1_Marker_Crimson
    images(6)=Alchemy_Game_Level_2_Marker_Crimson
    images(7)=Alchemy_Game_Level_3_Marker_Crimson
    images(8)=Alchemy_Game_Level_4_Marker_Crimson
  end object
  componentList.Add(Level_Marker_Lit)
  
}
