/*=============================================================================
 * ROTT_UI_Scene
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: A scene is a stack of pages that may be drawn on the screen
 * by the scene manager (see: ROTT_UI_Scene_Manager.uc)
 *===========================================================================*/

class ROTT_UI_Scene extends UI_Scene
abstract;

// Store objects selected by the menus in the scene
var privatewrite ROTT_Party       selectedParty;
var privatewrite ROTT_Combat_Hero selectedHero;
///var privatewrite tree treeindex;
  
  
  
  
  
  
  
// Parameters used in ROTT_Timers:
const LOOP_OFF = false;
const LOOP_ON  = true;

// If true, reset the scene to an initial display ever time its loaded
var privatewrite bool bResetOnLoad;

// An array of UI components that may appear ontop of this scene
var privatewrite instanced array<UI_Component> uiComponents;

// An array of pages that may be displayed by being pushed to the pageStack
var privatewrite instanced array<ROTT_UI_Page> pageComponents;

// An array of pages that are part of the initial display
var privatewrite instanced array<ROTT_UI_Page> initialPages;

// A stack data structure for organizing menu layers
var privatewrite array<ROTT_UI_Page> pageStack;

// The index of which page has focus
var private int focusedIndex;

// A reference to the component that will handle player input
var privatewrite ROTT_UI_Page inputControlComponent;

// Shortcut reference to the parent UI Scene manager
var privatewrite ROTT_UI_Scene_Manager sceneManager; 

// True if this scene has been initialized
var private bool bInitComplete; 

// Pop page function continues popping until this is zero
var private int popQueue;

// External references
var public ROTT_Game_Info gameInfo;
var public ROTT_Game_Sfx sfxBox;
var public ROTT_Game_Music jukeBox;

// Player has over world control if true, false otherwise
var protected bool bAllowOverWorldControl;

// Players camera is used if false, otherwise use ...
var protected bool bOverrideCamera;
var protected vector overrideCamLoc;
var protected rotator overrideCamRot;

// Caching
var privatewrite bool bCaching;

/*=============================================================================
 * initScene()
 *
 * Called when this scene is created
 *===========================================================================*/
event initScene() {
  local int i;
  
  // Assign parent reference
  sceneManager = ROTT_UI_Scene_Manager(outer);
  
  // Assign other references
  gameInfo = ROTT_Game_Info(class'WorldInfo'.static.getWorldInfo().game);
  sfxBox = ROTT_Game_Sfx(gameInfo.sfxBox);
  jukeBox = gameInfo.jukeBox;
  
  // Initialize all pages contained in scene
  for (i = 0; i < pageComponents.length; i++) {
    if (pageComponents[i] != none) {
      pageComponents[i].setGameInfo();
    }
    pageComponents[i].initializeComponent();
  }
  
  // Initialize sprites & labels
  for (i = 0; i < uiComponents.length; i++) {
    uiComponents[i].initializeComponent();
  }
  
  bInitComplete = true;
  
  // Cache
  ///cacheSprites();
  
  /// Start
  for (i = 0; i < pageComponents.length; i++) {
    pageComponents[i].startEvent();
  }
  for (i = 0; i < uiComponents.length; i++) {
    uiComponents[i].startEvent();
  }
}

/*=============================================================================
 * cacheTextures()
 *
 * Adds textures to a cache queue to prevent blurry textures
 *===========================================================================*/
public function cacheTextures(UI_Texture_Storage textures) {
  local int i;
  
  if (textures == none) return;
  
  // Cache textures
  for (i = 0; i < textures.images.length; i++) {
    UI_Sprite(findComp("Sprite_Cacher")).addSprite(textures, i);
  }
  
  bCaching = true;
}

/*=============================================================================
 * loadScene()
 *
 * Called when switching to this scene 
 * (e.g. when this scene becomes activeScene)
 *===========================================================================*/
