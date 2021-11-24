/*=============================================================================
 * UI_Label
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This label component draws text on the screen
 *===========================================================================*/
 
class UI_Label extends UI_Component_Visual; 

// Font Styles
enum FontStyles {
  DEFAULT_SMALL_WHITE,
  DEFAULT_SMALL_GRAY,
  DEFAULT_SMALL_BEIGE,
  DEFAULT_SMALL_GREEN,
  DEFAULT_SMALL_RED,
  DEFAULT_SMALL_PEACH,
  DEFAULT_SMALL_BLUE,
  DEFAULT_SMALL_PURPLE,
  DEFAULT_SMALL_TEAL,
  DEFAULT_SMALL_PINK,
  DEFAULT_SMALL_ORANGE,
  DEFAULT_SMALL_DARK_ORANGE,
  DEFAULT_SMALL_CYAN,
  DEFAULT_SMALL_DARK_CYAN,
  DEFAULT_SMALL_YELLOW,
  DEFAULT_SMALL_TAN,
  DEFAULT_SMALL_BROWN,
  DEFAULT_SMALL_DARK_GREEN,
  
  DEFAULT_MEDIUM_WHITE,
  DEFAULT_MEDIUM_GOLD,
  DEFAULT_MEDIUM_PURPLE,
  DEFAULT_MEDIUM_TEAL,
  DEFAULT_MEDIUM_PINK,
  DEFAULT_MEDIUM_YELLOW,
  DEFAULT_MEDIUM_ORANGE,
  DEFAULT_MEDIUM_PEACH,
  DEFAULT_MEDIUM_GREEN,
  DEFAULT_MEDIUM_RED,
  DEFAULT_MEDIUM_CYAN,
  DEFAULT_MEDIUM_GRAY,
  DEFAULT_MEDIUM_TAN,
  
  DEFAULT_LARGE_WHITE, 
  DEFAULT_LARGE_GOLD, 
  DEFAULT_LARGE_ORANGE, 
  DEFAULT_LARGE_RED, 
  DEFAULT_LARGE_TAN,
  DEFAULT_LARGE_CYAN,
  DEFAULT_LARGE_BLUE,
  DEFAULT_LARGE_GREEN,
  
  COMBAT_SMALL_DARK_GRAY,
  COMBAT_SMALL_RED,
  COMBAT_SMALL_TAN,
  COMBAT_SMALL_GOLD,
  COMBAT_SMALL_GRAY,
  COMBAT_SMALL_GREEN,
  COMBAT_SMALL_BLUE,
  COMBAT_SMALL_PURPLE,
  
  JOURNAL_22_BROWN,
  
};

// Fonts for label components are stored here
var protectedwrite instanced UI_String_Style uiFonts[FontStyles];

// This index corresponds to which font will be used to draw the text
var protectedwrite FontStyles fontStyle;

// Text to display on screen
var protectedwrite string labelText;

// When this label converts text to a number, the numbers stored here
var protectedwrite int numericStorage;

// Style cycler settings
///var protected bool bCycleStyles;

// These indices are optionally used for a cycle effect
var protected editinline instanced array<FontStyles> cycleStyles;
var protected int cycleIndex;

// Style cycle time
var protected float cycleStyleLength;   // cycle length in seconds
var protected float elapsedCycleTime;   // elapsed cycle time in seconds

// Scrolling text effect
var protected float charsPerSec;        // Number of characters to draw per second
var protectedwrite float scrollTime;         // Time elapsed after delay time
var protected float delayTime;          // Time to stall until scroll effect

// Padding feature
struct paddingStruct {
  var int top, left, right, bottom;
};

var protected paddingStruct padding;

// Alignment feature
enum alignEnum {
  LEFT, TOP,
  CENTER,
  RIGHT, BOTTOM
};

var public alignEnum alignY;
var public alignEnum alignX;

// Stores whether or not to abbreviate numeric values
var public bool bFormatAbbreviations;

/*============================================================================= 
 * drawCanvas()
 *
 * This event is called every frame, to display the text on screen.
 *===========================================================================*/
