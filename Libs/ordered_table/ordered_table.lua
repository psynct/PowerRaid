--[[
   LUA 5.1 compatible

   Ordered Table
   keys added will be also be stored in a metatable to recall the insertion oder
   metakeys can be seen with for i,k in ( <this>:ipairs()  or ipairs( <this>._korder ) ) do
   ipairs( ) is a bit faster

   variable names inside __index shouldn't be added, if so you must delete these again to access the metavariable
   or change the metavariable names, except for the 'del' command. thats the reason why one cannot change its value
]]--

local ordered_table

do
  -- Semantic version. all lowercase.
  -- Suffix can be alpha1, alpha2, beta1, beta2, rc1, rc2, etc.
  -- NOTE: Two version numbers need to be modified.
  -- 1. _version
  -- 2. _minor

  -- version to store the official version of ordered_table.lua
  local _version = "1.0.0"

  -- When major is changed, it should be changed to ordered_table2
  local _major = "ordered_table"

  -- Update this whenever a new version, for LibStub version registration.
  local _minor = 1

  -- Register in the World of Warcraft library "LibStub" if detected.
  if LibStub then
    local lib, minor = LibStub:GetLibrary(_major, true)
    if lib and minor and minor >= _minor then -- No need to update.
      return lib
    else -- Update or first time register
      ordered_table = LibStub:NewLibrary(_major, _minor)
      -- NOTE: It is important that new version has implemented
      -- all exported APIs and tables in the old version,
      -- so the old library is fully garbage collected,
      -- and we 100% ensure the backward compatibility.
    end
  else -- "LibStub" is not detected.
    ordered_table = {}
  end

  ordered_table._version = _version
  ordered_table._major = _major
  ordered_table._minor = _minor
end

function ordered_table.create(t)
  local mt = {}
  -- set methods
  mt.__index = {
    -- set key order table inside __index for faster lookup
    _korder = {},
    -- traversal of hidden values
    hidden = function() return pairs( mt.__index ) end,
    -- traversal of table ordered: returning index, key
    ipairs = function( self ) return ipairs( self._korder ) end,
    -- traversal of table
    pairs = function( self ) return pairs( self ) end,
    -- traversal of table ordered: returning key,value
    opairs = function( self )
      local i = 0
      local function iter( self )
        i = i + 1
        local k = self._korder[i]
        if k then
          return k,self[k]
        end
      end
      return iter,self
    end,
    -- to be able to delete entries we must write a delete function
    del = function( self,key )
      if self[key] then
        self[key] = nil
        for i,k in ipairs( self._korder ) do
          if k == key then
            table.remove( self._korder, i )
            return
          end
        end
      end
    end,
  }
  -- set new index handling
  mt.__newindex = function( self,k,v )
    if k ~= "del" and v then
      rawset( self,k,v )
      table.insert( self._korder, k )
    end
  end
  return setmetatable( t or {},mt )
end

return ordered_table
