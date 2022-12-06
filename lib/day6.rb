require_relative 'advent_problem'

class TuningTrouble < AdventProblem
  @day = 6

  def answer
    chars = input.strip.chars
    chars.each.with_index do |ch, i|
      return i + 4 if chars.slice(i, 4).uniq.length == 4
    end
  end

  def answer2
    chars = input.strip.chars
    chars.each.with_index do |ch, i|
      return i + 14 if chars.slice(i, 14).uniq.length == 14
    end
  end
end

TEST_INPUT = <<~END
mjqjpqmgbljsphdztnvjfqwrcgsmlb
END

puts 7 == TuningTrouble.new(TEST_INPUT).answer
puts TuningTrouble.new.answer

puts 19 == TuningTrouble.new(TEST_INPUT).answer2
puts TuningTrouble.new.answer2
