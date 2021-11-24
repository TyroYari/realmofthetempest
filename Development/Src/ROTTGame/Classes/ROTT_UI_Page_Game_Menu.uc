/*=============================================================================
 * ROTT_UI_Page_Game_Menu
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This class handles the leftside of the game menu.
 *===========================================================================*/
 
class ROTT_UI_Page_Game_Menu extends ROTT_UI_Page;

/** ============================== **/

enum LeftMenuGraphics {
  MENU_EMPTY_GRAPHIC,
  
  MENU_DEFAULT_GRAPHIC,
  MENU_CONFIRM_GRAPHIC,
  MENU_REINVEST_STAT_GRAPHIC,
  MENU_REINVEST_SKILL_GRAPHIC
};

var private LeftMenuGraphics LeftMenuGraphic;

// Menu options
enum LeftGameMenuOptions {
  MENU_PARTY,
  MENU_UTILITIES,
  MENU_ARTIFACTS,
  MENU_GAME
};

enum CreationMenuOptions {
  MENU_INFO,
  MENU_CONFIRM
};

var private bool bCreationMode;

/** ============================== **/

// Internal references
var private UI_Selector menuSelector;
var private ROTT_UI_Party_Display partyDisplayer;
var private UI_Sprite menuBackground;

// Parent reference
var private ROTT_UI_Scene_Game_Menu someScene;

/*============================================================================= 
 * initializeComponent
 *
 * Called once, when the scene is first initialized.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  super.initializeComponent(newTag);
  
  someScene = ROTT_UI_Scene_Game_Menu(outer);
  
  // Get internal references
  menuBackground = findSprite("Menu_Background_Left");
  menuSelector = UI_Selector(findComp("Game_Menu_Selector"));
  partyDisplayer = ROTT_UI_Party_Display(findComp("Party_Displayer"));
  
  setMenuGraphic(MENU_DEFAULT_GRAPHIC);
}


/*============================================================================= 
 * resetSelector()
 *
 * This can be called by other scenes when they dont want the cursor preserved
 *===========================================================================*/
public function resetSelector() {
  // Reset selector info
  menuSelector.resetSelection();
}


/*============================================================================= 
 * setCreationMode
 *
 * This is called to limit the menu options to character creation mode.
 *===========================================================================*/
public function setCreationMode() {
  bCreationMode = true;
  setMenuGraphic(MENU_CONFIRM_GRAPHIC);
}

/*============================================================================= 
 * onPushPageEvent
 *
 * Description: This event is called every time the page is pushed.
 *===========================================================================*/
event onPushPageEvent() {
  partyDisplayer.syncIconEffects();
}

/*============================================================================= 
 * onSceneActivation
 *
 * Called every time the parent scene is loaded
 *===========================================================================*/
public function onSceneActivation() {
  // Render active party when game menu is opened
  partyDisplayer.renderParty(gameInfo.getActiveParty()); 
}

/*=============================================================================
 * onFocusMenu()
 *
 * Called when a menu is given focus.  Assign controls, and enable graphics.
 *===========================================================================*/
event onFocusMenu() {
  menuSelector.setActive(true);
}

/*=============================================================================
 * onUnfocusMenu()
 *
 * Called when the menu loses focus, but is not popped from the page stack.
 * Disable controls and update graphics accordingly.
 *===========================================================================*/
event onUnfocusMenu() {
  menuSelector.setActive(false);
}

/*============================================================================= 
 * refresh()
 *
 * Called to update info after investing skill points
 *===========================================================================*/
public function refresh() {
  partyDisplayer.renderParty(gameInfo.getActiveParty()); 
}

/*=============================================================================
 * setMenuGraphic()
 *
 * Changes the left menu graphic
 *===========================================================================*/
private function setMenuGraphic(LeftMenuGraphics newGraphic) {
  LeftMenuGraphic = newGraphic;
  menuBackground.setDrawIndex(newGraphic);
  
  switch (newGraphic) {
    case MENU_DEFAULT_GRAPHIC: 
      menuSelector.setNumberOfMenuOptions(4);
      break;
    case MENU_CONFIRM_GRAPHIC: 
      menuSelector.setNumberOfMenuOptions(2);
      break;
  }
}

/*=============================================================================
 * confirmCreation()
 *
 * Confirms a character class selection, and handles what happens next
 *===========================================================================*/
