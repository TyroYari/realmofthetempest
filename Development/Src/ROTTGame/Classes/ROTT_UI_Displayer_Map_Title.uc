/*=============================================================================
 * ROTT_UI_Displayer_Map_Title
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: Displays the name of maps in the game world, along with the
 * type of subregion (Towns, Citadels, Wildernesses, etc...) 
 *===========================================================================*/

/// This class should derive from a 'static displayer' w.i.p.
class ROTT_UI_Displayer_Map_Title extends ROTT_UI_Displayer;

// A list of each type of subregion
enum MainRegions {
  REGION_TALONOVIA,
  REGION_RHUNIA,
  REGION_ETZLAND,
  REGION_HAXLYN,
  REGION_VALIMOR,
  REGION_KALROTH,
  REGION_SEVENTH_HOUSE,
  REGION_AKSALOM,
};

// A list of each type of subregion
enum SubRegions {
  SUBREGION_TOWN,         // Blue
  SUBREGION_CITADEL,      // Orange
  SUBREGION_WILDERNESS,   // Gold
  SUBREGION_CAVES,        // Red
  SUBREGION_BACKLANDS,    // Purple
  SUBREGION_OUTSKIRTS,    // Gray
  SUBREGION_MOUNTAIN_SHRINE,
};

// Internal references
var privatewrite UI_Container mapGreeter;
var privatewrite UI_Sprite mapTitle;
var privatewrite UI_Sprite areaSubregion;

/*============================================================================= 
 * initializeComponent()
 *
 * Called once, when the scene is first initialized.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  // Draw each component
  super.initializeComponent(newTag);
  
  // Link to sprites
  mapTitle = findSprite("Map_Title_Sprite");
  areaSubregion = findSprite("Subregion_Sprite");
  
  // Plug in the region display information
  setRegionSprite();
  setSubregionSprite();
  
  // Set fade routines for region label
  mapTitle.addEffectToQueue(DELAY, 1.2);
  mapTitle.addEffectToQueue(FADE_IN, 1);
  mapTitle.addEffectToQueue(DELAY, 1.6);
  mapTitle.addEffectToQueue(FADE_OUT, 1);
  
  // Set fade routines for subregion label
  areaSubregion.addEffectToQueue(DELAY, 1.25);
  areaSubregion.addEffectToQueue(FADE_IN, 0.85);
  areaSubregion.addEffectToQueue(DELAY, 1.45);
  areaSubregion.addEffectToQueue(FADE_OUT, 1.25);
  
}

/*=============================================================================
 * setRegionSprite()
 *
 * Sets region display sprite, based on map information.
 *===========================================================================*/
private function setRegionSprite() {
  // Area title
  switch (gameInfo.getCurrentMap()) {
    case MAP_UI_TITLE_MENU:
    case MAP_UI_CREDITS:
    case MAP_UI_GAME_OVER:
      // No area title
      break;
    case MAP_TALONOVIA_TOWN:
    case MAP_TALONOVIA_OUTSKIRTS:
    case MAP_TALONOVIA_BACKLANDS:
    case MAP_TALONOVIA_SHRINE:
      mapTitle.setDrawIndex(REGION_TALONOVIA); 
      break;
    case MAP_RHUNIA_CITADEL:
    case MAP_RHUNIA_WILDERNESS:
    case MAP_RHUNIA_BACKLANDS:
    case MAP_RHUNIA_OUTSKIRTS:
    case MAP_MOUNTAIN_SHRINE:
      mapTitle.setDrawIndex(REGION_RHUNIA); 
      break;
    case MAP_ETZLAND_CITADEL:
    case MAP_ETZLAND_WILDERNESS:
    case MAP_ETZLAND_BACKLANDS:
    case MAP_ETZLAND_OUTSKIRTS:
      mapTitle.setDrawIndex(REGION_ETZLAND);  
      break;
    case MAP_HAXLYN_CITADEL:
    case MAP_HAXLYN_WILDERNESS:
    case MAP_HAXLYN_BACKLANDS:
    case MAP_HAXLYN_OUTSKIRTS:
      mapTitle.setDrawIndex(REGION_HAXLYN);  
      break;
    case MAP_VALIMOR_CITADEL:
    case MAP_VALIMOR_WILDERNESS:
    case MAP_VALIMOR_BACKLANDS:
    case MAP_VALIMOR_OUTSKIRTS:
      mapTitle.setDrawIndex(REGION_VALIMOR);  
      break;
    case MAP_KALROTH_CITADEL:
    case MAP_KALROTH_WILDERNESS:
    case MAP_KALROTH_BACKLANDS:
    case MAP_KALROTH_OUTSKIRTS:
      mapTitle.setDrawIndex(REGION_KALROTH);  
      break;
    
    default:
      mapTitle.setEnabled(false); /// put "Unknown" here instead w.i.p.
      break;
  }
}

