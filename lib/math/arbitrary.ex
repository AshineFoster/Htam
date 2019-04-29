defmodule Math.AP do
  @moduledoc """
  Support for arbitrary precision calculation of some math functions and constants.
  """
  @doc """
  Returns π rounded to the number of decimal digits passed in.
  Maximum number of decimal places is 1000. Default is 10 decimal places.

  ## Examples

      iex> Math.AP.pi
      #Decimal<3.1415926536>

      iex> Math.AP.pi 30
      #Decimal<3.141592653589793238462643383280>
  """
  def pi(disp \\ 10) do
    chudnovsky(disp)
  end

  defp chudnovsky(disp) when is_integer(disp) and (disp < 0 or disp > 1000) do
    raise(
      ArgumentError,
      "Cannot display value to #{disp} decimal places; range 0 to 1000 inclusive."
    )
  end

  defp chudnovsky(disp) when is_integer(disp) do
    max_k = 80
    prec = 1008
    Decimal.set_context(%Decimal.Context{precision: prec})
    values = {6, 1, 13_591_409, 1, 13_591_409}
    sum = calculate_inter_val(1, max_k, values)

    Decimal.mult(426_880, Decimal.sqrt(10005))
    |> Decimal.div(sum)
    |> Decimal.round(disp)
  end

  defp chudnovsky(_) do
    raise(ArgumentError, "Unknown argument type. Enter an integer from 0 to 1000")
  end

  defp calculate_inter_val(counter, max_k, {_k, _m, _l, _x, s}) when counter == max_k do
    s
  end

  defp calculate_inter_val(counter, max_k, {k, m, l, x, s}) do
    val_cubed = &(&1 * &1 * &1)
    m = ((val_cubed.(k) - 16 * k) * m) |> div(val_cubed.(counter))
    l = l + 545_140_134
    x = x * -262_537_412_640_768_000
    s = Decimal.mult(m, l) |> Decimal.div(x) |> Decimal.add(s)
    k = k + 12
    calculate_inter_val(counter + 1, max_k, {k, m, l, x, s})
  end

  @doc """
  Returns tau rounded to the number of decimal digits passed in.
  Maximum number of decimal places is 1000. Default is 10 decimal places.

  ## Examples

      iex> Math.AP.tau
      #Decimal<6.2831853072>

  """
  def tau(prec \\ 10) do
    pi(prec) |> Decimal.mult(2)
  end

  @doc """
  Finds the square root of a number to a particular precision.

  ## Examples

        iex> Math.AP.sqrt(2, 10)
        #Decimal<1.414213562>

        iex> Math.AP.sqrt(2, 15) 
        #Decimal<1.41421356237310>
  """
  def sqrt(num, prec) do
    Decimal.set_context(%Decimal.Context{precision: prec})
    Decimal.sqrt(num)
  end

  @doc """
  Returns the mathematical constant ℯ rounded to the number of decimal digits passed in.
  Maximum number of decimal places is 1000. Default is 10 decimal places.

  ## Examples

      iex> Math.AP.e
      #Decimal<2.7182818285>

      iex> Math.AP.e(30)
      #Decimal<2.718281828459045235360287471353>

  """
  @iter 500
  @prec 1000

  def e(disp \\ 10) do
    calculate_e(disp)
  end

  defp calculate_e(disp) when is_integer(disp) and (disp < 0 or disp > 1000) do
    raise(
      ArgumentError,
      "Cannot display ℯ to #{disp} decimal places; range: 0 to 1000 inclusive."
    )
  end

  defp calculate_e(disp) when is_integer(disp) do
    Decimal.set_context(%Decimal.Context{precision: @prec})
    {pre_sum, fact} = fact_div_fact_two()

    (pre_sum + 2 * fact + @iter + 1)
    |> Decimal.div(fact)
    |> Decimal.round(disp)
  end

  defp calculate_e(_) do
    raise(ArgumentError, "Unknown argument type. Enter an integer from 0 to 1000")
  end

  defp fact_div_fact_two(n \\ @iter, sum \\ 0, fact_to_2 \\ 1)

  defp fact_div_fact_two(n, sum, fact_to_2) when n == 2 do
    {sum, fact_to_2 * 2}
  end

  defp fact_div_fact_two(n, sum, fact_to_2) do
    fact_to_2 = fact_to_2 * n
    sum = sum + fact_to_2
    fact_div_fact_two(n - 1, sum, fact_to_2)
  end
end
