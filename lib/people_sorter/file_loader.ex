defmodule PeopleSorter.FileLoader do
  @doc """
  Load the file, remove the newlines, parse the line, create a Person, add it to the list
  """
  def load_file(filename) do
    filename
    |> File.stream!()
    |> Enum.map(&String.replace(&1, "\n", ""))
    |> Stream.map(&parse_person_line/1)
    |> Stream.map(&parse_person_list/1)
    |> Stream.map(&add_person/1)
    |> Enum.to_list()
  end

  def parse_person_line(line) do
    cond do
      String.contains?(line, "|") -> String.split(line, "|")
      String.contains?(line, ",") -> String.split(line, ",")
      true -> String.split(line, " ")
    end
  end

  def parse_person_list(person_list) do
    {last_name, _} = List.pop_at(person_list, 0)
    {first_name, _} = List.pop_at(person_list, 1)
    {email, _} = List.pop_at(person_list, 2)
    {color, _} = List.pop_at(person_list, 3)
    {dob, _} = List.pop_at(person_list, 4)
    PeopleSorter.Person.new(last_name, first_name, email, color, dob)
  end

  def add_person(%PeopleSorter.Person{} = person) do
    PeopleSorter.add_person(person)
  end
end
