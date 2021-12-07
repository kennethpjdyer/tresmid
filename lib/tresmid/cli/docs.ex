defmodule Tresmid.CLI.Docs do
  @moduledoc false

  ####################### CONFIGURE OPTIONS ##############################
  def format_opt({short, long, var, help}) do
    "-#{short} #{var}, --#{long} #{var}\n #{help}"
  end
  def format_opt({short, long, help}) do
    "-#{short}, --#{long}\n #{help}"
  end


  def opts do
    Tresmid.CLI.Options.docs
    |> Enum.map(
      fn x -> format_opt(x) end
    )
    |> Enum.join("\n")
  end

  def opts_web do
    Tresmid.CLI.Options.docs
    |> Enum.map(
      fn x -> x end
    )
  end

  def usage do
    [
      "Options:",
      opts
    ]
    |> Enum.join("\n")
    |> IO.puts
  end
end
