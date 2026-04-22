# Use Case Document

# Use Cases

| UC ID and Name: | UC-1: Player Avatar Move Left and Right | DONE |  |
| --- | --- | --- | --- |
| Created By: |  | Date Created: |  |
| Primary Actor: | Player | Secondary Actors: | Player Avatar |
| Trigger: | The player pushes the A key or the D key |  |  |
| Description: | The player wants the Player Avatar to move in a horizontal direction |  |  |
| Preconditions: | PRE-1. Player Avatar is in a moveable state |  |  |
| Postconditions: | POST-1. The Player Avatar  moves in the appropriate direction (left for A, right for D)
POST-2. A running animation plays for the Player Avatar |  |  |
| Main Success Scenario: | 1. The player presses the A key or the D key
2. The Player Avatar moves left or right, depending on the direction
3. Use Case ends |  |  |
| Extensions: | **1a. Multiple Input rule violation:**
1a1. The Player Avatar  does not move (both A and D are pressed).
1a2. The player releases one of the two keys, and the Player Avatar moves in the direction of the still pressed key

2**a. Blocked direction:**
2a1. The Player Avatar moves in place, blocked by the environment |  |  |

| UC ID and Name: | UC-2: Player Avatar Jump | DONE |  |
| --- | --- | --- | --- |
| Created By: |  | Date Created: |  |
| Primary Actor: | Player | Secondary Actors: | Player Avatar |
| Trigger: | The player pushes the SPACE key |  |  |
| Description: | The player wants the Player Avatar to move in a vertical direction |  |  |
| Preconditions: | PRE-1. Player Avatar is in a moveable state |  |  |
| Postconditions: | POST-1. The Player Avatar moves upwards
POST-2. The Player Avatar changes to a jump animation |  |  |
| Main Success Scenario: | 1. The Player presses the SPACE key
2. The Player Avatar jumps upward
3. The Player Avatar changes to a jumping animation
4. Use Case ends |  |  |
| Extensions: | **4a. Player Avatar Land**
4a1. The Player Avatar falls and plays a falling animation
4a2. The Player Avatar lands on the ground and ceases to fall
4a3. The Player Avatar changes to an idle animation
4a4. Use Case ends

**4b. Player Avatar Double Jump**
4b1. The Player presses the SPACE key while still airborne after jumping once
4b2. The Player Avatar jumps upward once more
4b3. The Player Avatar plays its jumping animation again
4b4. Use Case continues to 4a. |  |  |

| UC ID and Name: | UC-3: Player Avatar Sword Attack | DONE |  |
| --- | --- | --- | --- |
| Created By: |  | Date Created: |  |
| Primary Actor: | Player | Secondary Actors: | Player Avatar |
| Trigger: | The player pushes the Left-Mouse Button |  |  |
| Description: | The player wants the Player Avatar to attack using the sword |  |  |
| Preconditions: | PRE-1. Player Avatar is in a moveable state |  |  |
| Postconditions: | POST-1. The Player Avatar attacks using a sword
POST-2. The Player Avatar changes to sword attack animation |  |  |
| Main Success Scenario: | 1. The player presses the Left-Mouse Button
2. Player Avatar animation changes to the first sword attack animation
3. The Player Avatar attacks with a sword
4. Use Case ends |  |  |
| Extensions: | **4a. Combo Attack 1
4**a1. The player presses the Left-Mouse Button again within 0.2 seconds of the animation finishing
4a2. The Player Avatar changes to the second sword attack animation
4a3. The Player Avatar attacks with the second sword attack in the combo
**4b. Combo Attack 2
4**b1. The player presses the Left-Mouse Button again within 0.2 seconds of the animation finishing
4b2. The Player Avatar changes to the second sword attack animation
4b3. The Player Avatar attacks with the second ****sword attack in the combo
4b4. The player presses the Left-Mouse Button for the third time within 0.2 seconds of the animation finishing
4b5. The Player Avatar changes to the third sword attack animation
4b6. The Player Avatar attacks with the third sword attack in the combo
**4c. Combo Attack 3**
4c1. The player presses the Left-Mouse Button again within 0.2 seconds of the animation finishing
4c2. The Player Avatar changes to the second sword attack animation
4c3. The Player Avatar attacks with the second sword attack in the combo
4c4. The player presses the Left-Mouse Button for the third time within 0.2 seconds of the animation finishing
4c5. The Player Avatar changes to the third sword attack animation
4c6. The Player Avatar attacks with the third sword attack in the combo
4c7. The player presses the Left-Mouse Button for the fourth time within 0.2 seconds of the animation finishing
4c8. The Player Avatar changes to the fourth sword attack animation
4c9. The Player Avatar attacks with the fourth sword attack in the combo |  |  |

