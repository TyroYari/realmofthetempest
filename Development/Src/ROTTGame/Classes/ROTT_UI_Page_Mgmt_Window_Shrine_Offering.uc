/*=============================================================================
 * ROTT_UI_Page_Mgmt_Window_Shrine_Offering
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: Interface for making an offering to a shrine
 *===========================================================================*/
 
class ROTT_UI_Page_Mgmt_Window_Shrine_Offering extends ROTT_UI_Page;

// Button options
enum StatsMenuOptions {
  SHRINE_OFFERING_1,
  SHRINE_OFFERING_5,
  SHRINE_OFFERING_MAX
};

// Selector
var private UI_Selector selectionBox;

// Donation Costs
var private ROTT_UI_Displayer_Cost donationCost1;
var private ROTT_UI_Displayer_Cost donationCost2;

// Selected donation type
var privatewrite RitualTypes ritualType;

/*=============================================================================
 * Initialize Component
 *
 * Description: This event is called as the UI is loaded.
 *              Our initial scene is drawn here.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  super.initializeComponent(newTag);
  
  // References
  selectionBox = UI_Selector(findComp("Selector"));
  
  donationCost1 = ROTT_UI_Displayer_Cost(findComp("Donation_Cost_1"));
  donationCost2 = ROTT_UI_Displayer_Cost(findComp("Donation_Cost_2"));
}

/*=============================================================================
 * setRitualType()
 *
 * Sets the donation parameters
 *===========================================================================*/
public function setRitualType(RitualTypes newRitual) {
  ritualType = newRitual;
  refresh();
}

/*=============================================================================
 * refresh()
 *
 * Called to update the gold and gems
 *===========================================================================*/
public function refresh() {
  local int i;
  
  // Reset costs
  for (i = 0; i < componentList.length; i++) {
    if (ROTT_UI_Displayer_Cost(componentList[i]) != none) {
      ROTT_UI_Displayer_Cost(componentList[i]).costValue = 0;
    }
  }
  
  // Set donation price tags
  setDonationCosts(class'ROTT_Descriptor_Rituals'.static.getRitualCost(ritualType));
  
  // Refresh costs
  for (i = 0; i < componentList.length; i++) {
    if (ROTT_UI_Displayer_Cost(componentList[i]) != none) {
      ROTT_UI_Displayer_Cost(componentList[i]).refresh();
    }
  }
}

/*============================================================================= 
 * onPushPageEvent()
 *
 * This event is called every time the page is pushed.
 *===========================================================================*/
event onPushPageEvent() {
  selectionBox.resetSelection();
  refresh();
}

/*============================================================================= 
 * onPopPageEvent()
 *
 * 
 *===========================================================================*/
event onPopPageEvent() {
  
}

/*=============================================================================
 * onFocusMenu()
 *
 * Called when a menu is given focus.  Assign controls, and enable graphics.
 *===========================================================================*/
event onFocusMenu() {
  
}

/*=============================================================================
 * Button controls
 *===========================================================================*/
protected function navigationRoutineA() {
  local bool bOfferSuccess, bMaxOffering;
  local ROTT_Combat_Hero hero;
  local int shrineOfferings;
  local int i;
  
  // Get player's selection info
  hero = parentScene.getSelectedHero();
  
  // Get player's investment choice
  switch (selectionBox.getSelection()) {
    case SHRINE_OFFERING_1: 
      shrineOfferings = 1;
      break;
    case SHRINE_OFFERING_5: 
      shrineOfferings = 5;
      break;
    case SHRINE_OFFERING_MAX: 
      bMaxOffering = true;
      break;
  }
  
  // Shrine donations
  for (i = 0; i < shrineOfferings || bMaxOffering; i++) {
    // Attempt to donate
    if (hero.shrineRitual(ritualType)) {
      bOfferSuccess = true;
    } else {
      // Stop when donation fails
      break;
    }
  }
  
  // Play sound for player feedback
  if (bOfferSuccess) {
    sfxBox.playSFX(SFX_MENU_BLESS_STAT);
  } else {
    sfxBox.playSFX(SFX_MENU_INSUFFICIENT);
  }
  
  // Refresh UI display
  parentScene.refresh();
}

