Start-Sleep -Seconds 3
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms
$screen = [System.Windows.Forms.SystemInformation]::VirtualScreen
$Bitmap = new-object System.Drawing.Bitmap ($screen.width),($screen.height)
$Size = New-object System.Drawing.Size ($screen.width),($screen.height)
$FromImage = [System.Drawing.Graphics]::FromImage($Bitmap)
$FromImage.CopyFromScreen(0,0,0,0,$Size,([System.Drawing.CopyPixelOperation]::SourceCopy))
$Bitmap.Save("C:\Users\systemizer\Videos\Debut\about.png", 
([system.drawing.imaging.imageformat]::png))