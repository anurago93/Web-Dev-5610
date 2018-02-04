defmodule CalcTest do
  use ExUnit.Case
  doctest Calc

  test "Simple Addition" do
    assert Calc.eval('23+4') == 27
  end
  test "Complex Calculation" do
    assert Calc.eval('10+20*10+(40/5)') == 218.0
  end
  test "Convert String function" do
    assert Calc.convertString('10+20*10+(40/5)',[],0) == [10, &:erlang.+/2, 20, &:erlang.*/2, 10, &:erlang.+/2, '(', 40, &:erlang.//2, 5, ')']
  end
  test "Evaluate function" do
    assert Calc.evaluate([1, &:erlang.+/2, 20, &:erlang.*/2, 10, &:erlang.+/2, '(', 40, &:erlang.//2, 10, ')'], [], []) == 205.0
  end
  test "Check precendence function" do
    assert Calc.precedenceOrder(&:erlang.//2) == 1
  end
  test "FindValue function" do
    assert Calc.findVal([&:erlang.+/2, '('], [24, 26], "braces") == {[], '2'}
  end
end