/*=============================================================================
 * setSubregionSprite()
 *
 * Sets subregion display sprite, based on map information.
 *===========================================================================*/
private function setSubregionSprite() {
  // Area title
  switch (gameInfo.getCurrentMap()) {
    case MAP_UI_TITLE_MENU:
    case MAP_UI_CREDITS:
    case MAP_UI_GAME_OVER:
    case MAP_TALONOVIA_SHRINE:
    case MAP_AKSALOM_SKYGATE:
    case MAP_AKSALOM_GROVE:
    case MAP_AKSALOM_STORMLANDS:
    case MAP_MYSTERY_PATH:
      // Not applicable
      areaSubregion.setEnabled(false);
      break;
    case MAP_MOUNTAIN_SHRINE:
      areaSubregion.setDrawIndex(SUBREGION_MOUNTAIN_SHRINE); 
      break;
    case MAP_TALONOVIA_TOWN:
      areaSubregion.setDrawIndex(SUBREGION_TOWN); 
      break;
    case MAP_KYRIN_CAVERN:
    case MAP_KAUFINAZ_CAVERN:
      areaSubregion.setDrawIndex(SUBREGION_CAVES);  
      break;
    case MAP_ETZLAND_CITADEL:
    case MAP_RHUNIA_CITADEL:
    case MAP_HAXLYN_CITADEL:
    case MAP_VALIMOR_CITADEL:
    case MAP_KALROTH_CITADEL:
      areaSubregion.setDrawIndex(SUBREGION_CITADEL); 
      break;
    case MAP_RHUNIA_WILDERNESS:
    case MAP_ETZLAND_WILDERNESS:
    case MAP_HAXLYN_WILDERNESS:
    case MAP_VALIMOR_WILDERNESS:
    case MAP_KALROTH_WILDERNESS:
      areaSubregion.setDrawIndex(SUBREGION_WILDERNESS);  
      break;
    case MAP_TALONOVIA_BACKLANDS:
    case MAP_RHUNIA_BACKLANDS:
    case MAP_ETZLAND_BACKLANDS:
    case MAP_HAXLYN_BACKLANDS:
    case MAP_VALIMOR_BACKLANDS:
    case MAP_KALROTH_BACKLANDS:
      areaSubregion.setDrawIndex(SUBREGION_BACKLANDS);  
      break;
    case MAP_TALONOVIA_OUTSKIRTS:
    case MAP_RHUNIA_OUTSKIRTS:
    case MAP_ETZLAND_OUTSKIRTS:
    case MAP_HAXLYN_OUTSKIRTS:
    case MAP_VALIMOR_OUTSKIRTS:
    case MAP_KALROTH_OUTSKIRTS:
      areaSubregion.setDrawIndex(SUBREGION_OUTSKIRTS);  
      break;
    
    default:
      areaSubregion.setEnabled(false); /// put "Unknown" here instead
      break;
  }
}


