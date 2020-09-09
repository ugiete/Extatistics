defmodule Extatistics.Base do
    @moduledoc"""
    * Module to implement basic estatistics functions
    """

    defp trim(array, n) when rem(n, 2) == 0 do
        x = div(n, 2)
        
        array
        |> Enum.drop(x)
        |> Enum.drop(-x)
    end
    defp trim(array, n) when rem(n, 2) == 1 do
        lower = div(n, 2) + 1
        upper = div(n, 2)
        
        array
        |> Enum.drop(lower)
        |> Enum.drop(-upper)
    end

    defp calculate_weight(value, weight), do: value * weight

    defp deviation(value, reference), do: value - reference

    defp absolute_deviation(value, reference) do
        value
        |> deviation(reference)
        |> abs()
    end

    defp square_deviation(value, reference) do
        value
        |> deviation(reference)
        |> :math.pow(2)
    end

    # Média
    def mean(array),
        do: Enum.sum(array)/Enum.count(array)
    def mean(array, n) do
        # Média aparada
        array
        |> Enum.sort()
        |> trim(n)
        |> mean()
    end

    # Média Ponderada
    def weighted_mean(array) do
        sum = array
              |> Enum.map(fn {v, w} -> calculate_weight(v, w) end)
              |> Enum.sum()

        sum_weights = array
                      |> Enum.map(fn {_v, w} -> w end)
                      |> Enum.sum()
        
        sum / sum_weights
    end
    def weighted_mean(values, weights) do
        values
        |> Enum.zip(weights)
        |> weighted_mean()
    end

    def median(array) do
        #Mediana
        n = Enum.count(array)
        sorted = Enum.sort(array)

        case rem(n, 2) do
            0 -> (Enum.at(sorted, div(n, 2) - 1) + Enum.at(sorted, div(n, 2))) / 2
            _ -> Enum.at(sorted, div(n, 2))
        end
    end

    def weighted_median(array) do
        array
        |> Enum.map(fn {v, w} -> calculate_weight(v, w) end)
        |> Enum.sort()
        |> median()
    end
    def weighted_median(values, weights) do
        values
        |> Enum.zip(weights)
        |> weighted_median()
    end

    def abs_stdev(array) do
        # Desvio absoluto médio
        m = mean(array)

        array
        |> Enum.map(&(absolute_deviation(&1, m)))
        |> mean()
    end

    def variance(array) do
        m = mean(array)

        sum = array
              |> Enum.map(&(square_deviation(&1, m)))
              |> Enum.sum()
        
        sum / (Enum.count(array) - 1)
    end

    def stdev(array) do
        array
        |> variance()
        |> :math.sqrt()
    end

    def corr(array_a, array_b) do
        #Correlação de Pearson
        mean_a = mean(array_a)
        mean_b = mean(array_b)

        diff_a = Enum.map(array_a, &(deviation(&1, mean_a)))
        diff_b = Enum.map(array_b, &(deviation(&1, mean_b)))

        sum = diff_a
              |> Enum.zip(diff_b)
              |> Enum.map(fn {a, b} -> calculate_weight(a, b) end)
              |> Enum.sum()

        sqrt_a = array_a
                 |> Enum.map(&(square_deviation(&1, mean_a)))
                 |> Enum.sum()
                 |> :math.sqrt()

        sqrt_b = array_b
                 |> Enum.map(&(square_deviation(&1, mean_b)))
                 |> Enum.sum()
                 |> :math.sqrt()
        
        sum / (sqrt_a * sqrt_b)
    end

    def std_error(array) do
        # Erro padrão
        s = stdev(array)
        n = array
            |> Enum.count()
            |> :math.sqrt()
        
        s / n
    end
end