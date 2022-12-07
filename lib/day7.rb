require_relative 'advent_problem'

class NoSpace < AdventProblem
  @day = 7

  MAX_SIZE = 100_000
  TOTAL_SIZE = 70_000_000
  NEEDED_FREE = 30_000_000

  def deep_update(hash, keys, value)
    # puts "put #{value.inspect} at #{keys.inspect}"
    if keys.length == 1
      hash[keys.first] = value
    else
      deep_update(hash[keys.first], keys[1..-1], value)
    end
  end

  def dig(hash, keys)
    if keys.length == 1
      hash[keys.first]
    else dig(hash[keys.first], keys[1..-1])
    end
  end

  def total_size(hash, path = nil)
    # puts "total size at #{path.inspect}"
    return total_size(dig(hash, path)) if path
    # puts "--> #{hash.inspect}"
    hash.collect do |k,v|
      v.is_a?(Hash) ? total_size(v) : v
    end.sum
  end

  attr_accessor :slash, :all_dirs
  def build_directory_info
    commands = input.lines.map(&:strip).slice_before{ |l| l.start_with? "$"}
    self.slash = {}
    pwd = []
    self.all_dirs = []
    commands.each do |command, *output|
      if /^\$ cd (?<dir>.+)$/ =~ command
        case dir
        when "/" then pwd = []
        when ".." then pwd.pop
        else
          pwd.push(dir)
          all_dirs.push(pwd.dup)
          # TODO validate dir in structure?
        end
      elsif /^\$ ls$/ =~ command
        output.each do |line|
          if /^(?<size>\d+) (?<name>.+)$/ =~ line
            # handle a file in the directory
            deep_update(slash, pwd + [name], size.to_i)
          elsif /^dir (?<name>.+)$/ =~ line
            # handle a nested directory
            deep_update(slash, pwd + [name], {})
          else raise "unexpected in `ls` output: #{line}"
          end
        end
      else raise "unexpected command: #{command}"
      end
    end
  end

  def all_sizes
    all_dirs.map{ |path| total_size(slash, path) }
  end

  def answer
    build_directory_info
    all_sizes.filter{ |n| n <= MAX_SIZE }.sum
  end

  def answer2
    build_directory_info
    free_space = TOTAL_SIZE - total_size(slash)
    delete_at_least = NEEDED_FREE - free_space

    all_sizes.filter{ |s| s >= delete_at_least }.min
  end
end

TEST_INPUT = <<~END
$ cd /
$ ls
dir a
14848514 b.txt
8504156 c.dat
dir d
$ cd a
$ ls
dir e
29116 f
2557 g
62596 h.lst
$ cd e
$ ls
584 i
$ cd ..
$ cd ..
$ cd d
$ ls
4060174 j
8033020 d.log
5626152 d.ext
7214296 k
END

puts 95437 == NoSpace.new(TEST_INPUT).answer
puts NoSpace.new.answer

puts 24933642 == NoSpace.new(TEST_INPUT).answer2
puts NoSpace.new.answer2
