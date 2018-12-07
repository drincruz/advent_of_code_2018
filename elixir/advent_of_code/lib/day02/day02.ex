defmodule AdventOfCode.Day02 do
  @moduledoc """
    Day 02.

    Count the number of box IDs that have exactly two of any letter or that have
    exactly three of any letter.
    i.e.
      abcdef does not have any
      bababc has both two letters exactly and three letters exactly, so it counts for both.
  """

  @day2 Path.join(["day2.txt"])

  def read do
    data =
      File.stream!(@day2, [], :line)
      |> Stream.map(&String.trim/1)
      |> Enum.to_list()

    two_count = box_count(data, 0, 2)
    three_count = box_count(data, 0, 3)
    two_count * three_count
  end

  def box_count([box_id | tail], count, n) do
    box_id
    |> String.to_charlist()
    |> char_frequency()
    |> Map.values()
    |> Enum.member?(n)
    |> if do
      box_count(tail, count + 1, n)
    else
      box_count(tail, count, n)
    end
  end

  def box_count([], count, _n), do: count

  defp char_frequency(char_list) do
    char_list
    |> Enum.reduce(%{}, fn(char, acc) ->
      if Map.get(acc, char, false) do
        Map.update!(acc, char, &(&1 + 1))
      else
        Map.put(acc, char, 1)
      end
    end)
  end

  @doc """
  Part 2.

  Find two box IDs that only have one character that is different within each.
  """
  def get_box_ids do
    data =
      File.stream!(@day2, [], :line)
      |> Stream.map(&String.trim/1)
      |> Stream.map(&box_id_to_mapset/1)

    Enum.reduce_while(data, [], fn box_id, acc ->
      case check_box_id(data, box_id) do
        [data] when is_binary(data) ->
          {:halt, [data | acc]}
        _ -> {:cont, []}
      end
    end)
  end

  # change the box IDs to a mapset with indices
  def box_id_to_mapset(box_id) do
    String.to_charlist(box_id)
    |> Stream.with_index()
    |> MapSet.new()
  end

  # This is our helper function to have a box_id check itself with the other
  # box values.
  def check_box_id(boxes, box_id) do
    boxes
    |> Stream.flat_map(fn box ->
      [{MapSet.intersection(box_id, box), MapSet.difference(box_id, box)}]
    end)
    |> Stream.filter(fn {_intersection, difference} ->
      MapSet.size(difference) == 1
    end)
    |> Enum.map(fn({intersection, _difference}) ->
      intersection
      # So a MapSet.net will sort the data, but we want the order we passed it in.
      |> Enum.sort_by(fn {_char, index} -> index end)
      |> Enum.map(fn {char, _index} -> char end)
      |> IO.iodata_to_binary()
    end)
  end
end