protected function drawCanvas(Canvas canvas) {
  local vector2D windowScale;
  local string scrollingString;
  local float X, Y, textWidth, textHeight;
  
  // Attempt to set font, exit if font fails
  if (!setFontOnCanvas(canvas)) return;
  
  // Get window scale
  windowScale.x = float(canvas.sizeX) / NATIVE_WIDTH;
  windowScale.y = float(canvas.sizeY) / NATIVE_HEIGHT;

  if (!bMandatoryScaleToWindow) {
    switch (hud.scaleMode) {
      case NO_STRETCH_SCALE:
        // Use smallest scaler
        windowScale.x = (windowScale.x < windowScale.y) ? windowScale.x : windowScale.y;
        windowScale.y = (windowScale.x < windowScale.y) ? windowScale.x : windowScale.y;
        break;
      case FIXED_SCALE:
        // Use smallest scaler
        windowScale.x = 1;
        windowScale.y = 1;
        break;
    }
  }
  
  // Get textWidth and textHeight values for this string 
  canvas.textSize(
    labelText, 
    textWidth, 
    textHeight,
    uiFonts[fontStyle].scaleX * windowScale.x, 
    uiFonts[fontStyle].scaleY * windowScale.y
  );
  
  // Calculate x and y starting coordinates
  calcAlignmentXY(x, y, textWidth, textHeight);
  
  // Calculate real time color
  realTimeColor = getColor();
  
  // begin process to draw text to screen
  if (int(scrollTime * charsPerSec) >= len(labelText)) scrollTime = -1;
  if (scrollTime == -1) {
    // Draw the full label string
    uiFonts[fontStyle].drawString(canvas, x, y, labelText, windowScale, realTimeColor);
  } else {
    // Draw the label substring on the screen
    scrollingString = left(labelText, int(scrollTime * charsPerSec));
    uiFonts[fontStyle].drawString(canvas, x, y, scrollingString, windowScale, realTimeColor);
  }
}

/*=============================================================================
 * isVisible()
 *
 * Returns true if this component should be drawn
 *===========================================================================*/
protected function bool isVisible() { 
  return super.isVisible() && !isEmptyText();
}

/*=============================================================================
 * getColor()
 *
 * Returns the draw color for the text
 *===========================================================================*/
protected function Color getColor() {
  return multiplyColors(super.getColor(), uiFonts[fontStyle].drawColor);
}

/*============================================================================= 
 * setDrawIndex()
 *
 * Switches the draw method (e.g. textures, fonts)
 *===========================================================================*/
public function bool setDrawIndex(coerce byte index) {
  if (index >= cycleStyles.length) return false;
  
  fontStyle = cycleStyles[index];
  return true;
}

/*=============================================================================
 * setFontOnCanvas()
 *
 * Called to set a font on the texture
 *===========================================================================*/
protected function bool setFontOnCanvas(out Canvas canvas) {
  if (uiFonts[fontStyle].Font != none) {
    canvas.Font = uiFonts[fontStyle].Font;
    return true;
  } else {
    yellowLog("Warning (!) Font is missing for " $ tag);
    return false;
  }
}

/*=============================================================================
 * getDelayTime()
 *
 * Returns the amount of time another label should wait until this one scrolls.
 *===========================================================================*/
public function float getDelayTime() {
  return (len(labelText) / charsPerSec) - charsPerSec * scrollTime;
}

/*=============================================================================
 * calcAlignmentXY()
 *
 * Implements label alignment options, outputs X and Y in full window pixel 
 * range. (i.e. [0, 1440]x[0, 900] if native)
 *===========================================================================*/