| UC ID and Name: | UC-4: Player Avatar Spinning Jump Attack | DONE |  |
| --- | --- | --- | --- |
| Created By: |  | Date Created: |  |
| Primary Actor: | Player | Secondary Actors: | Player Avatar |
| Trigger: | The player pushes the Left-Mouse Button while in a jump state |  |  |
| Description: | The player wants the Player Avatar to attack using the sword in the air |  |  |
| Preconditions: | PRE-1. Player Avatar is in a jump state
PRE-2. Player Avatar is in a moveable state |  |  |
| Postconditions: | POST-1. The Player Avatar attacks in the air using a sword spin attack
POST-2. The Player Avatar changes to a cycling sword spin attack animation |  |  |
| Main Success Scenario: | 1. The Player presses the SPACE key
2. The Player Avatar jumps into the air
3. The Player Avatar changes to a jumping animation
4. The Player presses the Left-Mouse Button
5. The Player Avatar does a spinning jump attack
6. The Player Avatar changes to a spin attack animation
7. The Player Avatar touches the ground
8. Use Case ends |  |  |
| Extensions: |  |  |  |

| UC ID and Name: | UC-5: Player Avatar Cast Spell |  |  |
| --- | --- | --- | --- |
| Created By: |  | Date Created: |  |
| Primary Actor: | Player | Secondary Actors: | Player Avatar |
| Trigger: | The player pushes the Right-Mouse Button |  |  |
| Description: | The player wants the Player Avatar to attack using a spell |  |  |
| Preconditions: | PRE-1. Player Avatar is in a moveable state
PRE-2. Player Avatar’s Mana is above the spell’s Mana cost
PRE-3. Active spell’s cooldown timer is at 0 |  |  |
| Postconditions: | POST-1. The Player Avatar casts a spell
POST-2. The Player Avatar changes to spell cast animation
POST-3. Active spell is on cooldown for its cooldown duration |  |  |
| Main Success Scenario: | 1. The Player presses the Right-Mouse Button
2. The Player Avatar casts a spell
3. The Player Avatar plays the appropriate spell-casting animation based on the spell type
4. Player Avatar Mana resource is reduced by the amount required by the spell
5. Mana Resource bar is updated
6. Use Case ends |  |  |
| Extensions: | **3a. Combo Spell Injection
PRE-3 Player Avatar is currently in UC-3
PRE-4 Currently active spell is a Combo spell**
3a1. The Player Avatar casts a Combo spell at the next combo step, based on the last combo step reached in UC-3
3a2. Player Avatar plays appropriate animation for Combo spell step
3a3. Use Case continues at 4. in the Main Success Scenario

**3b. Incantation Spell Cast
PRE-3. Currently active spell is an Incantation Spell** 
3b1. The Player Avatar movement is locked
3b2. The Player Avatar changes to a casting animation
3b3. A cast time progress bar appears above the Player Avatar
3b4. Cast time progress bar is filled
3b5. Player Avatar casts spell
3b6. Use Case continues at 4. in the Main Success Scenario |  |  |

| UC ID and Name: | UC-6: Player Avatar Dodge Cast |  |  |
| --- | --- | --- | --- |
| Created By: |  | Date Created: |  |
| Primary Actor: | Player | Secondary Actors: | Player Avatar |
| Trigger: | The player pushes the Shift Button |  |  |
| Description: | The player wants the Player Avatar to dodge and avoid damage for a time |  |  |
| Preconditions: | PRE-1. Player Avatar is in a moveable state
PRE-2. Dodge Cooldown is currently at 0 |  |  |
| Postconditions: | POST-1. The Player Avatar moves quickly in the facing direction
POST-2. The Player Avatar changes to a dodge animation
POST-3. The Player Avatar is invulnerable to damage for 0.5 seconds
POST-4. Dodge Cooldown is reset |  |  |
| Main Success Scenario: | 1. The Player presses the Shift-Button
2. The Player Avatar dodges in a direction
3. The Player Avatar changes to a dodge animation
3. The Player Avatar is invulnerable for the duration of the dodge animation
4. Use Case ends |  |  |
| Extensions: |  |  |  |

| UC ID and Name: | UC-7: Player Avatar Take Damage |  |  |
| --- | --- | --- | --- |
| Created By: |  | Date Created: |  |
| Primary Actor: | Player Avatar | Secondary Actors: | Enemy |
| Trigger: | The player gets struck with an enemy attack |  |  |
| Description: | The Player Avatar takes damage from an enemy attack |  |  |
| Preconditions: | PRE-1. Player Avatar is in a vulnerable state
PRE-2. Enemy health is above 0
PRE-3. Player health is above 0 |  |  |
| Postconditions: | POST-1. The Player Avatar takes damage
POST-2. The Player Avatar plays a take damage animation
POST-3. The Player Avatar is invulnerable to damage for 1 second
POST-4. Health resource bar is updated with new value |  |  |
| Main Success Scenario: | 1. The Player Avatar gets hit by an enemy attack
2. The Player Avatar Health decreases based on the damage value of the enemy attack
3. The Player Avatar is in an immovable state for 0.2 seconds and is an invulnerable state for 0.5 seconds
4. The Player Avatar changes to a taking damage animation
5. Player regains control of Player Avatar
6. Player Avatar loses invulnerability
7. Use Case ends |  |  |
| Extensions: | **3a. Player Avatar Dies
3**a1. GO TO UC-8 3.

