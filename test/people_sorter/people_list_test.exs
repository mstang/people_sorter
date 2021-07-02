defmodule PeopleSorter.PersonListTest do
  use ExUnit.Case, async: true

  alias Faker.{Color, Internet, Person}

  setup do
    child_spec = %{
      id: TestProcess,
      start: {PeopleSorter.PeopleList, :start_link, [[], [name: TestProcess]]}
    }

    person_1 = create_random_person()
    person_2 = create_random_person()
    person_3 = create_random_person()

    {:ok, child_spec: child_spec, person_1: person_1, person_2: person_2, person_3: person_3}
  end

  test "returns an empty list", %{child_spec: child_spec} do
    pid = start_supervised!(child_spec)

    assert PeopleSorter.get_list(pid) == []
  end

  test "returns an empty list even when killed", %{child_spec: child_spec} do
    pid = start_supervised!(child_spec)

    Process.exit(pid, :normal)

    assert PeopleSorter.get_list(pid) == []
  end

  test "add_person", %{child_spec: child_spec, person_1: person_1} do
    pid = start_supervised!(child_spec)

    PeopleSorter.add_person(pid, person_1)

    assert person_1 ==
             pid
             |> PeopleSorter.get_list()
             |> List.first()
  end

  test "sort list by birthday", %{
    child_spec: child_spec
  } do
    pid = start_supervised!(child_spec)

    Enum.each(1..3, fn _i ->
      new_person = create_random_person()
      PeopleSorter.add_person(pid, new_person)
    end)

    sorted_dob =
      pid
      |> PeopleSorter.get_list()
      |> Enum.map(fn person -> Map.get(person, :date_of_birth) end)
      |> Enum.sort(Date)

    sorted_persons =
      pid
      |> PeopleSorter.get_list_sorted_by_dob()
      |> Enum.map(fn person -> Map.get(person, :date_of_birth) end)

    assert sorted_dob == sorted_persons
  end

  test "sort by lastname", %{
    child_spec: child_spec,
    person_1: person_1,
    person_2: person_2,
    person_3: person_3
  } do
    pid = start_supervised!(child_spec)

    PeopleSorter.add_person(pid, person_1)
    PeopleSorter.add_person(pid, person_2)
    PeopleSorter.add_person(pid, person_3)

    assert [person_3, person_2, person_1] == PeopleSorter.get_list(pid)
  end

  defp create_random_person() do
    %PeopleSorter.Person{
      date_of_birth: Faker.Date.date_of_birth(18..99),
      email: Internet.email(),
      favorite_color: Color.name(),
      first_name: Person.first_name(),
      last_name: Person.last_name()
    }
  end
end
