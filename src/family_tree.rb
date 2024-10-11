require_relative './person'

class FamilyTree
  def initialize
    @persons = {}
  end

  def add_child(mother_name, child_name, child_gender)
    mother = @persons[mother_name.strip]
    return "PERSON_NOT_FOUND" unless mother
    return "CHILD_ADDITION_FAILED" unless mother.female?

    begin
      child = mother.add_child(child_name, child_gender)
      @persons[child_name] = child
      "CHILD_ADDED"
    rescue ArgumentError => e
      "CHILD_ADDITION_FAILED"
    end
  end

  def add_person(name, gender)
    stripped_name = name.to_s.strip
    return "PERSON_ALREADY_EXISTS" if @persons.key?(stripped_name)

    begin
      @persons[stripped_name] = Person.new(stripped_name, gender)
      "PERSON_ADDED"
    rescue ArgumentError => e
      "PERSON_ADDITION_FAILED"
    end
  end

  def marry(person1_name, person2_name)
    person1 = @persons[person1_name.strip]
    person2 = @persons[person2_name.strip]

    if person1 && person2 && person1.spouse.nil? && person2.spouse.nil?
      person1.add_spouse(person2)
      "MARRIAGE_SUCCEEDED"
    else
      "MARRIAGE_FAILED"
    end
  end

  def get_relationship(name, relationship)
    person = @persons[name.strip]
    return "PERSON_NOT_FOUND" unless person

    result = case relationship.downcase
    when 'siblings'
      person.siblings
    when 'son'
      person.sons
    when 'daughter'
      person.daughters
    when 'paternal-uncle'
      person.father.brothers
    when 'maternal-uncle'
      person.mother.brothers
    when 'paternal-aunt'
      person.father.sisters
    when 'maternal-aunt'
      person.mother.sisters
    when 'brother-in-law'
      (person.spouse&.brothers || []) + person.sisters.flat_map(&:spouse)
    when 'sister-in-law'
      (person.spouse&.sisters || []) + person.brothers.flat_map(&:spouse)
    else
      return "RELATIONSHIP_NOT_SUPPORTED"
    end

    result.empty? ? 'NONE' : result.map(&:name).join(' ')
  end
end
