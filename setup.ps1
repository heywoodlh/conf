# Cross-platform function to test symlink
function test-symlink($filePath) {
    # For Windows check if file is symlink using dir
    if ($isWindows) {
        (Get-ItemProperty "${filePath}").LinkType 2>$null
        $global:symcheck_code = $?
    } 
    # For everything not Windows, use BASH to check symlink
    else {
        bash -c "test -L ${filePath}"
        $global:symcheck_code = $?
    }
}

## Get file path/name
$script_path = $MyInvocation.MyCommand.Path

## Get parent of file
$working_dir = Split-Path ${script_path} -Parent

# Function to create symlinks in target directory
function create-symlink-in-dir($src_dir, $target_dir, $dot) {
    Get-ChildItem -Path "${src_dir}" | Foreach-Object {
        $file_path = $_
    
        $file_name = Split-Path -Path "${file_path}" -Leaf 
    
        $target_path = "${target_dir}/${dot}${file_name}"
    
        # If file exists at target path, but is not symbolic link, then rename it
        if (test-path "${target_path}") {
	    test-symlink "${target_path}"
    	    if(!${symcheck_code}) {
    	        write-output "${target_path} is not a symlink, renaming"
    	        move-item -verbose "${target_path}" "${target_path}.old"
    	    }
        }
    
        New-Item -ItemType SymbolicLink -Path "${target_path}" -Target "${file_path}" -ErrorAction silentlycontinue && write-output "Created symbolic link at ${target_path}"
    }
}

## For items in dotfiles
create-symlink-in-dir "${working_dir}/dotfiles" "${HOME}" "."
## For items in home 
create-symlink-in-dir "${working_dir}/home" "${HOME}"

## Windows specific symlink
if ($isWindows) {
    New-Item -ItemType SymbolicLink -Path "$env:HOME/vimfiles" -Target "${working_dir}/dotfiles/vim" -ErrorAction silentlycontinue
}
