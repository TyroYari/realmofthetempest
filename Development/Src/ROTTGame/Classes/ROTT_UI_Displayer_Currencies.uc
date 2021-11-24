/*=============================================================================
 * ROTT_UI_Displayer_Currencies
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This object displays player currency (Gold, gems)
 *===========================================================================*/

class ROTT_UI_Displayer_Currencies extends ROTT_UI_Displayer;

// Internal UI References
var private UI_Label goldCountLabel;
var private UI_Label gemCountLabel;

/*=============================================================================
 * initializeComponent()
 *  
 * Sets up display positions
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  super.initializeComponent(newTag);
  
  // Internal references
  goldCountLabel = findLabel("Currency_Gold_Count");
  gemCountLabel = findLabel("Currency_Gem_Count");
  
}

/*============================================================================= 
 * updateCurrency
 *
 * Description: This function updates player trueCurrency on screen.
 *===========================================================================*/
public function updateCurrency(int gold, int gems) { 
  goldCountLabel.setText(class'UI_Label'.static.abbreviate(gold));
  gemCountLabel.setText(class'UI_Label'.static.abbreviate(gems));
}

/*============================================================================= 
 * Default properties
 *===========================================================================*/
defaultProperties
{
  /** ===== Textures ===== **/
  // Currency icons
  begin object class=UI_Texture_Info Name=Gem_Revised_Icon
    componentTextures.add(Texture2D'GUI.Gem_Revised_Icon')
  end object
  begin object class=UI_Texture_Info Name=Gold_Revised_Icon
    componentTextures.add(Texture2D'GUI.Gold_Revised_Icon')
  end object
  
  /** ===== UI Components ===== **/
  // Gold Sprite
  begin object class=UI_Sprite Name=Currency_Gold_Icon
    tag="Currency_Gold_Icon"
    posX=46
    posY=813
    posXEnd=110
    posYEnd=877
    images(0)=Gold_Revised_Icon
  end object
  componentList.add(Currency_Gold_Icon)
  
  // Gold Text
  begin object class=UI_Label Name=Currency_Gold_Count
    tag="Currency_Gold_Count"
    posX=-16
    posY=813
    posXEnd=264
    posYEnd=877
    fontStyle=DEFAULT_MEDIUM_WHITE
    labelText="0"
    alignX=RIGHT
    alignY=CENTER
  end object
  componentList.add(Currency_Gold_Count)
  
  // Gem Sprite
  begin object class=UI_Sprite Name=Currency_Gem_Icon
    tag="Currency_Gem_Icon"
    posX=1182
    posY=813
    posXEnd=1246
    posYEnd=877
    images(0)=Gem_Revised_Icon
  end object
  componentList.add(Currency_Gem_Icon)
  
  // Gem Text
  begin object class=UI_Label Name=Currency_Gem_Count
    tag="Currency_Gem_Count"
    posX=1120
    posY=813
    posXEnd=1400
    posYEnd=877
    fontStyle=DEFAULT_MEDIUM_WHITE
    labelText="0"
    alignX=RIGHT
    alignY=CENTER
  end object
  componentList.add(Currency_Gem_Count)

}




















