# PhoneNumber

Library for validating international phone numbers. Based on Google's libphonenumber.

## Installation

Add `phone_number` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:phone_number, "~> 0.1.1"}
  ]
end
```

Documentation [HexDocs](https://hexdocs.pm/phone_number)

## Usage

Parse phone:

```elixir
iex> p = PhoneNumber.parse("381601234567")
%PhoneNumber.Phone{country: %PhoneNumber.Country{country_code: "381", data: %{},
  id: "RS", main_country_for_code: false,
  validations: [~r/[126-9]\d{4,11}|3(?:[0-79]\d{3,10}|8[2-9]\d{2,9})/]},
  number: "381601234567", original_number: "381601234567", valid: true}

iex> PhoneNumber.Phone.e164_number(p)
{:ok, "+38181601234567"}
```

On startup, the library loads the file `data/telephone_number_data.dat`.

If the file is not found, then the file `data/telephone_number_data.xml` is processed, which contains patterns for parsing the phone. 

If you updated `telephone_number_data.xls`, you must delete the `data/telephone_number_data.dat` file, or run the `mix phone_number.load_phone_data` task