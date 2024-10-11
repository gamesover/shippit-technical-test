# frozen_string_literal: true

class Person
  MALE = 'male'
  FEMALE = 'female'

  attr_accessor :name, :gender, :children, :spouse, :parents

  def initialize(name, gender)
    raise ArgumentError, 'Invalid name' if name.nil? || name.strip.empty?
    raise ArgumentError, 'Invalid gender' unless [MALE, FEMALE].include?(gender.downcase)

    @name = name.strip
    @gender = gender.downcase
    @children = []
    @spouse = nil
    @parents = []
  end

  def father
    @parents.find(&:male?)
  end

  def mother
    @parents.find(&:female?)
  end

  def sons
    @children.select(&:male?)
  end

  def daughters
    @children.select(&:female?)
  end

  def brothers
    siblings.select(&:male?)
  end

  def sisters
    siblings.select(&:female?)
  end

  def siblings
    @parents.flat_map { |parent| parent.children.reject { |sibling| sibling == self } }.uniq
  end

  def male?
    @gender == MALE
  end

  def female?
    @gender == FEMALE
  end

  def add_child(child_name, child_gender)
    stripped_child_name = child_name.to_s.strip
    raise ArgumentError, 'Invalid child name' if stripped_child_name.empty?
    raise ArgumentError, 'Invalid child gender' unless [MALE, FEMALE].include?(child_gender.downcase)

    Person.new(stripped_child_name, child_gender).tap do |child|
      child.parents << self
      child.parents << @spouse if @spouse
      @children << child
    end
  end

  def add_spouse(spouse)
    @spouse = spouse
    spouse.spouse = self
  end
end
