/*============================================================================= 
 * ROTT_UI_Page_Combat_Encounter
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This class displays an enemy encounter, and handles player 
 * input for combat interactions.
 *===========================================================================*/
 
class ROTT_UI_Page_Combat_Encounter extends ROTT_UI_Page;

// Internal References
var privatewrite ROTT_UI_Displayer_Combat_Heroes heroDisplayers;
var privatewrite ROTT_UI_Displayer_Combat_Enemy enemyDisplayers[3];

var public UI_Label glyphFeedback;

var privatewrite ROTT_UI_Scene_Combat_Encounter someScene;

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
  
  // Combat unit displayers
  for (i = 0; i < 3; i++) {
    // Enemy displayers
    enemyDisplayers[i] = new class'ROTT_UI_Displayer_Combat_Enemy';
    componentList.addItem(enemyDisplayers[i]);
    enemyDisplayers[i].initializeComponent();
    enemyDisplayers[i].updatePosition(229 + (i*385), 105);
    enemyDisplayers[i].linkReferences();
  }
  
  // Combat unit displayers
  heroDisplayers = ROTT_UI_Displayer_Combat_Heroes(
    findComp("Displayer_Combat_Heroes")
  );
  
  glyphFeedback = findLabel("Glyph_Feedback_Label");
  
}

/*=============================================================================
 * cacheSkills()
 *
 * 
 *===========================================================================*/
public function cacheSkills() {
  findSprite("Skill_Cacher").addFlipbookEffect(1, 0.001);
}

/*============================================================================= 
 * onPushPageEvent()
 *
 * This event is called every time the page is pushed.
 *===========================================================================*/
event onPushPageEvent() {
  
}

/*============================================================================= 
 * onPopPageEvent()
 *
 * 
 *===========================================================================*/
event onPopPageEvent() {
  scriptTrace();
  redLog("Error: I should never pop, I should never lock, and i should never drop it");
}

/*============================================================================= 
 * onSceneActivation()
 *
 * This event is called every time the parent scene is activated
 *===========================================================================*/
public function onSceneActivation() {
  local int i;
  
  glyphFeedback.setText("");
  
  // Hide all enemy displayers before assigning them to enemies
  for (i = 0; i < 3; i++) {
    enemyDisplayers[i].attachDisplayer(none);
  }
  
  // Attach each hero display
  for (i = 0; i < 3; i++) {
    heroDisplayers.getDisplay(i).attachDisplayer(
      gameInfo.getActiveParty().getHero(i)
    );
    heroDisplayers.getDisplay(i).showDetail(
      gameInfo.optionsCookie.showCombatDetail
    );
  }
}

/*============================================================================= 
 * onSceneDeactivation()
 *
 * This event is called every time the parent scene is deactivated
 *===========================================================================*/
public function onSceneDeactivation() {
  
}

/*============================================================================= 
 * showCombatNotification()
 *
 * Shows a message in the center of the enemy encounter display area
 *===========================================================================*/
public function showCombatNotification(string message) {
  local UI_Label notificationLabel;
  notificationLabel = makeLabel(message);
  notificationLabel.updatePosition(
    ,
    ,
    ,
    580
  );
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
  name Key, 
  EInputEvent Event, 
  float AmountDepressed = 1.f, 
  bool bGamepad = false
) 
{
  return true;
}

public function onNavigateLeft();
public function onNavigateRight();

/*=============================================================================
 * elapseTimers()
 *
 * Ticks every frame. 
 *===========================================================================*/
public function elapseTimers(float deltaTime) {
  super.elapseTimers(deltaTime);
  
  if (someScene.bPaused) return;
  
  // Pass elapsed time to combat units
  gameInfo.playerProfile.getActiveParty().elapseTime(deltaTime * gameInfo.gameSpeed);
  if (gameInfo.enemyEncounter != none) {
    gameInfo.enemyEncounter.elapseTime(deltaTime * gameInfo.gameSpeed);
  }
}

/*============================================================================= 
 * deleteComp
 *===========================================================================*/
event deleteComp() {
  local int i;
  
  super.deleteComp();
  
  if (heroDisplayers != none) heroDisplayers.deleteComp();
  
  // Clean combat unit displayers
  for (i = 0; i < 3; i++) {
    enemyDisplayers[i] = none;
  }
}