event loadScene() {
  local int i;
  
  if (bResetOnLoad) resetScene();
  
  // Set camera position and rotation
  if (bOverrideCamera == true) {
    gameInfo.tempestPawn.overrideCamera(overrideCamLoc, overrideCamRot);
  } else {
    gameInfo.tempestPawn.releaseCamera();
  }
  
  // Trigger scene activation event for all pages
  for (i = 0; i < pageComponents.length; i++) {
    if (pageComponents[i] != none) {
      pageComponents[i].onSceneActivation();
    }
  }
  
  // Set 3D World controls
  if (!bAllowOverWorldControl) {
    gameInfo.pauseGame();
  } else {
    // We dont want to always unpause here
    //gameInfo.unpauseGame();
  }
  
  // Set mouse visibility lock
  if (!gameInfo.hud.bCursorActive) {
    gameInfo.hud.lockCursorHidden();
  } 
}

/*=============================================================================
 * removeObjectSelection()
 *
 * Unmarks a component as selected in the scene. Returns true if successful.
 *===========================================================================*/
public function bool removeObjectSelection(class<object> searchType) {
  // Check for clearing selection data?
  switch (searchType) {
    case class'ROTT_Party':
      selectedParty = none;
    case class'ROTT_Combat_Hero':
      selectedHero = none;
      break;
  }
  return super.removeObjectSelection(searchType);
}

/*=============================================================================
 * unloadScene()
 *
 * Called when switching to a different scene
 *===========================================================================*/
event unloadScene(){
  local int i;
  
  // Trigger scene deactivation event for all pages
  for (i = 0; i < pageComponents.length; i++) {
    if (pageComponents[i] != none) {
      pageComponents[i].onSceneDeactivation();
    }
  }
  
  // Unpause here, and allow next scene to decide whether to repause again
  ROTT_Game_Info(class'WorldInfo'.static.getWorldInfo().game).unpauseGame();
}

/*=============================================================================
 * resetScene()
 *
 * Called to reset the scene to an initial display state
 *===========================================================================*/
public function resetScene(){
  local int i;
  
  // Remove all pages
  popAllPages();
  
  // Push all initial pages
  for (i = 0; i < pageComponents.length; i++) {
    if (pageComponents[i].bInitialPage) pushPage(pageComponents[i]);
  }
}

/*=============================================================================
 * pauseScene()
 *
 * Called when the scene pauses
 *===========================================================================*/
event pauseScene(){
  local int i;
  
  // Trigger pause event on pages
  for (i = 0; i < pageComponents.length; i++) {
    if (pageComponents[i] != none) {
      pageComponents[i].onScenePause();
    }
  }
}

/*=============================================================================
 * unpauseScene()
 *
 * Called when the scene pauses
 *===========================================================================*/
event unpauseScene(){
  local int i;
  
  // Trigger pause event on pages
  for (i = 0; i < pageComponents.length; i++) {
    if (pageComponents[i] != none) {
      pageComponents[i].onSceneUnpause();
    }
  }
}

/*=============================================================================
 * drawScene()
 *
 * Called each frame to draw the scene
 *===========================================================================*/
public function drawScene(Canvas canvas) {
  local int i, layer;
  
  whiteLog("+ " $ self, DEBUG_HIERARCHY);
  
  // Update page stack
  for (i = 0; i < pageStack.length; i++) {
    pageStack[i].updateEvent();
  }
  
  // Update scene sprites/labels
  for (i = 0; i < uiComponents.length; i++) {
    uiComponents[i].updateEvent();
  }
  
  // Draw page stack
  for (layer = 0; layer < class'UI_Component'.static.getLayerCount(); layer++) {
    for (i = 0; i < pageStack.length; i++) {
      pageStack[i].drawEvent(canvas, LayerList(layer));
      //pageStack[i].debugHierarchy(1, true);
    }
    
    // Draw scene sprites/labels
    for (i = 0; i < uiComponents.length; i++) {
      uiComponents[i].drawEvent(canvas, LayerList(layer));
      //uiComponents[i].debugHierarchy(1, true);
    }
  }
}

/*=============================================================================
 * isMouseVisible()
 *
 * True if the mouse should be shown
 *===========================================================================*/
public function bool isMouseVisible() {
  // Page overrides
  if (pageStack[pageStack.length - 1].bPageForcesCursorOff) return false;
  if (pageStack[pageStack.length - 1].bPageForcesCursorOn)  return true;
  
  // Scene setting
  return (bHideCursorOverride == false);
}

