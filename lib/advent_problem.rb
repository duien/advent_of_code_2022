class AdventProblem
  attr_accessor :input

  def initialize(input = data_file)
    raise "class must set day!" if self.class.day.nil?
    @input = input
  end

  def data_file
    file_path = File.join(File.dirname(__FILE__), '..', 'data', "day#{self.class.day}.txt")
    raise "Data file not found at #{file_path}" unless File.file? file_path
    File.read(file_path)
  end

  def self.day
    @day
  end
end