private function confirmCreation() {
  // Reset creation mode settings and graphics
  bCreationMode = false;
  setMenuGraphic(MENU_DEFAULT_GRAPHIC);
  
  // Reset character class selection page
  sceneManager.sceneCharacterCreation.characterCreationPage.resetSelection();
  
  if (partySystem.activePartySize() == 1) {
    // New active party index is set to this new party
    partySystem.setActiveParty(partySystem.getNumberOfParties() - 1);
    
    if (partySystem.getNumberOfParties() == 1) {
      // Go back to new game dialogue with NPC
      gameInfo.sceneManager.switchScene(SCENE_NPC_DIALOG);
      gameInfo.sceneManager.sceneNpcDialog.npcDialoguePage.npc.dialogTraversal(true);
    } else {
      // Remain in town after new party conscription
      
    }
  } else {
    // Update menu status to 'closed'
    gameInfo.closeGameMenu();
    parentScene.popPage();
  }
}

/*=============================================================================
 * Button controls
 *===========================================================================*/
protected function navigationRoutineA() {
  local LeftGameMenuOptions selection;
  local CreationMenuOptions altSelection;
  
  switch (bCreationMode) {
    case true:
      altSelection = CreationMenuOptions(menuSelector.getSelection());
      
      switch (altSelection) {
        case MENU_INFO:    someScene.pushMenu(PARTY_SELECTION);          break;
        case MENU_CONFIRM: confirmCreation();                              break;
      }
      break;
    case false:
      selection = LeftGameMenuOptions(menuSelector.getSelection());
      
      switch (selection) {
        case MENU_PARTY:     someScene.pushMenu(PARTY_SELECTION);        break;
        case MENU_UTILITIES: someScene.pushMenu(UTILITY_MENU);           break;
        case MENU_ARTIFACTS: someScene.pushMenu(ARTIFACT_COLLECTION);    break;
        case MENU_GAME:      sceneManager.switchScene(SCENE_GAME_MANAGER); break;
      }
      break;
  }
  
  // Sfx
  gameInfo.sfxBox.playSfx(SFX_MENU_ACCEPT);
}