/*============================================================================= 
 * pageTagIsUp()
 *
 * Returns true if the given tag is found.
 *===========================================================================*/
public function bool pageTagIsUp(string searchTag) {
  local int i;
  
  // Draw page stack
  for (i = 0; i < pageStack.length; i++) {
    if (pageStack[i].tag == searchTag) return true;
  }
  
  return false;
}

/*============================================================================= 
 * pageIsUp()
 *
 * Returns true if the given page is up.
 *===========================================================================*/
public function bool pageIsUp(ROTT_UI_Page targetPage) {
  local int i;
  
  // Draw page stack
  for (i = 0; i < pageStack.length; i++) {
    if (pageStack[i] == targetPage) return true;
  }
  
  return false;
}

/*============================================================================= 
 * refresh()
 *
 * This should be called when data changes are made that might impact the UI.
 *===========================================================================*/
public function refresh() {
  local int i;
  
  // Draw page stack
  for (i = 0; i < pageStack.length; i++) {
    pageStack[i].refresh();
  }
}

/*=============================================================================
 * Process an input key event 
 *
 * @return  true to consume the key event, false to pass it on.
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
  local bool bConsumeKey;
  
  // Pass input to HUD
  gameInfo.hud.onInputKey(inputName);
  
  // Pass control to the the appropriate component
  if (inputControlComponent != none && inputControlComponent.bEnabled) {
    bConsumeKey = inputControlComponent.onInputKey(ControllerId, inputName, Event, AmountDepressed, bGamepad);
    if (bConsumeKey && inputName != 'XboxTypeS_RightTrigger')
      return true;
  }

  return false;
}

/*=============================================================================
 * isPageInStack()
 *
 * True if the page is found in the stack
 *===========================================================================*/
public function bool isPageInStack(string compTag) {
  local int i;
  
  for (i = 0; i < pageStack.length; i++) {
    if (pageStack[i].tag == compTag) return true;
  }
  
  return false;
}

/*=============================================================================
 * findComp()
 *
 * returns a reference to a page matching the given tag
 *===========================================================================*/
public function UI_Component findComp(string compTag) {
  local int i;

  if (compTag == "")
    return None;
  
  // Search through pages
  for (i = 0; i < pageComponents.length; i++) {
    if (pageComponents[i].tag == compTag) return pageComponents[i];
  }
  
  // Search through sprites/labels
  for (i = 0; i < uiComponents.length; i++) {
    if (uiComponents[i].tag == compTag) return uiComponents[i];
  }

  return none;
}

/*=============================================================================
 * previousAvailableHero()
 *
 * 
 *===========================================================================*/
public function previousAvailableHero() {
  local int i;
  
  // Search pages for party selector
  for (i = 0; i < pageStack.length; i++) {
    if (ROTT_UI_Page_Party_Selection(pageStack[i]) != none) {
      ROTT_UI_Page_Party_Selection(pageStack[i]).previousAvailableHero();
      return;
    }
  }
}

/*=============================================================================
 * nextAvailableHero()
 *
 * 
 *===========================================================================*/
public function nextAvailableHero() {
  local int i;
  
  // Search pages for party selector
  for (i = 0; i < pageStack.length; i++) {
    if (ROTT_UI_Page_Party_Selection(pageStack[i]) != none) {
      ROTT_UI_Page_Party_Selection(pageStack[i]).nextAvailableHero();
      return;
    }
  }
}

/*=============================================================================
 * pushPageByTag()
 *
 * Finds a page, and pushes it to the stack
 *===========================================================================*/
public function pushPageByTag(string pageTag, optional bool bFocused = true) {
  local int i;
  
  for (i = 0; i < pageComponents.length; i++) {
    if (pageComponents[i].tag == pageTag) pushPage(pageComponents[i], bFocused);
  }
}

/*=============================================================================
 * pushPage()
 *
 * Adds an element to the top of the stack
 *===========================================================================*/
