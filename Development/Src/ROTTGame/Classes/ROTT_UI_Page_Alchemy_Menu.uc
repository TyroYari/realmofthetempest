/*=============================================================================
 * ROTT_UI_Page_Alchemy_Menu
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: The menu for starting the alchemy game.
 *===========================================================================*/
 
class ROTT_UI_Page_Alchemy_Menu extends ROTT_UI_Page;

/** ============================== **/

enum MenuStates {
  SELECT_ENCHANTMENT,
  SELECT_MULTIPLIER
};

var private MenuStates menuState;

/** ============================== **/

// Internal references
var private UI_Selector selector;
var private UI_Sprite enchantmentList;
var private UI_Sprite selectionArrows;
var private UI_Label enchantmentText[6];

// Store selection options
var privatewrite int enchantmentSelection;

// External references
var privatewrite ROTT_UI_Scene_Service_Alchemy alchemyScene;

/*============================================================================= 
 * Initialize Component
 *
 * Description: This event is called as the UI is loaded.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  super.initializeComponent(newTag);
  
  // Internal references
  selectionArrows = findSprite("Enchantment_Navigation_Arrows");
  selector = UI_Selector(findComp("Alchemy_Enchantment_Selector"));
  selector.setActive(true);
  
  enchantmentList = UI_Sprite(findComp("Enchantment_Selection_List"));
  
  enchantmentText[0] = UI_Label(findComp("Alchemy_Menu_Enchantment_Name"));
  enchantmentText[1] = UI_Label(findComp("Alchemy_Menu_Enchantment_Description_1"));
  enchantmentText[2] = UI_Label(findComp("Alchemy_Menu_Enchantment_Description_2"));
  enchantmentText[3] = UI_Label(findComp("Enchantment_Effect_Label"));
  
  // Scene reference
  alchemyScene = ROTT_UI_Scene_Service_Alchemy(parentScene);
}

/*=============================================================================
 * onFocusMenu()
 *
 * Called when a menu is given focus.  Assign controls, and enable graphics.
 *===========================================================================*/
event onFocusMenu() {
  selector.setActive(true);
}
event onUnfocusMenu() {
  
}

/*============================================================================= 
 * onPushPageEvent()
 *
 * This event is called every time the page is pushed.
 *===========================================================================*/
event onPushPageEvent() {
  // Reset menu state
  menuState = SELECT_ENCHANTMENT;
  
  // Reset enchantment selection
  enchantmentSelection = 7;
  alchemyScene.minigameMultiplier = 1;
  selector.setActive(true);
  selector.forceSelection(enchantmentSelection);
  
  enchantmentList.updatePosition(
    364-120 * enchantmentSelection,
    203,
    2664-120 * enchantmentSelection,
    303
  );
  
  // Update display
  refresh();
}

/*=============================================================================
 * refresh()
 *
 * Should be called when any changes occur to the UI.
 *===========================================================================*/
public function refresh() {
  local EnchantmentDescriptor script;
  local int i;
  
  // Minimum game level cap 
  if (alchemyScene.minigameMultiplier < 1) {
    alchemyScene.minigameMultiplier = 1;
  }
  
  // Get script
  script = class'ROTT_Descriptor_Enchantment_List'.static.getEnchantment(
    enchantmentSelection
  );
  
  // Set display text
  for (i = 0; i < 3; i++) {
    enchantmentText[i].setText(script.displayText[i]);
  }
  
  // Replacement codes
  enchantmentText[3].setText(script.displayText[ENCHANTMENT_ROUND_BONUS]);
  enchantmentText[3].replaceText("%bonus", script.bonusPerLevel * alchemyScene.minigameMultiplier);
  
  // Set price per game
  setCostValues(getEnchantmentCost());
  
  // Set active widgets
  switch (menuState) {
    case SELECT_ENCHANTMENT:
      selectionArrows.updatePosition(410, 126, 1030, 186);
      selector.selectorSprite.clearEffects();
      break;
    case SELECT_MULTIPLIER:
      selectionArrows.updatePosition(410, 126+413, 1030, 186+413);
      selector.selectorSprite.addFlickerEffect(-1, 0.1, 0, 200, 255); /// hack, fake inactive graphics
      break;
  }
}

