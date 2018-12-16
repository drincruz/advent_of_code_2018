defmodule AdventOfCode.Day04Test do
  use ExUnit.Case
  alias AdventOfCode.Day04

  test "parse_input/1" do
    parsed = Day04.parse_input("[1518-02-24 23:57] Guard #521 begins shift")
    assert is_map(parsed)
    assert Map.has_key?(parsed, "datetime")
    assert String.equivalent?("1518-02-24 23:57", Map.get(parsed, "datetime"))
    assert Map.has_key?(parsed, "rest")
    assert String.equivalent?("Guard #521 begins shift", Map.get(parsed, "rest"))
  end
end
