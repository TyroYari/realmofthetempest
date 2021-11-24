/*=============================================================================
 * ROTT_UI_Page_Game_Options
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: Interface for player to change gameplay options, such as sound
 * volumes, and 
 *===========================================================================*/
 
class ROTT_UI_Page_Game_Options extends ROTT_UI_Page;

/** ============================== **/

// Game option list
enum GameOptionList {
  OPTION_RESOLUTION,
  OPTION_MUSIC_VOLUME,
  OPTION_EFFECT_VOLUME,
  OPTION_TARGET_MEMORY,
  OPTION_ACTION_MEMORY,
  OPTION_SCALE_MODE,
  OPTION_NEXT_PAGE,
};

// Resolution options
enum ResolutionOptions {
  RESOLUTION_1280_X_720,
  RESOLUTION_1366_X_768,
  RESOLUTION_1440_X_900,
  RESOLUTION_1680_X_1050,
  RESOLUTION_1768_X_992,
  RESOLUTION_1920_X_1080,
  RESOLUTION_2560_X_1080,
  RESOLUTION_2560_X_1440,
  RESOLUTION_3840_X_2160,
};

/** ============================== **/

// Internal references
var private UI_Selector optionSelector;
var private UI_Selector resolutionSelector;
var private UI_Selector scaleModeSelector;
var private UI_Slider musicSlider;
var private UI_Slider effectSlider;
var private UI_Checkbox actionMemoryCheckbox;
var private UI_Checkbox targetMemoryCheckbox;

/*============================================================================= 
 * initializeComponent
 *
 * Called once, when the scene is first initialized.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  super.initializeComponent(newTag);
  
  // Selector for choosing which option to modify
  optionSelector = UI_Selector(findComp("Menu_Selector"));
  optionSelector.onInputA = optionSelectorInputA;
  optionSelector.onInputB = optionSelectorInputB;
  
  // Resolution options
  resolutionSelector = UI_Selector(findComp("Resolution_Options"));
  resolutionSelector.onInputA = resolutionSelectorInputA;
  resolutionSelector.onInputB = widgetSelectorInputB;
  
  // Music slider
  musicSlider = UI_Slider(findComp("Slider_Music_Volume"));
  musicSlider.onInputB = widgetSelectorInputB;
  
  // Sfx slider
  effectSlider = UI_Slider(findComp("Slider_Effect_Volume"));
  effectSlider.onInputB = widgetSelectorInputB;
  
  // Check boxes
  actionMemoryCheckbox = UI_Checkbox(findComp("Action_Memory_Checkbox"));
  targetMemoryCheckbox = UI_Checkbox(findComp("Target_Memory_Checkbox"));
  
  // Scaling options
  scaleModeSelector = UI_Selector(findComp("Scaling_Options"));
  scaleModeSelector.onInputA = scaleSelectorInputA;
  scaleModeSelector.onInputB = widgetSelectorInputB;
  
}

/*============================================================================= 
 * onPushPageEvent
 *
 * Description: This event is called every time the page is pushed.
 *===========================================================================*/
event onPushPageEvent() {
  optionSelector.resetSelection();
  optionSelector.setEnabled(true);
  
  resolutionSelector.forceSelection(getCurrentResolution());
  scaleModeSelector.forceSelection(gameInfo.hud.scaleMode);
  
  // Load volume settings from preferences
  effectSlider.setKnob(gameInfo.optionsCookie.sfxVolume);
  musicSlider.setKnob(gameInfo.optionsCookie.musicVolume);
  
  // Load checkboxes from profile
  targetMemoryCheckbox.setTick(gameInfo.optionsCookie.bTickTargetMemory);
  actionMemoryCheckbox.setTick(gameInfo.optionsCookie.bTickActionMemory);
  
}

/*=============================================================================
 * onPopPageEvent()
 *
 * Called when this page is removed from the scene
 *===========================================================================*/
event onPopPageEvent() {
  // Change options data
  gameInfo.optionsCookie.bTickActionMemory = actionMemoryCheckbox.bTick;
  gameInfo.optionsCookie.bTickTargetMemory = targetMemoryCheckbox.bTick;
  `log("Action : " $ actionMemoryCheckbox.bTick);
  `log("Target : " $ targetMemoryCheckbox.bTick);
  
  // Save
  gameInfo.saveOptions();
}

/*============================================================================= 
 * refresh()
 *
 * This function should ensure that any data thats been changed will be 
 * correctly updated on the UI.
 *===========================================================================*/
public function refresh() {
  
}

/*============================================================================= 
 * onSceneActivation
 *
 * Called every time the parent scene is loaded
 *===========================================================================*/
