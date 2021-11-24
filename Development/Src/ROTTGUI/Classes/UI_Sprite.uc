/*=============================================================================
 * UI_Sprite
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * This class displays a texture to the screen, with optional effects
 *===========================================================================*/

class UI_Sprite extends UI_Component_Visual;

// Default values used to find "undefined" end coordinate
const DEFAULT_END = -65535;

// Texture collection
var public instanced array<UI_Texture_Info> images;

// Draw index for which texture to use
var protectedwrite byte drawIndex;

/*=============================================================================
 * Initialize Component
 *
 * Description: This event is called as the UI is loaded.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  local int i;
  
  super.initializeComponent(newTag);
  
  // Initialize textures
  for (i = 0; i < images.length; i++) {
    if (images[i] != none) {
      images[i].initializeInfo();
    }
  }
  
  // Filter bad indices
  if (!(drawIndex < images.length)) return;
  
  // Automatically get end points
  if (images[drawIndex] != none) {
    // Anchored resize
    if (bAnchor) anchoredResize();
    
    // Fill missing end point info
    if (getXEnd() == DEFAULT_END) {
      updatePosition(
        , 
        , 
        getX() + images[drawIndex].getSizeX(),
      );
    }
    if (getYEnd() == DEFAULT_END) {
      updatePosition(
        , 
        , 
        , 
        getY() + images[drawIndex].getSizeY()
      );
    }
  }
}

/*============================================================================= 
 * drawCanvas
 *
 * Draws the component to the screen, every frame.
 *===========================================================================*/
protected function drawCanvas(Canvas canvas) {
  local color realColor;
  
  // Calculate color
  realColor = getColor();
  applyEffects(realColor);
  
  // Draw sprite to screen
  canvas.setClip(canvas.sizeX, canvas.sizeY);
  images[drawIndex].drawTexture(
    canvas, 
    getStartPosition(), 
    getEndPosition(), 
    realColor
  );
}

/*=============================================================================
 * isVisible()
 *
 * Returns true if this component should be drawn
 *===========================================================================*/
protected function bool isVisible() { 
  if (images.length == 0) return false;
  return super.isVisible() && images[drawIndex] != none;
}

/*=============================================================================
 * debugColor()
 *
 * 
 *===========================================================================*/
public function Color debugColor() { 
  local color returnColor;
  returnColor = multiplyColors(images[drawIndex].drawColor, drawColor);
  
  whitelog(" --- Color info --- ");
  cyanlog("Texture: (" $ images[drawIndex].drawColor.r $ ", " $ images[drawIndex].drawColor.g $ ", " $ images[drawIndex].drawColor.b $ ", " $ images[drawIndex].drawColor.a $ ")");
  
  cyanlog("Sprite: (" $ drawColor.r $ ", " $ drawColor.g $ ", " $ drawColor.b $ ", " $ drawColor.a $ ")");
  
  cyanlog("Visual Layer: (" $ super.getColor().r $ ", " $ super.getColor().g $ ", " $ super.getColor().b $ ", " $ super.getColor().a $ ")");
  
  return multiplyColors(super.getColor(), returnColor);
}

/*=============================================================================
 * getColor()
 *
 * Returns the draw color for the visual component
 *===========================================================================*/
protected function Color getColor() { 
  // Calculate color from visual parent, and multiply with sprite texture
  return multiplyColors(super.getColor(), images[drawIndex].drawColor);
}

/*============================================================================= 
 * hideForFadeIn()
 *
 * Called to set this component as hidden before a fade in effect
 *===========================================================================*/
public function hideForFadeIn() {
  fadeSystem.hideForFadeIn();
}

/*============================================================================= 
 * setDrawIndex()
 *
 * Sets a new index for which sprite to draw to the screen
 *===========================================================================*/
public function bool setDrawIndex(coerce byte index) {
  // Check valid index
  if (!(index < images.length)) return false;
  
  // Set index
  drawIndex = index;
  
  // Adjust scale around center point
  if (bAnchor) anchoredResize();
  return true;
}

/*=============================================================================
 * modifyTexture()
 *
 * Given a texture, applies it to the sprite
 *===========================================================================*/
public function modifyTexture(UI_Texture_Info t) {
  // Set draw info
  images[drawIndex] = t;
  
  // Skip resizing if specified
  if (bAnchor) { 
    anchoredResize(); return; 
  }

  // Fill missing end point info
  updatePosition(
    , 
    , 
    getX() + images[drawIndex].getSizeX(),
    getY() + images[drawIndex].getSizeY()
  );
  return;
}

/*=============================================================================
 * anchoredResize()
 *
 * Adjusts the position coordinates about the anchor, based on image size.
 *===========================================================================*/
