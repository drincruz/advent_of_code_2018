defmodule AdventOfCode.Day1Test do
  use ExUnit.Case
  alias AdventOfCode.Day1

  test "frequency/2" do
    change_list = [
      "+1",
      "-1",
      "-2",
      "-3",
      "+2",
    ]
    assert Day1.frequency(change_list, 0) == -3
  end

  test "frequency/4" do
    change_list = ["+1", "-2", "+3", "+1", "+1", "-2"]
    assert Day1.frequency(change_list, 0, MapSet.new(), change_list) == 2
  end
end
