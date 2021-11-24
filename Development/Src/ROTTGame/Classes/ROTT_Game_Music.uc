/*=============================================================================
 * ROTT_Game_Music
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This object may be instantiated to play songs from the
 * Realm of the Tempest original soundtrack
 *
 * Each world has a default soundtrack, and may override that soundtrack with
 * other miscellaneous songs.
 *===========================================================================*/

class ROTT_Game_Music extends ROTT_Object
dependsOn(ROTT_Game_Info);

// Default Soundtracks for each World
var private AudioComponent worldSoundtracks[MapNameEnum];

// Soundtracks that interrupt default music
enum OverrideOSTs {
  // Towns
  MUSIC_VICTORY,
  MUSIC_CHARACTER_CREATION
};

// Soundtracks that may override default music
var private AudioComponent overrideSoundtracks[OverrideOSTs];

// Active themes
var private AudioComponent worldMusic;
var private AudioComponent overrideMusic;

// Music delay timers
var public ROTT_Timer overrideDelay; 

// Queue'd Fade controller
var privatewrite float fadeInTime; 

/*=============================================================================
 * initialize()
 *
 * This should be called as soon as the object is created
 *===========================================================================*/
public function initialize() {
  linkReferences();
}

/*=============================================================================
 * setVolume()
 *
 * Changes the music volume.
 *===========================================================================*/
public function setVolume(float newVolume) {
  // Store the option information
  gameInfo.optionsCookie.musicVolume = newVolume;
  
  // Change the music
  worldMusic.adjustVolume(0, newVolume);
  if (overrideMusic != none) overrideMusic.adjustVolume(0, newVolume);
}

/*=============================================================================
 * loadMusic()
 *
 * This function assigns OST selections by map name, and optionally sets fade
 * parameters.
 *===========================================================================*/
public function loadMusic(MapNameEnum map) {
  // Assign soundtrack from map enumeration
  worldMusic = worldSoundtracks[map];
  
  // Fade in settings for the given map
  switch (map) {
    case MAP_VALIMOR_CITADEL:
    case MAP_KALROTH_WILDERNESS:
    case MAP_VALIMOR_BACKLANDS:
      fadeIn(4);
      break;
      
    case MAP_ETZLAND_OUTSKIRTS:
    case MAP_VALIMOR_WILDERNESS:
      fadeIn(8);
      break;
      
    default:
      worldMusic.stop();
      worldMusic.adjustVolume(0, 1); 
      worldMusic.play();
      setVolume(getMusicVolume());
      break;
    
  }
}

/*=============================================================================
 * overrideSoundtrack()
 *
 * This function overrides the active theme with a song that isnt assigned to
 * the map by default.
 *===========================================================================*/
public function overrideSoundtrack
(
  OverrideOSTs songSelection, 
  optional float delay = 0,
  optional float fadeTime = 0
) 
{
  // Prepare song for play
  overrideMusic = overrideSoundtracks[songSelection];
  overrideMusic.stop();
  fadeInTime = fadeTime;
  
  if (delay == 0) {
    // Play immediate
    overrideMusic.play();
    overrideMusic.adjustVolume(0, 1); ///getMusicVolume()
    setVolume(getMusicVolume());
  } else {
    // Play delay
    if (overrideDelay != none) overrideDelay.destroy();
    overrideDelay = gameInfo.spawn(class'ROTT_Timer');
    overrideDelay.makeTimer(delay, LOOP_OFF, overridePlay);
  }
}

/*=============================================================================
 * fadeIn()
 *
 * Fades in the active theme music
 *
 * Parameters: time - Length in seconds for fade duration
 *===========================================================================*/
public function fadeIn(float time, optional bool targetOverride = false) {
  if (targetOverride) { 
    overrideMusic.stop();
    overrideMusic.fadeIn(time, 1);
    setVolume(getMusicVolume());
  } else {
    worldMusic.stop();
    worldMusic.fadeIn(time, 1);
    setVolume(getMusicVolume());
  }
}

/*=============================================================================
 * fadeOut()
 *
 * Description: Fades out active theme music. 
 *
 * Parameters: time - Length in seconds for fade duration
 *===========================================================================*/
public function fadeOut(int time, optional bool targetOverride = false) {
  if (targetOverride) {
    overrideMusic.fadeOut(time, 0);
  } else {
    worldMusic.fadeOut(time, 0);
  }
}