public function anchoredResize() {
  local int w, h;
  bAnchor = true;
  
  w = images[drawIndex].getSizeX();
  h = images[drawIndex].getSizeY();
  updatePosition(
    anchorX - w / 2, 
    anchorY - h / 2, 
    anchorX + w / 2, 
    anchorY + h / 2
  );
  
}
/*=============================================================================
 * drawNextFrame()
 *
 * Attempts to draw the next frame.  Returns false if out of bounds.
 *===========================================================================*/
public function bool drawNextFrame() {
  return setDrawIndex(drawIndex + 1);
}

/*============================================================================= 
 * elapseTimer()
 *
 * Called every tick from the outer container page.
 *===========================================================================*/
public function elapseTimer(float deltaTime, float gameSpeedOverride) {
  // Ignore effect calculations if disabled
  if (!bEnabled) return;
  if (images.length == 0) return;
  if (images[drawIndex] == none) return;
  
  // Do generic effects before sprite effects
  super.elapseTimer(deltaTime, gameSpeedOverride);
}

/*=============================================================================
 * addHueEffect()
 *
 * Starts a hue cycle effect
 *===========================================================================*/
public function addHueEffect
(
  optional float lifeTime = -1,
  optional float intervalTime = 0.5,
  optional float startTime = 0.f,
  optional byte min = 0,
  optional byte max = 255
)
{
  local EffectInfo newEffect;
  
  // Prevent overlapping effect
  clearEffect(EFFECT_HUE_SHIFT);
  
  // Setup effect info
  newEffect.effectType = EFFECT_HUE_SHIFT;
  newEffect.lifeTime = lifeTime;
  newEffect.elapsedTime = startTime;
  newEffect.intervalTime = intervalTime;
  newEffect.min = min;
  newEffect.max = max;
  
  // Activate effect
  activeEffects.addItem(newEffect);
}

/*=============================================================================
 * addAlphaEffect()
 *
 * Adds a transparency oscillation effect
 *===========================================================================*/
public function addAlphaEffect
(
  optional float lifeTime = -1,
  optional float intervalTime = 0.5,  /// ?
  optional float startTime = 0.f,
  optional byte min = 128,            /// ?
  optional byte max = 255             /// ?
)
{
  local EffectInfo newEffect;
  
  // Prevent overlapping effect
  clearEffect(EFFECT_ALPHA_CYCLE);
  
  // Setup effect info
  newEffect.effectType = EFFECT_ALPHA_CYCLE;
  newEffect.lifeTime = lifeTime;
  newEffect.intervalTime = intervalTime;
  newEffect.min = min;
  newEffect.max = max;
  
  // Activate effect
  activeEffects.addItem(newEffect);
}

/*=============================================================================
 * addFlickerEffect()
 *
 * Adds a flickering transparency effect
 *===========================================================================*/
public function addFlickerEffect
(
  optional float lifeTime = -1,
  optional float intervalTime = 0.5,  /// ?
  optional float startTime = 0.f,
  optional byte min = 0,              /// 128
  optional byte max = 255
)
{
  local EffectInfo newEffect;
  
  // Prevent overlapping effect
  clearEffect(EFFECT_FLICKER);
  
  // Setup effect info
  newEffect.effectType = EFFECT_FLICKER;
  newEffect.lifeTime = lifeTime;
  newEffect.intervalTime = intervalTime;
  newEffect.min = min;
  newEffect.max = max;
  
  // Activate effect
  activeEffects.addItem(newEffect);
}

/*=============================================================================
 * addFlipbookEffect()
 *
 * Adds animation effects, which cycle through all of the sprites textures 
 *===========================================================================*/
public function addFlipbookEffect
(
  optional float lifeTime = -1,
  optional float intervalTime = -1,  /// ? every frame by default, yeah?
  optional float startTime = 0.f
)
{
  local EffectInfo newEffect;
  
  // Prevent overlapping effect
  clearEffect(EFFECT_FLIPBOOK);
  
  // Setup effect info
  newEffect.effectType = EFFECT_FLIPBOOK;
  newEffect.lifeTime = lifeTime;
  newEffect.intervalTime = intervalTime;
  
  // Activate effect
  activeEffects.addItem(newEffect);
}

/*=============================================================================
 * clearEffect()
 *
 * This removes all of the given effect types
 *===========================================================================*/
public function clearEffect(EffectTypes fx) {
  local int i;
  
  // Scan for effects of the given type
  for (i = activeEffects.length - 1; i >= 0; i--) {
    // Remove if effect type is found
    if (activeEffects[i].effectType == fx) activeEffects.remove(i, 1);
  }
}

/*=============================================================================
 * clearEffects()
 *
 * This removes all image effects and resets original draw information.
 *===========================================================================*/
public function clearEffects() {
  // Clear UI gerneric effects, like fade
  super.resetEffects();
  
  // Remove sprite effects
  activeEffects.length = 0;
  resetColor();
}

/*=============================================================================
 * setColor()
 *
 * Changes the draw color for all textures in this sprite
 *===========================================================================*/
