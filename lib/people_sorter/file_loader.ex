defmodule PeopleSorter.FileLoader do
  @moduledoc """
  Load the files, remove the newlines, parse the line, create a Person, add it to the list
  """
  alias PeopleSorter.Person

  @doc """
  Stream a file from disk, remove newlines, parse the person line,
  create a new person struct, strip out nils, add the person to the list
  """
  def load_file(filename) do
    with true <- File.exists?(filename) do
      filename
      |> File.stream!()
      |> Enum.map(&String.replace(&1, "\n", ""))
      |> Stream.map(&Person.parse_person_line/1)
      |> Stream.map(&Person.new/1)
      |> Stream.filter(fn item -> !is_nil(item) end)
      |> Stream.map(&add_person/1)
      |> Enum.to_list()
    else
      _ -> IO.puts("#{filename} doesn't exist, skipping")
    end
  end

  def add_person(%Person{} = person) do
    PeopleSorter.add_person(person)
    person
  end
end
