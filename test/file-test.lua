-----------------------------------------------------------------
-- Tests for the printer module.
-----------------------------------------------------------------
local Test = ...

-----------------------------------------------------------------
-- Imports.
-----------------------------------------------------------------
local assertion = require'moon.unit.assertion'
local file = require'moon.file'

-----------------------------------------------------------------
-- Freeze global access.
-----------------------------------------------------------------
-- Declare all globals used.
local os = os
local io = io
local assert = assert

-- No reading or writing of globals from here on.
local _ENV = nil

-----------------------------------------------------------------
-- Aliases.
-----------------------------------------------------------------
local ASSERT = assertion.ASSERT
local ASSERT_EQ = assertion.ASSERT_EQ

local copy_file = file.copy_file
local exists = file.exists

-----------------------------------------------------------------
-- Test cases.
-----------------------------------------------------------------
function Test.copy_file()
  local input = '/tmp/abc123.txt'
  local output = '/tmp/123abc.txt'
  if exists( input ) then os.remove( input ) end
  if exists( output ) then os.remove( output ) end

  ASSERT( not exists( input ) )
  ASSERT( not exists( output ) )

  do
    local f<close> = assert( io.open( input, 'wb' ) )
    f:write( 'hello' )
  end

  ASSERT( exists( input ) )
  ASSERT( not exists( output ) )

  copy_file( input, output )

  ASSERT( exists( input ) )
  ASSERT( exists( output ) )

  do
    local f<close> = assert( io.open( output, 'rb' ) )
    local contents = f:read( '*a' )
    ASSERT_EQ( contents, 'hello' )
  end

  ASSERT( exists( input ) )
  ASSERT( exists( output ) )
end
