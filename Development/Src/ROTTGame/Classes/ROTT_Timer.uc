/*=============================================================================
 * ROTT_Timer
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * This class can be instantiated anywhere to perform functions from other
 * classes after a given amount of time has passed.
 *===========================================================================*/
class ROTT_Timer extends Actor;

delegate timerPop();
function functionPasser() { timerPop(); }   // No idea why this is necessary

function makeTimer(float seconds, bool bLoop, delegate<timerPop> timerFunction) { 
  timerPop = timerFunction;
  setTimer(seconds, bLoop, 'functionPasser');
}

defaultProperties 
{
  
}

















