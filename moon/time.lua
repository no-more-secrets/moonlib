-----------------------------------------------------------------
-- Time-related functions.
-----------------------------------------------------------------
-----------------------------------------------------------------
-- Imports.
-----------------------------------------------------------------
local posix_time = require'posix.time'

-----------------------------------------------------------------
-- Aliases.
-----------------------------------------------------------------
local nanosleep = posix_time.nanosleep
local clock_gettime = posix_time.clock_gettime
local modf = math.modf
local floor = math.floor
local pack = table.pack
local unpack = table.unpack

local CLOCK_REALTIME = posix_time.CLOCK_REALTIME

-----------------------------------------------------------------
-- Implementation.
-----------------------------------------------------------------
-- Argument is a floating point number giving number of seconds
-- to sleep.
local function sleep( secs )
  assert( secs and secs >= 0 )
  local integral, fractional = modf( secs )
  nanosleep{
    tv_sec=integral,
    tv_nsec=floor( fractional * 1000000000 ),
  }
end

-- Return the current epoch time in micros.
local function now_micros()
  local spec = clock_gettime( CLOCK_REALTIME )
  local secs, nanos = spec.tv_sec, spec.tv_nsec
  return secs * 1000000 + (nanos // 1000)
end

-- Return runtime of function in micros, followed by any return
-- values of the function.
local function timeit_micros( func )
  local start = now_micros()
  local res = pack( func() )
  local end_ = now_micros()
  return end_ - start, unpack( res )
end

-----------------------------------------------------------------
-- Finished.
-----------------------------------------------------------------
return {
  sleep=sleep,
  now_micros=now_micros,
  timeit_micros=timeit_micros,
}
