defmodule PeopleSorterWeb.RecordControllerTest do
  use PeopleSorterWeb.ConnCase

  @create_attrs %{
    date_of_birth: ~D[2016-05-24],
    email: "markjstang@gmail.com",
    favorite_color: "red",
    first_name: "mark",
    last_name: "stang"
  }

  # @invalid_attrs %{date_of_birth: nil, email: nil, favorite_color: nil, first_name: nil, last_name: nil}

  def fixture(:person) do
    %{
      date_of_birth: ~D[2016-05-24],
      email: "markjstang@gmail.com",
      favorite_color: "red",
      first_name: "mark",
      last_name: "stang"
    }

    # {:ok, record} = Records.create_record(@create_attrs)
    # record
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    @tag focus: true
    test "lists all records", %{conn: conn} do
      conn = get(conn, Routes.record_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create record" do
    test "renders record when data is valid", %{conn: conn} do
      conn = post(conn, Routes.record_path(conn, :create), person: @create_attrs)
      assert %{"email" => email} = json_response(conn, 201)["data"]

      # conn = get(conn, Routes.record_path(conn, :show, email))

      #   assert %{
      #            "id" => id,
      #            "date_of_birth" => "2010-04-17",
      #            "email" => "some email",
      #            "favorite_color" => "some favorite_color",
      #            "first_name" => "some first_name",
      #            "last_name" => "some last_name"
      #          } = json_response(conn, 200)["data"]
    end

    # test "renders errors when data is invalid", %{conn: conn} do
    #   conn = post(conn, Routes.record_path(conn, :create), record: @invalid_attrs)
    #   assert json_response(conn, 422)["errors"] != %{}
    # end
  end

  defp create_record(_) do
    person = fixture(:person)
    %{person: person}
  end
end
