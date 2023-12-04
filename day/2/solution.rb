# typed: strict
# frozen_string_literal: true

require 'sorbet-runtime'

# Day 2 solution and related classes (e.g. structs, enums).
module Day2
  extend T::Sig

  # ------------------------------------------------------------------------- #

  # Color of a cube.
  class Color < T::Enum
    extend T::Sig

    enums do
      Red = new('red')
      Green = new('green')
      Blue = new('blue')
    end
  end

  # ------------------------------------------------------------------------- #

  # A single move in a round within a game.
  class Move < T::Struct
    extend T::Sig

    const :color, Color
    const :number, Integer
  end

  # ------------------------------------------------------------------------- #

  # A single round within a game (consisting of moves per color).
  class Round < T::Struct
    extend T::Sig

    const :moves, T::Array[Move]
  end

  # ------------------------------------------------------------------------- #

  # Current state of a game's bag.
  class BagState < T::Struct
    extend T::Sig

    const :num_cubes, T::Hash[Color, Integer], factory: -> { {} }
    const :minimal_cubes_required, T::Hash[Color, Integer], factory: -> { {} }

    # Whether current bag state is valid.
    sig { returns(T::Boolean) }
    def valid?
      num_cubes.values.none?(&:negative?)
    end
  end

  # ------------------------------------------------------------------------- #

  # Indication of a "failed" round (not enough cubes to be valid).
  class RoundFailed < StandardError; end

  # ------------------------------------------------------------------------- #

  # Stateful representation of a single game
  class Game
    extend T::Sig

    sig { returns(Integer) }
    attr_reader :game_id

    sig { params(game_id: Integer, rounds: T::Array[Round]).void }
    def initialize(game_id:, rounds:)
      @game_id = T.let(game_id, Integer)
      @rounds = T.let(rounds, T::Array[Round])
      @bag_state = T.let(BagState.new, BagState)
    end

    # ----------------------------------------------------------------------- #

    sig { params(color: Color, number: Integer).void }
    def add_cubes(color:, number:)
      @bag_state.num_cubes[color] = @bag_state.num_cubes[color].to_i + number
    end

    # ----------------------------------------------------------------------- #

    sig { void }
    def play!
      round_failed = T.let(false, T::Boolean)

      @rounds.each do |round|
        round.moves.each do |move|
          # Take out the cubes.
          add_cubes(color: move.color, number: -move.number)

          # Update the minimal cubes required of a given color (Part Two).
          @bag_state.minimal_cubes_required[move.color] =
            T.must_because([move.number,
                            @bag_state.minimal_cubes_required[move.color]].compact.max) do
              'First input to .min is always non-nil'
            end
        end

        round_failed = true unless @bag_state.valid?

        round.moves.each do |move|
          # Put back the cubes.
          add_cubes(color: move.color, number: move.number)
        end
      end

      # If we've gone negative, stop the game and raise a RoundFailed exception.
      raise RoundFailed.new(game_id: @game_id) if round_failed
    end

    # ----------------------------------------------------------------------- #

    sig { returns(Integer) }
    def power
      @bag_state.minimal_cubes_required.values.reduce(&:*).to_i
    end
  end

  # ------------------------------------------------------------------------- #

  sig { params(lines: T::Array[String]).returns(T::Array[Game]) }
  def self.parse_games_from_lines(lines)
    lines.map do |line|
      game_id = line.split(' ').fetch(1).to_i
      rounds = line.split(': ').fetch(1).split(';').map do |round_str|
        moves = round_str.split(',').map do |move_str|
          move_arr = move_str.split

          number = move_arr.fetch(0).to_i
          color = Color.deserialize(move_arr.fetch(1))

          Move.new(color:, number:)
        end

        Round.new(moves:)
      end

      Game.new(game_id:, rounds:)
    end
  end

  # ------------------------------------------------------------------------- #

  sig { params(path: String).returns(T::Array[Game]) }
  def self.load_games_from_file(path)
    lines = T::Array[String].new

    File.open(path, 'r') do |f|
      f.each_line do |line|
        lines << line
      end
    end

    parse_games_from_lines(lines)
  end

  # ------------------------------------------------------------------------- #

  # Desired solution result (i.e. success of the games by ID).
  class Result < T::Struct
    extend T::Sig

    const :successful_game_ids, T::Array[Integer]
    const :failed_game_ids, T::Array[Integer]
    const :powers, T::Array[Integer]
  end

  # ------------------------------------------------------------------------- #

  # Day 2 solution logic.
  class Solution
    extend T::Sig

    sig { params(games: T::Array[Game]).void }
    def initialize(games)
      @games = T.let(games, T::Array[Game])
    end

    sig { returns(Result) }
    def solve
      failed_game_ids = T::Array[Integer].new
      successful_game_ids = T::Array[Integer].new

      @games.each do |game|
        game.add_cubes(color: Color::Red, number: 12)
        game.add_cubes(color: Color::Green, number: 13)
        game.add_cubes(color: Color::Blue, number: 14)

        game.play!
        successful_game_ids << game.game_id
      rescue RoundFailed
        failed_game_ids << game.game_id
      end

      powers = @games.map(&:power)

      Result.new(failed_game_ids:, successful_game_ids:, powers:)
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  solution = Day2::Solution.new(Day2.load_games_from_file('day/2/input.txt'))
  result = solution.solve
  puts result.successful_game_ids.sum
  puts result.powers.sum
end
