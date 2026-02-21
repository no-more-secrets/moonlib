-----------------------------------------------------------------
-- Tests for the json module.
-----------------------------------------------------------------
local Test = ...

-----------------------------------------------------------------
-- Imports.
-----------------------------------------------------------------
local assertion = require'moon.unit.assertion'
local json = require'moon.json'

-----------------------------------------------------------------
-- Freeze global access.
-----------------------------------------------------------------
-- Declare all globals used.
local assert = assert
local type = type
local next = next
local table = table

-- No reading or writing of globals from here on.
local _ENV = nil

-----------------------------------------------------------------
-- Aliases.
-----------------------------------------------------------------
local ASSERT_EQ = assertion.ASSERT_EQ
local ASSERT_THROWS = assertion.ASSERT_THROWS

local insert = table.insert

local JNULL = assert( json.JNULL )

-----------------------------------------------------------------
-- Test cases.
-----------------------------------------------------------------
function Test.list_constructor()
  local l = json.list()
  ASSERT_EQ( #l, 0 )
  ASSERT_EQ( l[0], 0 )
  ASSERT_EQ( l[1], nil )
  ASSERT_EQ( json.tostring( l ), '[]' )

  ASSERT_THROWS( function() l[3] = 5 end )
  l[1] = JNULL
  l[2] = JNULL

  l[3] = 5
  ASSERT_EQ( #l, 3 )
  ASSERT_EQ( l[0], 3 )
  ASSERT_EQ( l[1], JNULL )
  ASSERT_EQ( l[2], JNULL )
  ASSERT_EQ( l[3], 5 )
  ASSERT_EQ( l[4], nil )
  ASSERT_EQ( json.tostring( l ), '[null,null,5]' )

  ASSERT_THROWS( function() l[5] = 'hello' end )
  l[4] = JNULL

  l[5] = 'hello'
  ASSERT_EQ( #l, 5 )
  ASSERT_EQ( l[0], 5 )
  ASSERT_EQ( l[1], JNULL )
  ASSERT_EQ( l[2], JNULL )
  ASSERT_EQ( l[3], 5 )
  ASSERT_EQ( l[4], JNULL )
  ASSERT_EQ( l[5], 'hello' )
  ASSERT_EQ( l[6], nil )
  ASSERT_EQ( json.tostring( l ), '[null,null,5,null,"hello"]' )

  l[4] = nil
  ASSERT_EQ( #l, 3 )
  ASSERT_EQ( l[0], 3 )
  ASSERT_EQ( l[1], JNULL )
  ASSERT_EQ( l[2], JNULL )
  ASSERT_EQ( l[3], 5 )
  ASSERT_EQ( l[4], nil )
  ASSERT_EQ( l[5], nil )
  ASSERT_EQ( l[6], nil )
  ASSERT_EQ( json.tostring( l ), '[null,null,5]' )

  insert( l, 'zzz' )
  ASSERT_EQ( #l, 4 )
  ASSERT_EQ( l[0], 4 )
  ASSERT_EQ( l[1], JNULL )
  ASSERT_EQ( l[2], JNULL )
  ASSERT_EQ( l[3], 5 )
  ASSERT_EQ( l[4], 'zzz' )
  ASSERT_EQ( l[5], nil )
  ASSERT_EQ( l[6], nil )
  ASSERT_EQ( json.tostring( l ), '[null,null,5,"zzz"]' )

  insert( l, 'abc' )
  ASSERT_EQ( #l, 5 )
  ASSERT_EQ( l[0], 5 )
  ASSERT_EQ( l[1], JNULL )
  ASSERT_EQ( l[2], JNULL )
  ASSERT_EQ( l[3], 5 )
  ASSERT_EQ( l[4], 'zzz' )
  ASSERT_EQ( l[5], 'abc' )
  ASSERT_EQ( l[6], nil )
  ASSERT_EQ( json.tostring( l ), '[null,null,5,"zzz","abc"]' )

  l[2] = nil
  ASSERT_EQ( #l, 1 )
  ASSERT_EQ( l[0], 1 )
  ASSERT_EQ( l[1], JNULL )
  ASSERT_EQ( l[2], nil )
  ASSERT_EQ( l[3], nil )
  ASSERT_EQ( l[4], nil )
  ASSERT_EQ( l[5], nil )
  ASSERT_EQ( l[6], nil )
  ASSERT_EQ( json.tostring( l ), '[null]' )

  l[1] = 5
  ASSERT_EQ( #l, 1 )
  ASSERT_EQ( l[0], 1 )
  ASSERT_EQ( l[1], 5 )
  ASSERT_EQ( l[2], nil )
  ASSERT_EQ( l[3], nil )
  ASSERT_EQ( l[4], nil )
  ASSERT_EQ( l[5], nil )
  ASSERT_EQ( l[6], nil )
  ASSERT_EQ( json.tostring( l ), '[5]' )

  l[1] = JNULL
  ASSERT_EQ( #l, 1 )
  ASSERT_EQ( l[0], 1 )
  ASSERT_EQ( l[1], JNULL )
  ASSERT_EQ( l[2], nil )
  ASSERT_EQ( l[3], nil )
  ASSERT_EQ( l[4], nil )
  ASSERT_EQ( l[5], nil )
  ASSERT_EQ( l[6], nil )
  ASSERT_EQ( json.tostring( l ), '[null]' )

  l[1] = nil
  ASSERT_EQ( #l, 0 )
  ASSERT_EQ( l[0], 0 )
  ASSERT_EQ( l[1], nil )
  ASSERT_EQ( l[2], nil )
  ASSERT_EQ( l[3], nil )
  ASSERT_EQ( l[4], nil )
  ASSERT_EQ( l[5], nil )
  ASSERT_EQ( l[6], nil )
  ASSERT_EQ( json.tostring( l ), '[]' )
end

function Test.decode()
  local json_str
  local o

  json_str = 'null'
  o = json.decode( json_str )
  ASSERT_EQ( o, JNULL )

  json_str = '5'
  o = json.decode( json_str )
  ASSERT_EQ( type( o ), 'number' )
  ASSERT_EQ( o, 5 )

  json_str = '5.6'
  o = json.decode( json_str )
  ASSERT_EQ( type( o ), 'number' )
  ASSERT_EQ( o, 5.6 )

  json_str = '"555"'
  o = json.decode( json_str )
  ASSERT_EQ( type( o ), 'string' )
  ASSERT_EQ( o, '555' )

  json_str = '{}'
  o = json.decode( json_str )
  ASSERT_EQ( type( o ), 'table' )
  ASSERT_EQ( o[0], nil )
  ASSERT_EQ( next( o ), nil )

  json_str = '[]'
  o = json.decode( json_str )
  ASSERT_EQ( type( o ), 'table' )
  ASSERT_EQ( o[0], 0 )

  json_str = '[5]'
  o = json.decode( json_str )
  ASSERT_EQ( type( o ), 'table' )
  ASSERT_EQ( o[0], 1 )
  ASSERT_EQ( o[1], 5 )
  ASSERT_EQ( o[2], nil )

  json_str = '[5,6,null,"hello"]'
  o = json.decode( json_str )
  ASSERT_EQ( type( o ), 'table' )
  ASSERT_EQ( o[0], 4 )
  ASSERT_EQ( o[1], 5 )
  ASSERT_EQ( o[2], 6 )
  ASSERT_EQ( o[3], JNULL )
  ASSERT_EQ( o[4], 'hello' )
  ASSERT_EQ( o[5], nil )

  json_str = [=[
{
  "aaa": "bbb",
  "hello": "world",
  "nested": [
    "elem1",
    5,
    7,
    {
      "ccc": "ddd",
      "ddd": {
        "hhh": [
          "a",
          3,
          null,
          2
        ]
      }
    },
    "nine"
  ]
}]=]

  o = json.decode( json_str )

  ASSERT_EQ( type( o ), 'table' )
  ASSERT_EQ( o[0], nil )
  ASSERT_EQ( o.aaa, 'bbb' )
  ASSERT_EQ( o.hello, 'world' )
  ASSERT_EQ( o.nested[0], 5 ) -- length
  ASSERT_EQ( o.nested[1], 'elem1' )
  ASSERT_EQ( o.nested[2], 5 )
  ASSERT_EQ( o.nested[3], 7 )
  ASSERT_EQ( o.nested[4].ccc, 'ddd' )
  ASSERT_EQ( o.nested[4].ddd[0], nil )
  ASSERT_EQ( o.nested[4].ddd.hhh[0], 4 ) -- length
  ASSERT_EQ( o.nested[4].ddd.hhh[1], 'a' )
  ASSERT_EQ( o.nested[4].ddd.hhh[2], 3 )
  ASSERT_EQ( o.nested[4].ddd.hhh[3], JNULL )
  ASSERT_EQ( o.nested[4].ddd.hhh[4], 2 )
  ASSERT_EQ( o.nested[4].ddd.hhh[5], nil )
  ASSERT_EQ( o.nested[5], 'nine' )
  ASSERT_EQ( o.nested[6], nil )
end

function Test.tostring()
  local tbl, expected

  local function f() return json.tostring( tbl ) end

  tbl = nil
  expected = 'null'
  ASSERT_EQ( f(), expected )

  tbl = {}
  expected = '{}'
  ASSERT_EQ( f(), expected )

  tbl = 5
  expected = '5'
  ASSERT_EQ( f(), expected )

  tbl = 5.6
  expected = '5.6'
  ASSERT_EQ( f(), expected )

  tbl = 'hello'
  expected = '"hello"'
  ASSERT_EQ( f(), expected )

  tbl = { 'hello', 'world' }
  expected = '["hello","world"]'
  ASSERT_EQ( f(), expected )

  tbl = { hello='world', aaa='bbb' }
  expected = '{"aaa":"bbb","hello":"world"}'
  ASSERT_EQ( f(), expected )

  tbl = {
    hello='world',
    nested={
      'elem1', 5, 7, { ccc='ddd', ddd={ hhh={ 'a', 3, 2 } } },
      'nine',
    },
    aaa='bbb',
  }
  expected =
      '{"aaa":"bbb","hello":"world","nested":["elem1",5,7,{"ccc":"ddd","ddd":{"hhh":["a",3,2]}},"nine"]}'
  ASSERT_EQ( f(), expected )
end

function Test.tostring_pretty()
  local tbl, expected

  local function f() return json.tostring_pretty( tbl, 2 ) end

  tbl = nil
  expected = 'null'
  ASSERT_EQ( f(), expected )

  tbl = {}
  expected = '{}'
  ASSERT_EQ( f(), expected )

  tbl = 5
  expected = '5'
  ASSERT_EQ( f(), expected )

  tbl = 5.6
  expected = '5.6'
  ASSERT_EQ( f(), expected )

  tbl = 'hello'
  expected = '"hello"'
  ASSERT_EQ( f(), expected )

  tbl = { 'hello', 'world' }
  expected = [=[
[
  "hello",
  "world"
]]=]
  ASSERT_EQ( f(), expected )

  tbl = { hello='world', aaa='bbb' }
  expected = [[
{
  "aaa": "bbb",
  "hello": "world"
}]]
  ASSERT_EQ( f(), expected )

  tbl = {
    hello='world',
    nested={
      'elem1', 5, 7,
      { ccc='ddd', ddd={ hhh={ 'a', 3, JNULL, 2 } } }, 'nine',
    },
    aaa='bbb',
  }
  expected = [=[
{
  "aaa": "bbb",
  "hello": "world",
  "nested": [
    "elem1",
    5,
    7,
    {
      "ccc": "ddd",
      "ddd": {
        "hhh": [
          "a",
          3,
          null,
          2
        ]
      }
    },
    "nine"
  ]
}]=]
  ASSERT_EQ( f(), expected )

  tbl = {
    __key_order={ 'hello', 'nested', 'aaa' },
    hello='world',
    nested={
      'elem1', 5, 7,
      { ccc='ddd', ddd={ hhh={ 'a', 3, JNULL, 2 } } }, 'nine',
    },
    aaa='bbb',
  }
  expected = [=[
{
  "hello": "world",
  "nested": [
    "elem1",
    5,
    7,
    {
      "ccc": "ddd",
      "ddd": {
        "hhh": [
          "a",
          3,
          null,
          2
        ]
      }
    },
    "nine"
  ],
  "aaa": "bbb"
}]=]
  ASSERT_EQ( f(), expected )

  tbl = {
    __key_order={ 'hello', 'nested', 'aaa' },
    hello='world',
    nested={
      'elem1', 5, 7, {
        __key_order={ 'ddd', 'ccc' },
        ccc='ddd',
        ddd={ hhh={ 'a', 3, JNULL, 2 } },
      }, 'nine',
    },
    aaa='bbb',
  }
  expected = [=[
{
  "hello": "world",
  "nested": [
    "elem1",
    5,
    7,
    {
      "ddd": {
        "hhh": [
          "a",
          3,
          null,
          2
        ]
      },
      "ccc": "ddd"
    },
    "nine"
  ],
  "aaa": "bbb"
}]=]
  ASSERT_EQ( f(), expected )
end
