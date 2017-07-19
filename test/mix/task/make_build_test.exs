defmodule Mix.Tasks.Usvc.Make.Build.Test do
  use ExUnit.Case

  @prj "test_make_build"
  @prj_module_name Macro.camelize(@prj)

  setup_all do
    File.rm_rf!(@prj)
    Mix.Tasks.Usvc.New.run([@prj])
    IO.puts("Compiling...")
    {_, 0} = System.cmd("make", ["image.build"], [cd: @prj])
    :ok
  end

  test "usvc.new creates appropriate app field in mix.exs" do
    args =
      "run -t renderedtext/#{@prj}:latest mix run -e IO.inspect(#{@prj_module_name}.Mixfile.project)"
      |> String.split()
    {mix_project_, ecode} = System.cmd("docker", args, [cd: @prj])
    assert ecode == 0
    mix_project = Code.eval_string(mix_project_) |> elem(0)
    assert Keyword.get(mix_project, :app) == String.to_atom(@prj)
  end
end
