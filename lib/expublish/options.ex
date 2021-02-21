defmodule Expublish.Options do
  def parse(args) do
    {options, _, _} =
      OptionParser.parse(args,
        aliases: [
          b: :branch,
          d: :dry_run,
          h: :help,
          r: :remote,
          p: :skip_publish,
          u: :skip_push,
          t: :skip_test
        ],
        strict: [
          branch: :string,
          dry_run: :boolean,
          help: :boolean,
          remote: :string,
          skip_publish: :boolean,
          skip_push: :boolean,
          skip_test: :boolean
        ]
      )

    if (print_help?(options)) do
      print_help()
      exit(:shutdown)
    end

    options
  end

  def print_help?(options), do: Keyword.get(options, :help, false)
  def dry_run?(options), do: Keyword.get(options, :dry_run, false)
  def skip_tests?(options), do: Keyword.get(options, :skip_test, false)
  def skip_push?(options), do: Keyword.get(options, :skip_push, false)
  def skip_publish?(options), do: Keyword.get(options, :skip_publish, false)

  def print_help() do
    IO.puts(~S"""
    Usage: mix publish.[level] [--dry-run | -d] [--skip-push]

    Levels:
      major   - Publish major version
      minor   - Publish minor version
      patch   - Publish patch version

    Flags:
      -d, --dry-run           - Perform dry run (no writes, no commits)
      -u, --skip-push         - Disable git push
      -p, --skip-publish      - Disable hex publish
      -t, --skip-test         - Disable test run
      -r, --branch            - Remote branch to push to, default: "master"
      -b, --remote            - Remote name to push to, default: "origin"
      -h, --help              - Print this help
    """)
  end
end
