defmodule PeopleSorter.Person do
  @moduledoc """
  A Person is a struct that contains fields that describe a Person.
  """
  alias PeopleSorter.Person
  @derive {Phoenix.Param, key: :email}
  @type t :: %__MODULE__{
          last_name: String.t(),
          first_name: String.t(),
          email: String.t(),
          favorite_color: String.t(),
          date_of_birth: Date.t()
        }
  @derive {Jason.Encoder,
           only: [:last_name, :first_name, :email, :favorite_color, :date_of_birth]}
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
    with 5 <- Enum.count(person_list) do
      {last_name, _} = List.pop_at(person_list, 0)
      {first_name, _} = List.pop_at(person_list, 1)
      {email, _} = List.pop_at(person_list, 2)
      {color, _} = List.pop_at(person_list, 3)
      {dob, _} = List.pop_at(person_list, 4)

      case convert_date_to_dob(dob) do
        {:ok, date_of_birth} ->
          PeopleSorter.Person.new(last_name, first_name, email, color, date_of_birth)

        {:error, :invalid_date} ->
          IO.puts("invalid dob(#{dob}) for #{email}, skipped")
          nil
      end
    else
      _ -> nil
    end
  end

  @doc """
  convert input format of Month/Day/Year to Elixir Date
  """
  @spec convert_date_to_dob(String.t()) :: {:ok, Date.t()} | {:error, :invalid_date}
  def convert_date_to_dob(string_date) do
    with parse_results <- convert_string_parts_to_int_parts(string_date),
         false <- conversion_contains_errors?(parse_results) do
      parse_results
      |> remove_remainder_from_parse()
      |> create_date_from_date_parts()
    else
      _ -> {:error, :invalid_date}
    end
  end

  defp convert_string_parts_to_int_parts(date) do
    date
    |> String.split("/")
    |> Enum.map(&Integer.parse/1)
  end

  defp conversion_contains_errors?(int_parts) do
    Enum.any?(int_parts, fn item -> item == :error end)
  end

  defp remove_remainder_from_parse(int_parts) do
    Enum.map(int_parts, fn date_piece -> elem(date_piece, 0) end)
  end

  defp create_date_from_date_parts(date_parts) do
    {month, _} = List.pop_at(date_parts, 0)
    {day, _} = List.pop_at(date_parts, 1)
    {year, _} = List.pop_at(date_parts, 2)

    Date.new(year, month, day)
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

  @doc """
  Format date for display
  """
  def format_date(date) do
    "#{date.month}/#{date.month}/#{date.year}"
  end

  defimpl String.Chars do
    @doc """
    Fornat Person for display, add plenty of padding
    """
    def to_string(person) do
      last_name = String.pad_trailing(person.last_name, 30)
      first_name = String.pad_trailing(person.first_name, 20)
      email = String.pad_trailing(person.email, 40)
      favorite_color = String.pad_trailing(person.favorite_color, 20)

      date_of_birth =
        person.date_of_birth
        |> Person.format_date()
        |> String.pad_leading(11)

      "#{last_name} #{first_name} #{email} #{favorite_color} #{date_of_birth}"
    end
  end
end
