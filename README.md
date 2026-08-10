# Vehicle

Vehicle is a cool computer game, free software
([GNU General Public License v3.0](https://www.gnu.org/licenses/gpl.html)),
created with
[Godot Engine (https://www.godotengine.org)](https://www.godotengine.org)
and programmed by Janosch Lion.

If you run into an issue, you can report it on [GitHub](https://github.com/Janorico/Vehicle/issues/new).

Thanks to:

* [Superwaitsum](https://github.com/Superwaitsum/) for the
  [GDSerialAsset]([https://github.com/Superwaitsum/GDSerialAsset)
  repository with a compiled version of the GDSercomm library -
  without this library you cant steering with serial ports.

* [Dreapon](https://github.com/dreadpon/)
  for the [Spatial Gardener](https://github.com/dreadpon/godot_spatial_gardener)
  Godot addon - without this plugin no trees existing.

* [RedHaloStudio](https://github.com/RedHaloStudio/)
  for the
  [Sketchup Importer](https://github.com/RedHaloStudio/Sketchup_Importer)
  Blender addon - without this addon the SketchUp world was gray.

* Samuel Weywara for the Mini Snowplow car.

Vehicle contain files from:

* GDSerialAsset ([https://github.com/Superwaitsum/GDSerialAsset](https://github.com/Superwaitsum/GDSerialAsset)),
  licensed under the MIT license (See GDSerialAsset.LICENSE).

* Dreadpon's Spatial Gardener ([https://github.com/dreadpon/godot_spatial_gardener](https://github.com/dreadpon/godot_spatial_gardener)),
  licensed under the MIT license (See SpatialGardener.LICENSE.md)

## License information

    Vehicle is a car driving computer game, that is created with Godot Engine.
    Copyright (C) 2022-present Janosch Lion

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program. If not, see <https://www.gnu.org/licenses/>.

## Index

<!-- TOC -->
* [Vehicle](#vehicle)
  * [License information](#license-information)
  * [Index](#index)
  * [Version History](#version-history)
    * [Vehicle 14.0.0.0](#vehicle-14000)
      * [What's new](#whats-new)
    * [Vehicle 12.0.0.0](#vehicle-12000)
      * [What's new](#whats-new)
    * [Vehicle 11.0.0.0](#vehicle-11000)
      * [What's new](#whats-new)
    * [Vehicle 10.0.0.0](#vehicle-10000)
      * [What's new](#whats-new-1)
    * [Vehicle 9.0.0.0](#vehicle-9000)
      * [What's new](#whats-new-2)
    * [Vehicle 8.0.0.0](#vehicle-8000)
      * [What's new](#whats-new-3)
    * [Vehicle 7.0.0.0](#vehicle-7000)
      * [What's new](#whats-new-4)
    * [Vehicle 6.0.0.0](#vehicle-6000)
      * [What's new](#whats-new-5)
    * [Vehicle 5.5.0.0](#vehicle-5500)
      * [What's new](#whats-new-6)
    * [Vehicle 5.0.0.0](#vehicle-5000)
      * [What's new](#whats-new-7)
    * [Vehicle 4.0.0.0](#vehicle-4000)
      * [What's new](#whats-new-8)
    * [Vehicle 3.0.0.0](#vehicle-3000)
      * [What's new](#whats-new-9)
    * [Vehicle 2.5.0.0](#vehicle-2500)
    * [Vehicle 2.0.0.0](#vehicle-2000)
    * [Vehicle 1.0.0.0](#vehicle-1000)
<!-- TOC -->

## Version History

### Vehicle 14.0.0.0

### What's new

* Dashboard Improvements
* Optimizations
* Auto GUI scale
* Power doesn't depend on wheel count anymore
* New helicopter controller / HUD
* Directional map markers
* Touch input
* New GUI theme

### Vehicle 12.0.0.0

#### What's new

* More stable mirrors
* Change view control to option button
* Add horn
* Add outlines to helicopter roatation display for better visibility
* Enable GLES-2 fallback (more compability!)

### Vehicle 11.0.0.0

#### What's new

* The old car was renamed to 'Car (Legacy)' and a new car was added ('Car').
* Fix invalid tile on GridMap World.
* The clock.
* Adding 'Power' item to dashboard.
* Adding 'Brake' LED to dashboard.
* Changes on 'GridMap World':
    * Bigger World
    * Actualized Map
    * Hills
* Changes on 'SketchUp World'
* (For developers) Re-structuring vehicle base.
* Improve startpage
* Make port selectable (Includes a new key for ``user://last_states.json`` (``last_port``).).
* The helicopter.
* The dump truck.
* Two new views.

### Vehicle 10.0.0.0

#### What's new

* Changes on SketchUp World:
    * The big, big cave _under_ the world (With tunnel).
    * More streets.
    * A new middle-sized mountain (With lake on top).
    * The world are bigger (12x12km)
* Multiplayer improvement: Synchronizing tipping
  on dump trucks (``res://Scripts/Vehicles/DumpTruck.gd``).
* The trees have multiple sizes.
* Trees in GridMap and Real World.
* Better mirrors: interacting with velocity.

### Vehicle 9.0.0.0

#### What's new

* Crash sound system:
    * Enable and disable it in the settings dialog.
    * If enabled, play sound when collide with
      other bodies (Vehicles, World, etc.).
    * Set the maximum reported crashs (In the settings dialog too)
      and find your compromise between comfort and performance.
* Better message system:
    * See the players ID.
    * Better receiving popup (No unusable GUI, hide with a button, answer...).
* Changing 'window_state' in ``user://last_states.json``:
  The values are now maximized, fullscreen and a JSON string
  with keys size_x, size_y, position_x and position_y, not with
  keys x and y for size.
* Error fix: The smoke was adjusted on quad bike.
* Other keyboard control system:
    * __Accelerate:__
        * Up
        * Kp 8
    * __Accelerate back:__
        * Down
        * Kp 2
    * __Steer left:__
        * Left
        * Kp 4
    * __Steer right:__
        * Right
        * Kp 6
    * __Brake:__
        * Space
        * Kp 5
    * __Handbrake:__
        * Control+Space
        * Kp 0
    * __Toggle fullscreen:__
        * F11
    * __Toggle extra:__
        * Control+Enter
    * __Toggle mouse mode:__
        * Shift+Escape
    * __Reset:__
        * Control+Home
    * __Clear silo things:__
        * Control+Delete
    * __Exit:__
        * Escape

### Vehicle 8.0.0.0

#### What's new

* The center view was adjusted on quad bike, tractor and minibus.
* The silo tiles are now rocks and don't spheres.
* The messaging system:
    * On sending, choose to who it is (All or one specific player) and type your message.
    * On receiving, see from who it is, to who it is and the messages text.
* The emitting time from the silos was set from 0.4 to 0.15.
* A new (the _first_) silo in the real world (X: -100, Y: 0, Z: 0).

### Vehicle 7.0.0.0

#### What's new

* Multiplayer improvement: Joining works again.
* Silos:
    * Load the emitting tiles on the truck or the large dump truck.
    * Press 'C' to remove all emitted tiles.
* The position was moved to top right.
* On top right, the rotation was displayed too.
* The backside wall on truck.
* The center view was adjusted on car and truck.
* Changes on SketchUp World:
    * Two new lakes.
    * Improvements on the big hole bridge.
    * More accurate map (Orthographic view on capturing).
* 'Mouse' control mode:
    * Steer with moving the mouse to right/left.
    * Accelerate with pressing left button.
    * Brake with pressing middle button.
    * Accelerate back with right button.
* Press 'Shift + Escape' to toggle mouse mode from visible to captured and vice versa.
* The map shows now other players too (in blue).

### Vehicle 6.0.0.0

#### What's new

* The vehicles have mirrors.
* A new world (Real World).
* The startpage was changed:
    * The 'choose world/vehicle' buttons are in scroll containers.
    * The day-night cycle check box to disable/enable it.
    * The version label.
* Press 'R' to reset position and rotation.
* The FPS display was moved to top right.
* The speedometer was moved to dashboard (That's new too.).
* The handbrake button to control the handbrake from GUI.
* The multiplayer mode was improved:
    * No fidgeting vehicles, better collisions...
      Why? In Vehicle.gd now (additional to position and rotation),
      steering, engine force and brake updated too.
    * More than two players.
    * The players can choose different vehicles.
    * The players can't choose different worlds.
    * Displaying player names.
* The WaitPage scene (``res://Scenes/WaitPage.tscn``).
* Saving last states in ``user://last_states.json``:
    * window_state:
        * Description: The window state.
        * Values: maximized, fullscreen, size (JSON string)
    * last_typed_name:
        * Description: The last typed name for multiplayer.
        * Value: String
    * last_typed_server_ip:
        * Description: The last typed IP address for multiplayer server.
        * Value: String, must be a valid IP address.
    * last_max_players:
        * Description: The last selected maximum players value for multiplayer.
        * Value: Integer, from 2 to 100

### Vehicle 5.5.0.0

#### What's new

* The multiplayer mode.
* The FPS display.
* A new startpage.
* The tractor was improved.
* Press ESCAPE to exit.

### Vehicle 5.0.0.0

#### What's new

* A new Vehicle (Minibus).
* An improvement on the compass.
* The steering wheel, for more overview.
* The handbreak.
* The fullscreen mode is toggleable (F11).
* More keyboard steer options:
    * __Forward:__
        * Up
        * W
        * Kp 8
    * __Backward:__
        * Down
        * S
        * Kp 2
    * __Left:__
        * Left
        * A
        * Kp 4
    * __Right:__
        * Right
        * D
        * Kp 6
    * __Brake:__
        * Space
        * Kp 5
    * __Handbrake:__
        * B
        * Kp 0
    * __Toggle fullscreen:__
        * F11
* More support for serial controlling.
    * Before, Vehicle reads only the steering value from a serial port
      (Float, -1 - 1).
    * In this version (and, probably, in later versions), Vehicle reads
      _four_ numbers from a serial port (With a semicolon (;) as delimiter).
      The four numbers may refer to:
      Steering (Float, from -1 - 1); Engine force (Float, from 0 - 1);
      Backward (0 or 1); Brake (0 or 1).
    * The Arduino code was tested on an Arduino Nano.
* The X rotation from the vehicle cameras was set from -20 to -10.
* The FAR from the vehicle cameras was set from 1000 to 10000.
* The GridMap World is recreated.
* The day-night cycle.
* The new light controller.
* Changes on the world (SketchUp World).
    * More streets on the plateau.
    * A new terrace on the settlement.
    * A very, very big hole with bridge.
    * The street corners are now street _curves_!
    * A wall around the world.
    * A hill in the roundabout.
    * It's existing trees!
    * The first two leaks.

### Vehicle 4.0.0.0

#### What's new

* A new Vehicle (Tractor).
* The "Settings" button, to set engine force value, brake value,
  steer limit, steer speed and steer device
  (Keyboard and all detected serial ports)
  (The values will be saved to a JSON in the data folder,
  except the steer device).
* Serial port steering (Arduino code only tested on Arduino Mega)
* Changes on the World (SketchUp World).
    * The first settlement (In east).
    * In west a redoubt.
    * In south-west, the plateau.
* A custom GUI theme.
* The startup animation is changed.
* The start page is changed.
* The bottom bar is removed.
* A new World (GridMap World).
* The old world is named to SketchUp World.
* On start any scene, you see a GUI animation.
* The Worlds aren't colored, the Worlds are textured!

### Vehicle 3.0.0.0

#### What's new

* Changes on the World.
    * Two tunnels and a cave in the big mountain.
    * A little mountain, with _one_ tunnel.
* The startup animation.
* The control is changed.
* The bottom bar.
* A view was added.

__In previous versions you steer so:__

* UP: Forward
* DOWN: Brake / Backward
* LEFT: Steer left
* RIGHT: Steer right

__Now you steer so:__

* UP / W: Forward
* DOWN / S: Back
* LEFT / A: Steer left
* RIGHT / D: Steer right
* SPACE: Brake

### Vehicle 2.5.0.0

The world is coloured!

### Vehicle 2.0.0.0

* Adding version info to the setup executable.
* The License dialog will not be shown after a click on OK.
* The world is bigger (10km x 10km)
* A compass and a map are added.

### Vehicle 1.0.0.0

Basic functions. The world is very small and only gray.

* 3 vehicles (Car, Quad bike and Truck).
