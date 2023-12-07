# typed: strict
# frozen_string_literal: true

require 'sorbet-runtime'

# Advent of code Day 4 solution code.
module Day4
  extend T::Sig

  # ------------------------------------------------------------------------- #
  # Part A                                                                    #
  # ------------------------------------------------------------------------- #

  sig do
    params(
      winning_numbers: T::Array[String],
      card_numbers: T::Array[String]
    ).returns(Integer)
  end
  def self.points_for_card(winning_numbers:, card_numbers:)
    points = 0

    card_numbers.each do |card_number|
      if winning_numbers.include?(card_number)
        if points.zero?
          points = 1
        else
          points *= 2
        end
      end
    end

    points
  end

  sig { params(card_lines: T::Array[String]).returns(Integer) }
  def self.points_for_cards(card_lines)
    total_points = 0

    card_lines.each do |card_line|
      first, second = card_line.split(' | ')
      winning_numbers = first.to_s.split(' ').drop(2)
      card_numbers = second.to_s.split(' ')

      total_points += points_for_card(winning_numbers:, card_numbers:)
    end

    total_points
  end

  # ------------------------------------------------------------------------- #
  # Part B                                                                    #
  # ------------------------------------------------------------------------- #

  sig do
    params(
      winning_numbers: T::Array[String],
      card_numbers: T::Array[String]
    ).returns(Integer)
  end
  def self.matches_for_card(winning_numbers:, card_numbers:)
    card_numbers.count do |card_number|
      winning_numbers.include?(card_number)
    end
  end

  sig { params(card_lines: T::Array[String]).returns(Integer) }
  def self.total_cards(card_lines)
    num_cards_per_number = {}

    card_lines.each do |card_line|
      card_number = card_line.split(' ')[1].to_s.split(':')[0].to_i
      num_cards_per_number[card_number] ||= 0
      num_cards_per_number[card_number] += 1
    end

    card_lines.each do |card_line|
      card_number = card_line.split(' ')[1].to_s.split(':')[0].to_i

      first, second = card_line.split(' | ')
      winning_numbers = first.to_s.split(' ').drop(2)
      card_numbers = second.to_s.split(' ')

      num_copies = num_cards_per_number[card_number]
      num_matches = matches_for_card(winning_numbers:, card_numbers:)

      num_matches.times.each do |i|
        num_cards_per_number[card_number + i + 1] += num_copies
      end
    end

    num_cards_per_number.values.sum
  end

  # ------------------------------------------------------------------------- #
  # Common                                                                    #
  # ------------------------------------------------------------------------- #

  sig { params(path: String).returns(T::Array[String]) }
  def self.card_lines_from_file(path)
    card_lines = T::Array[String].new

    File.open(path, 'r') do |f|
      f.each_line do |line|
        card_lines << line
      end
    end

    card_lines
  end
end

if __FILE__ == $PROGRAM_NAME
  card_lines = Day4.card_lines_from_file('day/4/input.txt')
  total_points = Day4.points_for_cards(card_lines)
  puts(total_points)
  total_cards = Day4.total_cards(card_lines)
  puts(total_cards)
end
