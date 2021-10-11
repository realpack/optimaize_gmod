- `cl_limit_render.lua`
  - Disables the HDR player hardware. (High Dynamic Range)
  - Disables Pixel Shaders 2.0/1.4 and Vertex Shaders 2.0
  - Sets the maximum available DirectX version.

- [`Hook-Library`](https://github.com/Srlion/Hook-Library) This is a simple, realible, fast and optimized hook library for Garry's Mod. It's well tested and will not mess anything when added to your server. It can/should improve your server performance.

- [`BadCoderz`](https://github.com/ExtReMLapin/BadCoderz) "Find unoptimized gmod addons and KILL the devs who made them"

- [`Simple-Render-Distance`](https://github.com/scuroinside/Simple-Render-Distance) Addon that allows you to change render distance of certain categories of entities on your server

- `sh_disable_widgets.lua` Disables unnecessary widget hooks that no one ever uses.

- `sh_limit_phys.lua` Changes the physics of objects, both for the server and for the client.

- `sh_nw_to_nw2.lua` "I don't think this is a good idea for now, NWVars2 have some problems right now which need fixing before this can be even considered."

- `sh_remove_ents.lua` Deletes entities that are not normally used. I think it's worth checking if you're using any of the list.

- `sh_remove_hooks.lua` Deletes hooks that. Also check if you need to.

- `cl_remove_ragdolls.lua`
  - Starts a timer to delete all ragdolls and objects on the client side.
  - Disables the unnecessary depth display hook after death.

- `sh_umsg_to_net.lua` Forces the obsolete umsg library to use the new net.

- `sv_animation.lua` Disables server-side movement of the mouth and ears.

- `sv_run_commands.lua` Runs a bunch of commands to optimize the client and its graphics. Some idiot wrote this, but it seems to work.

- `sv_seatsoptimaize.lua` Makes corrections to the seat network?

- `cl_fontcache.lua` Caches fonts and prevents them from being overwritten without changes.
___ 

Here are just some observations that might help you.

- In ./srcds_run - find the lines `ulimit -c 2000` and replace it with `ulimit -c unlimited`. This will allow us to use more resources and remove some segmentation errors.

 - You can play with the values in `server.cfg`:
  ```cfg
    mem_max_heapsize "2048"
    threadpool_affinity "4" // 8 for octa-core, 6 for hexa-core, 4 for quad-core, 2 for double-core
  ```
