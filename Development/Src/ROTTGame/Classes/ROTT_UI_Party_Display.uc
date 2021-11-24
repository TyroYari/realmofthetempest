/*=============================================================================
 * ROTT_UI_Party_Display
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: Displays a party using portraits provided by a 
 * UI_Texture_Storage class
 *===========================================================================*/
 
class ROTT_UI_Party_Display extends UI_Container;

// The number of members in a full party
const PARTY_CAPACITY = 3;

// The sprites
var private UI_Sprite portrait[PARTY_CAPACITY];
var private UI_Sprite unspentIcon[PARTY_CAPACITY];

// The distance from one portrait to the next
var private int xOffset;
var private int yOffset;

enum PortraitTypes {
  MENU_PORTRAITS,
  MANAGER_PORTRAITS,
  VICTORY_PORTRAITS
};

var private UI_Texture_Storage portraits[PortraitTypes];
var private PortraitTypes displayMode;

// Unspent icon animation
var private float flipBookInterval, flipBookTime;

// Item slot graphics
var privatewrite ROTT_UI_Displayer_Item inventorySlots[3];

// References
var privatewrite ROTT_Game_Info gameInfo;

/*============================================================================= 
 * initializeComponent
 *
 * Called once, when the scene is first initialized.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  local int i;
  
  // Game reference
  gameInfo = ROTT_Game_Info(class'WorldInfo'.static.getWorldInfo().game);
  
  super.initializeComponent(newTag);
  
  portraits[MENU_PORTRAITS] = UI_Texture_Storage(findComp("Menu_Portraits"));
  portraits[MANAGER_PORTRAITS] = UI_Texture_Storage(findComp("Manager_Portraits"));
  portraits[VICTORY_PORTRAITS] = UI_Texture_Storage(findComp("Victory_Portraits"));
  
  // Get internal references
  for (i = 0; i < PARTY_CAPACITY; i++) {
    portrait[i] = findSprite("Party_Portrait_" $ i+1);
    unspentIcon[i] = findSprite("Unspent_Icon_" $ i+1);
    
    // Set initial positioning
    portrait[i].shiftX(XOffset * i);
    portrait[i].shiftY(YOffset * i);
    
    unspentIcon[i].shiftX(XOffset * i);
    unspentIcon[i].shiftY(YOffset * i);
  }
  
  // Initialize item displayers
  for (i = 0; i < 3; i++) {
    inventorySlots[i] = new(self) class'ROTT_UI_Displayer_Item';
    componentList.addItem(inventorySlots[i]);
    inventorySlots[i].initializeComponent();
    inventorySlots[i].updatePosition(
      portrait[i].getX() + 34,
      portrait[i].getY() + 119,
      portrait[i].getX() + 162,
      portrait[i].getY() + 247
    );
  }
}

/*=============================================================================
 * renderParty()
 *
 * Given a party, this will update a series of portraits representing the 
 * heroes
 *===========================================================================*/
public function renderParty(ROTT_Party party) {
  local ROTT_Combat_Hero hero;
  local int i;
  
  for (i = 0; i < PARTY_CAPACITY; i++) {
    hero = party.getHero(i);
    if (hero != none) {
      // Render hero portrait
      portrait[i].setEnabled(true);
      portrait[i].copySprite(portraits[displayMode], hero.myClass);
      
      // Show unspent icons for menu portraits
      if (displayMode == MENU_PORTRAITS && hero.hasUnspentPoints()) {
        unspentIcon[i].setEnabled(true);
        unspentIcon[i].setDrawIndex(1); // Start on first sprite
      } else {
        unspentIcon[i].setEnabled(false);
      }
      
    } else {
      portrait[i].setEnabled(false);
      unspentIcon[i].setEnabled(false);
    }
  }
  
  // Show item graphics
  for (i = 0; i < 3; i++) {
    // Check valid hero
    if (party.getHero(i) != none) {
      // Display held item
      inventorySlots[i].updateDisplay(
        party.getHero(i).heldItem
      );
    } else {
      // Show no item graphics
      inventorySlots[i].updateDisplay(none);
    }
  }
}

/*=============================================================================
 * elapseTimer()
 *
 * Time is passed to non-actors through the scene that contains them
 *===========================================================================*/
public function elapseTimer(float deltaTime, float gameSpeedOverride) {
  super.elapseTimer(deltaTime, gameSpeedOverride);
}

/*=============================================================================
 * syncIconEffects()
 *
 * Called to sync unspent icon flipbook effects
 *===========================================================================*/
public function syncIconEffects() {
  local int i;
  
  for (i = 0; i < PARTY_CAPACITY; i++) {
    unspentIcon[i].resetEffectTimes();
  }
}

/*=============================================================================
 * Assets
 *===========================================================================*/
