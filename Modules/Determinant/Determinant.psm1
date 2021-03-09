using namespace System.Net

function Determinant
{
    param($Request, $TriggerMetadata)
    
    if (-not ($size = $Request.Query.Size)) { $size = 5 }
    
    $matrix = generateMatrix -size $size
    
    $Body = getStyle
    
    $Body += formatMatrix -matrix $matrix -size $size
    
    $det = calculateDeterminant -matrix $matrix
    
    $Body += "<p>det = <span style=`"font-size: 1.5em`">$det</span></p>"
    
    Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = [HttpStatusCode]::OK
        Body = $Body
        ContentType = "text/html"
    })
}

Export-ModuleMember -Function Determinant, calculateDeterminant, generateMatrix, subMatrix, formatMatrix, getOne, getStyle