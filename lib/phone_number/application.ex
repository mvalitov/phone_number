defmodule PhoneNumber.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    if !File.exists?(Mix.Tasks.PhoneNumber.LoadPhoneData.file_path()) do
      Mix.Tasks.PhoneNumber.LoadPhoneData.run()
    end

    FastGlobal.put(
      :data,
      read_file(Mix.Tasks.PhoneNumber.LoadPhoneData.file_path()) |> :erlang.binary_to_term()
    )

    children = []

    opts = [strategy: :one_for_one, name: PhoneNumber.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp read_file(path) do
    File.read!(path)
  end
end