defaultProperties
{
  // Unspent Icon animation
  flipBookInterval=0.06
  
  // Container draw settings
  bDrawRelative=true
  
  /** ===== Textures ===== **/
  // Menu Portraits
  begin object class=UI_Texture_Info Name=Menu_Portrait_Goliath
    componentTextures.add(Texture2D'GUI.Hero_Portraits.Portrait_Goliath_400x600')
  end object
  begin object class=UI_Texture_Info Name=Menu_Portrait_Valkyrie
    componentTextures.add(Texture2D'GUI.Hero_Portraits.Portrait_Valkyrie_400x600')
  end object
  begin object class=UI_Texture_Info Name=Menu_Portrait_Wizard
    componentTextures.add(Texture2D'GUI.Hero_Portraits.Portrait_Wizard_400x600')
  end object
  begin object class=UI_Texture_Info Name=Menu_Portrait_Titan
    componentTextures.add(Texture2D'GUI.Hero_Portraits.Portrait_Titan_400x600')
  end object
  
  // Manager Portraits
  begin object class=UI_Texture_Info Name=Manager_Portrait_Goliath
    componentTextures.add(Texture2D'GUI.Hero_Portraits.Unlabeled_Portrait_Goliath_400x480')
  end object
  begin object class=UI_Texture_Info Name=Manager_Portrait_Valkyrie
    componentTextures.add(Texture2D'GUI.Hero_Portraits.Unlabeled_Portrait_Valkyrie_400x480')
  end object
  begin object class=UI_Texture_Info Name=Manager_Portrait_Wizard
    componentTextures.add(Texture2D'GUI.Hero_Portraits.Unlabeled_Portrait_Wizard_400x480')
  end object
  begin object class=UI_Texture_Info Name=Manager_Portrait_Titan
    componentTextures.add(Texture2D'GUI.Hero_Portraits.Unlabeled_Portrait_Titan_400x480')
  end object
  
  // Draw settings (just some defaults)
  posX=65
  posY=549
  xOffset=200
  yOffset=0
  
  // Menu Portraits
  begin object class=UI_Texture_Storage Name=Menu_Portraits
    tag="Menu_Portraits"
    images(VALKYRIE)=Menu_Portrait_Valkyrie
    images(WIZARD)=Menu_Portrait_Wizard
    images(GOLIATH)=Menu_Portrait_Goliath
    images(TITAN)=Menu_Portrait_Titan
    textureWidth=200
    textureHeight=300
  end object
  componentList.add(Menu_Portraits)
  
  // Manager Portraits
  begin object class=UI_Texture_Storage Name=Manager_Portraits
    tag="Manager_Portraits"
    images(VALKYRIE)=Manager_Portrait_Valkyrie
    images(WIZARD)=Manager_Portrait_Wizard
    images(GOLIATH)=Manager_Portrait_Goliath
    images(TITAN)=Manager_Portrait_Titan
    textureWidth=200
    textureHeight=240
  end object
  componentList.add(Manager_Portraits)
  
  // Victory Portraits
  begin object class=UI_Texture_Storage Name=Victory_Portraits
    tag="Victory_Portraits"
    images(VALKYRIE)=Manager_Portrait_Valkyrie
    images(WIZARD)=Manager_Portrait_Wizard
    images(GOLIATH)=Manager_Portrait_Goliath
    images(TITAN)=Manager_Portrait_Titan
  end object
  componentList.add(Victory_Portraits)
  
  // Portraits
  begin object class=UI_Sprite Name=Party_Portrait_1
    tag="Party_Portrait_1"
    bEnabled=true
    images(0)=Menu_Portrait_Wizard
  end object
  componentList.add(Party_Portrait_1)
  
  // Portraits
  begin object class=UI_Sprite Name=Party_Portrait_2
    tag="Party_Portrait_2"
    bEnabled=true
    images(0)=Menu_Portrait_Wizard
  end object
  componentList.add(Party_Portrait_2)
  
  // Portraits
  begin object class=UI_Sprite Name=Party_Portrait_3
    tag="Party_Portrait_3"
    bEnabled=true
    images(0)=Menu_Portrait_Wizard
  end object
  componentList.add(Party_Portrait_3)
  
  // Unspent Icons
  begin object class=UI_Texture_Info Name=Unspent_Points_Icon_F1
    componentTextures.add(Texture2D'GUI.Unspent_Points_Icon_F1')
  end object
  begin object class=UI_Texture_Info Name=Unspent_Points_Icon_F2
    componentTextures.add(Texture2D'GUI.Unspent_Points_Icon_F2')
  end object
  
  // Unspent points
  begin object class=UI_Sprite Name=Unspent_Icon_1
    tag="Unspent_Icon_1"
    posX=130
    posY=8
    images(0)=Unspent_Points_Icon_F1
    images(1)=Unspent_Points_Icon_F2
    
    // Alpha Effects
    activeEffects.add((effectType = EFFECT_ALPHA_CYCLE, lifeTime = -1, elapsedTime = 0, intervalTime = 0.5, min = 158, max = 245))
    
    // Flipbook Effects
    activeEffects.add((effectType = EFFECT_FLIPBOOK, lifeTime = -1, elapsedTime = 0, intervalTime = 0.06, min = 0, max = 255))
    
  end object
  componentList.add(Unspent_Icon_1)
  
  begin object class=UI_Sprite Name=Unspent_Icon_2
    tag="Unspent_Icon_2"
    posX=130
    posY=8
    images(0)=Unspent_Points_Icon_F1
    images(1)=Unspent_Points_Icon_F2
    
    // Alpha Effects
    activeEffects.add((effectType = EFFECT_ALPHA_CYCLE, lifeTime = -1, elapsedTime = 0, intervalTime = 0.5, min = 158, max = 245))
    
    // Flipbook Effects
    activeEffects.add((effectType = EFFECT_FLIPBOOK, lifeTime = -1, elapsedTime = 0, intervalTime = 0.06, min = 0, max = 255))
    
  end object
  componentList.add(Unspent_Icon_2)
  
  begin object class=UI_Sprite Name=Unspent_Icon_3
    tag="Unspent_Icon_3"
    posX=130
    posY=8
    images(0)=Unspent_Points_Icon_F1
    images(1)=Unspent_Points_Icon_F2
    
    // Alpha Effects
    activeEffects.add((effectType = EFFECT_ALPHA_CYCLE, lifeTime = -1, elapsedTime = 0, intervalTime = 0.6, min = 158, max = 245))
    
    // Flipbook Effects
    activeEffects.add((effectType = EFFECT_FLIPBOOK, lifeTime = -1, elapsedTime = 0, intervalTime = 0.06, min = 0, max = 255))
    
  end object
  componentList.add(Unspent_Icon_3)
  
  
}