public function setColor(byte r, byte g, byte b, optional byte a = 255) {
  drawColor.r = r;
  drawColor.g = g;
  drawColor.b = b;
  drawColor.a = a;
}
 
/*=============================================================================
 * resetColor()
 *
 * This should reset original draw color info for all sprites.  
 * (Note: Right now this just assumes the default color was white)
 *===========================================================================*/
public function resetColor(optional byte alpha = 255) {
  drawColor.r = 255;
  drawColor.g = 255;
  drawColor.b = 255;
  drawColor.A = alpha;
}
 
/*=============================================================================
 * setAlpha()
 *
 * Sets an opacity
 *===========================================================================*/
public function setAlpha(byte alpha) {
  drawColor.a = alpha;
}
 
/*=============================================================================
 * getDrawOptionCount()
 *
 * Returns the number of draw options (e.g. textures, fonts)
 *===========================================================================*/
public function int getDrawOptionCount() {
  return images.length;
}

/*=============================================================================
 * resetEffectTimes()
 *
 * Resets all elapsed times of effects, used to syncronize sprite effects
 *===========================================================================*/
public function resetEffectTimes() {
  local int i;
  
  for (i = 0; i < activeEffects.length; i++) {
    activeEffects[i].elapsedTime = 0;
  }
}

/*=============================================================================
 * alphaEffectOn()
 *
 * Returns true if there is an active transparency oscillation effect
 *===========================================================================*/
private function bool alphaEffectOn() {
  local int i;
  
  for (i = 0; i < activeEffects.length; i++) {
    if (activeEffects[i].effectType == EFFECT_ALPHA_CYCLE) return true;
  }
  
  return false;
}

/*=============================================================================
 * setVerticalMask()
 *
 * Draws a portion of the sprite, starting at the bottom, based on the ratio
 *===========================================================================*/
public function setVerticalMask(float ratio) {
  images[drawIndex].vertRatio = ratio;
}

/*=============================================================================
 * setHorizontalMask()
 *
 * Draws a portion of the sprite, starting at the left, based on the ratio
 *===========================================================================*/
public function setHorizontalMask(float ratio) {
  images[drawIndex].horizontalRatio = ratio;
}

/*=============================================================================
 * resetImageSize()
 *
 * Resets to default size of image
 *===========================================================================*/
public function resetImageSize() {
  if (images[drawIndex] == none) return;
  if (images[drawIndex].getTexture() == none) return;
  
  // Update end coordinates
  updatePosition(
    ,
    ,
    getX() + images[drawIndex].getSizeX(),
    getY() + images[drawIndex].getSizeY()
  );
}

/*=============================================================================
 * addTexture()
 *
 * Adds a texture to the sprite
 *===========================================================================*/
public function addTexture
(
  Texture2D sourceTexture
) 
{
  local UI_Texture_Info textureInfo;
  
  textureInfo = new class'UI_Texture_Info';
  textureInfo.componentTextures.addItem(sourceTexture);
  
  // Add new texture
  images.addItem(textureInfo);
}

/*=============================================================================
 * addSprite()
 *
 * Copies over a sprite from a UI_Texture_Storage into the next available slot
 *===========================================================================*/
public function bool addSprite
(
  UI_Texture_Storage sourceTextures, 
  optional int index = sourceTextures.images.length
) 
{
  // Check if index is in bounds of the source textures
  if (!(index < sourceTextures.images.length)) {
    return false;
  }
  
  // Add new texture
  images[images.length] = sourceTextures.images[index];
  return true;
}

/*=============================================================================
 * clearSprite()
 *
 * Clears the draw info texture
 *===========================================================================*/
public function clearSprite() {
  images[drawIndex] = none;
}

/*=============================================================================
 * copySprite()
 *
 * Copies over a sprite from a UI_Texture_Storage
 *===========================================================================*/
public function bool copySprite
(
  UI_Texture_Storage spriteInfo, 
  int index,
  optional bool bNoResize = false
) 
{
  local int w, h;
  
  // Get draw info if it exists
  if (spriteInfo == none || index >= spriteInfo.images.length) {
    images[drawIndex] = none;
    return false;
  }
  images[drawIndex] = spriteInfo.images[index];
  
  // Skip resizing if specified
  if (bNoResize) return true;
  
  // Skip resizing if specified
  if (bAnchor) { 
    anchoredResize(); return true; 
  }
  
  // Use texture dimensions defined in texture container
  w = spriteInfo.textureWidth;
  h = spriteInfo.textureHeight;
  updatePosition( , , getX() + w, getY() + h);
  
  return true;
}

/*=============================================================================
 * deleteComp()
 *
 * Called when deleting this component, to clean up memory
 *===========================================================================*/
event deleteComp() {
  images.remove(0, images.Length);
  
  super.deleteComp();
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  // These are flags to signal that the end points are unmodified
  posXEnd=DEFAULT_END
  posYEnd=DEFAULT_END
  
  drawColor=(R=255,G=255,B=255,A=255)
}


























