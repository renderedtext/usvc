defmodule Mix.Tasks.Usvc.New.Test do
  use ExUnit.Case

  # @prj "test_new_prj"
  @prj "test_new"

  setup_all do
    File.rm_rf!(@prj)
    Mix.Tasks.Usvc.New.run([@prj])
    :ok
  end

  test "usvc.new creates new project dir" do
    assert Map.get(File.stat!(@prj), :type) == :directory
  end


  test "usvc.new creates empty mix.lock" do
    mix_lock = File.read!("#{@prj}/mix.lock")
    assert mix_lock == ""
  end
end
