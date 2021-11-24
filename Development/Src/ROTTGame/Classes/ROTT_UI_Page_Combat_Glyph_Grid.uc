/*============================================================================= 
 * ROTT_UI_Page_Combat_Glyph_Grid
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This class displays an enemy encounter, and handles player 
 * input for combat interactions.
 *===========================================================================*/
 
class ROTT_UI_Page_Combat_Glyph_Grid extends ROTT_UI_Page
dependsOn(ROTT_Combat_Object);

var private ROTT_UI_Scene_Combat_Encounter someScene;
  
// Glyphs that have been selected for randomization
var private array<GlyphEnum> glyphSet;

// Glyphs currently randomized into the grid
var private GlyphEnum glyphGrid[16];

// Internal graphics references
var private UI_Selector_2D tilePress;
var private UI_Selector_2D glyphSelector;

var private UI_Texture_Storage glyphSprites;
var private UI_Sprite collectibleGlyphs[16];

/*============================================================================= 
 * Initialize Component
 *
 * Description: This event is called as the UI is loaded.
 *              Our initial scene is drawn here.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  local int i;
  
  // Draw each component
  super.initializeComponent(newTag);
  
  someScene = ROTT_UI_Scene_Combat_Encounter(outer);
  
  // UI references
  tilePress = UI_Selector_2D(findComp("Glyph_Tile_Pressed_Sprite"));
  glyphSprites = UI_Texture_Storage(findComp("Glyph_Icon_Container"));
  glyphSelector = UI_Selector_2D(findComp("Combat_Glyph_Selector"));
  
  // Glyph Sprites
  for (i = 0; i < 16; i++) {
    collectibleGlyphs[i] = new class'UI_Sprite';
    componentList.addItem(collectibleGlyphs[i]);
    collectibleGlyphs[i].initializeComponent();
    collectibleGlyphs[i].updatePosition(420 + 60*(i%4), 619 + 60*(i/4));
  }
}

/*============================================================================= 
 * onPushPageEvent()
 *
 * This event is called every time the page is pushed.
 *===========================================================================*/
event onPushPageEvent() {
  // Initialize grid
  randomizeGlyphs();
  
  // Reset push down tile graphic
  tilePress.setEnabled(false);
}

/*============================================================================= 
 * onSceneActivation()
 *
 * This event is called every time the parent scene is activated
 *===========================================================================*/
public function onSceneActivation() {
  
}

/*============================================================================= 
 * onSceneDeactivation()
 *
 * This event is called every time the parent scene is deactivated
 *===========================================================================*/
public function onSceneDeactivation() {
  
}

/*============================================================================= 
 * onScenePause()
 *
 * This event is called when the parent scene pauses
 *===========================================================================*/
public function onScenePause() {
  // Hide glyph selector if combat hasnt started
  glyphSelector.setEnabled(false);
}

/*============================================================================= 
 * onSceneUnpause()
 *
 * This event is called when the parent scene unpauses
 *===========================================================================*/
public function onSceneUnpause() {
  // Hide glyph selector if combat hasnt started
  glyphSelector.setEnabled(true);
  UI_Selector(findComp("Input_Listener")).setActive(true);
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
  name inputName, 
  EInputEvent Event, 
  float AmountDepressed = 1.f, 
  bool bGamepad = false) 
{
  switch (inputName) {
    case 'XboxTypeS_A':
      if (glyphSelector.bEnabled) {
        if (Event == IE_Pressed) { 
          tilePress.setEnabled(true);
        }
        if (Event == IE_Released) {
          tilePress.setEnabled(false);
        }
      }
      break;
  }
  
  return super.onInputKey(ControllerId, inputName, Event, AmountDepressed, bGamepad);
}

/*=============================================================================
 * D-Pad controls
 *===========================================================================*/
public function onNavigateLeft() {
  glyphSelector.moveLeft();
  tilePress.moveLeft();
}

public function onNavigateRight() {
  glyphSelector.moveRight();
  tilePress.moveRight();
}

public function onNavigateUp() {
  glyphSelector.moveUp();
  tilePress.moveUp();
}

public function onNavigateDown() {
  glyphSelector.moveDown();
  tilePress.moveDown();
}

/*============================================================================= 
 * Button inputs
 *===========================================================================*/