protected function calcAlignmentXY
(
  out float X, 
  out float Y, 
  float textWidth, 
  float textHeight
) 
{
  local int startX, startY, endX, endY;
  
  // Coordinates based on native 1440x900 resolution
  startX = getStartPosition().x + padding.left;
  startY = getStartPosition().y + padding.top;
  endX = getEndPosition().x - padding.right;
  endY = getEndPosition().y - padding.bottom;
  
  // Alignment adjustments for X based on textWidth
  switch(alignX) {
    case TOP:
      yellowLog("Warning (!) Treating alignX=TOP as LEFT");
    case LEFT:
      X = startX;
      break;
      
    case CENTER:
      X = startX + (endX - startX) / 2.0;
      X -= textWidth / 2.0;
      break;
      
    case BOTTOM:
      yellowLog("Warning (!) Treating alignX=BOTTOM as RIGHT");
    case RIGHT:
      X = endX;
      X -= textWidth;
      break;
  }
  
  // Alignment adjustments for Y based on textHeight
  switch(alignY) {
    case LEFT:
      yellowLog("Warning (!) Treating alignY=LEFT as TOP");
    case TOP:
      Y = startY;
      break;
      
    case CENTER:
      Y = startY + (endY - startY) / 2.0;
      Y -= textHeight / 2.0;
      break;
      
    case RIGHT:
      yellowLog("Warning (!) Treating alignY=RIGHT as BOTTOM");
    case BOTTOM:
      Y = endY;
      Y -= textHeight;
      break;
  }
  
  // Clamp to pixels
  x = int(x * NATIVE_WIDTH) / NATIVE_WIDTH;
  y = int(y * NATIVE_HEIGHT) / NATIVE_HEIGHT;
}

/*=============================================================================
 * elapseTimer
 *===========================================================================*/
public function elapseTimer(float deltaTime, float gameSpeedOverride) {
  super.elapseTimer(deltaTime, gameSpeedOverride);
  
  // Stall for activation delay
  if (activationDelay > 0) { return; } /// This line could be encapsulated better
  
  /// move to update()
  // Scroll effect
  if (scrollTime != -1) {
    if (delayTime > 0) {
      delayTime -= deltaTime;
      if (delayTime < 0) {
        scrollTime -= delayTime;
        deltaTime = 0;
      }
    } else {
      scrollTime += deltaTime;
    }
  }
}

/*=============================================================================
 * setAlpha()
 *
 * Sets the transparency
 *===========================================================================*/
public function setAlpha(byte alpha) {
  local int i;
  
  for (i = 0; i < FontStyles.EnumCount; i++) {
    if (uiFonts[i] != none) {
      uiFonts[i].drawColor.A = alpha;
    }
  }
}

/*=============================================================================
 * resetEffects()
 *
 * Clears the effect queue
 *===========================================================================*/
public function resetEffects(optional bool bShow = true) {
  local int i;
  
  super.resetEffects();
  
  for (i = 0; i < FontStyles.EnumCount; i++) {
    if (uiFonts[i] != none) {
      uiFonts[i].drawColor.A = (bShow) ? 255 : 0;
    }
  }
}

/*=============================================================================
 * startScrollEffect
 *===========================================================================*/
public function startScrollEffect(optional float delay = 0) {
  if (isEmptyText()) { scrollTime = -1; return; }
  scrollTime = 0;
  delayTime = delay;
}

/*=============================================================================
 * getLength()
 * 
 * Returns length of string text
 *===========================================================================*/
public function int getLength() {
  return len(labelText);
}

/*=============================================================================
 * setText
 *===========================================================================*/
public function setText(coerce string newText) {
  // Update text
  labelText = newText;
  
  // Store text as numeric value
  numericStorage = int(labelText);
  
  // Check for abbreviated formatting
  if (bFormatAbbreviations) formatNumericAbbreviations();
}

/*=============================================================================
 * setFont
 *===========================================================================*/
public function setFont(FontStyles newFont) {
  // Update font
  fontStyle = newFont;
}

/*=============================================================================
 * putChar
 *===========================================================================*/
public function putChar(coerce string newChar) {
  // Check input is valid
  if (len(newChar) != 1) return;
  
  // Concatenate new character
  labelText $= newChar;     
}

/*=============================================================================
 * removeChar
 *===========================================================================*/
public function removeChar() {
  // Check input is valid
  if (len(labelText) == 0) return;
  
  // Remove the last character
  labelText = left(labelText, len(labelText) - 1);  
}

/*=============================================================================
 * replaceText()
 *===========================================================================*/