/*=============================================================================
 * getMusicVolume()
 *
 * Description: Retrieves music volume from player profile
 *===========================================================================*/
public function float getMusicVolume() {
  return gameInfo.optionsCookie.musicVolume;
}

/*=============================================================================
 * overridePlay()
 *
 * Called by a timer to play override music after a delay
 *===========================================================================*/
private function overridePlay() {
  // Play music
  if (fadeInTime == 0) {
    overrideMusic.play();
    overrideMusic.adjustVolume(0, 1); ///getMusicVolume()
    setVolume(getMusicVolume());
  } else {
    fadeIn(fadeInTime, true);
  }
  
  // Remove timer
  overrideDelay.destroy();
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  /** Original Soundtracks (Engine ties) **/
  // Tiny Mirror
  begin object class=AudioComponent Name=Tiny_Mirror_OST_Cue
    SoundCue=SoundCue'ROTT_Music_Disc_2.ROTT-Cue-Tiny_Mirror'
  end object
  
  // Violet Cape
  begin object class=AudioComponent Name=The_Violet_Clasp_OST_Cue
    SoundCue=SoundCue'ROTT_Music_Disc_2.ROTT-Cue-The_Violet_Clasp'
  end object
  
  // Swing of the Meadow
  begin object class=AudioComponent Name=Swing_Of_The_Meadow_OST_Cue
    SoundCue=SoundCue'ROTT_Music_Disc_1.ROTT-Cue-Swing_Of_The_Meadow'
  end object
  
  // Ethereal Ocean
  begin object class=AudioComponent Name=Ethereal_Ocean_OST_Cue
    SoundCue=SoundCue'ROTT_Music_Disc_1.ROTT-Cue-Ethereal_Ocean'
  end object
  
  // Lachyrmal Static
  begin object class=AudioComponent Name=Lachrymal_Static_OST_Cue
    SoundCue=SoundCue'ROTT_Music_Disc_1.ROTT-Cue-Lachrymal_Static'
  end object
  
  // Hex Wrought Haze
  begin object class=AudioComponent Name=Hex_Wrought_Haze_OST_Cue
    SoundCue=SoundCue'ROTT_Music_Disc_1.ROTT-Cue-Hex_Wrought_Haze'
  end object
  
  // Spiritual_Concomitance
  begin object class=AudioComponent Name=Spiritual_Concomitance_OST_Cue
    SoundCue=SoundCue'ROTT_Music_Disc_2.ROTT-Cue-Spiritual_Concomitance'
  end object
  
  // Unicursal Immolation
  begin object class=AudioComponent Name=Unicursal_Immolation_OST_Cue
    SoundCue=SoundCue'ROTT_Music_Disc_2.ROTT-Cue-Unicursal_Immolation'
  end object
  
  // Stone Soaked Shrine
  begin object class=AudioComponent Name=Stone_Soaked_Shrine_OST_Cue
    SoundCue=SoundCue'ROTT_Music_Disc_1.ROTT-Cue-Stone_Soaked_Shrine'
  end object
  
  // Stone Soaked Shrine
  begin object class=AudioComponent Name=Perpetual_Zugzwang_OST_Cue
    SoundCue=SoundCue'ROTT_Music_Disc_4.ROTT-Cue-Perpetual_Zugzwang'
  end object
  
  // Cult of Dreamfire
  begin object class=AudioComponent Name=Cult_of_Dreamfire_OST_Cue
    SoundCue=SoundCue'ROTT_Music_Disc_1.ROTT-Cue-Cult_of_Dreamfire'
  end object
  
  // Weak Prayer
  begin object class=AudioComponent Name=Lexical_Wind_OST_Cue
    SoundCue=SoundCue'ROTT_Music_Disc_2.ROTT-Cue-Lexical_Wind'
  end object
  
  // Weak Prayer
  begin object class=AudioComponent Name=Of_The_Earth_OST_Cue
    SoundCue=SoundCue'ROTT_Music_Disc_2.ROTT-Cue-Of_The_Earth'
  end object
  
  // Sorrow Sky
  begin object class=AudioComponent Name=Sorrow_Sky_OST_Cue
    SoundCue=SoundCue'ROTT_Music_Disc_2.ROTT-Cue-Sorrow_Sky'
  end object
  
  // The Path Within
  begin object class=AudioComponent Name=Without_Paths_OST_Cue
    SoundCue=SoundCue'ROTT_Music_Disc_3.ROTT-Cue-Without_Paths'
  end object

  // Neutrality The Toy
  begin object class=AudioComponent Name=Lexical_Synergy_OST_Cue
    SoundCue=SoundCue'ROTT_Music_Disc_3.ROTT-Cue-Lexical_Synergy'
  end object
  
  // The Sky is a Mountain Tamer
  begin object class=AudioComponent Name=The_Sky_is_a_Mountain_Tamer_OST_Cue
    SoundCue=SoundCue'ROTT_Music_Disc_3.ROTT-Cue-The_Sky_is_a_Mountain_Tamer'
  end object
  
  // A Storm is a Serpent
  begin object class=AudioComponent Name=A_Storm_is_a_Serpent_OST_Cue
    SoundCue=SoundCue'ROTT_Music_Disc_2.ROTT-Cue-A_Storm_is_a_Serpent'
  end object
  
  // Basalt Sanctuary
  begin object class=AudioComponent Name=Basalt_Sanctuary_OST_Cue
    SoundCue=SoundCue'ROTT_Music_Disc_3.ROTT-Cue-Basalt_Sanctuary'
  end object
  
  // Heights
  begin object class=AudioComponent Name=Heights_OST_Cue
    SoundCue=SoundCue'ROTT_Music_Disc_3.ROTT-Cue-Heights'
  end object
  
  // Live For Never
  begin object class=AudioComponent Name=Live_for_Never_OST_Cue
    SoundCue=SoundCue'ROTT_Music_Disc_1.ROTT-Cue-Live_for_Never'
  end object
  
  // The Missive
  begin object class=AudioComponent Name=The_Missive_OST_Cue
    SoundCue=SoundCue'ROTT_Music_Disc_1.ROTT-Cue-The_Missive'
  end object
  
  // OMEV AGRE
  begin object class=AudioComponent Name=OMEV_AGRE_OST_Cue
    SoundCue=SoundCue'ROTT_Music_Disc_1.ROTT-Cue-OMEV_AGRE'
  end object
  
  // Mira Monstrosity
  begin object class=AudioComponent Name=Mira_Monstrosity_OST_Cue
    SoundCue=SoundCue'ROTT_Music_Disc_4.ROTT-Cue-Mira_Monstrosity'
  end object
  
  // Lexical Toil
  begin object class=AudioComponent Name=Lexical_Toil_OST_Cue
    SoundCue=SoundCue'ROTT_Music_Disc_3.ROTT-Cue-Lexical_Toil'
  end object
  
  // Yellow Petals
  begin object class=AudioComponent Name=Yellow_Petals_OST_Cue
    SoundCue=SoundCue'ROTT_Music_Disc_4.ROTT-Cue-Yellow_Petals'
  end object
  
  // Gears and Gadgets
  begin object class=AudioComponent Name=Gears_and_Gadgets_OST_Cue
    SoundCue=SoundCue'ROTT_Music_Disc_3.ROTT-Cue-Gears_and_Gadgets'
  end object
  
  // Empty Myriads
  begin object class=AudioComponent Name=Empty_Myriads_OST_Cue
    SoundCue=SoundCue'ROTT_Music_Disc_3.ROTT-Cue-Empty_Myriads'
  end object
  
  // Blue Harps
  begin object class=AudioComponent Name=Blue_Harps_OST_Cue
    SoundCue=SoundCue'ROTT_Music_Disc_4.ROTT-Cue-Blue_Harps'
  end object
  
  // Black Magic
  begin object class=AudioComponent Name=Black_Magic_OST_Cue
    SoundCue=SoundCue'ROTT_Music_Disc_4.ROTT-Cue-Black_Magic'
  end object
  
  // Marro World
  begin object class=AudioComponent Name=Marro_OST_Cue
    SoundCue=SoundCue'ROTT_Music_Disc_4.ROTT-Cue-Marro'
  end object
  
  // Placeholder music
  begin object class=AudioComponent Name=Placeholder_OST_Cue
    SoundCue=SoundCue'ROTT_Sound_Effects.ROTT-SFXCUE-Ambient_Ominous'
  end object
  
  /** Default world music **/
  // UI Scenes
  worldSoundtracks[MAP_UI_TITLE_MENU]=Live_for_Never_OST_Cue
  ///MAP_UI_CREDITS,
  worldSoundtracks[MAP_UI_GAME_OVER]=OMEV_AGRE_OST_Cue
  
  // Talonovia
  worldSoundtracks[MAP_TALONOVIA_TOWN]=Tiny_Mirror_OST_Cue
  worldSoundtracks[MAP_TALONOVIA_SHRINE]=Stone_Soaked_Shrine_OST_Cue
  worldSoundtracks[MAP_TALONOVIA_BACKLANDS]=Of_The_Earth_OST_Cue
  worldSoundtracks[MAP_TALONOVIA_OUTSKIRTS]=Heights_OST_Cue
  
  // Rhunia
  worldSoundtracks[MAP_RHUNIA_CITADEL]=Ethereal_Ocean_OST_Cue
  worldSoundtracks[MAP_RHUNIA_WILDERNESS]=The_Violet_Clasp_OST_Cue
  worldSoundtracks[MAP_RHUNIA_BACKLANDS]=Placeholder_OST_Cue
  worldSoundtracks[MAP_RHUNIA_OUTSKIRTS]=Sorrow_Sky_OST_Cue
  
  // Etzland
  worldSoundtracks[MAP_ETZLAND_CITADEL]=Unicursal_Immolation_OST_Cue
  worldSoundtracks[MAP_ETZLAND_WILDERNESS]=Swing_Of_The_Meadow_OST_Cue
  worldSoundtracks[MAP_ETZLAND_BACKLANDS]=Perpetual_Zugzwang_OST_Cue
  worldSoundtracks[MAP_ETZLAND_OUTSKIRTS]=Yellow_Petals_OST_Cue
  
  // Haxlyn
  worldSoundtracks[MAP_HAXLYN_CITADEL]=Lexical_Wind_OST_Cue
  worldSoundtracks[MAP_HAXLYN_WILDERNESS]=Spiritual_Concomitance_OST_Cue
  worldSoundtracks[MAP_HAXLYN_BACKLANDS]=Marro_OST_Cue
  worldSoundtracks[MAP_HAXLYN_OUTSKIRTS]=A_Storm_is_a_Serpent_OST_Cue
  
  // Valimor
  worldSoundtracks[MAP_VALIMOR_CITADEL]=Cult_of_Dreamfire_OST_Cue
  worldSoundtracks[MAP_VALIMOR_WILDERNESS]=Without_Paths_OST_Cue
  worldSoundtracks[MAP_VALIMOR_BACKLANDS]=Lexical_Toil_OST_Cue
  worldSoundtracks[MAP_VALIMOR_OUTSKIRTS]=Mira_Monstrosity_OST_Cue
  
  // Kalroth
  worldSoundtracks[MAP_KALROTH_CITADEL]=Hex_Wrought_Haze_OST_Cue
  worldSoundtracks[MAP_KALROTH_WILDERNESS]=Empty_Myriads_OST_Cue
  worldSoundtracks[MAP_KALROTH_BACKLANDS]=Blue_Harps_OST_Cue
  worldSoundtracks[MAP_KALROTH_OUTSKIRTS]=Placeholder_OST_Cue 
  
  // Caves
  worldSoundtracks[MAP_KYRIN_CAVERN]=Lachrymal_Static_OST_Cue
  worldSoundtracks[MAP_KAUFINAZ_CAVERN]=Stone_Soaked_Shrine_OST_Cue
  worldSoundtracks[MAP_KORUMS_CAVERN]=Gears_and_Gadgets_OST_Cue
  
  // Misc: The land between the tempests
  worldSoundtracks[MAP_AKSALOM_SKYGATE]=The_Sky_is_a_Mountain_Tamer_OST_Cue
  worldSoundtracks[MAP_AKSALOM_GROVE]=Placeholder_OST_Cue
  worldSoundtracks[MAP_AKSALOM_STORMLANDS]=Basalt_Sanctuary_OST_Cue
  worldSoundtracks[MAP_MYSTERY_PATH]=Placeholder_OST_Cue
  worldSoundtracks[MAP_MOUNTAIN_SHRINE]=Lexical_Synergy_OST_Cue
  
  // Override Soundtracks
  overrideSoundtracks[MUSIC_CHARACTER_CREATION]=The_Missive_OST_Cue;
  
}






















