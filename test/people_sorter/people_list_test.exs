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

  test "add a person", %{child_spec: child_spec, person_1: person_1} do
    pid = start_supervised!(child_spec)

    PeopleSorter.add_person(pid, person_1)

    assert person_1 ==
             pid
             |> PeopleSorter.get_list()
             |> List.first()
  end

  test "add three people", %{
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

  test "sort list by birthday", %{
    child_spec: child_spec
  } do
    pid = start_supervised!(child_spec)

    Enum.each(1..30, fn _i ->
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

  test "sort list by last_name", %{
    child_spec: child_spec
  } do
    pid = start_supervised!(child_spec)

    Enum.each(1..30, fn _i ->
      new_person = create_random_person()

      #! todo remove this
      # new_person
      # |> to_string()
      # |> IO.inspect()

      PeopleSorter.add_person(pid, new_person)
    end)

    sorted_last_name =
      pid
      |> PeopleSorter.get_list()
      |> Enum.map(fn person -> Map.get(person, :last_name) end)
      |> Enum.sort(:desc)

    sorted_persons =
      pid
      |> PeopleSorter.get_list_sorted_by_last_name()
      |> Enum.map(fn person -> Map.get(person, :last_name) end)

    assert sorted_last_name == sorted_persons
  end

  test "sort list by color, last_name", %{
    child_spec: child_spec
  } do
    pid = start_supervised!(child_spec)

    person_2 = %PeopleSorter.Person{
      date_of_birth: ~D[1945-08-09],
      email: "gracie2054@ward.biz",
      favorite_color: "Blue",
      first_name: "Scottie",
      last_name: "Smith"
    }

    PeopleSorter.add_person(pid, person_2)

    person_3 = %PeopleSorter.Person{
      date_of_birth: ~D[1945-09-27],
      email: "assunta_rogahn@langworth.biz",
      favorite_color: "Red",
      first_name: "Danny",
      last_name: "Avon"
    }

    PeopleSorter.add_person(pid, person_3)

    person_1 = %PeopleSorter.Person{
      date_of_birth: ~D[1976-02-10],
      email: "lexie2093@mayer.org",
      favorite_color: "Blue",
      first_name: "Jaron",
      last_name: "Hermiston"
    }

    PeopleSorter.add_person(pid, person_1)

    sorted_persons = PeopleSorter.get_list_sorted_by_color_last_name(pid)

    assert [person_1, person_2, person_3] == sorted_persons
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
