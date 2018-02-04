defmodule Calc do

	def main() do
        input = IO.gets(">")
        input = String.replace(input, "\n", "")
	    input = String.replace(input, " ","")
        val = Calc.eval(to_charlist input)
	    IO.puts(val)
	    Calc.main
	end

    def eval(input) do
        input |> convertString([], 0) |> evaluate([], [])
    end

    def convertString([], operators, operands) do     
        if(List.last(operators) == ')') do
            operators
        else
            operators ++ [operands]
        end
    end

    def convertString([h | rest], operators, operands) do

        if(h in '0123456789') do
           convertString(rest, operators, operands * 10 + (h - ?0))
        else
            if(h in '()') do
                if(h == ?() do
                   convertString(rest, operators ++ ['('], 0)
                else
                   convertString(rest, operators ++ [operands,')'], 0)
                end
            else
                symbolFunction = case h do
		            ?+ -> &+/2
		            ?- -> &-/2
		            ?* -> &*/2
		            ?/ -> &//2
        		end

		        if(List.last(operators) == ')') do
		           convertString(rest, operators ++ [symbolFunction], 0)
		        else
		           convertString(rest, operators ++ [operands, symbolFunction], 0)
		        end
		    end
		end
    end

    def evaluate([], opertrStack, valueStack) do  
        findVal(opertrStack, valueStack, "final")
    end

    def evaluate([h | rest], opertrStack = [hStack | restStack], valueStack) when is_function(h, 2) do
        if(precedenceOrder(h) > precedenceOrder(hStack)) do
            evaluate(rest, [h | opertrStack], valueStack)
        else
            valueStackNew = findVal(hStack, valueStack, "first")
            evaluate(rest, [h | restStack], valueStackNew)
        end
    end

    def evaluate([h | rest], [], valueStack) when is_function(h, 2) do
        evaluate(rest, [h], valueStack)
    end

    def evaluate([h | rest], opertrStack, valueStack) when (h=='(' or h == ')' or is_number(h)) do
        
        if(is_number(h)) do
            
        	evaluate(rest, opertrStack, [h | valueStack])

        else

	        if(h == '(') do
	            evaluate(rest, [h | opertrStack], valueStack)
	        else
	            {opertrStack, valueStack} = findVal(opertrStack, valueStack, "braces")
	            evaluate(rest, opertrStack, valueStack) 
	        end
        end
    end

    def evaluate(_, _, _) do
        raise "Invalid Input"
    end
 
    def precedenceOrder(operator)  do
        cond do
            operator == '(' -> -1
            operator == &*/2 -> 1
            operator == &//2 -> 1
            operator == &+/2 -> 0 
            operator == &-/2 -> 0
            true -> raise "Invalid operator"
        end
    end

    def findVal([h| rest] , valueStack, braces) when braces == "braces" do
        if(h == '(') do
            {rest, valueStack}
        else
            [op2, op1 | restValueStack] = valueStack
            findVal(rest, [h.(op1,op2) | restValueStack], "braces")
        end
    end

    def findVal([] , [finalValue], final) when final == "final" do
        finalValue
    end

    def findVal([h | rest], [op2, op1 | valueStack_rest], "final") when is_function(h, 2)  do
        findVal(rest, [h.(op1,op2) | valueStack_rest], "final")
    end 

    def findVal(operator, [op2, op1 | valueStack_rest], "first") do
        [operator.(op1,op2) | valueStack_rest]
    end

    def findVal(_, _, _) do
        raise "Invalid Input"
    end
  
end
