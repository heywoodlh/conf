$working_dir = Get-Location | Select-Object -ExpandProperty Path

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
