defmodule PeopleSorter.Person do
  @type t :: %__MODULE__{
          last_name: String.t(),
          first_name: String.t(),
          email: String.t(),
          favorite_color: String.t(),
          date_of_birth: DateTime.t()
        }
  defstruct [:last_name, :first_name, :email, :favorite_color, :date_of_birth]

  @spec new(String.t(), String.t(), String.t(), String.t(), DateTime.t()) :: t()
  def new(last_name, first_name, email, favorite_color, date_of_birth) do
    %__MODULE__{
      last_name: last_name,
      first_name: first_name,
      email: email,
      favorite_color: favorite_color,
      date_of_birth: date_of_birth
    }
  end

  defimpl String.Chars do
    def to_string(person) do
      person.last_name <> ":" <> person.first_name
    end
  end
end
