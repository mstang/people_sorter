defmodule PeopleSorter.CLI do
  def main(args \\ []) do
    IO.puts("Welcome to the People Sorter Program")

    with {sort_by, filenames} <- parse_args(args),
         :ok <- validate_sort_by(sort_by),
         :ok <- validate_filenames(filenames) do
      create_response(sort_by, filenames)
      |> IO.puts()
    else
      :sort_by_error ->
        IO.puts("--sort-by is required and must be either color, dob or last_name")

      :missing_filename_error ->
        IO.puts("At least one filename is required")
    end
  end

  defp parse_args(command_line_args) do
    {parsed, filenames, _invalid} =
      OptionParser.parse(command_line_args, strict: [sort_by: :string])
      |> IO.inspect(label: :parse_args)

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
  Validate that we have at least one filename
  """
  def validate_filenames([]) do
    :missing_filename_error
  end

  def validate_filenames(_) do
    :ok
  end

  def create_response(sort_by, filenames) do
    IO.inspect(filenames, label: :filenames)
    IO.inspect(sort_by, label: :sort_by)
  end
end
