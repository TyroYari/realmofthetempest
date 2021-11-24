/*=============================================================================
 * ROTT_UI_Displayer_Shrine_Reward
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Used to display rewards for passive shrine attendence
 *===========================================================================*/

class ROTT_UI_Displayer_Shrine_Reward extends ROTT_UI_Displayer;

// Display settings
var privatewrite PassiveShrineActivies hyperShrine;
var privatewrite string rewardDescriptionText;
var privatewrite string rewardBoostText;

// Item graphics
var private ROTT_UI_Displayer_Item itemGraphics;

// Cost label
var private UI_Label rewardDescription;
var private UI_Label rewardQuantity;

/*============================================================================= 
 * initializeComponent
 *
 * This is called as the UI is loaded.  Our initial scene is drawn here.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  super.initializeComponent(newTag);
  
  // Internal references
  itemGraphics = ROTT_UI_Displayer_Item(findComp("Player_Inventory_Slot"));
  rewardDescription = findLabel("Reward_Description_Label");
  rewardQuantity = findLabel("Reward_Quantity");
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
 * setRewardInfo()
 *
 * Sets costs specifically for a shrine donation
 *===========================================================================*/
public function setRewardInfo(ShrineRewards reward) {
  // Reset UI
  findSprite("Reward_Slot_Bottles").setEnabled(false);
  findSprite("Reward_Slot_Ceremonial_Daggers").setEnabled(false);
  findSprite("Reward_Slot_Hyper_Glyph").setEnabled(false);
  findSprite("Reward_Slot_Currency").setEnabled(false);
  findSprite("Reward_Slot_Herbs").setEnabled(false);
  findSprite("Reward_Slot_Lustrous_Batons").setEnabled(false);
  findSprite("Reward_Slot_Kite_Shields").setEnabled(false);
  findSprite("Reward_Slot_Charms").setEnabled(false);
  findSprite("Reward_Slot_Flails").setEnabled(false);
  findSprite("Reward_Slot_Bucklers").setEnabled(false);
  findSprite("Reward_Slot_Paintbrushes").setEnabled(false);
  
  // Set display info
  switch (reward) {
    // Hyper Glyphs
    case REWARD_HYPER_ARMOR:
      rewardDescriptionText = "Hyper Armor:";
      rewardBoostText = "+5% glyph chance";
      findSprite("Reward_Slot_Hyper_Glyph").setEnabled(true);
      findSprite("Reward_Slot_Hyper_Glyph").setDrawIndex(0);
      break;
    case REWARD_HYPER_HEALTH:
      rewardDescriptionText = "Hyper Health:";
      rewardBoostText = "+5% glyph chance";
      findSprite("Reward_Slot_Hyper_Glyph").setEnabled(true);
      findSprite("Reward_Slot_Hyper_Glyph").setDrawIndex(1);
      break;
    case REWARD_HYPER_MANA:
      rewardDescriptionText = "Hyper Mana:";
      rewardBoostText = "+5% glyph chance";
      findSprite("Reward_Slot_Hyper_Glyph").setEnabled(true);
      findSprite("Reward_Slot_Hyper_Glyph").setDrawIndex(3);
      break;
    case REWARD_HYPER_MANA_REGEN:
      rewardDescriptionText = "Hyper Mana Regen:";
      rewardBoostText = "+5% glyph chance";
      findSprite("Reward_Slot_Hyper_Glyph").setEnabled(true);
      findSprite("Reward_Slot_Hyper_Glyph").setDrawIndex(5);
      break;
      
    case REWARD_HYPER_SPEED:
      rewardDescriptionText = "Hyper Speed:";
      rewardBoostText = "+5% glyph chance";
      findSprite("Reward_Slot_Hyper_Glyph").setEnabled(true);
      findSprite("Reward_Slot_Hyper_Glyph").setDrawIndex(7);
      break;
    case REWARD_HYPER_DAMAGE:
      rewardDescriptionText = "Hyper Damage:";
      rewardBoostText = "+5% glyph chance";
      findSprite("Reward_Slot_Hyper_Glyph").setEnabled(true);
      findSprite("Reward_Slot_Hyper_Glyph").setDrawIndex(4);
      break;
    case REWARD_HYPER_ACCURACY:
      rewardDescriptionText = "Hyper Accuracy:";
      rewardBoostText = "+5% glyph chance";
      findSprite("Reward_Slot_Hyper_Glyph").setEnabled(true);
      findSprite("Reward_Slot_Hyper_Glyph").setDrawIndex(6);
      break;
    case REWARD_HYPER_DODGE:
      rewardDescriptionText = "Hyper Dodge:";
      rewardBoostText = "+5% glyph chance";
      findSprite("Reward_Slot_Hyper_Glyph").setEnabled(true);
      findSprite("Reward_Slot_Hyper_Glyph").setDrawIndex(2);
      break;
      
    // Ritual drop rates
    case REWARD_BOTTLES:
      rewardDescriptionText = "More Bottles:";
      rewardBoostText = "+5% Drop Rate";
      findSprite("Reward_Slot_Bottles").setEnabled(true);
      break;
    case REWARD_CHARMS:
      rewardDescriptionText = "Charms:";
      rewardBoostText = "+5% Drop Rate";
      findSprite("Reward_Slot_Charms").setEnabled(true);
      break;
    case REWARD_HERBS:
      rewardDescriptionText = "Herbs:";
      rewardBoostText = "+5% Drop Rate";
      findSprite("Reward_Slot_Herbs").setEnabled(true);
      break;
    case REWARD_GOLD:
      rewardDescriptionText = "Gold:";
      rewardBoostText = "+5% Drop Rate";
      findSprite("Reward_Slot_Currency").setEnabled(true);
      findSprite("Reward_Slot_Currency").setDrawIndex(0);
      break;
    case REWARD_GEMS:
      rewardDescriptionText = "Gems:";
      rewardBoostText = "+5% Drop Rate";
      findSprite("Reward_Slot_Currency").setEnabled(true);
      findSprite("Reward_Slot_Currency").setDrawIndex(1);
      break;
    
    // Equipment drop levels
    case REWARD_FLAILS:
      rewardDescriptionText = "Flails:";
      rewardBoostText = "+5% Drop Level";
      findSprite("Reward_Slot_Flails").setEnabled(true);
      break;
    case REWARD_KITE_SHIELDS:
      rewardDescriptionText = "Kite Shields:";
      rewardBoostText = "+5% Drop Level";
      findSprite("Reward_Slot_Kite_Shields").setEnabled(true);
      break;
    case REWARD_BUCKLER_SHIELDS:
      rewardDescriptionText = "Bucklers:";
      rewardBoostText = "+5% Drop Level";
      findSprite("Reward_Slot_Bucklers").setEnabled(true);
      break;
    case REWARD_PAINTBRUSHES:
      rewardDescriptionText = "Paintbrushes:";
      rewardBoostText = "+5% Drop Level";
      findSprite("Reward_Slot_Paintbrushes").setEnabled(true);
      break;
    case REWARD_CEREMONIAL_DAGGERS:
      rewardDescriptionText = "Ceremonial Daggers:";
      rewardBoostText = "+5% Drop Level";
      findSprite("Reward_Slot_Ceremonial_Daggers").setEnabled(true);
      break;
    case REWARD_LUSTROUS_BATONS:
      rewardDescriptionText = "Lustrous Batons:";
      rewardBoostText = "+5% Drop Level";
      findSprite("Reward_Slot_Lustrous_Batons").setEnabled(true);
      break;
      
    default:
      yellowLog("Warning (!) Unhandled " $ reward);
      break;
  }
  
  // Update user interface
  refresh();
}