**4a. Player Avatar Gets Debuffed**
4a1. The Player Avatar gains an additional negative effect from the enemy attack

**4b. Knockback
PRE-4. Enemy attack has a knockback value**
4b1. Player Avatar is pushed in the knockback direction based on the knockback value of the attack  |  |  |

| UC ID and Name: | UC-8: Player Avatar Dies |  |  |
| --- | --- | --- | --- |
| Created By: |  | Date Created: |  |
| Primary Actor: | Player Avatar | Secondary Actors: | Enemy |
| Trigger: | The Player Avatar gets struck with an enemy attack and loses all remaining Health points |  |  |
| Description: | The Player Avatar dies after taking too much damage |  |  |
| Preconditions: | PRE-1. Player Avatar is in a vulnerable state
PRE-2. Enemy health is above 0
PRE-3. Player Avatar Health is above 0 |  |  |
| Postconditions: | POST-1. Player Avatar Health is less than or equal to 0
POST-2. The Player Avatar changes to a death animation
POST-3. The Player Avatar is in an immovable state
POST-4. The player is in a Game Over state |  |  |
| Main Success Scenario: | 1. The Player Avatar gets hit by an enemy attack
2. The Player Avatar Health decreases based on the damage value of the enemy attack
3. Player Avatar changes to an immovable state
4. The Player Avatar changes into a death animation
5. The player state changes to a Game Over state
6. Use Case ends |  |  |
| Extensions: |  |  |  |

| UC ID and Name: | UC-9: Player Triggers Menu Option |  |  |
| --- | --- | --- | --- |
| Created By: |  | Date Created: |  |
| Primary Actor: | Player | Secondary Actors: |  |
| Trigger: | The player presses the Left-Mouse Button on a menu element |  |  |
| Description: | The player wants to interact with a menu element |  |  |
| Preconditions: | PRE-1. Player is in a Pause, Game Over, or Game Menu state |  |  |
| Postconditions: | POST-1. Menu option selection changes menu or game state |  |  |
| Main Success Scenario: | 1. The player highlights a menu option
2. The player presses the Left-Mouse Button over the menu option
3. Menu option runs
4. Use Case ends |  |  |
| Extensions: | **4a. Restart Level**
4a1. Game state for level is reset to parameters on original entry
4a2. Use Case ends

**4b. Quit Game**
4b1. Game executable is closed
4b2. Use Case ends

**4c. Quit to map**
4c1. Current screen changes to map screen
4c2. Use Case ends

**4d. Play Game**
4d1. Game progresses to level selection menu
4d2. Use Case ends |  |  |

| UC ID and Name: | UC-10: Player Pauses Game |  |  |
| --- | --- | --- | --- |
| Created By: |  | Date Created: |  |
| Primary Actor: | Player | Secondary Actors: |  |
| Trigger: | The player presses the ESCAPE key |  |  |
| Description: | The player wants to pause the game |  |  |
| Preconditions: | PRE-1. Player is in an Active Game state |  |  |
| Postconditions: | POST-1. Gameplay stops
POST-2. Pause Menu options appear
POST-3. Gameplay visually fades |  |  |
| Main Success Scenario: | 1. The Player presses the ESCAPE key
2. Pause Menu appears
3. Gameplay fades to the background
4. Use Case ends |  |  |
| Extensions: |  |  |  |

| UC ID and Name: | UC-11: Player Unpauses Game |  |  |
| --- | --- | --- | --- |
| Created By: |  | Date Created: |  |
| Primary Actor: | Player | Secondary Actors: |  |
| Trigger: | The player presses the ESCAPE key |  |  |
| Description: | The player wants to unpause the game |  |  |
| Preconditions: | PRE-1. Player is in a Pause state |  |  |
| Postconditions: | POST-1. Gameplay unfades
POST-2. Pause Menu options disappear
POST-3. Gameplay resumes |  |  |
| Main Success Scenario: | 1. The Player presses the ESCAPE key
2. Gameplay unfades from the background
3. Pause Menu disappears
4. Use Case ends |  |  |
| Extensions: |  |  |  |

| UC ID and Name: | UC-12: Mid-Combat Event Occurs |  |  |
| --- | --- | --- | --- |
| Created By: |  | Date Created: |  |
| Primary Actor: | Boss Enemy | Secondary Actors: | Player Avatar |
| Trigger: | Boss Enemy Reaches a Health Point threshold |  |  |
| Description: | The Boss Enemy uses a special attack, the effect of which changes depending on the enemy |  |  |
| Preconditions: | PRE-1. Boss Enemy Health is below threshold 
PRE-2. Boss Enemy is not currently performing a different attack |  |  |
| Postconditions: |  |  |  |
| Main Success Scenario: | 1. The Player Avatar attacks the enemy
2. Enemy health reduces below threshold value
3. Mid combat event occurs
4. Player interacts with event
5. Use Case ends |  |  |
| Extensions: | **5a. Enemy Dies During Mid Combat Event**
5a1. GO TO UC-14: Enemy Dies |  |  |

