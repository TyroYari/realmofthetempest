/*=============================================================================
 * ROTT_UI_Scene_Game_Menu
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This class handles the UI and controls for the in-game menu.
 *===========================================================================*/
 
class ROTT_UI_Scene_Game_Menu extends ROTT_UI_Scene;
 
/** ============================== **/

enum GameMenuPages {
  
  LEFT_GAME_MENU,
  UTILITY_MENU,
  PARTY_SELECTION,
  PAGE_SELECTION,
  STATS_INSPECTION,
  CLASS_SKILLTREE,
  GLYPH_SKILLTREE,
  MASTERY_SKILLTREE,
  
  MGMT_WINDOW_ITEM,
  MGMT_WINDOW_STATS,
  MGMT_WINDOW_SKILLS,
  MGMT_WINDOW_PASSIVE,
  MGMT_WINDOW_COLLECT,
  MGMT_WINDOW_BLANK,
  
  INVENTORY_MENU,
  
  REINVEST_STAT_MENU,
  REINVEST_SKILL_MENU,
  HYPER_SKILLTREE,
  
  ARTIFACT_COLLECTION,
  
  PROFILE_SCREEN,
  GUIDE_SCREEN,
};

/** ============================== **/

// Cache descriptor
var private ROTT_Descriptor_Hero_Skill lastDescriptor;

// Internal menu references
var privatewrite ROTT_UI_Page_Game_Menu leftGameMenu;
var privatewrite ROTT_UI_Page_Utility_Menu utilityMenu;
var privatewrite ROTT_UI_Page_Party_Selection partySelection;
var privatewrite ROTT_UI_Page_Stats_Inspection statsInspection;
var privatewrite ROTT_UI_Page_Class_Skilltree classSkilltree;
var privatewrite ROTT_UI_Page_Glyph_Skilltree glyphSkilltree;
var privatewrite ROTT_UI_Page_Mastery_Skilltree masterySkilltree;

var privatewrite ROTT_UI_Page_Preview_Window_Item previewWindowItem;

var privatewrite ROTT_UI_Page_Mgmt_Window_Item mgmtWindowItem;
var privatewrite ROTT_UI_Page_Mgmt_Window_Stats mgmtWindowStats;
var privatewrite ROTT_UI_Page_Mgmt_Window_Skills mgmtWindowSkills;
var privatewrite ROTT_UI_Page_Mgmt_Window_Passive mgmtWindowPassive;
var privatewrite ROTT_UI_Page_Mgmt_Window_Collectible mgmtWindowCollect;
var privatewrite ROTT_UI_Page_Mgmt_Window_Blank mgmtWindowBlank;

var privatewrite ROTT_UI_Page_Inventory inventoryPage;
var privatewrite ROTT_UI_Page_Reset_Stat resetStatMenu;
var privatewrite ROTT_UI_Page_Reset_Skill resetSkillMenu;
var privatewrite ROTT_UI_Page_Reset_Skill_Preview resetSkillPreview;
var privatewrite ROTT_UI_Page_Hyper_Skilltree hyperSkilltree;
var privatewrite ROTT_UI_Page_Equip_Select equipSelectPage;

var private ROTT_UI_Page_Enchantments enchantmentsPage;

var private ROTT_UI_Page_Profile profilePage;
var private ROTT_UI_Page_Guide guidePage;

// Additional navigation graphics
var private UI_Sprite pageNavigationArrows;
var private UI_Texture_Storage itemCacher;

// Navigation mechanics
var private bool bNavigateToNewStats;

/*=============================================================================
 * initScene()
 *
 * Called when this scene is created
 *===========================================================================*/
