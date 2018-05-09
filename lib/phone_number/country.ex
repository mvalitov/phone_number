defmodule PhoneNumber.Country do
  import SweetXml
  alias __MODULE__

  defstruct(id: nil, country_code: nil, national_prefix: nil, national_prefix_for_parsing: nil, national_prefix_transform_rule: nil, full_general_pattern: nil, mobile_token: nil, data: %{}, general_validation: nil, validations: [], main_country_for_code: false)

  @mobile_token_countries  %{ "AR" => "9" }

  def parse_file(path) do
    case File.read(path) do
      {:ok, body} ->
        body |> xpath(~x"//territories/territory"l)
        |> Enum.map(fn(territory) ->
          national_prefix_for_parsing = case xpath(territory, ~x"@nationalPrefixForParsing"s) |> String.replace("\n", "") |> String.replace(" ", "") do
            "" -> nil
            str -> Regex.compile!(str)
          end
          country = %Country{
            id: xpath(territory, ~x"@id"s),
            country_code: xpath(territory, ~x"@countryCode"s),
            national_prefix: xpath(territory, ~x"@nationalPrefix"s),
            national_prefix_transform_rule: xpath(territory, ~x"@nationalPrefixTransformRule"s),
            national_prefix_for_parsing: national_prefix_for_parsing,
            main_country_for_code: xpath(territory, ~x"@mainCountryForCode"s) == "true",
            general_validation: Regex.compile!(xpath(territory, ~x"./generalDesc/nationalNumberPattern/text()"s) |> String.replace("\n", "") |> String.replace(" ", "")),
            validations: parse_validations(territory)
          }
          %{country | mobile_token: @mobile_token_countries[country.id], full_general_pattern: Regex.compile!("^(#{country.country_code})?(#{country.national_prefix})?(?<national_num>#{country.general_validation.source})$")}
        end)
      {:error, reason} ->
        raise to_string(reason)
    end
  end

  defp parse_validations(data) do
    xpath(data, ~x"./*"l)
    |> Enum.map(fn(element) ->
      case elem(element, 1) do
        :references -> nil
        :availableFormats -> nil
        :generalDesc -> nil
        :areaCodeOptional -> nil
        _ ->
          xpath(element, ~x"./nationalNumberPattern/text()"ls)
          |> Enum.map(&(String.replace(&1, "\n", "") |> String.replace(" ", "")))
      end
    end)
    |> List.flatten()
    |> Enum.filter(&(!is_nil(&1)))
    |> Enum.map(fn(validation) ->
      case Regex.compile("^("<>validation<>")$") do
        {:ok, regex} ->
          regex
        {:error, _} ->
          nil
      end
    end)
    |> Enum.filter(&(!is_nil(&1)))
  end

end