public function pushPage
(
  UI_Page pageComponent,
  optional bool bFocusMenu = true
) 
{
  local int i;
  
  // Filter out bad requests
  if (ROTT_UI_Page(pageComponent) == none) { 
    yellowLog("Warning: Pushing null page reference"); 
    return;
  }
  
  pageStack.addItem(ROTT_UI_Page(pageComponent));  // Push new page to top.
  pageComponent.setEnabled(true);    // Enable new top.
  pageComponent.onPushPageEvent();   // Event triggered for newly pushed page
  
  // Populate cull tags
  for (i = 0; i < pageComponent.cullTags.length; i++) {
    cullTag(pageComponent.cullTags[i], pageComponent);
  }
  
  if (bFocusMenu == true) {
    // Update controller
    setControlComponent(ROTT_UI_Page(pageComponent));
    
    if (focusedIndex != -1) {
      // Unfocus previous menu
      pageStack[focusedIndex].unfocusMenu();
    }
  
    // Focus the new menu
    focusedIndex = pageStack.length - 1;
    pageStack[focusedIndex].focusMenu();
  }
  
  darkGreenLog("pushPage()", DEBUG_UI_PAGES);
  
  debugPageStack();
  
  // Pause controls
  if (pageComponent.bPauseGameWhenUp) {
    gameInfo.pauseGame();
  }
}

/*=============================================================================
 * popPage()
 *
 * Removes the top element from the stack (LIFO)
 *===========================================================================*/
public function popPage(optional string tag = "") {
  local int index;
  local bool bPageFound;
  local int i;
  
  // Check if there are no pages to pop
  if (pageStack.length == 0) {
    yellowLog("Warning (!) Cannot pop an empty pageStack.");
    return;
  }
  
  // Look for specific tag if one was given
  index = pageStack.length - 1;
  if (tag != "") {
    bPageFound = false;
    for (i = pageStack.length - 1; i >= 0; i--) {
      if (pageStack[i].tag == tag) {
        // Remove page
        index = i;
        bPageFound = true;
      }
    }
    if (!bPageFound) { yellowLog("Warning (!) Page not found for popPage(): " $ tag); return; }
  }
  
  // Update the focused index
  if (pageStack.length > 1) {
    // Shift index back if we are popping the focused page (or any page beneath it)
    if (index <= focusedIndex) {
      focusedIndex--;
    }
  } else {
    focusedIndex = -1;
  }
  
  // Call pop event
  pageStack[index].onPopPageEvent();
  pageStack[index].clearTempUI();
  
  // Remove cull tags
  uncullTag(pageStack[index]);
  
  // Disable and remove the top page
  pageStack[index].setEnabled(false);  
  pageStack.remove(index, 1); 
  
  if (pageStack.length > 0) {
    // Enable the new top page
    if (focusedIndex == pageStack.length - 1) {
      pageStack[pageStack.length - 1].focusMenu(); 
    }
    pageStack[pageStack.length - 1].setEnabled(true); 
  
    // Update the controller component based on focus
    if (focusedIndex != -1) {
      setControlComponent(pageStack[focusedIndex]);
    }
  }
  
  // Pop queue
  if (popQueue > 0) {
    popQueue--;
    popPage();
  }
  
  darkGreenLog("popPage()", DEBUG_UI_PAGES);
  
  debugPageStack();
  
}

/*=============================================================================
 * cullTag()
 *
 * Prevents the given tag from being drawn
 *===========================================================================*/
public function cullTag(string targetTag, UI_Component source) {
  local int i;
  
  for (i = 0; i < pageComponents.length; i++) {
    if (pageComponents[i] != none) {
      pageComponents[i].cullTag(targetTag, source);
    }
  }
}

/*=============================================================================
 * uncullTag()
 *
 * Removes a cull for the given tag.  (There may be more than one cull)
 *===========================================================================*/
public function uncullTag(UI_Component source) {
  local int i;
  
  for (i = 0; i < pageComponents.length; i++) {
    if (pageComponents[i] != none) {
      pageComponents[i].uncullTag(source);
    }
  }
}

/*=============================================================================
 * queuePop()
 *
 * Increases the number of pages to pop on the next popPage() call
 *===========================================================================*/
