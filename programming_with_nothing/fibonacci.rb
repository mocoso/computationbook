# Ruby helpers for translating output
def to_integer(proc)
  proc[-> n { n + 1 }][0]
end

def to_boolean(proc)
  proc[true][false]
end

# Some numbers
ZERO    = -> p { -> x {             x      } }
ONE     = -> p { -> x {           p[x]     } }
TWO     = -> p { -> x {         p[p[x]]    } }
THREE   = -> p { -> x {       p[p[p[x]]]   } }
FOUR    = -> p { -> x {     p[p[p[p[x]]]]  } }
FIVE    = -> p { -> x {   p[p[p[p[p[x]]]]] } }

TRUE    = -> x { -> y { x } }
FALSE   = -> x { -> y { y } }

EQUALS_ZERO = -> n { n[-> x { FALSE }][TRUE] }

INCREMENT = -> n { -> p { -> x { n[p][p[x]] } } }

PAIR = -> l { -> r { -> p { p[l][r] } } }
LEFT = -> p { p[TRUE] }
RIGHT = -> p { p[FALSE] }

DECREMENT = -> n { LEFT[n[-> p { PAIR[RIGHT[p]][INCREMENT[RIGHT[p]]]} ][PAIR[ZERO][ZERO]]] }

ADD = -> a { -> b { a[INCREMENT][b] } }

# def decrement(n)
#   pair = [0, 0]
#   n.times do
#     pair = [pair[1], pair[1]++]
#   end
#   pair[0]
# end

FIB = -> n {
  LEFT[
    n[
      -> p {
        PAIR[
          RIGHT[p]
        ][
          ADD[LEFT[p]][RIGHT[p]]
        ]
      }
    ][
      PAIR[ONE][ONE]
    ]
  ]
}

describe 'to_integer' do
  it { to_integer(ZERO).should == 0 }
  it { to_integer(ONE).should == 1 }
  it { to_integer(TWO).should == 2 }
end

describe 'to_boolean' do
  it { to_boolean(TRUE).should == true }
  it { to_boolean(FALSE).should == false }
end

describe 'EQUALS_ZERO' do
  it { to_boolean(EQUALS_ZERO[ZERO]).should == true }
  it { to_boolean(EQUALS_ZERO[ONE]).should == false }
  it { to_boolean(EQUALS_ZERO[TWO]).should == false }
  it { to_integer(EQUALS_ZERO[ZERO][ONE][TWO]).should == 1 }
  it { to_integer(EQUALS_ZERO[ONE][ONE][TWO]).should == 2 }
end

describe 'LEFT' do 
  it { to_integer(LEFT[PAIR[ZERO][ONE]]).should == 0 }
end

describe 'RIGHT' do
  it { to_integer(RIGHT[PAIR[ZERO][ONE]]).should == 1 }
end

describe 'DECREMENT' do
  it { to_integer(DECREMENT[ONE]).should == 0 }
  it { to_integer(DECREMENT[TWO]).should == 1 }
end

describe 'FIB' do
  it { to_integer(FIB[ZERO]).should == 1 }
  it { to_integer(FIB[ONE]).should == 1 }
  it { to_integer(FIB[TWO]).should == 2 }
  it { to_integer(FIB[THREE]).should == 3 }
  it { to_integer(FIB[FOUR]).should == 5 }
  it { to_integer(FIB[FIVE]).should == 8 }
end

describe 'INCREMENT' do
  it { to_integer(INCREMENT[ZERO]).should == 1 }
  it { to_integer(INCREMENT[ONE]).should == 2 }
  it { to_integer(INCREMENT[TWO]).should == 3 }
end

describe 'ADD' do
  it { to_integer(ADD[TWO][ONE]).should == 3 }
end
