defmodule AdventOfCode.Day03 do
  @moduledoc """
  Day 3.

  Part 1: We need to find overlapping square inches that are within two or more claims.
  """
  @day3 Path.join(["day03.txt"])

  def read do
    File.stream!(@day3, [], :line)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&parse_input/1)
    |> Enum.reduce(%{}, fn (mapped_data, acc) ->
      count_squares(mapped_data, acc)
    end)
    |> Map.values()
    |> Enum.filter(&(&1 > 1))
    |> length()
  end

  def parse_input("#" <> rest) do
    rest
    |> String.split()
    |> clean_input()
  end

  defp clean_input([id, "@", xy, dimensions]) do
    [x, y] =
      xy
      |> String.trim(":")
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
    [width, height] =
      dimensions
      |> String.split("x")
      |> Enum.map(&String.to_integer/1)

    %{
      id: String.to_integer(id),
      from_left: x,
      from_top: y,
      width: width,
      height: height
    }
  end

  def count_squares(%{id: _id, from_left: left, from_top: top, width: width, height: height}, squares) do
    start_x = left + 1
    end_x = start_x + (width - 1)
    start_y = -top - 1
    end_y = start_y - (height - 1)

    for x <- start_x..end_x, y <- start_y..end_y do
      {x, y}
    end
    |> Enum.reduce(squares, fn (coordinate, acc) ->
      Map.update(acc, coordinate, 1, &(&1 + 1))
    end)
  end

  @doc """
  Part 2.

  Find the one ID that does _not_ have any points that overlap with other IDs.
  So, if we fetch the coordinate keys and if *all* of the values are only seen
  once, then we can assume that that specific ID is unique and doesn't overlap anything else.
  """
  def part2 do
    parsed_data =
      File.stream!(@day3, [], :line)
      |> Stream.map(&String.trim/1)
      |> Stream.map(&parse_input/1)

    coordinates_count =
      parsed_data
      |> Enum.reduce(%{}, fn (mapped_data, acc) ->
        count_squares(mapped_data, acc)
      end)

    Enum.reduce(parsed_data, [], fn (box_data, acc) ->
      if all_unique?(count_squares(box_data, %{}), coordinates_count) do
        [box_data | acc]
      else
        []
      end
    end)
  end

  def all_unique?(coordinates, coordinates_count) do
    coordinates
    |> Map.keys()
    |> Enum.all?(fn (coordinate) ->
      Map.get(coordinates_count, coordinate) == 1
    end)
  end
end
