/*=============================================================================
 * ROTT_UI_Scene_Service_Shrine
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This scene manages the shrine service for item offerings.
 *===========================================================================*/

class ROTT_UI_Scene_Service_Shrine extends ROTT_UI_Scene;

// Pages
var privatewrite ROTT_UI_Page_Party_Selection partySelection;
var privatewrite ROTT_UI_Page_Stats_Inspection statsInspection;
var privatewrite ROTT_UI_Page_Mgmt_Window_Shrine_Offering shrineMgmt;
var privatewrite ROTT_UI_Page serviceInfoShrine;
var privatewrite UI_Label donationInfo1;
var privatewrite UI_Label donationInfo2;
var privatewrite UI_Label donationInfo3;

// Party
var private ROTT_UI_Party_Display partyDisplayer;

/*=============================================================================
 * initScene()
 *
 * Called when this scene is created
 *===========================================================================*/
event initScene() {
  super.initScene();
  
  // Internal references
  partySelection = ROTT_UI_Page_Party_Selection(findComp("Party_Selection_UI"));
  statsInspection = ROTT_UI_Page_Stats_Inspection(findComp("Stats_Inspection_UI"));
  shrineMgmt = ROTT_UI_Page_Mgmt_Window_Shrine_Offering(findComp("Shrine_Management_UI"));
  
  // References
  serviceInfoShrine = ROTT_UI_Page(findComp("Service_Info_Shrine"));
  partyDisplayer = ROTT_UI_Party_Display(serviceInfoShrine.findComp("Party_Displayer"));
  donationInfo1 = UI_Label(serviceInfoShrine.findComp("Item_Donation_Info_Line_1"));
  donationInfo2 = UI_Label(serviceInfoShrine.findComp("Item_Donation_Info_Line_2"));
  donationInfo3 = UI_Label(serviceInfoShrine.findComp("Item_Donation_Info_Line_3"));
  
}

/*=============================================================================
 * launchShrine()
 *
 * Used to set the donation parameters
 *===========================================================================*/
public function launchShrine(RitualTypes donationType) {
  local int x;
  
  // Get bonus information
  x = class'ROTT_Descriptor_Rituals'.static.getRitualBoost(donationType);
  
  // Set donation process information
  switch (donationType) {
    case RITUAL_EXPERIENCE_BOOST:
      donationInfo1.setText("Donating herbs at this shrine provides");
      donationInfo2.setText("experience to the character chosen.");
      donationInfo3.setText("+1/8 of Current Bar");
      donationInfo3.setFont(DEFAULT_SMALL_TAN);
      break;
    case RITUAL_MANA_REGEN:
      donationInfo1.setText("Donating at this shrine provides");
      donationInfo2.setText("mana regen to the character chosen.");
      donationInfo3.setText("+" $ x $ " to Mana Regeneration");
      donationInfo3.setFont(DEFAULT_SMALL_BLUE);
      break;
    case RITUAL_MANA_BOOST:
      donationInfo1.setText("Donating at this shrine provides higher");
      donationInfo2.setText("mana to the character chosen.");
      donationInfo3.setText("+" $ x $ " to Max Mana");
      donationInfo3.setFont(DEFAULT_SMALL_BLUE);
      break;
    case RITUAL_PHYSICAL_DAMAGE:
      donationInfo1.setText("Donating at this shrine provides higher");
      donationInfo2.setText("physical damage to the character chosen.");
      donationInfo3.setText("+" $ x $ "% to Physical Damage");
      donationInfo3.setFont(DEFAULT_SMALL_ORANGE);
      break;
    case RITUAL_HEALTH_BOOST:
      donationInfo1.setText("Donating at this shrine provides higher");
      donationInfo2.setText("health to the character chosen.");
      donationInfo3.setText("+" $ x $ " to Max Health");
      donationInfo3.setFont(DEFAULT_SMALL_PINK);
      break;
    case RITUAL_HEALTH_REGEN:
      donationInfo1.setText("Donating at this shrine provides");
      donationInfo2.setText("health regen to the character chosen.");
      donationInfo3.setText("+" $ x $ " to Health Regeneration");
      donationInfo3.setFont(DEFAULT_SMALL_PINK);
      break;
    case RITUAL_ARMOR:
      donationInfo1.setText("Donating at this shrine provides");
      donationInfo2.setText("armor to the character chosen.");
      donationInfo3.setText("+" $ x $ " to Armor");
      donationInfo3.setFont(DEFAULT_SMALL_TAN);
      break;
    case RITUAL_SKILL_POINT:
      donationInfo1.setText("Donating at this shrine provides a");
      donationInfo2.setText("skill point to the character chosen.");
      donationInfo3.setText("+" $ x $ " Unspent Skill Point");
      donationInfo3.setFont(DEFAULT_SMALL_TAN);
      break;
  }
  
  // Set donation cost parameters
  shrineMgmt.setRitualType(donationType);
  refresh();
}

