defmodule Mix.Tasks.Usvc.New do
  use Mix.Task

  alias NewUservice.Colors
  alias NewUservice.Templates

  @shortdoc "Create new minimal micro service"
  # @credentials_url "s3://renderedtext-secrets/thrifter/env"

  # def run(a) do
  #   IO.puts "args: #{inspect a}"
  #   prj = Enum.at(a, 0)
  #   IO.puts("Creating projects: #{prj}")
  #   System.cmd("mix", ["new", prj, "--sup"])
  #   IO.inspect System.cmd("/bin/bash", ["-c", "cd #{prj}; git init"])
  # end

  def run(args) do
    prj = Enum.at(args, 0)
    svc_type = :default

    Mix.shell.info ""
    Mix.shell.info "Generating uservice #{prj}, type: #{svc_type}"
    Mix.shell.info "------------------------"

    create_ex_prj(prj)

    # Thrift.generate(output: thrift_output_dir, language: "erl")
    _output_paths = generate_elixir_files(prj, svc_type)

    git_setup(prj)
    Mix.shell.info "\nElixir client generated in #{Colors.green(prj)}\n"

    # output_paths ++ [thrift_output_dir]
    # |> GitRepo.create_package(package_name, client_dir, version)
  end

  def create_ex_prj(prj) do
    File.dir?(prj) |> if do throw "Directory #{prj} already exists" end
    System.cmd("mix", ["new", prj, "--sup"])
  end

  def git_setup(prj) do
    IO.inspect System.cmd("/bin/bash", ["-c", "cd #{prj}; git init"])
    IO.inspect System.cmd("/bin/bash", ["-c", "cd #{prj}; git add ."])
    IO.inspect System.cmd("/bin/bash", ["-c", "cd #{prj}; git commit -m \"initial\""])
  end

  defp generate_elixir_files(prj, svc_type) do
    template_paths = Templates.template_files_for(svc_type)
    |> IO.inspect(label: "template_paths")
    output_paths   = output_file_paths(template_paths, prj, svc_type)
    |> IO.inspect(label: "output_paths")
    template_variables = template_variables(prj)
    |> IO.inspect(label: "template_variables")
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