/*============================================================================= 
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  // Hide cursor
  bPageForcesCursorOff=true
  
  /** ===== Textures ===== **/
  // Background
  begin object class=UI_Texture_Info Name=Combat_Background
    componentTextures.add(Texture2D'GUI.Combat_Background')
  end object
  
  // Menu
  begin object class=UI_Texture_Info Name=Combat_Menu
    componentTextures.add(Texture2D'GUI.Combat_Menu')
  end object
  
  /** ===== UI Components ===== **/
  tag="Page_Combat_Encounter"
  posX=0
  posY=0
  posXEnd=NATIVE_WIDTH
  posYEnd=NATIVE_HEIGHT
  
  // Background
  begin object class=UI_Sprite Name=Combat_Encounter_Background
    tag="Combat_Encounter_Background"
    posX=0
    posY=0
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    images(0)=Combat_Background
  end object
  componentList.add(Combat_Encounter_Background)
  
  // Combat Menu
  begin object class=UI_Sprite Name=Combat_Encounter_Menu
    tag="Combat_Encounter_Menu"
    posX=0
    posY=0
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    images(0)=Combat_Menu
  end object
  componentList.add(Combat_Encounter_Menu)
  
  // Enemy displayers
  /** Enemy UI is dynamically created in init() function above **/
  
  // Hero displayers
  begin object class=ROTT_UI_Displayer_Combat_Heroes Name=Displayer_Combat_Heroes
    tag="Displayer_Combat_Heroes"
    posX=0
    posY=0
  end object
  componentList.add(Displayer_Combat_Heroes)
  
  // Glyph feedback label
  begin object class=UI_Label Name=Glyph_Feedback_Label
    tag="Glyph_Feedback_Label"
    posX=405
    posY=551
    posXEnd=679
    posYEnd=617
    AlignX=CENTER
    AlignY=CENTER
    fontStyle=DEFAULT_SMALL_RED
    labelText="Health+ (#TOTAL)"
  end object
  componentList.add(Glyph_Feedback_Label)
  
  
  // Combat animation cache
  begin object class=UI_Texture_Info Name=SkillAnim_AstralFire_F1
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_AstralFire_F1')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_AstralFire_F2
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_AstralFire_F2')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_AstralFire_F3
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_AstralFire_F3')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_AstralFire_F4
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_AstralFire_F4')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_AstralFire_F5
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_AstralFire_F5')
  end object
  
  begin object class=UI_Texture_Info Name=SkillAnim_Attack_A1
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Attack_A1')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Attack_A2
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Attack_A2')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Attack_A3
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Attack_A3')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Attack_A4
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Attack_A4')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Attack_blue_f1
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Attack_blue_f1')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Attack_blue_f2
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Attack_blue_f2')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Attack_blue_f3
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Attack_blue_f3')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Attack_blue_f4
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Attack_blue_f4')
  end object
  
  
  begin object class=UI_Texture_Info Name=SkillAnim_Avalanche_F1
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Avalanche_F1')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Avalanche_F2
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Avalanche_F2')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Avalanche_F3
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Avalanche_F3')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Avalanche_F4
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Avalanche_F4')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Avalanche_F5
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Avalanche_F5')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Avalanche_F6
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Avalanche_F6')
  end object
  
  begin object class=UI_Texture_Info Name=SkillAnim_Debuff_Blue_F1
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Debuff_Blue_F1')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Debuff_Blue_F2
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Debuff_Blue_F2')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Debuff_Blue_F3
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Debuff_Blue_F3')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Debuff_Blue_F4
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Debuff_Blue_F4')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Debuff_Blue_F5
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Debuff_Blue_F5')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Debuff_Blue_F6
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Debuff_Blue_F6')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Debuff_Blue_F7
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Debuff_Blue_F7')
  end object
  
  begin object class=UI_Texture_Info Name=SkillAnim_Debuff_Purp_F1
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Debuff_Purp_F1')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Debuff_Purp_F2
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Debuff_Purp_F2')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Debuff_Purp_F3
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Debuff_Purp_F3')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Debuff_Purp_F4
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Debuff_Purp_F4')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Debuff_Purp_F5
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Debuff_Purp_F5')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Debuff_Purp_F6
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Debuff_Purp_F6')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Debuff_Purp_F7
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Debuff_Purp_F7')
  end object
  
  begin object class=UI_Texture_Info Name=SkillAnim_Debuff_Red_F1
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Debuff_Red_F1')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Debuff_Red_F2
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Debuff_Red_F2')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Debuff_Red_F3
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Debuff_Red_F3')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Debuff_Red_F4
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Debuff_Red_F4')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Debuff_Red_F5
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Debuff_Red_F5')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Debuff_Red_F6
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Debuff_Red_F6')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Debuff_Red_F7
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Debuff_Red_F7')
  end object
  
  begin object class=UI_Texture_Info Name=SkillAnim_Debuff_Yellow_F1
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Debuff_Yellow_F1')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Debuff_Yellow_F2
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Debuff_Yellow_F2')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Debuff_Yellow_F3
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Debuff_Yellow_F3')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Debuff_Yellow_F4
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Debuff_Yellow_F4')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Debuff_Yellow_F5
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Debuff_Yellow_F5')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Debuff_Yellow_F6
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Debuff_Yellow_F6')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Debuff_Yellow_F7
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Debuff_Yellow_F7')
  end object
  
  begin object class=UI_Texture_Info Name=SkillAnim_Demolish_F1
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Demolish_F1')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Demolish_F2
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Demolish_F2')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Demolish_F3
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Demolish_F3')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Demolish_F4
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Demolish_F4')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Demolish_F5
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Demolish_F5')
  end object
  
  begin object class=UI_Texture_Info Name=SkillAnim_EarthQuake_F1
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_EarthQuake_F1')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_EarthQuake_F2
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_EarthQuake_F2')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_EarthQuake_F3
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_EarthQuake_F3')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_EarthQuake_F4
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_EarthQuake_F4')
  end object
  
  begin object class=UI_Texture_Info Name=SkillAnim_Goliath_Stone_Strike_F1
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Goliath_Stone_Strike_F1')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Goliath_Stone_Strike_F2
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Goliath_Stone_Strike_F2')
  end object
  
  begin object class=UI_Texture_Info Name=SkillAnim_Ice_Storm_Intensity_F1
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Ice_Storm_Intensity_F1')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Ice_Storm_Intensity_F2
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Ice_Storm_Intensity_F2')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Ice_Storm_Intensity_F3
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Ice_Storm_Intensity_F3')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Ice_Storm_Intensity_F4
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Ice_Storm_Intensity_F4')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Ice_Storm_Intensity_F5
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Ice_Storm_Intensity_F5')
  end object
  
  begin object class=UI_Texture_Info Name=Skill_Animation_Lightning_Vertical_F1
    componentTextures.add(Texture2D'GUI_Skills.Lightning_Vertical.Skill_Animation_Lightning_Vertical_F1')
  end object
  begin object class=UI_Texture_Info Name=Skill_Animation_Lightning_Vertical_F2
    componentTextures.add(Texture2D'GUI_Skills.Lightning_Vertical.Skill_Animation_Lightning_Vertical_F2')
  end object
  begin object class=UI_Texture_Info Name=Skill_Animation_Lightning_Vertical_F3
    componentTextures.add(Texture2D'GUI_Skills.Lightning_Vertical.Skill_Animation_Lightning_Vertical_F3')
  end object
  begin object class=UI_Texture_Info Name=Skill_Animation_Lightning_Vertical_F4
    componentTextures.add(Texture2D'GUI_Skills.Lightning_Vertical.Skill_Animation_Lightning_Vertical_F4')
  end object
  begin object class=UI_Texture_Info Name=Skill_Animation_Lightning_Vertical_F5
    componentTextures.add(Texture2D'GUI_Skills.Lightning_Vertical.Skill_Animation_Lightning_Vertical_F5')
  end object
  
  begin object class=UI_Texture_Info Name=Skill_Animation_Lightning_Diagonal_F1
    componentTextures.add(Texture2D'GUI_Skills.Lightning_Diagonal.Skill_Animation_Lightning_Diagonal_F1')
  end object
  begin object class=UI_Texture_Info Name=Skill_Animation_Lightning_Diagonal_F2
    componentTextures.add(Texture2D'GUI_Skills.Lightning_Diagonal.Skill_Animation_Lightning_Diagonal_F2')
  end object
  begin object class=UI_Texture_Info Name=Skill_Animation_Lightning_Diagonal_F3
    componentTextures.add(Texture2D'GUI_Skills.Lightning_Diagonal.Skill_Animation_Lightning_Diagonal_F3')
  end object
  begin object class=UI_Texture_Info Name=Skill_Animation_Lightning_Diagonal_F4
    componentTextures.add(Texture2D'GUI_Skills.Lightning_Diagonal.Skill_Animation_Lightning_Diagonal_F4')
  end object
  begin object class=UI_Texture_Info Name=Skill_Animation_Lightning_Diagonal_F5
    componentTextures.add(Texture2D'GUI_Skills.Lightning_Diagonal.Skill_Animation_Lightning_Diagonal_F5')
  end object
  
  begin object class=UI_Texture_Info Name=Skill_Animation_Spectral_Surge_F1
    componentTextures.add(Texture2D'GUI_Skills.Skill_Animation_Spectral_Surge_F1')
  end object
  begin object class=UI_Texture_Info Name=Skill_Animation_Spectral_Surge_F2
    componentTextures.add(Texture2D'GUI_Skills.Skill_Animation_Spectral_Surge_F2')
  end object
  begin object class=UI_Texture_Info Name=Skill_Animation_Spectral_Surge_F3
    componentTextures.add(Texture2D'GUI_Skills.Skill_Animation_Spectral_Surge_F3')
  end object
  begin object class=UI_Texture_Info Name=Skill_Animation_Spectral_Surge_F4
    componentTextures.add(Texture2D'GUI_Skills.Skill_Animation_Spectral_Surge_F4')
  end object
  
  begin object class=UI_Texture_Info Name=SkillAnim_SolarShock_F1
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_SolarShock_F1')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_SolarShock_F2
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_SolarShock_F2')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_SolarShock_F3
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_SolarShock_F3')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_SolarShock_F4
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_SolarShock_F4')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_SolarShock_F5
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_SolarShock_F5')
  end object
  
  begin object class=UI_Texture_Info Name=SkillAnim_SpiritNova_F1
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_SpiritNova_F1')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_SpiritNova_F2
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_SpiritNova_F2')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_SpiritNova_F3
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_SpiritNova_F3')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_SpiritNova_F4
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_SpiritNova_F4')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_SpiritNova_F5
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_SpiritNova_F5')
  end object
  
  begin object class=UI_Texture_Info Name=SkillAnim_Starbolt_F1
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Starbolt_F1')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Starbolt_F2
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Starbolt_F2')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Starbolt_F3
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Starbolt_F3')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Starbolt_F4
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Starbolt_F4')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Starbolt_F5
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Starbolt_F5')
  end object
  
  begin object class=UI_Texture_Info Name=SkillAnim_Thrasher_F1
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Thrasher_F1')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Thrasher_F2
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Thrasher_F2')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Thrasher_F3
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Thrasher_F3')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Thrasher_F4
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Thrasher_F4')
  end object
  
  begin object class=UI_Texture_Info Name=SkillAnim_Titan_Blizzard_f1
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Titan_Blizzard_f1')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Titan_Blizzard_f2
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Titan_Blizzard_f2')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Titan_Blizzard_f3
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Titan_Blizzard_f3')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Titan_Blizzard_f4
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Titan_Blizzard_f4')
  end object
  
  begin object class=UI_Texture_Info Name=Skill_Animation_Black_Hole_1
    componentTextures.add(Texture2D'GUI_Skills.Black_Hole.Skill_Animation_Black_Hole_1')
  end object
  begin object class=UI_Texture_Info Name=Skill_Animation_Black_Hole_2
    componentTextures.add(Texture2D'GUI_Skills.Black_Hole.Skill_Animation_Black_Hole_2')
  end object
  begin object class=UI_Texture_Info Name=Skill_Animation_Black_Hole_3
    componentTextures.add(Texture2D'GUI_Skills.Black_Hole.Skill_Animation_Black_Hole_3')
  end object
  begin object class=UI_Texture_Info Name=Skill_Animation_Black_Hole_4
    componentTextures.add(Texture2D'GUI_Skills.Black_Hole.Skill_Animation_Black_Hole_4')
  end object
  begin object class=UI_Texture_Info Name=Skill_Animation_Black_Hole_5
    componentTextures.add(Texture2D'GUI_Skills.Black_Hole.Skill_Animation_Black_Hole_5')
  end object
  begin object class=UI_Texture_Info Name=Skill_Animation_Black_Hole_6
    componentTextures.add(Texture2D'GUI_Skills.Black_Hole.Skill_Animation_Black_Hole_6')
  end object
  begin object class=UI_Texture_Info Name=Skill_Animation_Black_Hole_7
    componentTextures.add(Texture2D'GUI_Skills.Black_Hole.Skill_Animation_Black_Hole_7')
  end object
  begin object class=UI_Texture_Info Name=Skill_Animation_Black_Hole_8
    componentTextures.add(Texture2D'GUI_Skills.Black_Hole.Skill_Animation_Black_Hole_8')
  end object
  begin object class=UI_Texture_Info Name=Skill_Animation_Black_Hole_9
    componentTextures.add(Texture2D'GUI_Skills.Black_Hole.Skill_Animation_Black_Hole_9')
  end object
  begin object class=UI_Texture_Info Name=Skill_Animation_Black_Hole_10
    componentTextures.add(Texture2D'GUI_Skills.Black_Hole.Skill_Animation_Black_Hole_10')
  end object
  
  ///begin object class=UI_Texture_Info Name=SkillAnim_triple_strike_Y_1
  ///  componentTextures.add(Texture2D'GUI_Skills.SkillAnim_triple_strike_Y_1')
  ///end object
  ///begin object class=UI_Texture_Info Name=SkillAnim_triple_strike_Y_2
  ///  componentTextures.add(Texture2D'GUI_Skills.SkillAnim_triple_strike_Y_2')
  ///end object
  ///begin object class=UI_Texture_Info Name=SkillAnim_triple_strike_Y_3
  ///  componentTextures.add(Texture2D'GUI_Skills.SkillAnim_triple_strike_Y_3')
  ///end object
  ///begin object class=UI_Texture_Info Name=SkillAnim_triple_strike_Y_4
  ///  componentTextures.add(Texture2D'GUI_Skills.SkillAnim_triple_strike_Y_4')
  ///end object
  ///begin object class=UI_Texture_Info Name=SkillAnim_triple_strike_Y_5
  ///  componentTextures.add(Texture2D'GUI_Skills.SkillAnim_triple_strike_Y_5')
  ///end object
  ///begin object class=UI_Texture_Info Name=SkillAnim_triple_strike_Y_6
  ///  componentTextures.add(Texture2D'GUI_Skills.SkillAnim_triple_strike_Y_6')
  ///end object
  ///begin object class=UI_Texture_Info Name=SkillAnim_triple_strike_Y_7
  ///  componentTextures.add(Texture2D'GUI_Skills.SkillAnim_triple_strike_Y_7')
  ///end object
  ///begin object class=UI_Texture_Info Name=SkillAnim_triple_strike_Y_8
  ///  componentTextures.add(Texture2D'GUI_Skills.SkillAnim_triple_strike_Y_8')
  ///end object
  ///begin object class=UI_Texture_Info Name=SkillAnim_triple_strike_Y_9
  ///  componentTextures.add(Texture2D'GUI_Skills.SkillAnim_triple_strike_Y_9')
  ///end object
  ///begin object class=UI_Texture_Info Name=SkillAnim_triple_strike_Y_10
  ///  componentTextures.add(Texture2D'GUI_Skills.SkillAnim_triple_strike_Y_10')
  ///end object
  ///
  begin object class=UI_Texture_Info Name=SkillAnim_Valkyrie_Valor_Strike_F1
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Valkyrie_Valor_Strike_F1')
  end object
  begin object class=UI_Texture_Info Name=SkillAnim_Valkyrie_Valor_Strike_F2
    componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Valkyrie_Valor_Strike_F2')
  end object
  
  
  // Skill Cacher
  begin object class=UI_Sprite Name=Skill_Cacher
    tag="Skill_Cacher"
    bEnabled=true
    posx=-9000
    posy=0
    images(0)=SkillAnim_AstralFire_F1
    images(1)=SkillAnim_AstralFire_F2
    images(2)=SkillAnim_AstralFire_F3
    images(3)=SkillAnim_AstralFire_F4
    images(4)=SkillAnim_AstralFire_F5
    images(5)=SkillAnim_Attack_A1
    images(6)=SkillAnim_Attack_A2
    images(7)=SkillAnim_Attack_A3
    images(8)=SkillAnim_Attack_A4
    images(9)=SkillAnim_Attack_blue_f1
    images(10)=SkillAnim_Attack_blue_f2
    images(11)=SkillAnim_Attack_blue_f3
    images(12)=SkillAnim_Attack_blue_f4
    images(13)=SkillAnim_Avalanche_F1
    images(14)=SkillAnim_Avalanche_F2
    images(15)=SkillAnim_Avalanche_F3
    images(16)=SkillAnim_Avalanche_F4
    images(17)=SkillAnim_Avalanche_F5
    images(18)=SkillAnim_Avalanche_F6
    images(19)=SkillAnim_Debuff_Blue_F1
    images(20)=SkillAnim_Debuff_Blue_F2
    images(21)=SkillAnim_Debuff_Blue_F3
    images(22)=SkillAnim_Debuff_Blue_F4
    images(23)=SkillAnim_Debuff_Blue_F5
    images(24)=SkillAnim_Debuff_Blue_F6
    images(25)=SkillAnim_Debuff_Blue_F7
    images(26)=SkillAnim_Debuff_Purp_F1
    images(27)=SkillAnim_Debuff_Purp_F2
    images(28)=SkillAnim_Debuff_Purp_F3
    images(29)=SkillAnim_Debuff_Purp_F4
    images(30)=SkillAnim_Debuff_Purp_F5
    images(31)=SkillAnim_Debuff_Purp_F6
    images(32)=SkillAnim_Debuff_Purp_F7
    images(33)=SkillAnim_Debuff_Red_F1
    images(34)=SkillAnim_Debuff_Red_F2
    images(35)=SkillAnim_Debuff_Red_F3
    images(36)=SkillAnim_Debuff_Red_F4
    images(37)=SkillAnim_Debuff_Red_F5
    images(38)=SkillAnim_Debuff_Red_F6
    images(39)=SkillAnim_Debuff_Red_F7
    images(40)=SkillAnim_Debuff_Yellow_F1
    images(41)=SkillAnim_Debuff_Yellow_F2
    images(42)=SkillAnim_Debuff_Yellow_F3
    images(43)=SkillAnim_Debuff_Yellow_F4
    images(44)=SkillAnim_Debuff_Yellow_F5
    images(45)=SkillAnim_Debuff_Yellow_F6
    images(46)=SkillAnim_Debuff_Yellow_F7
    images(47)=SkillAnim_Demolish_F1
    images(48)=SkillAnim_Demolish_F2
    images(49)=SkillAnim_Demolish_F3
    images(50)=SkillAnim_Demolish_F4
    images(51)=SkillAnim_Demolish_F5
    images(52)=SkillAnim_EarthQuake_F1
    images(53)=SkillAnim_EarthQuake_F2
    images(54)=SkillAnim_EarthQuake_F3
    images(55)=SkillAnim_EarthQuake_F4
    images(56)=SkillAnim_Goliath_Stone_Strike_F1
    images(57)=SkillAnim_Goliath_Stone_Strike_F2
    images(58)=SkillAnim_Ice_Storm_Intensity_F1
    images(59)=SkillAnim_Ice_Storm_Intensity_F2
    images(60)=SkillAnim_Ice_Storm_Intensity_F3
    images(61)=SkillAnim_Ice_Storm_Intensity_F4
    images(62)=SkillAnim_Ice_Storm_Intensity_F5
    images(63)=Skill_Animation_Lightning_Vertical_F1
    images(64)=Skill_Animation_Lightning_Vertical_F2
    images(65)=Skill_Animation_Lightning_Vertical_F3
    images(66)=Skill_Animation_Lightning_Vertical_F4
    images(67)=Skill_Animation_Lightning_Vertical_F5
    images(68)=Skill_Animation_Lightning_Diagonal_F1
    images(69)=Skill_Animation_Lightning_Diagonal_F2
    images(70)=Skill_Animation_Lightning_Diagonal_F3
    images(71)=Skill_Animation_Lightning_Diagonal_F4
    images(72)=Skill_Animation_Lightning_Diagonal_F5
    images(73)=Skill_Animation_Spectral_Surge_F1
    images(74)=Skill_Animation_Spectral_Surge_F2
    images(75)=Skill_Animation_Spectral_Surge_F3
    images(76)=Skill_Animation_Spectral_Surge_F4
    images(77)=SkillAnim_SolarShock_F1
    images(78)=SkillAnim_SolarShock_F2
    images(79)=SkillAnim_SolarShock_F3
    images(80)=SkillAnim_SolarShock_F4
    images(81)=SkillAnim_SolarShock_F5
    images(82)=SkillAnim_SpiritNova_F1
    images(83)=SkillAnim_SpiritNova_F2
    images(84)=SkillAnim_SpiritNova_F3
    images(85)=SkillAnim_SpiritNova_F4
    images(86)=SkillAnim_SpiritNova_F5
    images(87)=SkillAnim_Starbolt_F1
    images(88)=SkillAnim_Starbolt_F2
    images(89)=SkillAnim_Starbolt_F3
    images(90)=SkillAnim_Starbolt_F4
    images(91)=SkillAnim_Starbolt_F5
    images(92)=SkillAnim_Thrasher_F1
    images(93)=SkillAnim_Thrasher_F2
    images(94)=SkillAnim_Thrasher_F3
    images(95)=SkillAnim_Thrasher_F4
    images(96)=SkillAnim_Titan_Blizzard_f1
    images(97)=SkillAnim_Titan_Blizzard_f2
    images(98)=SkillAnim_Titan_Blizzard_f3
    images(99)=SkillAnim_Titan_Blizzard_f4 
    images(100)=Skill_Animation_Black_Hole_1
    images(101)=Skill_Animation_Black_Hole_2
    images(102)=Skill_Animation_Black_Hole_3
    images(103)=Skill_Animation_Black_Hole_4
    images(104)=Skill_Animation_Black_Hole_5
    images(105)=Skill_Animation_Black_Hole_6
    images(106)=Skill_Animation_Black_Hole_7
    images(107)=Skill_Animation_Black_Hole_8
    images(108)=Skill_Animation_Black_Hole_9
    images(109)=Skill_Animation_Black_Hole_10
    
  /// begin object class=UI_Texture_Info Name=SkillAnim_triple_strike_Y_1
  ///   componentTextures.add(Texture2D'GUI_Skills.SkillAnim_triple_strike_Y_1')
  /// end object
  /// begin object class=UI_Texture_Info Name=SkillAnim_triple_strike_Y_2
  ///   componentTextures.add(Texture2D'GUI_Skills.SkillAnim_triple_strike_Y_2')
  /// end object
  /// begin object class=UI_Texture_Info Name=SkillAnim_triple_strike_Y_3
  ///   componentTextures.add(Texture2D'GUI_Skills.SkillAnim_triple_strike_Y_3')
  /// end object
  /// begin object class=UI_Texture_Info Name=SkillAnim_triple_strike_Y_4
  ///   componentTextures.add(Texture2D'GUI_Skills.SkillAnim_triple_strike_Y_4')
  /// end object
  /// begin object class=UI_Texture_Info Name=SkillAnim_triple_strike_Y_5
  ///   componentTextures.add(Texture2D'GUI_Skills.SkillAnim_triple_strike_Y_5')
  /// end object
  /// begin object class=UI_Texture_Info Name=SkillAnim_triple_strike_Y_6
  ///   componentTextures.add(Texture2D'GUI_Skills.SkillAnim_triple_strike_Y_6')
  /// end object
  /// begin object class=UI_Texture_Info Name=SkillAnim_triple_strike_Y_7
  ///   componentTextures.add(Texture2D'GUI_Skills.SkillAnim_triple_strike_Y_7')
  /// end object
  /// begin object class=UI_Texture_Info Name=SkillAnim_triple_strike_Y_8
  ///   componentTextures.add(Texture2D'GUI_Skills.SkillAnim_triple_strike_Y_8')
  /// end object
  /// begin object class=UI_Texture_Info Name=SkillAnim_triple_strike_Y_9
  ///   componentTextures.add(Texture2D'GUI_Skills.SkillAnim_triple_strike_Y_9')
  /// end object
  /// begin object class=UI_Texture_Info Name=SkillAnim_triple_strike_Y_10
  ///   componentTextures.add(Texture2D'GUI_Skills.SkillAnim_triple_strike_Y_10')
  /// end object
  /// 
  /// begin object class=UI_Texture_Info Name=SkillAnim_Valkyrie_Valor_Strike_F1
  ///   componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Valkyrie_Valor_Strike_F1')
  /// end object
  /// begin object class=UI_Texture_Info Name=SkillAnim_Valkyrie_Valor_Strike_F1
  ///   componentTextures.add(Texture2D'GUI_Skills.SkillAnim_Valkyrie_Valor_Strike_F2')
  /// end object
  
  
    activeEffects.add((effectType=EFFECT_FLIPBOOK, lifeTime=3, elapsedTime=0, intervalTime=0.01, min=0, max=255))
  end object
  componentList.add(Skill_Cacher)
  
  
  
}




































