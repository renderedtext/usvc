defmodule Mix.Tasks.New.Uservice do
  use Mix.Task

  @shortdoc "Create new minimal micro service"
  @credentials_url "s3://renderedtext-secrets/thrifter/env"

  def run(a) do
    IO.puts "args: #{inspect a}" 
    prj = Enum.at(a, 0)
    IO.puts("Creating projects: #{prj}")
    System.cmd("mix", ["new", prj, "--sup"])
    IO.inspect System.cmd("/bin/bash", ["-c", "cd #{prj}; git init"])
  end
end
