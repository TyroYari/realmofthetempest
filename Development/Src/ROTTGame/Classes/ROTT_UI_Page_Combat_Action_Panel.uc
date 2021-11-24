/*============================================================================= 
 * ROTT_UI_Page_Combat_Action_Panel
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This class displays an enemy encounter, and handles player 
 * input for combat interactions.
 *===========================================================================*/
 
class ROTT_UI_Page_Combat_Action_Panel extends ROTT_UI_Page;

/** ============================== **/

enum ControlState {
  IGNORE_INPUT,
  ACCEPT_INPUT
};

var private ControlState menuControl;

/** ============================== **/

enum ActionMenuOptions {
  ACTION_ATTACK,
  ACTION_SKILL_PRIMARY,
  ACTION_DEFEND,
  ACTION_SKILL_SECONDARY
};

var private ActionMenuOptions actionSelection;

/** ============================== **/

// Internal References
var private UI_Sprite buttons[4];
var private UI_Sprite icons[4];

var private UI_Selector actionSelector;

// Delay before selection display (and control)
var private ROTT_Timer menuDelay;    
var public ROTT_Timer turboDelay;    

// Parent scene
var private ROTT_UI_Scene_Combat_Encounter someScene;

/*============================================================================= 
 * Initialize Component
 *
 * Description: This event is called as the UI is loaded.
 *              Our initial scene is drawn here.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  // Draw each component
  super.initializeComponent(newTag);
  
  // Parent scene reference
  someScene = ROTT_UI_Scene_Combat_Encounter(outer);
  
  // UI references
  buttons[ACTION_ATTACK] = findSprite("Action_Attack_Button");
  buttons[ACTION_DEFEND] = findSprite("Action_Defend_Button");
  buttons[ACTION_SKILL_PRIMARY] = findSprite("Action_Skill_Button_Primary");
  buttons[ACTION_SKILL_SECONDARY] = findSprite("Action_Skill_Button_Secondary");
  
  icons[ACTION_ATTACK] = findSprite("Action_Attack_Button_Text");
  icons[ACTION_DEFEND] = findSprite("Action_Defend_Button_Text");
  icons[ACTION_SKILL_PRIMARY] = findSprite("Action_Skill_Icon_Primary");
  icons[ACTION_SKILL_SECONDARY] = findSprite("Action_Skill_Icon_Secondary");
  
  actionSelector = UI_Selector(findComp("Action_Selector"));
}

/*============================================================================= 
 * onPushPageEvent()
 *
 * This event is called every time the page is pushed.
 *===========================================================================*/
event onPushPageEvent() {
  local ROTT_Combat_Hero hero;
  local int i;
  
  // Ignore input until timer is ready
  menuControl = IGNORE_INPUT;
  hideSelectors();
  
  // Get acting hero
  hero = gameInfo.getActiveParty().readyUnits[0];
  
  // Get heroes last selection
  getActionFromMemory(hero.actionType);
  
  // Initialize menu graphics
  hero.primaryScript.skillIcon.initializeComponent();
  icons[ACTION_SKILL_PRIMARY].copySprite(hero.primaryScript.skillIcon, 0);
  icons[ACTION_SKILL_SECONDARY].copySprite(hero.secondaryScript.skillIcon, 0);
  
  for (i = 0; i < 4; i++) {
    buttons[i].setDrawIndex(1);
  }
  
  // Delay selection graphic
  menuDelay = gameInfo.spawn(class'ROTT_Timer');
  menuDelay.makeTimer(0.35, LOOP_OFF, allowInput); /// was 0.4
}

/*============================================================================= 
 * onPopPageEvent()
 *
 * This event is called when the page is removed
 *===========================================================================*/
event onPopPageEvent() {
  if (menuDelay != none) menuDelay.destroy();
}

/*=============================================================================
 * onUnfocusMenu()
 *
 * Called when the menu loses focus, but is not popped from the page stack.
 * Disable controls and update graphics accordingly.
 *===========================================================================*/
event onUnfocusMenu() {
  
}

/*=============================================================================
 * onFocusMenu()
 *
 * Called when a menu is given focus.  Assign controls, and enable graphics.
 *===========================================================================*/
event onFocusMenu() {
  local ROTT_Combat_Hero hero;
  
  resetIconColors();
  
  // Get acting hero
  hero = gameInfo.getActiveParty().readyUnits[0];
  
  // Get heroes last selection
  getActionFromMemory(hero.actionType);
  
  // Draw selector immediately if backing out from targeting
  if (menuControl == ACCEPT_INPUT) {
    showSelector();
  }
}

