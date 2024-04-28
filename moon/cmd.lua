-----------------------------------------------------------------
-- Module: cmd
-----------------------------------------------------------------
local freeze = require( 'moon.freeze' )

-----------------------------------------------------------------
-- Globals.
-----------------------------------------------------------------
local _ENV = freeze.globals( _ENV )

-----------------------------------------------------------------
-- Aliases.
-----------------------------------------------------------------
local format = string.format

-----------------------------------------------------------------
-- Functions.
-----------------------------------------------------------------
local function make_command_string( prog, ... )
  assert( prog )
  local c = format( '"%s"', prog )
  assert( not prog:match( ' ' ),
          'program name should not have spaces in it.' )
  for _, arg in ipairs( table.pack( ... ) ) do
    arg = arg:gsub( '"', [[\"]] )
    -- LuaFormatter off
    c = format( '%s "%s"', c, arg )
    -- LuaFormatter on
  end
  return c
end

-- Runs a shell command in a subprocess, waits for it to end,
-- then returns the entirety of stdout as a string. If the pro-
-- gram ends with a non-zero error code then an error will be
-- thrown with information about the error. Note that stderr of
-- the subprocess is not captured, so it will just go to stderr
-- of the calling process. If you want to send stderr to stdout
-- it should work to include 2>&1 on the command line. It is ex-
-- pected that the `sh` shell is used.
local function command( prog, ... )
  local c = make_command_string( prog, ... )
  local file = assert( io.popen( c ) )
  file:flush()
  local stdout = file:read( '*all' )
  local success, termination, code = file:close()
  if not success or code ~= 0 then
    error( format( 'system command failed.\n' .. --
                       '  success:     %s\n' .. --
                       '  termination: %s\n' .. --
                       '  code:        %d\n' .. --
                       '  command:     %s', --
    success, termination, code, c ) )
  end
  return stdout
end

-- Starts the subprocess running and returns a file handle to
-- read from its stdout. The `close` method must be called on the
-- result, which returns three values as demonstrated in the
-- `command` function. One can also put the resulting file handle
-- in a to-be-closed variable which will auto-close the file on
-- scope exist, but note that has the disadvantage that you can't
-- then retrieve the results from the close function, so you'd
-- probably have to call it manually anyway.
local function command_pipe( prog, ... )
  local c = make_command_string( prog, ... )
  return assert( io.popen( c ) )
end

-----------------------------------------------------------------
-- Module definition.
-----------------------------------------------------------------
return {
  make_command_string=make_command_string,
  command=command,
  command_pipe=command_pipe,
}