protected function navigationRoutineB() {
  // Reset selector info
  resetSelector();
  
  switch (bCreationMode) {
    case false:
      // Update menu status to 'closed'
      gameInfo.closeGameMenu();
      break;
    case true:
      // Remove hero
      gameInfo.playerProfile.getActiveParty().removeHero();
      
      // Go back to class selection
      sceneManager.switchScene(SCENE_CHARACTER_CREATION);
      break;
  }
  parentScene.popPage();
  
  // Sfx
  gameInfo.sfxBox.playSfx(SFX_MENU_BACK);
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
  
  /** ===== Textures ===== **/
  // Left menu backgrounds
  begin object class=UI_Texture_Info Name=Menu_Background_Left_Confirm
    componentTextures.add(Texture2D'GUI.Menu_Background_Left_Confirm')
  end object
  begin object class=UI_Texture_Info Name=Menu_Background_Left_Texture
    componentTextures.add(Texture2D'GUI.Menu_Background_Left')
  end object
  
  // Rightside background
  begin object class=UI_Texture_Info Name=Menu_Background_Texture
    componentTextures.add(Texture2D'GUI.Game_Menu_Right_Side_Cover') 
  end object
  
  /** ===== UI Components ===== **/
  // Left background
  begin object class=UI_Sprite Name=Menu_Background_Left
    tag="Menu_Background_Left"
    bEnabled=true
    posX=0
    posY=0
    posXEnd=720
    posYEnd=NATIVE_HEIGHT
    images(MENU_DEFAULT_GRAPHIC)=Menu_Background_Left_Texture
    images(MENU_CONFIRM_GRAPHIC)=Menu_Background_Left_Confirm
  end object
  componentList.add(Menu_Background_Left)
  
  // Right background
  begin object class=UI_Sprite Name=Menu_Background_Right
    tag="Menu_Background_Right"
    bEnabled=true
    posX=720
    posY=0
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    images(0)=Menu_Background_Texture
  end object
  componentList.add(Menu_Background_Right)
  
  // Selection box
  begin object class=UI_Selector Name=Game_Menu_Selector
    tag="Game_Menu_Selector"
    bEnabled=true
    posX=17
    posY=50
    selectionOffset=(x=0,y=100)
    numberOfMenuOptions=4
    hoverCoords(0)=(xStart=17,yStart=50,xEnd=647,yEnd=136)
    hoverCoords(1)=(xStart=17,yStart=150,xEnd=647,yEnd=236)
    hoverCoords(2)=(xStart=17,yStart=250,xEnd=647,yEnd=336)
    hoverCoords(3)=(xStart=17,yStart=350,xEnd=647,yEnd=436)
    
    // Selection box
    begin object class=UI_Texture_Info Name=Selection_Box_Texture
      componentTextures.add(Texture2D'GUI.Menu_Selection_Box')
    end object

    // Selector sprite
    begin object class=UI_Sprite Name=Selector_Sprite
      tag="Selector_Sprite"
      images(0)=Selection_Box_Texture
      activeEffects.add((effectType=EFFECT_ALPHA_CYCLE, lifeTime=-1, elapsedTime=0, intervalTime=0.4, min=170, max=255))
    end object
    componentList.add(Selector_Sprite)
    
    // Selection arrow
    begin object class=UI_Texture_Info Name=Inactive_Selection_Arrow
      componentTextures.add(Texture2D'GUI.Menu_Selection_Arrow')
    end object
    
    // Inactive sprite
    begin object class=UI_Sprite Name=Inactive_Selector_Sprite
      tag="Inactive_Selector_Sprite"
      images(0)=Inactive_Selection_Arrow
      activeEffects.add((effectType=EFFECT_FLICKER, lifeTime=-1, elapsedTime=0, intervalTime=0.1, min=200, max=255))
    end object
    componentList.add(Inactive_Selector_Sprite)
    
  end object
  componentList.add(Game_Menu_Selector)
  
  // Party Displayer
  begin object class=ROTT_UI_Party_Display Name=Party_Displayer
    tag="Party_Displayer"
    bEnabled=true
    posX=60
    posY=544
    XOffset=200
    YOffset=0
  end object
  componentList.add(Party_Displayer)

  // Item cache
  begin object class=UI_Texture_Info Name=Quest_Amulet
    componentTextures.add(Texture2D'ROTT_Items.Quest_Items.Ornament_Of_Chaos_Amulet')
  end object
  begin object class=UI_Texture_Info Name=Quest_Goblet
    componentTextures.add(Texture2D'ROTT_Items.Quest_Items.Ornament_Of_Chaos_Goblet')
  end object
  begin object class=UI_Texture_Info Name=Quest_Ice_Tome
    componentTextures.add(Texture2D'ROTT_Items.Quest_Items.Ornament_Of_Chaos_Ice_Tome')
  end object
  
  begin object class=UI_Texture_Info Name=Buckler_Black
    componentTextures.add(Texture2D'ROTT_Items.Buckler_Shields.Buckler_Black')
  end object
  begin object class=UI_Texture_Info Name=Buckler_Blue
    componentTextures.add(Texture2D'ROTT_Items.Buckler_Shields.Buckler_Blue')
  end object
  begin object class=UI_Texture_Info Name=Buckler_Cyan
    componentTextures.add(Texture2D'ROTT_Items.Buckler_Shields.Buckler_Cyan')
  end object
  begin object class=UI_Texture_Info Name=Buckler_Gold
    componentTextures.add(Texture2D'ROTT_Items.Buckler_Shields.Buckler_Gold')
  end object
  begin object class=UI_Texture_Info Name=Buckler_Green
    componentTextures.add(Texture2D'ROTT_Items.Buckler_Shields.Buckler_Green')
  end object
  begin object class=UI_Texture_Info Name=Buckler_Orange
    componentTextures.add(Texture2D'ROTT_Items.Buckler_Shields.Buckler_Orange')
  end object
  begin object class=UI_Texture_Info Name=Buckler_Purple
    componentTextures.add(Texture2D'ROTT_Items.Buckler_Shields.Buckler_Purple')
  end object
  begin object class=UI_Texture_Info Name=Buckler_Rainbow
    componentTextures.add(Texture2D'ROTT_Items.Buckler_Shields.Buckler_Rainbow')
  end object
  begin object class=UI_Texture_Info Name=Buckler_Red
    componentTextures.add(Texture2D'ROTT_Items.Buckler_Shields.Buckler_Red')
  end object
  begin object class=UI_Texture_Info Name=Buckler_Special
    componentTextures.add(Texture2D'ROTT_Items.Buckler_Shields.Buckler_Special')
  end object
  begin object class=UI_Texture_Info Name=Buckler_Violet
    componentTextures.add(Texture2D'ROTT_Items.Buckler_Shields.Buckler_Violet')
  end object
  begin object class=UI_Texture_Info Name=Buckler_White
    componentTextures.add(Texture2D'ROTT_Items.Buckler_Shields.Buckler_White')
  end object
  begin object class=UI_Texture_Info Name=Ceremonial_Dagger_Black
    componentTextures.add(Texture2D'ROTT_Items.Ceremonial_Daggers.Ceremonial_Dagger_Black')
  end object
  begin object class=UI_Texture_Info Name=Ceremonial_Dagger_Blue
    componentTextures.add(Texture2D'ROTT_Items.Ceremonial_Daggers.Ceremonial_Dagger_Blue')
  end object
  begin object class=UI_Texture_Info Name=Ceremonial_Dagger_Gold
    componentTextures.add(Texture2D'ROTT_Items.Ceremonial_Daggers.Ceremonial_Dagger_Gold')
  end object
  begin object class=UI_Texture_Info Name=Ceremonial_Dagger_Green
    componentTextures.add(Texture2D'ROTT_Items.Ceremonial_Daggers.Ceremonial_Dagger_Green')
  end object
  begin object class=UI_Texture_Info Name=Ceremonial_Dagger_Orange
    componentTextures.add(Texture2D'ROTT_Items.Ceremonial_Daggers.Ceremonial_Dagger_Orange')
  end object
  begin object class=UI_Texture_Info Name=Ceremonial_Dagger_Purple
    componentTextures.add(Texture2D'ROTT_Items.Ceremonial_Daggers.Ceremonial_Dagger_Purple')
  end object
  begin object class=UI_Texture_Info Name=Ceremonial_Dagger_Red
    componentTextures.add(Texture2D'ROTT_Items.Ceremonial_Daggers.Ceremonial_Dagger_Red')
  end object
  begin object class=UI_Texture_Info Name=Ceremonial_Dagger_Violet
    componentTextures.add(Texture2D'ROTT_Items.Ceremonial_Daggers.Ceremonial_Dagger_Violet')
  end object
  begin object class=UI_Texture_Info Name=Ceremonial_Dagger_Whirlwind_Spike
    componentTextures.add(Texture2D'ROTT_Items.Ceremonial_Daggers.Ceremonial_Dagger_Whirlwind_Spike')
  end object
  begin object class=UI_Texture_Info Name=Ceremonial_Dagger_White
    componentTextures.add(Texture2D'ROTT_Items.Ceremonial_Daggers.Ceremonial_Dagger_White')
  end object

  begin object class=UI_Texture_Info Name=Flail_Black
    componentTextures.add(Texture2D'ROTT_Items.Flails.Flail_Black')
  end object
  begin object class=UI_Texture_Info Name=Flail_Blue
    componentTextures.add(Texture2D'ROTT_Items.Flails.Flail_Blue')
  end object
  begin object class=UI_Texture_Info Name=Flail_Cyan
    componentTextures.add(Texture2D'ROTT_Items.Flails.Flail_Cyan')
  end object
  begin object class=UI_Texture_Info Name=Flail_Gold
    componentTextures.add(Texture2D'ROTT_Items.Flails.Flail_Gold')
  end object
  begin object class=UI_Texture_Info Name=Flail_Green
    componentTextures.add(Texture2D'ROTT_Items.Flails.Flail_Green')
  end object
  begin object class=UI_Texture_Info Name=Flail_Orange
    componentTextures.add(Texture2D'ROTT_Items.Flails.Flail_Orange')
  end object
  begin object class=UI_Texture_Info Name=Flail_Purple
    componentTextures.add(Texture2D'ROTT_Items.Flails.Flail_Purple')
  end object
  begin object class=UI_Texture_Info Name=Flail_Red
    componentTextures.add(Texture2D'ROTT_Items.Flails.Flail_Red')
  end object
  begin object class=UI_Texture_Info Name=Flail_Ultimatum
    componentTextures.add(Texture2D'ROTT_Items.Flails.Flail_Ultimatum')
  end object
  begin object class=UI_Texture_Info Name=Flail_Violet
    componentTextures.add(Texture2D'ROTT_Items.Flails.Flail_Violet')
  end object
  begin object class=UI_Texture_Info Name=Flail_White
    componentTextures.add(Texture2D'ROTT_Items.Flails.Flail_White')
  end object
  begin object class=UI_Texture_Info Name=Flat_Brush_Black
    componentTextures.add(Texture2D'ROTT_Items.Flat_Brushes.Flat_Brush_Black')
  end object
  begin object class=UI_Texture_Info Name=Flat_Brush_Blue
    componentTextures.add(Texture2D'ROTT_Items.Flat_Brushes.Flat_Brush_Blue')
  end object
  begin object class=UI_Texture_Info Name=Flat_Brush_Cyan
    componentTextures.add(Texture2D'ROTT_Items.Flat_Brushes.Flat_Brush_Cyan')
  end object
  begin object class=UI_Texture_Info Name=Flat_Brush_Gold
    componentTextures.add(Texture2D'ROTT_Items.Flat_Brushes.Flat_Brush_Gold')
  end object
  begin object class=UI_Texture_Info Name=Flat_Brush_Green
    componentTextures.add(Texture2D'ROTT_Items.Flat_Brushes.Flat_Brush_Green')
  end object
  begin object class=UI_Texture_Info Name=Flat_Brush_Orange
    componentTextures.add(Texture2D'ROTT_Items.Flat_Brushes.Flat_Brush_Orange')
  end object
  begin object class=UI_Texture_Info Name=Flat_Brush_Purple
    componentTextures.add(Texture2D'ROTT_Items.Flat_Brushes.Flat_Brush_Purple')
  end object
  begin object class=UI_Texture_Info Name=Flat_Brush_Red
    componentTextures.add(Texture2D'ROTT_Items.Flat_Brushes.Flat_Brush_Red')
  end object
  begin object class=UI_Texture_Info Name=Flat_Brush_Violet
    componentTextures.add(Texture2D'ROTT_Items.Flat_Brushes.Flat_Brush_Violet')
  end object

  begin object class=UI_Texture_Info Name=Flat_Brush_White
    componentTextures.add(Texture2D'ROTT_Items.Flat_Brushes.Flat_Brush_White')
  end object
  begin object class=UI_Texture_Info Name=Item_Bottle_Blue
    componentTextures.add(Texture2D'ROTT_Items.Bottles.Item_Bottle_Blue')
  end object

  begin object class=UI_Texture_Info Name=Item_Bottle_Gold
    componentTextures.add(Texture2D'ROTT_Items.Bottles.Item_Bottle_Gold')
  end object
  begin object class=UI_Texture_Info Name=Item_Bottle_Green
    componentTextures.add(Texture2D'ROTT_Items.Bottles.Item_Bottle_Green')
  end object
  begin object class=UI_Texture_Info Name=Item_Bottle_Orange
    componentTextures.add(Texture2D'ROTT_Items.Bottles.Item_Bottle_Orange')
  end object
  begin object class=UI_Texture_Info Name=Item_Bottle_Pink
    componentTextures.add(Texture2D'ROTT_Items.Bottles.Item_Bottle_Pink')
  end object
  begin object class=UI_Texture_Info Name=Item_Bottle_Purple
    componentTextures.add(Texture2D'ROTT_Items.Bottles.Item_Bottle_Purple')
  end object
  begin object class=UI_Texture_Info Name=Item_Charm_Blue
    componentTextures.add(Texture2D'ROTT_Items.Charms.Item_Charm_Blue')
  end object
  begin object class=UI_Texture_Info Name=Item_Charm_Gold
    componentTextures.add(Texture2D'ROTT_Items.Charms.Item_Charm_Gold')
  end object
  begin object class=UI_Texture_Info Name=Item_Charm_Green
    componentTextures.add(Texture2D'ROTT_Items.Charms.Item_Charm_Green')
  end object
  
  begin object class=UI_Texture_Info Name=Item_Charm_Orange
    componentTextures.add(Texture2D'ROTT_Items.Charms.Item_Charm_Orange')
  end object
  begin object class=UI_Texture_Info Name=Item_Charm_Pink
    componentTextures.add(Texture2D'ROTT_Items.Charms.Item_Charm_Pink')
  end object
  begin object class=UI_Texture_Info Name=Item_Charm_Purple
    componentTextures.add(Texture2D'ROTT_Items.Charms.Item_Charm_Purple')
  end object
  begin object class=UI_Texture_Info Name=Item_Charm_Red
    componentTextures.add(Texture2D'ROTT_Items.Charms.Item_Charm_Red')
  end object
  begin object class=UI_Texture_Info Name=Item_Charm_Teal
    componentTextures.add(Texture2D'ROTT_Items.Charms.Item_Charm_Teal')
  end object
  
  begin object class=UI_Texture_Info Name=Item_Herb_Blue
    componentTextures.add(Texture2D'ROTT_Items.Herbs.Item_Herb_Blue')
  end object
  begin object class=UI_Texture_Info Name=Item_Herb_Cyan
    componentTextures.add(Texture2D'ROTT_Items.Herbs.Item_Herb_Cyan')
  end object
  begin object class=UI_Texture_Info Name=Item_Herb_Gold
    componentTextures.add(Texture2D'ROTT_Items.Herbs.Item_Herb_Gold')
  end object
  begin object class=UI_Texture_Info Name=Item_Herb_Green
    componentTextures.add(Texture2D'ROTT_Items.Herbs.Item_Herb_Green')
  end object
  begin object class=UI_Texture_Info Name=Item_Herb_Orange
    componentTextures.add(Texture2D'ROTT_Items.Herbs.Item_Herb_Orange')
  end object
  begin object class=UI_Texture_Info Name=Item_Herb_Purple
    componentTextures.add(Texture2D'ROTT_Items.Herbs.Item_Herb_Purple')
  end object
  begin object class=UI_Texture_Info Name=Item_Herb_Red
    componentTextures.add(Texture2D'ROTT_Items.Herbs.Item_Herb_Red')
  end object
  begin object class=UI_Texture_Info Name=Item_Herb_Violet
    componentTextures.add(Texture2D'ROTT_Items.Herbs.Item_Herb_Violet')
  end object
  
  begin object class=UI_Texture_Info Name=Kite_Shield_Black
    componentTextures.add(Texture2D'ROTT_Items.Kite_Shield.Kite_Shield_Black')
  end object
  begin object class=UI_Texture_Info Name=Kite_Shield_Blue
    componentTextures.add(Texture2D'ROTT_Items.Kite_Shield.Kite_Shield_Blue')
  end object
  begin object class=UI_Texture_Info Name=Kite_Shield_Cyan
    componentTextures.add(Texture2D'ROTT_Items.Kite_Shield.Kite_Shield_Cyan')
  end object
  begin object class=UI_Texture_Info Name=Kite_Shield_Gold
    componentTextures.add(Texture2D'ROTT_Items.Kite_Shield.Kite_Shield_Gold')
  end object
  begin object class=UI_Texture_Info Name=Kite_Shield_Green
    componentTextures.add(Texture2D'ROTT_Items.Kite_Shield.Kite_Shield_Green')
  end object
  begin object class=UI_Texture_Info Name=Kite_Shield_Orange
    componentTextures.add(Texture2D'ROTT_Items.Kite_Shield.Kite_Shield_Orange')
  end object
  begin object class=UI_Texture_Info Name=Kite_Shield_Purple
    componentTextures.add(Texture2D'ROTT_Items.Kite_Shield.Kite_Shield_Purple')
  end object
  begin object class=UI_Texture_Info Name=Kite_Shield_Red
    componentTextures.add(Texture2D'ROTT_Items.Kite_Shield.Kite_Shield_Red')
  end object
  begin object class=UI_Texture_Info Name=Kite_Shield_Special
    componentTextures.add(Texture2D'ROTT_Items.Kite_Shield.Kite_Shield_Special')
  end object
  begin object class=UI_Texture_Info Name=Kite_Shield_Violet
    componentTextures.add(Texture2D'ROTT_Items.Kite_Shield.Kite_Shield_Violet')
  end object
  begin object class=UI_Texture_Info Name=Kite_Shield_White
    componentTextures.add(Texture2D'ROTT_Items.Kite_Shield.Kite_Shield_White')
  end object
  
  begin object class=UI_Texture_Info Name=Lustrous_Baton_Black
    componentTextures.add(Texture2D'ROTT_Items.Lustrous_Batons.Lustrous_Baton_Black')
  end object
  begin object class=UI_Texture_Info Name=Lustrous_Baton_Blue
    componentTextures.add(Texture2D'ROTT_Items.Lustrous_Batons.Lustrous_Baton_Blue')
  end object
  begin object class=UI_Texture_Info Name=Lustrous_Baton_Cyan
    componentTextures.add(Texture2D'ROTT_Items.Lustrous_Batons.Lustrous_Baton_Cyan')
  end object
  begin object class=UI_Texture_Info Name=Lustrous_Baton_Gold
    componentTextures.add(Texture2D'ROTT_Items.Lustrous_Batons.Lustrous_Baton_Gold')
  end object
  begin object class=UI_Texture_Info Name=Lustrous_Baton_Green
    componentTextures.add(Texture2D'ROTT_Items.Lustrous_Batons.Lustrous_Baton_Green')
  end object
  begin object class=UI_Texture_Info Name=Lustrous_Baton_Orange
    componentTextures.add(Texture2D'ROTT_Items.Lustrous_Batons.Lustrous_Baton_Orange')
  end object
  begin object class=UI_Texture_Info Name=Lustrous_Baton_Purple
    componentTextures.add(Texture2D'ROTT_Items.Lustrous_Batons.Lustrous_Baton_Purple')
  end object
  begin object class=UI_Texture_Info Name=Lustrous_Baton_Rainbow
    componentTextures.add(Texture2D'ROTT_Items.Lustrous_Batons.Lustrous_Baton_Rainbow')
  end object
  begin object class=UI_Texture_Info Name=Lustrous_Baton_Red
    componentTextures.add(Texture2D'ROTT_Items.Lustrous_Batons.Lustrous_Baton_Red')
  end object
  begin object class=UI_Texture_Info Name=Lustrous_Baton_Violet
    componentTextures.add(Texture2D'ROTT_Items.Lustrous_Batons.Lustrous_Baton_Violet')
  end object
  begin object class=UI_Texture_Info Name=Lustrous_Baton_White
    componentTextures.add(Texture2D'ROTT_Items.Lustrous_Batons.Lustrous_Baton_White')
  end object
  
  begin object class=UI_Texture_Info Name=Paintbrush_Black
    componentTextures.add(Texture2D'ROTT_Items.Paintbrushes.Paintbrush_Black')
  end object
  begin object class=UI_Texture_Info Name=Paintbrush_Blue
    componentTextures.add(Texture2D'ROTT_Items.Paintbrushes.Paintbrush_Blue')
  end object
  begin object class=UI_Texture_Info Name=Paintbrush_Cyan
    componentTextures.add(Texture2D'ROTT_Items.Paintbrushes.Paintbrush_Cyan')
  end object
  begin object class=UI_Texture_Info Name=Paintbrush_Gold
    componentTextures.add(Texture2D'ROTT_Items.Paintbrushes.Paintbrush_Gold')
  end object
  begin object class=UI_Texture_Info Name=Paintbrush_Green
    componentTextures.add(Texture2D'ROTT_Items.Paintbrushes.Paintbrush_Green')
  end object
  begin object class=UI_Texture_Info Name=Paintbrush_Orange
    componentTextures.add(Texture2D'ROTT_Items.Paintbrushes.Paintbrush_Orange')
  end object
  begin object class=UI_Texture_Info Name=Paintbrush_Purple
    componentTextures.add(Texture2D'ROTT_Items.Paintbrushes.Paintbrush_Purple')
  end object
  begin object class=UI_Texture_Info Name=Paintbrush_Rainbow
    componentTextures.add(Texture2D'ROTT_Items.Paintbrushes.Paintbrush_Rainbow')
  end object
  begin object class=UI_Texture_Info Name=Paintbrush_Red
    componentTextures.add(Texture2D'ROTT_Items.Paintbrushes.Paintbrush_Red')
  end object
  begin object class=UI_Texture_Info Name=Paintbrush_Violet
    componentTextures.add(Texture2D'ROTT_Items.Paintbrushes.Paintbrush_Violet')
  end object
  begin object class=UI_Texture_Info Name=Paintbrush_White
    componentTextures.add(Texture2D'ROTT_Items.Paintbrushes.Paintbrush_White')
  end object
  
  // Item Cacher
  begin object class=UI_Sprite Name=Item_Cacher
    tag="Item_Cacher"
    bEnabled=true
    posx=-9000
    posy=0
    images(0)=Buckler_Black
    images(1)=Buckler_Blue
    images(2)=Buckler_Cyan
    images(3)=Buckler_Gold
    images(4)=Buckler_Green
    images(5)=Buckler_Orange
    images(6)=Buckler_Purple
    images(7)=Buckler_Rainbow
    images(8)=Buckler_Red
    images(9)=Buckler_Special
    images(10)=Buckler_Violet
    images(11)=Buckler_White
    images(12)=Ceremonial_Dagger_Black
    images(13)=Ceremonial_Dagger_Blue
    images(14)=Ceremonial_Dagger_Gold
    images(15)=Ceremonial_Dagger_Green
    images(16)=Ceremonial_Dagger_Orange
    images(17)=Ceremonial_Dagger_Purple
    images(18)=Ceremonial_Dagger_Red
    images(19)=Ceremonial_Dagger_Violet
    images(20)=Ceremonial_Dagger_Whirlwind_Spike
    images(21)=Ceremonial_Dagger_White
    images(22)=Flail_Black
    images(23)=Flail_Blue
    images(24)=Flail_Cyan
    images(25)=Flail_Gold
    images(26)=Flail_Green
    images(27)=Flail_Orange
    images(28)=Flail_Purple
    images(29)=Flail_Red
    images(30)=Flail_Ultimatum
    images(31)=Flail_Violet
    images(32)=Flail_White
    images(33)=Flat_Brush_Black
    images(34)=Flat_Brush_Blue
    images(35)=Flat_Brush_Cyan
    images(36)=Flat_Brush_Gold
    images(37)=Flat_Brush_Green
    images(38)=Flat_Brush_Orange
    images(39)=Flat_Brush_Purple
    images(40)=Flat_Brush_Red
    images(41)=Flat_Brush_Violet
    images(42)=Flat_Brush_White
    images(43)=Item_Bottle_Blue
    images(44)=Item_Bottle_Gold
    images(45)=Item_Bottle_Green
    images(46)=Item_Bottle_Orange
    images(47)=Item_Bottle_Pink
    images(48)=Item_Bottle_Purple
    images(49)=Item_Charm_Blue
    images(50)=Item_Charm_Gold
    images(51)=Item_Charm_Green
    images(52)=Item_Charm_Orange
    images(53)=Item_Charm_Pink
    images(54)=Item_Charm_Purple
    images(55)=Item_Charm_Red
    images(56)=Item_Charm_Teal
    images(57)=Item_Herb_Blue
    images(58)=Item_Herb_Cyan
    images(59)=Item_Herb_Gold
    images(60)=Item_Herb_Green
    images(61)=Item_Herb_Orange
    images(62)=Item_Herb_Purple
    images(63)=Item_Herb_Red
    images(64)=Item_Herb_Violet
    images(65)=Kite_Shield_Black
    images(66)=Kite_Shield_Blue
    images(67)=Kite_Shield_Cyan
    images(68)=Kite_Shield_Gold
    images(69)=Kite_Shield_Green
    images(70)=Kite_Shield_Orange
    images(71)=Kite_Shield_Purple
    images(72)=Kite_Shield_Red
    images(73)=Kite_Shield_Special
    images(74)=Kite_Shield_Violet
    images(75)=Kite_Shield_White
    images(76)=Lustrous_Baton_Black
    images(77)=Lustrous_Baton_Blue
    images(78)=Lustrous_Baton_Cyan
    images(79)=Lustrous_Baton_Gold
    images(80)=Lustrous_Baton_Green
    images(81)=Lustrous_Baton_Orange
    images(82)=Lustrous_Baton_Purple
    images(83)=Lustrous_Baton_Rainbow
    images(84)=Lustrous_Baton_Red
    images(85)=Lustrous_Baton_Violet
    images(86)=Lustrous_Baton_White
    images(87)=Paintbrush_Black
    images(88)=Paintbrush_Blue
    images(89)=Paintbrush_Cyan
    images(90)=Paintbrush_Gold
    images(91)=Paintbrush_Green
    images(92)=Paintbrush_Orange
    images(93)=Paintbrush_Purple
    images(94)=Paintbrush_Rainbow
    images(95)=Paintbrush_Red
    images(96)=Paintbrush_Violet
    images(97)=Paintbrush_White
    images(98)=Quest_Amulet
    images(99)=Quest_Goblet
    images(100)=Quest_Ice_Tome
    
    activeEffects.add((effectType=EFFECT_FLIPBOOK, lifeTime=-1, elapsedTime=0, intervalTime=0.001, min=0, max=255))
  end object
  componentList.add(Item_Cacher)
}














