/*=============================================================================
 * UI_Game_Info
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This class prepares the game info to handle interface 
 * components
 *===========================================================================*/

class UI_Game_Info extends UDKGame;
 
var protectedwrite UI_Game_Sfx sfxBox;

// Store custom settings
var public CustomSystemSettings systemSettings;
 
// Stores game option data, saved as binary file
var privatewrite Cookie_Options optionsCookie;

// Include colored debug logs
`include(ROTTColorLogs.h)

/*=============================================================================
 * initGame
 *
 * For more info on this event: 
 * https://wiki.beyondunreal.com/What_happens_at_map_startup
 *===========================================================================*/
event initGame(string options, out string errorMessage) {
  super.initGame(options, errorMessage);
  whitelog("--+-- UI_Game_Info: InitGame()       --+--");
  
  // We set up music and sfx later so they will have a correct backlink type
  // for ROTT_Game_Info
  
  // Set up system settings
  systemSettings = spawn(class'CustomSystemSettings');
  
  graylog("Loading options...");
  
  // Load options
  optionsCookie = new(self) class'Cookie_Options';
  if (class'Engine'.static.basicLoadObject(optionsCookie, "Save\\options_cookie.bin", true, 0)) {
    graylog("Option settings loaded successfully");
  } else {
    graylog("No option settings found, loading defaults.");
    
    // Default options
    optionsCookie.sfxVolume = 0.65;
    optionsCookie.musicVolume = 0.75;
    
    // Default memory selection
    optionsCookie.bTickActionMemory = true;
    optionsCookie.bTickTargetMemory = true;
  
    // Default extended options
    optionsCookie.turnSpeed = 0.75;
  
    // Default resolution
    setResolution(1440, 900);
  }
  
}

/*=============================================================================
 * postBeginPlay()
 *
 * Called when the game has started
 *===========================================================================*/
event postBeginPlay() {
  super.postBeginPlay();
}

/*=============================================================================
 * setResolution()
 *
 * This resizes the window resolution and saves the changes to system settings
 *===========================================================================*/
public function setResolution(int x, int y) {
  // Change resolution
  systemSettings.setFullscreen(false);
  systemSettings.setResX(x);
  systemSettings.setResY(y);
}

/*=============================================================================
 * saveOptions()
 *
 * This function saves the settings set by the options page.
 *===========================================================================*/
public function saveOptions() {
  // Save game options
  class'Engine'.static.basicSaveObject(optionsCookie, "Save\\options_cookie.bin", true, 0);
}

/*============================================================================= 
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  
}
















