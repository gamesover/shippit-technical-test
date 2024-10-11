# frozen_string_literal: true

class FamilyTreeProcessor
  COMMANDS = {
    'add_child' => :add_child,
    'add_person' => :add_person,
    'marry' => :marry,
    'get_relationship' => :get_relationship
  }.freeze

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
    parts = line.strip.split
    command = parts[0]&.downcase
    return if command.nil?

    if COMMANDS.key?(command)
      method = COMMANDS[command]
      result = send(method, *parts[1..])
      puts result
    else
      puts 'UNKNOWN COMMAND'
    end
  end

  private

  def add_person(name = nil, gender = nil)
    if name.nil? || gender.nil?
      'INVALID_COMMAND_FORMAT'
    else
      @tree.add_person(name, gender)
    end
  end

  def add_child(mother_name = nil, child_name = nil, child_gender = nil)
    if mother_name.nil? || child_name.nil? || child_gender.nil?
      'INVALID_COMMAND_FORMAT'
    else
      @tree.add_child(mother_name, child_name, child_gender)
    end
  end

  def marry(person1_name = nil, person2_name = nil)
    if person1_name.nil? || person2_name.nil?
      'INVALID_COMMAND_FORMAT'
    else
      @tree.marry(person1_name, person2_name)
    end
  end

  def get_relationship(name = nil, relationship = nil)
    if name.nil? || relationship.nil?
      'INVALID_COMMAND_FORMAT'
    else
      @tree.get_relationship(name, relationship)
    end
  end
end
