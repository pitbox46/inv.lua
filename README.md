![Screenshot](https://github.com/knector01/inv.lua/blob/master/inv-client-screenshot.png?raw=true)

# inv.lua

Inventory management system for ComputerCraft:Tweaked / Restitched. Supports recursive autocrafting but is largely untested. Use with caution.

This software's UI was made using my [gui.lua](https://github.com/knector01/gui.lua) toolkit.

## Installation

This software can be downloaded from GitHub using [gitget](http://www.computercraft.info/forums2/index.php?/topic/17387-gitget-version-2-release/).
```
pastebin get W5ZkVYSi gitget
gitget knector01 inv.lua master inv
cd inv
```

## Usage

This system requires that CC:Tweaked generic peripherals be enabled. Recent versions enable this feature by default but for older ones you may need to change a setting in `computercraft_server.toml`.

To use this system, you must connect your chests to a ComputerCraft wired modem network. CC offers full-block wired modems crafted by putting a small wired modem into the crafting table, and this type must be used when connecting peripherals like chests and turtles that aren't full blocks. Place wired modems on each chest, connect the modems together with modem cables, and make sure to right-click each modem to connect the chest peripherals to the network.

Then connect a crafting turtle to the network in a similar fashion. This turtle will act as the central server for the inventory system. Install the inv.lua software on this turtle, and run `run_server.lua` to host the server. Optionally, you can also create a `startup.lua` script on the turtle that runs the server on boot:

```lua
shell.setDir("inv")
shell.run("run_server.lua")
```

Finally, place a separate Advanced Turtle connected to the same network. This one will be used as a client to retrieve items from the inventory system. Install the software as before, then run `inv_client.lua SERVER_ID` on the client turtle, replacing `SERVER_ID` with the numeric computer ID of the server. This ID can be found by running the built-in command `id` on the server turtle, and is not the same as the name displayed when initially connecting the server turtle to the wired network. If desired, you can make a startup script for the client as well:

```lua
local SERVER_ID = 1 -- replace with your server's ID
shell.setDir("inv")
shell.run("run_client.lua", SERVER_ID)
```

You can then use the client turtle's GUI to request items from the storage network, and they will be placed in the turtle's inventory. Recipes must be specified in JSON files under the recipes folder.

The turtles and chests can be placed anywhere as long as they are connected by cables, and an arbitrary number of client turtles can be connected.

## Troubleshooting

Make sure to use `cd` to enter the `inv` folder before running the client or server.

If the client or server crash when run, or you are unable to view the list of items in the network, then one of the turtles likely has not been connected to the server properly (check the cables). If the items show up in the list but cannot be pulled into to the client inventory then you may have forgotten to right-click the modem to connect the turtle fully to the network.
