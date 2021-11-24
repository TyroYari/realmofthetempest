/*=============================================================================
 * ROTT_UI_Displayer_Combat
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This displayer shows combat feedback for a combat unit
 *===========================================================================*/

class ROTT_UI_Displayer_Combat extends ROTT_UI_Displayer
abstract;

const QUEUE_DELAY = 0.65;

var privatewrite AnimationStyles animationModes[LabelClass];

struct LabelQueue {
  var array<UI_Label> queue;
  var float queueDelay;
};

var privatewrite LabelQueue queues[LabelClass];

// When true the queues will be cleared much quicker
var public bool bClearQueues;

/*============================================================================= 
 * initializeComponent()
 *
 * This is called as the UI is loaded.  Our initial scene is drawn here.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  super.initializeComponent(newTag);
  
}
 
/*=============================================================================
 * showDetail()
 *
 * This is used to turn on or off extra combat details
 *===========================================================================*/
public function showDetail(bool bShow) {
  
}

/*=============================================================================
 * updateDisplay()
 *
 * This updates the UI with the info of the attached combat unit.  
 * Returns true when there actually exists a unit to display, false otherwise.
 *===========================================================================*/
public function bool updateDisplay() {
  // Check if parent displayer fails
  if (!super.updateDisplay()) return false;
  
  // Successfully drew hero information
  return true;
}

/*=============================================================================
 * debuffEffect()
 *
 * This is called when a unit recieves a debuff
 *===========================================================================*/
public function debuffEffect();

/*=============================================================================
 * takeDamageEffect()
 *
 * This is called when a unit takes damage
 *===========================================================================*/
public function takeDamageEffect();

/*=============================================================================
 * showSkillEffects()
 *
 * Given a "sprite sheet" this will animate a skill animation
 *===========================================================================*/
public function showSkillEffects(UI_Texture_Storage sprites);

/*=============================================================================
 * updateSpeedAmp()
 *
 * Called when the speed amp changes
 *===========================================================================*/
public function updateSpeedAmp(float speedAmp);

/*=============================================================================
 * onDeath()
 *
 * This is called when the unit dies
 *===========================================================================*/
public function onDeath();

/*=============================================================================
 * unitDestroyed()
 * 
 * When the unit becomes 'none' this event is called
 *===========================================================================*/
public function unitDestroyed();

/*=============================================================================
 * battlePrep()
 *
 * This function is called right before a battle starts
 *===========================================================================*/
public function battlePrep();

/*=============================================================================
 * battleEnd()
 *
 * This function is called after a battle is done, when the transition out is
 * complete.
 *===========================================================================*/
public function battleEnd() { resetUI(); } 

/*=============================================================================
 * onAnalysisComplete()
 * 
 * This function is called after a battle is done, and after battle analysis
 * is finished.
 *===========================================================================*/
public function onAnalysisComplete();

/*=============================================================================
 * showDamage()
 *
 * Called when the unit takes damage
 *===========================================================================*/
public function showDamage(int damage, bool bCrit);

/*=============================================================================
 * showDamageToMana()
 *
 * Called when the unit takes damage to their mana
 *===========================================================================*/
public function showDamageToMana(int damage, bool bCrit);

/*=============================================================================
 * onManaRecovered()
 *
 * Called when the hero displayed recovers mana
 *===========================================================================*/
public function onManaRecovered(float manaRecovered) {
  if (int(manaRecovered) == 0) return;
  
  // Show recovery on the UI
  makeLabel(
    "+" $ int(manaRecovered), 
    FONT_MEDIUM, 
    COLOR_BLUE, 
    LABEL_TYPE_MANA_GAIN
  );
}

/*=============================================================================
 * onHealthRecovered()
 *
 * This is called when the displayed unit recovers health
 *===========================================================================*/
public function onHealthRecovered(float healthRecovered) {
  // Show recovery on the UI
  makeLabel(
    "+" $ int(healthRecovered), 
    FONT_MEDIUM, 
    COLOR_RED, 
    LABEL_TYPE_HEALTH_GAIN
  );
}

/*=============================================================================
 * improveStat()
 *
 * Called when a stat improvement has been made
 *===========================================================================*/
public function improveStat(float value, float total, MechanicTypes targetStat);
  
/*=============================================================================
 * addStatus()
 *
 * Called to add a status to be displayed in by this label
 *===========================================================================*/
public function addStatus(ROTT_Descriptor_Hero_Skill skillInfo);

/*=============================================================================
 * addManualStatus()
 *
 * Used to add a status manually, with no skill descriptor (e.g. Persistence)
 *===========================================================================*/
public function addManualStatus(string statusTag, FontStyles statusColor);

/*=============================================================================
 * removeStatus()
 *
 * Called to remove a status from being displayed by this label
 *===========================================================================*/
public function removeStatus(ROTT_Descriptor_Hero_Skill skillInfo);

/*=============================================================================
 * removeAllStatus()
 *
 * Called to remove all status
 *===========================================================================*/
