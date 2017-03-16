# Challenge: Write Template a Parser

This is my solution to a template parsing challenge. I implemented the core of the parsing/interpolation logic using regular expressions with capture groups and back references. The main `parse` method then iteratively substitutes environment values and captured matches until there are no captures.

The parser supports plain variables, `if` and `unless` type logic, as well as nested captures. The parser may be instantiated once with an environment and it can parse multiple templates with that environment. It will always operate on and return a copy of the template.

## Description
Given a template and an environment, fill the template with correct values.

```ruby
# template is a string.
# environment is a dictionary that specifies the variables.
def parse(template, environment)
  # ...code...
end
```

## Running Specs

  1. Clone the repo:

```bash
git clone git@github.com:DiegoSalazar/template_parsing_challenge.git
cd template_parsing_challenge
```

  2. Run `bundle` unless you already have `rspec` installed.
  3. Run `rspec ./template_parser_spec.rb`

## Examples
```ruby
# Input:
template: "Hi {FIRST_NAME}"
environment: { first_name: "Diego" }

# Output:
"Hi Diego"

# Input:
template: "Hi {FIRST_NAME}"
environment: { }

# Output:
"Hi"

# Input:
template: "{#PATIENT_PAID}Patient paid.{#PATIENT_PAID}"
environment: { patient_paid: true }

# Output:
"Patient paid."

# Input:
template: "{#PATIENT_PAID}Patient paid.{#PATIENT_PAID}"
environment: { patient_paid: false }

# Output:
""

# Input:
template: "{^PATIENT_PAID}Patient did not pay.{^PATIENT_PAID}"
environment: { patient_paid: false }

# Output:
"Patient did not pay."

# Input:
template: "{^PATIENT_PAID}Patient did not pay.{^PATIENT_PAID}"
environment: { patient_paid: true }

# Output:
""

# Input:
template: "{#PATIENT_PAID}Patient paid.{^PATIENT_YOUNG} Patient is not young.{^PATIENT_YOUNG}{#PATIENT_PAID}"
environment: { patient_paid: true, patient_young: true }

# Output:
"Patient paid."

# Input:
template: "{#PATIENT_PAID}Patient paid. {^PATIENT_YOUNG} Patient is not young.{^PATIENT_YOUNG}{#PATIENT_PAID}"
environment: { patient_paid: true, patient_young: false }

# Output:
"Patient paid. Patient is not young."

# Input:
template: "{#PATIENT_PAID}Patient paid. {^PATIENT_YOUNG} Patient is not young.{^PATIENT_YOUNG}{#PATIENT_PAID}"
environment: { patient_paid: false, patient_young: false }

# Output:
""
```