event initScene() {
  super.initScene();
  
  // Internal menu references
  leftGameMenu = ROTT_UI_Page_Game_Menu(findComp("Page_Game_Menu"));
  utilityMenu = ROTT_UI_Page_Utility_Menu(findComp("Utility_Menu_UI"));
  partySelection = ROTT_UI_Page_Party_Selection(findComp("Party_Selection_UI"));
  statsInspection = ROTT_UI_Page_Stats_Inspection(findComp("Stats_Inspection_UI"));
  classSkilltree = ROTT_UI_Page_Class_Skilltree(findComp("Class_Skilltree_UI"));
  glyphSkilltree = ROTT_UI_Page_Glyph_Skilltree(findComp("Glyph_Skilltree_UI"));
  masterySkilltree = ROTT_UI_Page_Mastery_Skilltree(findComp("Mastery_Skilltree_UI"));
  
  previewWindowItem = ROTT_UI_Page_Preview_Window_Item(findComp("Preview_Window_Item"));
  
  mgmtWindowItem = ROTT_UI_Page_Mgmt_Window_Item(findComp("Mgmt_Window_Item"));
  mgmtWindowStats = ROTT_UI_Page_Mgmt_Window_Stats(findComp("Mgmt_Window_Stats"));
  mgmtWindowSkills = ROTT_UI_Page_Mgmt_Window_Skills(findComp("Mgmt_Window_Skills"));
  mgmtWindowPassive = ROTT_UI_Page_Mgmt_Window_Passive(findComp("Mgmt_Window_Passive"));
  mgmtWindowCollect = ROTT_UI_Page_Mgmt_Window_Collectible(findComp("Mgmt_Window_Collect"));
  mgmtWindowBlank = ROTT_UI_Page_Mgmt_Window_Blank(findComp("Mgmt_Window_Blank"));
  
  inventoryPage = ROTT_UI_Page_Inventory(findComp("Inventory_UI"));
  resetStatMenu = ROTT_UI_Page_Reset_Stat(findComp("Reinvest_Stat_UI"));
  resetSkillMenu = ROTT_UI_Page_Reset_Skill(findComp("Reinvest_Skill_UI"));
  resetSkillPreview = ROTT_UI_Page_Reset_Skill_Preview(findComp("Reset_Skill_Preview_UI"));
  hyperSkilltree = ROTT_UI_Page_Hyper_Skilltree(findComp("Hyper_Skilltree_UI"));
  equipSelectPage = ROTT_UI_Page_Equip_Select(findComp("Equip_Select_UI"));
  
  enchantmentsPage = ROTT_UI_Page_Enchantments(findComp("Page_Enchantment_Collection"));
  
  profilePage = ROTT_UI_Page_Profile(findComp("Page_Profile"));
  guidePage = ROTT_UI_Page_Guide(findComp("Page_Guide"));
  
  // Navigation assets
  pageNavigationArrows = UI_Sprite(findComp("Page_Navigation_Arrow_Sprite"));
  itemCacher = UI_Texture_Storage(findComp("Item_Cacher"));
  cacheItems();
  
  // Initial page stack
  pushMenu(LEFT_GAME_MENU);  
}

/*=============================================================================
 * cacheItems()
 *
 * Called to initialize item textures
 *===========================================================================*/
private function cacheItems() {
  local UI_Texture_Info textureInfo;
  local int i;
  
  // Cache all loot types
  for (i = 0; i < gameInfo.lootTypes.length; i++) {
    textureInfo = new class'UI_Texture_Info';
    textureInfo.componentTextures.addItem(gameInfo.lootTypes[i].default.itemTexture);
    textureInfo.initializeInfo();
    
    itemCacher.addTexture(textureInfo);
  }
}

/*=============================================================================
 * loadScene()
 *
 * Called every time the menu is opened
 *===========================================================================*/
event loadScene() {
  super.loadScene();
  
  if (pageStack.length == 0) {
    pushMenu(LEFT_GAME_MENU);
  }
  
  if (bNavigateToNewStats) {
    bNavigateToNewStats = false;
    
    // Push party selection
    pushMenu(PARTY_SELECTION);
    
    // Auto select first hero with unspent stats
    partySelection.navToNewStats();
    
    // Push stats page
    pushMenu(STATS_INSPECTION);
  }
  
  cacheTextures(itemCacher);
}

/*=============================================================================
 * unloadScene()
 * 
 * Called when this scene will no longer be rendered.  Each page receives
 * a call for the onSceneDeactivation() event
 *===========================================================================*/
event unloadScene() {
  super.unloadScene();
}

/*============================================================================= 
 * refresh()
 *
 * This function should ensure that any data thats been changed will be 
 * correctly updated on the UI.
 *===========================================================================*/
public function refresh() {
  super.refresh();
  
  if (lastDescriptor != none) {
    lastDescriptor.refresh();
    setMgmtDescriptor(lastDescriptor);
  }
}

/*============================================================================= 
 * closeGameMenu()
 *
 * This is called when the entire menu is closed.
 *===========================================================================*/
public function closeGameMenu() {
  // Should probably pass this through everywhere as an event, but for now~
  leftGameMenu.resetSelector();
}

/*============================================================================= 
 * switchPage()
 *
 * This pops the current page, and pushes a new one.
 *===========================================================================*/