public function queuePop() {
  popQueue++;
}

/*=============================================================================
 * popAllPages()
 *
 * Used to empty the pagestack for this scene
 *===========================================================================*/
public function popAllPages() {
  while (pageStack.length > 0) {
    popPage();
  }
}

/*=============================================================================
 * setControlComponent()
 *
 * The specified page will be in charge of parsing the players input
 *===========================================================================*/
public function setControlComponent(ROTT_UI_Page newController) {
  inputControlComponent = newController;
  
  cyanlog(newController, DEBUG_UI_CONTROLLERS);
}

/*=============================================================================
 * focusTop()
 *
 * Sets focus on the topmost page
 *===========================================================================*/
public function focusTop() {
  if (focusedIndex == pageStack.length - 1) {
    yellowlog("Warning (!) This page is already focused.");
    return;
  }
  
  // Ignore if top is already focused
  if (pageStack.length - 1 == focusedIndex) return;
  
  // Unfocus previous page
  pageStack[focusedIndex].unfocusMenu();
  
  // Focus top
  focusedIndex = pageStack.length - 1;
  pageStack[focusedIndex].focusMenu();
  
  // Set controls
  setControlComponent(pageStack[focusedIndex]);
  
  darkGreenLog("focusTop()", DEBUG_UI_PAGES);
  
  // Debug
  debugPageStack();
}
 
/*=============================================================================
 * focusBack()
 *
 * Sets focus on previous page
 *===========================================================================*/
public function focusBack() {
  // Event handling
  pageStack[focusedIndex].unfocusMenu();
  focusedIndex--;
  pageStack[focusedIndex].focusMenu();
  
  // Set controls
  setControlComponent(pageStack[focusedIndex]);
}
 
/*=============================================================================
 * overrideCamera
 *
 * Sets camera override position and rotation
 *===========================================================================*/
public function overrideCamera(vector camLocation, rotator camRotator) {
  overrideCamLoc = camLocation;
  overrideCamRot = camRotator;
  gameInfo.tempestPawn.overrideCamera(overrideCamLoc, overrideCamRot);
  
  /// sloppy, why is camera info stored in both scene and pawn?
}

/*=============================================================================
 * elapseTimers()
 *
 * Provides a sense of time to each n UI component
 *===========================================================================*/
final public function elapseTimers(float deltaTime) {
  local int i;
  
  /// the fuck is going on here why is the time scaled differently?
  
  // Enable time for the whole stack
  for (i = 0; i < pageStack.length; i++) {
    pageStack[i].elapseTimers(deltaTime);
  }
  
  // Enable time for "global" scene components
  for (i = 0; i < uiComponents.length; i++) {
    uiComponents[i].elapseTimer(deltaTime, gameInfo.gameSpeed);
  }
  
  elapseTimer(deltaTime, gameInfo.gameSpeed);
}

/*=============================================================================
 * elapseTimer()
 *
 * Increments time every engine tick.
 *===========================================================================*/
public function elapseTimer(float deltaTime, float gameSpeedOverride) {
  if (bCaching) bCaching = UI_Sprite(findComp("Sprite_Cacher")).drawNextFrame();
}

/*=============================================================================
 * isNotInitialized()
 *
 * Returns true if this scene needs initialization
 *===========================================================================*/
public function bool isNotInitialized() {
  return (!bInitComplete);
}

/*=============================================================================
 * topPage()
 *
 * Returns the top page
 *===========================================================================*/
public function ROTT_UI_Page topPage() {
  return pageStack[pageStack.length - 1] ;
}

/*=============================================================================
 * transitionCompletion()
 *
 * Called by a transition page when it completes a transition animation
 *===========================================================================*/
public function transitionCompletion(string transitionTag);







/*=============================================================================
 * getSelectedParty()
 *
 * Returns a party selected from a party list
 *===========================================================================*/
public function ROTT_Party getSelectedParty() {
  if (selectedParty == none) {
    yellowLog("Warning (!) No party selection found");
    return none;
  }
  return selectedParty;
}


/*=============================================================================
 * getSelectedHero()
 *
 * Returns a hero selected by whichever active selector can be found.
 *===========================================================================*/
