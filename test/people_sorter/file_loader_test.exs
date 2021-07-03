defmodule PeopleSorter.FileLoaderTest do
  use ExUnit.Case, async: true

  alias PeopleSorter.FileLoader

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

  @tag focus: true
  test "load space-delimited file" do
    count =
      "text_space.txt"
      |> FileLoader.load_file()
      |> Enum.count()

    assert count == 30
  end
end
