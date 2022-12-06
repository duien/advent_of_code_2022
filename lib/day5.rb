require_relative "advent_problem"

class SupplyStacks < AdventProblem
  @day = 5

  def parse_stacks(stack_text)
    layers = stack_text.lines.reverse
    layers.shift # numbers

    stacks = []
    layers.each do |layer|
      crates = layer.chars.each_slice(4).map{ |g| g[1] }
      crates.each.with_index do |c, i|
        next if c == " "
        stacks[i] ||= []
        stacks[i].push(c)
      end
    end
    stacks
  end

  def parse_instruction(text)
    /move (?<count>\d+) from (?<source>\d) to (?<dest>\d)/ =~ text
    [source.to_i - 1, dest.to_i - 1, count.to_i]
  end

  def answer
    stack_text, instructions = input.split("\n\n")
    stacks = parse_stacks(stack_text)

    instructions.lines.each do |text|
      source, dest, count = parse_instruction(text)
      count.times do
        stacks[dest].push(stacks[source].pop)
      end
    end

    stacks.map(&:last).join
  end

  def answer2
    stack_text, instructions = input.split("\n\n")
    stacks = parse_stacks(stack_text)

    instructions.lines.each do |text|
      source, dest, count = parse_instruction(text)
      stacks[dest].concat(stacks[source].pop(count))
    end

    stacks.map(&:last).join
  end

end

TEST_INPUT = <<~END
    [D]
[N] [C]
[Z] [M] [P]
 1   2   3

move 1 from 2 to 1
move 3 from 1 to 3
move 2 from 2 to 1
move 1 from 1 to 2
END

puts "CMZ" == SupplyStacks.new(TEST_INPUT).answer
puts SupplyStacks.new.answer

puts "MCD" == SupplyStacks.new(TEST_INPUT).answer2
puts SupplyStacks.new.answer2
