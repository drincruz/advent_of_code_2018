defmodule AdventOfCode.Day06 do
  @moduledoc """
  Day 6.

  Given a list of x,y coordinates, determine the largest area using Manhattan Distance.
  """
  @day6 Path.join(["day06.txt"])

  def read do
    data =
      File.stream!(@day6, [], :line)
      |> Stream.map(&String.trim/1)
      |> Stream.map(&(String.split(&1, ", ")))
      |> Stream.map(fn [x, y] -> {String.to_integer(x), String.to_integer(y)} end)
      |> Enum.to_list()

    {min_x, max_x} =
      data
      |> Stream.map(fn {x, _y} -> x end)
      |> min_max()

    {min_y, max_y} =
      data
      |> Stream.map(fn {_x, y} -> y end)
      |> min_max()
    [{min_x, max_x}, {min_y, max_y}]
  end

  # Return the min and max of a list of values.
  # TODO FIXME: it looks like min, max will always be +/- 1 because coordinates
  # cannot be borders? I think.
  defp min_max(values) do
    sorted =
      values
      |> Enum.sort()
    {List.first(sorted), List.last(sorted)}
  end
end
