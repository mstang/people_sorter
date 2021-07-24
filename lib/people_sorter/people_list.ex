defmodule PeopleSorter.PeopleList do
  use GenServer
  alias PeopleSorter.Person

  @type t() :: %__MODULE__{
          people: [Person.t()]
        }
  defstruct [:people]

  def start_link(_arg, opts \\ []) do
    name = Keyword.get(opts, :name, __MODULE__)
    GenServer.start_link(__MODULE__, [], name: name)
  end

  @impl true
  def init(people_list) do
    {:ok, people_list}
  end

  @doc """
  return an unsorted list
  """
  @spec list(pid()) :: [%Person{}]
  def list(name \\ __MODULE__) do
    GenServer.call(name, :list)
  end

  @doc """
  return a list sorted by dob
  """
  @spec list_sorted_by_dob(pid()) :: [%Person{}]
  def list_sorted_by_dob(name \\ __MODULE__) do
    GenServer.call(name, :sort_by_dob)
  end

  @doc """
  return a list sorted by last_name
  """
  @spec list_sorted_by_last_name(pid()) :: [%Person{}]
  def list_sorted_by_last_name(name \\ __MODULE__) do
    GenServer.call(name, :sort_by_last_name)
  end

  @doc """
  return a list sorted by color
  """
  @spec list_sorted_by_color(pid()) :: [%Person{}]
  def list_sorted_by_color(name \\ __MODULE__) do
    GenServer.call(name, :sort_by_color)
  end

  @doc """
  return a list sorted by color and then last_name
  """
  @spec list_sorted_by_color_last_name(pid()) :: [%Person{}]
  def list_sorted_by_color_last_name(name \\ __MODULE__) do
    GenServer.call(name, :sort_by_color_last_name)
  end

  @doc """
  add a person to the list
  """
  @spec add_person_to_list(pid(), %Person{}) :: :ok
  def add_person_to_list(name \\ __MODULE__, person) do
    GenServer.cast(name, {:add_person_to_list, person})
  end

  @impl true
  @doc """
  implement returning list of people
  """
  def handle_call(:list, _from, people_list) do
    {:reply, people_list, people_list}
  end

  @impl true
  # implment sort by date of birth
  def handle_call(:sort_by_dob, _from, people_list) do
    sorted_list = Enum.sort_by(people_list, & &1.date_of_birth, {:asc, Date})
    {:reply, sorted_list, people_list}
  end

  @impl true
  # implement sorf by favorite color
  def handle_call(:sort_by_color, _from, people_list) do
    sorted_list = Enum.sort_by(people_list, & &1.favorite_color)
    {:reply, sorted_list, people_list}
  end

  @impl true
  # implment sort by last name by implementing a function to compare last names
  def handle_call(:sort_by_last_name, _from, people_list) do
    last_name_desc = fn lhs, rhs ->
      case compare(Map.get(lhs, :last_name), Map.get(rhs, :last_name)) do
        :lt -> false
        _ -> true
      end
    end

    sorted_list = Enum.sort(people_list, last_name_desc)

    {:reply, sorted_list, people_list}
  end

  @impl true
  # implement sorting by favorite color and then by last name descending
  def handle_call(:sort_by_color_last_name, _from, people_list) do
    color_last_name = fn lhs, rhs ->
      case {compare(Map.get(lhs, :favorite_color), Map.get(rhs, :favorite_color)),
            compare(Map.get(lhs, :last_name), Map.get(rhs, :last_name))} do
        {:lt, _} -> true
        {:eq, :lt} -> true
        {_, _} -> false
      end
    end

    sorted_list = Enum.sort(people_list, color_last_name)

    {:reply, sorted_list, people_list}
  end

  @impl true
  @doc """
  implment adding a person to the list
  """
  def handle_cast({:add_person_to_list, person}, people_list) do
    {:noreply, [person | people_list]}
  end

  @impl true
  @doc """
  implment emptying out the list of persons, only expected to be used for testing.
  """
  def handle_info({:empty_table, _reason}, _state) do
    {:noreply, []}
  end

  @impl true
  # implment stopping the genserver for testing purposes
  def handle_info({:quit, reason}, state) do
    {:stop, reason, state}
  end

  # needed a generic compare function, used above
  defp compare(x, x), do: :eq
  defp compare(x, y) when x > y, do: :gt
  defp compare(_, _), do: :lt
end
