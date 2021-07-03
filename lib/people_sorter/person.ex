defmodule PeopleSorter.Person do
  @type t :: %__MODULE__{
          last_name: String.t(),
          first_name: String.t(),
          email: String.t(),
          favorite_color: String.t(),
          date_of_birth: Date.t()
        }
  defstruct [:last_name, :first_name, :email, :favorite_color, :date_of_birth]

  @spec new(String.t(), String.t(), String.t(), String.t(), Date.t()) :: t()
  def new(last_name, first_name, email, favorite_color, date_of_birth) do
    %__MODULE__{
      last_name: last_name,
      first_name: first_name,
      email: email,
      favorite_color: favorite_color,
      date_of_birth: date_of_birth
    }
  end

  @doc """
  Take a list of person attributes and build a Person Struct
  """
  @spec new([String.t()]) :: t()
  def new(person_list) do
    {last_name, _} = List.pop_at(person_list, 0)
    {first_name, _} = List.pop_at(person_list, 1)
    {email, _} = List.pop_at(person_list, 2)
    {color, _} = List.pop_at(person_list, 3)
    {date_of_birth, _} = List.pop_at(person_list, 4)
    PeopleSorter.Person.new(last_name, first_name, email, color, date_of_birth)
  end

  @doc """
  Depending on the delimiter, split the line
  """
  def parse_person_line(line) do
    cond do
      String.contains?(line, "|") -> String.split(line, "|")
      String.contains?(line, ",") -> String.split(line, ",")
      true -> String.split(line, " ")
    end
  end

  defimpl String.Chars do
    def to_string(person) do
      date_of_birth = format_date(person.date_of_birth)

      "#{person.last_name} #{person.first_name} #{person.email} #{person.favorite_color} #{date_of_birth}"
    end

    defp format_date(date) do
      "#{date.month}/#{date.month}/#{date.year}"
    end
  end
end
