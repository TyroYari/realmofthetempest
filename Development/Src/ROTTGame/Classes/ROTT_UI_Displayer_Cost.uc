/*=============================================================================
 * ROTT_UI_Displayer_Cost
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Used to display cost for a single currency.
 *===========================================================================*/

class ROTT_UI_Displayer_Cost extends ROTT_UI_Displayer;

// Display settings
var privatewrite class<ROTT_Inventory_Item> currencyType;
var privatewrite string costDescriptionText;
var public int costValue;
var public bool bAlwaysShow;

// Item graphics
var private ROTT_UI_Displayer_Item itemGraphics;

// Cost label
var private UI_Label costDescription;
var private UI_Label costQuantity;

/*============================================================================= 
 * initializeComponent
 *
 * This is called as the UI is loaded.  Our initial scene is drawn here.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  super.initializeComponent(newTag);
  
  // Internal references
  itemGraphics = ROTT_UI_Displayer_Item(findComp("Player_Inventory_Slot"));
  costDescription = findLabel("Cost_Description_Label");
  costQuantity = findLabel("Cost_Quantity");
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
 * setDonationCost()
 *
 * Sets costs specifically for a shrine donation
 *===========================================================================*/
public function setDonationCost(ItemCost costInfo) {
  currencyType = costInfo.currencyType;
  costValue = costInfo.quantity;
  
  switch(currencyType) {
    case class'ROTT_Inventory_Item_Gold':
      costDescriptionText = "Gold donation:";
      break;
    case class'ROTT_Inventory_Item_Gem':
      costDescriptionText = "Gem donation:";
      break;
      
    case class'ROTT_Inventory_Item_Herb':
    case class'ROTT_Inventory_Item_Herb_Unjah':
    case class'ROTT_Inventory_Item_Herb_Saripine':
    case class'ROTT_Inventory_Item_Herb_Koshta':
    case class'ROTT_Inventory_Item_Herb_Xuvi':
    case class'ROTT_Inventory_Item_Herb_Zeltsi':
    case class'ROTT_Inventory_Item_Herb_Aquifinie':
    case class'ROTT_Inventory_Item_Herb_Jengsu':
      costDescriptionText = "Herb donation:";
      break;
      
    case class'ROTT_Inventory_Item_Bottle_Nettle_Roots':
    case class'ROTT_Inventory_Item_Bottle_Harrier_Claws':
    case class'ROTT_Inventory_Item_Bottle_Faerie_Bones':
    case class'ROTT_Inventory_Item_Bottle_Swamp_Husks':
    case class'ROTT_Inventory_Item_Bottle_Yinras_Ore':
      costDescriptionText = "Bottle donation:";
      break;
      
    case class'ROTT_Inventory_Item_Charm_Myroka':
    case class'ROTT_Inventory_Item_Charm_Shukisu':
    case class'ROTT_Inventory_Item_Charm_Erazi':
    case class'ROTT_Inventory_Item_Charm_Bayuta':
    case class'ROTT_Inventory_Item_Charm_Eluvi':
    case class'ROTT_Inventory_Item_Charm_Kamita':
    case class'ROTT_Inventory_Item_Charm_Cerok':
      costDescriptionText = "Charm donation:";
      break;
      
    default:
      costDescriptionText = "Unhandled type " $ costInfo.currencyType;
      break;
  }
}

/*=============================================================================
 * refresh()
 *
 * Called to update the gold and gems
 *===========================================================================*/
public function refresh() {
  // Hide or show based on existing cost value
  if (bAlwaysShow) { 
    setEnabled(true);
  } else {
    setEnabled(!(costValue == 0));
  }
  
  // Set the cost description
  costDescription.setText(costDescriptionText);
  
  // Set the cost value label
  costQuantity.setText(costValue);
  
  // Set font colors for insufficient funds
  if (gameInfo.getInventoryCount(currencyType) < costValue) {
    costQuantity.setFont(DEFAULT_LARGE_RED);
  } else { 
    costQuantity.setFont(DEFAULT_LARGE_WHITE);
  }
  
  // Show player inventory
  refreshItem();
  
}

/*============================================================================= 
 * refreshItem()
 *
 * Called during a refresh to update item displayer from inventory info
 *===========================================================================*/
private function refreshItem() {
  local ROTT_Inventory_Item itemInfo;
  
  // Setup an item
  itemInfo = new currencyType;
  itemInfo.initialize();
  
  // Set quantity from profile
  itemInfo.setQuantity(gameInfo.getInventoryCount(currencyType));
  
  // Show item in displayer
  itemGraphics.updateDisplay(itemInfo);
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  bDrawRelative=true
  
  // Displayer info
  currencyType=class'ROTT_Inventory_Item_Gold'
  ///costDescriptionText="Gold cost per point:"
  costValue=100
  
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
  
  // Inventory slot
  begin object class=ROTT_UI_Displayer_Item Name=Player_Inventory_Slot
    tag="Player_Inventory_Slot"
    bShowIfSingular=true
    posX=443
    posY=0
  end object
  componentList.add(Player_Inventory_Slot)
  
  // Cost description label
  begin object class=UI_Label Name=Cost_Description_Label
    tag="Cost_Description_Label"
    posX=144
    posY=34
    posYEnd=64
    fontStyle=DEFAULT_SMALL_TAN
    AlignX=LEFT
    AlignY=CENTER
    labelText="-Init-"
  end object
  componentList.add(Cost_Description_Label)
  
  // Cost display value
  begin object class=UI_Label Name=Cost_Quantity
    tag="Cost_Quantity"
    posX=174
    posY=86
    posYEnd=116
    AlignX=LEFT
    AlignY=CENTER
    labelText="100"
  end object
  componentList.add(Cost_Quantity)
  
}














