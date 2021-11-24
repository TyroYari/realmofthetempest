/*=============================================================================
 * ROTT_UI_Page_Hero_Tree_Info
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This page is the base class for pages that inspect hero info.
 *===========================================================================*/
 
class ROTT_UI_Page_Hero_Tree_Info extends ROTT_UI_Page_Hero_Info
abstract;
  
var protected UI_Tree_Selector treeSelectionBox;
var protected UI_Selector_2D skillSelectionBox;
var protected UI_Sprite skilltreeBackground;

/*=============================================================================
 * Initialize Component
 *
 * Description: This event is called as the UI is loaded.
 *              Our initial scene is drawn here.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  super.initializeComponent(newTag);
  
  
}

/*============================================================================= 
 * onPushPageEvent()
 *
 * This event is called every time the page is pushed.
 *===========================================================================*/
event onPushPageEvent() {
  // Render selected hero
  renderHeroData(parentScene.getSelectedHero());
  
  // Check if reset utility is up
  if (parentScene.isPageInStack("Reinvest_Skill_UI")) {
    controlState = RESET_VIEW_MODE;
    return;
  }
  
  controlState = VIEW_MODE;
}

/*=============================================================================
 * onFocusMenu()
 *
 * Called when a menu is given focus.  Assign controls, and enable graphics.
 *===========================================================================*/
event onFocusMenu() {
  local ROTT_Combat_Hero hero;
  
  super.onFocusMenu();
  
  hero = parentScene.getSelectedHero();
  
  // Enable display and navigation graphics
  skilltreeBackground.setEnabled(true);
  
  // Render selected hero info 
  renderHeroData(hero);
  
  // Change display based on control state
  switch (controlState) {
    case VIEW_MODE: 
    case RESET_VIEW_MODE: 
      gameMenuScene.enablePageArrows(true);
      break;
    case SELECTION_MODE:
    case RESET_SELECTION_MODE:
      // Remove flicker effects
      if (skillSelectionBox != none) skillSelectionBox.clearEffect(EFFECT_FLICKER);
      if (treeSelectionBox != none) treeSelectionBox.clearEffect(EFFECT_FLICKER);
      break;
  }
}

/*============================================================================= 
 * refresh()
 *
 * Called to update info after investing skill points
 *===========================================================================*/
public function refresh() {
  // Render selected hero information
  renderHeroData(parentScene.getSelectedHero());
  
  // Render selected skill information
  renderSkillData();
  
  // Hacky resolution to hover updates for the mgmt window
  hoverUpdateFix();
}

/*============================================================================= 
 * hoverUpdateFix()
 *
 * Refreshes the proper management window
 *===========================================================================*/
protected function hoverUpdateFix() {
  // Switch to proper window ...hacky
  if (controlState == RESET_SELECTION_MODE) return;
  if (controlState == VIEW_MODE) return;
  
  // Ignore for glyph and mastery page
  if (ROTT_UI_Page_Glyph_Skilltree(self) != none) return;
  if (ROTT_UI_Page_Mastery_Skilltree(self) != none) return;
  
  // Update for hovering and swapping mgmt pages
  if (isSkillPassive() && parentScene.topPage().tag != "Mgmt_Window_Passive") {
    parentScene.popPage("Mgmt_Window_Skills");
    pushSkillWindow();
  }
  if (!isSkillPassive() && parentScene.topPage().tag != "Mgmt_Window_Skills") {
    parentScene.popPage("Mgmt_Window_Passive");
    pushSkillWindow();
  }
}

/**============================================================================= 
 * setResetMode()
 *
 * This changes the input mode for resetting stat points
 *===========================================================================
public function setResetMode() {
  // Controls
  controlState = RESET_VIEW_MODE;
}
*/
/*============================================================================= 
 * renderHeroData()
 *
 * Given a hero, this displays all of its information to the screen
 *===========================================================================*/
protected function renderHeroData(ROTT_Combat_Hero hero) {
  if (ROTT_UI_Page_Class_Skilltree(self) != none) ROTT_UI_Page_Class_Skilltree(self).renderHeroData(hero);
  if (ROTT_UI_Page_Glyph_Skilltree(self) != none) ROTT_UI_Page_Glyph_Skilltree(self).renderHeroData(hero);
  if (ROTT_UI_Page_Mastery_Skilltree(self) != none) ROTT_UI_Page_Mastery_Skilltree(self).renderHeroData(hero);
}

/*=============================================================================
 * moveUp
 * 
 * 
 *===========================================================================*/
protected function moveUp() {
  if (treeSelectionBox != none) treeSelectionBox.moveUp();
  if (skillSelectionBox != none) skillSelectionBox.moveUp();
}

/*=============================================================================
 * moveDown
 * 
 * 
 *===========================================================================*/
