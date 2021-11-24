/*============================================================================= 
 * ROTT_UI_Page_Combat_Targeting
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This class displays an enemy encounter, and handles player 
 * input for combat interactions.
 *===========================================================================*/
 
class ROTT_UI_Page_Combat_Targeting extends ROTT_UI_Page;

// Define alpha cycling UI effect
`define ALPHA_EFFECT() activeEffects.add((effectType = EFFECT_ALPHA_CYCLE, lifeTime = -1, elapsedTime = 0, intervalTime = 1.6, min = 215, max = 255))

// Internal References
var privatewrite UI_Selector enemySelector;
var privatewrite UI_Selector heroSelector;
var privatewrite UI_Container allHeroSelector;
var privatewrite UI_Container allEnemySelector;

// Parent scene
var private ROTT_UI_Scene_Combat_Encounter someScene;

// Delay before auto selection if using turbo
var public ROTT_Timer turboDelay;    

// Target selection mode, passed in from invoking action panel
var public TargetingClassification targetClassification;

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
  enemySelector = UI_Selector(findComp("Enemy_Selector"));
  heroSelector = UI_Selector(findComp("Hero_Selector"));
  allHeroSelector = UI_Container(findComp("All_Hero_Selector"));
  allEnemySelector = UI_Container(findComp("All_Enemy_Selector"));
  
}

/*============================================================================= 
 * onPushPageEvent()
 *
 * This event is called every time the page is pushed.
 *===========================================================================*/
event onPushPageEvent() {
  // Check if enemy 
  if (gameInfo.enemyEncounter.getMobSize() == 0) {
    parentScene.popPage();
  }
  
  // Initially clear graphics
  enemySelector.setEnabled(false);
  heroSelector.setEnabled(false);
  allHeroSelector.setEnabled(false);
  allEnemySelector.setEnabled(false);
  
  // Start turbo auto selection timer
  turboDelay = gameInfo.spawn(class'ROTT_Timer');
  turboDelay.makeTimer(0.35, LOOP_OFF, autoSelect); /// was 0.4
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
 * setTargetMode()
 *
 * This should be called right after the page is pushed
 *===========================================================================*/
public function setTargetMode(TargetingClassification mode) {
  // Set target selection for current skill
  targetClassification = mode;
  
  // Set initial target
  switch (targetClassification) {
    case SINGLE_TARGET_ATTACK:
    case SINGLE_TARGET_DEBUFF:
      // Target one enemy
      selectSingleEnemy();
      break;
    case MULTI_TARGET_ATTACK:
    case MULTI_TARGET_DEBUFF:
      // Target all enemies
      selectAllEnemies();
      break;
    case SINGLE_TARGET_BUFF:
      // Target one hero
      selectSingleHero();
      break;
    case MULTI_TARGET_BUFF:
      // Target all heroes
      selectAllHeroes();
      break;
    case SELF_TARGET_BUFF:
      // Target self
      selectSelf();
      break;
  }
}

/*============================================================================= 
 * selectSingleEnemy()
 *
 * Initializes selection for single enemy selection mode
 *===========================================================================*/
private function selectSingleEnemy() { 
  local ROTT_Combat_Hero hero;
  local ROTT_Mob mob;
  local int targetIndex;
  local int i;
  
  // Get acting unit
  hero = gameInfo.getActiveParty().readyUnits[0];
  
  // Get mob reference
  mob = gameInfo.enemyEncounter;
  
  // Move selector to first slot
  enemySelector.setEnabled(true);
  
  // Check target memory option
  if (gameInfo.optionsCookie.bTickTargetMemory) {
    // Recall selection
    targetIndex = hero.lastEnemySelection;
  } else {
    targetIndex = 0;
  }
  
  // Update selection
  enemySelector.forceSelection(targetIndex);
  
  // Check validity of selection 
  if (mob.getEnemy(targetIndex) != none) {
    if (mob.getEnemy(targetIndex).bDead == false) {
      return;
    }
  }
  
  // Increment selector to first non empty enemy
  enemySelector.resetSelection();
  enemySelector.setEnabled(true);
  i = 0;
  while ((mob.getEnemy(i) == none || mob.getEnemy(i).bDead) && i < 3) {
    enemySelector.nextSelection();
    
    i++;
  }
}

/*============================================================================= 
 * selectAllEnemies()
 *
 * Initializes selection for all enemies
 *===========================================================================*/
private function selectAllEnemies() { 
  local int i;
  local bool validTarget;
  
  allEnemySelector.setEnabled(true);
  for (i = 0; i < 3; i++) {
    validTarget = (gameInfo.enemyEncounter.getEnemy(i) != none);
    allEnemySelector.findComp("Enemy_Selector_" $ i + 1).setEnabled(validTarget);
  }
  
}

/*============================================================================= 
 * selectSingleHero()
 *
 * Initializes selection for single hero selection mode
 *===========================================================================*/
private function selectSingleHero() { 
  local int i;
  
  // Move selector to first slot
  heroSelector.resetSelection();
  heroSelector.setEnabled(true);
  heroSelector.setActive(true);
  
  // Increment selector to first non empty hero
  i = 0;
  while (gameInfo.getActiveParty().getHero(i).bDead && i < 3) {
    heroSelector.nextSelection();
    
    i++;
  }
}

/*============================================================================= 
 * selectAllHeroes()
 *
 * Initializes selection for all heroes
 *===========================================================================*/
private function selectAllHeroes() { 
  local int i;
  local bool validTarget;
  local ROTT_Combat_Hero hero;
  
  allHeroSelector.setEnabled(true);
  for (i = 0; i < 3; i++) {
    hero = gameInfo.getActiveParty().getHero(i);
    validTarget = (hero != none && hero.bDead == false);
    allHeroSelector.findComp("Hero_Selector_" $ i + 1).setEnabled(validTarget);
  }
  
}

/*============================================================================= 
 * selectSelf()
 *
 * Initializes selection for self selection mode
 *===========================================================================*/
private function selectSelf() { 
  // Move selector to first slot
  heroSelector.resetSelection();
  heroSelector.setEnabled(true);
  
  // Increment selector to the ready hero (self)
  heroSelector.forceSelection(gameInfo.getActiveParty().readyUnits[0].partyIndex);
  
  // Lock navigation
  heroSelector.setActive(false);
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
 * Update the target selection since the hero using it has died
 *
 * Precondition: dead unit has already been dequeued
 *===========================================================================*/
public function readyHeroHasDied() {
  someScene.popPage("Page_Targeting");
  someScene.pushNextActionPanel();
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
  return super.onInputKey(ControllerId, Key, Event, AmountDepressed, bGamepad);
}

public function onNavigateLeft() {
  local int i;
  
  // Selection validation routine
  switch (targetClassification) {
    case SINGLE_TARGET_ATTACK:
    case SINGLE_TARGET_DEBUFF:
      // Increment selector to first non empty enemy
      while (gameInfo.enemyEncounter.getEnemy(enemySelector.getSelection()) == none) {
        enemySelector.previousSelection();
        i++;
        if (i == 3) return;
      }
      break;
    case SINGLE_TARGET_BUFF:
      // Increment selector to first valid target
      while (gameInfo.getActiveParty().getHero(heroSelector.getSelection()) == none) {
        heroSelector.previousSelection();
        i++;
        if (i == 3) return;
      }
      break;
  }
}

public function onNavigateRight() {
  local int i;
  
  // Selection validation routine
  switch (targetClassification) {
    case SINGLE_TARGET_ATTACK:
    case SINGLE_TARGET_DEBUFF:
      // Increment selector to first valid target
      while (gameInfo.enemyEncounter.getEnemy(enemySelector.getSelection()) == none) {
        enemySelector.nextSelection();
        i++;
        if (i == 3) return;
      }
      break;
    case SINGLE_TARGET_BUFF:
      // Increment selector to first valid target
      while (gameInfo.getActiveParty().getHero(heroSelector.getSelection()) == none) {
        heroSelector.nextSelection();
        i++;
        if (i == 3) return;
      }
      break;
    
  }
}

/*============================================================================= 
 * Button Input
 *===========================================================================*/
protected function navigationRoutineA() {
  local ROTT_Combat_Hero hero;
  local ChosenTargetEnum targetSelection;
  
  // Remove turbo automation if its on
  if (turboDelay != none) turboDelay.destroy();
  
  // Get acting unit
  hero = gameInfo.getActiveParty().readyUnits[0];
  
  // Remove auto selection timer
  if (turboDelay != none) turboDelay.destroy();
  
  // Selection mode handling
  switch (targetClassification) {
    case SINGLE_TARGET_ATTACK:
    case SINGLE_TARGET_DEBUFF:
      // Target one enemy
      switch (enemySelector.getSelection()) {
        case 0: targetSelection = TARGET_ENEMY_1; break;
        case 1: targetSelection = TARGET_ENEMY_2; break;
        case 2: targetSelection = TARGET_ENEMY_3; break;
      }
      // Store last enemy selection
      hero.lastEnemySelection = enemySelector.getSelection();
      break;
    case MULTI_TARGET_ATTACK:
    case MULTI_TARGET_DEBUFF:
      // Target all enemies
      targetSelection = TARGET_ALL_ENEMIES;
      break;
    case SINGLE_TARGET_BUFF:
      // Target one hero
      switch (heroSelector.getSelection()) {
        case 0: targetSelection = TARGET_HERO_1; break;
        case 1: targetSelection = TARGET_HERO_2; break;
        case 2: targetSelection = TARGET_HERO_3; break;
      }
      break;
    case MULTI_TARGET_BUFF:
      // Target all heroes
      targetSelection = TARGET_ALL_HEROES;
      break;
    case SELF_TARGET_BUFF:
      // Target self
      switch (hero.partyIndex) {
        case 0: targetSelection = TARGET_HERO_1; break;
        case 1: targetSelection = TARGET_HERO_2; break;
        case 2: targetSelection = TARGET_HERO_3; break;
      }
      break; 
  }
  
  // Commit action (if mana sufficient and target valid)
  if (hero.sendAction(targetSelection)) {
    // Conditions met to act
    someScene.popTargetPage();
    
  } else {
    // Conditions failed
    /* to do ... */
  }
}

protected function navigationRoutineB() {
  // Return to action selection
  parentScene.popPage();
  sfxBox.playSFX(SFX_MENU_BACK);
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
  
  begin object class=ROTT_Input_Handler Name=Input_B
    inputName="XBoxTypeS_B"
    buttonComponent=none
  end object
  inputList.add(Input_B)
  
  /** ===== UI Components ===== **/
  tag="Target_Selection_Page"
  posX=0
  posY=0
  posXEnd=NATIVE_WIDTH
  posYEnd=NATIVE_HEIGHT

  // Target selector (Enemy)
  begin object class=UI_Selector Name=Enemy_Selector
    tag="Enemy_Selector"
    bEnabled=false
    posX=185
    posY=231
    navigationType=SELECTION_HORIZONTAL
    selectionOffset=(x=385,y=0)
    numberOfMenuOptions=3
    
    // Selection texture
    begin object class=UI_Texture_Info Name=Selection_Arrows_Texture
      componentTextures.add(Texture2D'GUI.Target_Selector_Enemy')
    end object

    // Selector sprite
    begin object class=UI_Sprite Name=Selector_Sprite
      tag="Selector_Sprite"
      images(0)=Selection_Arrows_Texture
      ///activeEffects.add((effectType = EFFECT_ALPHA_CYCLE, lifeTime = -1, elapsedTime = 0, intervalTime = 0.4, min = 170, max = 255))
      `ALPHA_EFFECT()
    end object
    componentList.add(Selector_Sprite)
  end object
  componentList.add(Enemy_Selector)
  
  // Target selector (Hero)
  begin object class=UI_Selector Name=Hero_Selector
    tag="Hero_Selector"
    bEnabled=false
    posX=724
    posY=597
    navigationType=SELECTION_HORIZONTAL
    selectionOffset=(x=231,y=0)
    numberOfMenuOptions=3
    
    // Selection texture
    begin object class=UI_Texture_Info Name=Selection_Arrows_Texture
      componentTextures.add(Texture2D'GUI.Target_Selector_Hero')
    end object

    // Selector sprite
    begin object class=UI_Sprite Name=Selector_Sprite
      tag="Selector_Sprite"
      images(0)=Selection_Arrows_Texture
      ///activeEffects.add((effectType = EFFECT_ALPHA_CYCLE, lifeTime = -1, elapsedTime = 0, intervalTime = 0.4, min = 170, max = 255))
      `ALPHA_EFFECT()
    end object
    componentList.add(Selector_Sprite)
    
    // Selector sprite
    begin object class=UI_Sprite Name=Inactive_Selector_Sprite
      tag="Inactive_Selector_Sprite"
      images(0)=Selection_Arrows_Texture
      ///activeEffects.add((effectType = EFFECT_ALPHA_CYCLE, lifeTime = -1, elapsedTime = 0, intervalTime = 0.4, min = 170, max = 255))
      `ALPHA_EFFECT()
    end object
    componentList.add(Inactive_Selector_Sprite)
  end object
  componentList.add(Hero_Selector)
  
  // All Hero Targets
  begin object class=UI_Container Name=All_Hero_Selector
    tag="All_Hero_Selector"
    bEnabled=false
    
    // Selection texture
    begin object class=UI_Texture_Info Name=Target_Selector_Hero
      componentTextures.add(Texture2D'GUI.Target_Selector_Hero')
    end object
    
    begin object class=UI_Sprite Name=Hero_Selector_1
      tag="Hero_Selector_1"
      posX=724
      posY=597
      images(0)=Target_Selector_Hero
      
      // Alpha Effects
      `ALPHA_EFFECT()
      
    end object
    componentList.add(Hero_Selector_1)
    
    begin object class=UI_Sprite Name=Hero_Selector_2
      tag="Hero_Selector_2"
      posX=955
      posY=597
      images(0)=Target_Selector_Hero
      
      // Alpha Effects
      `ALPHA_EFFECT()
      
    end object
    componentList.add(Hero_Selector_2)
    
    begin object class=UI_Sprite Name=Hero_Selector_3
      tag="Hero_Selector_3"
      posX=1186
      posY=597
      images(0)=Target_Selector_Hero
      
      // Alpha Effects
      `ALPHA_EFFECT()
      
    end object
    componentList.add(Hero_Selector_3)
    
  end object
  componentList.add(All_Hero_Selector)
  
  
  
  // All Enemy Targets
  begin object class=UI_Container Name=All_Enemy_Selector
    tag="All_Enemy_Selector"
    bEnabled=false
    
    // Selection texture
    begin object class=UI_Texture_Info Name=Target_Selector_Enemy
      componentTextures.add(Texture2D'GUI.Target_Selector_Enemy')
    end object

    begin object class=UI_Sprite Name=Enemy_Selector_1
      tag="Enemy_Selector_1"
      posX=185
      posY=231
      images(0)=Target_Selector_Enemy
      
      // Alpha Effects
      `ALPHA_EFFECT()
      
    end object
    componentList.add(Enemy_Selector_1)
    
    begin object class=UI_Sprite Name=Enemy_Selector_2
      tag="Enemy_Selector_2"
      posX=570
      posY=231
      images(0)=Target_Selector_Enemy
      
      // Alpha Effects
      `ALPHA_EFFECT()
      
    end object
    componentList.add(Enemy_Selector_2)
    
    begin object class=UI_Sprite Name=Enemy_Selector_3
      tag="Enemy_Selector_3"
      posX=955
      posY=231
      images(0)=Target_Selector_Enemy
      
      // Alpha Effects
      `ALPHA_EFFECT()
      
    end object
    componentList.add(Enemy_Selector_3)
    
  end object
  componentList.add(All_Enemy_Selector)
  
}




































