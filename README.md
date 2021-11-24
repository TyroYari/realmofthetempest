# Realm of the Tempest - Unrealscript Style Guide #

## Preface ##
Realm of the Tempest (ROTT) has been written in Unrealscript, a C-Derived language for the Unreal Development Kit (UDK).
<br />

## Mission Statement ##
ROTT attempts to be a 'pot' that any ideas may be stirred into.  In our efforts to be feature friendly, we're fighting the natural phenomenon of "feature creep".  To do so, let's strive to be well-encapsulated, and well-documented in our code.
<br />

## IDE Template ##
Here are some of the recommended highlight settings for writing code in unrealscript. <br />

__Instruction Words__: super self begin end none foreach until <br />
__Typewords__: byte string protectedwrite privatewrite event exec delegate defaultProperties function object final editinline 
instanced local abstract var optional extends out structdefaultproperties coerce simulated

These settings help with viewing some of the quirky parts of unrealscripts "Default Properties", analagous to the concept of constructors.

## File Organization ##
The folder hierarchy gets compiled in order as follows:
 - ROTTGUI : Classes for interface management on the 2D screen.
 - ROTTGame : Classes for Realm of the Tempest gameplay.
 - ROTTNPCs : Classes for NPCs, containing dialog and settings for sprite display.
 - TSGame : Classes for objects placed directly into the world, (through level map files.)
  
## Comment styles ##

__Comments__: English description of the overarching algorithm, independent from implementation. <br />
__Code__: Implementation of an english comment, through a translation into unrealscript.

<pre>
// Keep count of the fish
x++;

// Keep count of the fish
x += 1;

// Keep count of the fish
x = x + 1;

// Keep count of the fish
fishCounter.count();
</pre><br/ >

## Git commands ##
__To see changes in git (-p for prompt)__
<pre>git add -p</pre>

__View stage changes__
<pre>git status</pre>

__Create the commit package (-m for in prompt message)__
<pre>git commit -m</pre>

__Push the changes to github__
<pre>git push origin < branch (e.g. master) ></pre>


## Contributor Guide ##
Create a fork of this repository, then submit a pull request!