public function ROTT_Combat_Hero getSelectedHero() {
  if (selectedHero == none) {
    ///yellowLog("Warning (!) No hero selection found");
    ///scriptTrace();
    return none;
  }
  return selectedHero;
}

/**=============================================================================
 * getSelectedSkill()
 *
 * Returns a skill that has been selected in the skilltree
 *===========================================================================*/
public function byte getSelectedSkill() {
  local int i;
  
  // Search pages for party selector
  for (i = 0; i < pageStack.length; i++) {
    if (ROTT_UI_Page_Hero_Tree_Info(pageStack[i]) != none) {
      return ROTT_UI_Page_Hero_Tree_Info(pageStack[i]).getSkillID();
    }
  }
  
  yellowLog("Warning (!) Failed to find class<ROTT_UI_Page_Hero_Tree_Info> on " $ self);
  return 0;
}

/**=============================================================================
 * getSelectedStat()
 *
 * Returns a stat that has been selected in the menu (Vitality, Strength, etc)
 *===========================================================================*/
public function byte getSelectedStat() {
  local int index, i;
  
  // Search pages for party selector
  for (i = 0; i < pageStack.length; i++) {
    if (ROTT_UI_Stats_Selector(pageStack[i].findComp("Stats_Selector")) != none) {
      index = ROTT_UI_Stats_Selector(pageStack[i].findComp("Stats_Selector")).getSelection();
      return index;
    }
  }
  
  yellowLog("Warning (!) Failed to find \"Stats_Selector\" on " $ self);
  return 0;
}

/**=============================================================================
 * getStatSelector()
 *
 * Returns the stat selector
 *===========================================================================*/
public function ROTT_UI_Stats_Selector getStatSelector() {
  local int i;
  
  // Search pages for party selector
  for (i = 0; i < pageStack.length; i++) {
    if (ROTT_UI_Stats_Selector(pageStack[i].findComp("Stats_Selector")) != none) {
      return ROTT_UI_Stats_Selector(pageStack[i].findComp("Stats_Selector"));
    }
  }
  
  yellowLog("Warning (!) Failed to find \"Stats_Selector\" on " $ self);
  return none;
}

/**=============================================================================
 * getSkillSelector()
 *
 * Returns the skill selector
 *===========================================================================*/
public function UI_Tree_Selector getSkillSelector() {
  local int i;
  
  // Search pages for party selector
  for (i = 0; i < pageStack.length; i++) {
    if (UI_Tree_Selector(pageStack[i].findComp("Skill_Selector")) != none) {
      return UI_Tree_Selector(pageStack[i].findComp("Skill_Selector"));
    }
  }
  
  yellowLog("Warning (!) Failed to find \"Skill_Selector\" on " $ self);
  return none;
}

/**============================================================================= 
 * getSelectedtree()
 *
 * Returns the index for what skill tree is up on the HUD.
 *===========================================================================*/
public function byte getSelectedtree() {
  local int i;
  
  debugPageStack();
  
  // Scan for tree
  for (i = 0; i < pageStack.length; i++) {
    switch (pageStack[i].tag) {
      case "Class_Skilltree_UI": return 0;
      case "Glyph_Skilltree_UI": return 1;
      case "Mastery_Skilltree_UI": return 2;
    }
  }
  
  yellowLog("Warning (!) No skill tree found during lookup.");
  return -1;
}
/// 
/// 
/// 
/// 
/// 
/// 
/// 
/// 
/// 
/// 
/// 
/// 
/// 
/// 
/// 
/// 
/// 
/// 
/// 
/// 
/// 
/// 
/// 
/// 
/// 
/// /*=============================================================================
///  * getSelectedParty()
///  *
///  * Returns a party selected from a party list
///  *===========================================================================*/
/// public function ROTT_Party getSelectedParty() {
///   local ROTT_Party selectedParty;
///   local int i;
///   
///   // Scan through selected components
///   selectedParty = ROTT_Party(findSelectedObject(class'ROTT_Party'));
///   if (selectedParty != none) return selectedParty;
///   
///   // Look up in scene manager?
///   /* to do...*/
///   
///   // No party found
///   return none;
/// }
/// 
/// /*=============================================================================
///  * getSelectedHero()
///  *
///  * Returns a hero selected by whichever active selector can be found.
///  *===========================================================================*/
/// public function ROTT_Combat_Hero getSelectedHero() {
///   local ROTT_Combat_Hero hero;
///   local int i;
///   
///   // Scan through selected components
///   hero = ROTT_Combat_Hero(findSelectedObject(class'ROTT_Combat_Hero'));
///   if (hero != none) return hero;
///   
///   // Look up in scene manager?
///   /* to do...*/
///   
///   // No party found
///   return none;
/// }
/// 









