-----------------------------------------------------------------
-- Assertions for unit tests.
-----------------------------------------------------------------
local M = {}

-----------------------------------------------------------------
-- Methods.
-----------------------------------------------------------------
function M.ASSERT( cond )
  if cond then assert( type( cond ) == 'boolean' ) end
  if cond then return end
  error( tostring( cond ) .. ' is not true' )
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

-----------------------------------------------------------------
-- Finished.
-----------------------------------------------------------------
return M
