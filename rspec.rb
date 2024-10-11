# frozen_string_literal: true

require 'rspec'
require_relative 'family_tree_ruby_solution_restored'

describe FamilyTree do
  let(:family_tree) { FamilyTree.new }

  describe '#add_person' do
    it 'adds a new person to the family tree' do
      expect(family_tree.add_person('Alice', 'female')).to eq('PERSON_ADDITION_SUCCEEDED')
      expect(family_tree.add_person('Bob', 'male')).to eq('PERSON_ADDITION_SUCCEEDED')
    end

    it 'does not add a person that already exists' do
      family_tree.add_person('Alice', 'female')
      expect(family_tree.add_person('Alice', 'female')).to eq('PERSON_ALREADY_EXISTS')
    end
  end

  describe '#add_child' do
    before do
      family_tree.add_person('Queen_Margaret', 'female')
      family_tree.add_person('King_Arthur', 'male')
      family_tree.marry('King_Arthur', 'Queen_Margaret')
    end

    it 'adds a child to a mother in the family tree' do
      expect(family_tree.add_child('Queen_Margaret', 'Charles', 'male')).to eq('CHILD_ADDITION_SUCCEEDED')
    end

    it 'fails to add a child if mother does not exist' do
      expect(family_tree.add_child('Non_Existent', 'Charles', 'male')).to eq('CHILD_ADDITION_FAILED')
    end

    it 'fails to add a child if the person is not female' do
      expect(family_tree.add_child('King_Arthur', 'Charles', 'male')).to eq('CHILD_ADDITION_FAILED')
    end
  end

  describe '#marry' do
    before do
      family_tree.add_person('Alice', 'female')
      family_tree.add_person('Bob', 'male')
    end

    it 'marries two people in the family tree' do
      expect(family_tree.marry('Alice', 'Bob')).to eq('MARRIAGE_SUCCEEDED')
    end

    it 'fails to marry if one person is already married' do
      family_tree.marry('Alice', 'Bob')
      family_tree.add_person('Charlie', 'male')
      expect(family_tree.marry('Alice', 'Charlie')).to eq('MARRIAGE_FAILED')
    end
  end

  describe '#get_relationship' do
    before do
      family_tree.add_person('Queen_Margaret', 'female')
      family_tree.add_person('King_Arthur', 'male')
      family_tree.marry('King_Arthur', 'Queen_Margaret')
      family_tree.add_child('Queen_Margaret', 'Charles', 'male')
      family_tree.add_child('Queen_Margaret', 'Anne', 'female')
      family_tree.add_child('Queen_Margaret', 'Andrew', 'male')
    end

    it 'gets the sons of a person' do
      expect(family_tree.get_relationship('Queen_Margaret', 'son')).to eq(%w[Charles Andrew])
    end

    it 'gets the daughters of a person' do
      expect(family_tree.get_relationship('Queen_Margaret', 'daughter')).to eq(['Anne'])
    end

    it 'returns PERSON_NOT_FOUND for a non-existent person' do
      expect(family_tree.get_relationship('Non_Existent', 'son')).to eq('PERSON_NOT_FOUND')
    end

    it 'returns RELATIONSHIP_NOT_SUPPORTED for an invalid relationship' do
      expect(family_tree.get_relationship('Queen_Margaret', 'invalid_relationship')).to eq('RELATIONSHIP_NOT_SUPPORTED')
    end
  end
end