public function replaceText(
  string textToReplace, 
  coerce string replacementText
) {
  labelText = repl(labelText, textToReplace, replacementText);
}

/*=============================================================================
 * isEmptyText()
 *===========================================================================*/
public function bool isEmptyText() {
  return (labelText == "");
}

/*=============================================================================
 * clearScrollEffect()
 *
 * Removes the effect which will instead display the full message
 *===========================================================================*/
public function clearScrollEffect() {
  scrollTime = -1;
}

/*=============================================================================
 * getDrawOptionCount()
 *
 * Returns the number of draw options (e.g. textures, fonts)
 *===========================================================================*/
public function int getDrawOptionCount() {
  return cycleStyles.length;
}

/*=============================================================================
 * formatNumericAbbreviations()
 *
 * Modifies the text with numeric abbreviations.  (e.g. K, M, B, T)
 *===========================================================================*/
public function formatNumericAbbreviations() {
  // Set display text
  labelText = abbreviate(labelText);
}

/*=============================================================================
 * abbreviate()
 *
 * Formats numeric abbreviations.  (e.g. K, M, B, T)
 *===========================================================================*/
public static function string abbreviate
(
  coerce string numericString,
  optional int thresholdK = 25000
) 
{
  local string abbreviatedText;
  
  // Ignore under threshold
  if (int(numericString) < thresholdK) return numericString;
  
  switch (len(numericString)) {
    case 5:
      abbreviatedText = left(numericString, 2);
      abbreviatedText $= ".";
      abbreviatedText $= mid(numericString, 3, 1);
      abbreviatedText $= "K";
      break;
    case 6:
      abbreviatedText = left(numericString, 3);
      abbreviatedText $= "K";
      break;
    case 7:
      abbreviatedText = left(numericString, 1);
      abbreviatedText $= ".";
      abbreviatedText $= mid(numericString, 2, 2);
      abbreviatedText $= "M";
      break;
    case 8:
      abbreviatedText = left(numericString, 2);
      abbreviatedText $= ".";
      abbreviatedText $= mid(numericString, 3, 1);
      abbreviatedText $= "M";
      break;
    case 9:
      abbreviatedText = left(numericString, 3);
      abbreviatedText $= "M";
      break;
    case 10:
      abbreviatedText = left(numericString, 1);
      abbreviatedText $= ".";
      abbreviatedText $= mid(numericString, 2, 2);
      abbreviatedText $= "B";
      break;
    /// Max value 2B, temporary until new data structures implemented
    //case 11:
    //  abbreviatedText = left(numericString, 2);
    //  abbreviatedText $= ".";
    //  abbreviatedText $= mid(numericString, 3, 1);
    //  abbreviatedText $= "B";
    //  break;
      
  }
  
  // Send the abreviated result
  return abbreviatedText;
}

/*=============================================================================
 * deleteComp
 *===========================================================================*/
