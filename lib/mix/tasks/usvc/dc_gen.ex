defmodule Mix.Tasks.Usvc.DcGen do
  use Mix.Task

  @shortdoc "Generate docker-compose.yml"
  @docker_compose_template "docker-compose.yml.eex"
  @git_hash_cmd "git log --format=format:'%h' -1"

  def run(args) do
    with  {git_hash, 0} <- System.cmd("/bin/bash", ["-c", @git_hash_cmd]),
          git_hash = args |> Enum.at(0, git_hash)
    do
      run_(git_hash)
    else error ->
      raise "git error: #{error}"
    end
  end

  defp run_(git_hash) do
    Mix.shell.info "Generating docker-compose.yml with tag '#{git_hash}'"

    EEx.eval_file(@docker_compose_template, [git_hash: git_hash])
    |> write_docker_compose()
  end

  defp write_docker_compose(rendered) do
    String.replace_suffix(@docker_compose_template, ".eex", "")
    |> File.write!(rendered)
  end
end
