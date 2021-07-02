defmodule PeopleSorter do
  @moduledoc """
  People Sorter takes in a list of Persons and returns them sorted.
  """

  defdelegate get_list(pid), to: PeopleSorter.PeopleList, as: :list
  defdelegate add_person(person), to: PeopleSorter.PeopleList, as: :add_person_to_list
  defdelegate add_person(pid, person), to: PeopleSorter.PeopleList, as: :add_person_to_list
end
