require_relative 'advent_problem'

class MonkeyMiddle < AdventProblem
  @day = 11

  class Monkey
    def self.from_description(text)
      name,items,operation,test,if_true,if_false = text.lines
      name = name.strip.gsub(":", "")
      items = items.scan(/\d+/).map(&:to_i)

      /Operation: new = (?<l>old|\d+) (?<o>[+*]) (?<r>old|\d+)/ =~ operation
      l = l.to_i unless l == "old"
      r = r.to_i unless r == "old"

      test = test.match(/Test: divisible by (\d+)/)[1].to_i
      if_true = if_true.match(/If true: throw to monkey (\d+)/)[1].to_i
      if_false = if_false.match(/If false: throw to monkey (\d+)/)[1].to_i

      new(name, items, l, o, r, test, if_true, if_false)
    end

    def initialize(name, items, op_left, op, op_right, test, if_true, if_false)
      @name = name
      @items = items
      @op_left = op_left
      @op = op
      @op_right = op_right
      @test = test
      @if_true = if_true
      @if_false = if_false
      @items_inspected = 0
    end

    def items?
      !@items.empty?
    end

    def op_left(old)
      @op_left == "old" ? old : @op_left
    end

    def op_right(old)
      @op_right == "old" ? old : @op_right
    end

    # A ROUND OF MONKEY BUSINESS
    # Each monkey goes through all the items it's holding
    # - Perform operation
    # - Divide by 3 and round down
    # - Check test condition and throw package
    #
    # take your first item, decide what to do with it
    # return [destination, item worry level]
    def consider
      @items_inspected += 1
      item = @items.shift
      item = case @op
             when "+" then op_left(item) + op_right(item)
             when "*" then op_left(item) * op_right(item)
             end
      item, _ = item.divmod(3)
      if item % @test == 0
        [@if_true, item]
      else
        [@if_false, item]
      end
    end

    def give(item)
      @items.push(item)
    end
    attr_accessor :items_inspected, :name, :items
  end

  class ModMonkey < Monkey
    def prep_items(modulos)
      @items = items.map do |value|
        modulos.inject({}) { |h,mod| h.update(mod => value % mod) }
      end
    end

    def operate(item)
      item.each do |k,v|
        item[k] = case @op
                  when "+" then op_left(v) + op_right(v)
                  when "*" then op_left(v) * op_right(v)
                  end
        item[k] = item[k] % k
      end
      item
    end

    def consider
      @items_inspected += 1
      item = @items.shift
      item = operate(item)
      # item[@test] = item[@test] % @test
      if item[@test] == 0
        [@if_true, item]
      else
        [@if_false, item]
      end
    end

    attr_accessor :test
  end

  def answer
    monkeys = input.split("\n\n").map{ |m| Monkey.from_description(m) }

    # how many items the two most active monkeys inspected (in 20 rounds)
    # multiply those to get level of monkey business
    20.times do
      monkeys.each do |monkey|
        while monkey.items?
          dest, item = monkey.consider
          monkeys[dest].give(item)
        end
      end
    end

    inspected_counts = monkeys.map(&:items_inspected).max(2).reduce(&:*)
  end

  def answer2(rounds = 10000)
    monkeys = input.split("\n\n").map{ |m| ModMonkey.from_description(m) }
    modulos = monkeys.map(&:test)
    monkeys.each{ |m| m.prep_items(modulos) }


    rounds.times do |i|
      begin
      # print "." if i % 100 == 0
      # 20.times do
      # print_round = i % 100 == 0 || rounds < 100 && i % 10 == 0
      # puts "-----[ ROUND #{i} ]-----" if print_round
      monkeys.each do |monkey|
        # if print_round
        #   puts "#{monkey.name}: #{monkey.items.count} / #{monkey.items_inspected}"
        #   puts monkey.items.map{ |i| "    " + i.inspect }
        # end
        while monkey.items?
          dest, item = monkey.consider
          monkeys[dest].give(item)
        end
      end
      rescue SystemExit, Interrupt
        puts "interrupt on round #{i}"
        monkeys.each do |monkey|
          puts "#{monkey.name}: #{monkey.items.count} / #{monkey.items_inspected}"
          puts monkey.items.map{ |i| "    " + i.inspect }
        end
        raise
      end
    end

    monkeys.map(&:items_inspected).max(2).reduce(&:*)
  end
end

TEST_INPUT = <<~END
Monkey 0:
  Starting items: 79, 98
  Operation: new = old * 19
  Test: divisible by 23
    If true: throw to monkey 2
    If false: throw to monkey 3

Monkey 1:
  Starting items: 54, 65, 75, 74
  Operation: new = old + 6
  Test: divisible by 19
    If true: throw to monkey 2
    If false: throw to monkey 0

Monkey 2:
  Starting items: 79, 60, 97
  Operation: new = old * old
  Test: divisible by 13
    If true: throw to monkey 1
    If false: throw to monkey 3

Monkey 3:
  Starting items: 74
  Operation: new = old + 3
  Test: divisible by 17
    If true: throw to monkey 0
    If false: throw to monkey 1
END

test = MonkeyMiddle.new(TEST_INPUT)
puts 10605 == test.answer

real = MonkeyMiddle.new
puts real.answer

puts 2713310158 == test.answer2
puts real.answer2
