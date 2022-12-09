require_relative 'advent_problem'

class TreeHouse < AdventProblem
  @day = 8

  def trees
    @trees ||= input.lines.map{ |l| l.strip.chars.map(&:to_i) }
  end

  def max_col
    @max_col ||= trees.first.count - 1
  end

  def max_row
    @max_row ||= trees.count - 1
  end

  def visible?(row, col)
    # edges are always visible
    return true if row == 0 or row == max_row or col == 0 or col == max_col
    height = trees[row][col]

    # left
    return true if trees[row][0..(col - 1)].all?{ |t| t < height }
    # right
    return true if trees[row][(col + 1)..max_col].all?{ |t| t < height }
    # above
    return true if trees[0..(row - 1)].map{ |r| r[col] }.all?{ |t| t < height }
    # below
    return true if trees[(row + 1)..max_row].map{ |r| r[col] }.all?{ |t| t < height }
    return false
  end

  def scenic_score(row, col, p = false)
    # edges always have a mult by 0
    return 0 if row == 0 or row == max_row or col == 0 or col == max_col
    height = trees[row][col]

    left = trees[row][0..(col - 1)].reverse
    right = trees[row][(col + 1)..max_col]
    above = trees[0..(row - 1)].map{ |r| r[col] }.reverse
    below = trees[(row + 1)..max_row].map{ |r| r[col] }

    # left_count =  [1,  left.take_until{ |t| t >= height }.count].max
    # right_count = [1, right.take_until{ |t| t >= height }.count].max
    # above_count = [1, above.take_until{ |t| t >= height }.count].max
    # below_count = [1, below.take_until{ |t| t >= height }.count].max
    left_count = left.index{ |t| t >= height }
    right_count = right.index{ |t| t >= height }
    above_count = above.index{ |t| t >= height }
    below_count = below.index{ |t| t >= height }

    left_count = left_count ? left_count + 1 : left.count
    right_count = right_count ? right_count + 1 : right.count
    above_count = above_count ? above_count + 1 : above.count
    below_count = below_count ? below_count + 1 : below.count


    if p
      puts "L:#{left_count} #{left.inspect}",
           "R:#{right_count} #{right.inspect}",
           "A:#{above_count} #{above.inspect}",
           "B:#{below_count} #{below.inspect}"
    end


    left_count * right_count * above_count * below_count

  end

  def answer
    visibility = trees.map.with_index do |tree_row, r|
      tree_row.map.with_index do |tree, c|
        visible?(r,c)
      end
    end
    # 0.upto(max_row) do |r|
    #   0.upto(max_col) do |c|
    #     print "#{visible?(r,c) ? `tput bold` : ''}#{trees[r][c]}#{`tput sgr0`} "
    #   end
    #   print "\n"
    # end
    visibility.flatten.filter(&:itself).count
  end

  def answer2
    # puts trees.map{ |r| r.join(" ") }
    # puts
    # 0.upto(max_row) do |r|
    #   0.upto(max_col) do |c|
    #     print "%3i" % [scenic_score(r,c)]
    #   end
    #   print "\n"
    # end
    # puts
    # scenic_score(1,2,true)
    # scenic_score(3,2,true)
    scores = 0.upto(max_row).map do |r|
      0.upto(max_col).map do |c|
        scenic_score(r,c)
      end
    end.flatten.max
  end
end

TEST_INPUT = <<~END
30373
25512
65332
33549
35390
END

test = TreeHouse.new(TEST_INPUT)
puts 21 == test.answer
puts test.answer

real = TreeHouse.new
puts real.answer

puts 8 == test.answer2
puts real.answer2
