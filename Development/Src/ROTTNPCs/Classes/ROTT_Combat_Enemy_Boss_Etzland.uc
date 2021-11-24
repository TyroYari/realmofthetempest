/*=============================================================================
 * ROTT_Combat_Enemy_Boss_Etzland
 *
 * 
 *===========================================================================*/
class ROTT_Combat_Enemy_Boss_Etzland extends ROTT_Combat_Enemy
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
  baseStatsPerLvl[PRIMARY_VITALITY] = 7;
  baseStatsPerLvl[PRIMARY_STRENGTH] = 10;
  baseStatsPerLvl[PRIMARY_COURAGE] = 1;
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
    MILESTONE_HYRIX, 
    MILESTONE_JUST_COMPLETED
  );
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  monsterName="Hyrix The Storm Raiser"
  
  expAmp=1
  
  // Quest items
  itemDropRates.add((dropType=class'ROTT_Inventory_Item_Quest_Amulet',chanceOverride=100,minOverride=,maxOverride=,chanceAmp=,quantityAmp=))
  
  // Drop rate modifiers
  itemDropRates.add((dropType=class'ROTT_Inventory_Item_Lustrous_Baton',chanceOverride=,minOverride=,maxOverride=,chanceAmp=8,quantityAmp=))
  
  // Currency
  itemDropRates.add((dropType=class'ROTT_Inventory_Item_Gem',chanceOverride=100,minOverride=,maxOverride=,chanceAmp=,quantityAmp=))
  
  // Sprites 240x240
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Bone_Mage_Green_240
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Bone_Mage_Green_240')
  end object
  
  // Sprite options
  begin object class=UI_Texture_Storage Name=Enemy_Sprite_Container
    tag="Enemy_Sprite_Container"
    images(CLAN_GREEN)=Enemy_Portrait_Bone_Mage_Green_240
  end object
  enemySprites=Enemy_Sprite_Container
  
  // Sprites 360x360
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Bone_Mage_Green_360
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Bone_Mage_Green_360')
  end object
  
  // Sprite options
  begin object class=UI_Texture_Storage Name=Champ_Sprite_Container
    tag="Champ_Sprite_Container"
    images(CLAN_GREEN)=Enemy_Portrait_Bone_Mage_Green_360
  end object
  champSprites=Champ_Sprite_Container
  
}









