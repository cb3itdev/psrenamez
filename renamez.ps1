

#string table for replacements
#left side is .Value and needs double blackslashes  \\\\lwpparsdxr01\\data
#right side is .Key and does not need double backslashes   \\10.9.60.71\aus360wp01
$lookupTable = @{(Get-Content "$($pwd)\renamez.ini")}

Write-Host
$lookupTable[3]




$fileTypes = '*.ord'



#grab directory/file from drag&drop
$filePath = $args[0]
#if no folder dropped set to c:\users\usernamehere\downloads\temp
IF ($filePath -eq $null)
{$filePath = "$env:userprofile\Downloads\temp"}

Write-Host
'Looking for files under ' + $filePath




#$filePathTest = Test-Path $filePath





#get directory listing from $filesPath var
#if Test-Path
$fileArray = (Get-ChildItem -Recurse $filePath -Filter $fileTypes).fullname

Write-Host
$fileArray



#parse each file from $fileArray as line item
foreach($fileEach in $fileArray)
{
	#read in file
	(Get-Content $fileEach) | foreach-object {
		$line = $_
		#process each line
		$lookupTable.GetEnumerator() | ForEach-Object {
			#search for strings in line
			if ($line -match $_.Key)
			{
				#actually replace stuff based on lookuptable
				$line = $line -replace $_.Key, $_.Value
			}
		}
		$line
	} | set-content $fileEach
}
