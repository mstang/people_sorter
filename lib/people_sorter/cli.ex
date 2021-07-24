defmodule PeopleSorter.CLI do
  @moduledoc """
  This is the command line interface to People Sorter
  """
  @doc """
  Main entry point for the cli process
  """
  def main(args \\ []) do
    IO.puts("Welcome to the People Sorter Program")

    with {sort_by, filenames} <- parse_args(args),
         :ok <- validate_sort_by(sort_by),
         :ok <- validate_filenames(filenames) do
      load_files(filenames)
      print_response(sort_by)
    else
      :sort_by_error ->
        IO.puts("--sort-by is required and must be either color, dob or last_name")

      :missing_filename_error ->
        IO.puts("At least one filename is required")
    end
  end

  @doc """
  parse the command-line arguments
  """
  def parse_args(command_line_args) do
    {parsed, filenames, _invalid} =
      OptionParser.parse(command_line_args, strict: [sort_by: :string])

    sort_by = parsed[:sort_by]
    {sort_by, filenames}
  end

  @doc """
  Validate that a correct sort_by was provided
  """
  def validate_sort_by(sort_by) when sort_by in ["dob", "color", "last_name"] do
    :ok
  end

  def validate_sort_by(_) do
    :sort_by_error
  end

  @doc """
  Validate that we have at least one filename was provided
  """
  def validate_filenames([]) do
    :missing_filename_error
  end

  def validate_filenames(_) do
    :ok
  end

  @doc """
  load_files - load each individual file
  """
  def load_files(filenames) do
    for filename <- filenames do
      PeopleSorter.FileLoader.load_file(filename)
    end
  end

  @doc """
  Print out the list of the file(s) that were processed
  """
  def print_response(sort_by) do
    sorted_list =
      case sort_by do
        "dob" -> PeopleSorter.get_list_sorted_by_dob()
        "last_name" -> PeopleSorter.get_list_sorted_by_last_name()
        "color" -> PeopleSorter.get_list_sorted_by_color_last_name()
      end

    for person <- sorted_list do
      person
      |> to_string
      |> IO.puts()
    end
  end
end