| UC ID and Name: | UC-13: Enemy Takes Damage | DONE |  |
| --- | --- | --- | --- |
| Created By: |  | Date Created: |  |
| Primary Actor: | Player Avatar | Secondary Actors: | Enemy |
| Trigger: | Enemy is hit by Player Avatar attack or damaging spell |  |  |
| Description: | The enemy takes damage from a Player Avatar attack |  |  |
| Preconditions: | PRE-1. Enemy health is above 0
PRE-2. Enemy is not currently in an invulnerable state |  |  |
| Postconditions: | POST-1. Enemy sprite flashes
POST-2. Enemy Health bar updates based on new value |  |  |
| Main Success Scenario: | 1. The enemy gets hit by a player attack
2. The enemy Health decreases based on the damage value of the Player Avatar attack
3. The enemy sprite flashes
4. Use Case ends |  |  |
| Extensions: | **5a. Enemy Dies** 
5a1. GO TO UC-14: Enemy Dies |  |  |

| UC ID and Name: | UC-14: Enemy Dies | DONE |  |
| --- | --- | --- | --- |
| Created By: |  | Date Created: |  |
| Primary Actor: | Enemy | Secondary Actors: | Player Avatar |
| Trigger: | Enemy is hit by Player Avatar attack or damaging spell |  |  |
| Description: | The enemy takes damage from a Player Avatar attack and dies |  |  |
| Preconditions: | PRE-1. Enemy health is above 0
PRE-2. Enemy is not currently in an invulnerable state |  |  |
| Postconditions: | POST-1. Enemy sprite flashes
POST-2. Enemy Health bar updates based on new value
POST-3. Enemy death animation plays |  |  |
| Main Success Scenario: | 1. The enemy gets hit by a Player Avatar attack
2. The enemy health decreases based on the damage value of the player attack
3. The enemy sprite flashes
4. Enemy health is reduced to 0
5. Enemy death animation plays
6. Use Case ends |  |  |
| Extensions: |  |  |  |

| UC ID and Name: | UC-15: Enemy Attacks |  |  |
| --- | --- | --- | --- |
| Created By: |  | Date Created: |  |
| Primary Actor: | Enemy | Secondary Actors: | Player Avatar |
| Trigger: | Enemy Action Cooldown reached 0 |  |  |
| Description: | The enemy performs an attack |  |  |
| Preconditions: | PRE-1. Enemy health is above 0 |  |  |
| Postconditions: | POST-1. Enemy uses an attack
POST-2. Enemy Action Cooldown starts |  |  |
| Main Success Scenario: | 1. The enemy uses an attack
2. The enemy Action Cooldown starts
3. Use Case ends |  |  |
| Extensions: |  |  |  |

| UC ID and Name: | UC-16: Boss Enemy Intro Cutscene |  |  |
| --- | --- | --- | --- |
| Created By: |  | Date Created: |  |
| Primary Actor: | Player Avatar | Secondary Actors: | Boss Enemy |
| Trigger: | Player enters a level |  |  |
| Description: | The Player Avatar and Boss Enemy perform introductory animations to set the context of the scene |  |  |
| Preconditions: | PRE-1. Player Avatar is in an immovable state
PRE-2. Boss Enemy attack logic is paused |  |  |
| Postconditions: | POST-1. Player Avatar is an a moveable state 
POST-2. Boss Enemy attack logic begins |  |  |
| Main Success Scenario: | 1. The player selects a level
2. The Player Avatar and the Boss Enemy perform entrance animations
3. Use Case ends |  |  |
| Extensions: | **3a. Game Tutorial**
3a1. The Player Avatar is able to be controlled
****3a2. GOTO UC-17 |  |  |

| UC ID and Name: | UC-17: Game Tutorial |  |  |
| --- | --- | --- | --- |
| Created By: |  | Date Created: |  |
| Primary Actor: | Player | Secondary Actors: | Boss Enemy, Player Avatar |
| Trigger: | Player enters the first level |  |  |
| Description: | The player is given a tutorial on how to control the Player Avatar |  |  |
| Preconditions: | PRE-1. Player Avatar is in an moveable state
PRE-2. Boss Enemy attack logic is paused |  |  |
| Postconditions: | POST-1. Boss Enemy attack logic begins |  |  |
| Main Success Scenario: | 1. The first tutorial message plays
2. The player follows the instructions of the first tutorial message and controls the Player Avatar accordingly
3. The second tutorial message plays
4. The player follows the instructions of the second tutorial message and controls the Player Avatar accordingly
5. The third tutorial message plays
6. The player follows the instructions of the third tutorial message and controls the Player Avatar accordingly
7. The fourth tutorial message plays
8. Use Case ends |  |  |
| Extensions: | **Xa. Exit Tutorial Early**
Xa1. The Player Avatar damages the Boss Enemy
Xa2. Use Case ends |  |  |

