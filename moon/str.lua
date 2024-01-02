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

-----------------------------------------------------------------
-- Finished.
-----------------------------------------------------------------
return M