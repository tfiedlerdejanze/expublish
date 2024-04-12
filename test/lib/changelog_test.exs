defmodule ChangelogTest do
  use ExUnit.Case

  import Expublish.TestHelper
  import ExUnit.CaptureLog

  alias Expublish.Changelog
  alias Expublish.Options

  doctest Expublish

  @version Version.parse!("1.0.1")
  @rm_release_file "test/files/remove_release_file_test.md"

  setup do
    [options: Options.parse(["--dry-run"]), version: @version]
  end

  test "validate/1 validates the release file exists", %{options: options} do
    with_release_md(fn ->
      assert :ok == Changelog.validate(options)
    end)
  end

  test "remove_release_file!/3 deletes the file", %{version: version} do
    File.write!(@rm_release_file, "generated in test")

    assert version == Changelog.remove_release_file!(version, %Options{}, @rm_release_file)

    refute File.exists?(@rm_release_file)
  end

  test "write_entry!/1 logs info message", %{options: options, version: version} do
    fun = fn ->
      with_release_md(fn ->
        Changelog.write_entry!(version, options)
      end)
    end

    assert capture_log(fun) =~ "Skipping new entry"
  end

  test "build_title/3 runs without errors", %{version: version} do
    assert Changelog.build_title(version) =~ ~r/#{version} - \d{4}-\d{2}-\d{2}/
  end

  test "build_title/3 formats datetime to ISO 8601 date by default", %{options: options, version: version} do
    naive_datetime = NaiveDateTime.utc_now()

    title = Changelog.build_title(version, options, naive_datetime)

    assert title == "## #{version} - #{NaiveDateTime.to_date(naive_datetime)}"
  end

  test "build_title/3 may format datetime to ISO 8601 date-time", %{version: version} do
    naive_datetime = NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)

    date_format = NaiveDateTime.to_date(naive_datetime)
    time_format = NaiveDateTime.to_time(naive_datetime)

    title = Changelog.build_title(version, %Options{changelog_date_time: true}, naive_datetime)

    assert title == "## #{version} - #{date_format} #{time_format}"
  end

  test "with_new_entry/1 adds a new changelog entry from RELEASE.md", %{version: version} do
    with_release_md(fn ->
      release_text = File.read!("RELEASE.md")
      assert Changelog.with_new_entry("#{version}", release_text) =~ "#{version}"
      assert Changelog.with_new_entry("#{version}", release_text) =~ release_text
    end)
  end
end
