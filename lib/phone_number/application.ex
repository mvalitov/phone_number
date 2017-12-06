defmodule PhoneNumber.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    if !File.exists?(Mix.Tasks.PhoneNumber.LoadPhoneData.file_path()) do
      Mix.Tasks.PhoneNumber.LoadPhoneData.run()
    end
    
    FastGlobal.put(:data, read_file(Mix.Tasks.PhoneNumber.LoadPhoneData.file_path()) |> :erlang.binary_to_term())

    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: PhoneNumber.Worker.start_link(arg)
      # {PhoneNumber.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PhoneNumber.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp read_file(path) do
    File.read!(path)
  end
end
