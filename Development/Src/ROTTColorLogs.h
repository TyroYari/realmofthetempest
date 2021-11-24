/*=============================================================================
 * ROTTColorLogs
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * This header provides color coded logging messages for the console.
 * Usage: `include(ROTTColorLogs.h)
 *===========================================================================*/

// Filtering modes for each debug type
const PREFIX_DEFAULT        = '';
const PREFIX_COMBAT         = 'Combat';
const PREFIX_WORLD          = 'World';
const PREFIX_NPC            = 'NPC';
const PREFIX_UI_PAGES       = 'Interface';
const PREFIX_UI_CONTROLLERS = 'Controller';
const PREFIX_PLAYER_PROFILE = 'Profile';
const PREFIX_DATA_STRUCTURE = 'Data';
const PREFIX_HIERARCHY      = 'Hierarchy';
const PREFIX_LOOT           = 'Loot';
  
// Filtering modes for each debug type
const VERBOSE_DEFAULT        = true;
const VERBOSE_COMBAT         = false;
const VERBOSE_WORLD          = true;
const VERBOSE_NPC            = false;
const VERBOSE_UI_PAGES       = true;
const VERBOSE_UI_CONTROLLERS = false;
const VERBOSE_PLAYER_PROFILE = false;
const VERBOSE_DATA_STRUCTURE = false;
const VERBOSE_HIERARCHY      = false;
const VERBOSE_LOOT           = true;
  
// Types of debug messages
enum LogTypes {
  DEBUG_DEFAULT,
  DEBUG_COMBAT,
  DEBUG_WORLD,
  DEBUG_NPC,
  DEBUG_UI_PAGES,
  DEBUG_UI_CONTROLLERS,
  DEBUG_PLAYER_PROFILE,
  DEBUG_DATA_STRUCTURE,
  DEBUG_HIERARCHY,
  DEBUG_LOOT,
};

/*=============================================================================
 * getPrefix()
 *
 * This function maps the debug modes to their respective log prefixes
 *===========================================================================*/
static private function Name getPrefix(LogTypes logType) {
  switch (logType) {
    case DEBUG_DEFAULT:        return PREFIX_DEFAULT;
    case DEBUG_COMBAT:         return PREFIX_COMBAT;
    case DEBUG_WORLD:          return PREFIX_WORLD;
    case DEBUG_NPC:            return PREFIX_NPC;
    case DEBUG_UI_PAGES:       return PREFIX_UI_PAGES;
    case DEBUG_UI_CONTROLLERS: return PREFIX_UI_CONTROLLERS;
    case DEBUG_PLAYER_PROFILE: return PREFIX_PLAYER_PROFILE;
    case DEBUG_DATA_STRUCTURE: return PREFIX_DATA_STRUCTURE;
    case DEBUG_HIERARCHY:      return PREFIX_HIERARCHY;
    case DEBUG_LOOT:           return PREFIX_LOOT;
    default:
      yellowLog("Warning (!) Unhandled debug type");
      return '';
  }
}

/*=============================================================================
 * verboseCheck()
 *
 * This function is required to map these constants due to default properties
 * being unavailable in header files
 *===========================================================================*/
static private function bool verboseCheck(LogTypes logType) {
  switch (logType) {
    case DEBUG_DEFAULT:        return VERBOSE_DEFAULT;
    case DEBUG_COMBAT:         return VERBOSE_COMBAT;
    case DEBUG_WORLD:          return VERBOSE_WORLD;
    case DEBUG_NPC:            return VERBOSE_NPC;
    case DEBUG_UI_PAGES:       return VERBOSE_UI_PAGES;
    case DEBUG_UI_CONTROLLERS: return VERBOSE_UI_CONTROLLERS;
    case DEBUG_PLAYER_PROFILE: return VERBOSE_PLAYER_PROFILE;
    case DEBUG_DATA_STRUCTURE: return VERBOSE_DATA_STRUCTURE;
    case DEBUG_HIERARCHY:      return VERBOSE_HIERARCHY;
    case DEBUG_LOOT:           return VERBOSE_LOOT;
    default:
      yellowLog("Warning (!) Unhandled debug type");
      return false;
  }
}

// Gray
static function grayLog(coerce string logMessage, optional LogTypes logType = DEBUG_DEFAULT) {
  if (verboseCheck(logType) == false) return;
	`log(logMessage, , getPrefix(logType));
}

// Purple
static function violetlog(coerce string logMessage, optional LogTypes logType = DEBUG_DEFAULT) {
  if (verboseCheck(logType) == false) return;
	`log("1010",, 'color');	`log(logMessage, , getPrefix(logType));	`log("",, 'color');
}

