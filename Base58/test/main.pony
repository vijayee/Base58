use "ponytest"
use ".."
use "collections"

primitive Fixtures
  fun valid (): Array[(String, Array[U8])] ref^ =>
    try
      var fixtures: Array[(String, Array[U8])] ref^ = Array[(String, Array[U8])](14)
      fixtures(0)? = ("2g", [54; 49])
      fixtures(1)? = ("a3gV", [54; 50; 54; 50; 54; 50])
      fixtures(2)? = ("aPEr", [54; 51; 54; 51; 54; 51])
      fixtures(3)? = ("2cFupjhnEsSn59qHXstmK2ffpLv2", [55; 51; 54; 57; 54; 100; 55; 48; 54; 99; 55; 57; 50; 48; 54; 49; 50; 48; 54; 99; 54; 102; 54; 101; 54; 55; 50; 48; 55; 51; 55; 52; 55; 50; 54; 57; 54; 101; 54; 55])
      fixtures(4)? = ("1NS17iag9jJgTHD1VXjvLCEnZuQ3rJDE9L", [48; 48; 101; 98; 49; 53; 50; 51; 49; 100; 102; 99; 101; 98; 54; 48; 57; 50; 53; 56; 56; 54; 98; 54; 55; 100; 48; 54; 53; 50; 57; 57; 57; 50; 53; 57; 49; 53; 97; 101; 98; 49; 55; 50; 99; 48; 54; 54; 52; 55])
      fixtures(5)? = ("ABnLTmg", [53; 49; 54; 98; 54; 102; 99; 100; 48; 102])
      fixtures(6)? = ("3SEo3LWLoPntC", [98; 102; 52; 102; 56; 57; 48; 48; 49; 101; 54; 55; 48; 50; 55; 52; 100; 100])
      fixtures(7)? = ("3EFU7m", [53; 55; 50; 101; 52; 55; 57; 52])
      fixtures(8)? = ("EJDM8drfXA6uyA",  [101; 99; 97; 99; 56; 57; 99; 97; 100; 57; 51; 57; 50; 51; 99; 48; 50; 51; 50; 49])
      fixtures(9)? = ("Rt5zm", [49; 48; 99; 56; 53; 49; 49; 101])
      fixtures(11)? = ("1111111111", [48; 48; 48; 48; 48; 48; 48; 48; 48; 48; 48; 48; 48; 48; 48; 48; 48; 48; 48; 48])
      fixtures(12)? = ("5Hx15HFGyep2CfPxsJKe2fXJsCVn5DEiyoeGGF6JZjGbTRnqfiD", [56; 48; 49; 49; 56; 52; 99; 100; 50; 99; 100; 100; 54; 52; 48; 99; 97; 52; 50; 99; 102; 99; 51; 97; 48; 57; 49; 99; 53; 49; 100; 53; 52; 57; 98; 50; 102; 48; 49; 54; 100; 52; 53; 52; 98; 50; 55; 55; 52; 48; 49; 57; 99; 50; 98; 50; 100; 50; 101; 48; 56; 53; 50; 57; 102; 100; 50; 48; 54; 101; 99; 57; 55; 101])
      fixtures(13)? = ("16UjcYNBG9GTK4uq2f7yYEbuifqCzoLMGS", [48; 48; 51; 99; 49; 55; 54; 101; 54; 53; 57; 98; 101; 97; 48; 102; 50; 57; 97; 51; 101; 57; 98; 102; 55; 56; 56; 48; 99; 49; 49; 50; 98; 49; 98; 51; 49; 98; 52; 100; 99; 56; 50; 54; 50; 54; 56; 49; 56; 55])
      fixtures
    else
      []
    end

primitive U8Array
  fun equal(a: Array[U8] ref^, b: Array[U8] ref^) : Bool =>
    try
      if (a.size() != b.size()) then
        return false
      end
      for i in Range(0, a.size()) do
        if a(i)? != b(i)? then
          return false
        end
      end
      true
    else
      false
    end


actor Main is TestList
  new create(env: Env) =>
    PonyTest(env, this)
  new make () =>
    None
  fun tag tests(test: PonyTest) =>
    test(_TestEmpty)
    test(_TestFixtures)

class iso _TestEmpty is UnitTest
  fun name(): String => "Testing Empty Array"
  fun apply(t: TestHelper) =>
    var buf: Array[U8] = []
    try
      var result: String ref^ =  Base58.encode(buf)?
      t.assert_true(result == "")
    else
      t.assert_true(false)
    end

class iso _TestFixtures is UnitTest
  fun name(): String => "Testing Valid Fixtures"
  fun apply(t: TestHelper) =>
    var fixtures = Fixtures.valid()
    for fixture in fixtures.values() do
      let encoded: String ref^ = try Base58.encode(fixture._2)? else String(0) end
      t.assert_true(encoded == fixture._1)
      let decoded: Array[U8] ref^ = try Base58.decode(encoded)? else Array[U8](0) end
      t.assert_true(U8Array.equal(decoded, fixture._2))
    end
