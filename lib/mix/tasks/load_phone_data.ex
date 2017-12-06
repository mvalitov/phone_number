defmodule Mix.Tasks.PhoneNumber.LoadPhoneData do
  use Mix.Task
  @shortdoc "Load phone data from xls file"
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
    [ __DIR__, "../../../data/telephone_number_data_file.dat" ]
    |> Path.join()
    |> Path.expand()
  end

  def xml_file_path() do
    [ __DIR__, "../../../data/telephone_number_data_file.xml" ]
    |> Path.join()
    |> Path.expand()
  end

end
