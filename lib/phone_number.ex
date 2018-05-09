defmodule PhoneNumber do
  @moduledoc """
  Library for validating international phone numbers. Based on Google's libphonenumber.
  """

  @doc """
  parse phone number

  ## Examples

      iex> phone = PhoneNumber.parse("381601234567")
      ...>
      iex> phone.valid
      true

  """
  @spec parse(String.t) :: %PhoneNumber.Phone{}
  def parse(phone) when is_binary(phone) do
    number = String.replace(phone, ~r/\D/, "")
    eligible_countries = Enum.filter(FastGlobal.get(:data), fn(country) ->
      String.starts_with?(number, country.country_code) &&
      !is_nil(
        Enum.find(
          country.validations,
          &(Regex.match?(&1, PhoneNumber.Phone.normalized_number(country, number)))
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
      original_number: number,
      valid: !is_nil(country),
      country: country
    }
  end
end
