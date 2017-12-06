defmodule PhoneNumber.Country do
  import SweetXml
  alias __MODULE__

  defstruct(id: nil, country_code: nil, data: %{}, validations: [], main_country_for_code: false)

  def parse_file(path) do
    case File.read(path) do
      {:ok, body} ->
        body |> xpath(~x"//territories/territory"l)
        |> Enum.map(fn(territory) ->
          %Country{
            id: xpath(territory, ~x"@id"s),
            country_code: xpath(territory, ~x"@countryCode"s),
            main_country_for_code: xpath(territory, ~x"@mainCountryForCode"s) == "true",
            validations: parse_validations(territory)
          }
        end)
      {:error, reason} ->
        raise reason
    end
  end

  defp parse_validations(data) do
    xpath(data, ~x"./*"l)
    |> Enum.map(fn(element) ->
      case elem(element, 1) do
        :generalDesc ->
          xpath(element, ~x"./*/text()"ls)
          |> Enum.map(&(String.replace(&1, "\n", "") |> String.replace(" ", "")))
        _ -> nil
      end
    end)
    |> List.flatten()
    |> Enum.filter(&(!is_nil(&1)))
    |> Enum.map(fn(validation) ->
      case Regex.compile(validation) do
        {:ok, regex} ->
          regex
        {:error, _} ->
          nil
      end
    end)
    |> Enum.filter(&(!is_nil(&1)))
  end

end