event deleteComp() {
  local int i;
  
  for (i = 0; i < FontStyles.enumCount; i++) {
    //uiFonts[i].deleteInfo();
  }
  
  super.deleteComp();
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  // <FONT>_<SIZE>_<COLOR>_<optional: EFFECTS>
  
  /** ===== Fonts ===== **/
  // Cinzel: Small, White
  begin object class=UI_String_Style Name=Cinzel_Small_White
    drawColor=(R=255,G=255,B=255,A=255)
    font=Font'GUI.Fonts.Cinzel_18'
  end object
  uiFonts[DEFAULT_SMALL_WHITE]=Cinzel_Small_White
  
  // Cinzel: Small, Gray
  begin object class=UI_String_Style Name=Cinzel_Small_Gray
    drawColor=(R=185,G=185,B=185,A=255) 
    font=Font'GUI.Fonts.Cinzel_18'
  end object
  uiFonts[DEFAULT_SMALL_GRAY]=Cinzel_Small_Gray
  
  // Cinzel: Small, Beige
  begin object class=UI_String_Style Name=CINZEL_SMALL_BEIGE
    drawColor=(R=255,G=250,B=242,A=220)
    font=Font'GUI.Fonts.Cinzel_18'
  end object
  uiFonts[DEFAULT_SMALL_BEIGE]=Cinzel_Small_Beige
  
  // Cinzel: Small, Green
  begin object class=UI_String_Style Name=Cinzel_Small_Green
    drawColor=(R=80,G=235,B=90,A=255) 
    font=Font'GUI.Fonts.Cinzel_18'
  end object
  uiFonts[DEFAULT_SMALL_GREEN]=Cinzel_Small_Green
  
  // Cinzel: Small, Red
  begin object class=UI_String_Style Name=Cinzel_Small_Red
    drawColor=(R=235,G=80,B=80,A=255) 
    font=Font'GUI.Fonts.Cinzel_18'
  end object
  uiFonts[DEFAULT_SMALL_RED]=Cinzel_Small_Red
  
  // Cinzel: Small, Peach
  begin object class=UI_String_Style Name=Cinzel_Small_Peach
    drawColor=(R=235,G=103,B=103,A=255) 
    font=Font'GUI.Fonts.Cinzel_18'
  end object
  uiFonts[DEFAULT_SMALL_PEACH]=Cinzel_Small_Peach
  
  // Cinzel: Small, Blue
  begin object class=UI_String_Style Name=Cinzel_Small_Blue
    drawColor=(R=30,G=120,B=255,A=255) 
    font=Font'GUI.Fonts.Cinzel_18'
  end object
  uiFonts[DEFAULT_SMALL_BLUE]=Cinzel_Small_Blue
  
  // Cinzel: Small, Purple
  begin object class=UI_String_Style Name=Cinzel_Small_Purple
    drawColor=(R=175,G=30,B=255,A=255) 
    font=Font'GUI.Fonts.Cinzel_18'
  end object
  uiFonts[DEFAULT_SMALL_PURPLE]=Cinzel_Small_Purple
  
  // Cinzel: Small, Teal
  begin object class=UI_String_Style Name=Cinzel_Small_Teal
    drawColor=(R=72,G=252,B=177,A=255) 
    font=Font'GUI.Fonts.Cinzel_18'
  end object
  uiFonts[DEFAULT_SMALL_TEAL]=Cinzel_Small_Teal
  
  // Cinzel: Small, Pink
  begin object class=UI_String_Style Name=Cinzel_Small_Pink
    drawColor=(R=255,G=83,B=140,A=255) 
    font=Font'GUI.Fonts.Cinzel_18'
  end object
  uiFonts[DEFAULT_SMALL_PINK]=Cinzel_Small_Pink
  
  // Cinzel: Small, Orange
  begin object class=UI_String_Style Name=Cinzel_Small_Orange
    drawColor=(R=255,G=145,B=0,A=255) 
    font=Font'GUI.Fonts.Cinzel_18'
  end object
  uiFonts[DEFAULT_SMALL_ORANGE]=Cinzel_Small_Orange
  
  // Cinzel: Small, Dark Orange
  begin object class=UI_String_Style Name=Cinzel_Small_Dark_Orange
    drawColor=(R=160,G=87,B=0,A=255) 
    font=Font'GUI.Fonts.Cinzel_18'
  end object
  uiFonts[DEFAULT_SMALL_DARK_ORANGE]=Cinzel_Small_Dark_Orange
  
  // Cinzel: Small, Cyan
  begin object class=UI_String_Style Name=Cinzel_Small_Cyan
    drawColor=(R=51,G=204,B=255,A=255)
    font=Font'GUI.Fonts.Cinzel_18'
  end object
  uiFonts[DEFAULT_SMALL_CYAN]=Cinzel_Small_Cyan
  
  // Cinzel: Small, Dark Cyan
  begin object class=UI_String_Style Name=Cinzel_Small_Dark_Cyan
    drawColor=(R=0,G=102,B=145,A=255)
    font=Font'GUI.Fonts.Cinzel_18'
  end object
  uiFonts[DEFAULT_SMALL_DARK_CYAN]=Cinzel_Small_Dark_Cyan
  
  // Cinzel: Small, Yellow
  begin object class=UI_String_Style Name=Cinzel_Small_Yellow
    drawColor=(R=255,G=255,B=102,A=255)
    font=Font'GUI.Fonts.Cinzel_18'
  end object
  uiFonts[DEFAULT_SMALL_YELLOW]=Cinzel_Small_Yellow
  
  // Cinzel: Small, Tan
  begin object class=UI_String_Style Name=Cinzel_Small_Tan
    drawColor=(R=230,G=217,B=164,A=255)
    font=Font'GUI.Fonts.Cinzel_18'
  end object
  uiFonts[DEFAULT_SMALL_TAN]=Cinzel_Small_Tan

  // Cinzel: Small, Map Light-Brown
  begin object class=UI_String_Style Name=Cinzel_Small_Brown
    drawColor=(R=204,G=194,B=160,A=255)
    font=Font'GUI.Fonts.Cinzel_18'
  end object
  uiFonts[DEFAULT_SMALL_BROWN]=Cinzel_Small_Brown

  // Cinzel: Small, dark green
  begin object class=UI_String_Style Name=Cinzel_Small_Dark_green
    drawColor=(R=20,G=120,B=26,A=255) 
    font=Font'GUI.Fonts.Cinzel_18'
  end object
  uiFonts[DEFAULT_SMALL_DARK_GREEN]=Cinzel_Small_Dark_green

  // Cinzel: Medium, White
  begin object class=UI_String_Style Name=Cinzel_Medium_White
    drawColor=(R=255,G=255,B=255,A=255)
    font=Font'GUI.Fonts.Cinzel_22'
  end object
  uiFonts[DEFAULT_MEDIUM_WHITE]=Cinzel_Medium_White
  
  // Cinzel: Medium, Gold
  begin object class=UI_String_Style Name=Cinzel_Medium_Gold
    drawColor=(R=255,G=245,B=200,A=220)
    font=Font'GUI.Fonts.Cinzel_22'
  end object
  uiFonts[DEFAULT_MEDIUM_GOLD]=Cinzel_Medium_Gold
  
  // Cinzel: Medium, Teal
  begin object class=UI_String_Style Name=Cinzel_Medium_Teal
    drawColor=(R=72,G=252,B=177,A=255) 
    font=Font'GUI.Fonts.Cinzel_22'
  end object
  uiFonts[DEFAULT_MEDIUM_TEAL]=Cinzel_Medium_Teal
  
  // Cinzel: Medium, Pink
  begin object class=UI_String_Style Name=Cinzel_Medium_Pink
    drawColor=(R=255,G=83,B=140,A=255) 
    font=Font'GUI.Fonts.Cinzel_22'
  end object
  uiFonts[DEFAULT_MEDIUM_PINK]=Cinzel_Medium_Pink
  
  // Cinzel: Medium, Purple
  begin object class=UI_String_Style Name=Cinzel_Medium_Purple
    drawColor=(R=175,G=30,B=255,A=255) 
    font=Font'GUI.Fonts.Cinzel_22'
  end object
  uiFonts[DEFAULT_MEDIUM_PURPLE]=Cinzel_Medium_Purple
  
  // Cinzel: Medium, Yellow
  begin object class=UI_String_Style Name=Cinzel_Medium_Yellow
    drawColor=(R=255,G=255,B=102,A=255)
    font=Font'GUI.Fonts.Cinzel_22'
  end object
  uiFonts[DEFAULT_MEDIUM_YELLOW]=Cinzel_Medium_Yellow
  
  // Cinzel: Medium, Orange
  begin object class=UI_String_Style Name=Cinzel_Medium_Orange
    drawColor=(R=255,G=145,B=0,A=255) 
    font=Font'GUI.Fonts.Cinzel_22'
  end object
  uiFonts[DEFAULT_MEDIUM_ORANGE]=Cinzel_Medium_Orange
  
  // Cinzel: Medium, Orange
  begin object class=UI_String_Style Name=Cinzel_Medium_Peach
    drawColor=(R=255,G=170,B=88,A=255)
    font=Font'GUI.Fonts.Cinzel_22'
  end object
  uiFonts[DEFAULT_MEDIUM_PEACH]=Cinzel_Medium_Peach
  
  // Cinzel: Medium, Gray
  begin object class=UI_String_Style Name=Cinzel_Medium_Gray
    drawColor=(R=130,G=130,B=130,A=255)
    font=Font'GUI.Fonts.Cinzel_22'
  end object
  uiFonts[DEFAULT_MEDIUM_GRAY]=Cinzel_Medium_Gray
  
  // Cinzel: Medium, Green
  begin object class=UI_String_Style Name=Cinzel_Medium_Green
    drawColor=(R=80,G=235,B=90,A=255) 
    font=Font'GUI.Fonts.Cinzel_22'
  end object
  uiFonts[DEFAULT_MEDIUM_GREEN]=Cinzel_Medium_Green
  
  // Cinzel: Medium, Red
  begin object class=UI_String_Style Name=Cinzel_Medium_Red
    drawColor=(R=235,G=80,B=80,A=255) 
    font=Font'GUI.Fonts.Cinzel_22'
  end object
  uiFonts[DEFAULT_MEDIUM_RED]=Cinzel_Medium_Red
  
  // Cinzel: Medium, Cyan 
  begin object class=UI_String_Style Name=Cinzel_Medium_Cyan
    drawColor=(R=51,G=204,B=255,A=255)
    font=Font'GUI.Fonts.Cinzel_22'
  end object
  uiFonts[DEFAULT_MEDIUM_CYAN]=Cinzel_Medium_Cyan
  
  // Cinzel: Medium, Tan
  begin object class=UI_String_Style Name=Cinzel_Medium_Tan
    drawColor=(R=230,G=217,B=164,A=255)
    font=Font'GUI.Fonts.Cinzel_22'
  end object
  uiFonts[DEFAULT_MEDIUM_TAN]=Cinzel_Medium_Tan
  
  // Cinzel: Large, White
  begin object class=UI_String_Style Name=Cinzel_Large_White
    drawColor=(R=255,G=255,B=255,A=255)
    font=Font'GUI.Fonts.Cinzel_28'
  end object
  uiFonts[DEFAULT_LARGE_WHITE]=Cinzel_Large_White
  
  // Cinzel: Large, Red
  begin object class=UI_String_Style Name=Cinzel_Large_Red
    drawColor=(R=235,G=80,B=80,A=255) 
    font=Font'GUI.Fonts.Cinzel_28'
  end object
  uiFonts[DEFAULT_LARGE_RED]=Cinzel_Large_Red
  
  // Cinzel: Large, Tan
  begin object class=UI_String_Style Name=Cinzel_Large_Tan
    drawColor=(R=230,G=217,B=164,A=255)
    font=Font'GUI.Fonts.Cinzel_28'
  end object
  uiFonts[DEFAULT_LARGE_TAN]=Cinzel_Large_Tan
  
  // Cinzel: Large, Gold
  begin object class=UI_String_Style Name=Cinzel_Large_Gold
    drawColor=(R=255,G=245,B=200,A=220)
    font=Font'GUI.Fonts.Cinzel_28'
  end object
  uiFonts[DEFAULT_LARGE_GOLD]=Cinzel_Large_Gold
  
  // Cinzel: Large, Cyan
  begin object class=UI_String_Style Name=Cinzel_Large_Cyan
    drawColor=(R=51,G=204,B=255,A=255)
    font=Font'GUI.Fonts.Cinzel_28'
  end object
  uiFonts[DEFAULT_LARGE_CYAN]=Cinzel_Large_Cyan
  
  // Cinzel: Large, Blue
  begin object class=UI_String_Style Name=Cinzel_Large_Blue
    drawColor=(R=30,G=120,B=255,A=255) 
    font=Font'GUI.Fonts.Cinzel_28'
  end object
  uiFonts[DEFAULT_LARGE_BLUE]=Cinzel_Large_Blue
  
  // Cinzel: Large, Green
  begin object class=UI_String_Style Name=Cinzel_Large_Green
    drawColor=(R=114,G=238,B=123,A=255) 
    font=Font'GUI.Fonts.Cinzel_28'
  end object
  uiFonts[DEFAULT_LARGE_GREEN]=Cinzel_Large_Green
  
  // Cinzel: Large, Orange
  begin object class=UI_String_Style Name=Cinzel_Large_Orange
    drawColor=(R=255,G=170,B=88,A=255)
    font=Font'GUI.Fonts.Cinzel_28'
  end object
  uiFonts[DEFAULT_LARGE_ORANGE]=Cinzel_Large_Orange
  
  // Combat: Small, red
  begin object class=UI_String_Style Name=FriendDeed_Small_Red
    drawColor=(R=200,G=0,B=20,A=255)
    font=Font'GUI.Combat_Font_24'
  end object
  uiFonts[COMBAT_SMALL_RED]=FriendDeed_Small_Red
  
  // Combat: Small, gold
  begin object class=UI_String_Style Name=FriendDeed_Small_Gold
    //drawColor=(R=255,G=200,B=57,A=255) //g=216
    drawColor=(R=255,G=230,B=65,A=255)
    font=Font'GUI.Combat_Font_24'
  end object
  uiFonts[COMBAT_SMALL_GOLD]=FriendDeed_Small_Gold 
  
  // Combat: Small, tan
  begin object class=UI_String_Style Name=FriendDeed_Small_Tan
    drawColor=(R=255,G=245,B=200,A=220)
    font=Font'GUI.Combat_Font_24'
  end object
  uiFonts[COMBAT_SMALL_TAN]=FriendDeed_Small_Tan 
  
  // Combat: Small, green
  begin object class=UI_String_Style Name=FriendDeed_Small_Green
    drawColor=(R=30,G=237,B=168,A=255) 
    font=Font'GUI.Combat_Font_24'
  end object
  uiFonts[COMBAT_SMALL_GREEN]=FriendDeed_Small_Green
  
  // Combat: Small, dark gray
  begin object class=UI_String_Style Name=FriendDeed_Small_Dark_Gray
    drawColor=(R=20,G=20,B=20,A=255) 
    font=Font'GUI.Combat_Font_24'
  end object
  uiFonts[COMBAT_SMALL_DARK_GRAY]=FriendDeed_Small_Dark_Gray
  
  // Combat: Small, gray
  begin object class=UI_String_Style Name=FriendDeed_Small_Gray
    drawColor=(R=165,G=174,B=180,A=255) 
    font=Font'GUI.Combat_Font_24'
  end object
  uiFonts[COMBAT_SMALL_GRAY]=FriendDeed_Small_Gray
  
  // Combat: Small, blue
  begin object class=UI_String_Style Name=FriendDeed_Small_Blue
    drawColor=(R=40 ,G=167,B=255,A=255) 
    //drawColor=(R=30 ,G=200,B=245,A=255) 
    font=Font'GUI.Combat_Font_24'
  end object
  uiFonts[COMBAT_SMALL_BLUE]=FriendDeed_Small_Blue
  
  // Combat: Small, purple
  begin object class=UI_String_Style Name=FriendDeed_Small_Purple
    drawColor=(R=125,G=40,B=255,A=255) 
    font=Font'GUI.Combat_Font_24'
  end object
  uiFonts[COMBAT_SMALL_PURPLE]=FriendDeed_Small_Purple
  
  // Journal
  begin object class=UI_String_Style Name=Journal_Font_22
    ///drawColor=(R=48,G=43,B=32,A=255) 
    drawColor=(R=227,G=203,B=172,A=255) 
    font=Font'GUI.Fonts.Note_This_22'
  end object
  uiFonts[JOURNAL_22_BROWN]=Journal_Font_22
  
  // Padding
  padding=(top=0, left=12, right=12, bottom=8)
  
  // Alignment
  alignY=CENTER
  alignX=CENTER
  
  // Label effects
  scrollTime=-1
  charsPerSec=32
  cycleIndex=0
  
  // Style cycling
  ///bCycleStyles=false
  ///cycleStyleLength=0.1  // Seconds
  
}





















