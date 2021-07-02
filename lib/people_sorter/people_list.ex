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

  def list(name \\ __MODULE__) do
    GenServer.call(name, :list)
  end

  def list_sorted_by_dob(name \\ __MODULE__) do
    GenServer.call(name, :sort_by_dob)
  end

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
  def handle_cast({:add_person_to_list, person}, people_list) do
    {:noreply, [person | people_list]}
  end
end
