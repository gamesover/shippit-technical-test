# frozen_string_literal: true

require 'rspec'
require_relative '../src/family_tree'
require_relative '../src/family_tree_processor'

RSpec.describe FamilyTreeProcessor do
  let(:family_tree) { FamilyTree.new }
  let(:processor) { FamilyTreeProcessor.new(family_tree) }

  describe '#process_command_line' do
    it 'processes ADD_PERSON command' do
      expect { processor.process_command_line('ADD_PERSON John male') }.to output("PERSON_ADDED\n").to_stdout
    end

    it 'processes ADD_CHILD command' do
      processor.process_command_line('ADD_PERSON Jane female')
      processor.process_command_line('ADD_PERSON John male')
      processor.process_command_line('MARRY Jane John')
      expect { processor.process_command_line('ADD_CHILD Jane Alice female') }.to output("CHILD_ADDED\n").to_stdout
    end

    it 'processes MARRY command' do
      processor.process_command_line('ADD_PERSON John male')
      processor.process_command_line('ADD_PERSON Jane female')
      expect { processor.process_command_line('MARRY John Jane') }.to output("MARRIAGE_SUCCEEDED\n").to_stdout
    end

    it 'processes GET_RELATIONSHIP command' do
      processor.process_command_line('ADD_PERSON John male')
      processor.process_command_line('ADD_PERSON Jane female')
      processor.process_command_line('MARRY John Jane')
      processor.process_command_line('ADD_CHILD Jane Alice female')
      expect { processor.process_command_line('GET_RELATIONSHIP Jane Daughter') }.to output("Alice\n").to_stdout
    end

    it 'handles unknown commands' do
      expect { processor.process_command_line('UNKNOWN_COMMAND') }.to output("UNKNOWN COMMAND\n").to_stdout
    end

    it 'handles invalid command formats' do
      expect { processor.process_command_line('ADD_PERSON John') }.to output("INVALID_COMMAND_FORMAT\n").to_stdout
    end
  end

  describe '#process_input_file' do
    it 'processes commands from an input file' do
      input_file = 'spec/test_input.txt'
      File.write(input_file, <<~INPUT)
        ADD_PERSON John male
        ADD_PERSON Jane female
        MARRY John Jane
        ADD_CHILD Jane Alice female
        GET_RELATIONSHIP Jane Daughter
      INPUT

      expect { processor.process_input_file(input_file) }.to output(
        "PERSON_ADDED\nPERSON_ADDED\nMARRIAGE_SUCCEEDED\nCHILD_ADDED\nAlice\n"
      ).to_stdout

      File.delete(input_file)
    end
  end
end
