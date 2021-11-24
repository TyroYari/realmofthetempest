/*=============================================================================
 * ROTT_UI_Scene_Game_Manager
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This scene displays game management operations, like changing
 * game options, saving the game, exiting the game.
 *===========================================================================*/

class ROTT_UI_Scene_Game_Manager extends ROTT_UI_Scene;

// Pages
var privatewrite ROTT_UI_Page_Game_Manager gameManagerPage;
var privatewrite ROTT_UI_Page_Warning_Window gameMgmtWarningWindow;
var privatewrite ROTT_UI_Page_Game_Options gameOptionsPage;
var privatewrite ROTT_UI_Page_Game_Options_Extended gameOptionsExtendedPage;
var privatewrite ROTT_UI_Page_Journal journalPage;
var privatewrite ROTT_UI_Page_Control_Sheet controlSheet;
var privatewrite ROTT_UI_Page_Game_Intro contentsPage;

// If true, the options page has been accessed from the title menu
var public bool bTitleMenuDirection;

/*=============================================================================
 * initScene()
 *
 * Called when this scene is created
 *===========================================================================*/
event initScene() {
  super.initScene();
  
  // Internal references
  gameManagerPage = ROTT_UI_Page_Game_Manager(findComp("Page_Game_Manager"));
  gameMgmtWarningWindow = ROTT_UI_Page_Warning_Window(findComp("Game_Mgmt_Warning_Window"));
  gameOptionsPage = ROTT_UI_Page_Game_Options(findComp("Page_Game_Options"));
  gameOptionsExtendedPage = ROTT_UI_Page_Game_Options_Extended(findComp("Page_Game_Options_Extended"));
  journalPage = ROTT_UI_Page_Journal(findComp("Page_Journal"));
  controlSheet = ROTT_UI_Page_Control_Sheet(findComp("Page_Control_Sheet"));
  contentsPage = ROTT_UI_Page_Game_Intro(findComp("Page_Table_Of_Contents"));
  
  // Initial stack
  pushPage(gameManagerPage);

  // Warning window control
  gameMgmtWarningWindow.confirmWarningWindowDelegate = confirmWarningWindow;
  gameMgmtWarningWindow.closeWarningWindowDelegate = closeWarningWindow;
}

/*=============================================================================
 * loadScene()
 *
 * Called every time the menu is opened
 *===========================================================================*/
event loadScene() {
  super.loadScene();
  
  if (pageStack.length == 0) pushPageByTag("Page_Game_Manager");
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
 * Show warning window
 *===========================================================================*/
///public function pushWarningPage() {
///  pushpage(gameMgmtWarningWindow);
///}

/*=============================================================================
 * Delegated Warning Window functions
 *
 * These must be assigned after the scene is instantiated, it will not work
 * if assigned through default properties.
 *===========================================================================*/
public function closeWarningWindow() {
  popPage();
}

public function confirmWarningWindow() {
  gameInfo.consoleCommand("open " $ gameInfo.getMapFileName(MAP_UI_TITLE_MENU));
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties 
{
  /** ===== GUI Components ===== **/
  // Game Management Page
  begin object class=ROTT_UI_Page_Game_Manager Name=Page_Game_Manager
    tag="Page_Game_Manager"
    bEnabled=true
  end object
  pageComponents.add(Page_Game_Manager)
  
  // Warning Window
  begin object class=ROTT_UI_Page_Warning_Window Name=Game_Mgmt_Warning_Window
    tag="Game_Mgmt_Warning_Window"
    bEnabled=false
    
    header="Exit Confirmation"
    messageLine1="Are you sure you want to quit?"
    
  end object
  pageComponents.add(Game_Mgmt_Warning_Window)
  
  // Game Options Page
  begin object class=ROTT_UI_Page_Game_Options Name=Page_Game_Options
    tag="Page_Game_Options"
    bEnabled=false
  end object
  pageComponents.add(Page_Game_Options)
  
  // Game Options Page 2
  begin object class=ROTT_UI_Page_Game_Options_Extended Name=Page_Game_Options_Extended
    tag="Page_Game_Options_Extended"
    bEnabled=false
  end object
  pageComponents.add(Page_Game_Options_Extended)
  
  // Quest journal
  begin object class=ROTT_UI_Page_Journal Name=Page_Journal
    tag="Page_Journal"
    bEnabled=false
  end object
  pageComponents.add(Page_Journal)
  
  // Control Sheet
  begin object class=ROTT_UI_Page_Control_Sheet Name=Page_Control_Sheet
    tag="Page_Control_Sheet"
    bRedirectToMenu=true
    bEnabled=false
  end object
  pageComponents.add(Page_Control_Sheet)
  
  // Contents Page
  begin object class=ROTT_UI_Page_Game_Intro Name=Page_Table_Of_Contents
    tag="Page_Table_Of_Contents"
    bRedirectToMenu=true
    bEnabled=false
  end object
  pageComponents.add(Page_Table_Of_Contents)
  
}