protected function navigationRoutineA() {
  collectGlyph();
}
protected function navigationRoutineB();

/*=============================================================================
 * Requirements
 *===========================================================================*/
protected function bool requirementRoutineA() { 
  return glyphSelector.bEnabled; 
}

/*============================================================================= 
 * collectGlyph()
 *
 * Checks if a tile holds a glyph, and provide its benefits to the team.
 *===========================================================================*/
private function collectGlyph() {
  local GlyphEnum selectedGlyph;
  local ROTT_Party party;
  local FontStyles feedbackColor;
  local string feedbackText;
  local int i;
  local bool bClassGlyph;
  
  // Get party info
  party = gameInfo.playerProfile.getActiveParty();
  
  // Check for glyph
  selectedGlyph = glyphGrid[glyphSelector.getSelection()];
  if (selectedGlyph == NO_GLYPH) return;
  
  // Sfx
  sfxBox.playSfx(SFX_COMBAT_GLYPH_COLLECT);
  
  // Count
  party.glyphCount[selectedGlyph]++;
  
  // UI Feedback
  switch (selectedGlyph) {
    // Glyph tree
    case GLYPH_HEALTH: 
      feedbackText = "Health - " $ party.glyphCount[selectedGlyph] $ " -";
      feedbackColor = DEFAULT_SMALL_RED;
      break;
    case GLYPH_MANA: 
      feedbackText = "Mana - " $ party.glyphCount[selectedGlyph] $ " -";
      feedbackColor = DEFAULT_SMALL_BLUE;
      break;
    case GLYPH_MANA_REGAIN: 
      feedbackText = "Mana - " $ party.glyphCount[selectedGlyph] $ " -";
      feedbackColor = DEFAULT_SMALL_CYAN;
      break;
    case GLYPH_ARMOR: 
      feedbackText = "Armor - " $ party.glyphCount[selectedGlyph] $ " -";
      feedbackColor = DEFAULT_SMALL_WHITE;
      break;
    case GLYPH_SPEED: 
      feedbackText = "Speed - " $ party.glyphCount[selectedGlyph] $ " -";
      feedbackColor = DEFAULT_SMALL_YELLOW;
      break;
    case GLYPH_DODGE: 
      feedbackText = "Dodge - " $ party.glyphCount[selectedGlyph] $ " -";
      feedbackColor = DEFAULT_SMALL_ORANGE;
      break;
    case GLYPH_ACCURACY: 
      feedbackText = "Accuracy - " $ party.glyphCount[selectedGlyph] $ " -";
      feedbackColor = DEFAULT_SMALL_GREEN;
      break;
    case GLYPH_DAMAGE: 
      feedbackText = "Damage - " $ party.glyphCount[selectedGlyph] $ " -";
      feedbackColor = DEFAULT_SMALL_TAN;
      break;
      
    // Class skill glyphs
    case GLYPH_VALKYRIE_RETALIATION: 
      feedbackText = "Volt Count - " $ party.glyphCount[selectedGlyph] $ " -";
      feedbackColor = DEFAULT_SMALL_YELLOW;
      bClassGlyph = true;
      break;
    case GLYPH_GOLIATH_COUNTER: 
      feedbackText = "Counters - " $ party.glyphCount[selectedGlyph] $ " -";
      feedbackColor = DEFAULT_SMALL_ORANGE;
      bClassGlyph = true;
      break;
    case GLYPH_WIZARD_SPECTRAL_SURGE: 
      feedbackText = "Surge - " $ party.glyphCount[selectedGlyph] $ " -";
      feedbackColor = DEFAULT_SMALL_PURPLE;
      bClassGlyph = true;
      break;
    case GLYPH_TITAN_STORM: 
      feedbackText = "Storm - " $ party.glyphCount[selectedGlyph] $ " -";
      feedbackColor = DEFAULT_SMALL_CYAN;
      bClassGlyph = true;
      break;
    default: 
      yellowLog("Warning (!) Unhandled glyph: " $ selectedGlyph);
      break;
  }
  someScene.setGlyphFeedback(feedbackText, feedbackColor);
  
  // Provide glyph to party
  for (i = 0; i < party.getPartySize(); i++) {
    party.getHero(i).consumeGlyph(glyphGrid[glyphSelector.getSelection()], bClassGlyph);
  }
 
  // Re-Randomize grid
  randomizeGlyphs();
}

