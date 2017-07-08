defmodule Usvc.Templates do
  require EEx

  alias Usvc.Color
  alias Usvc.Directory

  @templates_dir "templates"

  def template_files_for(type) do
    type |> templates_dir() |> Directory.ls_r()
  end

  def templates_dir(type), do:
    [:code.priv_dir(:usvc), @templates_dir, type |> Atom.to_string]
    |> Path.join

  def render(templates_paths, output_paths, template_variables) do
    Mix.shell.info "\nRendering templates:"

    Enum.zip(templates_paths, output_paths)
    |> Enum.each(fn {template, output} ->
      render_one_template(template, output, template_variables)
    end)
  end

  defp render_one_template(template, output, template_variables) do
    Mix.shell.info " - #{Color.green(template)}"

    Path.dirname(output) |> File.mkdir_p!

    EEx.eval_file(template, template_variables)
    |> write!(output)
  end

  defp write!(rendered, output), do: File.write!(output, rendered)
end
