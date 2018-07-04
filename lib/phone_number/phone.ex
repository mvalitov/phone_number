defmodule PhoneNumber.Phone do
  alias __MODULE__
  # require IEx

  defstruct(original_number: nil, valid: false, country: nil)

  def e164_number(%Phone{valid: true} = phone) do
    {:ok, "+#{phone.country.country_code}#{normalized_number(phone.country, phone.original_number)}"}
  end

  def e164_number(_), do: {:error, "Phone not valid"}

  def normalized_number(country, number) do
    match_result = Regex.named_captures(country.full_general_pattern, parse_prefix(country, number))
    case match_result["national_num"] do
      nil -> number
      num -> num
    end
  end

  defp parse_prefix(country, number) do
    cond do
      is_nil(country.national_prefix_for_parsing) ->
        number
      true ->
        match_object = Regex.run(country.national_prefix_for_parsing, number)
        captures = Regex.scan(country.national_prefix_for_parsing, number, capture: :all_but_first)
        |> List.flatten
        cond do
          is_nil(match_object) || !String.starts_with?(number, List.first(match_object)) ->
            number
          country.national_prefix_transform_rule ->
            transform_national_prefix(country, number, match_object, captures)
          true ->
            String.replace(number, match_object, "")
        end
    end
  end

  defp transform_national_prefix(country, number, match_object, captures) do
    cond do
      country.mobile_token && length(captures) > 0 ->
        :io.format(build_format_string(country), String.replace(number, Enum.at(match_object, 0), Enum.at(match_object, 1)))
      length(captures) == 0 ->
        # for elixir 1.5
        case Enum.at(match_object, 0) do
          "" -> number
          pattern -> String.replace(number, pattern, "")
        end
      true -> :io.format(build_format_string(country), captures)
    end
  end

  defp build_format_string(country) do
    Regex.replace(country.national_prefix_transform_rule, ~r/(\$\d)/, fn _, x -> "%"<>String.reverse(x)<>"s" end)
  end
end
