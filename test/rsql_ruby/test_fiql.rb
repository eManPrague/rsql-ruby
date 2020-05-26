gem 'minitest'
require 'minitest/autorun'
require 'rsql_ruby'

module TestRsqlRuby; end

class TestRsqlRuby::TestFiql < Minitest::Test
  def test_basic_expressions
    parser = RsqlRuby::Parser.new

    {
      "a=eq=b": { type: :CONSTRAINT, selector: 'a', comparsion: '=eq=', argument: 'b' },
      "a=custom=b": { type: :CONSTRAINT, selector: 'a', comparsion: '=custom=', argument: 'b' },
      "a==b": { type: :CONSTRAINT, selector: 'a', comparsion: '==', argument: 'b' },
      "a==2018-09-01T12:14:28Z": { type: :CONSTRAINT, selector: 'a', comparsion: '==', argument: '2018-09-01T12:14:28Z' },
      "a!=b": { type: :CONSTRAINT, selector: 'a', comparsion: '!=', argument: 'b' },
      "field=op=(item0,item1,item2)": { type: :CONSTRAINT, selector: 'field', comparsion: '=op=', argument: ['item0', 'item1', 'item2'] },
    }.each do |key, output|
      assert_equal(parser.parse(key.to_s), output)
    end
  end

  def test_combinations
    {
      "a=eq=b;c=ne=d" => {
        type: :COMBINATION,
        operator: :AND,
        lhs: { type: :CONSTRAINT, selector: 'a', comparsion: '=eq=', argument: 'b' },
        rhs: { type: :CONSTRAINT, selector: 'c', comparsion: '=ne=', argument: 'd' },
      },
      "a=eq=b;c=ne=d;e=gt=f" => {
        type: :COMBINATION,
        operator: :AND,
        lhs: { type: :CONSTRAINT, selector: 'a', comparsion: '=eq=', argument: 'b' },
        rhs: {
          type: :COMBINATION,
          operator: :AND,
          lhs: { type: :CONSTRAINT, selector: 'c', comparsion: '=ne=', argument: 'd' },
          rhs: { type: :CONSTRAINT, selector: 'e', comparsion: '=gt=', argument: 'f' }
        }
      },
      "a=eq=b,c=ne=d" => {
        type: :COMBINATION,
        operator: :OR,
        lhs: { type: :CONSTRAINT, selector: 'a', comparsion: '=eq=', argument: 'b' },
        rhs: { type: :CONSTRAINT, selector: 'c', comparsion: '=ne=', argument: 'd' },
      },
      "a=eq=b,c=ne=d,e=gt=(f,g,c)" => {
        type: :COMBINATION,
        operator: :OR,
        lhs: { type: :CONSTRAINT, selector: 'a', comparsion: '=eq=', argument: 'b' },
        rhs: {
          type: :COMBINATION,
          operator: :OR,
          lhs: { type: :CONSTRAINT, selector: 'c', comparsion: '=ne=', argument: 'd' },
          rhs: { type: :CONSTRAINT, selector: 'e', comparsion: '=gt=', argument: ['f', 'g', 'c'] }
        }
      },
      "a=eq=b;c=ne=d,e=gt=f" => { # OR BEFORE AND
        type: :COMBINATION,
        operator: :OR,
        lhs: {
          type: :COMBINATION,
          operator: :AND,
          lhs: { type: :CONSTRAINT, selector: 'a', comparsion: '=eq=', argument: 'b' },
          rhs: { type: :CONSTRAINT, selector: 'c', comparsion: '=ne=', argument: 'd' }
        },
        rhs: { type: :CONSTRAINT, selector: 'e', comparsion: '=gt=', argument: 'f' },
      },
      'a=eq=b;(c=ne=d,e=gt=f)' => { # GROUPING
        type: :COMBINATION,
        operator: :AND,
        lhs: { type: :CONSTRAINT, selector: 'a', comparsion: '=eq=', argument: 'b' },
        rhs: {
          type: :COMBINATION,
          operator: :OR,
          lhs: { type: :CONSTRAINT, selector: 'c', comparsion: '=ne=', argument: 'd' },
          rhs: { type: :CONSTRAINT, selector: 'e', comparsion: '=gt=', argument: 'f' }
        }
      }
    }.each do |key, output|
      assert_equal(RsqlRuby.parse(key.to_s), output)
    end
  end

end