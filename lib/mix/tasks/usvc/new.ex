defmodule Mix.Tasks.Usvc.New do
  use Mix.Task

  alias NewUservice.Color
  alias NewUservice.Templates

  @shortdoc "Create new, working micro service"

  def run(args) do
    with  {:ok, prj} <- get_prj(args),
          {:ok, svc_type} <- get_svc_type(args),
          Mix.shell.info("\nCreating Elixir project #{Color.green(prj)}."),
          {_, 0} <- create_ex_prj(prj),
          :ok <- render_templates(prj, svc_type),
          Mix.shell.info("\nSetting-up git."),
          {:ok, _} <- git_setup(prj)
    do
      Mix.shell.info "\nCreated micro-service #{Color.green(prj)} based on #{Color.green(svc_type)} templates.\n"
    else error ->
      error |> inspect() |> IO.puts()
    end
  end

  def get_prj(args) do
    Enum.at(args, 0)
    |> case do
      nil -> {:error, "Project name not specified!"}
      name -> {:ok, name}
    end
  end

  def get_svc_type(args) do
    args
    |> Enum.find_index(fn it -> it == "--type" end)
    |> get_svc_type_(args)
  end

  def get_svc_type_(nil, _args), do: {:ok, :default}
  def get_svc_type_(index, args) do
    Enum.at(args, index+1)
    |> case do
      nil -> {:error, "Missing service type!"}
      type -> {:ok, type |> String.to_atom()}
    end
  end

  def create_ex_prj(prj) do
    if File.dir?(prj) do
      {"Directory #{prj} already exists", 1}
    else
      System.cmd("mix", ["new", prj, "--sup"])
    end
  end

  def git_setup(prj) do
    with  {_, 0} <- System.cmd("/bin/bash", ["-c", "cd #{prj}; git init"]),
          ({_, 0} <- System.cmd("/bin/bash", ["-c", "cd #{prj}; git add ."])),
          {_, 0} <- System.cmd("/bin/bash", ["-c", "cd #{prj}; git commit -m \"initial\""])
    do
      {:ok, ""}
    end
  end

  defp render_templates(prj, svc_type) do
    template_paths = Templates.template_files_for(svc_type)
    output_paths   = output_file_paths(template_paths, prj, svc_type)
    template_variables = template_variables(prj)
    Templates.render(template_paths, output_paths, template_variables)
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
