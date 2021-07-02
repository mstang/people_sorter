defmodule PeopleSorter.PersonTest do
  use ExUnit.Case

  alias PeopleSorter.Person

  test "create person" do
    {:ok, dob} = DateTime.new(~D[2016-05-24], ~T[13:26:08.003], "Etc/UTC")

    test_person = %PeopleSorter.Person{
      date_of_birth: ~U[2016-05-24 13:26:08.003Z],
      email: "markjstang@gmail.com",
      favorite_color: "red",
      first_name: "mark",
      last_name: "stang"
    }

    new_person = Person.new("stang", "mark", "markjstang@gmail.com", "red", dob)

    assert test_person == new_person
  end

  test "to string" do
    {:ok, dob} = DateTime.new(~D[2016-05-24], ~T[13:26:08.003], "Etc/UTC")

    new_person = Person.new("stang", "mark", "markjstang@gmail.com", "red", dob)

    assert "stang:mark" == to_string(new_person)
  end
end
