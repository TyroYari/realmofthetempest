/*=============================================================================
 * ROTT_UI_Displayer_Item
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Used to display an item on screen
 *===========================================================================*/

class ROTT_UI_Displayer_Item extends UI_Container; /// Warning: this inheritance needs to be updated to ROTT_UI_Displayer

// Display settings
var private bool bShowIfSingular;

// Item sprite
var private UI_Sprite itemSprite;

// Quantity label
var private UI_Label quantityLabel;

// Stores true if background sprite has been set
var private bool bBackgroundOn;

/*============================================================================= 
 * initializeComponent
 *
 * This is called as the UI is loaded.  Our initial scene is drawn here.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  super.initializeComponent(newTag);
  
  // Internal references
  itemSprite = findSprite("Item_Sprite");
  quantityLabel = findLabel("Item_Quantity_Label");
  
  // Set background if called for
  if (bBackgroundOn) setBackground(true);
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
 * updateDisplay()
 *
 * Given a hero, this updates the UI with their info
 *===========================================================================*/
public function updateDisplay(ROTT_Inventory_Item item) {
  // Draw item information
  if (item != none) {
    setEnabled(true);
    
    // Show item graphic
    itemSprite.setEnabled(true);
    itemSprite.copySprite(item.itemSprite, 0, true);
    
    // Show quantity only for stacked items
    if (bShowIfSingular || item.quantity > 1 || item.quantity == 0) {
      quantityLabel.setText(class'UI_Label'.static.abbreviate(item.quantity));
    } else {
      quantityLabel.setText("");
    }
  } else {
    if (bBackgroundOn) {
      // Hide all except background
      itemSprite.setEnabled(false);
      quantityLabel.setText("");
    } else {
      // Hide all
      setEnabled(false);
    }
  }
}

/*=============================================================================
 * setFont()
 *
 * Changes text color
 *===========================================================================*/
public function setFont(FontStyles fontColor) {
  quantityLabel.setFont(fontColor);
}

/*=============================================================================
 * setBackground()
 *
 * Sets the visibility for the backgruond slot
 *===========================================================================*/
public function setBackground(bool bShow) {
  bBackgroundOn = bShow;
  findSprite("Inventory_Slot_Sprite").setEnabled(bShow);
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  bDrawRelative=true
  
  // Hide by default
  bShowIfSingular=false
  
  // Textures
  begin object class=UI_Texture_Info Name=Inventory_Slot_Texture
    componentTextures.add(Texture2D'GUI.Cost_Inventory_Slot')
  end object
  
  // Inventory slot background
  begin object class=UI_Sprite Name=Inventory_Slot_Sprite
    tag="Inventory_Slot_Sprite"
    bEnabled=false
    posX=-11
    posY=-11
    images(0)=Inventory_Slot_Texture
  end object
  componentList.add(Inventory_Slot_Sprite)
  
  // Item graphic
  begin object class=UI_Sprite Name=Item_Sprite
    tag="Item_Sprite"
    posX=0
    posY=0
    posXEnd=128
    posYEnd=128
  end object
  componentList.add(Item_Sprite)
  
  // Quantity label
  begin object class=UI_Label Name=Item_Quantity_Label
    tag="Item_Quantity_Label"
    posX=0
    posY=0
    posXEnd=125
    posYEnd=127
    AlignX=RIGHT
    AlignY=BOTTOM
    fontStyle=DEFAULT_LARGE_WHITE
    labelText=""
  end object
  componentList.add(Item_Quantity_Label)
  
}