/*=============================================================================
 * refresh()
 *
 * Called to update the gold and gems
 *===========================================================================*/
public function refresh() {
  findLabel("Reward_Description_Label").setText(rewardDescriptionText);
  findLabel("Reward_Quantity").setText(rewardBoostText);
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  bDrawRelative=true
  
  // Textures
  begin object class=UI_Texture_Info Name=Inventory_Slot_Texture
    componentTextures.add(Texture2D'GUI.Cost_Inventory_Slot')
  end object
  
  // Inventory slot background
  begin object class=UI_Sprite Name=Inventory_Slot_Sprite
    tag="Inventory_Slot_Sprite"
    posX=431
    posY=-10
    images(0)=Inventory_Slot_Texture
  end object
  componentList.add(Inventory_Slot_Sprite)
  
  // Hyper Armor
  begin object class=UI_Texture_Info Name=Hyper_Armor_Reward
    componentTextures.add(Texture2D'GUI.Hyper_Glyphs.Hyper_Armor_Reward')
  end object
  begin object class=UI_Texture_Info Name=Hyper_Health_Reward
    componentTextures.add(Texture2D'GUI.Hyper_Glyphs.Hyper_Health_Reward')
  end object
  begin object class=UI_Texture_Info Name=Hyper_Dodge_Reward
    componentTextures.add(Texture2D'GUI.Hyper_Glyphs.Hyper_Dodge_Reward')
  end object
  begin object class=UI_Texture_Info Name=Hyper_Mana_Reward
    componentTextures.add(Texture2D'GUI.Hyper_Glyphs.Hyper_Mana_Reward')
  end object
  begin object class=UI_Texture_Info Name=Hyper_Damage_Reward
    componentTextures.add(Texture2D'GUI.Hyper_Glyphs.Hyper_Damage_Reward')
  end object
  begin object class=UI_Texture_Info Name=Hyper_Mana_Regen_Reward
    componentTextures.add(Texture2D'GUI.Hyper_Glyphs.Hyper_Mana_Regen_Reward')
  end object
  begin object class=UI_Texture_Info Name=Hyper_Accuracy_Reward
    componentTextures.add(Texture2D'GUI.Hyper_Glyphs.Hyper_Accuracy_Reward')
  end object
  begin object class=UI_Texture_Info Name=Hyper_Speed_Reward
    componentTextures.add(Texture2D'GUI.Hyper_Glyphs.Hyper_Speed_Reward')
  end object
  
  // Reward content: Hyper Armor
  begin object class=UI_Sprite Name=Reward_Slot_Hyper_Glyph
    tag="Reward_Slot_Hyper_Glyph"
    bEnabled=false
    posX=445
    posY=0
    images(0)=Hyper_Armor_Reward
    images(1)=Hyper_Health_Reward
    images(2)=Hyper_Dodge_Reward
    images(3)=Hyper_Mana_Reward
    images(4)=Hyper_Damage_Reward
    images(5)=Hyper_Mana_Regen_Reward
    images(6)=Hyper_Accuracy_Reward
    images(7)=Hyper_Speed_Reward
  end object
  componentList.add(Reward_Slot_Hyper_Glyph)
  
  // Bottles
  begin object class=UI_Texture_Info Name=Item_Bottle_Purple
    componentTextures.add(Texture2D'ROTT_Items.Bottles.Item_Bottle_Purple')
  end object
  begin object class=UI_Texture_Info Name=Item_Bottle_Blue
    componentTextures.add(Texture2D'ROTT_Items.Bottles.Item_Bottle_Blue')
  end object
  begin object class=UI_Texture_Info Name=Item_Bottle_Green
    componentTextures.add(Texture2D'ROTT_Items.Bottles.Item_Bottle_Green')
  end object
  begin object class=UI_Texture_Info Name=Item_Bottle_Gold
    componentTextures.add(Texture2D'ROTT_Items.Bottles.Item_Bottle_Gold')
  end object
  begin object class=UI_Texture_Info Name=Item_Bottle_Orange
    componentTextures.add(Texture2D'ROTT_Items.Bottles.Item_Bottle_Orange')
  end object
  begin object class=UI_Texture_Info Name=Item_Bottle_Pink
    componentTextures.add(Texture2D'ROTT_Items.Bottles.Item_Bottle_Pink')
  end object
  
  // Reward content: Bottles
  begin object class=UI_Sprite Name=Reward_Slot_Bottles
    tag="Reward_Slot_Bottles"
    bEnabled=false
    posX=445
    posY=0
    images(0)=Item_Bottle_Purple
    images(1)=Item_Bottle_Blue
    images(2)=Item_Bottle_Green
    images(3)=Item_Bottle_Gold
    images(4)=Item_Bottle_Orange
    images(5)=Item_Bottle_Pink
  
    // Reward cycle
    activeEffects.add((effectType = EFFECT_FLIPBOOK, lifeTime = -1, elapsedTime = 0, intervalTime = 0.4))
    
  end object
  componentList.add(Reward_Slot_Bottles)
  
  // Charms
  begin object class=UI_Texture_Info Name=Charm_Blue
    componentTextures.add(Texture2D'ROTT_Items.Charms.Item_Charm_Blue')
  end object
  begin object class=UI_Texture_Info Name=Charm_Cyan
    componentTextures.add(Texture2D'ROTT_Items.Charms.Item_Charm_Teal')
  end object
  begin object class=UI_Texture_Info Name=Charm_Gold
    componentTextures.add(Texture2D'ROTT_Items.Charms.Item_Charm_Gold')
  end object
  begin object class=UI_Texture_Info Name=Charm_Green
    componentTextures.add(Texture2D'ROTT_Items.Charms.Item_Charm_Green')
  end object
  begin object class=UI_Texture_Info Name=Charm_Orange
    componentTextures.add(Texture2D'ROTT_Items.Charms.Item_Charm_Orange')
  end object
  begin object class=UI_Texture_Info Name=Charm_Purple
    componentTextures.add(Texture2D'ROTT_Items.Charms.Item_Charm_Purple')
  end object
  begin object class=UI_Texture_Info Name=Charm_Red
    componentTextures.add(Texture2D'ROTT_Items.Charms.Item_Charm_Red')
  end object
  
  // Reward content: Bottles
  begin object class=UI_Sprite Name=Reward_Slot_Charms
    tag="Reward_Slot_Charms"
    bEnabled=false
    posX=445
    posY=0
    images(0)=Charm_Blue
    images(1)=Charm_Cyan
    images(2)=Charm_Gold
    images(3)=Charm_Green
    images(4)=Charm_Orange
    images(5)=Charm_Purple
    images(6)=Charm_Red
  
    // Reward cycle
    activeEffects.add((effectType = EFFECT_FLIPBOOK, lifeTime = -1, elapsedTime = 0, intervalTime = 0.4))
    
  end object
  componentList.add(Reward_Slot_Charms)
  
  // Herbs
  begin object class=UI_Texture_Info Name=Herb_Blue
    componentTextures.add(Texture2D'ROTT_Items.Herbs.Item_Herb_Blue')
  end object
  begin object class=UI_Texture_Info Name=Herb_Cyan
    componentTextures.add(Texture2D'ROTT_Items.Herbs.Item_Herb_Cyan')
  end object
  begin object class=UI_Texture_Info Name=Herb_Gold
    componentTextures.add(Texture2D'ROTT_Items.Herbs.Item_Herb_Gold')
  end object
  begin object class=UI_Texture_Info Name=Herb_Green
    componentTextures.add(Texture2D'ROTT_Items.Herbs.Item_Herb_Green')
  end object
  begin object class=UI_Texture_Info Name=Herb_Orange
    componentTextures.add(Texture2D'ROTT_Items.Herbs.Item_Herb_Orange')
  end object
  begin object class=UI_Texture_Info Name=Herb_Purple
    componentTextures.add(Texture2D'ROTT_Items.Herbs.Item_Herb_Purple')
  end object
  begin object class=UI_Texture_Info Name=Herb_Red
    componentTextures.add(Texture2D'ROTT_Items.Herbs.Item_Herb_Red')
  end object
  begin object class=UI_Texture_Info Name=Herb_Violet
    componentTextures.add(Texture2D'ROTT_Items.Herbs.Item_Herb_Violet')
  end object
  
  // Reward content: Bottles
  begin object class=UI_Sprite Name=Reward_Slot_Herbs
    tag="Reward_Slot_Herbs"
    bEnabled=false
    posX=445
    posY=0
    images(0)=Herb_Blue
    images(1)=Herb_Cyan
    images(2)=Herb_Gold
    images(3)=Herb_Green
    images(4)=Herb_Orange
    images(5)=Herb_Purple
    images(6)=Herb_Red
    images(7)=Herb_Violet
  
    // Reward cycle
    activeEffects.add((effectType = EFFECT_FLIPBOOK, lifeTime = -1, elapsedTime = 0, intervalTime = 0.4))
    
  end object
  componentList.add(Reward_Slot_Herbs)
  
  // Ceremonial Daggers
  begin object class=UI_Texture_Info Name=Ceremonial_Dagger_Black
    componentTextures.add(Texture2D'ROTT_Items.Ceremonial_Daggers.Ceremonial_Dagger_Black')
  end object
  begin object class=UI_Texture_Info Name=Ceremonial_Dagger_Blue
    componentTextures.add(Texture2D'ROTT_Items.Ceremonial_Daggers.Ceremonial_Dagger_Blue')
  end object
  begin object class=UI_Texture_Info Name=Ceremonial_Dagger_Cyan
    componentTextures.add(Texture2D'ROTT_Items.Ceremonial_Daggers.Ceremonial_Dagger_Cyan')
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
  begin object class=UI_Texture_Info Name=Ceremonial_Dagger_White
    componentTextures.add(Texture2D'ROTT_Items.Ceremonial_Daggers.Ceremonial_Dagger_White')
  end object
  
  // Reward content: Daggers
  begin object class=UI_Sprite Name=Reward_Slot_Ceremonial_Daggers
    tag="Reward_Slot_Ceremonial_Daggers"
    bEnabled=false
    posX=445
    posY=0
    images(0)=Ceremonial_Dagger_Black
    images(1)=Ceremonial_Dagger_Blue
    images(2)=Ceremonial_Dagger_Cyan
    images(3)=Ceremonial_Dagger_Gold
    images(4)=Ceremonial_Dagger_Green
    images(5)=Ceremonial_Dagger_Orange
    images(6)=Ceremonial_Dagger_Purple
    images(7)=Ceremonial_Dagger_Red
    images(8)=Ceremonial_Dagger_Violet
    images(9)=Ceremonial_Dagger_White
  
    // Reward cycle
    activeEffects.add((effectType = EFFECT_FLIPBOOK, lifeTime = -1, elapsedTime = 0, intervalTime = 0.4))
    
  end object
  componentList.add(Reward_Slot_Ceremonial_Daggers)
  
  // Batons
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
  begin object class=UI_Texture_Info Name=Lustrous_Baton_Red
    componentTextures.add(Texture2D'ROTT_Items.Lustrous_Batons.Lustrous_Baton_Red')
  end object
  begin object class=UI_Texture_Info Name=Lustrous_Baton_Violet
    componentTextures.add(Texture2D'ROTT_Items.Lustrous_Batons.Lustrous_Baton_Violet')
  end object
  begin object class=UI_Texture_Info Name=Lustrous_Baton_White
    componentTextures.add(Texture2D'ROTT_Items.Lustrous_Batons.Lustrous_Baton_White')
  end object
  
  // Reward content: Bottles
  begin object class=UI_Sprite Name=Reward_Slot_Lustrous_Batons
    tag="Reward_Slot_Lustrous_Batons"
    bEnabled=false
    posX=445
    posY=0
    images(0)=Lustrous_Baton_Black
    images(1)=Lustrous_Baton_Blue
    images(2)=Lustrous_Baton_Cyan
    images(3)=Lustrous_Baton_Gold
    images(4)=Lustrous_Baton_Green
    images(5)=Lustrous_Baton_Orange
    images(6)=Lustrous_Baton_Purple
    images(7)=Lustrous_Baton_Red
    images(8)=Lustrous_Baton_Violet
    images(9)=Lustrous_Baton_White
  
    // Reward cycle
    activeEffects.add((effectType = EFFECT_FLIPBOOK, lifeTime = -1, elapsedTime = 0, intervalTime = 0.4))
    
  end object
  componentList.add(Reward_Slot_Lustrous_Batons)
  
  // Flails
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
  begin object class=UI_Texture_Info Name=Flail_Violet
    componentTextures.add(Texture2D'ROTT_Items.Flails.Flail_Violet')
  end object
  begin object class=UI_Texture_Info Name=Flail_White
    componentTextures.add(Texture2D'ROTT_Items.Flails.Flail_White')
  end object
  
  // Reward content: Flails
  begin object class=UI_Sprite Name=Reward_Slot_Flails
    tag="Reward_Slot_Flails"
    bEnabled=false
    posX=445
    posY=0
    images(0)=Flail_Black
    images(1)=Flail_Blue
    images(2)=Flail_Cyan
    images(3)=Flail_Gold
    images(4)=Flail_Green
    images(5)=Flail_Orange
    images(6)=Flail_Purple
    images(7)=Flail_Red
    images(8)=Flail_Violet
    images(9)=Flail_White
  
    // Reward cycle
    activeEffects.add((effectType = EFFECT_FLIPBOOK, lifeTime = -1, elapsedTime = 0, intervalTime = 0.4))
    
  end object
  componentList.add(Reward_Slot_Flails)
  
  // Bucklers
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
  begin object class=UI_Texture_Info Name=Buckler_Red
    componentTextures.add(Texture2D'ROTT_Items.Buckler_Shields.Buckler_Red')
  end object
  begin object class=UI_Texture_Info Name=Buckler_Violet
    componentTextures.add(Texture2D'ROTT_Items.Buckler_Shields.Buckler_Violet')
  end object
  begin object class=UI_Texture_Info Name=Buckler_White
    componentTextures.add(Texture2D'ROTT_Items.Buckler_Shields.Buckler_White')
  end object
  
  // Reward content: Bottles
  begin object class=UI_Sprite Name=Reward_Slot_Bucklers
    tag="Reward_Slot_Bucklers"
    bEnabled=false
    posX=445
    posY=0
    images(0)=Buckler_Black
    images(1)=Buckler_Blue
    images(2)=Buckler_Cyan
    images(3)=Buckler_Gold
    images(4)=Buckler_Green
    images(5)=Buckler_Orange
    images(6)=Buckler_Purple
    images(7)=Buckler_Red
    images(8)=Buckler_Violet
    images(9)=Buckler_White
  
    // Reward cycle
    activeEffects.add((effectType = EFFECT_FLIPBOOK, lifeTime = -1, elapsedTime = 0, intervalTime = 0.4))
    
  end object
  componentList.add(Reward_Slot_Bucklers)
  
  // Kite Shields
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
  begin object class=UI_Texture_Info Name=Kite_Shield_Violet
    componentTextures.add(Texture2D'ROTT_Items.Kite_Shield.Kite_Shield_Violet')
  end object
  begin object class=UI_Texture_Info Name=Kite_Shield_White
    componentTextures.add(Texture2D'ROTT_Items.Kite_Shield.Kite_Shield_White')
  end object
  
  // Reward content: Kite Shields
  begin object class=UI_Sprite Name=Reward_Slot_Kite_Shields
    tag="Reward_Slot_Kite_Shields"
    bEnabled=false
    posX=445
    posY=0
    images(0)=Kite_Shield_Black
    images(1)=Kite_Shield_Blue
    images(2)=Kite_Shield_Cyan
    images(3)=Kite_Shield_Gold
    images(4)=Kite_Shield_Green
    images(5)=Kite_Shield_Orange
    images(6)=Kite_Shield_Purple
    images(7)=Kite_Shield_Red
    images(8)=Kite_Shield_Violet
    images(9)=Kite_Shield_White
  
    // Reward cycle
    activeEffects.add((effectType = EFFECT_FLIPBOOK, lifeTime = -1, elapsedTime = 0, intervalTime = 0.4))
    
  end object
  componentList.add(Reward_Slot_Kite_Shields)
  
  // Paintbrushes
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
  begin object class=UI_Texture_Info Name=Paintbrush_Red
    componentTextures.add(Texture2D'ROTT_Items.Paintbrushes.Paintbrush_Red')
  end object
  begin object class=UI_Texture_Info Name=Paintbrush_Violet
    componentTextures.add(Texture2D'ROTT_Items.Paintbrushes.Paintbrush_Violet')
  end object
  begin object class=UI_Texture_Info Name=Paintbrush_White
    componentTextures.add(Texture2D'ROTT_Items.Paintbrushes.Paintbrush_White')
  end object
  
  // Reward content: Paintbrushes
  begin object class=UI_Sprite Name=Reward_Slot_Paintbrushes
    tag="Reward_Slot_Paintbrushes"
    bEnabled=false
    posX=445
    posY=0
    images(0)=Paintbrush_Black
    images(1)=Paintbrush_Blue
    images(2)=Paintbrush_Cyan
    images(3)=Paintbrush_Gold
    images(4)=Paintbrush_Green
    images(5)=Paintbrush_Orange
    images(6)=Paintbrush_Purple
    images(7)=Paintbrush_Red
    images(8)=Paintbrush_Violet
    images(9)=Paintbrush_White
  
    // Reward cycle
    activeEffects.add((effectType = EFFECT_FLIPBOOK, lifeTime = -1, elapsedTime = 0, intervalTime = 0.4))
    
  end object
  componentList.add(Reward_Slot_Paintbrushes)
  
  // Currency textures
  begin object class=UI_Texture_Info Name=Item_Currency_Gold
    componentTextures.add(Texture2D'GUI.Item_Currency_Gold')
  end object
  begin object class=UI_Texture_Info Name=Item_Currency_Gem
    componentTextures.add(Texture2D'GUI.Item_Currency_Gem')
  end object
  
  // Reward content: Currency
  begin object class=UI_Sprite Name=Reward_Slot_Currency
    tag="Reward_Slot_Currency"
    bEnabled=false
    posX=445
    posY=2
    images(0)=Item_Currency_Gold
    images(1)=Item_Currency_Gem
  end object
  componentList.add(Reward_Slot_Currency)
  
  // Cost description label
  begin object class=UI_Label Name=Reward_Description_Label
    tag="Reward_Description_Label"
    posX=144
    posY=34
    posYEnd=64
    fontStyle=DEFAULT_SMALL_TAN
    AlignX=LEFT
    AlignY=CENTER
    labelText="xxx:"
  end object
  componentList.add(Reward_Description_Label)
  
  // Cost display value
  begin object class=UI_Label Name=Reward_Quantity
    tag="Reward_Quantity"
    posX=174
    posY=86
    posYEnd=116
    AlignX=LEFT
    AlignY=CENTER
    labelText="yyy"
  end object
  componentList.add(Reward_Quantity)
  
}














