-----------------------------------------------------------------
-- Logging.
-----------------------------------------------------------------
local M = {}

-----------------------------------------------------------------
-- Imports.
-----------------------------------------------------------------
local printer = require'moon.printer'
local colors = require'moon.colors'

-----------------------------------------------------------------
-- Aliases.
-----------------------------------------------------------------
local format = string.format
local getenv = os.getenv
local tointeger = math.tointeger

local printfln = printer.printfln

local ANSI_NORMAL = colors.ANSI_NORMAL
local ANSI_GREEN = colors.ANSI_GREEN
local ANSI_RED = colors.ANSI_RED
local ANSI_YELLOW = colors.ANSI_YELLOW
local ANSI_BLUE = colors.ANSI_BLUE
local ANSI_BOLD = colors.ANSI_BOLD

-----------------------------------------------------------------
-- Implementation.
-----------------------------------------------------------------
function M.info( fmt, ... )
  assert( fmt )
  local msg = format( fmt, ... )
  printfln( '%sinfo%s %s', ANSI_GREEN, ANSI_NORMAL, msg )
end

function M.dbg( fmt, ... )
  assert( fmt )
  local msg = format( fmt, ... )
  printfln( '%sdebug%s %s', ANSI_BLUE, ANSI_NORMAL, msg )
end

function M.warn( fmt, ... )
  assert( fmt )
  local msg = format( fmt, ... )
  printfln( '%swarning%s %s', ANSI_YELLOW, ANSI_NORMAL, msg )
end

function M.err( fmt, ... )
  assert( fmt )
  local msg = format( fmt, ... )
  printfln( '%s%serror%s %s', ANSI_RED, ANSI_BOLD, ANSI_NORMAL,
            msg )
end

function M.fatal( fmt, ... )
  M.err( fmt, ... )
  os.exit( 1 )
end

function M.check( condition, ... )
  if not condition then M.fatal( ... ) end
end

function M.not_implemented() assert( false, 'not implemented' ) end

function M.bar()
  local columns = assert( getenv( 'COLUMNS' ),
                       'COLUMNS environment variable not set' )
  local cols = assert( tointeger( columns ) )
  local dashes = string.rep( '-', cols )
  print( dashes )
end

-----------------------------------------------------------------
-- Finished.
-----------------------------------------------------------------
return M
