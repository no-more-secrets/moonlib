-----------------------------------------------------------------
-- Terminal/Console related things.
-----------------------------------------------------------------
local M = {}

-----------------------------------------------------------------
-- Aliases.
-----------------------------------------------------------------
local getenv = os.getenv
local tointeger = math.tointeger

-----------------------------------------------------------------
-- Constants.
-----------------------------------------------------------------
local DEFAULT_COLUMNS = 65

-----------------------------------------------------------------
-- Methods.
-----------------------------------------------------------------
function M.terminal_columns()
  local COLUMNS = getenv( 'COLUMNS' )
  assert( COLUMNS )
  assert( type( COLUMNS ) == 'string' )
  assert( #COLUMNS > 0 )
  local cols = tointeger( COLUMNS )
  assert( cols )
  assert( cols > 0 )
  return cols
end

function M.terminal_columns_safe()
  local success, val = pcall( M.terminal_columns )
  if not success then return DEFAULT_COLUMNS end
  return val
end

function M.is_wide_terminal()
  local cols = M.terminal_columns_safe()
  return cols > 250
end

-----------------------------------------------------------------
-- Finished.
-----------------------------------------------------------------
return M
