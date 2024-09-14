function change(amount)
  if math.type(amount) ~= "integer" then
    error("Amount must be an integer")
  end
  if amount < 0 then
    error("Amount cannot be negative")
  end
  local counts, remaining = {}, amount
  for _, denomination in ipairs({25, 10, 5, 1}) do
    counts[denomination] = remaining // denomination
    remaining = remaining % denomination
  end
  return counts
end

-- Write your first then lower case function here
function first_then_lower_case(tbl, predicate)
  for _, value in ipairs(tbl) do
    if predicate(value) then
      return string.lower(value)
    end
  end
-- Return nil if there is no match found
  return nil
end

-- Write your powers generator here
function powers_generator(base, limit)
  return coroutine.create(function()
    local result = 1
    while result <= limit do
      coroutine.yield(result)
      result = result * base
    end
  end)
end

-- Write your say function here
function say(word)
  local words = word or ""
  return function(next_word)
    if next_word then
      -- If next_word is an empty string, add a space
      if next_word == "" then
        words = words .. " "
      else
        -- Remove leading and trailing spaces from next_word
        next_word = next_word:match("^%s*(.-)%s*$")
        -- Only append non-empty words
        if #next_word > 0 then
          words = words .. (words == "" and "" or " ") .. next_word
        end
      end
      return say(words)
    else
      -- Return full sentence when no more words are passed
      return words
    end
  end
end

-- Write your line count function here
function meaningful_line_count(filename)
  local file, err = io.open(filename, "r")
  if not file then
    error("No such file")
  end

  local count = 0
  for line in file:lines() do
    if line:match("%S") and not line:match("^%s*#") then
      count = count + 1
    end
  end

  file:close()
  return count
end

-- Write your Quaternion table here
Quaternion = {}
Quaternion.__index = Quaternion

function Quaternion.new(a, b, c, d)
  local self = setmetatable({}, Quaternion)
  self.a = a
  self.b = b
  self.c = c
  self.d = d
  return self
end

function Quaternion.__add(q1, q2)
  return Quaternion.new(q1.a + q2.a, q1.b + q2.b, q1.c + q2.c, q1.d + q2.d)
end

function Quaternion.__mul(q1, q2)
  return Quaternion.new(
    q1.a * q2.a - q1.b * q2.b - q1.c * q2.c - q1.d * q2.d,  -- Real component
    q1.a * q2.b + q1.b * q2.a + q1.c * q2.d - q1.d * q2.c,  -- i component
    q1.a * q2.c - q1.b * q2.d + q1.c * q2.a + q1.d * q2.b,  -- j component
    q1.a * q2.d + q1.b * q2.c - q1.c * q2.b + q1.d * q2.a   -- k component
  )
end

function Quaternion:coefficients()
  return {self.a, self.b, self.c, self.d}
end

function Quaternion:conjugate()
  return Quaternion.new(self.a, -self.b, -self.c, -self.d)
end

local epsilon = 1e-9
function Quaternion.__eq(q1, q2)
  return math.abs(q1.a - q2.a) < epsilon and math.abs(q1.b - q2.b) < epsilon and
         math.abs(q1.c - q2.c) < epsilon and math.abs(q1.d - q2.d) < epsilon
end

function Quaternion:__tostring()
  local parts = {}

  -- Real component (a)
  if self.a ~= 0 then
    table.insert(parts, tostring(self.a))
  end

  -- i component (b)
  if self.b ~= 0 then
    table.insert(parts, (self.b < 0 and tostring(self.b) or (#parts > 0 and "+" or "") .. tostring(self.b)) .. "i")
  end

  -- j component (c)
  if self.c ~= 0 then
    table.insert(parts, (self.c < 0 and tostring(self.c) or (#parts > 0 and "+" or "") .. tostring(self.c)) .. "j")
  end

  -- k component (d)
  if self.d ~= 0 then
    table.insert(parts, (self.d < 0 and tostring(self.d) or (#parts > 0 and "+" or "") .. tostring(self.d)) .. "k")
  end

  -- If all parts are zero, return "0"
  if #parts == 0 then
    return "0"
  else
    return table.concat(parts)
  end
end