protected function moveDown() {
  if (treeSelectionBox != none) treeSelectionBox.moveDown();
  if (skillSelectionBox != none) skillSelectionBox.moveDown();
}

/*=============================================================================
 * moveLeft
 * 
 * 
 *===========================================================================*/
protected function moveLeft() {
  if (treeSelectionBox != none) treeSelectionBox.moveLeft();
  if (skillSelectionBox != none) skillSelectionBox.moveLeft();
}

/*=============================================================================
 * moveRight
 * 
 * 
 *===========================================================================*/
protected function moveRight() {
  if (treeSelectionBox != none) treeSelectionBox.moveRight();
  if (skillSelectionBox != none) skillSelectionBox.moveRight();
}

/*=============================================================================
 * resetUI
 * 
 * This is called when the menu loses focus
 *===========================================================================*/
protected function resetUI() {
  if (treeSelectionBox != none) treeSelectionBox.resetSelection();
  if (skillSelectionBox != none) skillSelectionBox.resetSelection();
  skilltreeBackground.setEnabled(false);
}

/*=============================================================================
 * setSelector
 * 
 * This is called to initialize the selector position and graphics
 *===========================================================================*/
protected function setSelector(int drawIndex) {
  if (treeSelectionBox != none) {
    treeSelectionBox.resetSelection();
    treeSelectionBox.setEnabled(true);
    treeSelectionBox.setDrawIndex(drawIndex);
  }
  if (skillSelectionBox != none) {
    skillSelectionBox.resetSelection();
    skillSelectionBox.setEnabled(true);
    skillSelectionBox.setDrawIndex(drawIndex);
  }
}

/*============================================================================= 
 * renderSkillData()
 *
 * This passes a skill descriptor to the mgmt window
 *===========================================================================*/
protected function renderSkillData() {
  local ROTT_Descriptor descriptor;
  local ROTT_Combat_Hero hero;
  local int skillID;
  
  // Get skill ID based on selection box
  skillID = getSkillID();
  
  // Get hero
  hero = parentScene.getSelectedHero();
  
  // Get skill descriptor
  if (ROTT_UI_Page_Class_Skilltree(self) != none) descriptor = hero.getSkillScript(skillID);
  if (ROTT_UI_Page_Glyph_Skilltree(self) != none) descriptor = hero.getGlyphScript(skillID);
  if (ROTT_UI_Page_Mastery_Skilltree(self) != none) descriptor = hero.getMasteryScript(skillID);
  
  // Set descriptor information mode
  ROTT_Descriptor_Hero_Skill(descriptor).setShowPrevious(false);
  
  // Display descriptor
  switch (controlState) {
    case VIEW_MODE:
    case SELECTION_MODE:
      gameMenuScene.setMgmtDescriptor(descriptor); 
      break;
    case RESET_VIEW_MODE:
    case RESET_SELECTION_MODE:
      gameMenuScene.setMgmtDescriptor(descriptor); 
      break;
  }
}

/*=============================================================================
 * pushSkillWindow
 * 
 * This is called to push a management window based on the skill selection
 *===========================================================================*/
protected function pushSkillWindow() {
  if (ROTT_UI_Page_Glyph_Skilltree(self) != none) {
    gameMenuScene.pushMenu(MGMT_WINDOW_COLLECT);
  } else if (isSkillPassive()) {
    gameMenuScene.pushMenu(MGMT_WINDOW_PASSIVE);
  } else {
    gameMenuScene.pushMenu(MGMT_WINDOW_SKILLS);
  }
}

/*============================================================================= 
 * isSkillPassive()
 *
 * Returns true if the selected skill is passive
 *===========================================================================*/
public function bool isSkillPassive() {
  local ROTT_Descriptor_Hero_Skill descriptor;
  local ROTT_Combat_Hero hero;
  local int skillID;
  
  // Always return true for mastery skills
  if (ROTT_UI_Page_Mastery_Skilltree(self) != none) return true;
  
  // Get skill ID based on selection box
  skillID = getSkillID();
  
  // Get hero
  hero = parentScene.getSelectedHero();
  
  // Get skill descriptor
  descriptor = ROTT_Descriptor_Hero_Skill(hero.getSkillScript(skillID));
  
  switch (descriptor.targetingLabel) {
    case PASSIVE_PARTY_BUFF:
    case COLLECTIBLE_GLYPH:
    case MULTI_TARGET_AURA:
    case PASSIVE_ATTACK_PERK:
    case PASSIVE_DEFEND_PERK:
      return true;
  }
  return false;
}

/*============================================================================= 
 * getSkillID()
 *
 * Converts selector index to a skill index
 *===========================================================================*/
