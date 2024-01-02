-----------------------------------------------------------------
-- File methods.
-----------------------------------------------------------------
local M = {}

-----------------------------------------------------------------
-- Aliases.
-----------------------------------------------------------------
local insert = table.insert

-----------------------------------------------------------------
-- Implementation.
-----------------------------------------------------------------
function M.exists( name )
  -- TODO: use <close> here.
  local f = io.open( name, 'r' )
  return f ~= nil and f:close()
end

-- The lines do NOT contain newlines at the end.
function M.read_file_lines( name )
  -- TODO: use <close> here.
  local f = assert( io.open( name, 'r' ) )
  local res = {}
  for line in f:lines() do
    insert( res, line )
  end
  f:close()
  return res
end

function M.append_string_to_file( filename, what )
  -- TODO: use <close> here.
  local f = assert( io.open( filename, 'a+' ) )
  f:write( what )
  f:close()
end

-----------------------------------------------------------------
-- Finished.
-----------------------------------------------------------------
return M
