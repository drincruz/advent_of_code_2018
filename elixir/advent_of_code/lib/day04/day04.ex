defmodule AdventOfCode.Day04 do
  @moduledoc """
  Day 4.

  Repose Record.
  Part 1: Find the guard that has the most minutes of sleep.
  """
  @day4 Path.join(["day04.txt"])

  def read do
    data =
      File.stream!(@day4, [], :line)
      |> Stream.map(&String.trim/1)
      |> Enum.sort()
      |> Enum.map(&parse_input/1)

    {id, %{:guard_minutes => guard_minutes}} =
      get_minutes(data, 0, %{}, nil)
      |> Map.to_list()
      |> Enum.sort_by(fn {_id, %{total_time: t} = guard_map} -> t end)
      |> List.last()

    {minute, _frequency} =
      guard_minutes
      |> Map.to_list()
      |> Enum.sort_by(fn {_min, frequency} -> frequency end)
      |> List.last()

    id * minute
  end

  @doc """
  Parse the initial line of input.

  A line of input looks like the following:
  "[1518-11-01 23:58] Guard #99 begins shift"
  We'll want the date, time, and the log entry (rest of the input).
  """
  def parse_input(input) do
    ~r/\[(?<datetime>\d{4}-\d{2}-\d{2}\ \d{2}:\d{2})\]\ (?<rest>.+)$/
    |> Regex.named_captures(input)
    |> Map.update!("datetime", fn date ->
      case NaiveDateTime.from_iso8601(date <> ":00") do
        {:ok, ret} -> ret
        {:error, _reason} = error -> error
      end
    end)
    |> Map.update!("rest", fn rest -> parse_rest(rest) end)
  end

  @doc """
  We will parse the rest of the input string.

  The "rest" meaning binaries like the following:
  "Guard #99 begins shift"
  "wakes up"
  "falls asleep"
  For the input that has the Guard ID, we'll return the ID only.
  """
  def parse_rest("Guard #" <> rest) do
    rest
    |> String.split()
    |> List.first()
    |> String.to_integer()
  end

  def parse_rest(rest), do: rest

  @doc """
  Get the minutes recursively.

  We will iterate through the parsed logs and take action on them accordingly.
  This code smells a bit, but the algorithm gets me where I want it to be. So meh. :-|
  The gist is, that we track both the total minutes slept *and* the exact frequency of minutes per guard ID.
  This is represented in a map like so:
  %{:guard_id => %{:guard_minutes => %{}, %:total_time => integer}}
  e.g. %{234 => %{:total_time => 23423, :guard_minutes => %{11 => 1, 12 => 23, 13 => 3}}}
  """
  def get_minutes([], _prev_ts, minutes_map, _current_guard), do: minutes_map

  def get_minutes([record | tail], prev_ts, minutes_map, current_guard) do
    ts = Map.get(record, "datetime")
    case Map.get(record, "rest") do
      id when is_integer(id) ->
        get_minutes(tail, ts, minutes_map, id)
      action when is_binary(action) ->
        if String.equivalent?("falls asleep", action) do
          get_minutes(tail, ts, minutes_map, current_guard)
        else
          sleep_minutes = NaiveDateTime.diff(ts, prev_ts)
          current_guard_map = Map.get(minutes_map, current_guard, %{:guard_minutes => %{}, :total_time => 0})
          current_guard_map =
            Map.update(current_guard_map, :total_time, 0, fn minutes ->
              minutes + sleep_minutes
            end)

          guard_minutes =
            update_guard_minutes_map(prev_ts.minute..ts.minute, Map.get(current_guard_map, :guard_minutes))
          current_guard_map = Map.put(current_guard_map, :guard_minutes, guard_minutes)
          updated_minutes_map = Map.put(minutes_map, current_guard, current_guard_map)
          get_minutes(tail, ts, updated_minutes_map, current_guard)
        end
    end
  end

  @doc """
  Update the frequency count map.

  We want to be able to find out what is the most frequent minute that the guard that slept the most has.
  """
  def update_guard_minutes_map(minutes, guard_minutes) do
    minutes
    |> Enum.reduce(guard_minutes, fn (minute, acc) ->
      Map.update(acc, minute, 0, fn count -> count + 1 end)
    end)
  end
end