public function byte getSkillID() {
  if (ROTT_UI_Page_Class_Skilltree(self) != none) return getClassID();
  if (ROTT_UI_Page_Glyph_Skilltree(self) != none) return getGlyphID();
  if (ROTT_UI_Page_Mastery_Skilltree(self) != none) return getMasteryID();
}

/*============================================================================= 
 * getClassID()
 *
 * Converts selector index to a skill index
 *===========================================================================*/
private function byte getClassID() {
  switch (parentScene.getSelectedHero().myClass) {
    case VALKYRIE:
      switch (treeSelectionBox.getSelection()) {
        case 1:   return VALKYRIE_VALOR_STRIKE;      break;   
        case 5:   return VALKYRIE_SWIFT_STEP;        break;
        case 8:   return VALKYRIE_ELECTRIC_SIGIL;    break;
        case 4:   return VALKYRIE_THUNDER_SLASH;     break;
        case 7:   return VALKYRIE_VERMEIL_STITCHING; break;
        case 6:   return VALKYRIE_SPARK_FIELD;       break; 
        case 9:   return VALKYRIE_SOLAR_SHOCK;       break; 
        case 10:  return VALKYRIE_VOLT_RETALIATION;  break; 
      }
      break;
    case WIZARD:
      switch (treeSelectionBox.getSelection()) {
        case 1:   return WIZARD_STARBOLT;       break;
        case 3:   return WIZARD_STARDUST;       break;
        case 4:   return WIZARD_SPECTRAL_SURGE; break;
        case 7:   return WIZARD_ARCANE_SIGIL;   break; 
        case 8:   return WIZARD_DEVOTION;       break; 
        case 9:   return WIZARD_PLASMA_SHROUD;  break;   
        case 10:  return WIZARD_BLACK_HOLE;     break;
        case 11:  return WIZARD_ASTRAL_FIRE;    break; 
      }
      break;
    case GOLIATH:
      switch (treeSelectionBox.getSelection()) {
        case 1:   return GOLIATH_STONE_STRIKE;    break;
        case 5:   return GOLIATH_INTIMIDATION;    break;
        case 4:   return GOLIATH_EARTHQUAKE;      break;
        case 6:   return GOLIATH_DEMOLISH;        break;
        case 8:   return GOLIATH_COUNTER_GLYPHS;  break;
        case 7:   return GOLIATH_OBSIDIAN_SPIRIT; break;
        case 11:  return GOLIATH_AVALANCHE;       break;
        case 10:  return GOLIATH_MARBLE_SPIRIT;   break;
      }
      break;
    case TITAN:
      switch (treeSelectionBox.getSelection()) {
        case 1:   return TITAN_SIPHON;       break;
        case 3:   return TITAN_THRASHER;     break;
        case 4:   return TITAN_ICE_STORM;    break;
        case 6:   return TITAN_BLIZZARD;     break;
        case 8:   return TITAN_OATH;         break;
        case 11:  return TITAN_FUSION;       break;
        case 9:   return TITAN_MEDITATION;   break;
        case 10:  return TITAN_AURORA_FANGS; break;
      }
      break;
    case ASSASSIN:
    
      break;
  }
}

/*============================================================================= 
 * getGlyphID()
 *
 * Converts selector index to a skill index
 *===========================================================================*/
private function byte getGlyphID() {
  switch (skillSelectionBox.getSelection()) {
    case 1:          return GLYPH_TREE_ARMOR;
    case 0:          return GLYPH_TREE_HEALTH;
    case 2:          return GLYPH_TREE_MANA;
    case 5:          return GLYPH_TREE_MP_REGEN;
    case 3:          return GLYPH_TREE_SPEED;
    case 6:          return GLYPH_TREE_ACCURACY;
    case 8:          return GLYPH_TREE_DODGE;
    case 4: case 7:  return GLYPH_TREE_DAMAGE;
  }
}

/*============================================================================= 
 * getMasteryID()
 *
 * Converts selector index to a skill index
 *===========================================================================*/
private function byte getMasteryID() {
  switch (skillSelectionBox.getSelection()) {
    case 0: return MASTERY_LIFE;
    case 1: return MASTERY_ARMOR;
    case 2: return MASTERY_MANA;
    case 3: return MASTERY_REJUV;
    case 4: return MASTERY_DAMAGE;
    case 5: return MASTERY_SPEED;
    case 6: return MASTERY_ACCURACY;
    case 7: return (gameInfo.playerProfile.gameMode == MODE_HARDCORE) ? MASTERY_OMNI_SEEKER : MASTERY_RESURRECT;
    case 8: return MASTERY_DODGE;
  }
}

/*============================================================================*
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
  // Remap for keyboard control
  if (Key == 'Z' && Event == IE_Pressed) navigationRoutineLB();
  if (Key == 'C' && Event == IE_Pressed) navigationRoutineRB();
  
  return super.onInputKey(ControllerId, Key, Event, AmountDepressed, bGamepad);
}

/*=============================================================================
 * D-Pad controls
 *===========================================================================*/
