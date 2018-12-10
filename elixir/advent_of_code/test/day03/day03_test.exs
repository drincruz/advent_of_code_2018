defmodule AdventOfCode.Day03Test do
  use ExUnit.Case
  alias AdventOfCode.Day03

  test "parse_input/1" do
    parsed = Day03.parse_input("#1343 @ 132,94: 10x17")
    assert is_map(parsed)
    assert Map.has_key?(parsed, :id)
    assert Map.has_key?(parsed, :from_left)
    assert Map.has_key?(parsed, :from_top)
    assert Map.has_key?(parsed, :width)
    assert Map.has_key?(parsed, :height)
    assert Map.get(parsed, :id) == 1343
    assert Map.get(parsed, :from_left) == 132
    assert Map.get(parsed, :from_top) == 94
    assert Map.get(parsed, :width) == 10
    assert Map.get(parsed, :height) == 17
  end

  test "all_unique?/2" do
    data = [
      "#1 @ 1,3: 4x4",
      "#2 @ 3,1: 4x4",
      "#3 @ 5,5: 2x2"
    ]

    parsed_data =
      data
      |> Stream.map(&String.trim/1)
      |> Stream.map(&Day03.parse_input/1)

    coordinates_count =
      parsed_data
      |> Enum.reduce(%{}, fn (mapped_data, acc) ->
        Day03.count_squares(mapped_data, acc)
      end)

    get_square_count = fn (string_input) ->
      string_input
      |> Day03.parse_input()
      |> Day03.count_squares(%{})
    end

    id1 = get_square_count.("#1 @ 1,3: 4x4")
    assert Day03.all_unique?(id1, coordinates_count) == false
    id2 = get_square_count.("#2 @ 3,1: 4x4")
    assert Day03.all_unique?(id2, coordinates_count) == false
    id3 = get_square_count.("#3 @ 5,5: 2x2")
    assert Day03.all_unique?(id3, coordinates_count) == true
  end
end
