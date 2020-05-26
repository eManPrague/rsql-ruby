gem 'minitest'
require 'minitest/autorun'
require 'rsql_ruby'

module TestRsqlRuby; end

class TestRsqlRuby::TestRsql < Minitest::Test
  def test_basic_expressions
    {
      'name=="Kill Bill";year=gt=2003' => {
        type: :COMBINATION,
        operator: :AND,
        lhs: { type: :CONSTRAINT, selector: 'name', comparsion: '==', argument: 'Kill Bill' },
        rhs: { type: :CONSTRAINT, selector: 'year', comparsion: '=gt=', argument: '2003' },
      },
      'name=="Kill;nam \'\'e=gt=Bill";year=gt=2003' => {
        type: :COMBINATION,
        operator: :AND,
        lhs: { type: :CONSTRAINT, selector: 'name', comparsion: '==', argument: 'Kill;nam \'\'e=gt=Bill' },
        rhs: { type: :CONSTRAINT, selector: 'year', comparsion: '=gt=', argument: '2003' },
      },
      'name==\'Kill;"name"=gt=Bill\',year=gt=2003' => {
        type: :COMBINATION,
        operator: :OR,
        lhs: { type: :CONSTRAINT, selector: 'name', comparsion: '==', argument: 'Kill;"name"=gt=Bill' },
        rhs: { type: :CONSTRAINT, selector: 'year', comparsion: '=gt=', argument: '2003' },
      },
      "name=in=('sci-fi','action');year=gt=2003" => {
        type: :COMBINATION,
        operator: :AND,
        lhs: { type: :CONSTRAINT, selector: 'name', comparsion: '=in=', argument: [ 'sci-fi', 'action' ] },
        rhs: { type: :CONSTRAINT, selector: 'year', comparsion: '=gt=', argument: '2003' },
      },
      'name=in="test \' \" name"' => {
        type: :CONSTRAINT,
        selector: 'name' ,
        comparsion: '=in=',
        argument: 'test \' \\" name',
      }
    }.each do |key, output|
      assert_equal(RsqlRuby.parse(key.to_s), output)
    end
  end
end