/*============================================================================*
 * getEnchantmentCost()
 *
 * Returns the cost for playing the selected enchantment minigame
 *===========================================================================*/
public function array<ItemCost> getEnchantmentCost() {
  local array<ItemCost> returnCosts;
  local int i;
  
  // Get cost of enchantment
  returnCosts = class'ROTT_Descriptor_Enchantment_List'.static.getEnchantmentCost(
    enchantmentSelection
  );
  
  // Multiply cost
  for (i = 0; i < returnCosts.length; i++) {
    returnCosts[i].quantity *= alchemyScene.minigameMultiplier;
  }
  
  return returnCosts;
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
  float amountDepressed = 1.f, 
  bool bGamepad = false
)
{
  switch (inputName) {
    case 'Z': inputName = 'XboxTypeS_LeftShoulder';  break;
    case 'C': inputName = 'XboxTypeS_RightShoulder'; break;
  }
  
  return super.onInputKey(ControllerId, inputName, Event, amountDepressed, bGamepad);
}

/*============================================================================*
 * Button controls
 *===========================================================================*/
protected function navigationRoutineA() {
  switch (menuState) {
    case SELECT_ENCHANTMENT:
      // Navigate to enchantment multiplier setting
      menuState = SELECT_MULTIPLIER;
      gameInfo.sfxBox.playSfx(SFX_MENU_ACCEPT);
      refresh();
      break;
    case SELECT_MULTIPLIER:
      // Check for sufficient funds
      if (!gameInfo.canDeductCosts(getEnchantmentCost())) {
        gameinfo.sfxBox.playSFX(SFX_MENU_INSUFFICIENT);
        return;
      }
      
      // Deduct cost
      gameInfo.deductCosts(getEnchantmentCost());
      
      // Sound effects
      gameInfo.sfxBox.playSfx(SFX_MENU_INVEST_STAT);
      
      // Push the game UI
      parentScene.popPage();
      parentScene.pushPageByTag("Page_Alchemy_Game");
      alchemyScene.selectedEnchantment = EnchantmentEnum(enchantmentSelection);
      break;
  }
}

protected function navigationRoutineB() {
  switch (menuState) {
    case SELECT_ENCHANTMENT:
      // Navigate back to NPC
      parentScene.popPage();
      sceneManager.switchScene(SCENE_NPC_DIALOG);
      break;
    case SELECT_MULTIPLIER:
      // Navigate back to enchantment selection
      menuState = SELECT_ENCHANTMENT;
      refresh();
      break;
  }
  // Sfx
  gameInfo.sfxBox.playSfx(SFX_MENU_BACK);
}

/*=============================================================================
 * Bumper inputs
 *===========================================================================*/
protected function navigationRoutineLB() {
  switch (menuState) {
    case SELECT_ENCHANTMENT:
      // No action
      return;
    case SELECT_MULTIPLIER:
      // Navigate alchemy multiplier left, in groups of 10
      alchemyScene.minigameMultiplier -= 10;
      refresh();
      
      // Play sound
      sfxBox.playSFX(SFX_MENU_NAVIGATE);
      break;
  }
}
 
protected function navigationRoutineRB() {
  switch (menuState) {
    case SELECT_ENCHANTMENT:
      // No action
      return;
    case SELECT_MULTIPLIER:
      // Navigate alchemy multiplier right, in groups of 10
      if (alchemyScene.minigameMultiplier == 1) {
        alchemyScene.minigameMultiplier += 9;
      } else {
        alchemyScene.minigameMultiplier += 10;
      }
      refresh();
      
      // Play sound
      sfxBox.playSFX(SFX_MENU_NAVIGATE);
      break;
  }
}

