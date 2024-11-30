$defaultExiftoolPath = "C:\exiftool-12.77\exiftool.exe"
$defaultDirectory = "C:\Users\User\Downloads"

function Get-ExifToolPath {
    Add-Type -AssemblyName System.Windows.Forms
    $dialog = New-Object System.Windows.Forms.OpenFileDialog
    $dialog.Filter = "Executable Files (*.exe)|*.exe"
    $dialog.Title = "Please select the ExifTool executable file"
    $dialog.InitialDirectory = [System.IO.Path]::GetDirectoryName($defaultExiftoolPath)

    if ($dialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        return $dialog.FileName
    } else {
        return $defaultExiftoolPath
    }
}

function Get-WorkingDirectory {
    Add-Type -AssemblyName System.Windows.Forms
    $dialog = New-Object System.Windows.Forms.OpenFileDialog
    $dialog.Filter = "Select Folder|*.none"
    $dialog.Title = "Please select the working directory"
    $dialog.CheckFileExists = $false
    $dialog.CheckPathExists = $true
    $dialog.FileName = "Select Folder"

    if ($dialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        return [System.IO.Path]::GetDirectoryName($dialog.FileName)
    } else {
        return $defaultDirectory
    }
}

$exiftoolPath = Get-ExifToolPath
$directory = Get-WorkingDirectory

Get-ChildItem -Path $directory -Filter "*.jpg" -File | ForEach-Object {
    & $exiftoolPath "-FileName<DateTimeOriginal" "-d" "%Y%m%d_%H%M%S%%-c.%%e" $_.FullName
}

Write-Host "File renaming is complete."