defmodule PeopleSorter do
  @moduledoc """
  People Sorter takes in a list of Persons and returns them sorted.
  """

  defdelegate get_list(pid), to: PeopleSorter.PeopleList, as: :list
  defdelegate get_list_sorted_by_dob(pid), to: PeopleSorter.PeopleList, as: :list_sorted_by_dob

  defdelegate get_list_sorted_by_last_name(pid),
    to: PeopleSorter.PeopleList,
    as: :list_sorted_by_last_name

  defdelegate get_list_sorted_by_color_last_name(pid),
    to: PeopleSorter.PeopleList,
    as: :list_sorted_by_color_last_name

  defdelegate add_person(person), to: PeopleSorter.PeopleList, as: :add_person_to_list
  defdelegate add_person(pid, person), to: PeopleSorter.PeopleList, as: :add_person_to_list
end
