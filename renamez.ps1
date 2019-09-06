#make sure we have localized path for ini file
$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path



#string table for replacements
#left side is .Value and needs double blackslashes  \\\\lwpparsdxr01\\data
#right side is .Key and does not need double backslashes   \\10.9.60.71\aus360wp01
#$lookupTable = Import-PowerShellDataFile "$scriptDir\renamez.ini"

#Write-Host $lookupTable



$lookupTable = @{

#lvservers
"\\\\lwpparsdxr01\\data" = "\\10.9.60.71\aus360wp01\lwpparsdxr01\data"
"\\\\lwpparsdxr01\\I" = "\\10.9.60.71\aus360wp01\lwpparsdxr01\data"
"\\\\lwpparsdxr05\\data" = "\\10.9.60.71\aus360wp01\lwpparsdxr05\data"
"\\\\lwpparsdxr05\\I" = "\\10.9.60.71\aus360wp01\lwpparsdxr05\data"
"\\\\lwpparsdxr09\\data" = "\\10.9.60.71\aus360wp01\lwpparsdxr09\data"
"\\\\lwpparsdxr09\\I" = "\\10.9.60.71\aus360wp01\lwpparsdxr09\data"
"\\\\lwpparsdxr11\\data" = "\\10.9.60.71\aus360wp01\lwpparsdxr11\data"
"\\\\lwpparsdxr11\\I" = "\\10.9.60.71\aus360wp01\lwpparsdxr11\data"
"\\\\lwpparsdxr18\\data" = "\\10.9.60.71\aus360wp01\lwpparsdxr18\data"
"\\\\lwpparsdxr18\\I" = "\\10.9.60.71\aus360wp01\lwpparsdxr18\data"
"\\\\LWPPARSDXR18\\Ddrive\\data" = "\\10.9.60.71\aus360wp01\lwpparsdxr18\data"
"\\\\lwpparsdxr21\\data" = "\\10.9.60.71\aus360wp01\lwpparsdxr21\data"
"\\\\lwpparsdxr21\\I" = "\\10.9.60.71\aus360wp01\lwpparsdxr21\data"
"\\\\lwpparsdxr22\\data" = "\\10.9.60.71\aus360wp01\lwpparsdxr22\data"
"\\\\lwpparsdxr22\\I" = "\\10.9.60.71\aus360wp01\lwpparsdxr22\data"
"\\\\lwpparsdxr26\\data" = "\\10.9.60.71\aus360wp01\lwpparsdxr26\data"
"\\\\lwpparsdxr26\\I" = "\\10.9.60.71\aus360wp01\lwpparsdxr26\data"
"\\\\lwpparsdxr34\\data" = "\\10.9.60.71\aus360wp01\lwpparsdxr34\data"
"\\\\lwpparsdxr34\\I" = "\\10.9.60.71\aus360wp01\lwpparsdxr34\data"
"\\\\lwpparsdxr34\\d\\data" = "\\10.9.60.71\aus360wp01\lwpparsdxr34\data"
"\\\\lwpparsdxr43\\data" = "\\10.9.60.71\aus360wp01\lwpparsdxr43\data"
"\\\\lwpparsdxr43\\I" = "\\10.9.60.71\aus360wp01\lwpparsdxr43\data"
"\\\\lwpparsdxr44\\data" = "\\10.9.60.71\aus360wp01\lwpparsdxr44\data"
"\\\\lwpparsdxr44\\I" = "\\10.9.60.71\aus360wp01\lwpparsdxr44\data"
"\\\\lwpparsdxr45\\data" = "\\10.9.60.71\aus360wp01\lwpparsdxr45\data"
"\\\\lwpparsdxr45\\I" = "\\10.9.60.71\aus360wp01\lwpparsdxr45\data"

#prodmaster
"\\\\lwpparssmb01\\prodmaster\\jobs" = "\\10.9.60.71\aus360wp01\jobs"
"\\\\lwpparssmb01.ec.checkfree.com\\prodmaster\\jobs" = "\\10.9.60.71\aus360wp01\jobs"
"\\\\epsiia.com\\prodmaster\\jobs" = "\\10.9.60.71\aus360wp01\jobs"
"Z:\\jobs" = "\\10.9.60.71\aus360wp01\jobs"
"Z:\\rimage" = "\\10.9.60.71\aus360wp01\rimage"



#mopac paths
"\\\\app006\\i" = "\\10.9.60.71\aus360wp01\lwpparsdxr34\data"
"\\\\aus80pwstup002\\j" = "\\10.9.60.71\aus360wp01\lwpparsdxr43\data"
"\\\\app401\\i" = "\\10.9.60.71\aus360wp01\lwpparsdxr09\data"
"\\\\app004\\i" = "\\10.9.60.71\aus360wp01\lwpparsdxr21\data"
"D:\\data\\RUN\\Personix\\Integrasys" = "\\10.9.60.71\aus360wp01\lwpparsdxr01\data\RUN\Personix\Integrasys"

#special
"=\\\\" = "= \\"

}



#grab directory/file from drag&drop
$filePath = $args[0]

#if no folder dropped set to c:\users\usernamehere\downloads\temp
IF ($filePath -eq $null)
{$filePath = "$env:userprofile\Downloads\temp"}

$filePath = "$filePath\*"



Write-Host
"Looking for files under $filePath"



#$filePathTest = Test-Path $filePath


#get directory listing from $filesPath var
$fileArray = (Get-ChildItem -Path $filePath -Recurse -include @("*.ord", "*.nwp", "*.lst")).fullname


#Write-Host
#$fileArray


#parse each file from $fileArray as line item
foreach($fileEach in $fileArray)
{
	Write-Host $fileEach
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