/*=============================================================================
 * onSelectObject()
 *
 * Called after a new selection has been made.
 *===========================================================================*/
protected function onSelectObject(object selectedObject) {
  switch (selectedObject.class) {
    case class'ROTT_Party':
      selectedParty = ROTT_Party(selectedObject);
      break;
    case class'ROTT_Combat_Hero_Valkyrie':
    case class'ROTT_Combat_Hero_Wizard':
    case class'ROTT_Combat_Hero_Goliath':
    case class'ROTT_Combat_Hero_Titan':
      selectedHero = ROTT_Combat_Hero(selectedObject);
      break;
  }
}


























/*=============================================================================
 * deleteScene()
 *
 * Deletes scene references for garbage collection
 *===========================================================================*/
public function deleteScene() {
  local int i;
  
  // Remove external references
  gameInfo = none;
  sfxBox = none;
  jukeBox = none;

  // Remove all page references from scene
  pageStack.Remove(0, pageStack.Length);
  
  inputControlComponent = none;
  sceneManager = none;
  
  // Delete children
  for (i = pageComponents.length - 1; i >= 0; i--) {
    pageComponents[i].deleteComp();
  }
  
}

/*=============================================================================
 * debugPageStack()
 *
 * Prints the stack to the console
 *===========================================================================*/
public function debugPageStack() {
  local int i;
  
  grayLog("[" $ self $ "] Page stack:", DEBUG_UI_PAGES);
  for (i = 0; i < pageStack.length; i++) {
    if (focusedIndex == i) {
      greenlog("  " $ pageStack[i].tag, DEBUG_UI_PAGES);
    } else {
      darkGreenlog("  " $ pageStack[i].tag, DEBUG_UI_PAGES);
    }
  }
  grayLog(" ", DEBUG_UI_PAGES);
}

/*=============================================================================
 * debugDataStructure()
 * 
 * Dumps most of the data structure to the console log when called
 * (Note: excludes player profile, see DEBUG_PLAYER_PROFILE instead)
 *===========================================================================*/
public function debugDataStructure() {
  local int i;  
  
  greenLog("  Scene: (" $ self $ ")", DEBUG_DATA_STRUCTURE);
  greenLog("    UI Components:", DEBUG_DATA_STRUCTURE);
  if (uiComponents.length == 0) darkGreenLog("      none", DEBUG_DATA_STRUCTURE);
  for (i = 0; i < uiComponents.length; i++) {
    darkGreenLog("      " $ uiComponents[i], DEBUG_DATA_STRUCTURE);
  }
  greenLog("    Page Components:", DEBUG_DATA_STRUCTURE);
  if (pageComponents.length == 0) darkGreenLog("      none", DEBUG_DATA_STRUCTURE);
  for (i = 0; i < pageComponents.length; i++) {
    darkGreenLog("      " $ pageComponents[i], DEBUG_DATA_STRUCTURE);
  }
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  // Player controls
  bAllowOverWorldControl=false
  
  // Camera controls
  bOverrideCamera=false
  overrideCamLoc=(x=0.0,y=0.0,z=0.0)
  
  
  // Cache block
  begin object class=UI_Sprite Name=Sprite_Cacher
    tag="Sprite_Cacher"
    bEnabled=true
    posX=-50
    posY=-50
    posXEnd=-49
    posYend=-49
    images(0)=none
  end object
  uiComponents.add(Sprite_Cacher)
  
}





















