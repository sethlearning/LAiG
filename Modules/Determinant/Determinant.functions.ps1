function calculateDeterminant
{
    Param(
        [array]$matrix
    )

    $size = $matrix.Length

    if ($size -eq 2)
    {
        return $matrix[0][0] * $matrix[1][1] - $matrix[0][1] * $matrix[1][0]
    }
    else
    {
        $det = 0;

        for ($i = 0; $i -lt $size; $i++)
        {
            $one = getOne -i $i

            $subMatrix = subMatrix -matrix $matrix -element $i
            $det += $matrix[0][$i] * $one * (calculateDeterminant -matrix $subMatrix)
        }
    }
    return $det
}

function subMatrix
{
    Param(
        [array]$matrix,
        [int]$element
    )

    $size = $matrix.Length
    
    $subMatrix = [array]::CreateInstance([array], $size-1)
    
    for ($i = 1; $i -lt $size; $i++)
    {
        $k = 0
        for ($j = 0; $j -lt $size; $j++)
        {
            if ($j -eq 0) { $subMatrix[$i-1] = [array]::CreateInstance([int], $size-1) }
            if ($j -eq $element) { continue }

            $subMatrix[$i-1][$k] = $matrix[$i][$j]
            $k++
        }
    }

    return $subMatrix
}

function generateMatrix
{
    Param(
        [int]$size
    )

    $matrix = [array]::CreateInstance([array], $size)

    for ($i = 0; $i -lt $size; $i++)
    {
        for ($j = 0; $j -lt $size; $j++)
        {
            if ($j -eq 0) { $matrix[$i] = [array]::CreateInstance([int], $size) }
            $matrix[$i][$j] = Get-Random -Minimum 0 -Maximum 99
        }
    }

    return $matrix
}

function formatMatrix
{
    Param(
        [array]$matrix,
        [int]$size
    )

    $result = ""
    $result += "<table>`n"

    for ($i = 0; $i -lt $size; $i++)
    {
        $result += "<tr>`n"

        for ($j = 0; $j -lt $size; $j++)
        {
            $result += "<td>$($matrix[$i][$j].ToString())</td>`n"
        }

        $result += "</tr>`n"
    }

    $result += "</table>`n"

    return $result
}

function getOne
{
    Param(
        [int]$i
    )

    if ($i % 2) # i+j is odd
    {
        return -1
    }
    else
    {
        return 1
    }
}

function getStyle
{
    Param()

    return "<style>
        table, th, td {
            font-family: Arial, Verdana, Helvetica, sans-serif;
            font-size: 1.3em;
            text-align: center;
            border: 1px solid darkgray;
            border-collapse: collapse;
            padding: 8px;
        }

        p {
            font-family: Arial, Verdana, Helvetica, sans-serif;
            font-size: 1.3em;
            text-align: left;
            padding: 10px;
        }
        </style>"
}
