require_relative 'advent_problem'

class CathodeRayTube < AdventProblem
  @day = 10

  def run_cycles
    # cycles = [20,60,100,140,180,220]
    cycles = [0]

    cycle_sum = 0
    cycle = 1
    register = 1
    input.lines.each do |line|
      start_cycle = cycle
      line.strip!

      cycles[cycle] = register
      if line == "noop"
        cycle += 1
      elsif /addx (?<num>-?\d+)/ =~ line
        num = num.to_i
        # register += num
        # cycle += 2
        cycle += 1
        cycles[cycle] = register
        cycle += 1
        register += num
      end
    end

    cycles
  end

  def answer
    cycles = run_cycles
    signal_strength_sum = 0
    cycles.each.with_index do |value, cycle|
      if (cycle - 20) % 40 == 0
        # puts "@#{cycle} #{value} -> #{value * cycle}"
        signal_strength_sum += (value * cycle)
      end
    end
    signal_strength_sum
  end

  def answer2
    cycles = run_cycles
    cycles.shift

    screen = cycles.each_slice(40).map do |line|
      line.map.with_index do |register, pixel|
        # sprite is register-1..register+1
        pixel_overlaps_sprite = ((register - 1)..(register + 1)).include?(pixel)
        pixel_overlaps_sprite ? "#" : "."
      end
    end

    screen.map(&:join).join("\n")
  end
end

SHORT_TEST = <<~END
noop
addx 3
addx -5
END

LONG_TEST = <<~END
addx 15
addx -11
addx 6
addx -3
addx 5
addx -1
addx -8
addx 13
addx 4
noop
addx -1
addx 5
addx -1
addx 5
addx -1
addx 5
addx -1
addx 5
addx -1
addx -35
addx 1
addx 24
addx -19
addx 1
addx 16
addx -11
noop
noop
addx 21
addx -15
noop
noop
addx -3
addx 9
addx 1
addx -3
addx 8
addx 1
addx 5
noop
noop
noop
noop
noop
addx -36
noop
addx 1
addx 7
noop
noop
noop
addx 2
addx 6
noop
noop
noop
noop
noop
addx 1
noop
noop
addx 7
addx 1
noop
addx -13
addx 13
addx 7
noop
addx 1
addx -33
noop
noop
noop
addx 2
noop
noop
noop
addx 8
noop
addx -1
addx 2
addx 1
noop
addx 17
addx -9
addx 1
addx 1
addx -3
addx 11
noop
noop
addx 1
noop
addx 1
noop
noop
addx -13
addx -19
addx 1
addx 3
addx 26
addx -30
addx 12
addx -1
addx 3
addx 1
noop
noop
noop
addx -9
addx 18
addx 1
addx 2
noop
noop
addx 9
noop
noop
noop
addx -1
addx 2
addx -37
addx 1
addx 3
noop
addx 15
addx -21
addx 22
addx -6
addx 1
noop
addx 2
addx 1
noop
addx -10
noop
noop
addx 20
addx 1
addx 2
addx 2
addx -6
addx -11
noop
noop
noop
END

test = CathodeRayTube.new(LONG_TEST)
puts 13140 == test.answer

real = CathodeRayTube.new
puts real.answer

image = <<~END
##..##..##..##..##..##..##..##..##..##..
###...###...###...###...###...###...###.
####....####....####....####....####....
#####.....#####.....#####.....#####.....
######......######......######......####
#######.......#######.......#######.....
END

puts test.answer2 == image.strip

puts real.answer2
