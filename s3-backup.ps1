## Creator: Steve Cooke
## Use: Upload directory to S3, delete after $retention days.

## Set these
$aws_access_key = XXXXXXXXXXXXXXXXXXXX
$aws_secret_key = zzzzzzzzzzzzzzzzzzzzzz
$aws_s3_bucket  = backup-bucket
$directory      = /path/to/directory  <# .\path\to\directory #>
$retention      = 90

## System sets these
$date         = Get-Date -UFormat "%Y%m%d"
#$date.AddDays(-$retention)
$remotefolder = Write-Host ("{1}{2}" -f $directory,$date )
$oldremote    = Write-Host ("{1}{2}" -f $directory,$date.AddDays(-$retention )

## Backs up files
$results = Get-ChildItem $directory -Recurse
foreach ($path in $results) {
  Write-Host $path
  $filename = [System.IO.Path]::GetFileName($path)
  Write-S3Object -BucketName $aws_s3_bucket -File $path -Key $remotefolder/$filename -CannedACLName Private -AccessKey $aws_access_key -SecretKey $aws_secret_key

## Removes old files
Remove-S3Object -BucketName $aws_s3_bucket -Key $oldremote -AccessKey $aws_access_key -SecretKey $aws_secret_key
