-----------------------------------------------------------------
-- String methods.
-----------------------------------------------------------------
local M = {}

-----------------------------------------------------------------
-- Implementation.
-----------------------------------------------------------------
function M.trim( str )
  -- The '-' is like '*' except it matches the shortest sequence
  -- instead of the longest sequence.
  return str:match( '^%s*(.-)%s*$' )
end

function M.trim_right( str )
  -- The '-' is like '*' except it matches the shortest sequence
  -- instead of the longest sequence.
  return str:match( '^(.-)%s*$' )
end

-----------------------------------------------------------------
-- Finished.
-----------------------------------------------------------------
return M