public function switchPage(GameMenuPages scene) {
  // Remove top page
  popPage();
  
  // Then replace with specified page
  pushMenu(scene);
}

/*============================================================================= 
 * updateItemWindow()
 *
 * Shows preview information for a given item
 *===========================================================================*/
public function updateItemWindow(ROTT_Descriptor descriptor) {
  // Ignore if window is not up
  if (!pageIsUp(previewWindowItem)) return;
  
  // Set descriptor
  previewWindowItem.setDescriptor(descriptor);
}

/*============================================================================= 
 * toggleSideItemWindow()
 *
 * This pushes a menu page, giving it focus and control.
 *===========================================================================*/
public function toggleSideItemWindow
(
  ROTT_Descriptor descriptor,
  optional int yOffset = 0
) 
{
  // Hide if window is already up
  if (pageIsUp(previewWindowItem)) {
    popPage(previewWindowItem.tag);
    return;
  }
  
  // Show item preview
  pushPage(previewWindowItem, false);
  
  // Move to right side
  previewWindowItem.updatePosition(yOffset, , , );
  
  // Set descriptor
  previewWindowItem.setDescriptor(descriptor);
}

/*============================================================================= 
 * pushMenu()
 *
 * This pushes a menu page, giving it focus and control.
 *===========================================================================*/
public function pushMenu(GameMenuPages menu) {
  // Push new menu to the stack
  switch (menu) {
    case LEFT_GAME_MENU:            pushPage(leftGameMenu);         break;
    case UTILITY_MENU:              pushPage(utilityMenu);          break;
    case STATS_INSPECTION:          pushPage(statsInspection);      break;
    case CLASS_SKILLTREE:           pushPage(classSkilltree);       break;
    case GLYPH_SKILLTREE:           pushPage(glyphSkilltree);       break;
    case MASTERY_SKILLTREE:         pushPage(masterySkilltree);     break;
    
    case INVENTORY_MENU:            pushPage(inventoryPage);        break;
    case PROFILE_SCREEN:            pushPage(profilePage);          break;
    case GUIDE_SCREEN:              pushPage(guidePage);            break;
    
    // Push without focus
    case MGMT_WINDOW_ITEM:    pushPage(mgmtWindowItem, false);      break;
    case MGMT_WINDOW_STATS:   pushPage(mgmtWindowStats, false);     break;
    case MGMT_WINDOW_SKILLS:  pushPage(mgmtWindowSkills, false);    break;
    case MGMT_WINDOW_PASSIVE: pushPage(mgmtWindowPassive, false);   break;
    case MGMT_WINDOW_COLLECT: pushPage(mgmtWindowCollect, false);   break;
    case MGMT_WINDOW_BLANK:   pushPage(mgmtWindowBlank, false);     break;
    case PARTY_SELECTION:     
      pushPage(partySelection);  
      partySelection.setNavMode(DEFAULT_NAVIGATION); 
      break;
    case REINVEST_STAT_MENU:  
      pushPage(partySelection);
      partySelection.setNavMode(RESET_STAT_NAVIGATION);
      pushPage(resetStatMenu, false);       
      break;
    case REINVEST_SKILL_MENU: 
      pushPage(partySelection);
      partySelection.setNavMode(RESET_SKILL_NAVIGATION);
      pushPage(resetSkillMenu, false);      
      break;
      
    case HYPER_SKILLTREE:     
      pushPage(hyperSkilltree);
      pushMenu(MGMT_WINDOW_BLANK);     
      break;
    
    case ARTIFACT_COLLECTION: pushPage(enchantmentsPage);       
      break;
  } 
}

/*============================================================================= 
 * setMgmtDescriptor()
 *
 * This assigns a descriptor to the mgmt window, updating the text displayed
 * by it
 *===========================================================================*/
public function setMgmtDescriptor(ROTT_Descriptor descriptor) {
  // Caching
  lastDescriptor = ROTT_Descriptor_Hero_Skill(descriptor);
  
  // Assignment
  if (ROTT_Descriptor_Item(descriptor) != none) {
    if (mgmtWindowItem == none) return;
    mgmtWindowItem.setDescriptor(descriptor);
    return;
  }
  if (ROTT_Descriptor_Stat(descriptor) != none) {
    if (mgmtWindowStats == none) return;
    mgmtWindowStats.setDescriptor(descriptor);
    return;
  }
  mgmtWindowSkills.setDescriptor(descriptor);
  mgmtWindowPassive.setDescriptor(descriptor);
  mgmtWindowCollect.setDescriptor(descriptor);
  mgmtWindowBlank.setDescriptor(descriptor);
}

