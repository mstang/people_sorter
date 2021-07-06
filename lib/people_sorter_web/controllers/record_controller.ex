defmodule PeopleSorterWeb.RecordController do
  use PeopleSorterWeb, :controller

  action_fallback PeopleSorterWeb.FallbackController

  @doc """
  dob route process
  """
  def dob(conn, _params) do
    persons = PeopleSorter.get_list_sorted_by_dob()
    render(conn, "index.json", persons: persons)
  end

  @doc """
  color route process
  """
  def color(conn, _params) do
    persons = PeopleSorter.get_list_sorted_by_color()
    render(conn, "index.json", persons: persons)
  end

  @doc """
  last_name route process
  """
  def last_name(conn, _params) do
    persons = PeopleSorter.get_list_sorted_by_last_name()
    render(conn, "index.json", persons: persons)
  end

  @doc """
  Return the list of existing persons, no sorting
  """
  def index(conn, _params) do
    persons = PeopleSorter.get_list()
    render(conn, "index.json", persons: persons)
  end

  @doc """
  Given a person string, parse it and add a person
  """
  def create(conn, %{"person" => person}) do
    person
    |> PeopleSorter.parse_person_string()
    |> PeopleSorter.new_person()
    |> add_person(conn)
  end

  defp add_person(nil, conn) do
    error_message = Jason.encode!(%{error: "unable to create person - bad data"})

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(422, error_message)
  end

  defp add_person(person, conn) do
    with :ok <- PeopleSorter.add_person(person) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.record_path(conn, :show, person))
      |> render("show.json", person: person)
    else
      error ->
        error_message = Jason.encode!(%{error: error})

        conn
        |> put_resp_content_type("application/json")
        |> send_resp(422, error_message)
    end
  end

  @doc """
  default response when someone doesn't use dob or color or last_name
  """
  def show(conn, _params) do
    persons = PeopleSorter.get_list()
    render(conn, "index.json", persons: persons)
  end
end
