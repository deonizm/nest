<# 
	Stores files and directories into respective directories 
		which use specified search folder and search term 
#>
function nest_custom {
<# Test case: nest_custom -path "." -filter "horriblesubs" #>
	Param([string]$path, [string]$filter);
	$titles = @();
	ls $path "*$filter*" |
	% { 
		$item = ($_.name -replace '.*] (.+) -.*', '$1');
		$destination = ($path + $item); 
		if ($titles -notcontains $item) { 
			$titles += $item; 
			mkdir $destination -ea 0; 
		}
		Move-Item -destination "$destination" -literalpath "$($path + $_)" <# Important for literalpath to be 2nd #>
		write "$destination added $($path + $_)"
	}
}