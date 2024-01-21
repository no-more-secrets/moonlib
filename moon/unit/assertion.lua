-----------------------------------------------------------------
-- Assertions for unit tests.
-----------------------------------------------------------------
local M = {}

-----------------------------------------------------------------
-- Methods.
-----------------------------------------------------------------
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

-----------------------------------------------------------------
-- Finished.
-----------------------------------------------------------------
return M
