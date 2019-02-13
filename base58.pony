use "collections"

primitive Base58Alphabet
  fun apply(num: U8) : U8 =>
    match num
      |  0 => '1'
      |  1 => '2'
      |  2 => '3'
      |  3 => '4'
      |  4 => '5'
      |  5 => '6'
      |  6 => '7'
      |  7 => '8'
      |  8 => '9'
      |  9 => 'A'
      |  10 => 'B'
      |  11 => 'C'
      |  12 => 'D'
      |  13 => 'E'
      |  14 => 'F'
      |  15 => 'G'
      |  16 => 'H'
      |  17 => 'J'
      |  18 => 'K'
      |  19 => 'L'
      |  20 => 'M'
      |  21 => 'N'
      |  22 => 'P'
      |  23 => 'Q'
      |  24 => 'R'
      |  25 => 'S'
      |  26 => 'T'
      |  27 => 'U'
      |  28 => 'V'
      |  29 => 'W'
      |  30 => 'X'
      |  31 => 'Y'
      |  32 => 'Z'
      |  33 => 'a'
      |  34 => 'b'
      |  35 => 'c'
      |  36 => 'd'
      |  37 => 'e'
      |  38 => 'f'
      |  39 => 'g'
      |  40 => 'h'
      |  41 => 'i'
      |  42 => 'j'
      |  43 => 'k'
      |  44 => 'm'
      |  45 => 'n'
      |  46 => 'o'
      |  47 => 'p'
      |  48 => 'q'
      |  49 => 'r'
      |  50 => 's'
      |  51 => 't'
      |  52 => 'u'
      |  53 => 'v'
      |  54 => 'w'
      |  55 => 'x'
      |  56 => 'y'
      |  57 => 'z'
      else
        U8.max_value()
    end

primitive Base58ByteMap
  fun apply(char: U8) : U8 val =>
    match char
      | '1' => 0
      | '2' => 1
      | '3' => 2
      | '4' => 3
      | '5' => 4
      | '6' => 5
      | '7' => 6
      | '8' => 7
      | '9' => 8
      | 'A' => 9
      | 'B' => 10
      | 'C' => 11
      | 'D' => 12
      | 'E' => 13
      | 'F' => 14
      | 'G' => 15
      | 'H' => 16
      | 'J' => 17
      | 'K' => 18
      | 'L' => 19
      | 'M' => 20
      | 'N' => 21
      | 'P' => 22
      | 'Q' => 23
      | 'R' => 24
      | 'S' => 25
      | 'T' => 26
      | 'U' => 27
      | 'V' => 28
      | 'W' => 29
      | 'X' => 30
      | 'Y' => 31
      | 'Z' => 32
      | 'a' => 33
      | 'b' => 34
      | 'c' => 35
      | 'd' => 36
      | 'e' => 37
      | 'f' => 38
      | 'g' => 39
      | 'h' => 40
      | 'i' => 41
      | 'j' => 42
      | 'k' => 43
      | 'm' => 44
      | 'n' => 45
      | 'o' => 46
      | 'p' => 47
      | 'q' => 48
      | 'r' => 49
      | 's' => 50
      | 't' => 51
      | 'u' => 52
      | 'v' => 53
      | 'w' => 54
      | 'x' => 55
      | 'y' => 56
      | 'z' => 57
      else
        U8.max_value()
    end

primitive Base58
  fun encode(data: Array[U8]) : String ref^ =>
    try
      if (data.size() == 0) then
        return String(0)
      end

      var zeroes: USize = 0
      var length: USize = 0
      var pbegin: USize = 0
      let pend: USize = data.size()
      let iFactor: F64 = 1.365658237309761

      while ((pbegin != pend) and (data(pbegin)? == 0)) do
        pbegin = pbegin + 1
        zeroes = zeroes + 1
      end

      let size = (((pend.f64() - pbegin.f64()) * iFactor) + 1).usize() >> 0
      var b58 = Array[U8].init(0, size)

      while pbegin != pend do
        var carry: U64 = data(pbegin)?.u64()
        var i: USize = 0
        var it: USize = size - 1
        while (((carry != 0) or (i < length)) and (it < -1)) do
          carry = carry + ((256 * b58(it)?.u64()) >> 0)
          b58(it)? = (carry % 58).u8() >> 0
          carry = (carry / 58) >> 0
          it = it - 1
          i = i + 1
        end
        if (carry != 0) then
          error
        end
        length = i
        pbegin = pbegin + 1
      end

      var it: USize = size - length

      var str: String ref^ = String(zeroes + (size - it))

      while ((it != size) and (b58(it)? == 0)) do
        it = it +  1
      end

      for i in Range(0, zeroes) do
        str.push(Base58Alphabet(0))
      end

      while (it < size) do
        str.push(Base58Alphabet(b58(it)?))
        it = it + 1
      end
      str
    else
      String(0)
    end

fun decode(data: String) : Array[U8] ref^ =>
    try
      var psz: USize = 0
      var zeroes: USize = 0
      var length: USize = 0
      var factor: F64 = 0.7322476243909465

      while data(psz)? == Base58Alphabet(0) do
        zeroes = zeroes + 1
        psz = psz + 1
      end

      let size: USize = (((data.size() - psz).f64() * factor) + 1).usize() >> 0
      var b256: Array[U8] = Array[U8].init(0, size)
      while psz < data.size() do
        var carry: U64 = Base58ByteMap(data(psz)?).u64()
        if carry == U8.max_value().u64() then
          error
        end

        var it: USize = size - 1
        var i: USize = 0

        while (((carry != 0) or (i < length)) and (it != -1)) do
          carry = carry + ((58 * b256(it)?.u64()) >> 0)
          b256(it)? = (carry % 256).u8() >> 0
          carry = (carry / 256) >> 0
          i = i + 1
          it = it - 1
        end

        if carry != 0 then
          error
        end
        length = i
        psz = psz + 1
      end

      var it: USize = size - length
      while ((it != size) and (b256(it)? == 0)) do
        it = it + 1
      end

      var vch: Array[U8] = Array[U8].init(0, (zeroes + (size - it)))
      var j: USize = zeroes
      while it != size do
        vch(j = j + 1)? = b256(it = it + 1)?
      end
      vch
    else
      Array[U8](0)
    end
