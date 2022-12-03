require_relative 'advent_problem'
class RockPaperScissors < AdventProblem
  @day = 2

  # Take A, B, C / X, Y, Z and translate into rock, paper, scissors
  def translate(move)
    case move
    when "A", "X" then :rock
    when "B", "Y" then :paper
    when "C", "Z" then :scissors
    end
  end

  def round_score(opponent, me)
    { rock: { rock: 3 + 1,
              paper: 6 + 2,
              scissors: 0 + 3
            },
      paper: { rock: 0 + 1,
               paper: 3 + 2,
               scissors: 6 + 3
             },
      scissors: { rock: 6 + 1,
                  paper: 0 + 2,
                  scissors: 3 + 3
                }
    }[opponent][me]
  end

  def answer
    scores = @input.lines.map do |line|
      opponent, me = line.strip.split(" ")
      round_score(translate(opponent), translate(me))
    end
    scores.sum
  end
end

TEST_INPUT = <<~END
A Y
B X
C Z
END

puts 15 == RockPaperScissors.new(TEST_INPUT).answer
puts RockPaperScissors.new.answer

class RockPaperScissors::WinLoseDraw < RockPaperScissors
  @day = 2
  def translate_outcome(opponent, outcome)
    opponent = translate(opponent)
    me = case outcome
    when "X" # lose
      { rock: :scissors,
        paper: :rock,
        scissors: :paper
      }[opponent]
    when "Y" # draw
      opponent
    when "Z" # win
      { rock: :paper,
        paper: :scissors,
        scissors: :rock
      }[opponent]
    end
    [opponent, me]
  end

  def answer
    scores = @input.lines.map do |line|
      opponent, outcome = line.strip.split(" ")
      round_score(*translate_outcome(opponent, outcome))
    end
    scores.sum
  end
end

puts 12 == RockPaperScissors::WinLoseDraw.new(TEST_INPUT).answer
puts RockPaperScissors::WinLoseDraw.new.answer
