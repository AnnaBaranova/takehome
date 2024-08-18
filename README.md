# Ruby Challenge Project: Company Users Data Processor

The project processes company and user data, formats it, and writes the output to a file. It includes error handling for unexpected issues during file operations.

## Features

- Read data from JSON file.
- Process and format company and user data.
- Write formatted data to an output file.
- Handle errors during file operations.

## Setup

1. **Clone the repository**:
   ```sh
   git clone https://github.com/AnnaBaranova/takehome
   ```
2. **Navigate to the project directory**
   ```sh
   cd takehome
   ```
3. **Install the required gems**
   ```sh
   bundle install
   ```
4. **Run sript in the terminal to process data**
   ```sh
   ruby challenge.rb
   ```
5. **Run tests**
   ```sh
   bundle exec rspec
   ```

## Project Structure

<details>
  <summary>Click to expand</summary>

  - helpers
    - data_formatter.rb
    - data_validator.rb
    - error_helper.rb
    - file_helper.rb
    - json_helper.rb
  - models
    - company.rb
    - user.rb
  - processors
    - company_processor.rb
    - data_processor.rb
    - user_prcessor.rb
  - spec
    - helpers
      - data_formatter_spec.rb
      - data_validator_spec.rb
      - error_helper_spec.rb
      - file_helper_spec.rb
      - json_helper_spec.rb
    - fixtures
    - models
      - company_spec.rb
      - user_spec.rb
    - processors
      - company_processor_spec.rb
      - data_processor_spec.rb
      - user_prcessor_spec.rb
    - challenge_spec.rb
  - challenge.rb
  - challenge.txt
  - companies.json
  - users.json
  - example_output.txt
  - Gemfile
  - challenge.rb
  - Gemfile
  - Gemfile.lock
  - README.md
</details>



