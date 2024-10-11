# frozen_string_literal: true

require_relative './person'

class FamilyTree
  def initialize
    @persons = {}
  end

  def add_child(mother_name, child_name, child_gender)
    mother = @persons[mother_name.strip]
    return 'PERSON_NOT_FOUND' unless mother
    return 'CHILD_ADDITION_FAILED' unless mother.female?

    stripped_child_name = child_name.to_s.strip
    return 'PERSON_ALREADY_EXISTS' if @persons.key?(stripped_child_name)

    begin
      child = Person.new(child_name, child_gender)
      mother.add_child(child)
      @persons[stripped_child_name] = child
      'CHILD_ADDED'
    rescue ArgumentError => _e
      'CHILD_ADDITION_FAILED'
    end
  end

  def add_person(name, gender)
    stripped_name = name.to_s.strip
    return 'PERSON_ALREADY_EXISTS' if @persons.key?(stripped_name)

    begin
      @persons[stripped_name] = Person.new(stripped_name, gender)
      'PERSON_ADDED'
    rescue ArgumentError => _e
      'PERSON_ADDITION_FAILED'
    end
  end

  def marry(person1_name, person2_name)
    person1 = @persons[person1_name.strip]
    person2 = @persons[person2_name.strip]
    return 'PERSON_NOT_FOUND' unless person1 && person2

    begin
      person1.add_spouse(person2)
      'MARRIAGE_SUCCEEDED'
    rescue ArgumentError => _e
      'MARRIAGE_FAILED'
    end
  end

  def get_relationship(name, relationship)
    person = @persons[name.strip]
    return 'PERSON_NOT_FOUND' unless person

    relatives = case relationship.downcase
                when 'siblings'
                  person.siblings
                when 'son'
                  person.sons
                when 'daughter'
                  person.daughters
                when 'paternal-uncle'
                  person.father&.brothers || []
                when 'maternal-uncle'
                  person.mother&.brothers || []
                when 'paternal-aunt'
                  person.father&.sisters || []
                when 'maternal-aunt'
                  person.mother&.sisters || []
                when 'brother-in-law'
                  (person.spouse&.brothers || []) + person.sisters.map(&:spouse).compact
                when 'sister-in-law'
                  (person.spouse&.sisters || []) + person.brothers.map(&:spouse).compact
                else
                  return 'RELATIONSHIP_NOT_SUPPORTED'
                end

    uniq_relatives = relatives.compact.uniq
    uniq_relatives.empty? ? 'NONE' : uniq_relatives.map(&:name).join(' ')
  end
end
