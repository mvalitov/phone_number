defmodule PhoneNumber.Phone do
  alias __MODULE__

  defstruct(original_number: nil, number: nil, valid: false, country: nil)

  def e164_number(%Phone{valid: true} = phone) do
    n = Regex.run(List.first(phone.country.validations), phone.original_number)
    |> List.first()
    {:ok, "+#{phone.country.country_code}#{n}"}
  end

  def e164_number(_), do: {:error, "Phone not valid"}
end
