## Get file path/name
$script_path = $MyInvocation.MyCommand.Path

## Get parent of file
$working_dir = Split-Path ${script_path} -Parent

## For items in dotfiles
Get-ChildItem -Path "${working_dir}/dotfiles" | Foreach-Object {
    $file_path = $_

    $file_name = Split-Path -Path "${file_path}" -Leaf 

    New-Item -ItemType SymbolicLink -Path "$env:HOME/.${file_name}" -Target "${file_path}" -ErrorAction silentlycontinue
}

## For items in home 
Get-ChildItem -Path "${working_dir}/home" | Foreach-Object {
    $file_path = $_

    $file_name = Split-Path -Path "${file_path}" -Leaf 

    New-Item -ItemType SymbolicLink -Path "$env:HOME/${file_name}" -Target "${file_path}" -ErrorAction silentlycontinue
}

## Windows specific symlink
if ($isWindows) {
    New-Item -ItemType SymbolicLink -Path "$env:HOME/vimfiles" -Target "${working_dir}/dotfiles/vim" -ErrorAction silentlycontinue
}
