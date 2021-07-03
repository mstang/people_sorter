defmodule PeopleSorter.FileLoader do
  @doc """
  Load the file, remove the newlines, parse the line, create a Person, add it to the list
  """
  alias PeopleSorter.Person

  def load_file(filename) do
    with true <- File.exists?(filename) do
      filename
      |> File.stream!()
      |> Enum.map(&String.replace(&1, "\n", ""))
      |> Stream.map(&Person.parse_person_line/1)
      |> Stream.map(&Person.new/1)
      |> Stream.map(&add_person/1)
      |> Enum.to_list()
    else
      _ -> IO.puts("#{filename} doesn't exist, skipping")
    end
  end

  def add_person(%Person{} = person) do
    PeopleSorter.add_person(person)
  end
end