public function onNavigateUp() {
  switch (controlState) {
    case SELECTION_MODE:
      moveUp();
      renderSkillData();
      parentScene.popPage();
      pushSkillWindow();
      break;
    case RESET_SELECTION_MODE:
      moveUp();
      renderSkillData();
      break;
  }
}

public function onNavigateDown() {
  switch (controlState) {
    case SELECTION_MODE:
      moveDown();
      renderSkillData();
      parentScene.popPage();
      pushSkillWindow();
      break;
    case RESET_SELECTION_MODE:
      moveDown();
      renderSkillData();
      break;
  }
}

public function onNavigateLeft() {
  switch (controlState) {
    case VIEW_MODE:
      resetUI();
      break;
    case SELECTION_MODE:
      moveLeft();
      renderSkillData();
      parentScene.popPage();
      pushSkillWindow();
      break;
    case RESET_SELECTION_MODE:
      moveLeft();
      renderSkillData();
      break;
  }
}

public function onNavigateRight() {
  switch (controlState) {
    case VIEW_MODE:
      resetUI();
      break;
    case SELECTION_MODE:
      moveRight();
      renderSkillData();
      parentScene.popPage();
      pushSkillWindow();
      break;
    case RESET_SELECTION_MODE:
      moveRight();
      renderSkillData();
      break;
  }
}

/*=============================================================================
 * Button controls
 *===========================================================================*/
protected function navigationRoutineA() {
  switch (controlState) {
    case VIEW_MODE:
      // Change view to inspection mode
      controlState = SELECTION_MODE;
      gameMenuScene.enablePageArrows(false);
      setSelector(0);
      pushSkillWindow();
      renderSkillData();
      break;
    case SELECTION_MODE: 
      // Change view to inspection window
      parentScene.focusTop();
      
      // Set flicker effects
      if (skillSelectionBox != none) skillSelectionBox.addFlickerEffect(-1, 0.065, , 100, 200);
      if (treeSelectionBox != none) treeSelectionBox.addFlickerEffect(-1, 0.065, , 100, 200);
      break;
    case RESET_VIEW_MODE:
      // Change view to inspection mode
      controlState = RESET_SELECTION_MODE;
      gameMenuScene.enablePageArrows(false);
      setSelector(1);
      renderSkillData();
      parentScene.pushPageByTag("Reset_Skill_Manager_UI", false); 
      break;
    case RESET_SELECTION_MODE: 
      parentScene.focusTop();
      
      // Set flicker effects
      if (skillSelectionBox != none) skillSelectionBox.addFlickerEffect(-1, 0.065, , 100, 200);
      if (treeSelectionBox != none) treeSelectionBox.addFlickerEffect(-1, 0.065, , 100, 200);
      break;
  }
  // Sfx
  gameInfo.sfxBox.playSfx(SFX_MENU_ACCEPT);
}

protected function navigationRoutineB() {
  switch (controlState) {
    case VIEW_MODE:
      // Close menu
      resetUI();
      parentScene.popPage();
      break;
    case SELECTION_MODE:
      // Change to view mode
      controlState = VIEW_MODE;
      
      // Remove Selection box
      if (treeSelectionBox != none) treeSelectionBox.setEnabled(false);
      if (skillSelectionBox != none) skillSelectionBox.setEnabled(false);
      
      // Close the mgmt window
      parentScene.popPage();
      break;
    case RESET_VIEW_MODE:
      // Close menu
      resetUI();
      parentScene.popPage();
      break;
    case RESET_SELECTION_MODE:
      // Change to view mode
      controlState = RESET_VIEW_MODE;
      parentScene.popPage();
      
      // Remove Selection box
      if (treeSelectionBox != none) treeSelectionBox.setEnabled(false);
      if (skillSelectionBox != none) skillSelectionBox.setEnabled(false);
      break;
  }
  // Sfx
  gameInfo.sfxBox.playSfx(SFX_MENU_BACK);
}

/*=============================================================================
 * Bumper inputs
 *===========================================================================*/
protected function navigationRoutineRB() {
  // Navigate to next hero
  switch (controlState) {
    case VIEW_MODE:
    case RESET_VIEW_MODE:
      parentScene.nextAvailableHero();
      refresh();
      break;
  }
}

protected function navigationRoutineLB() {
  // Navigate to previous hero
  switch (controlState) {
    case VIEW_MODE:
    case RESET_VIEW_MODE:
      parentScene.previousAvailableHero();
      refresh();
      break;
  }
}

/*=============================================================================
 * Assets
 *===========================================================================*/
defaultProperties
{
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
}