/*=============================================================================
 * loadScene()
 *
 * Called every time the menu is opened
 *===========================================================================*/
event loadScene() {
  super.loadScene();
  
  // Show party
  partyDisplayer.renderParty(gameInfo.getActiveParty()); 
  partyDisplayer.syncIconEffects();
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
 * Default properties
 *===========================================================================*/
defaultProperties 
{
  bResetOnLoad=true
  
  // Scene frame
  begin object class=ROTT_UI_Screen_Frame Name=Screen_Frame
    tag="Screen_Frame"
    bEnabled=true
  end object
  uiComponents.add(Screen_Frame)
  
  /** ===== Pages ===== **/
  // Scene Background Page
  begin object class=ROTT_UI_Page Name=Scene_Background_Page
    tag="Scene_Background_Page"
    bInitialPage=true
    
    /** ===== Textures ===== **/
    // Left menu backgrounds
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
      images(0)=Menu_Background_Left_Texture
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
    
  end object
  pageComponents.add(Scene_Background_Page)
  
  // Stats Inspection Menu
  begin object class=ROTT_UI_Page_Stats_Inspection Name=Stats_Inspection_UI
    tag="Stats_Inspection_UI"
  end object
  pageComponents.add(Stats_Inspection_UI)
  
  // Shrine Management Window
  begin object class=ROTT_UI_Page_Mgmt_Window_Shrine_Offering Name=Shrine_Management_UI
    tag="Shrine_Management_UI"
  end object
  pageComponents.add(Shrine_Management_UI)
  
  // Service info
  begin object class=ROTT_UI_Page Name=Service_Info_Shrine
    tag="Service_Info_Shrine"
    bInitialPage=true
    
    // Half size window
    begin object class=UI_Texture_Info Name=Half_Window
      componentTextures.add(Texture2D'GUI.Reset_Cost_Window'
    end object
    
    // Window background
    begin object class=UI_Sprite Name=Service_Window
      tag="Service_Window"
      posX=0
      posY=0
      images(0)=Half_Window
    end object
    componentList.add(Service_Window)
    
    // Header label
    begin object class=UI_Label Name=Header_Label
      tag="Header_Label"
      posX=0
      posY=74
      posXEnd=720
      posYEnd=NATIVE_HEIGHT
      fontStyle=DEFAULT_LARGE_TAN
      AlignX=CENTER
      AlignY=TOP
      labelText="Item Offering Ritual"
    end object
    componentList.add(Header_Label)
      
    /** Test description stuff? **/
    // Mgmt Window - Title Label
    begin object class=UI_Label Name=Sub_Header_Label
      tag="Sub_Header_Label"
      posX=0
      posY=112
      posXEnd=720
      posYEnd=NATIVE_HEIGHT
      AlignX=CENTER
      AlignY=TOP
      labelText="(Shrine service)"
      fontStyle=DEFAULT_SMALL_GRAY
    end object
    componentList.add(Sub_Header_Label)
    
    // Mgmt Window - Description Labels
    begin object class=UI_Label Name=Shrine_Party_Selection_Info
      tag="Shrine_Party_Selection_Info"
      posX=0
      posY=151
      posXEnd=720
      posYEnd=NATIVE_HEIGHT
      AlignX=CENTER
      AlignY=TOP
      labelText="Select a character."
    end object
    componentList.add(Shrine_Party_Selection_Info)
    
    begin object class=UI_Label Name=Item_Donation_Info_Line_1
      tag="Item_Donation_Info_Line_1"
      posX=0
      posY=189
      posXEnd=720
      posYEnd=NATIVE_HEIGHT
      AlignX=CENTER
      AlignY=TOP
      labelText="Donating herbs at this shrine provides"
    end object
    componentList.add(Item_Donation_Info_Line_1)
    
    begin object class=UI_Label Name=Item_Donation_Info_Line_2
      tag="Item_Donation_Info_Line_2"
      posX=0
      posY=216
      posXEnd=720
      posYEnd=NATIVE_HEIGHT
      AlignX=CENTER
      AlignY=TOP
      labelText="experience to the character chosen."
    end object
    componentList.add(Item_Donation_Info_Line_2)
    
    begin object class=UI_Label Name=Item_Donation_Info_Line_3
      tag="Item_Donation_Info_Line_3"
      posX=0
      posY=270
      posXEnd=720
      posYEnd=NATIVE_HEIGHT
      fontStyle=DEFAULT_SMALL_PINK
      AlignX=CENTER
      AlignY=TOP
      labelText=""
    end object
    componentList.add(Item_Donation_Info_Line_3)
    
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
    
  end object
  pageComponents.add(Service_Info_Shrine)
  
  // Party selection Menu
  begin object class=ROTT_UI_Page_Party_Selection Name=Party_Selection_UI
    tag="Party_Selection_UI"
    bInitialPage=true
    
    navMode=ITEM_SHRINE_NAVIGATION
  end object
  pageComponents.add(Party_Selection_UI)
  
}









