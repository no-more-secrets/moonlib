-----------------------------------------------------------------
-- Time-related functions.
-----------------------------------------------------------------
local M = {}

-----------------------------------------------------------------
-- Imports.
-----------------------------------------------------------------
local posix_time = require'posix.time'

-----------------------------------------------------------------
-- Aliases.
-----------------------------------------------------------------
local nanosleep = posix_time.nanosleep
local modf = math.modf
local floor = math.floor

-----------------------------------------------------------------
-- Implementation.
-----------------------------------------------------------------
-- Argument is a floating point number giving number of seconds
-- to sleep.
function M.sleep( secs )
  assert( secs and secs >= 0 )
  local integral, fractional = modf( secs )
  nanosleep{
    tv_sec=integral,
    tv_nsec=fractional * floor( fractional * 1000000000 ),
  }
end

-----------------------------------------------------------------
-- Finished.
-----------------------------------------------------------------
return M
