defmodule PeopleSorter.PersonTest do
  use ExUnit.Case

  alias PeopleSorter.Person

  test "create person" do
    new_person = Person.new("stang", "mark", "markjstang@gmail.com", "red", ~D[2016-05-24])

    assert %PeopleSorter.Person{
             date_of_birth: ~D[2016-05-24],
             email: "markjstang@gmail.com",
             favorite_color: "red",
             first_name: "mark",
             last_name: "stang"
           } ==
             new_person
  end

  test "to string, test string formatting" do
    new_person = Person.new("stang", "mark", "markjstang@gmail.com", "red", ~D[2016-05-24])
    assert "stang mark markjstang@gmail.com red 5/5/2016" == to_string(new_person)
  end
end
