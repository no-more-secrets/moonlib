-----------------------------------------------------------------
-- JSON reading and writing.
-----------------------------------------------------------------
local M = {}

-----------------------------------------------------------------
-- Imports.
-----------------------------------------------------------------
local lunajson = require( 'lunajson' )
local time = require( 'moon.time' )
local logger = require( 'moon.logger' )

-----------------------------------------------------------------
-- Aliases.
-----------------------------------------------------------------
local yield = coroutine.yield
local timeit_micros = time.timeit_micros
local dbg = logger.dbg

-----------------------------------------------------------------
-- Constants.
-----------------------------------------------------------------
local DEFAULT_INDENT = 2

M.JNULL = {}

-----------------------------------------------------------------
-- Implementation.
-----------------------------------------------------------------
-- Decode a string of json.
function M.decode( json_string )
  -- Start decoding from the start of the string.
  local pos = 0
  -- `null` inside the json will be decoded as this sentinel.
  local nullv = M.JNULL
  -- Store the length of an array in array[0]. This can be used
  -- to distinguish empty arrays from empty objects.
  local arraylen = true
  local decode_time, tbl = timeit_micros( function()
    return lunajson.decode( json_string, pos, nullv, arraylen )
  end )
  dbg( 'json decode time: %dms', decode_time // 1000 )
  assert( tbl )
  return tbl
end

M.read = assert( M.decode )

-- Coroutine generator function that pretty-prints a layout in
-- conforming JSON while preserving key ordering. Each time a
-- line is produced it will yield it.
local function pprint_ordered_impl( append, o, indent, spaces )
  indent = indent or DEFAULT_INDENT
  spaces = spaces or ''
  assert( type( indent ) == 'number' )
  assert( type( spaces ) == 'string' )
  if o == M.JNULL or o == nil then
    append( 'null' )
  elseif type( o ) == 'table' and not o[0] and not o[1] then
    -- Object.
    append( '{' )
    spaces = spaces .. string.rep( ' ', indent )
    local keys = {}
    if o.__key_order then
      for _, k in ipairs( o.__key_order ) do
        assert( type( k ) == 'string' )
        if not k:match( '^_' ) then
          table.insert( keys, k )
        end
      end
    else
      for k, _ in pairs( o ) do
        assert( type( k ) == 'string', tostring( k ) )
        if not k:match( '^_' ) then
          table.insert( keys, k )
        end
      end
      table.sort( keys )
    end
    if #keys == 0 then
      append( '}' )
      return
    end
    append()
    for i, k in ipairs( keys ) do
      assert( o[k] ~= nil )
      local v = o[k]
      k = '"' .. k .. '"'
      local colon = (indent > 0) and ': ' or ':'
      append( spaces .. k .. colon )
      pprint_ordered_impl( append, v, indent, spaces )
      if i ~= #keys then append( ',' ) end
      append()
    end
    append( string.sub( spaces, 3 ) .. '}' )
  elseif type( o ) == 'table' and (o[0] or o[1]) then
    -- Array.
    append( '[' )
    local length = o[0] and o[0] or #o
    assert( type( length ) == 'number' )
    if length == 0 then
      append( ']' )
      return
    end
    append()
    spaces = spaces .. string.rep( ' ', indent )
    for i = 1, length do
      local e = o[i] -- might be nil, that's ok.
      append( spaces )
      pprint_ordered_impl( append, e, indent, spaces )
      if i ~= #o then append( ',' ) end
      append()
    end
    append( string.sub( spaces, 3 ) .. ']' )
  elseif type( o ) == 'string' then
    append( '"' .. tostring( o ) .. '"' )
  else
    append( tostring( o ) )
  end
end

local function appender()
  local res = ''
  return function( segment )
    if not segment then
      -- flush line.
      yield( res )
      res = ''
    else
      res = res .. segment
    end
  end
end

-- Returns a coroutine generator that pretty-prints a layout in
-- conforming JSON while preserving key ordering. Each time a
-- line is produced it will yield it.
function M.pprint_ordered( o, indent )
  indent = indent or DEFAULT_INDENT
  local append = appender()
  local printer = coroutine.wrap( function()
    pprint_ordered_impl( append, o, indent )
    append() -- emit final brace.
  end )
  return printer
end

local function write_with_sep( emit, o, SEP, indent )
  assert( type( SEP ) == 'string' )
  indent = indent or DEFAULT_INDENT
  emit = emit or function( ... ) io.stdout:write( ... ) end
  local printer = M.pprint_ordered( o, indent )
  local sep = ''
  for line in printer do
    emit( sep )
    sep = SEP
    emit( line )
  end
end

function M.write_pretty( o, indent, emit )
  indent = indent or DEFAULT_INDENT
  local sep = '\n'
  return write_with_sep( emit, o, sep, indent )
end

function M.write_oneline( o, emit )
  local indent = 0
  local sep = ' '
  return write_with_sep( emit, o, sep, indent )
end

M.write = assert( M.write_pretty )
M.print = assert( M.write_pretty )

function M.tostring( o )
  local lines = {}
  local function emit( line ) table.insert( lines, line ) end
  local sep = ''
  local indent = 0
  write_with_sep( emit, o, sep, indent )
  return table.concat( lines )
end

function M.tostring_pretty( o, indent )
  local lines = {}
  local function emit( line ) table.insert( lines, line ) end
  local sep = '\n'
  write_with_sep( emit, o, sep, indent )
  return table.concat( lines )
end

-----------------------------------------------------------------
-- Finished.
-----------------------------------------------------------------
return M