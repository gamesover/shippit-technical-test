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
    return [] if @parents.empty?

    @parents.flat_map(&:children).uniq.reject { |sibling| sibling == self }
  end

  def male?
    @gender == MALE
  end

  def female?
    @gender == FEMALE
  end

  def add_child(child)
    @children << child
    child.parents << self
    child.parents << @spouse if @spouse && !child.parents.include?(@spouse)
  end

  def add_spouse(spouse)
    raise ArgumentError, 'Cannot marry oneself' if self == spouse
    raise ArgumentError, "#{spouse.name} is already married" unless spouse.spouse.nil?
    raise ArgumentError, "#{name} is already married" unless @spouse.nil?

    @spouse = spouse
    spouse.spouse = self
  end
end