| UC ID and Name: | UC-18: Player Avatar Swap Spells |  |  |
| --- | --- | --- | --- |
| Created By: |  | Date Created: |  |
| Primary Actor: | Player | Secondary Actors: | Player Avatar |
| Trigger: | Player pressed 1, 2, or 3 Key |  |  |
| Description: | The player swaps the Player Avatar’s currently active spell |  |  |
| Preconditions: | PRE-1. Player Avatar is in an moveable state |  |  |
| Postconditions: | POST-1. Player Avatar active spell has changed |  |  |
| Main Success Scenario: | 1. The player presses the 1, 2, or 3 key
2. Player Avatar active spell changes to the respectively pressed button
3. An animation plays above the Player Avatar showing the newly selected spell
4. The spell UI highlights the newly active spell
5. Use Case ends |  |  |
| Extensions: |  |  |  |

| UC ID and Name: | UC-19: Boss Fight Ending Cutscene |  |  |
| --- | --- | --- | --- |
| Created By: |  | Date Created: |  |
| Primary Actor: | Player Avatar | Secondary Actors: | Boss Enemy |
| Trigger: | Player has defeated Boss Enemy |  |  |
| Description: | An ending cutscene plays to resolve the conflict of the Boss Fight |  |  |
| Preconditions: | PRE-1. Boss Enemy is dead |  |  |
| Postconditions: | POST-1. Boss Enemy level is disabled in level menu |  |  |
| Main Success Scenario: | 1. The Boss Enemy plays its death animation
2. Player Avatar positions self to appropriate location for cutscene
3. A cutscene plays
4. Player Avatar plays a level exit animation
5. Use Case ends |  |  |
| Extensions: |  |  |  |

| UC ID and Name: | UC-20: Celestial Primate Lighting Bolt |  |  |
| --- | --- | --- | --- |
| Created By: |  | Date Created: |  |
| Primary Actor: | Celestial Primate | Secondary Actors: | Player Avatar |
| Trigger: | Celestial Primate Action Cooldown is at 0, Attack has been selected randomly from attacks available in current phase |  |  |
| Description: | The Celestial Primate attacks using a volley of lightning bolts |  |  |
| Preconditions: | PRE-1. Player Avatar is alive
PRE-2. Action Cooldown is 0
PRE-3. UC-15 is being extended
PRE-4. Current phase includes this attack |  |  |
| Postconditions: | POST-1. Action Cooldown is reset |  |  |
| Main Success Scenario: | 1. The Celestial Primate telegraphs a lightning bolt attack at the Player Avatar’s current position
2. Lightning bolt fires at the end of its telegraph duration
3. Simultaneously, the Celestial Primate continues to telegraph 3 more lightning bolt attacks with a short delay between them
4. Use Case ends |  |  |
| Extensions: |  |  |  |

| UC ID and Name: | UC-21: Celestial Primate Meteor Swarm |  |  |
| --- | --- | --- | --- |
| Created By: |  | Date Created: |  |
| Primary Actor: | Celestial Primate | Secondary Actors: | Player Avatar |
| Trigger: | Celestial Primate Action Cooldown is at 0, Attack has been selected randomly from attacks available in current phase |  |  |
| Description: | The Celestial Primate attacks using a swarm of tracking meteors |  |  |
| Preconditions: | PRE-1. Player Avatar is alive
PRE-2. Action Cooldown is 0
PRE-3. UC-15 is being extended
PRE-4. Current phase includes this attack |  |  |
| Postconditions: | POST-1. Action Cooldown is reset |  |  |
| Main Success Scenario: | 1. The Celestial Primate shoots a swarm of small meteors up into the air
2. The meteors track the Player Avatar’s location for a short duration
3. The meteors continue on their current trajectory when the tracking duration has elapsed
4. Use Case ends |  |  |
| Extensions: |  |  |  |

| UC ID and Name: | UC-22: Celestial Primate Ice Shock |  |  |
| --- | --- | --- | --- |
| Created By: |  | Date Created: |  |
| Primary Actor: | Celestial Primate | Secondary Actors: | Player Avatar |
| Trigger: | Celestial Primate Action Cooldown is at 0, Attack has been selected randomly from attacks available in current phase |  |  |
| Description: | The Celestial Primate chills a circular area that flash-freezes for damage at the end of the telegraph duration |  |  |
| Preconditions: | PRE-1. Player Avatar is alive
PRE-2. Action Cooldown is 0
PRE-3. UC-15 is being extended
PRE-4. Current phase includes this attack |  |  |
| Postconditions: | POST-1. Action Cooldown is reset |  |  |
| Main Success Scenario: | 1. The Celestial Primate begins the ice shock attack at the Player Avatar’s location
2. The ice shock animation plays
3. After the telegraph duration ends, the ice shock deals damage in the area
4. Use Case ends |  |  |
| Extensions: | **4a. Player Avatar hit**
4a1. Player Avatar gains a debuff that slows them for a short time |  |  |