public function onSceneActivation() {
  
}

/*=============================================================================
 * onFocusMenu()
 *
 * Called when a menu is given focus.  Assign controls, and enable graphics.
 *===========================================================================*/
event onFocusMenu() {
  
}

/*=============================================================================
 * elapseTimers()
 *
 * Ticks every frame.  Used to check for joystick navigation.
 *===========================================================================*/
public function elapseTimers(float deltaTime) {
  super.elapseTimers(deltaTime);
  
  gameInfo.optionsCookie.sfxVolume = effectSlider.sliderScalar;
  gameInfo.jukeBox.setVolume(musicSlider.sliderScalar);
}

/*=============================================================================
 * getCurrentResolution()
 *
 * Returns the current resolution
 *===========================================================================*/
public function ResolutionOptions getCurrentResolution() {
  local int resX, resY;
  resX = gameInfo.systemSettings.resX;
  resY = gameInfo.systemSettings.resY;
  
  switch (resX) {
    case 1280: return RESOLUTION_1280_X_720;
    case 1366: return RESOLUTION_1366_X_768;
    case 1440: return RESOLUTION_1440_X_900;
    case 1680: return RESOLUTION_1680_X_1050;
    case 1768: return RESOLUTION_1768_X_992;
    case 1920: return RESOLUTION_1920_X_1080;
    case 2560: 
      switch (resY) {
        case 1080: return RESOLUTION_2560_X_1080;
        case 1440: return RESOLUTION_2560_X_1440;
      }
    case 3840: return RESOLUTION_3840_X_2160;
    default: 
      yellowLog("Warning (!) Unhandled resolution: " $ resX);
      break;
  }
}

/*=============================================================================
 * isFixedScaleValid()
 *
 * Returns true if the resolution is big enough for fixed scale.
 *===========================================================================*/
public function bool isFixedScaleValid() {  
  switch (getCurrentResolution()) {
    case RESOLUTION_1280_X_720: 
    case RESOLUTION_1366_X_768: 
      return false;
  }
  return true;
}

/*============================================================================*
 * Controls
 *
 * ControllerId     the controller that generated this input key event
 * Key              the name of the key which an event occured for
 * EventType        the type of event which occured
 * AmountDepressed  for analog keys, the depression percent.
 *
 * Returns: true to consume the key event, false to pass it on.
 *===========================================================================*/
function bool onInputKey
( 
  int ControllerId, 
  name Key, 
  EInputEvent Event, 
  float AmountDepressed = 1.f, 
  bool bGamepad = false
) 
{
  // Remap for keyboard control
  if (Key == 'C' && Event == IE_Pressed) navigationRoutineRB();
  
  return super.onInputKey(ControllerId, Key, Event, AmountDepressed, bGamepad);
}

/*=============================================================================
 * Option selector input delegates
 *===========================================================================*/
public function optionSelectorInputA() {
  switch (optionSelector.getSelection()) {
    case OPTION_RESOLUTION:
      // Give control to resolution selector
      resolutionSelector.setActive(true);
      optionSelector.setActive(false);
      sfxBox.playSfx(SFX_MENU_ACCEPT);
      
      // Special effects
      resolutionSelector.graphicalSelections.addAlphaEffect(,0.6,,100,170);
      break;
    case OPTION_MUSIC_VOLUME:
      // Give control to music slider
      musicSlider.setActive(true);
      optionSelector.setActive(false);
      sfxBox.playSfx(SFX_MENU_ACCEPT);
      break;
    case OPTION_EFFECT_VOLUME:
      // Give control to effect slider
      effectSlider.setActive(true);
      optionSelector.setActive(false);
      sfxBox.playSfx(SFX_MENU_ACCEPT);
      break;
    case OPTION_TARGET_MEMORY:
      // Toggle tick state
      targetMemoryCheckbox.toggleTick();
      
      // Sound
      sfxBox.playSfx(SFX_MENU_ACCEPT);
      break;
    case OPTION_ACTION_MEMORY:
      // Toggle tick state
      actionMemoryCheckbox.toggleTick();
      
      // Sound
      sfxBox.playSfx(SFX_MENU_ACCEPT);
      break;
    case OPTION_SCALE_MODE:
      // Give control to scale mode selector
      scaleModeSelector.setActive(true);
      optionSelector.setActive(false);
      sfxBox.playSfx(SFX_MENU_ACCEPT);
      
      // Special effects
      scaleModeSelector.graphicalSelections.addAlphaEffect(,0.6,,100,170);
      break;
    case OPTION_NEXT_PAGE:
      // Navigate to next page
      parentScene.popPage();
      parentScene.pushPage(ROTT_UI_Scene_Game_Manager(parentScene).gameOptionsExtendedPage);
      
      // Sound
      sfxBox.playSfx(SFX_MENU_ACCEPT);
      break;
  }
}