/*============================================================================*
 * D-Pad controls
 *===========================================================================*/
public function onNavigateDown() {
  
}

public function onNavigateUp() {
  
}

public function onNavigateLeft() {
  switch (menuState) {
    case SELECT_ENCHANTMENT:
      // Select enchantment left
      enchantmentList.shiftX(120);
      enchantmentSelection--;
      break;
    case SELECT_MULTIPLIER:
      alchemyScene.minigameMultiplier--;
      break;
  }
  refresh();
}

public function onNavigateRight() {
  switch (menuState) {
    case SELECT_ENCHANTMENT:
      // Select enchantment right
      enchantmentList.shiftX(-120);
      enchantmentSelection++;
      break;
    case SELECT_MULTIPLIER:
      alchemyScene.minigameMultiplier++;
      break;
  }
  refresh();
}

/*=============================================================================
 * Navigation requirements()
 *===========================================================================*/
public function bool preNavigateLeft() {
  switch (menuState) {
    case SELECT_ENCHANTMENT:
      // Select enchantment left
      if (enchantmentSelection > 0) return true;
      break;
    case SELECT_MULTIPLIER:
      // Decrease minigagme multiplier
      if (alchemyScene.minigameMultiplier > 1) return true;
      break;
  }
  return false;
}

public function bool preNavigateRight() {
  switch (menuState) {
    case SELECT_ENCHANTMENT:
      // Select enchantment right
      if (enchantmentSelection + 1 < class'ROTT_Descriptor_Enchantment_List'.static.countEnchantmentEnum()) {
        return true;
      }
      break;
    case SELECT_MULTIPLIER:
      if (alchemyScene.minigameMultiplier < 100) return true;
      break;
  }
  return false;
}