/*============================================================================= 
 * randomizeGlyphs()
 *===========================================================================*/
private function randomizeGlyphs() {
  local ROTT_Party party;
  local int index;
  local int i;
  
  // Party link
  party = gameInfo.playerProfile.getActiveParty();
  
  // Reset glyph set
  glyphSet.length = 0;
  
  // Get glyph set from heroes
  for (i = 1; i <= 8+4; i++) {
    if (party.tryGlyphSpawn(GlyphEnum(i))) {
      glyphSet.addItem(GlyphEnum(i));
    }    
  }
  
  // Fill the rest of this list empty
  glyphSet.length = 16;
  
  // Random mapping to grid
  for (i = 0; i < 16; i++) {
    index = rand(glyphSet.length);
    glyphGrid[i] = glyphSet[index];
    glyphSet.remove(index, 1);;
  }
  
  // Draw glyphs on screen
  renderGlyphs();
}

/*============================================================================= 
 * renderGlyphs()
 *
 * Draws all the current glyphs in the glyph grid 
 *===========================================================================*/
private function renderGlyphs() {
  local int i;
  
  // Draw glyphs from glyph grid
  for (i = 0; i < 16; i++) {
    if (glyphGrid[i] == NO_GLYPH) {
      collectibleGlyphs[i].setEnabled(false);
    } else {
      collectibleGlyphs[i].setEnabled(true);
      collectibleGlyphs[i].copySprite(glyphSprites, glyphGrid[i]);
    }
  }
}

/*============================================================================= 
 * deleteComp
 *===========================================================================*/
event deleteComp() {
  super.deleteComp();
}

