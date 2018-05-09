# PhoneNumber

Library for validating international phone numbers. Based on Google's libphonenumber.

## Installation

Add `phone_number` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:phone_number, "~> 0.2.0"}
  ]
end
```

To update to version `0.2.0`, you must delete the `telephone_number_data.dat` file.

Documentation [HexDocs](https://hexdocs.pm/phone_number)

## Usage

Parse phone:

```elixir
iex> p = PhoneNumber.parse("381601234567")
%PhoneNumber.Phone{
  country: %PhoneNumber.Country{
    country_code: "381",
    data: %{},
    full_general_pattern: ~r/^(381)?(0)?(?<national_num>[126-9]\d{4,11}|3(?:[0-79]\d{3,10}|8[2-9]\d{2,9}))$/,
    general_validation: ~r/[126-9]\d{4,11}|3(?:[0-79]\d{3,10}|8[2-9]\d{2,9})/,
    id: "RS",
    main_country_for_code: false,
    mobile_token: nil,
    national_prefix: "0",
    national_prefix_for_parsing: nil,
    national_prefix_transform_rule: "",
    validations: [~r/^((?:1(?:[02-9][2-9]|1[1-9])\d|2(?:[0-24-7][2-9]\d|[389](?:0[2-9]|[2-9]\d))|3(?:[0-8][2-9]\d|9(?:[2-9]\d|0[2-9])))\d{3,8})$/,
     ~r/^(6(?:[0-689]|7\d)\d{6,7})$/, ~r/^(800\d{3,9})$/,
     ~r/^((?:90[0169]|78\d)\d{3,7})$/, ~r/^(7[06]\d{4,10})$/]
  },
  original_number: "381601234567",
  valid: true
}

iex> PhoneNumber.Phone.e164_number(p)
{:ok, "+38181601234567"}
```

On startup, the library loads the file `data/telephone_number_data.dat`.

If the file is not found, then the file `data/telephone_number_data.xml` is processed, which contains patterns for parsing the phone. 

If you updated `telephone_number_data.xls`, you must delete the `data/telephone_number_data.dat` file, or run the `mix phone_number.load_phone_data` task