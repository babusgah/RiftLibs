local bit32 = bit32 or bit or {}

local function trim32(n)
    return n % 4294967296
end

local function tosigned(n)
    n = trim32(n)
    if n >= 2147483648 then
        n = n - 4294967296
    end
    return n
end

local function isnum(v)
    return type(v) == "number" and v == v
end

if not bit32.badd then
    bit32.badd = function(...)
        local result = 0
        for _, v in ipairs({...}) do
            if isnum(v) then result = trim32(result + v) end
        end
        return result
    end
end

if not bit32.bsub then
    bit32.bsub = function(...)
        local result = nil
        for _, v in ipairs({...}) do
            if isnum(v) then
                if result == nil then result = trim32(v)
                else result = trim32(result - v) end
            end
        end
        return result or 0
    end
end

if not bit32.bmul then
    bit32.bmul = function(...)
        local result = 1
        for _, v in ipairs({...}) do
            if isnum(v) then result = trim32(result * v) end
        end
        return result
    end
end

if not bit32.bdiv then
    bit32.bdiv = function(...)
        local result = nil
        for _, v in ipairs({...}) do
            if isnum(v) then
                if result == nil then result = trim32(v)
                elseif v ~= 0 then result = trim32(math.floor(result / v)) end
            end
        end
        return result or 0
    end
end

if not bit32.bswap then
    bit32.bswap = bit32.byteswap or function(n)
        n = trim32(n)
        return trim32(
            (n % 256) * 16777216 +
            math.floor(n / 256) % 256 * 65536 +
            math.floor(n / 65536) % 256 * 256 +
            math.floor(n / 16777216)
        )
    end
end

if not bit32.ror then
    bit32.ror = bit32.rrotate or function(a, b)
        b = b % 32
        if b == 0 then return trim32(a) end
        a = trim32(a)
        local shifted = a % (2 ^ b)
        local rest = math.floor(a / (2 ^ b))
        return trim32(shifted * (2 ^ (32 - b)) + rest)
    end
end

if not bit32.rol then
    bit32.rol = bit32.lrotate or function(a, b)
        b = b % 32
        if b == 0 then return trim32(a) end
        a = trim32(a)
        local shifted = math.floor(a / (2 ^ (32 - b)))
        local rest = a % (2 ^ (32 - b))
        return trim32(rest * (2 ^ b) + shifted)
    end
end

if not bit32.tohex then
    bit32.tohex = function(n)
        return string.format("%x", trim32(n))
    end
end

if not bit32.tobit then
    bit32.tobit = function(n)
        return tosigned(n)
    end
end

getgenv().bit32 = bit32
getgenv().bit = bit32
