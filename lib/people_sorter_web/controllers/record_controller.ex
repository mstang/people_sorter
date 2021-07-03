defmodule PeopleSorterWeb.RecordController do
  use PeopleSorterWeb, :controller

  alias PeopleSorter.Person

  action_fallback PeopleSorterWeb.FallbackController

  def index(conn, _params) do
    persons = PeopleSorter.get_list()
    render(conn, "index.json", persons: persons)
  end

  def dob(conn, _params) do
    persons = PeopleSorter.get_list_sorted_by_dob()
    render(conn, "index.json", persons: persons)
  end

  def color(conn, _params) do
    persons = PeopleSorter.get_list_sorted_by_color_last_name()
    render(conn, "index.json", persons: persons)
  end

  def last_name(conn, _params) do
    persons = PeopleSorter.get_list_sorted_by_last_name()
    render(conn, "index.json", persons: persons)
  end

  #! todo add parse_person_line and new to defdelegate
  def create(conn, %{"person" => person}) do
    new_person =
      person
      |> Person.parse_person_line()
      |> Person.new()

    with :ok <- PeopleSorter.add_person(new_person) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.record_path(conn, :show, new_person))
      |> render("show.json", person: new_person)
    end
  end

  def show(conn, _params) do
    persons = PeopleSorter.get_list()
    render(conn, "index.json", persons: persons)
  end
end