static function purplog(coerce string logMessage, optional LogTypes logType = DEBUG_DEFAULT) {
  if (verboseCheck(logType) == false) return;
	`log("1011",, 'color');	`log(logMessage, , getPrefix(logType));	`log("",, 'color');
}

// Blue
static function bluelog(coerce string logMessage, optional LogTypes logType = DEBUG_DEFAULT) {
  if (verboseCheck(logType) == false) return;
	`log("0011",, 'color');	`log(logMessage, , getPrefix(logType));	`log("",, 'color');
}

static function darkbluelog(coerce string logMessage, optional LogTypes logType = DEBUG_DEFAULT) {
  if (verboseCheck(logType) == false) return;
	`log("0010",, 'color');	`log(logMessage, , getPrefix(logType));	`log("",, 'color');
}

// Cyan
static function cyanlog(coerce string logMessage, optional LogTypes logType = DEBUG_DEFAULT) {
  if (verboseCheck(logType) == false) return;
	`log("0111",, 'color');	`log(logMessage, , getPrefix(logType));	`log("",, 'color');
}

static function darkcyanlog(coerce string logMessage, optional LogTypes logType = DEBUG_DEFAULT) {
  if (verboseCheck(logType) == false) return;
	`log("0110",, 'color');	`log(logMessage, , getPrefix(logType));	`log("",, 'color');
}

// Green
static function darkgreenlog(coerce string logMessage, optional LogTypes logType = DEBUG_DEFAULT) {
  if (verboseCheck(logType) == false) return;
	`log("0100",, 'color');	`log(logMessage, , getPrefix(logType));	`log("",, 'color');
}

static function greenlog(coerce string logMessage, optional LogTypes logType = DEBUG_DEFAULT) {
  if (verboseCheck(logType) == false) return;
	`log("0101",, 'color');	`log(logMessage, , getPrefix(logType));	`log("",, 'color');
}

// Yellow
static function goldlog(coerce string logMessage, optional LogTypes logType = DEBUG_DEFAULT) {
  if (verboseCheck(logType) == false) return;
	`log("1100",, 'color');	`log(logMessage, , getPrefix(logType));	`log("",, 'color');
}

static function yellowlog(coerce string logMessage, optional LogTypes logType = DEBUG_DEFAULT) {
  if (verboseCheck(logType) == false) return;
	`log("1101",, 'color');	`log(logMessage, , getPrefix(logType));	`log("",, 'color');
}

// Red
static function darkredlog(coerce string logMessage, optional LogTypes logType = DEBUG_DEFAULT) {
  if (verboseCheck(logType) == false) return;
	`log("1000",, 'color');	`log(logMessage, , getPrefix(logType));	`log("",, 'color');
}

static function redlog(coerce string logMessage, optional LogTypes logType = DEBUG_DEFAULT) {
  if (verboseCheck(logType) == false) return;
	`log("1001",, 'color');	`log(logMessage, , getPrefix(logType));	`log("",, 'color');
}

// White
static function whitelog(coerce string logMessage, optional LogTypes logType = DEBUG_DEFAULT) {
  if (verboseCheck(logType) == false) return;
	`log("1111",, 'color');	`log(logMessage, , getPrefix(logType));	`log("",, 'color');
} 

/**============================================================================
 ** Color codes:
 ** 
 **    0000     black
 **    1000     dark red
 **    0100     dark green
 **    0010     dark blue
 **    1100     dark yellow
 **    0110     dark cyan
 **    1010     dark purple
 **    1110     grey
 **    1001     red
 **    0101     green
 **    0011     blue
 **    1101     yellow
 **    0111     cyan
 **    1011     purple
 **    1111     white
 ** 
 **=========================================================================**/

static function colorDebugDump() {
  
  whitelog    ("+++++++++++++++++++++++++++++");
  purplog     (".+*+.+*+.+*+.+* purplog      ");
  violetlog   ("                          violetlog *+.+*+.+*+.+*+.");
  bluelog     (".+*+.+*+.+*+.+* bluelog      ");
  darkbluelog ("                          darkbluelog *+.+*+.+*+.+*+.");
  cyanlog     (".+*+.+*+.+*+.+* cyanlog      ");
  darkcyanlog ("                          darkcyanlo *+.+*+.+*+.+*+.");
  greenlog    (".+*+.+*+.+*+.+* greenlog     ");
  darkgreenlog("                          darkgreenlog *+.+*+.+*+.+*+."); 
  yellowlog   (".+*+.+*+.+*+.+* yellowlog    ");
  goldlog     ("                          goldlog *+.+*+.+*+.+*+.");
  redlog      (".+*+.+*+.+*+.+* redlog       ");
  darkredlog  ("                          darkredlog *+.+*+.+*+.+*+.");
  whitelog    ("+++++++++++++++++++++++++++++");
}

























