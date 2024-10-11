# Family Tree Builder

## Overview

Welcome to the **Family Tree Builder**! This Ruby application allows you to build and interact with a family tree through a command-line interface. You can add persons, establish marriages, add children, and query relationships within the family tree. The application supports both interactive commands and processing commands from input files.

## Features

- **Add Person**: Add new individuals with specified names and genders to the family tree.
- **Establish Marriages**: Link two individuals in a marriage relationship.
- **Add Children**: Add a child to a mother, automatically linking the father if married.
- **Query Relationships**: Retrieve relationships such as sons, daughters, siblings, uncles, aunts, brothers-in-law, and sisters-in-law.
- **File Input**: Build the family tree using input files containing commands.
- **Interactive Mode**: Interact with the family tree builder through a command-line interface.
- **Comprehensive Testing**: Includes unit and integration tests using RSpec.
- **Code Quality Tools**: Uses RuboCop for linting and code style enforcement.

## Requirements

- **Ruby 3.0.0**: Ensure you have Ruby version 3.0.0 installed.
- **Bundler**: For managing gem dependencies.

## Getting Started

### Installation

1. **Clone the Repository**

   ```bash
   git clone git@github.com:gamesover/shippit-technical-test.git
   cd shippit-technical-test
   ```

2. **Install Dependencies**

   Install required gems using Bundler:

   ```bash
   bundle install
   ```

3. **Set Ruby Version**

   Ensure you're using Ruby 3.0.0 with `asdf`:

   ```bash
   asdf install ruby 3.0.0
   asdf local ruby 3.0.0
   ```

### Usage

#### Running the Application

To start the Family Tree Builder application, run:

```bash
./family_tree_builder
```

If the script is not executable, set the execute permission:

```bash
chmod +x family_tree_builder
```

#### Available Commands

Once the application is running, you can use the following commands:

- **Build Tree from File**

  ```plaintext
  build_tree <input_file>
  ```

  Example:

  ```
  build_tree data/family_tree.txt
  ```

- **Add a New Person**

  ```plaintext
  ADD_PERSON <name> <gender>
  ```

  Example:

  ```
  ADD_PERSON John Male
  ```

- **Add a Child**

  ```plaintext
  ADD_CHILD <mother_name> <child_name> <gender>
  ```

  Example:

  ```
  ADD_CHILD Jane Alice Female
  ```

- **Establish a Marriage**

  ```plaintext
  MARRY <person1_name> <person2_name>
  ```

  Example:

  ```
  MARRY John Jane
  ```

- **Get a Relationship**

  ```plaintext
  GET_RELATIONSHIP <name> <relationship>
  ```

  Supported relationships include:

  - `Son`
  - `Daughter`
  - `Siblings`
  - `Brother-In-Law`
  - `Sister-In-Law`
  - `Maternal-Aunt`
  - `Paternal-Aunt`
  - `Maternal-Uncle`
  - `Paternal-Uncle`

  Example:

  ```
  GET_RELATIONSHIP Alice Brother-In-Law
  ```

- **Exit the Application**

  ```plaintext
  exit
  ```

#### Example Session

```plaintext
$ ./family_tree_builder
Welcome to the Family Tree Builder!

You can use the following commands:
- 'build_tree <input_file>': Add relationships from a file.
- 'ADD_PERSON <name> <gender>': Add a new person to the family tree.
- 'ADD_CHILD <mother_name> <child_name> <gender>': Add a child to a specified mother.
- 'MARRY <person1_name> <person2_name>': Establish a marriage between two people.
- 'GET_RELATIONSHIP <name> <relationship>': Retrieve a relationship of a person.
- 'exit': Quit the program.

> ADD_PERSON King_Arthur Male
PERSON_ADDED
> ADD_PERSON Queen_Margret Female
PERSON_ADDED
> MARRY King_Arthur Queen_Margret
MARRIAGE_SUCCEEDED
> ADD_CHILD Queen_Margret Charles Male
CHILD_ADDED
> ADD_CHILD Queen_Margret Anne Female
CHILD_ADDED
> GET_RELATIONSHIP Anne Siblings
Charles
> exit
Thank you for using the Family Tree Builder. Goodbye!
```

### Processing Commands from a File

You can build the family tree by processing commands from an input file.

**Example Input File (`data/family_tree.txt`):**

```plaintext
ADD_PERSON King_Arthur Male
ADD_PERSON Queen_Margret Female
MARRY King_Arthur Queen_Margret
ADD_CHILD Queen_Margret Bill Male
ADD_CHILD Queen_Margret Charlie Male
ADD_CHILD Queen_Margret Percy Male
ADD_CHILD Queen_Margret Ronald Male
ADD_CHILD Queen_Margret Ginerva Female
```

**Processing the Input File:**

```bash
./family_tree_builder
> build_tree data/family_tree.txt
```

## Testing

The project includes an RSpec test suite to verify all public methods of the `FamilyTree` class. To run the tests:
```bash
bundle exec rspec
```

## Future Improvements

- **Continuous Integration (CI):** Integrate CI tools like GitHub Actions or Travis CI to automate testing and code quality checks.
- **User Interface:** Develop a graphical user interface (GUI) to make the family tree builder more accessible.
- **Data Persistence:** Add support for saving and loading family trees to/from a database or files to allow users to resume work.
- **Additional Relationships:** Expand the relationships that can be queried, such as grandparents, cousins, and more complex familial connections.
- **Enhanced Error Handling:** Improve error handling and provide more informative messages to guide users.
- **Performance Optimization:** Optimize algorithms for handling large family trees.
- **Internationalization (i18n):** Support multiple languages for a broader user base.

## Contributing

Contributions are welcome! Please follow these steps:

1. **Fork the Repository**

   Click the 'Fork' button at the top right of the repository page.

2. **Create a New Branch**

   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Commit Your Changes**

   ```bash
   git commit -am 'Add new feature'
   ```

4. **Push to the Branch**

   ```bash
   git push origin feature/your-feature-name
   ```

5. **Submit a Pull Request**

   Go to your fork on GitHub and open a pull request.

**Please ensure all tests pass and code style checks are satisfied before submitting your pull request.**
