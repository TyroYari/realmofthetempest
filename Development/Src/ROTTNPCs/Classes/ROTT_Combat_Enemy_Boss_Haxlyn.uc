/*=============================================================================
 * ROTT_Combat_Enemy_Boss_Haxlyn
 *
 * Otaysian Lore:
 *  
 * Canon Lore:
 *  Khomat the Guardian, a phantom brute at the end of Haxlyn's Citadel.
 *
 * Abilities:
 *  
 *===========================================================================*/
class ROTT_Combat_Enemy_Boss_Haxlyn extends ROTT_Combat_Enemy
  dependsOn(ROTT_Worlds_Encounter_Info);

/*=============================================================================
 * initStats()
 *
 * Called before all other initialization functions
 *===========================================================================*/
public function initStats
(
  EnemyTypes enemyType, 
  SpawnTypes spawnerType
)
{
  // Sprite assignment handled in super class
  super.initStats(enemyType, spawnerType);

  // Fixed stat points per level
  armorPerLvl = 0;
  baseStatsPerLvl[PRIMARY_VITALITY] = 16;
  baseStatsPerLvl[PRIMARY_STRENGTH] = 5;
  baseStatsPerLvl[PRIMARY_COURAGE] = 5;
  baseStatsPerLvl[PRIMARY_FOCUS] = 5;
  
  // Randomly rolled stat variation
  randStatsPerLvl = 0;
  
  // Stat preferences (must add up to 100)
  statPreferences[PRIMARY_VITALITY] = 25;
  statPreferences[PRIMARY_STRENGTH] = 25;
  statPreferences[PRIMARY_COURAGE] = 25;
  statPreferences[PRIMARY_FOCUS] = 25;

  // Affinities
  statAffinities[PRIMARY_VITALITY] = AVERAGE;
  statAffinities[PRIMARY_STRENGTH] = AVERAGE;
  statAffinities[PRIMARY_COURAGE] = AVERAGE;
  statAffinities[PRIMARY_FOCUS] = AVERAGE;
  
}

/*=============================================================================
 * onDeath()
 *
 * This function is called when the unit dies
 *===========================================================================*/
protected function onDeath() {
  super.onDeath();
  
  gameInfo.playerProfile.updateMilestone(
    MILESTONE_KHOMAT, 
    MILESTONE_JUST_COMPLETED
  );
  
  // Temp?
  gameInfo.playerProfile.setPortalUnlocked(MAP_VALIMOR_WILDERNESS);
  gameInfo.playerProfile.setPortalUnlocked(MAP_KALROTH_WILDERNESS);
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  monsterName="Khomat the Guardian"
  
  expAmp=1
  
  // Quest items
  itemDropRates.add((dropType=class'ROTT_Inventory_Item_Quest_Goblet',chanceOverride=100,minOverride=,maxOverride=,chanceAmp=,quantityAmp=))
  
  // Drop rate modifiers
  itemDropRates.add((dropType=class'ROTT_Inventory_Item_Shield_Kite',chanceOverride=,minOverride=,maxOverride=,chanceAmp=5,quantityAmp=))
  itemDropRates.add((dropType=class'ROTT_Inventory_Item_Lustrous_Baton',chanceOverride=,minOverride=,maxOverride=,chanceAmp=5,quantityAmp=))
  
  // Currency modifiers
  itemDropRates.add((dropType=class'ROTT_Inventory_Item_Gem',chanceOverride=100,minOverride=,maxOverride=,chanceAmp=,quantityAmp=))
  
  // Sprites 240x240
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Phantom_Brute_Cyan_240
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Phantom_Brute_Cyan_240')
  end object
  
  // Sprite options
  begin object class=UI_Texture_Storage Name=Enemy_Sprite_Container
    tag="Enemy_Sprite_Container"
    images(CLAN_CYAN)=Enemy_Portrait_Phantom_Brute_Cyan_240
  end object
  enemySprites=Enemy_Sprite_Container
  
  // Sprites 360x360
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Phantom_Brute_Cyan_360
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Phantom_Brute_Cyan_360')
  end object
  
  // Sprite options
  begin object class=UI_Texture_Storage Name=Champ_Sprite_Container
    tag="Champ_Sprite_Container"
    images(CLAN_CYAN)=Enemy_Portrait_Phantom_Brute_Cyan_360
  end object
  champSprites=Champ_Sprite_Container
  
}









