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

-- No reading or writing of globals from here on.
local _ENV = nil

-----------------------------------------------------------------
-- Aliases.
-----------------------------------------------------------------
local ASSERT_EQ = assertion.ASSERT_EQ

local JNULL = assert( json.JNULL )

-----------------------------------------------------------------
-- Test cases.
-----------------------------------------------------------------
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
end
