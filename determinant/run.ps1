using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

<#
# Interact with query parameters or the body of the request.

$name = $Request.Query.Name
if (-not $name) {
    $name = $Request.Body.Name
}
#>

if (-not ($size = $Request.Query.Size))
{
    $size = 10
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

    # $result = $matrix[0][0].ToString() + " " + $matrix[0][1].ToString()

    return $result
}

function getStyle
{
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

function calculateDeterminant
{
    Param(
        [array]$matrix
    )

    $size = $matrix.Length

    if ($size -le 2)
    {
        return
    }
}

$matrix = generateMatrix -size $size

$Body = getStyle

$Body += formatMatrix -matrix $matrix -size $size

$Body += '<p>det = <span style="font-size: 1.5em">AAA</span></p>'

calculateDeterminant -matrix $matrix

# $html = ConvertTo-Html -Body $Body

Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body = $Body
    # Body = $html
    ContentType = "text/html"
})
