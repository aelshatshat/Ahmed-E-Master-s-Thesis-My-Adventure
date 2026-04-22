# Glossary of Terms

1. **Introduction**

This document is used to define terminology specific to the problem domain, and explain terms that may be unfamiliar to the reader of the use-case descriptions or other project documents. Many games use different terms to describe similar concepts, and so this document is provided to avoid ambiguity in such circumstances.

**1.1 Purpose**

This document is meant to provide clarity for certain terms used in the documentation that may be unfamiliar to certain stakeholders, or that may have implicit meanings that should be unified to avoid ambiguity.

**1.2 Scope**

The scope of this document is limited to the action-adventure game My Adventure, and the associated linked pages. *My Adventure*’s scope is limited to:

- one Player Avatar artifact with the ability to move, attack, cast spells, dodge, and jump
- one Boss Enemy with 4 phases, that has 4 primary attacks, and 1 special attack that occurs between Phase 2 and Phase 3
- Menu items and user-interface components to lead the player to and inform them of the status of their gameplay (e.g. Health and Mana resource bars)
- Necessary visual assets (backgrounds, attacks, etc.) and intro and ending cutscenes for the Boss Enemy fight

**1.3 References**

*[N/A]*

**1.4 Overview**

The remaining sections will go over the aforementioned terms and define them under the scope of the project

1. **Definitions**

2.1 Player Avatar (PA)

*The player avatar controlled by the user using the mouse and keyboard.*

2.2 Spell

*An alternate attack that can take multiple forms. Triggered using the Right-Mouse Button.*

2.3 Dodge

*A special form of movement. Quickly moves in the facing direction and provide a short invulnerability*

2.4 Attack

*An action of which the effect causes damage against a target. The PA’s primary form of attack is his sword, using the Left-Mouse Button.* 

2.5 Damage

*A measure of how many points any given attack will remove from an entity’s Health Points*

2.6 Health Points/Health

The amount of attacks one can survive, measured by an integer amount of points

2.7 Entity

*Any object in the game with health points.*

2.8 Enemy

*An Entity that damages the player on contact, and has at least one attack pattern.*

2.9 Boss Enemy

*A strong Enemy that form the main encounters in the game. Typically has various attacks that target and deal damage to the Incarnation.*

2.10 Attack Pattern

*An attack performed by an enemy, following certain logic that forms a pattern*

2.11 Anchor Point

*A static co-ordinate that a Boss Enemy uses to position itself around the stage*

2.11 Cooldown

*A duration of time during which a certain action or behaviour is unavailable and inactive. Once the timer has reached 0, the cooldown has reset.*