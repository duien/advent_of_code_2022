require_relative 'advent_problem'

class CampCleanup < AdventProblem
  @day = 4

  def pairs
    @pairs ||= input.lines.map do |line|
      ranges = line.split(",").map do |range|
        a,b = range.split("-").map(&:to_i)
        a..b
      end
    end
  end

  def answer
    pairs.select do |a,b|
      a.cover?(b) || b.cover?(a)
    end.count
  end

  def answer2
    pairs.select do |a,b|
      a.cover?(b.first) || b.cover?(a.first)
    end.count
  end
end

TEST_INPUT = <<~END
2-4,6-8
2-3,4-5
5-7,7-9
2-8,3-7
6-6,4-6
2-6,4-8
END

puts 2 == CampCleanup.new(TEST_INPUT).answer
puts CampCleanup.new.answer

puts 4 == CampCleanup.new(TEST_INPUT).answer2
puts CampCleanup.new.answer2