/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  // Area titles
  begin object class=UI_Texture_Info Name=Area_Titles_Rhunia
    componentTextures.add(Texture2D'GUI_Overworld.Area_Titles_Rhunia')
  end object
  begin object class=UI_Texture_Info Name=Area_Titles_Etzland
    componentTextures.add(Texture2D'GUI_Overworld.Area_Titles_Etzland')
  end object
  begin object class=UI_Texture_Info Name=Area_Titles_Valimor
    componentTextures.add(Texture2D'GUI_Overworld.Area_Titles_Valimor')
  end object
  begin object class=UI_Texture_Info Name=Area_Titles_Haxlyn
    componentTextures.add(Texture2D'GUI_Overworld.Area_Titles_Haxlyn')
  end object
  begin object class=UI_Texture_Info Name=Area_Titles_Kalroth
    componentTextures.add(Texture2D'GUI_Overworld.Area_Titles_Kalroth')
  end object
  begin object class=UI_Texture_Info Name=Area_Titles_Talonovia
    componentTextures.add(Texture2D'GUI_Overworld.Area_Titles_Talonovia')
  end object
  
  // Map Title Display Sprite
  begin object class=UI_Sprite Name=Map_Title_Sprite
    tag="Map_Title_Sprite"
    posX=420
    posY=338
    bEnabled=true
    images(REGION_TALONOVIA)=Area_Titles_Talonovia
    images(REGION_RHUNIA)=Area_Titles_Rhunia
    images(REGION_ETZLAND)=Area_Titles_Etzland
    images(REGION_HAXLYN)=Area_Titles_Haxlyn
    images(REGION_VALIMOR)=Area_Titles_Valimor 
    images(REGION_KALROTH)=Area_Titles_Kalroth
    images(REGION_SEVENTH_HOUSE)=Area_Titles_Kalroth
  end object
  componentList.add(Map_Title_Sprite)
  
  // Subregions
  begin object class=UI_Texture_Info Name=Subregion_Town_Texture
    componentTextures.add(Texture2D'GUI_Overworld.SubRegions.Subregion_Label_Town')
  end object
  begin object class=UI_Texture_Info Name=Subregion_Citadel_Texture
    componentTextures.add(Texture2D'GUI_Overworld.SubRegions.Subregion_Label_Citadel')
  end object
  begin object class=UI_Texture_Info Name=Subregion_Wilderness_Texture
    componentTextures.add(Texture2D'GUI_Overworld.SubRegions.Subregion_Label_Wilderness')
  end object
  begin object class=UI_Texture_Info Name=Subregion_Caves_Texture
    componentTextures.add(Texture2D'GUI_Overworld.SubRegions.Subregion_Label_Caves')
  end object
  begin object class=UI_Texture_Info Name=Subregion_Backlands_Texture
    componentTextures.add(Texture2D'GUI_Overworld.SubRegions.Subregion_Label_Backlands')
  end object
  begin object class=UI_Texture_Info Name=Subregion_Outskirts_Texture
    componentTextures.add(Texture2D'GUI_Overworld.SubRegions.Subregion_Label_Outskirts')
  end object
  begin object class=UI_Texture_Info Name=Subregion_Mountain_Shrine_Texture
    componentTextures.add(Texture2D'GUI_Overworld.SubRegions.Subregion_Label_Mountain_Shrine')
  end object
  
  // Area Subregion Sprite
  begin object class=UI_Sprite Name=Subregion_Sprite
    tag="Subregion_Sprite"
    posX=420
    posY=403
    bEnabled=true
    images(SUBREGION_TOWN)=Subregion_Town_Texture
    images(SUBREGION_CITADEL)=Subregion_Citadel_Texture
    images(SUBREGION_WILDERNESS)=Subregion_Wilderness_Texture
    images(SUBREGION_CAVES)=Subregion_Caves_Texture
    images(SUBREGION_BACKLANDS)=Subregion_Backlands_Texture
    images(SUBREGION_OUTSKIRTS)=Subregion_Outskirts_Texture
    images(SUBREGION_MOUNTAIN_SHRINE)=Subregion_Mountain_Shrine_Texture
  end object
  componentList.add(Subregion_Sprite)
  
}




















