/*=============================================================================
 * ROTT_UI_Displayer_Combat_Heroes
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Container for managing individual hero display panels 
 *===========================================================================*/

class ROTT_UI_Displayer_Combat_Heroes extends ROTT_UI_Displayer;

// Store delay from overlapping previous labels
var privatewrite MechanicTypes lastStatType;
var public MechanicTypes queueStatType;
var privatewrite float overlapDelay; 

// Internal references
var privatewrite ROTT_UI_Displayer_Combat_Hero heroDisplayers[3];

/*============================================================================= 
 * initializeComponent
 *
 * This is called as the UI is loaded.  Our initial scene is drawn here.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  local int i;
  
  super.initializeComponent(newTag);
  
  // Combat unit displayers
  for (i = 0; i < 3; i++) {
    // Hero displayers
    heroDisplayers[i] = new(self) class'ROTT_UI_Displayer_Combat_Hero';
    componentList.addItem(heroDisplayers[i]);
    heroDisplayers[i].initializeComponent();
    heroDisplayers[i].updatePosition(687 + (i*230), 443);
    heroDisplayers[i].displayerDelay = i * 0.125;
  }
}

/*=============================================================================
 * toggleCombatDetail()
 *
 * Called when the player presses Y in a combat scenario
 *===========================================================================*/
public function toggleCombatDetail() {
  local int i;
  
  // Toggle option settings
  ///gameInfo.optionsCookie.toggleCombatDetail();
  
  // Toggle UI display
  for (i = 0; i < gameInfo.getActiveParty().getPartySize(); i++) {
    heroDisplayers[i].showDetail(gameInfo.optionsCookie.showCombatDetail);
  }
}

/*=============================================================================
 * elapseTimer()
 *
 * Time is passed to non-actors through the scene that contains them
 *===========================================================================*/
public function elapseTimer(float deltaTime, float gameSpeedOverride) {
  // The parent class will erase temporary combat labels over time
  super.elapseTimer(deltaTime, gameSpeedOverride);
  
  // Track overlap delay
  if (overlapDelay > 0) {
    // Track countdown time
    overlapDelay -= deltaTime;
    
    // Check if limit reached
    if (overlapDelay <= 0) {
      overlapDelay = 0;
      lastStatType = queueStatType;
    }
  }
}

/*=============================================================================
 * queueLabel()
 *
 * Enters a stat change into the display queue
 *===========================================================================*/
public function UI_Label queueLabel
(
  coerce string text,
  optional CombatFonts fontIndex = FONT_LARGE,
  optional ColorStyles colorIndex = COLOR_GRAY,
  optional LabelClass labelType = LABEL_TYPE_RESIST,
  optional float labelDelay = 0.f
) 
{
  // Algorithm:
  // Display from queue 1
  // Search from queue 2 and 3 for matching types, delay if no match
  
  ///
  /// heroDisplayers[i].makeLabel(
  ///   totalMsg, 
  ///   FONT_MEDIUM_ITALICS, 
  ///   msgColor, 
  ///   LABEL_TYPE_STAT_REPORT,
  ///   displayerDelay + overlapDelay
  /// );
}
  
/*============================================================================= 
 * overlapDelayUpdate()
 *
 * Increments the overlap delay under aesthetic conditions
 *===========================================================================*/
public function overlapDelayUpdate(MechanicTypes targetStat) {
  // Check for a new stat display type
  if (lastStatType != targetStat) {
    // Separate display of next stat type
    overlapDelay += 0.5;
  }
  
  // Store last displayed stat type
  lastStatType = targetStat;
}

/*============================================================================= 
 * getDisplay
 *
 * Temporary access to displayer
 *===========================================================================*/
public function ROTT_UI_Displayer_Combat_Hero getDisplay(int index) {
  return heroDisplayers[index];
}

/*============================================================================= 
 * deleteComp
 *===========================================================================*/
event deleteComp() {
  local int i;
  
  super.deleteComp();
  
  // Clean combat unit displayers
  for (i = 0; i < 3; i++) {
    heroDisplayers[i] = none;
  }
}


/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  bDrawRelative=true
}














