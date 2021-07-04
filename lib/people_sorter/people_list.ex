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

  @spec list(pid()) :: [%Person{}]
  def list(name \\ __MODULE__) do
    GenServer.call(name, :list)
  end

  @spec list_sorted_by_dob(pid()) :: [%Person{}]
  def list_sorted_by_dob(name \\ __MODULE__) do
    GenServer.call(name, :sort_by_dob)
  end

  @spec list_sorted_by_last_name(pid()) :: [%Person{}]
  def list_sorted_by_last_name(name \\ __MODULE__) do
    GenServer.call(name, :sort_by_last_name)
  end

  @spec list_sorted_by_color_last_name(pid()) :: [%Person{}]
  def list_sorted_by_color_last_name(name \\ __MODULE__) do
    GenServer.call(name, :sort_by_color_last_name)
  end

  @spec add_person_to_list(pid(), %Person{}) :: :ok
  def add_person_to_list(name \\ __MODULE__, person) do
    GenServer.cast(name, {:add_person_to_list, person})
  end

  @impl true
  def handle_call(:list, _from, people_list) do
    {:reply, people_list, people_list}
  end

  @impl true
  def handle_call(:sort_by_dob, _from, people_list) do
    sorted_list = Enum.sort_by(people_list, & &1.date_of_birth, {:asc, Date})
    {:reply, sorted_list, people_list}
  end

  @impl true
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
  def handle_cast({:add_person_to_list, person}, people_list) do
    {:noreply, [person | people_list]}
  end

  @impl true
  def handle_info({:empty_table, _reason}, _state) do
    {:noreply, []}
  end

  @impl true
  def handle_info({:quit, reason}, state) do
    {:stop, reason, state}
  end

  defp compare(x, x), do: :eq
  defp compare(x, y) when x > y, do: :gt
  defp compare(_, _), do: :lt
end
