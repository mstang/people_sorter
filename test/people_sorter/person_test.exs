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

  test "don't create person with bad dob - e4/4/1930" do
    parsed = Person.parse_person_line("Bauch Elliott luisa.kunde@schmeler.name Green e4/4/1930")

    assert nil == Person.new(parsed)
  end

  test "don't create person with bad dob - 24/4/1930" do
    parsed = Person.parse_person_line("Bauch Elliott luisa.kunde@schmeler.name Green 24/4/1930")

    assert nil == Person.new(parsed)
  end

  test "create person from list" do
    parsed = Person.parse_person_line("Bauch Elliott luisa.kunde@schmeler.name Green 4/4/1930")

    assert %PeopleSorter.Person{
             date_of_birth: ~D[1930-04-04],
             email: "luisa.kunde@schmeler.name",
             favorite_color: "Green",
             first_name: "Elliott",
             last_name: "Bauch"
           } == Person.new(parsed)
  end

  test "convert m/d/year to Date" do
    assert {:ok, ~D[1902-01-22]} == Person.convert_date_to_dob("01/22/1902")
  end

  test "convert alphanumeric dob to Date" do
    assert {:error, :invalid_date} == Person.convert_date_to_dob("e1/22/1902")
  end

  test "test bad Date" do
    assert {:error, :invalid_date} = Person.convert_date_to_dob("22/01/1902")
  end

  test "to string, test string formatting" do
    new_person = Person.new("stang", "mark", "markjstang@gmail.com", "red", ~D[2016-05-24])

    assert "stang                          mark                 markjstang@gmail.com                     red                     5/5/2016" ==
             to_string(new_person)
  end

  test "parse pipe delimited person" do
    parsed = Person.parse_person_line("Bauch|Elliott|luisa.kunde@schmeler.name|Green|4/4/1930")

    assert parsed == ["Bauch", "Elliott", "luisa.kunde@schmeler.name", "Green", "4/4/1930"]
  end

  test "parse comma delimited person" do
    parsed = Person.parse_person_line("Bauch,Elliott,luisa.kunde@schmeler.name,Green,4/4/1930")

    assert parsed == ["Bauch", "Elliott", "luisa.kunde@schmeler.name", "Green", "4/4/1930"]
  end

  test "parse space delimited person" do
    parsed = Person.parse_person_line("Bauch Elliott luisa.kunde@schmeler.name Green 4/4/1930")

    assert parsed == ["Bauch", "Elliott", "luisa.kunde@schmeler.name", "Green", "4/4/1930"]
  end
end
