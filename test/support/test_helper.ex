defmodule Expublish.TestHelper do
  @moduledoc false

  def with_release_md(fun) do
    if File.exists?("RELEASE.md") do
      fun.()
    else
      File.write!("RELEASE.md", "generated by expublish test")
      fun.()
      File.rm!("RELEASE.md")
    end
  end
end
