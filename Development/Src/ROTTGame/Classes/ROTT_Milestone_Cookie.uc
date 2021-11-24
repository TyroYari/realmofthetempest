/*=============================================================================
 * ROTT_Milestone_Cookie
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: Stores milestone data separate from profiles.
 *===========================================================================*/
 
class ROTT_Milestone_Cookie extends ROTT_Object
dependsOn(ROTT_Game_Player_Profile);

enum SaveState {
  SAVE_EMPTY,
  SAVE_FILLED
};

// Store best milestone times
var privatewrite float bestTimes[SpeedRunMilestones];
var privatewrite SaveState savedTimes[SpeedRunMilestones];

/*=============================================================================
 * formatMilestoneTime()
 *
 * Returns a formatted version of the current time
 *===========================================================================*/
public function string formatMilestoneTime(float milestoneTime) {
  local float time;
  local int h2, h1, m2, m1, s2, s1, ms2, ms1;
  local string formattedTime;
  
  if (milestoneTime == 0) return "N/A";
  
  // Slice time into components
  time = milestoneTime;
  h2 = int(time / 60 / 60 / 10);
  h1 = int(time / 60 / 60) % 10;
  m2 = int(time / 60 / 10) % 6;
  m1 = int(time / 60) % 10;
  s2 = int(time / 10) % 6;
  s1 = int(time) % 10;
  ms2 = int(time * 10) % 10;
  ms1 = int(time * 100) % 10;

  // Format time
  formattedTime = m2 $ m1 $ ":" $ s2 $ s1 $ "." $ ms2 $ ms1;
  if (h2 != 0 || h1 != 0) {
    formattedTime = h2 $ h1 $ ":" $ formattedTime;
  }
  return formattedTime;
}

/*=============================================================================
 * recordMilestone()
 * 
 * Called to record a milestone time, returns true if personal best.
 *===========================================================================*/
public function bool recordMilestone(int milestoneIndex, float newTime) {
  if (savedTimes[milestoneIndex] == SAVE_EMPTY) {
    bestTimes[milestoneIndex] = newTime;
    savedTimes[milestoneIndex] = SAVE_FILLED;
    return true;
  }
  
  if (newTime < bestTimes[milestoneIndex]) {
    // Store the new time
    bestTimes[milestoneIndex] = newTime;
    gameInfo.saveMilestones();
    return true;
  }
  return false;
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  
}