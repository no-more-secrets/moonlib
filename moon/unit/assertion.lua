-----------------------------------------------------------------
-- Assertions for unit tests.
-----------------------------------------------------------------
local M = {}

-----------------------------------------------------------------
-- Imports.
-----------------------------------------------------------------
local tbl = require'moon.tbl'

-----------------------------------------------------------------
-- Aliases.
-----------------------------------------------------------------
local format = string.format
local tables_equal = tbl.tables_equal

-----------------------------------------------------------------
-- Methods.
-----------------------------------------------------------------
function M.ASSERT( cond )
  if cond then assert( type( cond ) == 'boolean' ) end
  if cond then return end
  error( tostring( cond ) .. ' is not true', 2 )
end

function M.ASSERT_EQ_APPROX( l, r )
  if math.abs( l - r ) < .000001 then return end
  error( tostring( l ) .. ' != ' .. tostring( r ), 2 )
end

function M.ASSERT_EQ( l, r )
  if l == r then return end
  error( tostring( l ) .. ' != ' .. tostring( r ), 2 )
end

function M.ASSERT_LE( l, r )
  if l <= r then return end
  error( tostring( l ) .. ' > ' .. tostring( r ), 2 )
end

function M.ASSERT_GE( l, r )
  if l >= r then return end
  error( tostring( l ) .. ' < ' .. tostring( r ), 2 )
end

function M.ASSERT_TABLE_EQ( l, r )
  local ok, k, l_v, l_r = tables_equal( l, r )
  if ok then return end
  error( format( 'mismatch on key %s: %s != %s', k, l_v, l_r ), 2 )
end

-----------------------------------------------------------------
-- Finished.
-----------------------------------------------------------------
return M
