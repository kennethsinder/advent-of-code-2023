# typed: strict
# frozen_string_literal: true

require 'sorbet-runtime'

module Day1
  # Parsed result for a given row as part of the Day 1 solution.
  class ParsedRow < T::Struct
    const :calibration_value, Integer, default: 0
  end

  # Final result for the Day 1 solution.
  class Result < T::Struct
    const :total_calibration_value, Integer, default: 0
  end

  # Day 1 solution logic.
  class Solution
    extend T::Sig

    sig { params(rows: T::Array[String]).void }
    def initialize(rows)
      @rows = T.let(rows, T::Array[String])
    end

    @@text_to_digit = T.let({
      'one' => '1',
      'two' => '2',
      'three' => '3',
      'four' => '4',
      'five' => '5',
      'six' => '6',
      'seven' => '7',
      'eight' => '8',
      'nine' => '9'
    }.freeze, T::Hash[String, String])

    sig { params(str: T.nilable(String)).returns(T::Boolean) }
    def self.digit?(str)
      !!str && str.to_i.to_s == str
    end

    sig { params(row: String).returns(ParsedRow) }
    def self.parse_row(row)
      # To handle Part B of the problem, replace text representations of digits
      # 1-9 with the digit strings and otherwise run the same algorithm as
      # Part A below. We want to eagerly perform replacements from left to
      # right for the 1st digit, and right to left for the 2nd digit.
      ascending_row = row.dup
      descending_row = row.dup
      row.length.times.each do |i|
        @@text_to_digit.each do |text, digit|
          if ascending_row[i..].to_s.start_with?(text)
            ascending_row = ascending_row[..i].to_s + ascending_row[i..].to_s.sub(text,
                                                                                  digit)
          end

          j = descending_row.length - i - 1
          if descending_row[j..].to_s.start_with?(text)
            descending_row = descending_row[..j].to_s + descending_row[j..].to_s.sub(text,
                                                                                     digit)
          end
        end
      end
      first_digit = ascending_row.split('').filter_map do |character|
        character.to_i if digit?(character)
      end.first

      last_digit = descending_row.split('').reverse.filter_map do |character|
        character.to_i if digit?(character)
      end.first

      # The calibration value is defined as the first digit in a given row
      # concatenated with the last digit in the row (e.g. "1" + "2" --> 12)
      calibration_value = "#{first_digit}#{last_digit}".to_i

      ParsedRow.new(
        calibration_value:
      )
    end

    sig { params(parsed_rows: T::Array[ParsedRow]).returns(Result) }
    def self.combine_result(parsed_rows)
      parsed_rows.reduce(Result.new) do |accumulated_result, parsed_row|
        Result.new(
          total_calibration_value: accumulated_result.total_calibration_value + \
            parsed_row.calibration_value
        )
      end
    end

    sig { returns(Result) }
    def solve
      parsed_rows = @rows.map do |row|
        self.class.parse_row(row)
      end

      self.class.combine_result(parsed_rows)
    end

    sig { params(path: String).returns(T::Array[String]) }
    def self.read_rows_from_file(path)
      rows = T::Array[String].new

      File.open(path, 'r') do |f|
        f.each_line do |line|
          rows << line
        end
      end

      rows
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  solution = Day1::Solution.new(Day1::Solution.read_rows_from_file('day/1/input.txt'))
  puts solution.solve.serialize
end
