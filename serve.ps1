$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add('http://localhost:8080/')
$listener.Start()
Write-Host 'Server running on http://localhost:8080'

while ($listener.IsListening) {
    $context = $listener.GetContext()
    $response = $context.Response
    $filename = $context.Request.Url.LocalPath
    if ($filename -eq '/') { $filename = '/index.html' }
    $filepath = Join-Path 'c:\Users\Sreeveena\OneDrive\Desktop\resource allotment' $filename.TrimStart('/')
    if (Test-Path $filepath) {
        $content = [System.IO.File]::ReadAllBytes($filepath)
        $response.ContentType = 'text/html; charset=utf-8'
        $response.ContentLength64 = $content.Length
        $response.OutputStream.Write($content, 0, $content.Length)
    } else {
        $response.StatusCode = 404
        $msg = [System.Text.Encoding]::UTF8.GetBytes('Not Found')
        $response.OutputStream.Write($msg, 0, $msg.Length)
    }
    $response.Close()
}
