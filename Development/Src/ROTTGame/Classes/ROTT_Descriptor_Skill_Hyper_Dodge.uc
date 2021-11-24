/*=============================================================================
 * ROTT_Descriptor_Skill_Hyper_Dodge
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Hyper glyph providing permanent Dodge boosts, and temporary damage reduction
 * by percent
 *===========================================================================*/

class ROTT_Descriptor_Skill_Hyper_Dodge extends ROTT_Descriptor_Hero_Skill;
 
/**
# Ratings
  'Spiritual Prowess'   hyper glyph intensity++ when worshipping AT ANY SHRINE
  'Hunting Prowess'     gold++ when hunting any monster
  'Botanical Prowess'   gems++ when tending gardens


# Worship at a shrine
  '4 shrines'
    "Cleric's Shrine"        - Health glyph, Tome             // All glyphs here correspond to % chance
    "Cobalt Sanctum"         - Armor% glyph, Hp/mp% glyph
    "The Rosette Pillars"    - Gems, Dodge glyph
    "Lockspire Shrine"       - Damage% glyph, Herb
    
# Hunt a monster
  '4 Monster groups'
    "The Undead"             - Gold, Leech glyph
    "The Demonic"            - Gold, Rune
    "The Serpentine"         - Gems, Elixir
    "The Beasts"             - Fang, Ki Feather
    
# Tend to a botanical garden
  '4 gardens'
    "Hawkspire Meadow"       - Acc/Dodge% glyph, Ki Feather
    "Laceroot Shrine"        - Strike glyph, Hp/mp% glyph
      shrooms
    "Fatewood Grove"         - Elm's Potion, Herb
    "Myrrhian Thicket"       - Eluvi Charm, Leech glyph
      https://en.wikipedia.org/wiki/Myrrh
**/

/*=============================================================================
 * initialize()
 *
 * this function should be called by the descriptor container to set headers
 * and paragraph formatting info
 *===========================================================================*/
public function setUI() {
  // Set header
  h1(
    "Hyper Dodge",
  );
  
  // Set header
  h2(
    "",
  );
  
  // Set paragraph information
  p1(
    "This collectible hyper glyph's bonus",
    "combines with your heroes' original",
    "glyph enhancements, if they exists.",
  );
  
  // Set skill information for p2 and p3
  skillInfo(      
    "Chance to spawn: %spawn%",
    "+%permDodge Permanent Dodge Rating",
    "+%%maxDodge Dodge Rating"
  );
}


/*=============================================================================
 * attributeInfo()
 *
 * This function should hold all equations pertaining to the skill's behavior.
 *===========================================================================*/
protected function float attributeInfo
(
  AttributeTypes type, 
  ROTT_Combat_Hero hero, 
  int level
) 
{
  local float attribute; attribute = 0; 
  
  if (level == 0) return 0;
  
  switch (type) {
    case HYPER_SPAWN_CHANCE:
      // Get hyper chance, based on worship count
      attribute = gameInfo.playerProfile.getShrineActivityCount(COBALT_SANCTUM) * 20; 
      break;
    case PERM_DODGE_BOOST:
      // Dodge increase permanent
      attribute = 10 + 5 * gameInfo.playerProfile.getSpiritualProwess() / 500; 
      break;
    case HYPER_DODGE_PERCENT:
      // Dodge increase by percent
      attribute = 2 + gameInfo.playerProfile.getSpiritualProwess() / 1000; 
      break;
  }
  
  return attribute;
}

/*============================================================================= 
 * Default Properties
 *===========================================================================*/
defaultProperties 
{
  // Level lookup info
  skillIndex=GLYPH_TREE_Dodge
  parentTree=HYPER_TREE
  
  // Glyph Attributes
  skillAttributes.add((attributeSet=GLYPH_SET,mechanicType=HYPER_SPAWN_CHANCE,tag="%spawn",font=DEFAULT_SMALL_BLUE,returnType=INTEGER));
  skillAttributes.add((attributeSet=GLYPH_SET,mechanicType=PERM_DODGE_BOOST,tag="%permDodge",font=DEFAULT_SMALL_GREEN,returnType=INTEGER));
  skillAttributes.add((attributeSet=GLYPH_SET,mechanicType=HYPER_DODGE_PERCENT,tag="%maxDodge",font=DEFAULT_SMALL_GREEN,returnType=INTEGER));
  
}