protected function navigationRoutineB() {
  // Pop the management page and stats
  parentScene.popPage(tag);
  parentScene.popPage("Stats_Inspection_UI");
  
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
  // Window background
  begin object class=UI_Texture_Info Name=Service_Window
    componentTextures.add(Texture2D'GUI.Reset_Cost_Window_With_Skill')
  end object
  
  /** ===== UI Components ===== **/
  // Window background
  begin object class=UI_Sprite Name=Blessing_Cost_Panel
    tag="Blessing_Cost_Panel"
    posX=0
    posY=0
    images(0)=Service_Window
  end object
  componentList.add(Blessing_Cost_Panel)
  
  // Header label
  begin object class=UI_Label Name=Header_Label
    tag="Header_Label"
    posX=0
    posY=74
    posXEnd=720
    posYEnd=NATIVE_HEIGHT
    fontStyle=DEFAULT_LARGE_WHITE
    AlignX=CENTER
    AlignY=TOP
    labelText="Shrine Donation"
  end object
  componentList.add(Header_Label)
  
  // Donation Cost Displayer #1
  begin object class=ROTT_UI_Displayer_Cost Name=Donation_Cost_1
    tag="Donation_Cost_1"
    posX=0
    posY=130
    currencyType=class'ROTT_Inventory_Item_Herb'
    costDescriptionText="Herbs needed:"
    costValue=1
  end object 
  componentList.add(Donation_Cost_1)
  
  // Donation Cost Displayer #2
  begin object class=ROTT_UI_Displayer_Cost Name=Donation_Cost_2
    tag="Donation_Cost_2"
    posX=0
    posY=272
    currencyType=class'ROTT_Inventory_Item_Gem'
    costDescriptionText="Gems needed:"
    costValue=0
  end object 
  componentList.add(Donation_Cost_2)
  
  // Donation Cost Displayer #3
  begin object class=ROTT_UI_Displayer_Cost Name=Donation_Cost_3
    tag="Donation_Cost_3"
    posX=0
    posY=414
    currencyType=class'ROTT_Inventory_Item_Bottle_Swamp_Husks'
    costDescriptionText="Bottles needed:"
    costValue=0
  end object 
  componentList.add(Donation_Cost_3)
  
  // Button textures
  begin object class=UI_Texture_Info Name=Button_Offering_1x
    componentTextures.add(Texture2D'GUI.Button_Offer_1')
  end object
  begin object class=UI_Texture_Info Name=Button_Offering_5x
    componentTextures.add(Texture2D'GUI.Button_Offer_5')
  end object
  begin object class=UI_Texture_Info Name=Button_Offer_All 
    componentTextures.add(Texture2D'GUI.Button_Offer_Max')
  end object
  
  // Buttons
  begin object class=UI_Sprite Name=Button_Offering_1x_Sprite
    tag="Button_Offering_1x_Sprite"
    posX=132
    posY=544
    images(0)=Button_Offering_1x
  end object
  componentList.add(Button_Offering_1x_Sprite)
  
  begin object class=UI_Sprite Name=Button_Offering_5x_Sprite
    tag="Button_Offering_5x_Sprite"
    posX=132
    posY=624
    images(0)=Button_Offering_5x
  end object
  componentList.add(Button_Offering_5x_Sprite)
  
  begin object class=UI_Sprite Name=Button_Offer_All_Sprite
    tag="Button_Offer_All_Sprite"
    posX=132
    posY=704
    images(0)=Button_Offer_All
  end object
  componentList.add(Button_Offer_All_Sprite)
  
  // Mgmt Window Selection Box
  begin object class=UI_Selector Name=Selector
    tag="Selector"
    bEnabled=true
    posX=144
    posY=552
    selectionOffset=(x=0,y=80)
    numberOfMenuOptions=3
    hoverCoords(0)=(xStart=146,yStart=555,xEnd=580,yEnd=625)
    hoverCoords(1)=(xStart=146,yStart=635,xEnd=580,yEnd=705)
    hoverCoords(2)=(xStart=146,yStart=715,xEnd=580,yEnd=785)
    
    // Selection texture
    begin object class=UI_Texture_Info Name=Selection_Box_Texture
      componentTextures.add(Texture2D'GUI.Mgmt_Window_Selector')
    end object

    // Selector sprite
    begin object class=UI_Sprite Name=Selector_Sprite
      tag="Selector_Sprite"
      drawLayer=TOP_LAYER
      images(0)=Selection_Box_Texture
      activeEffects.add((effectType=EFFECT_ALPHA_CYCLE, lifeTime=-1, elapsedTime=0, intervalTime=0.4, min=170, max=255))
    end object
    componentList.add(Selector_Sprite)
    
  end object
  componentList.add(Selector)
}





