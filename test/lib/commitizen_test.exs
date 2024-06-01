defmodule CommitizenTest do
  use ExUnit.Case

  test "groups commits" do
    commits = [
      "fix: i fix something",
      "feat: i add a feature",
      "BREAKING CHANGE: i break something",
      "not noteworthy"
    ]

    assert %{all: [_, _, _], patch: [_], feature: [_], breaking: [_]} = Expublish.Commitizen.run(commits)
  end
end
