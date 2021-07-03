defmodule PeopleSorter.CLITest do
  use ExUnit.Case, async: true

  test "valid sort_by's" do
    assert PeopleSorter.CLI.validate_sort_by("dob") == :ok
    assert PeopleSorter.CLI.validate_sort_by("last_name") == :ok
    assert PeopleSorter.CLI.validate_sort_by("color") == :ok
  end

  test "invalid sort_by" do
    assert PeopleSorter.CLI.validate_sort_by("dobx") == :sort_by_error
  end

  test "valid filenames" do
    assert PeopleSorter.CLI.validate_filenames(["test.txt", "test"]) == :ok
  end

  test "invalid filenames" do
    assert PeopleSorter.CLI.validate_filenames([]) == :missing_filename_error
  end
end
