class CalorieCounting
  def initialize(input = data_file)
    @input = input
  end

  def data_file
    file_path = File.join(File.dirname(__FILE__), '..', 'data', 'day1.txt')
    raise "Data file not found at #{file_path}" unless File.file? file_path
    File.read(file_path)
  end

  def calorie_counts
    @input.split("\n\n").map do |elf|
      elf.lines.map(&:to_i).sum
    end.sort
  end

  def answer
    calorie_counts.last
  end

  def answer2
    calorie_counts.last(3).sum
  end
end

TEST_INPUT = <<~END
1000
2000
3000

4000

5000
6000

7000
8000
9000

10000
END

puts "EXPECTED: 24000"
puts CalorieCounting.new(TEST_INPUT).answer
puts CalorieCounting.new.answer

puts "-----"

puts "EXPECTED: 45000"
puts CalorieCounting.new(TEST_INPUT).answer2
puts CalorieCounting.new.answer2