| UC ID and Name: | UC-23: Celestial Primate Flame Pillars |  |  |
| --- | --- | --- | --- |
| Created By: |  | Date Created: |  |
| Primary Actor: | Celestial Primate | Secondary Actors: | Player Avatar |
| Trigger: | Celestial Primate Action Cooldown is at 0, Attack has been selected randomly from attacks available in current phase |  |  |
| Description: | The Celestial Primate attacks using columns of flame that appear simultaneously, equally spaced across the stage |  |  |
| Preconditions: | PRE-1. Player Avatar is alive
PRE-2. Action Cooldown is 0
PRE-3. UC-15 is being extended
PRE-4. Current phase includes this attack |  |  |
| Postconditions: | POST-1. Action Cooldown is reset |  |  |
| Main Success Scenario: | 1. The Celestial Primate creates flame columns based on the Player Avatar’s current position; the first column is placed at the Player Avatar’s current location, and the other columns are created based on that initial column
2. The flame column telegraph animations play
3. After the telegraph duration ends, the flame columns deal damage in their respective areas
4. Use Case ends |  |  |
| Extensions: |  |  |  |

| UC ID and Name: | UC-24: Celestial Primate Chaos Crush Mid-Combat Event |  |  |
| --- | --- | --- | --- |
| Created By: |  | Date Created: |  |
| Primary Actor: | Celestial Primate | Secondary Actors: | Player Avatar |
| Trigger: | Celestial Primate Action Cooldown is at 0, Phase 3 has begun |  |  |
| Description: | The Celestial Primate appears in the center of the stage and summons a black hole that tries to suck the Player Avatar in |  |  |
| Preconditions: | PRE-1. Player Avatar is alive
PRE-2. Action Cooldown is 0
PRE-3. UC-12 is being extended |  |  |
| Postconditions: | POST-1. Action Cooldown is reset |  |  |
| Main Success Scenario: | 1. The Celestial Primate teleports to the center of the stage
2. The Celestial Primate performs its Chaos Crush animation
3. A black hole is summoned underneath the Celestial Primate
4. A lotus seat is summoned beneath the black hole, at ground level
5. The Player Avatar is drawn into the black hole
6. Black hole closing animation runs
7. Use Case ends |  |  |
| Alternatives: | **5a. Lotus Seat Yin-Yang Defense**
5a1. Player Avatar stays motionless over lotus seat
5a2. An animation plays indicating the Player Avatar’s safety
5a3. Use case continues at 6.

**5b. Lotus Seat Yin-Yang Defense Fail**
5b1. Player Avatar stays motionless over lotus seat
5b2. An animation plays indicating the Player Avatar’s safety
5b3. The Player Avatar moves
5b4. Use case continues at 6a. |  |  |
| Extensions: | **6a. Player Avatar gets sucked into black hole**
6a1. Player Avatar disappears for a short time before reappearing and taking damage
6a2. Use case continues at 6. |  |  |

| UC ID and Name: | UC-25: Enemy Movement |  |  |
| --- | --- | --- | --- |
| Created By: |  | Date Created: |  |
| Primary Actor: | Enemy | Secondary Actors: |  |
| Trigger: | Enemy Action Cooldown is at 0, movement action has been selected |  |  |
| Description: | The Enemy moves to a different location |  |  |
| Preconditions: | PRE-1. Player Avatar is alive
PRE-2. Action Cooldown is 0
PRE-3. Enemy is alive |  |  |
| Postconditions: | POST-1. Action Cooldown is reset |  |  |
| Main Success Scenario: | 1. The Enemy selects a movement action
2. The Enemy performs the selected movement
3. Use Case ends |  |  |
| Extensions: |  |  |  |

| UC ID and Name: | UC-26: Celestial Primate Straight Movement |  |  |
| --- | --- | --- | --- |
| Created By: |  | Date Created: |  |
| Primary Actor: | Celestial Primate | Secondary Actors: |  |
| Trigger: | Celestial Primate Action Cooldown is at 0, movement action has been selected |  |  |
| Description: | The Celestial Primate moves between two Anchor Points in a straight line |  |  |
| Preconditions: | PRE-1. Player Avatar is alive
PRE-2. Action Cooldown is 0
PRE-3. Celestial Primate is alive
PRE-4. UC-25 is in progress |  |  |
| Postconditions: | POST-1. Action Cooldown is reset |  |  |
| Main Success Scenario: | 1. The Celestial Primate selects the straight movement action
2. The Celestial Primate moves in a straight line between two Anchor Points
3. Use Case ends |  |  |
| Extensions: |  |  |  |

