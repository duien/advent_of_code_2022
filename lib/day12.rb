require_relative 'advent_problem'

class HillClimb < AdventProblem
  @day = 12

  attr_accessor :grid, :goal, :routes, :shortest_to
  def answer
    @grid = input.lines.map{ |l| l.strip.split("") }
    @shortest_to = grid.count.times.map{ [] }
    start = find("S")
    @goal = find("E")

    @routes = []
    find_route([start])

    # routes.map(&:count).min - 1
    routes.min
  rescue SystemExit, Interrupt
    puts shortest_to.map(&:inspect)
    puts shortest_to.flatten.compact.count
    raise
  end

  def find_route(so_far)
    current = so_far.last

    if current == goal
      routes << so_far.count - 1
      # puts "found route with length #{so_far.count - 1}"
      return
    end

    return if routes.any? and so_far.count > routes.min

    if (min = shortest_to[current[0]][current[1]]) and min < so_far.count
      return
    else
      shortest_to[current[0]][current[1]] = so_far.count
    end

    destinations = [
      [current[0], current[1] + 1],
      [current[0], current[1] - 1],
      [current[0] + 1, current[1]],
      [current[0] - 1, current[1]]
    ]

    destinations.each do |dest|
      next if dest[0] < 0 || dest[0] >= grid.count
      next if dest[1] < 0 || dest[1] >= grid.first.count
      next if height_at(*current) + 1 < height_at(*dest)
      # next unless [height_at(*current), height_at(*current) + 1].include?(height_at(*dest))
      next if so_far.include?(dest)

      find_route([*so_far, dest])
    end

  end

  def height_at(r,c)
    height(grid[r][c])
  end

  def height(char)
    case char
    when "S" then height("a")
    when "E" then height("z")
    else char.ord
    end
  end

  def find(char)
    row = grid.find_index{ |r| r.any?{ |c| c == char } }
    col = grid[row].find_index{ |c| c == char }
    [row, col]
  end
end

TEST_INPUT = <<~END
Sabqponm
abcryxxl
accszExk
acctuvwj
abdefghi
END

test = HillClimb.new(TEST_INPUT)
puts 31 == test.answer

real = HillClimb.new
puts real.answer
