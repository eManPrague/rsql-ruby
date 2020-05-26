module RsqlRuby

class Parser < Racc::Parser

macro
  BLANK         /(\ |\t)+/
  UNRESERVED    /[a-zA-Z0-9\-._~:]+/
  COMPARATOR    /!=|(=([a-z]|!)*=)/

  # Operator query
  AND_OPERATOR  /;/
  OR_COMMA_OPERATOR   /,/

  # String Parser
  SINGLE_QUOTE /'/
  DOUBLE_QUOTE /"/
  SINGLE_QUOTED_STRING /[^']+/
  DOUBLE_QUOTED_STRING /[^"]+/

  # Brakets
  OPENING_BRACKET /\(/
  CLOSING_BRACKET /\)/

rule
  /#{BLANK}/ # nothing to do 
  /#{UNRESERVED}/ { [:UNRESERVED, text] }

  /#{COMPARATOR}/ { [:COMPARATOR, text] }

  /#{OR_COMMA_OPERATOR}/ { [:OR_COMMA_OPERATOR, text] }
  /#{AND_OPERATOR}/ { [:AND_OPERATOR, text] }

  /#{OPENING_BRACKET}/ { [:OPENING_BRACKET, text] }
  /#{CLOSING_BRACKET}/ { [:CLOSING_BRACKET, text] }

                /#{SINGLE_QUOTE}/ { self.state = :SINGLE_QUOTE; [:SINGLE_QUOTE, text] }
  :SINGLE_QUOTE /#{SINGLE_QUOTED_STRING}/ { [:SINGLE_QUOTED_STRING, text] }
  :SINGLE_QUOTE /#{SINGLE_QUOTE}/ { self.state = nil; [:SINGLE_QUOTE, text] }

                /#{DOUBLE_QUOTE}/ { self.state = :DOUBLE_QUOTE; [:DOUBLE_QUOTE, text] }
  :DOUBLE_QUOTE /#{DOUBLE_QUOTED_STRING}/ { [:DOUBLE_QUOTED_STRING, text] }
  :DOUBLE_QUOTE /#{DOUBLE_QUOTE}/ { self.state = nil; [:DOUBLE_QUOTE, text] }

option

inner

end

end