/*============================================================================= 
 * enableCreationMode()
 *
 * Sets the game menu into creation mode
 *===========================================================================*/
public function enableCreationMode() {
  local int i;
  
  for (i = 0; i < pageStack.length - 1; i++) {
    popPage();
  }
  leftGameMenu.setCreationMode();
}

/*============================================================================= 
 * enablePageArrows()
 *===========================================================================*/
public function enablePageArrows(bool bEnabledState) {
  if (pageNavigationArrows != none) {
    pageNavigationArrows.setEnabled(bEnabledState);
  }
}

/*============================================================================= 
 * previousHero()
 *===========================================================================*/
public function previousHero() {
  partySelection.heroSelector.previousSelection();
}
 
/*============================================================================= 
 * nextHero()
 *===========================================================================*/
public function nextHero() {
  partySelection.heroSelector.nextSelection();
}
 
/*============================================================================= 
 * getSelectedStat()
 *===========================================================================*/
public function byte getSelectedStat() {
  return statsInspection.getSelectedStat();
}
 
/*=============================================================================
 * transitionToHeroStats()
 *
 * Called before this scene is reached, to set up navigation to new hero 
 * stats/skill points of a hero that leveled up.
 *===========================================================================*/
public function transitionToHeroStats() {
  bNavigateToNewStats = true;
}

/*============================================================================= 
 * Assets
 *===========================================================================*/
