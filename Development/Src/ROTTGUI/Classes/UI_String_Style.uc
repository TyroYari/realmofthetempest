/*=============================================================================
 * UI_String_Style
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * This defines the font and draw style to be used by labels when they draw
 * text on the screen.  (See: UI_Label.uc)
 *===========================================================================*/

class UI_String_Style extends object;

// If true, start in a new line if string exceeds clipping limit.
const CARRIAGE_RETURN = false; 

// Scaling for text size
var public float scaleX, scaleY;

// Font selected from the engine packages for drawing strings
var public Font font;

// Color selected for coloring the text
var public Color drawColor;

/*============================================================================= 
 * drawString()
 *
 * Labels provide a string and call this to draw that text on screen.
 *===========================================================================*/
public function drawString
(
  Canvas C, 
  float posX, 
  float posY, 
  string drawString, 
  optional Vector2D boundScale,
  optional Color textColor = drawColor
) 
{
  // Prevent division by zero from bad bounds
  if (boundScale.X ~= 0.f) boundScale.X = 1.f;
  if (boundScale.Y ~= 0.f) boundScale.Y = 1.f;
  
  // Prevent clipping from carriage returning...
  C.SetClip(14400, 9000);
  
  // Text outlining (lower shadow)
  C.SetPos(posX + 2, posY + 2);
  C.SetDrawColor(0,0,0, textColor.A);
  C.DrawText(drawString, CARRIAGE_RETURN, scaleX * boundScale.X, scaleY * boundScale.Y);
  
  // Text outlining (lower outline)
  C.SetPos(posX + 1, posY + 1);
  C.SetDrawColor(0,0,0, textColor.A);
  C.DrawText(drawString, CARRIAGE_RETURN, scaleX * boundScale.X, scaleY * boundScale.Y);
  
  // Text outlining (upper outline)
  C.SetPos(posX - 1, posY - 1);
  C.SetDrawColor(0,0,0, textColor.A);
  C.DrawText(drawString, CARRIAGE_RETURN, scaleX * boundScale.X, scaleY * boundScale.Y);

  // Set position and color
  C.SetPos(posX, posY);
  C.SetDrawColorStruct(textColor);

  // Draw the text to the screen
  C.DrawText(drawString, CARRIAGE_RETURN, scaleX * boundScale.X, scaleY * boundScale.Y);
}

/*============================================================================= 
 * getboundScale()
 *
 * A boundScale is a necessary argument to the canvas.  I dont think I care
 * much about this though.
 *===========================================================================
final function vector2D getboundScale(Canvas C, string drawString) {
  local vector2D result;
  
  result.x = c.sizeX / 1440.f;
  result.y = c.sizeY / 900.f;
  
  return result;
}
*/
event deleteInfo() {
  font = none;
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  drawColor=(R=255,G=255,B=255,A=255) // White
  scaleX=1.f
  scaleY=1.f
}






