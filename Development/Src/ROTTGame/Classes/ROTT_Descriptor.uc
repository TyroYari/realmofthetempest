/*=============================================================================
 * ROTT_Descriptor
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * This class stores information to be passed to UI classes and combat units
 * (e.g. the text and font colors to display on the screen)
 *
 * Note that default font colors will be overriden if escape commands to fetch
 * character info have an associated color (e.g. %mana will force a blue color)
 *
 *===========================================================================*/
  
class ROTT_Descriptor extends ROTT_Object
abstract;

// This is the general format for descriptors
enum MgmtWindowLines {
  HEADER_1,
  HEADER_2,
  
  PARAGRAPH_1_LINE_1,
  PARAGRAPH_1_LINE_2,
  PARAGRAPH_1_LINE_3,
  
  PARAGRAPH_2_LINE_1,
  PARAGRAPH_2_LINE_2,
  PARAGRAPH_2_LINE_3,
  PARAGRAPH_2_LINE_4,
  
  PARAGRAPH_3_LINE_1,
  PARAGRAPH_3_LINE_2,
  PARAGRAPH_3_LINE_3,
  PARAGRAPH_3_LINE_4
};

// Label info stores the text and font for a label component
struct LabelInfo {
  var string labelText;
  var FontStyles labelFont;
};

// Each element in this array describes a line of text on the mgmt window
var protectedwrite LabelInfo displayInfo[MgmtWindowLines];

// Highlighting info
struct HighlightInfo {
  var string highlightText;
  var FontStyles hightlightColor;
};

// This stores text that should be highlighted with a specified color 
var privatewrite instanced array<HighlightInfo> coloredText;


/*=============================================================================
 * initialize()
 *
 * this function should be called by the descriptor container to set headers
 * and paragraph formatting info
 *===========================================================================*/
public function initialize() {
  // Set headers
  
  // Set paragraph information
  
}

/*=============================================================================
 * formatScript()
 *
 * This must be called when the script is accessed from the descriptor list
 * container.  
 *===========================================================================*/
public function formatScript(ROTT_Combat_Hero hero);

/*=============================================================================
 * replace()
 *
 * This is used to replace a string in the descriptor, and should only be
 * used on temporary instances since the text is permanently changed.
 *===========================================================================*/
public function replace
(
  coerce string targetText, 
  coerce string newText
) 
{
  local int i;
  
  // Replace in each line
  for (i = 0; i < MgmtWindowLines.EnumCount; i++) {
    displayInfo[i].labelText = repl(displayInfo[i].labelText, targetText, newText);
  }
}

/*=============================================================================
 * highlight()
 *
 * This is used to find keywords that need to be highlighted with special
 * font colors
 *
 * (Note: This should be called after replacement codes are in place)
 *===========================================================================*/
public function highlight
(
  coerce string targetText, 
  FontStyles fontColor
) 
{
  local int i;
  
  // Search each line
  for (i = 0; i < MgmtWindowLines.EnumCount; i++) {
    if (inStr(displayInfo[i].labelText, targetText) != -1) {
      displayInfo[i].labelFont = fontColor;
    }
  }
}

/**=============================================================================
 * getLabelInfo()
 *
 * This accessor enforces replacement codes for UI display information
 *===========================================================================
public function LabelInfo getLabelInfo(int index) {
  return displayInfo[index];
}
*/

/*=============================================================================
 * h1()
 *
 * Allows the descriptor to be edited in a clean format
 *===========================================================================*/
protected function h1
(
  string text, 
  optional FontStyles font = DEFAULT_MEDIUM_GOLD
) 
{
  displayInfo[HEADER_1].labelText = text;
  displayInfo[HEADER_1].labelFont = font;
}

/*=============================================================================
 * h2()
 *
 * Allows the descriptor to be edited in a clean format
 *===========================================================================*/
protected function h2
(
  string text, 
  optional FontStyles font = DEFAULT_SMALL_GRAY
) 
{
  displayInfo[HEADER_2].labelText = text;
  displayInfo[HEADER_2].labelFont = font;
}

/*=============================================================================
 * p1()
 *
 * Allows the descriptor to be edited in a clean format
 *===========================================================================*/
protected function p1
(
  string text1, 
  string text2, 
  string text3, 
  optional FontStyles font = DEFAULT_SMALL_WHITE
) 
{
  displayInfo[PARAGRAPH_1_LINE_1].labelText = text1;
  displayInfo[PARAGRAPH_1_LINE_2].labelText = text2;
  displayInfo[PARAGRAPH_1_LINE_3].labelText = text3;
  
  displayInfo[PARAGRAPH_1_LINE_1].labelFont = font;
  displayInfo[PARAGRAPH_1_LINE_2].labelFont = font;
  displayInfo[PARAGRAPH_1_LINE_3].labelFont = font;
}

/*=============================================================================
 * p2()
 *
 * Allows the descriptor to be edited in a clean format
 *===========================================================================*/
protected function p2
(
  string text1, 
  string text2, 
  string text3, 
  string text4, 
  optional FontStyles font = DEFAULT_SMALL_WHITE
) 
{
  displayInfo[PARAGRAPH_2_LINE_1].labelText = text1;
  displayInfo[PARAGRAPH_2_LINE_2].labelText = text2;
  displayInfo[PARAGRAPH_2_LINE_3].labelText = text3;
  displayInfo[PARAGRAPH_2_LINE_4].labelText = text4;
  
  displayInfo[PARAGRAPH_2_LINE_1].labelFont = font;
  displayInfo[PARAGRAPH_2_LINE_2].labelFont = font;
  displayInfo[PARAGRAPH_2_LINE_3].labelFont = font;
  displayInfo[PARAGRAPH_2_LINE_4].labelFont = font;
}

/*=============================================================================
 * p3()
 *
 * Allows the descriptor to be edited in a clean format
 *===========================================================================*/
protected function p3
(
  string text1, 
  string text2, 
  string text3, 
  string text4, 
  optional FontStyles font = DEFAULT_SMALL_WHITE
) 
{
  displayInfo[PARAGRAPH_3_LINE_1].labelText = text1;
  displayInfo[PARAGRAPH_3_LINE_2].labelText = text2;
  displayInfo[PARAGRAPH_3_LINE_3].labelText = text3;
  displayInfo[PARAGRAPH_3_LINE_4].labelText = text4;
  
  displayInfo[PARAGRAPH_3_LINE_1].labelFont = font;
  displayInfo[PARAGRAPH_3_LINE_2].labelFont = font;
  displayInfo[PARAGRAPH_3_LINE_3].labelFont = font;
  displayInfo[PARAGRAPH_3_LINE_4].labelFont = font;
}

/*=============================================================================
 * debugScript()
 *
 * prints the descriptor to the console window
 *===========================================================================*/
public function debugScript() {
  local int i;
  
  cyanLog("Script:");
  for (i = 0; i < MgmtWindowLines.EnumCount; i++) {
    cyanLog("  " $ displayInfo[i].labelText);
  }
}

defaultProperties 
{
  // Default warning message
  displayInfo[HEADER_1]=(labelText="WARNING - You must call initialize()", labelfont=DEFAULT_SMALL_RED)
}








