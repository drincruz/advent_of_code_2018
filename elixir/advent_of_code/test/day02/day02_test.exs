defmodule AdventOfCode.Day02Test do
  use ExUnit.Case
  alias AdventOfCode.Day02

  test "frequency/2" do
    box_ids = [
      "abcdef",
      "bababc",
      "abbcde",
      "abcccd",
      "aabcdd",
      "abcdee",
      "ababab",
    ]
    assert Day02.box_count(box_ids, 0, 2) == 4
    assert Day02.box_count(box_ids, 0, 3) == 3
  end

  test "check_box_id/2" do
    box_ids =
      [
        "abcde",
        "fghij",
        "klmno",
        "pqrst",
        "fguij",
        "axcye",
        "wvxyz"
      ]
      |> Enum.map(&Day02.box_id_to_mapset/1)

    assert Day02.check_box_id(box_ids, Day02.box_id_to_mapset("fghij")) == ["fgij"]
  end
end