public function optionSelectorInputB() {
  // Check for redirection to title menu
  if (ROTT_UI_Scene_Game_Manager(parentScene).bTitleMenuDirection) {
    gameInfo.sceneManager.switchScene(SCENE_TITLE_SCREEN);
  }
  
  // Navigate back to game management options
  parentScene.popPage();
  sfxBox.playSfx(SFX_MENU_BACK);
}

/*=============================================================================
 * Bumper inputs
 *===========================================================================*/
protected function navigationRoutineRB() {
  // Navigate to next page
  parentScene.popPage();
  parentScene.pushPage(ROTT_UI_Scene_Game_Manager(parentScene).gameOptionsExtendedPage);
  
  // Sound
  sfxBox.playSfx(SFX_MENU_ACCEPT);
}

/*=============================================================================
 * Option selector input delegates
 *===========================================================================*/
public function resolutionSelectorInputA() {
  sfxBox.playSfx(SFX_MENU_ACCEPT);
  
  // Change resolution
  switch (resolutionSelector.getSelection()) {
    case RESOLUTION_1280_X_720: gameInfo.setResolution(1280, 720); break;
    case RESOLUTION_1366_X_768: gameInfo.setResolution(1366, 768); break;
    case RESOLUTION_1440_X_900: gameInfo.setResolution(1440, 900); break;
    case RESOLUTION_1680_X_1050: gameInfo.setResolution(1680, 1050); break;
    case RESOLUTION_1768_X_992: gameInfo.setResolution(1768, 992); break;
    case RESOLUTION_1920_X_1080: gameInfo.setResolution(1920, 1080); break;
    case RESOLUTION_2560_X_1080: gameInfo.setResolution(2560, 1080); break;
    case RESOLUTION_2560_X_1440: gameInfo.setResolution(2560, 1440); break;
    case RESOLUTION_3840_X_2160: gameInfo.setResolution(3840, 2160); break;
  }
  
  // Force scale mode for sub-standard resolution
  if (gameInfo.hud.scaleMode == FIXED_SCALE) {
    switch (resolutionSelector.getSelection()) {
      case RESOLUTION_1280_X_720: 
      case RESOLUTION_1366_X_768: 
        gameInfo.hud.scaleMode = STRETCH_SCALE;
        break;
    }
  }
}

public function scaleSelectorInputA() {  
  // Change scale mode
  switch (scaleModeSelector.getSelection()) {
    case FIXED_SCALE: 
      // Check validity of selection
      if (isFixedScaleValid() == false) {
        sfxBox.playSfx(SFX_MENU_INSUFFICIENT);
        return;
      }
      
      // Assign fixed scale mode
      gameInfo.hud.scaleMode = FIXED_SCALE;
      break;
    case NO_STRETCH_SCALE:
      // Assign stretchless scale mode
      gameInfo.hud.scaleMode = NO_STRETCH_SCALE;
      break;
    case STRETCH_SCALE: 
      // Assign stretched scale mode
      gameInfo.hud.scaleMode = STRETCH_SCALE;
      break;
  }
  
  // Store option data
  gameInfo.optionsCookie.scaleModeType = gameInfo.hud.scaleMode;
  
  // Play sound  
  sfxBox.playSfx(SFX_MENU_ACCEPT);
  
  // Reset control to option selector
  clearWidgets();
  optionSelector.setActive(true);
  
  // Reset scaling widget
  scaleModeSelector.graphicalSelections.clearEffects();
  scaleModeSelector.forceSelection(gameInfo.hud.scaleMode);
}

public function widgetSelectorInputB() {
  // Reset control to option selector
  clearWidgets();
  optionSelector.setActive(true);
  
  // Reset resolution widget
  resolutionSelector.graphicalSelections.clearEffects();
  resolutionSelector.forceSelection(getCurrentResolution());
  
  // Reset scaling widget
  scaleModeSelector.graphicalSelections.clearEffects();
  scaleModeSelector.forceSelection(gameInfo.hud.scaleMode);
  
  sfxBox.playSfx(SFX_MENU_BACK);
}

/*=============================================================================
 * Assets
 *===========================================================================*/
