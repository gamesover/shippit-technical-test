# frozen_string_literal: true

require 'rspec'
require 'open3'

RSpec.describe 'Read Commands from files Tests' do
  Dir.glob('spec/data/inputs/*.txt').each do |input_file|
    test_name = File.basename(input_file, '.txt')
    output_filename = test_name.sub('input', 'output')
    expected_output_file = "spec/data/outputs/#{output_filename}.txt"
    expected_output = File.read(expected_output_file).strip

    it "processes #{test_name} and produces the expected output" do
      commands = <<~COMMANDS
        build_tree data/family_tree.txt
        build_tree #{input_file}
        exit
      COMMANDS

      Open3.popen3('./family_tree_builder') do |stdin, stdout, _stderr, _wait_thr|
        stdin.puts commands
        stdin.close

        output = stdout.read
        actual_output = output.strip

        expect(actual_output).to include(expected_output)
      end
    end
  end
end
