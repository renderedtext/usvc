defmodule Mix.Tasks.Usvc.CfgGen do
  use Mix.Task

  alias Usvc.Templates

  @shortdoc "Generate configs dependent on git hash"
  @templates ["deploy.yml.eex"]
  @git_hash_cmd "git log --format=format:'%h' -1"

  def run(args) do
    with  {git_hash, 0} <- System.cmd("/bin/bash", ["-c", @git_hash_cmd]),
          tag = args |> Enum.at(0, git_hash)
    do
      run_(tag)
    else error ->
      raise "git error: #{error}"
    end
  end

  defp run_(tag) do
    output_paths = Enum.map(@templates, &String.replace_suffix(&1, ".eex", ""))
    template_variables = [image_tag: tag]
    Templates.render(@templates, output_paths, template_variables)
  end

end