defaultProperties
{
  // Scene frame
  begin object class=ROTT_UI_Screen_Frame Name=Screen_Frame
    tag="Screen_Frame"
    bEnabled=true
  end object
  uiComponents.add(Screen_Frame)
  
  /** ===== Textures ===== **/
  // Page navigation arrows
  begin object class=UI_Texture_Info Name=Menu_Navigation_Arrows_LR
    componentTextures.add(Texture2D'GUI.Menu_Navigation_Arrows_LR')
  end object
  
  /** ===== Page Components ===== **/
  // Game Menu Page
  begin object class=ROTT_UI_Page_Game_Menu Name=Page_Game_Menu
    tag="Page_Game_Menu"
    bEnabled=true
  end object
  pageComponents.add(Page_Game_Menu)
  
  // Utility Menu
  begin object class=ROTT_UI_Page_Utility_Menu Name=Utility_Menu_UI
    tag="Utility_Menu_UI"
  end object
  pageComponents.add(Utility_Menu_UI)
  
  // Party selection Menu
  begin object class=ROTT_UI_Page_Party_Selection Name=Party_Selection_UI
    tag="Party_Selection_UI"
  end object
  pageComponents.add(Party_Selection_UI)
  
  // Stats Inspection Menu
  begin object class=ROTT_UI_Page_Stats_Inspection Name=Stats_Inspection_UI
    tag="Stats_Inspection_UI"
  end object
  pageComponents.add(Stats_Inspection_UI)
  
  // Class Skilltree UI
  begin object class=ROTT_UI_Page_Class_Skilltree Name=Class_Skilltree_UI
    tag="Class_Skilltree_UI"
  end object
  pageComponents.add(Class_Skilltree_UI)
  
  // Glyph Skilltree UI
  begin object class=ROTT_UI_Page_Glyph_Skilltree Name=Glyph_Skilltree_UI
    tag="Glyph_Skilltree_UI"
  end object
  pageComponents.add(Glyph_Skilltree_UI)
  
  // Mastery Skilltree UI
  begin object class=ROTT_UI_Page_Mastery_Skilltree Name=Mastery_Skilltree_UI
    tag="Mastery_Skilltree_UI"
  end object
  pageComponents.add(Mastery_Skilltree_UI)
  
  // Inventory UI
  begin object class=ROTT_UI_Page_Inventory Name=Inventory_UI
    tag="Inventory_UI"
  end object
  pageComponents.add(Inventory_UI)
  
  // Reinvest Stat UI
  begin object class=ROTT_UI_Page_Reset_Stat Name=Reinvest_Stat_UI
    tag="Reinvest_Stat_UI"
  end object
  pageComponents.add(Reinvest_Stat_UI)
  
  // Reinvest Stat UI
  begin object class=ROTT_UI_Page_Mgmt_Window_Reset_Stats Name=Reset_Stat_Manager_UI
    tag="Reset_Stat_Manager_UI"
  end object
  pageComponents.add(Reset_Stat_Manager_UI)
  
  // Reinvest Skill UI
  begin object class=ROTT_UI_Page_Reset_Skill Name=Reinvest_Skill_UI
    tag="Reinvest_Skill_UI"
  end object
  pageComponents.add(Reinvest_Skill_UI)
  
  // Reinvest Skill Manager UI
  begin object class=ROTT_UI_Page_Mgmt_Window_Reset_Skills Name=Reset_Skill_Manager_UI
    tag="Reset_Skill_Manager_UI"
  end object
  pageComponents.add(Reset_Skill_Manager_UI)
  
  // Reinvest Skill Preview UI
  begin object class=ROTT_UI_Page_Reset_Skill_Preview Name=Reset_Skill_Preview_UI
    tag="Reset_Skill_Preview_UI"
    bDrawRelative=true
    posx=720
  end object
  pageComponents.add(Reset_Skill_Preview_UI)
  
  // Hyper Skilltree UI
  begin object class=ROTT_UI_Page_Hyper_Skilltree Name=Hyper_Skilltree_UI
    tag="Hyper_Skilltree_UI"
  end object
  pageComponents.add(Hyper_Skilltree_UI)
  
  // Equip Select UI
  begin object class=ROTT_UI_Page_Equip_Select Name=Equip_Select_UI
    tag="Equip_Select_UI"
  end object
  pageComponents.add(Equip_Select_UI)
  
  // Item Preview Window
  begin object class=ROTT_UI_Page_Preview_Window_Item Name=Preview_Window_Item
    tag="Preview_Window_Item"
  end object
  pageComponents.add(Preview_Window_Item)
  
  // Item Management Window
  begin object class=ROTT_UI_Page_Mgmt_Window_Item Name=Mgmt_Window_Item
    tag="Mgmt_Window_Item"
  end object
  pageComponents.add(Mgmt_Window_Item)
  
  // Stat Management Window
  begin object class=ROTT_UI_Page_Mgmt_Window_Stats Name=Mgmt_Window_Stats
    tag="Mgmt_Window_Stats"
  end object
  pageComponents.add(Mgmt_Window_Stats)
  
  // Skill Management Window
  begin object class=ROTT_UI_Page_Mgmt_Window_Skills Name=Mgmt_Window_Skills
    tag="Mgmt_Window_Skills"
  end object
  pageComponents.add(Mgmt_Window_Skills)
  
  // Skill Management Window (Passive)
  begin object class=ROTT_UI_Page_Mgmt_Window_Passive Name=Mgmt_Window_Passive
    tag="Mgmt_Window_Passive"
  end object
  pageComponents.add(Mgmt_Window_Passive)
  
  // Skill Management Window (Collectible)
  begin object class=ROTT_UI_Page_Mgmt_Window_Collectible Name=Mgmt_Window_Collect
    tag="Mgmt_Window_Collect"
  end object
  pageComponents.add(Mgmt_Window_Collect)
  
  // Blank Management Window
  begin object class=ROTT_UI_Page_Mgmt_Window_Blank Name=Mgmt_Window_Blank
    tag="Mgmt_Window_Blank"
  end object
  pageComponents.add(Mgmt_Window_Blank)
  
  // Enchantments Page
  begin object class=ROTT_UI_Page_Enchantments Name=Page_Enchantment_Collection
    tag="Page_Enchantment_Collection"
  end object
  pageComponents.add(Page_Enchantment_Collection)

  // Profile
  begin object class=ROTT_UI_Page_Profile Name=Page_Profile
    tag="Page_Profile"
  end object
  pageComponents.add(Page_Profile)

  // Guide
  begin object class=ROTT_UI_Page_Guide Name=Page_Guide
    tag="Page_Guide"
  end object
  pageComponents.add(Page_Guide)

  /** ===== UI Components ===== **/
  // Page Navigation Graphics
  begin object class=UI_Sprite Name=Page_Navigation_Arrow_Sprite
    tag="Page_Navigation_Arrow_Sprite"
    bEnabled=false
    posX=755
    posY=826
    images(0)=Menu_Navigation_Arrows_LR
    
    // Alpha Effects
    activeEffects.add((effectType = EFFECT_ALPHA_CYCLE, lifeTime = -1, elapsedTime = 0, intervalTime = 0.6, min = 200, max = 255))
    
  end object
  uiComponents.add(Page_Navigation_Arrow_Sprite)
  
  // Skill Animation Container
  begin object class=UI_Texture_Storage Name=Item_Cacher
    tag="Item_Cacher"
  end object
  uiComponents.add(Item_Cacher)
  
}



























