/*=============================================================================
 * ROTT_UI_Page_Mgmt_Window_Stats
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This management window allows player to allocate unspent stat 
 * points 
 *===========================================================================*/
 
class ROTT_UI_Page_Mgmt_Window_Stats extends ROTT_UI_Page_Mgmt_Window;

enum StatsMenuOptions {
  STATS_INVEST_1,
  STATS_INVEST_5,
  STATS_INVEST_ALL
};

/*=============================================================================
 * Button controls
 *===========================================================================*/
protected function navigationRoutineA() {
  local ROTT_Combat_Hero hero;
  local int spendAmount;
  local byte selection;
  
  // Get player's selection info
  hero = parentScene.getSelectedHero();
  selection = someScene.getSelectedStat();
  
  // Get player's investment choice
  switch (selectionBox.getSelection()) {
    case STATS_INVEST_1: 
      spendAmount = 1;
      break;
    case STATS_INVEST_5: 
      spendAmount = 5;
      break;
    case STATS_INVEST_ALL: 
      spendAmount = hero.unspentStatPoints;
      break;
  }
  
  // Attempt to invest stat points
  if (spendAmount > 0 && spendAmount <= hero.unspentStatPoints) {
    hero.investStats(spendAmount, StatTypes(selection));
    sfxBox.playSFX(SFX_MENU_INVEST_STAT);
  } else {
    sfxBox.playSFX(SFX_MENU_INSUFFICIENT);
  }
  
  parentScene.refresh();
}

/*=============================================================================
 * Assets
 *===========================================================================*/
defaultProperties
{
  // Number of menu options
  selectOptionsCount=3
  
  /** ===== Input ===== **/
  begin object class=ROTT_Input_Handler Name=Input_A
    inputName="XBoxTypeS_A"
    buttonComponent=none
  end object
  inputList.add(Input_A)
  
  /** ===== Textures ===== **/
  // Buttons
  begin object class=UI_Texture_Info Name=Button_Invest_1
    componentTextures.add(Texture2D'GUI.Button_Invest_1')
  end object
  begin object class=UI_Texture_Info Name=Button_Invest_5
    componentTextures.add(Texture2D'GUI.Button_Invest_5')
  end object
  begin object class=UI_Texture_Info Name=Button_Invest_All
    componentTextures.add(Texture2D'GUI.Button_Invest_All')
  end object
  
  /** ===== UI Components ===== **/
  // Buttons
  begin object class=UI_Sprite Name=Button_Invest_1_Sprite
    tag="Button_Invest_1_Sprite"
    posX=132
    posY=544
    images(0)=Button_Invest_1
  end object
  componentList.add(Button_Invest_1_Sprite)
  
  begin object class=UI_Sprite Name=Button_Invest_5_Sprite
    tag="Button_Invest_5_Sprite"
    posX=132
    posY=624
    images(0)=Button_Invest_5
  end object
  componentList.add(Button_Invest_5_Sprite)
  
  begin object class=UI_Sprite Name=Button_Invest_All_Sprite
    tag="Button_Invest_All_Sprite"
    posX=132
    posY=704
    images(0)=Button_Invest_All
  end object
  componentList.add(Button_Invest_All_Sprite)
  
}
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  