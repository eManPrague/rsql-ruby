# RSQL parser

class RsqlRuby::Parser
  prechigh
    left ';'
    left ','
  preclow
options
  no_result_var
rule
  target      : disjunction

  disjunction : conjuction OR_COMMA_OPERATOR disjunction { create_logical_operator(:OR, val[0], val[2]) }
              | conjuction

  conjuction  : constraint AND_OPERATOR conjuction { create_logical_operator(:AND, val[0], val[2]) }
              | constraint

  constraint  : selector COMPARATOR argument { create_constraint(val[0], val[1], val[2]) }
              | selector
              | OPENING_BRACKET disjunction CLOSING_BRACKET { val[1] }

  selector    : UNRESERVED

  argument    : array
              | value

  array       : OPENING_BRACKET contents CLOSING_BRACKET { val[1] }
              | OPENING_BRACKET CLOSING_BRACKET { [] }

  contents    : value { val }
              | contents OR_COMMA_OPERATOR value { val[0].push(val[2]); val[0] }

  value       : UNRESERVED
              | SINGLE_QUOTE SINGLE_QUOTED_STRING SINGLE_QUOTE { val[1] }
              | DOUBLE_QUOTE DOUBLE_QUOTED_STRING DOUBLE_QUOTE { val[1] }
end

---- header
  # Generated by racc
  require_relative 'lexer.rex'

---- inner

def create_logical_operator(operator, lhs, rhs)
  {
    type: :COMBINATION,
    operator: operator,
    lhs: lhs,
    rhs: rhs
  }
end

def create_constraint(selector, comparsion, argument)
  {
    type: :CONSTRAINT,
    selector: selector,
    comparsion: comparsion,
    argument: argument
  }
end

def create_array(string)

end

---- footer