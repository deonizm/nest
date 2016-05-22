<# 
	Stores files and directories into respective directories 
		which use the naming scheme of PLEX Series & Season Based on TV Shows 
#>
function nest_plex {
	param(
		[string]$rx_match = "(.+)(S\d\d)(E\d\d).+", 
		[string]$rx_replace = "(.+)S\d\dE\d\d.+" 
	)
	write "Matching files by:	$rx_match"
	write "Replacing files by:	$rx_replace"
	$keepgoing = read-host "Continue? [Y/N]"
	if ($keepgoing -eq "n") {return "Discontinued"; }
	$titles = @();
	$finalpath = "";
	$counter = 0;
	ls e:\ |
	? { $_.name -match $rx_match } |
	% {
		$matched_name = split-path $_.fullName -Leaf;
		$name = $matched_name -replace $rx_replace, ('$1') -replace '\.', ' ';
		$name = $name.Trim();
		if ($titles -notcontains $name) { 
			$parentpath = split-path $_.fullName -Parent;
			$finalpath = "$parentpath\$name";
			mkdir $finalpath -ea 0; 
			$titles += $name; 
		}
		<#write "move into $finalpath, this $($_.fullName)"; #>
		move -Destination "$finalpath" -LiteralPath "$($_.fullName)";
		$counter = $counter + 1;
	}
	write "Total files moved: $counter";
}