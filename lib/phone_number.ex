defmodule PhoneNumber do
  @moduledoc """
  Library for parsing phone numbers
  """

  @doc """
  parse phone number

  ## Examples

      iex> PhoneNumber.parse("381601234567")
      %PhoneNumber.Phone{country: %PhoneNumber.Country{country_code: "381", data: %{},
        id: "RS", main_country_for_code: false,
        validations: [~r/[126-9]\d{4,11}|3(?:[0-79]\d{3,10}|8[2-9]\d{2,9})/]},
       number: "381601234567", original_number: "381601234567", valid: true}

  """
  @spec parse(String.t) :: %PhoneNumber.Phone{}
  def parse(phone) when is_binary(phone) do
    number = String.replace(phone, ~r/\D/, "")
    eligible_countries = Enum.filter(FastGlobal.get(:data), fn(country) ->
      String.starts_with?(number, country.country_code) &&
      !is_nil(
        Enum.find(
          country.validations,
          &(Regex.match?(&1, number))
        )
      )
    end)
    country = cond do
      length(eligible_countries) == 1 ->
        List.first(eligible_countries)
      length(eligible_countries) == 0 ->
        nil
      true ->
        main_country = Enum.find(eligible_countries, &(&1.main_country_for_code))
        case main_country do
          nil ->
            List.first(eligible_countries)
          %PhoneNumber.Country{} ->
            main_country
        end
    end
    %PhoneNumber.Phone{
      original_number: phone,
      number: number,
      valid: !is_nil(country),
      country: country
    }
  end
end
