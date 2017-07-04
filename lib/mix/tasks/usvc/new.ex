defmodule Mix.Tasks.Usvc.New do
  use Mix.Task

  alias NewUservice.Colors
  alias NewUservice.Templates

  @shortdoc "Create new, working micro service"

  def run(args) do
    prj = Enum.at(args, 0)
      svc_type = :default

      Mix.shell.info "\nCreating Elixir project #{Colors.green(prj)}."
      create_ex_prj(prj)

      _output_paths = render_templates(prj, svc_type)

      Mix.shell.info "\nSetting-up git."
      git_setup(prj)
      Mix.shell.info "\nCreated micro-service #{Colors.green(prj)} based on #{Colors.green(svc_type)} templates.\n"
  end

  def create_ex_prj(_prj=nil), do: throw "Project name not specified!"
  def create_ex_prj(prj) do
    File.dir?(prj) |> if do throw "Directory #{prj} already exists" end
    System.cmd("mix", ["new", prj, "--sup"])
  end

  def git_setup(prj) do
    with  {_, 0} <- System.cmd("/bin/bash", ["-c", "cd #{prj}; git init"]),
          ({_, 0} <- System.cmd("/bin/bash", ["-c", "cd #{prj}; git add ."])),
          {_, 0} <- System.cmd("/bin/bash", ["-c", "cd #{prj}; git commit -m \"initial\""])
    do
    else error ->
      throw "#{inspect error}"
    end
  end

  defp render_templates(prj, svc_type) do
    template_paths = Templates.template_files_for(svc_type)
    output_paths   = output_file_paths(template_paths, prj, svc_type)
    template_variables = template_variables(prj)
    Templates.render(template_paths, output_paths, template_variables)

    output_paths
  end

  defp template_variables(prj) do
    [
      prj: prj,
      prj_atom: prj |> eex_atom(),
      prj_module_name: Macro.camelize(prj),
      git_hash_placeholder: "<%= git_hash %>"
    ]
  end

  defp eex_atom(string), do: string |> String.to_atom |> inspect

  def output_file_paths(template_file_paths, prj, svc_type) do
    template_file_paths
    |> Enum.map(&String.replace(&1, Templates.templates_dir(svc_type), prj))
    |> Enum.map(&String.replace_suffix(&1, ".eex", ""))
    |> Enum.map(&String.replace(&1, "prj", prj))
  end

  # defp package_name do (client_name |> String.replace("_", "-")) end
end
