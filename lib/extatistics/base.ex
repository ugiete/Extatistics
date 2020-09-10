defmodule Extatistics.Base do
    @moduledoc """
    * Module to implement basic estatistics functions
    """

    @type twoNumTL() :: [{number, number}]
    @type numEnum() :: Enumerate.number()

    @doc """
    Apara o array em N posições, retirando:
     - N/2 no início e N/2 no final, caso N par
     - N/2 + 1 no início e N/2 no final, caso N ímpar
    
    ## Parâmetros

        - array: um enumerável
        - n: a quantidade de dados a serem aparados

    ## Exemplos

        iex > array = [10, 54, 12.71, "Sean", 0, [4.2,10]]
        iex > Extatistics.Base.trim(array, 4)
        [ 12.71, "Sean" ]

        iex> Extatistics.Base.trim(array, 3)
        [ 12.71, "Sean", 0 ]

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

    @doc """
    Calcula a influência do peso para seu valor

    ## Parâmetros
    
    - value: um valor
    - weight: o respectivo peso do valor

    ## Exemplos

        iex> Extatistics.Base.calculate_weight(5,4)
        20
    
    """
    defp calculate_weight(value, weight), do: value * weight

    @doc """
    Calcula a distância(desvio) de um valor e uma referência

    ## Parâmetros
    
    - value: um valor
    - reference: o respectivo peso do valor

    ## Exemplos

        iex> Extatistics.Base.deviation(5,4)
        1
    
    """
    defp deviation(value, reference), do: value - reference

    @doc """
    Calcula a distância(desvio) absoluta de um valor e uma referência

    ## Parâmetros
    
    - value: um valor
    - reference: o respectivo peso do valor

    ## Exemplos

        iex> Extatistics.Base.absolute_deviation(4,8)
        4
    
    """
    defp absolute_deviation(value, reference) do
        value
        |> deviation(reference)
        |> abs()
    end

    @doc """
    Calcula a distância(desvio) quadrática de um valor e uma referência

    ## Parâmetros
    
    - value: um valor
    - reference: o respectivo peso do valor

    ## Exemplos

        iex> Extatistics.Base.square_deviation(4,8)
        16
    
    """
    defp square_deviation(value, reference) do
        value
        |> deviation(reference)
        |> :math.pow(2)
    end

    @doc """
    Calcula a média aritmética dos dados de um enumerável.

    ## Parâmetros
    
    - array: um enumerável de números
    
    ## Exemplos

        iex> Extatistics.Base.mean([2,7,25,1,12.3,0.7])
        8.0
    """
    @spec mean(numEnum()) :: number()
    def mean(array),
        do: Enum.sum(array)/Enum.count(array)

    @doc """
    Calcula a média ponderada dos dados de um enumerável.

    Ordena os dados, apara-os e calcula a média com os dados restantes.

    ## Parâmetros
    
    - array: um enumerável de números
    - n: a quantidade de dados a serem aparados
    
    ## Exemplos

        iex> Extatistics.Base.mean([2,7,25,1,12.3,0.7], 2)
        5.575

    """
    @spec mean(numEnum(), number()) :: number()
    def mean(array, n) do
        array
        |> Enum.sort()
        |> trim(n)
        |> mean()
    end

    @doc """
    Calcula a média ponderada dos dados de um lista de tuplas.

    ## Parâmetros
    
    - array: uma lista de tuplas de números com o par {valor, peso}
    
    ## Exemplos

        iex> Extatistics.Base.weighted_mean([{1.5, 2}, {2, 0}, {5.84, 1}])
        2.9466666666666668
        
    """
    @spec weighted_mean(twoNumTL()) :: number() 
    def weighted_mean(array) do
        sum = array
              |> Enum.map(fn {v, w} -> calculate_weight(v, w) end)
              |> Enum.sum()

        sum_weights = array
                      |> Enum.map(fn {_v, w} -> w end)
                      |> Enum.sum()
        
        sum / sum_weights
    end

    @doc """
    Calcula a média ponderada dos dados de um array valor e um array peso.

    ## Parâmetros
    
    - values: um enumerável de valores
    - weight: um enumerável de pesos
    
    ## Exemplos

        iex> Extatistics.Base.weighted_mean([1.5, 2, 5.84],[2,0,1])
        2.9466666666666668

    """
    @spec weighted_mean(numEnum(), numEnum()) :: number()
    def weighted_mean(values, weights) do
        values
        |> Enum.zip(weights)
        |> weighted_mean()
    end

    @doc """
    Calcula a mediana de um enumerável.

    ## Parâmetros
    
    - array: um enumerável de números
    
    ## Exemplos

        iex> Extatistics.Base.median([4,2,10,-6,1,1.7])
        1.85

    """
    @spec median(numEnum()) :: number()
    def median(array) do
        n = Enum.count(array)
        sorted = Enum.sort(array)

        case rem(n, 2) do
            0 -> (Enum.at(sorted, div(n, 2) - 1) + Enum.at(sorted, div(n, 2))) / 2
            _ -> Enum.at(sorted, div(n, 2))
        end
    end

    @doc """
    Calcula a mediana ponderada dos dados de um lista de tuplas.

    ## Parâmetros
    
    - array: uma lista de tuplas de números com o par {valor, peso}
    
    ## Exemplos

        iex> Extatistics.Base.weighted_median([{4, 1}, {1.5, 5}, {5, 2}, {1.5, 2}, {4.7, 0}])
        4
        
    """
    @spec weighted_median(twoNumTL()) :: number() 
    def weighted_median(array) do
        array
        |> Enum.map(fn {v, w} -> calculate_weight(v, w) end)
        |> Enum.sort()
        |> median()
    end

    @doc """
    Calcula a mediana ponderada dos dados de um array valor e um array peso.

    ## Parâmetros
    
    - values: um enumerável de valores
    - weight: um enumerável de pesos
    
    ## Exemplos

        iex> Extatistics.Base.weighted_median([4,1.5,5,1.5,4.7],[1,5,2,2,0])
        4

    """
    @spec weighted_median(numEnum(), numEnum()) :: number()
    def weighted_median(values, weights) do
        values
        |> Enum.zip(weights)
        |> weighted_median()
    end

    @doc """
    Calcula o desvio absoluto médio de um enumerável.

    ## Parâmetros
    
    - array: um enumerável de números
    
    ## Exemplos

        iex> Extatistics.Base.abs_stdev([4,2,10,-6,1,1.7])
        3.255555555555556

    """
    @spec abs_stdev(numEnum()) :: number()
    def abs_stdev(array) do
        m = mean(array)

        array
        |> Enum.map(&(absolute_deviation(&1, m)))
        |> mean()
    end

    @doc """
    Calcula a variância de um enumerável
    
    ## Parâmetros
    
    - array: um enumerável de números
    
    ## Exemplos

        iex> Extatistics.Base.variance([4,2,10,-6,1,1.7])
        26.601666666666667

    """
    @spec variance(numEnum()) :: number()
    def variance(array) do
        m = mean(array)

        sum = array
              |> Enum.map(&(square_deviation(&1, m)))
              |> Enum.sum()
        
        sum / (Enum.count(array) - 1)
    end

    @doc """
    Calcula o desvio padrão de um enumerável

    ## Parâmetros
    
    - array: um enumerável de números
    
    ## Exemplos

        iex> Extatistics.Base.stdev([4,2,10,-6,1,1.7])
        5.157680357163157

    """
    @spec stdev(numEnum()) :: number()
    def stdev(array) do
        array
        |> variance()
        |> :math.sqrt()
    end

    @doc """
    Calcula o Coeficiente de Correlação de Pearson.

    ## Parâmetros

    - array_a: enumerável de números A
    - array_b: enumerável de números B

    ## Exemplos

        iex> Extatistics.Base.corr([4,1.5,5,1.5,4.7],[1,5,2,2,0])
        -0.6920927019297618
    """
    @spec pearson(numEnum(), numEnum()) :: number()
    def pearson(array_a, array_b) do
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

    @doc """
    Calcula o erro padrão de um enumerável

    ## Parâmetros
    
    - array: um enumerável de números
    
    ## Exemplos

        iex> Extatistics.Base.std_error([4,2,10,-6,1,1.7])
        2.105614188570905
        

    """
    @spec std_error(numEnum()) :: number()
    def std_error(array) do
        s = stdev(array)
        n = array
            |> Enum.count()
            |> :math.sqrt()
        
        s / n
    end
end