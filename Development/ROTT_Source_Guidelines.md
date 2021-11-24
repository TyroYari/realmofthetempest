# Realm of the Tempest - Unrealscript Style Guide #

## Preface ##
Realm of the Tempest (ROTT) has been written in Unrealscript, a C-Derived language for the Unreal Development Kit (UDK).
<br />

## Mission Statement ##
ROTT attempts to be a 'pot' that any ideas may be stirred into.  In our efforts to be feature friendly, we're fighting the natural phenomenon of "feature creep".  To do so, let's strive to be well-encapsulated, and well-documented in our code.
<br />

## IDE Template ##
Here are some of the recommended highlight settings for writing code in unrealscript. <br>

__Instruction Words__: name object
__Typewords__: byte string begin end defaultProperties event simulated local var privatewrite protectedwrite extends function

These settings help with viewing some of the quirky parts of unrealscripts "Default Properties", analagous to the concept of constructors.

## File Organization ##
The folder hierarchy gets compiled in order as follows:
 - ROTTGUI : Classes for interface management on the 2D screen.
 - ROTTGame : Classes for Realm of the Tempest gameplay.
 - ROTTNPCs : Classes for NPCs, containing dialog and selected display information, (e.g. sprite and backgroundn selection.)
 - TSGame : Classes for objects placed directly into the world, (through level map files.)
  
## Comment styles ##

__Comments__: English description of the overarching algorithm, INDEPENDENT from implementation. 
__Code__: Implementation of an english comment, through a translation into unrealscript.

(Good Examples) <br />
// Keep count of the fish <br />
x++; <br /> <br />

// Keep count of the fish <br />
x += 1; <br /> <br />

// Keep count of the fish <br />
x = x + 1; <br /> <br />

// Keep count of the fish <br />
fishCounter.count(); <br /> <br />
