# typed: strict
# frozen_string_literal: true

require 'sorbet-runtime'

# Solution result for Day 3.
class Result < T::Struct
  const :part_number_sum, Integer
  const :gear_ratio_sum, Integer
end

# Day 3 solution logic.
class Solution
  extend T::Sig

  sig { params(grid: T::Array[T::Array[String]]).void }
  def initialize(grid)
    @grid = T.let(grid, T::Array[T::Array[String]])
  end

  sig { params(str: T.nilable(String)).returns(T::Boolean) }
  private_class_method def self.digit?(str)
    !!str && str.to_i.to_s == str
  end

  sig { params(row: T.nilable(T::Array[String]), index: Integer).returns(T.nilable(Integer)) }
  def self.chomp_number(row:, index:)
    return nil if row.nil?

    number = row[index]

    return nil if number.nil?
    return nil unless digit?(number)

    row[index] = '.'

    i = index - 1
    while digit?(row[i])
      number = row[i].to_s + number
      row[i] = '.'
      i -= 1
    end

    i = index + 1
    while digit?(row[i])
      number += row[i].to_s
      row[i] = '.'
      i += 1
    end

    number.to_i
  end

  sig { params(row: Integer, col: Integer).returns(Result) }
  private def process_symbol(row:, col:)
    part_numbers = [
      self.class.chomp_number(row: @grid[row - 1], index: col - 1),
      self.class.chomp_number(row: @grid[row - 1], index: col),
      self.class.chomp_number(row: @grid[row - 1], index: col + 1),
      self.class.chomp_number(row: @grid[row], index: col - 1),
      self.class.chomp_number(row: @grid[row], index: col + 1),
      self.class.chomp_number(row: @grid[row + 1], index: col - 1),
      self.class.chomp_number(row: @grid[row + 1], index: col),
      self.class.chomp_number(row: @grid[row + 1], index: col + 1)
    ].compact

    part_number_sum = part_numbers.sum

    # If the part is a gear (signified by the symbol being a `*` and being
    # adjacent to exactly two part numbers), multiply the two integers
    # together to get the gear ratio and report this result as well for Part
    # Two of the problem.
    gear_ratio_sum = if @grid.dig(row, col) == '*' && part_numbers.length == 2
                       part_numbers.fetch(0) * part_numbers.fetch(1)
                     else
                       0
                     end

    Result.new(
      part_number_sum:,
      gear_ratio_sum:
    )
  end

  sig { returns(Result) }
  def solve
    part_number_sum = 0
    gear_ratio_sum = 0
    @grid.each_with_index do |entries, row|
      entries.each_with_index do |entry, col|
        next if entry.strip.empty?
        next if entry =~ /\d/i
        next if entry == '.'

        result_for_symbol = process_symbol(row:, col:)
        part_number_sum += result_for_symbol.part_number_sum
        gear_ratio_sum += result_for_symbol.gear_ratio_sum
      end
    end

    Result.new(
      part_number_sum:,
      gear_ratio_sum:
    )
  end

  sig { params(str: String).returns(T::Array[T::Array[String]]) }
  def self.build_grid(str)
    str.split("\n").map { _1.split('') }
  end

  sig { params(path: String).returns(T::Array[T::Array[String]]) }
  def self.build_grid_from_file(path)
    grid = T::Array[T::Array[String]].new

    File.open(path, 'r') do |f|
      f.each_line do |line|
        grid << line.split('')
      end
    end

    grid
  end
end

if __FILE__ == $PROGRAM_NAME
  solution = Solution.new(Solution.build_grid_from_file('day/3/input.txt'))
  puts solution.solve.serialize
end
