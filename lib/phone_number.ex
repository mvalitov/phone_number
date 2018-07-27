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

  def parse(phone, country) when is_binary(phone) and is_binary(country) do
    number = String.replace(phone, ~r/\D/, "")
    case valid?(number, country) do
      {:ok, %PhoneNumber.Phone{} = p} -> p
      {:ok, nil} -> %PhoneNumber.Phone{
	original_number: number,
	valid: false,
	country: nil
      }
      {:error, reason} -> {:error, reason}
    end 
  end

  def possible_countries(phone) when is_binary(phone) do
     number = String.replace(phone, ~r/\D/, "")
    Enum.map(FastGlobal.get(:data), fn c -> 
      case validate(number, c) do
        {:ok, %PhoneNumber.Phone{} = p} -> p
        {:ok, nil} -> nil
      end
    end)
    |> Enum.filter(&(!is_nil(&1)))
  end

  def valid?(phone, country) when is_binary(phone) and is_binary(country) do
    case Enum.find(FastGlobal.get(:data), &(&1.id == country)) do
      nil -> {:error, "country with id #{country} not found"}
      c -> validate(phone, c)
    end
  end

  defp validate(phone, %PhoneNumber.Country{} = country) do
    case Enum.any?(country.validations, &(Regex.match?(&1, PhoneNumber.Phone.normalized_number(country, phone)))) do
      true -> 
        {
          :ok, 
          %PhoneNumber.Phone{
            original_number: phone,
            valid: true,
            country: country
          }
        }
      false ->
        {:ok, nil}
    end
  end
end