| UC ID and Name: | UC-27: Celestial Primate Arc Movement |  |  |
| --- | --- | --- | --- |
| Created By: |  | Date Created: |  |
| Primary Actor: | Celestial Primate | Secondary Actors: |  |
| Trigger: | Celestial Primate Action Cooldown is at 0, movement action has been selected |  |  |
| Description: | The Celestial Primate moves between two Anchor Points in an arc |  |  |
| Preconditions: | PRE-1. Player Avatar is alive
PRE-2. Action Cooldown is 0
PRE-3. Celestial Primate is alive
PRE-4. UC-25 is in progress |  |  |
| Postconditions: | POST-1. Action Cooldown is reset |  |  |
| Main Success Scenario: | 1. The Celestial Primate selects the arc movement action
2. The Celestial Primate moves in an arc between two Anchor Points
3. Use Case ends |  |  |
| Extensions: |  |  |  |

| UC ID and Name: | UC-27: Celestial Primate Teleport Movement |  |  |
| --- | --- | --- | --- |
| Created By: |  | Date Created: |  |
| Primary Actor: | Celestial Primate | Secondary Actors: |  |
| Trigger: | Celestial Primate Action Cooldown is at 0, movement action has been selected |  |  |
| Description: | The Celestial Primate teleports between two Anchor Points |  |  |
| Preconditions: | PRE-1. Player Avatar is alive
PRE-2. Action Cooldown is 0
PRE-3. Celestial Primate is alive
PRE-4. UC-25 is in progress |  |  |
| Postconditions: | POST-1. Action Cooldown is reset |  |  |
| Main Success Scenario: | 1. The Celestial Primate selects the teleport movement action
2. The Celestial Primate plays a teleport-out animation
3. The Celestial Primate appears at the destination Anchor Point
4. The Celestial Primate plays a teleport-in animation
5. Use Case ends |  |  |
| Extensions: |  |  |  |

| UC ID and Name: | UC-28: Boss Enemy Phase Change |  |  |
| --- | --- | --- | --- |
| Created By: |  | Date Created: |  |
| Primary Actor: | Boss Enemy | Secondary Actors: | Player Avatar |
| Trigger: | Boss Enemy Health reduces below phase threshold |  |  |
| Description: | The Boss Enemy changes phases, gaining new abilities and behaviour |  |  |
| Preconditions: | PRE-1. Boss Enemy is alive |  |  |
| Postconditions: | POST-1. Boss Enemy is in the next phase |  |  |
| Main Success Scenario: | 1. The Boss Enemy loses Health that takes them below the phase change threshold
2. A visual effect plays to indicate a phase change has occurred
3. The Boss Enemy’s phase moves to the next phase
4. Use Case ends |  |  |
| Extensions: |  |  |  |

| UC ID and Name: | UC-29: Player Selects a Level |  |  |
| --- | --- | --- | --- |
| Created By: |  | Date Created: |  |
| Primary Actor: | Player | Secondary Actors: |  |
| Trigger: | The player presses the Left-Mouse Button on a level selection circle |  |  |
| Description: | The player wants to enter a level |  |  |
| Preconditions: | PRE-1. Player is in the Level Selection page |  |  |
| Postconditions: | POST-1. Selected level is loaded |  |  |
| Main Success Scenario: | 1. The player highlights a level selection option
2. The player presses the Left-Mouse Button over the level
3. Level details menu opens and animates
4. Player selects level start button
5. Use Case ends |  |  |
| Alternatives: | **4a. Player Selects Different Level**
4a1. Newly selected level details menu opens and animates
4a2. Use Case continues at 4. |  |  |
| Extensions: |  |  |  |

| UC ID and Name: | UC-30: Player Avatar Cast Fireball |  |  |
| --- | --- | --- | --- |
| Created By: |  | Date Created: |  |
| Primary Actor: | Player | Secondary Actors: | Player Avatar |
| Trigger: | The player pushes the Right-Mouse Button when the Fireball spell is active |  |  |
| Description: | The player wants the Player Avatar to attack using a Fireball spell |  |  |
| Preconditions: | PRE-1. Player Avatar is in a moveable state
PRE-2. Player Avatar’s Mana is above the spell’s Mana cost
PRE-3. Currently active spell is Fireball
PRE-4. UC-5 is currently active
PRE-5. Fireball cooldown timer is at 0 |  |  |
| Postconditions: | POST-1. The Player Avatar casts a spell
POST-2. The Player Avatar plays a casting animation
POST-3. A fireball spell effect is created
POST-4. Fireball spell goes on cooldown for its cooldown duration |  |  |
| Main Success Scenario: | 1. The Player presses the Right-Mouse Button
2. The Player Avatar casts a Fireball
3. The Player Avatar plays the Instant spellcast animation
4. Player Avatar Mana resource is reduced by the amount required by the fireball
5. Mana Resource bar is updated
6. Fireball moves horizontally in a straight line from where it was cast
7. Use Case ends |  |  |
| Extensions: | **7a. Fireball hit**
7a1. The fireball hits an enemy
7a2. Enemy takes damage value of fireball spell
7a3. Fireball impact animation plays
7a4. Use case ends
 |  |  |

