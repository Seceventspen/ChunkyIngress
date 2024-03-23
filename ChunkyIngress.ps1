function ChunkyIngress {
    param (
        [Parameter(HelpMessage = "Specify the path to input file")]
        [string]
        $filePath
    )

    $base64String = [Convert]::ToBase64String([IO.File]::ReadAllBytes($filePath))
    $chunkSize = 68KB  # Change this to whatever limit you want, in my case 68kb was the limit
    $chunkCount = [math]::Ceiling($base64String.Length / $chunkSize)

    for ($i = 0; $i -lt $chunkCount; $i++) {
        $startIndex = $i * $chunkSize
        $chunk = $base64String.Substring($startIndex, [math]::Min($chunkSize, $base64String.Length - $startIndex))
        Set-Clipboard -Value $chunk
        Write-Output "Chunk $i copied to clipboard. Press Enter to copy next chunk or Ctrl+C to exit."
        Read-Host
    }

    Write-Output "Total chunks created: $chunkCount"
}