public function removeAllStatus();

/*=============================================================================
 * onResisted()
 *
 * Called when the displayed unit has resisted an effect
 *===========================================================================*/
public function onResisted();

/*=============================================================================
 * onMissed()
 *
 * Called when an attack misses the unit owning this displayer
 *===========================================================================*/
public function onMissed();

/*=============================================================================
 * onStatDiminished()
 *
 * Called when a stat is diminished for the displayed unit
 *===========================================================================*/
public function onStatDiminished(float value, MechanicTypes targetStat);

/*=============================================================================
 * setStatusDemoralized()
 *
 * Called to set the demoralized status
 *===========================================================================*/
public function setStatusDemoralized(bool statusEnabled) {
  local ROTT_Descriptor_Skill_Defend tempSkill;
  
  tempSkill = new class'ROTT_Descriptor_Skill_Defend';
  tempSkill.statusTag = "Demoralized";
  tempSkill.statusColor = COMBAT_SMALL_TAN;
  
  if (statusEnabled) { addStatus(tempSkill); } else { removeStatus(tempSkill); }
}

/*=============================================================================
 * elapseTimer()
 *
 * Time is passed to non-actors through the scene that contains them
 *===========================================================================*/
public function elapseTimer(float deltaTime, float gameSpeedOverride) {
  local float timeScale;
  local int i;
  
  super.elapseTimer(deltaTime, gameSpeedOverride);
  
  // Loop through each queue
  for (i = 0; i < class'UI_Label_Combat'.static.countLabelClass(); i++) {
    // Scale time to clear queues faster
    timeScale = 1 + (int(queues[i].queue.length / 3.f) / 1.f);
    if (bClearQueues) timeScale = 50;
    
    // Track delay time
    if (queues[i].queueDelay > 0) {
      queues[i].queueDelay -= deltaTime * gameSpeedOverride * timeScale;
    }
    
    // Check if queue is non empty
    if (queues[i].queue.length != 0) {
      // Check for time completion
      if (queues[i].queueDelay <= 0) {
        // Swap from queue to active components
        componentList.addItem(queues[i].queue[0]);
        queues[i].queue.remove(0, 1);
        
        // Force out more labels if overwhelmed
        while (queues[i].queueDelay + QUEUE_DELAY <= 0 && queues[i].queue.length > 0) {
          // Set delay
          queues[i].queueDelay += QUEUE_DELAY;
          
          // Swap from queue to active components
          componentList.addItem(queues[i].queue[0]);
          queues[i].queue.remove(0, 1);
          /// heavier animation??
        }
      }
    }
  }
}

/*=============================================================================
 * resetUI()
 *
 * Called at the start of combat to initiale the component
 *===========================================================================*/
public function resetUI() {
  local int i;
  
  // Clear queues
  for (i = 0; i < class'UI_Label_Combat'.static.countLabelClass(); i++) {
    queues[i].queue.length = 0;
    queues[i].queueDelay = 0;
  }
  
  // Clear dynamic labels
  for (i = componentList.length - 1; i >= 0 ; i--) {
    if (UI_Label_Combat(componentList[i]) != none) {
      UI_Label_Combat(componentList[i]).deleteComp();
      componentList.remove(i, 1);
    }
  }
  
}

/*=============================================================================
 * makeLabel()
 *
 * Creates a label to show feedback during combat
 *===========================================================================*/
protected function UI_Label makeLabel
(
  coerce string text,
  optional CombatFonts fontIndex = FONT_LARGE,
  optional ColorStyles colorIndex = COLOR_GRAY,
  optional LabelClass labelType = LABEL_TYPE_RESIST,
  optional float labelDelay = 0.f
) 
{
  local UI_Label_Combat label;
  local AnimationStyles labelAnim;
  
  // Create label
  label = new(self) class'UI_Label_Combat';
  label.initializeComponent();
  label.startEvent();
  label.setText(text);
  
  // Queue based on label type
  queues[labelType].queue.addItem(label);
  
  // Set animation for the given label class
  labelAnim = animationModes[labelType];
  
  // Set display info
  label.setStyle(
    fontIndex,
    colorIndex,
    labelAnim
  );
  
  /// I believe we already do this somewhere else?
  ///componentList.addItem(label);
  
  // Return reference of this label
  return label;
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  bDrawRelative=true
  
  // Animation modes for each label class
  animationModes(LABEL_TYPE_STAT_REPORT)=ANIMATE_SLOW_BOUNCE
  animationModes(LABEL_TYPE_STAT_CHANGE)=ANIMATE_UP_AND_FADE
  animationModes(LABEL_TYPE_HEALTH_GAIN)=ANIMATE_UP_AND_FADE
  animationModes(LABEL_TYPE_MANA_GAIN)=ANIMATE_UP_AND_FADE
  animationModes(LABEL_TYPE_DAMAGE)=ANIMATE_UP_BOUNCE
  animationModes(LABEL_TYPE_RESIST)=ANIMATE_STILL
  
}


















