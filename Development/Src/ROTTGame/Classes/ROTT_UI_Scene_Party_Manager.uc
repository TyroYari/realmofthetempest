/*=============================================================================
 * ROTT_UI_Scene_Party_Manager
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: The party manager scene allows players to select which party
 * they wish to play as, and manage the other behavior of the other parties.
 *===========================================================================*/

class ROTT_UI_Scene_Party_Manager extends ROTT_UI_Scene;

// Internal page references
var privatewrite ROTT_UI_Page_Party_Manager partyManagerPage;
var privatewrite ROTT_UI_Page_Party_Viewer partyViewerPage;
var privatewrite ROTT_UI_Page_Active_Party_Viewer partyActivePage;
var privatewrite ROTT_UI_Page_Party_Conscription partyConscriptionPage;
var privatewrite ROTT_UI_Page_Passive_Shrine_Management shrineManagementPage;

/*=============================================================================
 * initScene()
 *
 * Called when this scene is created
 *===========================================================================*/
event initScene() {
  super.initScene();
  
  // Internal references
  partyManagerPage = ROTT_UI_Page_Party_Manager(findComp("Page_Party_Manager"));
  partyViewerPage = ROTT_UI_Page_Party_Viewer(findComp("Page_Party_Viewer"));
  partyConscriptionPage = ROTT_UI_Page_Party_Conscription(findComp("Page_Party_Conscription"));
  partyActivePage = ROTT_UI_Page_Active_Party_Viewer(findComp("Page_Party_Viewer_Active"));
  shrineManagementPage = ROTT_UI_Page_Passive_Shrine_Management(findComp("Passive_Shrine_Management"));
  
  // Initial stack
  pushPage(partyManagerPage);
}

/*=============================================================================
 * loadScene()
 *
 * Called every time the menu is opened
 *===========================================================================*/
event loadScene() {
  super.loadScene();
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
 * 
 *===========================================================================*/
public function pushPartyViewerPage() {
  // Check if selected party is actively controlled
  if (getSelectedParty() == gameInfo.getActiveParty()) {
    pushpage(partyActivePage);
  } else {
    pushpage(partyViewerPage);
  }
}

/*=============================================================================
 * 
 *===========================================================================*/
public function pushPartyConscriptionPage() {
  pushpage(partyConscriptionPage);
}

/*=============================================================================
 * conscription()
 *
 *
 *===========================================================================*/
public function conscription() {
  partyManagerPage.conscription();
}

/*=============================================================================
 * getSelectedParty()
 *
 * Returns the party selected by the party manager page
 *===========================================================================*/
public function ROTT_Party getSelectedParty() {
  return gameInfo.playerProfile.partySystem.getParty(partyManagerPage.getSelectionNumber());
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties 
{
  // Scene frame
  begin object class=ROTT_UI_Screen_Frame Name=Screen_Frame
    tag="Screen_Frame"
    bEnabled=true
  end object
  uiComponents.add(Screen_Frame)
  
  /** ===== Page Components ===== **/
  // Page Party Manager (Main page)
  begin object class=ROTT_UI_Page_Party_Manager Name=Page_Party_Manager
    tag="Page_Party_Manager"
  end object
  pageComponents.add(Page_Party_Manager)
  
  // Conscription page
  begin object class=ROTT_UI_Page_Party_Conscription Name=Page_Party_Conscription
    tag="Page_Party_Conscription"
  end object
  pageComponents.add(Page_Party_Conscription)
  
  // Party Viewer page
  begin object class=ROTT_UI_Page_Party_Viewer Name=Page_Party_Viewer
    tag="Page_Party_Viewer"
  end object
  pageComponents.add(Page_Party_Viewer)
  
  // Active Party Viewer page
  begin object class=ROTT_UI_Page_Active_Party_Viewer Name=Page_Party_Viewer_Active
    tag="Page_Party_Viewer_Active"
  end object
  pageComponents.add(Page_Party_Viewer_Active)
  
  // Passive Shrine Management
  begin object class=ROTT_UI_Page_Passive_Shrine_Management Name=Passive_Shrine_Management
    tag="Passive_Shrine_Management"
  end object
  pageComponents.add(Passive_Shrine_Management)
  
}














