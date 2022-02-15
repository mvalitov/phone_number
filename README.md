# PhoneNumber

Library for validating international phone numbers. Based on Google's libphonenumber.

## Installation

Add `phone_number` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:phone_number, "~> 0.2.4"}
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

ex(2)> PhoneNumber.parse("381601234567", "RS")
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

iex(3)> PhoneNumber.valid?("381601234567", "RS")
{:ok,
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
 }}
iex(4)> PhoneNumber.valid?("481601234567", "RS")
{:ok, nil}

iex(5)> PhoneNumber.possible_countries("381601234567")
[
  %PhoneNumber.Phone{
    country: %PhoneNumber.Country{
      country_code: "49",
      data: %{},
      full_general_pattern: ~r/^(49)?(0)?(?<national_num>[1-35-9]\d{3,14}|4(?:[0-8]\d{3,12}|9(?:[0-37]\d|4(?:[1-35-8]|4\d?)|5\d{1,2}|6[1-8]\d?)\d{2,8}))$/,
      general_validation: ~r/[1-35-9]\d{3,14}|4(?:[0-8]\d{3,12}|9(?:[0-37]\d|4(?:[1-35-8]|4\d?)|5\d{1,2}|6[1-8]\d?)\d{2,8})/,
      id: "DE",
      main_country_for_code: false,
      mobile_token: nil,
      national_prefix: "0",
      national_prefix_for_parsing: nil,
      national_prefix_transform_rule: "",
      validations: [~r/^(2\d{5,13}|3(?:0\d{3,13}|2\d{9}|[3-9]\d{4,13})|4(?:0\d{3,12}|[1-8]\d{4,12}|9(?:[0-37]\d|4(?:[1-35-8]|4\d?)|5\d{1,2}|6[1-8]\d?)\d{2,8})|5(?:0[2-8]|[1256]\d|[38][0-8]|4\d{0,2}|[79][0-7])\d{3,11}|6(?:\d{5,13}|9\d{3,12})|7(?:0[2-8]|[1-9]\d)\d{3,10}|8(?:0[2-9]|[1-8]\d|9\d?)\d{3,10}|9(?:0[6-9]\d{3,10}|1\d{4,12}|[2-9]\d{4,11}))$/,
       ~r/^(1(?:5[0-25-9]\d{8}|6[023]\d{7,8}|7\d{8,9}))$/,
       ~r/^(16(?:4\d{1,10}|[89]\d{1,11}))$/, ~r/^(800\d{7,12})$/,
       ~r/^(137[7-9]\d{6}|900(?:[135]\d{6}|9\d{7}))$/,
       ~r/^(1(?:3(?:7[1-6]\d{6}|8\d{4})|80\d{5,11}))$/, ~r/^(700\d{8})$/,
       ~r/^(18(?:1\d{5,11}|[2-9]\d{8}))$/,
       ~r/^(1(?:5(?:(?:2\d55|7\d99|9\d33)\d{7}|(?:[034568]00|113)\d{8})|6(?:013|255|399)\d{7,8}|7(?:[015]13|[234]55|[69]33|[78]99)\d{7,8}))$/]
    },
    original_number: "381601234567",
    valid: true
  },
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
]
```

On startup, the library loads the file `data/telephone_number_data.dat`.

If the file is not found, then the file `data/telephone_number_data.xml` is processed, which contains patterns for parsing the phone. 

If you updated `telephone_number_data.xls`, you must delete the `data/telephone_number_data.dat` file, or run the `mix phone_number.load_phone_data` task
