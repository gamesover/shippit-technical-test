# frozen_string_literal: true

require 'rspec'
require_relative '../src/person'

RSpec.describe Person do
  let(:john) { Person.new('John', 'male') }
  let(:jane) { Person.new('Jane', 'female') }

  describe '#initialize' do
    it 'creates a new person with valid name and gender' do
      expect(john.name).to eq('John')
      expect(john.gender).to eq('male')
    end

    it 'raises an error for invalid name' do
      expect { Person.new('', 'male') }.to raise_error(ArgumentError, 'Invalid name')
    end

    it 'raises an error for invalid gender' do
      expect { Person.new('Alex', 'unknown') }.to raise_error(ArgumentError, 'Invalid gender')
    end
  end

  describe '#male?' do
    it 'returns true if the person is male' do
      expect(john.male?).to be true
    end

    it 'returns false if the person is female' do
      expect(jane.male?).to be false
    end
  end

  describe '#female?' do
    it 'returns true if the person is female' do
      expect(jane.female?).to be true
    end

    it 'returns false if the person is male' do
      expect(john.female?).to be false
    end
  end

  describe '#add_spouse' do
    it 'adds a spouse if both are unmarried' do
      john.add_spouse(jane)
      expect(john.spouse).to eq(jane)
      expect(jane.spouse).to eq(john)
    end

    it 'raises an error if trying to marry oneself' do
      expect { john.add_spouse(john) }.to raise_error(ArgumentError, 'Cannot marry oneself')
    end

    it 'raises an error if either person is already married' do
      john.add_spouse(jane)
      jack = Person.new('Jack', 'male')
      expect { jane.add_spouse(jack) }.to raise_error(ArgumentError, 'Jane is already married')
    end
  end

  describe '#add_child' do
    before do
      john.add_spouse(jane)
    end

    it 'adds a child to parents' do
      child = Person.new('Alice', 'female')
      jane.add_child(child)
      expect(jane.children).to include(child)
      expect(child.parents).to match_array([jane, john])
    end

    it 'does not duplicate parents in child' do
      child = Person.new('Alice', 'female')
      jane.add_child(child)
      expect(child.parents.count(jane)).to eq(1)
      expect(child.parents.count(john)).to eq(1)
    end
  end

  describe 'family relations' do
    let(:child1) { Person.new('Alice', 'female') }
    let(:child2) { Person.new('Bob', 'male') }

    before do
      john.add_spouse(jane)
      jane.add_child(child1)
      jane.add_child(child2)
    end

    it 'returns correct sons and daughters' do
      expect(jane.sons).to include(child2)
      expect(jane.daughters).to include(child1)
    end

    it 'returns correct siblings' do
      expect(child1.siblings).to include(child2)
      expect(child2.siblings).to include(child1)
    end

    it 'returns correct brothers and sisters' do
      expect(child1.brothers).to include(child2)
      expect(child1.sisters).to be_empty
      expect(child2.sisters).to include(child1)
      expect(child2.brothers).to be_empty
    end
  end
end
