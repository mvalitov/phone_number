defmodule Mix.Tasks.PhoneNumber.LoadPhoneData do
  use Mix.Task
  @shortdoc "Load phone data from xls file"
  @files_path  Application.get_env(:phone_number, :files_path)
  def run(path) do
    PhoneNumber.Country.parse_file(path)
    |> write_file(file_path())
  end

  def run() do
    PhoneNumber.Country.parse_file(xml_file_path())
    |> write_file(file_path())
  end

  defp write_file(data, path) do
    File.write!(path, :erlang.term_to_binary(data))
  end

  def file_path() do
    base_dir()
    |> Path.join("telephone_number_data_file.dat")
  end

  def xml_file_path() do
    base_dir()
    |> Path.join("telephone_number_data_file.xml")
  end

  defp base_dir() do
    Application.app_dir(:phone_number)
    |> Kernel.<>(@files_path)
  end

end