/*=============================================================================
 * Default Properties
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
  
  // Bumpers
  begin object class=ROTT_Input_Handler Name=Input_LB
    inputName="XboxTypeS_LeftShoulder"
    buttonComponent=none
  end object
  inputList.add(Input_LB)
  
  begin object class=ROTT_Input_Handler Name=Input_RB
    inputName="XboxTypeS_RightShoulder"
    buttonComponent=none
  end object
  inputList.add(Input_RB)
  
  /** ===== Textures ===== **/
  // Background
  begin object class=UI_Texture_Info Name=Menu_Background
    componentTextures.add(Texture2D'ROTT_Alchemy.Alchemy_Menu_Background')
  end object
  
  // Enchantment list
  begin object class=UI_Texture_Info Name=Enchantment_List
    componentTextures.add(Texture2D'ROTT_Alchemy.Service.Enchantment_List')
  end object
  
  // Helper Arrow 
  begin object class=UI_Texture_Info Name=Navigation_Arrows
    componentTextures.add(Texture2D'ROTT_Alchemy.Service.Enchantment_Navigation_Arrows')
  end object
  
  /** ===== Components ===== **/
  // Enchantment list (under background)
  begin object class=UI_Sprite Name=Enchantment_Selection_List
    tag="Enchantment_Selection_List" 
    posX=364
    posY=203
    posXEnd=2664
    posYEnd=303
    images(0)=Enchantment_List
  end object
  componentList.Add(Enchantment_Selection_List)
  
  // Background
  begin object class=UI_Sprite Name=Alchemy_Menu_Background
    tag="Alchemy_Menu_Background"
    posX=0
    posY=0
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    images(0)=Menu_Background
  end object
  componentList.add(Alchemy_Menu_Background)
  
  // Navigation Arrows
  begin object class=UI_Sprite Name=Enchantment_Navigation_Arrows
    tag="Enchantment_Navigation_Arrows"
    posX=410
    posY=126
    posXEnd=1030
    posYEnd=186
    images(0)=Navigation_Arrows
    activeEffects.add((effectType = EFFECT_ALPHA_CYCLE, lifeTime = -1, elapsedTime = 0, intervalTime = 1.0, min = 170, max = 255))
  end object
  componentList.add(Enchantment_Navigation_Arrows)
  
  // Header
  begin object class=UI_Label Name=Alchemy_Menu_Enchantment_Name
    tag="Alchemy_Menu_Enchantment_Name"
    posX=0
    posY=125
    posXEnd=NATIVE_WIDTH
    posYEnd=161
    alignX=CENTER
    alignY=TOP
    fontStyle=DEFAULT_LARGE_WHITE
    labelText="Mystic Marble"
  end object
  componentList.add(Alchemy_Menu_Enchantment_Name)
  
  // Enchantment effect description (Line #1)
  begin object class=UI_Label Name=Alchemy_Menu_Enchantment_Description_1
    tag="Alchemy_Menu_Enchantment_Description_1"
    posX=0
    posY=340
    posXEnd=NATIVE_WIDTH
    posYEnd=361
    alignX=CENTER
    alignY=TOP
    fontStyle=DEFAULT_SMALL_WHITE
    labelText="Increasese maximum mana for every"
  end object
  componentList.add(Alchemy_Menu_Enchantment_Description_1)
  
  // Enchantment effect description (Line #2)
  begin object class=UI_Label Name=Alchemy_Menu_Enchantment_Description_2
    tag="Alchemy_Menu_Enchantment_Description_2"
    posX=0
    posY=367
    posXEnd=NATIVE_WIDTH
    posYEnd=388
    alignX=CENTER
    alignY=TOP
    fontStyle=DEFAULT_SMALL_WHITE
    labelText="party of heroes"
  end object
  componentList.add(Alchemy_Menu_Enchantment_Description_2)
    
  // Enchantment effect label
  begin object class=UI_Label Name=Enchantment_Effect_Label
    tag="Enchantment_Effect_Label"
    posX=0
    posY=440
    posXEnd=NATIVE_WIDTH
    posYEnd=498
    fontStyle=DEFAULT_SMALL_GREEN
    labelText="+2 Health Regen for each round cleared"
    alignX=CENTER
    alignY=TOP
  end object
  componentList.add(Enchantment_Effect_Label)
  
  
  // Gold Cost Displayer
  begin object class=ROTT_UI_Displayer_Cost Name=Gold_Cost
    tag="Gold_Cost"
    posX=350
    posY=497
    currencyType=class'ROTT_Inventory_Item_Gold'
    costDescriptionText="Gold cost per game:"
    costValue=100
  end object 
  componentList.add(Gold_Cost)
  
  // Gem Cost Displayer
  begin object class=ROTT_UI_Displayer_Cost Name=Gem_Cost
    tag="Gem_Cost"
    posX=350
    posY=638
    currencyType=class'ROTT_Inventory_Item_Gem'
    costDescriptionText="Gem cost per game:"
    costValue=100
  end object 
  componentList.add(Gem_Cost)
  
  // Selector
  begin object class=UI_Selector Name=Alchemy_Enchantment_Selector
    tag="Alchemy_Enchantment_Selector"
    bEnabled=true
    bActive=true
    bWrapAround=false
    numberOfMenuOptions=0
    posX=658
    posY=187
    navigationType=SELECTION_HORIZONTAL
    selectionOffset=(x=0,y=0)
    
    // Selection texture
    begin object class=UI_Texture_Info Name=Selection_Box_Texture
      componentTextures.add(Texture2D'GUI.Skill_Selection_Box')
    end object

    // Selector sprite
    begin object class=UI_Sprite Name=Selector_Sprite
      tag="Selector_Sprite"
      images(0)=Selection_Box_Texture
    end object
    componentList.add(Selector_Sprite)
    
  end object
  componentList.add(Alchemy_Enchantment_Selector)
  
}





