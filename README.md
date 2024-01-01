To use this library, append the following to the LUA_PATH variable:

  $HOME/dev/moonlib/?.lua

e.g.:

```sh
export LUA_PATH="$LUA_PATH;$HOME/dev/moonlib/?.lua"
```

Alternatively, if Lua itself is the driver, you can do this:

```lua
local moonlib = string.format( '%s%s', os.getenv( 'HOME' ),
                               '/dev/moonlib/?.lua' )
package.path = string.format( '%s;%s', package.path, moonlib )
```

Note that it uses a semicolon as a separator.