/*============================================================================= 
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  bPageForcesCursorOff=true
  
  /** ===== Input ===== **/
  begin object class=ROTT_Input_Handler Name=Input_A
    inputName="XBoxTypeS_A"
    buttonComponent=none
  end object
  inputList.add(Input_A)
  
  /** ===== Textures ===== **/
  // Waiting panel
  begin object class=UI_Texture_Info Name=Combat_Waiting_Panel
    componentTextures.add(Texture2D'GUI.Combat_Waiting_Panel')
  end object
  
  // Glyph grid background
  begin object class=UI_Texture_Info Name=Combat_Glyph_Grid
    componentTextures.add(Texture2D'GUI.Combat_Glyph_Grid')
  end object
  
  // Glyph
  begin object class=UI_Texture_Info Name=Combat_Glyph_Health
    componentTextures.add(Texture2D'GUI.Glyph_Health')
  end object
  begin object class=UI_Texture_Info Name=Combat_Glyph_Mana
    componentTextures.add(Texture2D'GUI.Glyph_Mana')
  end object
  begin object class=UI_Texture_Info Name=Combat_Glyph_Armor
    componentTextures.add(Texture2D'GUI.GLYPH_ARMOR')
  end object
  begin object class=UI_Texture_Info Name=Combat_Glyph_Mana_Regen
    componentTextures.add(Texture2D'GUI.GLYPH_MANA_REGEN')
  end object
  begin object class=UI_Texture_Info Name=Combat_Glyph_Speed
    componentTextures.add(Texture2D'GUI.GLYPH_SPEED')
  end object
  begin object class=UI_Texture_Info Name=Combat_Glyph_Dodge
    componentTextures.add(Texture2D'GUI.GLYPH_DODGE')
  end object
  begin object class=UI_Texture_Info Name=Combat_Glyph_Accuracy
    componentTextures.add(Texture2D'GUI.GLYPH_ACCURACY')
  end object
  begin object class=UI_Texture_Info Name=Combat_Glyph_Damage
    componentTextures.add(Texture2D'GUI.GLYPH_DAMAGE')
  end object
  
  // Class skill glyphs
  begin object class=UI_Texture_Info Name=Combat_Glyph_Retaliation
    componentTextures.add(Texture2D'GUI.Tactical_Skill_Icon_Retaliation')
  end object
  begin object class=UI_Texture_Info Name=Combat_Glyph_Storm
    componentTextures.add(Texture2D'GUI.Glyph_Titan_Icon_Storm')
  end object
  begin object class=UI_Texture_Info Name=Combat_Glyph_Spectral_Surge
    componentTextures.add(Texture2D'GUI.Tactical_Skill_Icon_Mind_Surge')
  end object
  begin object class=UI_Texture_Info Name=Combat_Glyph_Counter
    componentTextures.add(Texture2D'GUI.GLYPH_GOLIATH_COUNTER')
  end object
  
  // Glyph Pressed Tile
  begin object class=UI_Texture_Info Name=Glyph_Tile_Pressed
    componentTextures.add(Texture2D'GUI.Combat_Pressed_Glyph_Tile')
  end object
  
  // Glyph Selector
  begin object class=UI_Texture_Info Name=Glyph_Selector
    componentTextures.add(Texture2D'GUI.Glyph_Selector')
  end object
  
  /** ===== UI Components ===== **/
  // Waiting Panel
  begin object class=UI_Sprite Name=Action_Waiting_Panel
    tag="Action_Waiting_Panel"
    bEnabled=true
    posX=33
    posY=604
    images(0)=Combat_Waiting_Panel
  end object
  componentList.add(Action_Waiting_Panel)
  
  // Glyph Grid Background
  begin object class=UI_Sprite Name=Glyph_Grid_Background
    tag="Glyph_Grid_Background"
    posX=403
    posY=601
    images(0)=Combat_Glyph_Grid
  end object
  componentList.add(Glyph_Grid_Background)
  
  
  
  // Glyph Icons
  begin object class=UI_Texture_Storage Name=Glyph_Icon_Container
    tag="Glyph_Icon_Container"
    textureWidth=64
    textureHeight=64
    images(GLYPH_HEALTH)=Combat_Glyph_Health
    images(GLYPH_MANA)=Combat_Glyph_Mana
    images(GLYPH_ARMOR)=Combat_Glyph_Armor
    images(GLYPH_MANA_REGAIN)=Combat_Glyph_Mana_Regen
    images(GLYPH_SPEED)=Combat_Glyph_Speed
    images(GLYPH_DODGE)=Combat_Glyph_Dodge
    images(GLYPH_ACCURACY)=Combat_Glyph_Accuracy
    images(GLYPH_DAMAGE)=Combat_Glyph_Damage
    
    images(GLYPH_VALKYRIE_RETALIATION)=Combat_Glyph_Retaliation
    images(GLYPH_GOLIATH_COUNTER)=Combat_Glyph_Counter
    images(GLYPH_WIZARD_SPECTRAL_SURGE)=Combat_Glyph_Spectral_Surge
    images(GLYPH_TITAN_STORM)=Combat_Glyph_Storm
  end object
  componentList.add(Glyph_Icon_Container)
  
  // Glyph Tile Pressed
  begin object class=UI_Selector_2D Name=Glyph_Tile_Pressed_Sprite
    tag="Glyph_Tile_Pressed_Sprite"
    bEnabled=false
    posX=421
    posY=618
    images(0)=Glyph_Tile_Pressed
    wrapSelection=true
    
    selectOffset=(x=60,y=60)  // Distance from neighboring spaces
    gridSize=(x=4,y=4)        // Total size of 2d selection space
    
  end object
  componentList.add(Glyph_Tile_Pressed_Sprite)
  
  // Glyph Selector
  begin object class=UI_Selector Name=Input_Listener
    tag="Input_Listener"
    navigationType=SELECTION_2D
    gridSize=(x=4,y=4)          // Total size of 2d selection space
    bEnabled=true
    bActive=true
    navSound=NO_SFX
  end object
  componentList.add(Input_Listener)
  begin object class=UI_Selector_2D Name=Combat_Glyph_Selector
    tag="Combat_Glyph_Selector"
    posX=411
    posY=608
    images(0)=Glyph_Selector
    wrapSelection=true
    
    selectOffset=(x=60,y=60)  // Distance from neighboring spaces
    gridSize=(x=4,y=4)          // Total size of 2d selection space
    
    // Mild glow
    activeEffects.add((effectType = EFFECT_ALPHA_CYCLE, lifeTime = -1, elapsedTime = 0, intervalTime = 0.8, min = 205, max = 255))
    
  end object
  componentList.add(Combat_Glyph_Selector)
  
}