/*============================================================================= 
 * getActionFromMemory()
 *
 * Called to initialize the action panel selection.
 *===========================================================================*/
public function getActionFromMemory(CombActEnum action) {
  // Get heroes last selection
  if (gameInfo.optionsCookie.bTickActionMemory) {
    // Fetch from hero memory
    switch (action) {
      case ATTACK: actionSelection = ACTION_ATTACK; break; 
      case DEFEND: actionSelection = ACTION_DEFEND; break; 
      case PRIMARY_SKILL: actionSelection = ACTION_SKILL_PRIMARY; break; 
      case SECONDARY_SKILL: actionSelection = ACTION_SKILL_SECONDARY; break; 
    }
  } else {
    // No memory, default attack
    actionSelection = ACTION_ATTACK;
  }
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
 * readyHeroHasDied()
 *
 * Update the action panel since the hero using it has died
 *
 * Precondition: dead unit has already been dequeued
 *===========================================================================*/
public function readyHeroHasDied() {
  someScene.pushNextActionPanel();
}

/*=============================================================================
 * Controls
 *
 * ControllerId     the controller that generated this input key event
 * inputName        the name of the key which an event occured for
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
  switch (inputName) {
    case 'LeftMouseButton': 
    case 'XboxTypeS_A': 
      // Button graphics
      if (menuControl == ACCEPT_INPUT) {
        if (Event == IE_Pressed)  buttonPress(true);
        if (Event == IE_Released) buttonPress(false);
      }
      break;
  }
  
  return super.onInputKey(ControllerId, inputName, Event, AmountDepressed, bGamepad);
}

/*=============================================================================
 * Button graphics
 *===========================================================================*/
private function buttonPress(bool bDown) {
  local int i;
  
  // Initialize button graphics
  for (i = 0; i < 4; i++) {
    buttons[i].setDrawIndex(1);
  }
  
  // Update button graphic
  buttons[actionSelection].setDrawIndex((bDown) ? 2:1);
  
  // Offset button icons
  icons[actionSelection].updatePosition(
    icons[actionSelection].homePos.x + (bDown) ? 1:0, 
    icons[actionSelection].homePos.y + (bDown) ? 1:0, 
    , 
  ); 
}

/*=============================================================================
 * D-Pad controls
 *===========================================================================*/
public function onNavigateLeft() {
  if (menuControl == IGNORE_INPUT) return;
  
  switch (actionSelection) {
    case ACTION_SKILL_PRIMARY:   actionSelection = ACTION_ATTACK; break;
    case ACTION_SKILL_SECONDARY: actionSelection = ACTION_DEFEND; break;
    default:
      return;
  }

  updateSelector();
}

public function onNavigateRight() {
  if (menuControl == IGNORE_INPUT) return;
  
  switch (actionSelection) {
    case ACTION_ATTACK: actionSelection = ACTION_SKILL_PRIMARY; break;
    case ACTION_DEFEND: actionSelection = ACTION_SKILL_SECONDARY; break;
    default:
      return;
  }
  
  updateSelector();
}

public function onNavigateUp() {
  if (menuControl == IGNORE_INPUT) return;
  
  switch (actionSelection) {
    case ACTION_DEFEND: actionSelection = ACTION_ATTACK; break;
    case ACTION_SKILL_SECONDARY: actionSelection = ACTION_SKILL_PRIMARY; break;
    default:
      return;
  }
  
  updateSelector();
}

public function onNavigateDown() {
  if (menuControl == IGNORE_INPUT) return;
  
  switch (actionSelection) {
    case ACTION_ATTACK: actionSelection = ACTION_DEFEND; break;
    case ACTION_SKILL_PRIMARY: actionSelection = ACTION_SKILL_SECONDARY; break;
    default:
      return;
  }
  
  updateSelector();
}

/*============================================================================= 
 * Button Inputs
 *===========================================================================*/
protected function navigationRoutineA() {
  local CombActEnum combAction;
  local ROTT_Combat_Hero hero;
  
  // Ignore input
  if (menuControl == IGNORE_INPUT) return;
  if (someScene.bPaused) return;
  
  // Remove auto selection timer
  if (turboDelay != none) turboDelay.destroy();
  
  // Get hero
  hero = gameInfo.getActiveParty().readyUnits[0];
  
  // Check validity of targets
  if (gameInfo.enemyEncounter.getMobSize() == 0) return;
  
  // Get script from action selection
  switch (actionSelection) {
    case ACTION_ATTACK: combAction = ATTACK; break;
    case ACTION_DEFEND: combAction = DEFEND; break;
    case ACTION_SKILL_PRIMARY: combAction = PRIMARY_SKILL; break;
    case ACTION_SKILL_SECONDARY: combAction = SECONDARY_SKILL; break;
  }
  
  // Set script for next action
  hero.selectAction(combAction);
  
  // Check for mana cost & glyph requirement
  if (!hero.glyphSufficient()) {
    sfxBox.playSFX(SFX_MENU_INSUFFICIENT); 
    
    makeActionLabel("Missing Glyph");
    return;
  }
  if (!hero.manaSufficient()) {
    sfxBox.playSFX(SFX_MENU_INSUFFICIENT); 
    
    makeActionLabel("Insufficient Mana");
    return;
  }
  
  // Graphics changes
  icons[actionSelection].drawColor.r = 255;
  icons[actionSelection].drawColor.g = 235;
  icons[actionSelection].drawColor.b = 203;
  
  hideSelectors();
  
  // Push target selection mode
  someScene.pushPage(someScene.targetingPage);
  someScene.targetingPage.setTargetMode(hero.getTargetingStyle());
}

/*============================================================================= 
 * hideSelectors()
 * 
 * Hides all selectors from the action panel menu
 *===========================================================================*/
private function hideSelectors() {
  actionSelector.clearSelection();
}

/*============================================================================= 
 * resetIconColors()
 * 
 * Resets all icons to white color highlighting
 *===========================================================================*/
private function resetIconColors() {
  local int i;
  
  for (i = 0; i < 4; i++) {
    // Graphics changes
    icons[i].resetColor();
  }
}

/*============================================================================= 
 * allowInput()
 * 
 * Delegated to a timer to delay input after page push event
 *===========================================================================*/
private function allowInput() {
  // Allow input
  menuControl = ACCEPT_INPUT;
  
  // Show selector
  showSelector();
  
  // Remove timer
  menuDelay.destroy();
  
  
  // Start turbo auto selection timer
  turboDelay = gameInfo.spawn(class'ROTT_Timer');
  turboDelay.makeTimer(0.4, LOOP_OFF, autoSelect);
}

/*============================================================================= 
 * showSelector()
 * 
 * Displays the action selector.
 *===========================================================================*/
public function showSelector() {
  local bool bToolTip;
  
  actionSelector.setEnabled(true);
  actionSelector.setActive(true);
  actionSelector.forceSelection(actionSelection);
  
  updateSelector();
  
  // Show tool tip
  bToolTip = !gameInfo.playerProfile.bHasUsedSkill;
  findLabel("Skill_Tip_Label_Shadow").setEnabled(bToolTip);
  findLabel("Skill_Tip_Label").setEnabled(bToolTip);
  findLabel("Skill_Tip_Label_Shadow_2").setEnabled(bToolTip);
  findLabel("Skill_Tip_Label_2").setEnabled(bToolTip);
  findSprite("Tool_Tip_Sprite").setEnabled(bToolTip);
}

/*============================================================================= 
 * updateSelector()
 * 
 * Sets the sprite for the selector
 *===========================================================================*/
public function updateSelector() {
  switch (actionSelection) {
    case ACTION_ATTACK: 
    case ACTION_DEFEND: 
      actionSelector.setDrawIndex(0);
      break;
    case ACTION_SKILL_PRIMARY:
    case ACTION_SKILL_SECONDARY: 
      actionSelector.setDrawIndex(1);
      break;
  }
}

/*============================================================================= 
 * autoSelect()
 * 
 * Delegated to a timer to automatically select an action if the turbo button
 * is active
 *===========================================================================*/
private function autoSelect() {
  // Auto select if using turbo
  if (gameInfo.gameSpeed != 1.0 && someScene.bPaused == false) {
    navigationRoutineA();
  }
  
  // Remove timer
  turboDelay.destroy();
}

/*============================================================================= 
 * makeActionLabel()
 *
 * Creates a label on the screen. [should encapsulate this more into the label]
 *===========================================================================*/
private function makeActionLabel(string text) {
  local UI_Label_Combat label;
  
  // Create label
  label = new(self) class'UI_Label_Combat';
  someScene.combatPage.componentList.addItem(label);
  label.initializeComponent();
  label.startEvent();
  label.setText(text);
  
  // Set position of message
  label.updatePosition(0, 495, 380, 575);
  
  // Set display info
  label.setStyle(
    FONT_MEDIUM,
    COLOR_TAN,
    ANIMATE_SLOW_BOUNCE
  );
  
  // Sets home position data
  label.postInit();
  
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
  // Buttons
  begin object class=UI_Texture_Info Name=Combat_Action_Button_Wide
    componentTextures.add(Texture2D'GUI.Combat_Action_Button_Wide')
  end object
  begin object class=UI_Texture_Info Name=Combat_Action_Button_Wide_Down
    componentTextures.add(Texture2D'GUI.Combat_Action_Button_Wide_Down')
  end object
  
  begin object class=UI_Texture_Info Name=Combat_Action_Skill
    componentTextures.add(Texture2D'GUI.Combat_Action_Skill')
  end object
  begin object class=UI_Texture_Info Name=Combat_Action_Skill_Down
    componentTextures.add(Texture2D'GUI.Combat_Action_Skill_Down')
  end object
  
  // Button Text (Icons)
  begin object class=UI_Texture_Info Name=Combat_Action_Attack_Text
    componentTextures.add(Texture2D'GUI.Combat_Action_Attack_Text')
  end object
  begin object class=UI_Texture_Info Name=Combat_Action_Defend_Text
    componentTextures.add(Texture2D'GUI.Combat_Action_Defend_Text')
  end object
  
  // Attack Button
  begin object class=UI_Sprite Name=Action_Attack_Button
    tag="Action_Attack_Button"
    posX=51
    posY=621
    images(0)=Combat_Action_Button_Wide
    images(1)=Combat_Action_Button_Wide
    images(2)=Combat_Action_Button_Wide_Down
  end object
  componentList.add(Action_Attack_Button)
  
  // Defend Button
  begin object class=UI_Sprite Name=Action_Defend_Button
    tag="Action_Defend_Button"
    posX=51
    posY=738
    images(0)=Combat_Action_Button_Wide
    images(1)=Combat_Action_Button_Wide
    images(2)=Combat_Action_Button_Wide_Down
  end object
  componentList.add(Action_Defend_Button)
  
  // Attack text
  begin object class=UI_Sprite Name=Action_Attack_Button_Text
    tag="Action_Attack_Button_Text"
    posX=51
    posY=621
    images(0)=Combat_Action_Attack_Text
  end object
  componentList.add(Action_Attack_Button_Text)
  
  // Defend text
  begin object class=UI_Sprite Name=Action_Defend_Button_Text
    tag="Action_Defend_Button_Text"
    posX=51
    posY=738
    images(0)=Combat_Action_Defend_Text
  end object
  componentList.add(Action_Defend_Button_Text)
  
  // Skill Button - Primary
  begin object class=UI_Sprite Name=Action_Skill_Button_Primary
    tag="Action_Skill_Button_Primary"
    posX=240
    posY=621
    images(0)=Combat_Action_Skill
    images(1)=Combat_Action_Skill
    images(2)=Combat_Action_Skill_Down
  end object
  componentList.add(Action_Skill_Button_Primary)
  
  // Skill Button - Secondary
  begin object class=UI_Sprite Name=Action_Skill_Button_Secondary
    tag="Action_Skill_Button_Secondary"
    posX=240
    posY=738
    images(0)=Combat_Action_Skill
    images(1)=Combat_Action_Skill
    images(2)=Combat_Action_Skill_Down
  end object
  componentList.add(Action_Skill_Button_Secondary)
  
  // Skill Icon - Primary
  begin object class=UI_Sprite Name=Action_Skill_Icon_Primary
    tag="Action_Skill_Icon_Primary"
    posX=246
    posY=627
    images(0)=Combat_Action_Skill
  end object
  componentList.add(Action_Skill_Icon_Primary)
  
  // Skill Icon - Secondary
  begin object class=UI_Sprite Name=Action_Skill_Icon_Secondary
    tag="Action_Skill_Icon_Secondary"
    posX=246
    posY=744
    images(0)=Combat_Action_Skill
  end object
  componentList.add(Action_Skill_Icon_Secondary)
  
  // Notification for skill tip
  begin object class=UI_Label Name=Skill_Tip_Label_Shadow
    tag="Skill_Tip_Label_Shadow"
    bEnabled=false
    posX=216
    posY=457
    posXEnd=384
    posYEnd=750
    padding=(top=1, left=13, right=11, bottom=7)
    fontStyle=DEFAULT_LARGE_ORANGE
    labelText="Select a"
    activeEffects.add((effectType=EFFECT_ALPHA_CYCLE, lifeTime=-1, elapsedTime=0, intervalTime=0.8, min=220, max=255))
    alignX=CENTER
    alignY=TOP
  end object
  componentList.add(Skill_Tip_Label_Shadow)
  
  // Notification for skill tip
  begin object class=UI_Label Name=Skill_Tip_Label
    tag="Skill_Tip_Label"
    bEnabled=false
    posX=216
    posY=457
    posXEnd=384
    posYEnd=750
    fontStyle=DEFAULT_LARGE_CYAN
    labelText="Select a"
    activeEffects.add((effectType=EFFECT_ALPHA_CYCLE, lifeTime=-1, elapsedTime=0, intervalTime=0.8, min=200, max=255))
    activeEffects.add((effectType=EFFECT_FLIPBOOK, lifeTime=-1, elapsedTime=0, intervalTime=0.10, min=0, max=255))
    cycleStyles=(DEFAULT_LARGE_GOLD, DEFAULT_LARGE_ORANGE)
    alignX=CENTER
    alignY=TOP
  end object
  componentList.add(Skill_Tip_Label)
  
  // Notification for skill tip
  begin object class=UI_Label Name=Skill_Tip_Label_Shadow_2
    tag="Skill_Tip_Label_Shadow_2"
    bEnabled=false
    posX=216
    posY=497
    posXEnd=384
    posYEnd=790
    padding=(top=1, left=13, right=11, bottom=7)
    fontStyle=DEFAULT_LARGE_ORANGE
    labelText="Skill"
    activeEffects.add((effectType=EFFECT_ALPHA_CYCLE, lifeTime=-1, elapsedTime=0, intervalTime=0.8, min=220, max=255))
    alignX=CENTER
    alignY=TOP
  end object
  componentList.add(Skill_Tip_Label_Shadow_2)
  
  // Notification for skill tip
  begin object class=UI_Label Name=Skill_Tip_Label_2
    tag="Skill_Tip_Label_2"
    bEnabled=false
    posX=216
    posY=497
    posXEnd=384
    posYEnd=790
    fontStyle=DEFAULT_LARGE_CYAN
    labelText="Skill"
    activeEffects.add((effectType=EFFECT_ALPHA_CYCLE, lifeTime=-1, elapsedTime=0, intervalTime=0.8, min=200, max=255))
    activeEffects.add((effectType=EFFECT_FLIPBOOK, lifeTime=-1, elapsedTime=0, intervalTime=0.10, min=0, max=255))
    cycleStyles=(DEFAULT_LARGE_GOLD, DEFAULT_LARGE_ORANGE)
    alignX=CENTER
    alignY=TOP
  end object
  componentList.add(Skill_Tip_Label_2)

  // Tool tip arrow
  begin object class=UI_Texture_Info Name=Tool_Tip_Arrow
    componentTextures.add(Texture2D'GUI.Party_Selection_Nav_Marker')
  end object
  
  // Inactive sprite
  begin object class=UI_Sprite Name=Tool_Tip_Sprite
    tag="Tool_Tip_Sprite"
    bEnabled=false
    posX=275
    posY=543
    images(0)=Tool_Tip_Arrow
    activeEffects.add((effectType=EFFECT_ALPHA_CYCLE, lifeTime=-1, elapsedTime=0, intervalTime=0.8, min=220, max=255))
  end object
  componentList.add(Tool_Tip_Sprite)
  
  // Large Selector
  begin object class=UI_Selector Name=Action_Selector
    tag="Action_Selector"
    bDrawRelative=true
    bWrapAround=false
    posX=46
    posY=617
    gridSize=(x=2,y=2)
    navigationType=SELECTION_2D
    selectionOffset=(x=190,y=117)
    numberOfMenuOptions=2
    
    // Selector textures
    begin object class=UI_Texture_Info Name=Action_Selector_Large
      componentTextures.add(Texture2D'GUI.Combat_Action_Selector_Large')
    end object
    begin object class=UI_Texture_Info Name=Action_Selector_Small
      componentTextures.add(Texture2D'GUI.Combat_Action_Selector_Small')
    end object
    
    // Selector sprite
    begin object class=UI_Sprite Name=Selector_Sprite
      tag="Selector_Sprite"
      images(0)=Action_Selector_Large
      images(1)=Action_Selector_Small
      
      // Mild glow
      activeEffects.add((effectType=EFFECT_ALPHA_CYCLE, lifeTime=-1, elapsedTime=0, intervalTime=0.8, min=205, max=255))
    end object
    componentList.add(Selector_Sprite)
    
  end object
  componentList.add(Action_Selector)
  
}




























  
  
  
  
  
  
  
  
  
  
  







