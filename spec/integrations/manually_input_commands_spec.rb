# frozen_string_literal: true

require 'rspec'
require 'open3'

RSpec.describe 'Manual command inputs' do
  it 'allows adding a person and reports success' do
    commands = <<~COMMANDS
      ADD_PERSON Tom Male
      exit
    COMMANDS

    expected_output = 'PERSON_ADDED'

    Open3.popen3('./family_tree_builder') do |stdin, stdout, _stderr, _wait_thr|
      stdin.puts commands
      stdin.close

      output = stdout.read.strip

      expect(output).to include(expected_output)
    end
  end

  it 'prevents adding a person who already exists' do
    commands = <<~COMMANDS
      ADD_PERSON Tom Male
      ADD_PERSON Tom Male
      exit
    COMMANDS

    expected_output = 'PERSON_ALREADY_EXISTS'

    Open3.popen3('./family_tree_builder') do |stdin, stdout, _stderr, _wait_thr|
      stdin.puts commands
      stdin.close

      output = stdout.read.strip

      expect(output).to include('PERSON_ADDED')
      expect(output).to include(expected_output)
    end
  end

  it 'allows adding a child to an existing mother' do
    commands = <<~COMMANDS
      ADD_PERSON Mary Female
      MARRY Mary John
      ADD_CHILD Mary Anna Female
      exit
    COMMANDS

    expected_output = 'CHILD_ADDED'

    Open3.popen3('./family_tree_builder') do |stdin, stdout, _stderr, _wait_thr|
      stdin.puts commands
      stdin.close

      output = stdout.read.strip

      expect(output).to include('PERSON_ADDED')
      expect(output).to include('PERSON_NOT_FOUND')
      expect(output).to include(expected_output)
    end
  end

  it 'prevents adding a child to a non-existent mother' do
    commands = <<~COMMANDS
      ADD_CHILD NonExistentMother Anna Female
      exit
    COMMANDS

    expected_output = 'PERSON_NOT_FOUND'

    Open3.popen3('./family_tree_builder') do |stdin, stdout, _stderr, _wait_thr|
      stdin.puts commands
      stdin.close

      output = stdout.read.strip

      expect(output).to include(expected_output)
    end
  end

  it 'allows marrying two unmarried people' do
    commands = <<~COMMANDS
      ADD_PERSON Alice Female
      ADD_PERSON Bob Male
      MARRY Alice Bob
      exit
    COMMANDS

    expected_output = 'MARRIAGE_SUCCEEDED'

    Open3.popen3('./family_tree_builder') do |stdin, stdout, _stderr, _wait_thr|
      stdin.puts commands
      stdin.close

      output = stdout.read.strip

      expect(output).to include('PERSON_ADDED').twice
      expect(output).to include(expected_output)
    end
  end

  it 'prevents marrying a person to themselves' do
    commands = <<~COMMANDS
      ADD_PERSON Charlie Male
      MARRY Charlie Charlie
      exit
    COMMANDS

    expected_output = 'MARRIAGE_FAILED'

    Open3.popen3('./family_tree_builder') do |stdin, stdout, _stderr, _wait_thr|
      stdin.puts commands
      stdin.close

      output = stdout.read.strip

      expect(output).to include('PERSON_ADDED')
      expect(output).to include(expected_output)
    end
  end

  it 'retrieves relationships correctly' do
    commands = <<~COMMANDS
      ADD_PERSON Dave Male
      ADD_PERSON Eve Female
      MARRY Eve Dave
      ADD_CHILD Eve Frank Male
      GET_RELATIONSHIP Frank Mother
      exit
    COMMANDS

    expected_output = 'Eve'

    Open3.popen3('./family_tree_builder') do |stdin, stdout, _stderr, _wait_thr|
      stdin.puts commands
      stdin.close

      output = stdout.read.strip

      expect(output).to include('PERSON_ADDED').twice
      expect(output).to include('MARRIAGE_SUCCEEDED')
      expect(output).to include('CHILD_ADDED')
      expect(output).to include(expected_output)
    end
  end

  it 'handles unknown commands gracefully' do
    commands = <<~COMMANDS
      UNKNOWN_COMMAND
      exit
    COMMANDS

    expected_output = 'UNKNOWN COMMAND'

    Open3.popen3('./family_tree_builder') do |stdin, stdout, _stderr, _wait_thr|
      stdin.puts commands
      stdin.close

      output = stdout.read.strip

      expect(output).to include(expected_output)
    end
  end

  it 'handles invalid command formats' do
    commands = <<~COMMANDS
      ADD_PERSON
      exit
    COMMANDS

    expected_output = 'INVALID_COMMAND_FORMAT'

    Open3.popen3('./family_tree_builder') do |stdin, stdout, _stderr, _wait_thr|
      stdin.puts commands
      stdin.close

      output = stdout.read.strip

      expect(output).to include(expected_output)
    end
  end
end
