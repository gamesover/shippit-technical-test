# frozen_string_literal: true

class FamilyTreeProcessor
  COMMANDS = {
    ADD_CHILD: "add_child",
    ADD_PERSON: "add_person",
    MARRY: "marry",
    GET_RELATIONSHIP: "get_relationship"
  }

  def initialize(tree)
    @tree = tree
  end

  def process_input_file(input_file)
    input_lines = File.readlines(input_file).map(&:strip)

    input_lines.each do |line|
      process_command_line(line)
    end
  end

  def process_command_line(line)
    parts = line.split
    command = parts[0]
    return if command.nil?

    case command.downcase
    when COMMANDS[:ADD_CHILD]
      mother_name = parts[1]
      child_name = parts[2]
      child_gender = parts[3]
      result = @tree.add_child(mother_name, child_name, child_gender)
      puts result
    when COMMANDS[:ADD_PERSON]
      name = parts[1]
      gender = parts[2]
      result = @tree.add_person(name, gender)
      puts result
    when COMMANDS[:MARRY]
      person1_name = parts[1]
      person2_name = parts[2]
      result = @tree.marry(person1_name, person2_name)
      puts result
    when COMMANDS[:GET_RELATIONSHIP]
      name = parts[1]
      relationship = parts[2]

      result = @tree.get_relationship(name, relationship)
      puts(result.is_a?(Array) ? result.join(' ') : result)
    else
      puts 'UNKNOWN_COMMAND'
    end
  end
end
