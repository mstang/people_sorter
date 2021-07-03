defmodule PeopleSorter.PersonTest do
  use ExUnit.Case

  alias PeopleSorter.Person

  test "create person" do
    test_person = %PeopleSorter.Person{
      date_of_birth: ~D[2016-05-24],
      email: "markjstang@gmail.com",
      favorite_color: "red",
      first_name: "mark",
      last_name: "stang"
    }

    new_person = Person.new("stang", "mark", "markjstang@gmail.com", "red", ~D[2016-05-24])

    assert test_person == new_person
  end

  test "to string" do
    new_person = Person.new("stang", "mark", "markjstang@gmail.com", "red", ~D[2016-05-24])

    assert "stang:mark" == to_string(new_person)
  end
end
