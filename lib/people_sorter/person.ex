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
    {dob, _} = List.pop_at(person_list, 4)
    date_of_birth = convert_date_to_dob(dob)
    PeopleSorter.Person.new(last_name, first_name, email, color, date_of_birth)
  end

  @doc """
  convert input format of Month/Day/Year to Elixir Date
  """
  @spec convert_date_to_dob(String.t()) :: Date.t()
  def convert_date_to_dob(date) do
    date_parts =
      date
      |> String.split("/")
      |> Enum.map(&Integer.parse/1)
      |> Enum.map(fn date_piece -> elem(date_piece, 0) end)

    {month, _} = List.pop_at(date_parts, 0)
    {day, _} = List.pop_at(date_parts, 1)
    {year, _} = List.pop_at(date_parts, 2)

    case Date.new(year, month, day) do
      {:ok, date} -> date
      {:error, error} -> error
    end
  end

  @doc """
  Depending on the delimiter, split the line
  """
  @spec parse_person_line(String.t()) :: [String.t()]
  def parse_person_line(line) do
    cond do
      String.contains?(line, "|") -> String.split(line, "|")
      String.contains?(line, ",") -> String.split(line, ",")
      true -> String.split(line, " ")
    end
  end

  defimpl String.Chars do
    @doc """
    Fornat Person for display
    """
    def to_string(person) do
      last_name = String.pad_trailing(person.last_name, 30)
      first_name = String.pad_trailing(person.first_name, 20)
      email = String.pad_trailing(person.email, 40)
      favorite_color = String.pad_trailing(person.favorite_color, 20)

      date_of_birth =
        person.date_of_birth
        |> format_date()
        |> String.pad_leading(11)

      "#{last_name} #{first_name} #{email} #{favorite_color} #{date_of_birth}"
    end

    @doc """
    Format date for display
    """
    def format_date(date) do
      "#{date.month}/#{date.month}/#{date.year}"
    end
  end
end
