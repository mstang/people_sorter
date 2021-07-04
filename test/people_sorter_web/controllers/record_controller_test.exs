defmodule PeopleSorterWeb.RecordControllerTest do
  use PeopleSorterWeb.ConnCase, async: false

  @create_attrs "Krajcik|Antonio|jade1918@schmeler.biz|Black|4/4/1946"
  @bad_dob_attrs "Krajcik|Antonio|jade1918@schmeler.biz|Black|44/4/1946"
  @alpha_dob_attrs "Krajcik|Antonio|jade1918@schmeler.biz|Black|e4/4/1946"
  @missing_dob_attrs "Krajcik|Antonio|jade1918@schmeler.biz|Black"
  @invalid_attrs "nil|nil|nil|nil|nil"

  @doc """
  Fixture to create sortable persons
  """
  def fixture(:persons) do
    persons = [
      "Rippin|Annalise|buford.braun@erdman.org|Pink|3/3/1986",
      "Dietrich|Cooper|oda2088@langosh.info|Pink|9/9/1953",
      "Rippin|Annalise|buford.braun@erdman.org|Pink|3/3/1986",
      "Kozey|Kenya|noemy2037@mante.biz|Green|8/8/1990",
      "Rolfson|Guido|shaina2003@rutherford.info|Brown|9/9/1932",
      "Ferry|Russell|pearlie2031@ernser.biz|Brown|8/8/1982",
      "Krajcik|Antonio|jade1918@schmeler.biz|Black|4/4/1946",
      "Bailey|Ada|ron.erdman@crist.info|Black|2/2/1950",
      "Beatty|Nedra|dorothea.huels@smith.net|Black|12/12/1929",
      "Dickens|Coleman|sasha.oreilly@sawayn.net|Pink|4/4/1991",
      "Nitzsche|Robert|gerson2032@altenwerth.biz|Blue|9/9/1945"
    ]

    for person <- persons do
      person
      |> PeopleSorter.parse_person_string()
      |> PeopleSorter.new_person()
      |> PeopleSorter.add_person()
    end
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "verify empty list", %{conn: conn} do
      conn = get(conn, Routes.record_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
      delete_people_list()
    end
  end

  describe "create record" do
    test "renders record when data is valid", %{conn: conn} do
      conn = post(conn, Routes.record_path(conn, :create), person: @create_attrs)
      data = json_response(conn, 201)["data"]

      assert %{
               "date_of_birth" => "4/4/1946",
               "email" => "jade1918@schmeler.biz",
               "favorite_color" => "Black",
               "first_name" => "Antonio",
               "last_name" => "Krajcik"
             } == data

      delete_people_list()
    end

    test "renders errors when date_of_birth is invalid", %{conn: conn} do
      conn = post(conn, Routes.record_path(conn, :create), person: @invalid_attrs)
      assert json_response(conn, 422)["error"] == "unable to create person - bad data"
      delete_people_list()
    end

    test "renders errors when dob is bad", %{conn: conn} do
      conn = post(conn, Routes.record_path(conn, :create), person: @bad_dob_attrs)
      assert json_response(conn, 422)["error"] == "unable to create person - bad data"
    end

    test "renders errors when dob has alpha", %{conn: conn} do
      conn = post(conn, Routes.record_path(conn, :create), person: @alpha_dob_attrs)
      assert json_response(conn, 422)["error"] == "unable to create person - bad data"
    end

    test "renders errors when dob is missing", %{conn: conn} do
      conn = post(conn, Routes.record_path(conn, :create), person: @missing_dob_attrs)
      assert json_response(conn, 422)["error"] == "unable to create person - bad data"
    end
  end

  describe "show records" do
    test "returns records sorted by color and then last_name", %{conn: conn} do
      fixture(:persons)
      conn = get(conn, Routes.record_path(conn, :color))

      color_last_name_list =
        json_response(conn, 200)["data"]
        |> Enum.map(&Map.take(&1, ["favorite_color", "last_name"]))

      assert [
               %{"favorite_color" => "Black", "last_name" => "Bailey"},
               %{"favorite_color" => "Black", "last_name" => "Beatty"},
               %{"favorite_color" => "Black", "last_name" => "Krajcik"},
               %{"favorite_color" => "Blue", "last_name" => "Nitzsche"},
               %{"favorite_color" => "Brown", "last_name" => "Ferry"},
               %{"favorite_color" => "Brown", "last_name" => "Rolfson"},
               %{"favorite_color" => "Green", "last_name" => "Kozey"},
               %{"favorite_color" => "Pink", "last_name" => "Dickens"},
               %{"favorite_color" => "Pink", "last_name" => "Dietrich"},
               %{"favorite_color" => "Pink", "last_name" => "Rippin"},
               %{"favorite_color" => "Pink", "last_name" => "Rippin"}
             ] == color_last_name_list

      delete_people_list()
    end

    test "returns records sorted by last_name", %{conn: conn} do
      fixture(:persons)
      conn = get(conn, Routes.record_path(conn, :last_name))

      last_name_list =
        json_response(conn, 200)["data"]
        |> Enum.map(&Map.get(&1, "last_name"))

      assert [
               "Rolfson",
               "Rippin",
               "Rippin",
               "Nitzsche",
               "Krajcik",
               "Kozey",
               "Ferry",
               "Dietrich",
               "Dickens",
               "Beatty",
               "Bailey"
             ] == last_name_list

      delete_people_list()
    end

    test "returns records sorted by date_of_birth", %{conn: conn} do
      fixture(:persons)
      conn = get(conn, Routes.record_path(conn, :dob))

      dob_list =
        json_response(conn, 200)["data"]
        |> Enum.map(&Map.get(&1, "date_of_birth"))

      assert [
               "12/12/1929",
               "9/9/1932",
               "9/9/1945",
               "4/4/1946",
               "2/2/1950",
               "9/9/1953",
               "8/8/1982",
               "3/3/1986",
               "3/3/1986",
               "8/8/1990",
               "4/4/1991"
             ] == dob_list

      delete_people_list()
    end

    test "returns unsorted records, default for show", %{conn: conn} do
      fixture(:persons)
      conn = get(conn, Routes.record_path(conn, :show, "test"))

      list = json_response(conn, 200)["data"]

      assert [
               %{
                 "date_of_birth" => "9/9/1945",
                 "email" => "gerson2032@altenwerth.biz",
                 "favorite_color" => "Blue",
                 "first_name" => "Robert",
                 "last_name" => "Nitzsche"
               },
               %{
                 "date_of_birth" => "4/4/1991",
                 "email" => "sasha.oreilly@sawayn.net",
                 "favorite_color" => "Pink",
                 "first_name" => "Coleman",
                 "last_name" => "Dickens"
               },
               %{
                 "date_of_birth" => "12/12/1929",
                 "email" => "dorothea.huels@smith.net",
                 "favorite_color" => "Black",
                 "first_name" => "Nedra",
                 "last_name" => "Beatty"
               },
               %{
                 "date_of_birth" => "2/2/1950",
                 "email" => "ron.erdman@crist.info",
                 "favorite_color" => "Black",
                 "first_name" => "Ada",
                 "last_name" => "Bailey"
               },
               %{
                 "date_of_birth" => "4/4/1946",
                 "email" => "jade1918@schmeler.biz",
                 "favorite_color" => "Black",
                 "first_name" => "Antonio",
                 "last_name" => "Krajcik"
               },
               %{
                 "date_of_birth" => "8/8/1982",
                 "email" => "pearlie2031@ernser.biz",
                 "favorite_color" => "Brown",
                 "first_name" => "Russell",
                 "last_name" => "Ferry"
               },
               %{
                 "date_of_birth" => "9/9/1932",
                 "email" => "shaina2003@rutherford.info",
                 "favorite_color" => "Brown",
                 "first_name" => "Guido",
                 "last_name" => "Rolfson"
               },
               %{
                 "date_of_birth" => "8/8/1990",
                 "email" => "noemy2037@mante.biz",
                 "favorite_color" => "Green",
                 "first_name" => "Kenya",
                 "last_name" => "Kozey"
               },
               %{
                 "date_of_birth" => "3/3/1986",
                 "email" => "buford.braun@erdman.org",
                 "favorite_color" => "Pink",
                 "first_name" => "Annalise",
                 "last_name" => "Rippin"
               },
               %{
                 "date_of_birth" => "9/9/1953",
                 "email" => "oda2088@langosh.info",
                 "favorite_color" => "Pink",
                 "first_name" => "Cooper",
                 "last_name" => "Dietrich"
               },
               %{
                 "date_of_birth" => "3/3/1986",
                 "email" => "buford.braun@erdman.org",
                 "favorite_color" => "Pink",
                 "first_name" => "Annalise",
                 "last_name" => "Rippin"
               }
             ] == list

      delete_people_list()
    end
  end

  @doc """
  Send a message to the process to delete the people list
  """
  def delete_people_list() do
    get_people_list_pid()
    |> send({:empty_table, :normal})
  end

  @doc """
  get the pid for the PeopleList Process from the Supervisor
  """
  def get_people_list_pid() do
    PeopleSorter.Supervisor
    |> Supervisor.which_children()
    |> Enum.filter(fn child -> PeopleSorter.PeopleList == elem(child, 0) end)
    |> List.first()
    |> elem(1)
  end
end
