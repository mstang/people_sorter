defmodule PeopleSorterWeb.RecordView do
  use PeopleSorterWeb, :view
  alias PeopleSorterWeb.RecordView

  def render("index.json", %{persons: persons}) do
    %{data: render_many(persons, RecordView, "person.json")}
  end

  def render("show.json", %{person: person}) do
    %{data: render_one(person, RecordView, "person.json")}
  end

  def render("person.json", %{record: person}) do
    date_of_birth = PeopleSorter.Person.format_date(person.date_of_birth)

    %{
      last_name: person.last_name,
      first_name: person.first_name,
      email: person.email,
      favorite_color: person.favorite_color,
      date_of_birth: date_of_birth
    }
  end
end
