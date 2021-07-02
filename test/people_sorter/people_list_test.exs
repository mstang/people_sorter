defmodule PeopleSorter.PersonListTest do
  use ExUnit.Case, async: true

  alias Faker.{Color, Date, Internet, Person}

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

  test "PeopleList.list/0 returns an empty list", %{child_spec: child_spec} do
    pid = start_supervised!(child_spec)

    assert PeopleSorter.PeopleList.list(pid) == []
  end

  test "PeopleList.list/0 returns an empty list even when killed", %{child_spec: child_spec} do
    pid = start_supervised!(child_spec)

    Process.exit(pid, :normal)

    assert PeopleSorter.PeopleList.list(pid) == []
  end

  test "PeopleList.add_person_to_list", %{child_spec: child_spec, person_1: person_1} do
    pid = start_supervised!(child_spec)

    PeopleSorter.PeopleList.add_person_to_list(pid, person_1)

    assert person_1 ==
             pid
             |> PeopleSorter.PeopleList.list()
             |> List.first()
  end

  test "add three people to list", %{
    child_spec: child_spec,
    person_1: person_1,
    person_2: person_2,
    person_3: person_3
  } do
    pid = start_supervised!(child_spec)

    PeopleSorter.PeopleList.add_person_to_list(pid, person_1)
    PeopleSorter.PeopleList.add_person_to_list(pid, person_2)
    PeopleSorter.PeopleList.add_person_to_list(pid, person_3)

    assert [person_3, person_2, person_1] ==
             PeopleSorter.PeopleList.list(pid)
  end

  defp create_random_person() do
    %PeopleSorter.Person{
      date_of_birth: Date.date_of_birth(18..99),
      email: Internet.email(),
      favorite_color: Color.name(),
      first_name: Person.first_name(),
      last_name: Person.last_name()
    }
  end
end
