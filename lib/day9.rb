require_relative 'advent_problem'
require 'set'

class RopeBridge < AdventProblem
  @day = 9

  class Point
    attr_reader :row, :col
    def self.[](r,c)
      new(r,c)
    end
    def initialize(r,c)
      @row = r
      @col = c
    end
    def left
      @col -= 1
    end
    def right
      @col += 1
    end
    def up
      @row -= 1
    end
    def down
      @row += 1
    end
    def to_a
      [row,col]
    end

    def adjacent?(other)
      (row - other.row).abs <= 1 and (col - other.col).abs <= 1
    end

    def toward(other)
      return false if adjacent?(other)
      left if other.col < col
      right if col < other.col
      up if other.row < row
      down if row < other.row
    end

    def move(dir)
      case dir
      when "L" then left
      when "R" then right
      when "U" then up
      when "D" then down
      end
    end
  end

  def moves
    @moves ||=input.lines.map do |move|
      /(?<dir>[LRUD]) (?<num>\d+)/ =~ move
      [dir,num.to_i]
    end
  end

  attr_reader :head, :tail
  def answer
    @head = Point[0,0]
    @tail = Point[0,0]

    visited_points = Set.new.add(tail.to_a)
    moves.each do |dir, num|
      num.times do
        # loop through number of moves for head
        head.move(dir)

        # now adjust tail to match
        until tail.adjacent?(head)
          tail.toward(head)
          visited_points.add(tail.to_a)
        end
      end
    end

    # and the outcome
    visited_points.count
  end

  attr_reader :knots
  def answer2
    @knots = 10.times.collect{ Point[0,0] }

    visited_points = Set.new.add(knots.last.to_a)
    moves.each do |dir, num|
      num.times do
        # move head
        knots.first.move(dir)

        # move each knot after head towards previous
        movement = true
        while movement
          results = knots.map.with_index do |knot, i|
            next if i == 0 # head has been dealt with
            knots[i].toward(knots[i-1])
          end
          visited_points.add(knots.last.to_a)
          movement = results.any?
        end
      end
    end

    visited_points.count
  end
end

TEST_INPUT = <<~END
R 4
U 4
L 3
D 1
R 4
D 1
L 5
R 2
END

test = RopeBridge.new(TEST_INPUT)
puts 13 == test.answer

real = RopeBridge.new
puts real.answer

LARGER_TEST = <<~END
R 5
U 8
L 8
D 3
R 17
D 10
L 25
U 20
END

puts 1 == test.answer2
puts 36 == RopeBridge.new(LARGER_TEST).answer2

puts real.answer2
