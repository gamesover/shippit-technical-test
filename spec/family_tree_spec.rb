# frozen_string_literal: true

require 'rspec'
require_relative '../src/family_tree'

RSpec.describe FamilyTree do
  let(:family_tree) { FamilyTree.new }

  describe '#add_person' do
    it 'adds a new person to the family tree' do
      result = family_tree.add_person('John', 'male')
      expect(result).to eq('PERSON_ADDED')
    end

    it 'does not add a person with an existing name' do
      family_tree.add_person('John', 'male')
      result = family_tree.add_person('John', 'male')
      expect(result).to eq('PERSON_ALREADY_EXISTS')
    end

    it 'returns error message for invalid gender' do
      result = family_tree.add_person('Alex', 'unknown')
      expect(result).to eq('PERSON_ADDITION_FAILED')
    end
  end

  describe '#add_child' do
    before do
      family_tree.add_person('Jane', 'female')
      family_tree.add_person('John', 'male')
      family_tree.marry('Jane', 'John')
    end

    it 'adds a child to a mother' do
      result = family_tree.add_child('Jane', 'Alice', 'female')
      expect(result).to eq('CHILD_ADDED')
    end

    it 'does not add a child to a non-female person' do
      result = family_tree.add_child('John', 'Bob', 'male')
      expect(result).to eq('CHILD_ADDITION_FAILED')
    end

    it 'does not add a child if mother is not found' do
      result = family_tree.add_child('Unknown', 'Bob', 'male')
      expect(result).to eq('PERSON_NOT_FOUND')
    end

    it 'does not add a child with an existing name' do
      family_tree.add_child('Jane', 'Alice', 'female')
      result = family_tree.add_child('Jane', 'Alice', 'female')
      expect(result).to eq('PERSON_ALREADY_EXISTS')
    end
  end

  describe '#marry' do
    it 'marries two unmarried people' do
      family_tree.add_person('John', 'male')
      family_tree.add_person('Jane', 'female')
      result = family_tree.marry('John', 'Jane')
      expect(result).to eq('MARRIAGE_SUCCEEDED')
    end

    it 'does not marry a person to themselves' do
      family_tree.add_person('John', 'male')
      result = family_tree.marry('John', 'John')
      expect(result).to eq('MARRIAGE_FAILED')
    end

    it 'does not marry if one person is already married' do
      family_tree.add_person('John', 'male')
      family_tree.add_person('Jane', 'female')
      family_tree.add_person('Mary', 'female')
      family_tree.marry('John', 'Jane')
      result = family_tree.marry('John', 'Mary')
      expect(result).to eq('MARRIAGE_FAILED')
    end

    it 'does not marry if a person is not found' do
      family_tree.add_person('John', 'male')
      result = family_tree.marry('John', 'Unknown')
      expect(result).to eq('PERSON_NOT_FOUND')
    end
  end

  describe '#get_relationship' do
    before do
      family_tree.add_person('John', 'male')
      family_tree.add_person('Jane', 'female')
      family_tree.marry('John', 'Jane')
      family_tree.add_child('Jane', 'Alice', 'female')
      family_tree.add_child('Jane', 'Bob', 'male')
    end

    it 'returns sons' do
      result = family_tree.get_relationship('Jane', 'Son')
      expect(result).to eq('Bob')
    end

    it 'returns daughters' do
      result = family_tree.get_relationship('Jane', 'Daughter')
      expect(result).to eq('Alice')
    end

    it 'returns siblings' do
      result = family_tree.get_relationship('Alice', 'Siblings')
      expect(result).to eq('Bob')
    end

    it 'returns brothers' do
      result = family_tree.get_relationship('Alice', 'Brother-In-Law')
      expect(result).to eq('NONE') # Since Alice is unmarried
    end

    it 'returns error if person not found' do
      result = family_tree.get_relationship('Unknown', 'Son')
      expect(result).to eq('PERSON_NOT_FOUND')
    end

    it 'returns error for unsupported relationship' do
      result = family_tree.get_relationship('John', 'Grandchildren')
      expect(result).to eq('RELATIONSHIP_NOT_SUPPORTED')
    end
  end
end
