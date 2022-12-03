require_relative 'advent_problem'

class RucksackReorganization < AdventProblem
  @day = 3

  def score(letter)
    case letter
    when "a".."z" then letter.ord - 96
    when "A".."Z" then letter.ord - 38
    end
  end

  def duplicate_in(*groups)
    groups.reduce(&:&).first
  end
  def answer
    input.lines.map(&:strip).map do |rucksack|
      items = rucksack.chars
      mid = items.length / 2
      left = items.slice(0,mid)
      right = items.slice(mid, mid)
      # dupe = (left & right).first
      dupe = duplicate_in(left, right)
      score(dupe)
    end.sum
  end

  def answer2
    input.lines.map(&:strip).map(&:chars).each_slice(3).map do |group|
      badge = duplicate_in(*group)
      score(badge)
    end.sum
  end
end

TEST_INPUT = <<~END
vJrwpWtwJgWrhcsFMMfFFhFp
jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
PmmdzqPrVvPwwTWBwg
wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
ttgJtRGJQctTZtZT
CrZsJsPPZsGzwwsLwLmpwMDw
END

puts 157 == RucksackReorganization.new(TEST_INPUT).answer
puts RucksackReorganization.new.answer

puts 70 == RucksackReorganization.new(TEST_INPUT).answer2
puts RucksackReorganization.new.answer2
