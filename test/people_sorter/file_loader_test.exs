defmodule PeopleSorter.FileLoaderTest do
  use ExUnit.Case, async: true

  alias PeopleSorter.{FileLoader, Person}

  test "load pipe-delimited file" do
    count =
      "text_pipe.txt"
      |> FileLoader.load_file()
      |> Enum.count()

    assert count == 30
  end

  test "load comma-delimited file" do
    count =
      "text_comma.txt"
      |> FileLoader.load_file()
      |> Enum.count()

    assert count == 30
  end

  test "load space-delimited file" do
    count =
      "text_space.txt"
      |> FileLoader.load_file()
      |> Enum.count()

    assert count == 30
  end

  test "parse pipe delimited person" do
    parsed = Person.parse_person_line("Bauch|Elliott|luisa.kunde@schmeler.name|Green|4/4/1930")

    assert parsed == ["Bauch", "Elliott", "luisa.kunde@schmeler.name", "Green", "4/4/1930"]
  end

  test "parse comma delimited person" do
    parsed = Person.parse_person_line("Bauch,Elliott,luisa.kunde@schmeler.name,Green,4/4/1930")

    assert parsed == ["Bauch", "Elliott", "luisa.kunde@schmeler.name", "Green", "4/4/1930"]
  end

  test "parse space delimited person" do
    parsed = Person.parse_person_line("Bauch Elliott luisa.kunde@schmeler.name Green 4/4/1930")

    assert parsed == ["Bauch", "Elliott", "luisa.kunde@schmeler.name", "Green", "4/4/1930"]
  end
end