defaultProperties
{  
  /** ===== Input ===== **/
  begin object class=ROTT_Input_Handler Name=Input_A
    inputName="XBoxTypeS_A"
    buttonComponent=none
  end object
  inputList.add(Input_A)
  
  begin object class=ROTT_Input_Handler Name=Input_B
    inputName="XBoxTypeS_B"
    buttonComponent=none
  end object
  inputList.add(Input_B)
  
  begin object class=ROTT_Input_Handler Name=Input_RB
    inputName="XboxTypeS_RightShoulder"
    buttonComponent=none
  end object
  inputList.add(Input_RB)
  
  // Scene frame
  begin object class=ROTT_UI_Screen_Frame Name=Screen_Frame
    tag="Screen_Frame"
    bEnabled=true
  end object
  componentList.add(Screen_Frame)
  
  /** ===== Textures ===== **/
  // Left menu backgrounds
  begin object class=UI_Texture_Info Name=Page_Background
    componentTextures.add(Texture2D'ROTT_GUI_Options.Options_Background')
  end object
  
  /** ===== UI Components ===== **/
  // Background
  begin object class=UI_Sprite Name=Background_Sprite
    tag="Background_Sprite"
    bEnabled=true
    posX=0
    posY=0
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    images(0)=Page_Background
  end object
  componentList.add(Background_Sprite)
  
  // Selection box
  begin object class=UI_Selector Name=Menu_Selector
    tag="Menu_Selector"
    bEnabled=true
    posX=76
    posY=158
    selectionOffset=(x=0,y=100)
    numberOfMenuOptions=7
    
    hoverCoords(0)=(xStart=136,yStart=153,xEnd=1329,yEnd=241)
    hoverCoords(1)=(xStart=136,yStart=253,xEnd=1329,yEnd=341)
    hoverCoords(2)=(xStart=136,yStart=353,xEnd=1329,yEnd=441)
    hoverCoords(3)=(xStart=136,yStart=453,xEnd=1329,yEnd=541)
    hoverCoords(4)=(xStart=136,yStart=553,xEnd=1329,yEnd=641)
    hoverCoords(5)=(xStart=136,yStart=653,xEnd=1329,yEnd=741)
    hoverCoords(6)=(xStart=136,yStart=753,xEnd=1329,yEnd=841)
    
    // Selection texture
    begin object class=UI_Texture_Info Name=Selection_Arrow_Texture
      componentTextures.add(Texture2D'GUI.Menu_Selection_Arrow')
    end object

    // Selector sprite
    begin object class=UI_Sprite Name=Selector_Sprite
      tag="Selector_Sprite"
      images(0)=Selection_Arrow_Texture
      activeEffects.add((effectType=EFFECT_ALPHA_CYCLE, lifeTime=-1, elapsedTime=0, intervalTime=0.4, min=170, max=255))
    end object
    componentList.add(Selector_Sprite)
    
    // Inactive sprite
    begin object class=UI_Sprite Name=Inactive_Selector_Sprite
      tag="Inactive_Selector_Sprite"
      images(0)=Selection_Arrow_Texture
      activeEffects.add((effectType=EFFECT_FLICKER, lifeTime=-1, elapsedTime=0, intervalTime=0.1, min=200, max=255))
    end object
    componentList.add(Inactive_Selector_Sprite)
    
  end object
  componentList.add(Menu_Selector)
  
  // Resolution options
  begin object class=UI_Texture_Info Name=Resolution_Option_1280_x_720
    componentTextures.add(Texture2D'ROTT_GUI_Options.Resolution_Option_1280_x_720')
  end object
  begin object class=UI_Texture_Info Name=Resolution_Option_1366_x_768
    componentTextures.add(Texture2D'ROTT_GUI_Options.Resolution_Option_1366_x_768')
  end object
  begin object class=UI_Texture_Info Name=Resolution_Option_1440_x_900
    componentTextures.add(Texture2D'ROTT_GUI_Options.Resolution_Option_1440_x_900')
  end object
  begin object class=UI_Texture_Info Name=Resolution_Option_1680_x_1050
    componentTextures.add(Texture2D'ROTT_GUI_Options.Resolution_Option_1680_x_1050')
  end object
  begin object class=UI_Texture_Info Name=Resolution_Option_1768_x_992
    componentTextures.add(Texture2D'ROTT_GUI_Options.Resolution_Option_1768_x_992')
  end object
  begin object class=UI_Texture_Info Name=Resolution_Option_1920_x_1080
    componentTextures.add(Texture2D'ROTT_GUI_Options.Resolution_Option_1920_x_1080')
  end object
  begin object class=UI_Texture_Info Name=Resolution_Option_2560_x_1080
    componentTextures.add(Texture2D'ROTT_GUI_Options.Resolution_Option_2560_x_1080')
  end object
  begin object class=UI_Texture_Info Name=Resolution_Option_2560_x_1440
    componentTextures.add(Texture2D'ROTT_GUI_Options.Resolution_Option_2560_x_1440')
  end object
  begin object class=UI_Texture_Info Name=Resolution_Option_3840_x_2160
    componentTextures.add(Texture2D'ROTT_GUI_Options.Resolution_Option_3840_x_2160')
  end object
  
  // Resolution options
  begin object class=UI_Selector Name=Resolution_Options
    tag="Resolution_Options"
    bActive=false
    navigationType=SELECTION_HORIZONTAL
    
    // Graphical selections
    begin object class=UI_Sprite Name=Graphical_Selections
      tag="Graphical_Selections"
      bEnabled=true
      posX=811
      posY=172
      images(RESOLUTION_1280_X_720)=Resolution_Option_1280_x_720
      images(RESOLUTION_1366_X_768)=Resolution_Option_1366_x_768
      images(RESOLUTION_1440_X_900)=Resolution_Option_1440_x_900
      images(RESOLUTION_1680_X_1050)=Resolution_Option_1680_x_1050
      images(RESOLUTION_1768_X_992)=Resolution_Option_1768_x_992
      images(RESOLUTION_1920_X_1080)=Resolution_Option_1920_x_1080
      images(RESOLUTION_2560_X_1080)=Resolution_Option_2560_x_1080
      images(RESOLUTION_2560_X_1440)=Resolution_Option_2560_x_1440
      images(RESOLUTION_3840_X_2160)=Resolution_Option_3840_x_2160
    end object
    componentList.add(Graphical_Selections)
    
  end object
  componentList.add(Resolution_Options)

  // Slider Music Volume
  begin object class=UI_Slider Name=Slider_Music_Volume
    tag="Slider_Music_Volume"
    bEnabled=true
    bActive=false
    posX=656
    posY=253
  end object
  componentList.add(Slider_Music_Volume)
  
  // Slider Effect Volume
  begin object class=UI_Slider Name=Slider_Effect_Volume
    tag="Slider_Effect_Volume"
    bEnabled=true
    bActive=false
    posX=656
    posY=353
  end object
  componentList.add(Slider_Effect_Volume)
  
  // Target Memory Checkbox
  begin object class=UI_Checkbox Name=Target_Memory_Checkbox
    tag="Target_Memory_Checkbox"
    bEnabled=true
    bDrawRelative=true
    posX=721
    posY=464
  end object
  componentList.add(Target_Memory_Checkbox)
  
  // Action Memory Checkbox
  begin object class=UI_Checkbox Name=Action_Memory_Checkbox
    tag="Action_Memory_Checkbox"
    bEnabled=true
    bDrawRelative=true
    posX=721
    posY=564
  end object
  componentList.add(Action_Memory_Checkbox)
  
  // Scaling options
  begin object class=UI_Selector Name=Scaling_Options
    tag="Scaling_Options"
    bActive=false
    navigationType=SELECTION_HORIZONTAL
    
    // Scaling options
    begin object class=UI_Texture_Info Name=Scale_Option_Fixed_Scale
      componentTextures.add(Texture2D'ROTT_GUI_Options.Scale_Option_Fixed_Scale')
    end object
    begin object class=UI_Texture_Info Name=Scale_Option_No_Stretch_Scale
      componentTextures.add(Texture2D'ROTT_GUI_Options.Scale_Option_No_Stretch_Scale')
    end object
    begin object class=UI_Texture_Info Name=Scale_Option_Stretch_Scale
      componentTextures.add(Texture2D'ROTT_GUI_Options.Scale_Option_Stretch_Scale')
    end object 
    
    // Graphical selections
    begin object class=UI_Sprite Name=Graphical_Selections
      tag="Graphical_Selections"
      bEnabled=true
      posX=673
      posY=675
      images(FIXED_SCALE)=Scale_Option_Fixed_Scale
      images(NO_STRETCH_SCALE)=Scale_Option_No_Stretch_Scale
      images(STRETCH_SCALE)=Scale_Option_Stretch_Scale
    end object
    componentList.add(Graphical_Selections)
    
  end object
  componentList.add(Scaling_Options)

  /// wip
  // Version
  begin object class=UI_Label Name=WIP_Label
    tag="WIP_Label"
    posX=0
    posY=0
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    alignX=RIGHT
    alignY=BOTTOM
    fontStyle=DEFAULT_MEDIUM_TAN
    labelText=""
  end object
  componentList.add(WIP_Label)
}
















