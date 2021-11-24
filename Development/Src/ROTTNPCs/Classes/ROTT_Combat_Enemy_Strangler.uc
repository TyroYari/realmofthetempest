/*=============================================================================
 * ROTT_Combat_Enemy_Strangler
 *
 * Lore:
 *  The strangler ties dried petals of the nether lotus to their feet, dyed in
 *  the color of their clan.  The noxious fumes from the petals kill sound
 *  waves, allowing stranglers to move in silence.  They tape their legs to
 *  protect their skin from the poisonous petals.  They summon extra hands
 *  through nether worship, which produces a trail of bones protruding from
 *  the wrist as a byproduct of the spell.  Stranglers also practice blood
 *  worship, evident by the mouth veil, to animate and control their extra 
 *  hands.
 *
 * Ability:
 *  Strangle.  Stuns an opponent, dealing dps while stunned.
 *===========================================================================*/
class ROTT_Combat_Enemy_Strangler extends ROTT_Combat_Enemy
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
  
  // Set stat modifiers for individual clans here
  switch (clanColor) {
    case CLAN_BLUE:
    case CLAN_CYAN:
    case CLAN_GREEN:
    case CLAN_GOLD:
    case CLAN_ORANGE:
    case CLAN_RED:
    case CLAN_VIOLET:
    case CLAN_PURPLE:
    case CLAN_BLACK: 
    case CLAN_WHITE:
      // Fixed stat points per level
      armorPerLvl = 0;
      baseStatsPerLvl[PRIMARY_VITALITY] = 4;
      baseStatsPerLvl[PRIMARY_STRENGTH] = 3;
      baseStatsPerLvl[PRIMARY_COURAGE] = 1;
      baseStatsPerLvl[PRIMARY_FOCUS] = 2;
      
      // Randomly rolled stat variation
      randStatsPerLvl = 3;
      
      // Stat preferences (must add up to 100)
      statPreferences[PRIMARY_VITALITY] = 0;
      statPreferences[PRIMARY_STRENGTH] = 50;
      statPreferences[PRIMARY_COURAGE] = 25;
      statPreferences[PRIMARY_FOCUS] = 25;
    
      // Affinities
      statAffinities[PRIMARY_VITALITY] = AVERAGE;
      statAffinities[PRIMARY_STRENGTH] = AVERAGE;
      statAffinities[PRIMARY_COURAGE] = MAJOR;
      statAffinities[PRIMARY_FOCUS] = AVERAGE;
      break;
    default:
      yellowLog("Warning (!) No " $ default.monsterName $ " constructor defined for class " $ enemyType);
      break;
  }
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  monsterName="Strangler"
  
  // Positive drop rate modifiers
  ///itemDropRates.add((dropType=class'ROTT_Inventory_Item_Charm_Kamita',chanceOverride=,minOverride=,maxOverride=,chanceAmp=2,quantityAmp=))
  ///itemDropRates.add((dropType=class'ROTT_Inventory_Item_Charm_Bayuta',chanceOverride=,minOverride=,maxOverride=,chanceAmp=2,quantityAmp=))
  ///itemDropRates.add((dropType=class'ROTT_Inventory_Item_Bottle_Harrier_Claws',chanceOverride=,minOverride=,maxOverride=,chanceAmp=2,quantityAmp=))
  
  // Negative drop rate modifiers
  ///itemDropRates.add((dropType=class'ROTT_Inventory_Item_Bottle_Faerie_Bones',chanceOverride=,minOverride=,maxOverride=,chanceAmp=0,quantityAmp=))
  ///itemDropRates.add((dropType=class'ROTT_Inventory_Item_Herb',chanceOverride=,minOverride=,maxOverride=,chanceAmp=0,quantityAmp=))
  ///itemDropRates.add((dropType=class'ROTT_Inventory_Item_Charm_Eluvi',chanceOverride=,minOverride=,maxOverride=,chanceAmp=0,quantityAmp=))
  
  // Currency modifiers
  ///itemDropRates.add((dropType=class'ROTT_Inventory_Item_Gem',chanceOverride=,minOverride=,maxOverride=,chanceAmp=2,quantityAmp=))
  
  // Sprites 240x240
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Strangler_Black_240
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Strangler_Black_240')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Strangler_Blue_240
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Strangler_Blue_240')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Strangler_Cyan_240
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Strangler_Cyan_240')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Strangler_Gold_240
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Strangler_Gold_240')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Strangler_Green_240
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Strangler_Green_240')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Strangler_Orange_240
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Strangler_Orange_240')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Strangler_Purple_240
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Strangler_Purple_240')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Strangler_Red_240
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Strangler_Red_240')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Strangler_Violet_240
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Strangler_Violet_240')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Strangler_White_240
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Strangler_White_240')
  end object
  
  // Sprite options
  begin object class=UI_Texture_Storage Name=Enemy_Sprite_Container
    tag="Enemy_Sprite_Container"
    images(CLAN_BLUE)=Enemy_Portrait_Strangler_Blue_240
    images(CLAN_CYAN)=Enemy_Portrait_Strangler_Cyan_240
    images(CLAN_GREEN)=Enemy_Portrait_Strangler_Green_240
    images(CLAN_GOLD)=Enemy_Portrait_Strangler_Gold_240
    images(CLAN_ORANGE)=Enemy_Portrait_Strangler_Orange_240
    images(CLAN_RED)=Enemy_Portrait_Strangler_Red_240
    images(CLAN_VIOLET)=Enemy_Portrait_Strangler_Violet_240
    images(CLAN_PURPLE)=Enemy_Portrait_Strangler_Purple_240
    images(CLAN_BLACK)=Enemy_Portrait_Strangler_Black_240
    images(CLAN_WHITE)=Enemy_Portrait_Strangler_White_240
  end object
  enemySprites=Enemy_Sprite_Container
  
  // Sprites 360x360
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Strangler_Black_360
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Strangler_Black_360')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Strangler_Blue_360
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Strangler_Blue_360')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Strangler_Cyan_360
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Strangler_Cyan_360')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Strangler_Gold_360
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Strangler_Gold_360')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Strangler_Green_360
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Strangler_Green_360')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Strangler_Orange_360
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Strangler_Orange_360')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Strangler_Purple_360
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Strangler_Purple_360')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Strangler_Red_360
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Strangler_Red_360')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Strangler_Violet_360
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Strangler_Violet_360')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Strangler_White_360
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Strangler_White_360')
  end object
  
  // Sprite options
  begin object class=UI_Texture_Storage Name=Champ_Sprite_Container
    tag="Champ_Sprite_Container"
    images(CLAN_BLUE)=Enemy_Portrait_Strangler_Blue_360
    images(CLAN_CYAN)=Enemy_Portrait_Strangler_Cyan_360
    images(CLAN_GREEN)=Enemy_Portrait_Strangler_Green_360
    images(CLAN_GOLD)=Enemy_Portrait_Strangler_Gold_360
    images(CLAN_ORANGE)=Enemy_Portrait_Strangler_Orange_360
    images(CLAN_RED)=Enemy_Portrait_Strangler_Red_360
    images(CLAN_VIOLET)=Enemy_Portrait_Strangler_Violet_360
    images(CLAN_PURPLE)=Enemy_Portrait_Strangler_Purple_360
    images(CLAN_BLACK)=Enemy_Portrait_Strangler_Black_360
    images(CLAN_WHITE)=Enemy_Portrait_Strangler_White_360
  end object
  champSprites=Champ_Sprite_Container
  
}