| UC ID and Name: | UC-31: Player Avatar Cast Magic Explosion |  |  |
| --- | --- | --- | --- |
| Created By: |  | Date Created: |  |
| Primary Actor: | Player | Secondary Actors: | Player Avatar |
| Trigger: | The player pushes the Right-Mouse Button when the Fireball spell is active |  |  |
| Description: | The player wants the Player Avatar to attack using a Fireball spell |  |  |
| Preconditions: | PRE-1. Player Avatar is in a moveable state
PRE-2. Player Avatar’s Mana is above the spell’s Mana cost
PRE-3. Currently active spell is Magic Explosion
PRE-4. UC-5 is currently active |  |  |
| Postconditions: | POST-1. The Player Avatar casts a spell
POST-2. The Player Avatar plays a casting animation
POST-3. A Magic Explosion spell effect is created
POST-4. Combo step increments |  |  |
| Main Success Scenario: | 1. The Player presses the Right-Mouse Button
2. The Player Avatar casts a Magic Explosion
3. The Player Avatar plays the Magic Explosion spellcast animation for the current combo step
4. Player Avatar Mana resource is reduced by the amount required by the Magic Explosion’s mana cost
5. Mana Resource bar is updated
6. Magic Explosion animation and effect plays
7. Use Case ends |  |  |
| Extensions: | **3a. Magic Explosion Combo Injection**
3a1. GOTO UC-5 3a
 |  |  |

| UC ID and Name: | UC-32: Player Avatar Cast Magic Missilerack |  |  |
| --- | --- | --- | --- |
| Created By: |  | Date Created: |  |
| Primary Actor: | Player | Secondary Actors: | Player Avatar |
| Trigger: | The player pushes the Right-Mouse Button when the Magic Missilerack spell is active |  |  |
| Description: | The player wants the Player Avatar to attack using a Magic Missilerack spell |  |  |
| Preconditions: | PRE-1. Player Avatar is in a moveable state
PRE-2. Player Avatar’s Mana is above the spell’s Mana cost
PRE-3. Currently active spell is Magic Missilerack
PRE-4. UC-5 is currently active
PRE-5. Magic Missilerack cooldown timer is at 0 |  |  |
| Postconditions: | POST-1. The Player Avatar casts a spell
POST-2. The Player Avatar plays a casting animation
POST-3. A Magic Missilerack spell effect is created
POST-4. Magic Missilerack goes on cooldown for its cooldown duration |  |  |
| Main Success Scenario: | 1. The Player presses the Right-Mouse Button
2. The Player Avatar changes to  the Incantation spellcasting animation
3. The Magic Missilerack fades in behind the Player Avatar while the cast time elapses
4. Cast time finishes
5. Player Avatar Mana resource is reduced by the amount required by the Magic Missilerack
6. Mana Resource bar is updated
7. Magic Missilerack shoots a volley of Magic Missiles
8. Magic Missiles track the location of an Enemy until it hits them
9. Enemy hit by Magic Missile take damage value of that spell
10. Use Case ends |  |  |
| Extensions: | **4a. Player Avatar interrupted by hit**
4a1. The enemy hits the Player Avatar
4a2. Player Avatar casting is interrupted and Player Avatar state is reset to idle
4a3. GOTO UC-7
 |  |  |

| UC ID and Name: | UC-33: Player Avatar Falling Attack | DONE |  |
| --- | --- | --- | --- |
| Created By: |  | Date Created: |  |
| Primary Actor: | Player | Secondary Actors: | Player Avatar |
| Trigger: | The player attacks or casts a spell while the Player Avatar is in a falling state |  |  |
| Description: | The player wants the Player Avatar to attack while falling in the air |  |  |
| Preconditions: | PRE-1. Player Avatar is in a falling state
PRE-2. Player Avatar is in a moveable state |  |  |
| Postconditions: | POST-1. The Player Avatar attacks in the air
POST-2. The Player Avatar’s falling speed is reduced for the duration of the attack |  |  |
| Main Success Scenario: | 1. The Player presses the LMB
2. The Player Avatar attacks as described in UC-3
3. The Player Avatar’s falling speed is reduced
4. UC-3 finishes
5. The Player Avatar falling speed reverts to default
6. The Player Avatar touches the ground
7. Use Case ends |  |  |
| Alternatives: | **1a. Mid-air Combo Spell
PRE-3. Currently active spell is a Combo spell**
1a1. The Player presses the RMB
1a2. The Player Avatar casts a Combo spell, as described in UC-5, taking the 3a extension
1a3. The Player Avatar’s falling speed is reduced
1a4. UC-5 finishes
1a5. The Player Avatar falling speed reverts to default
1a6. The Player Avatar touches the ground
1a7. Use Case ends

**1b. Mid-air Incantation Spell
PRE-3. Currently active spell is an Incantation spell**
1b1. The Player presses the RMB
1b2. The Player Avatar stops falling
1b3. UC-5 proceeds, taking the 3b extension
1b4. UC-5 finishes
1b5. Player Avatar starts falling again
1b6. Use Case ends |  |  |
| Extensions: |  |  |  |