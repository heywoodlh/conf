# Disable desktop icons
New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideIcons" -Value 1 -PropertyType DWORD -Force
# Smaller taskbar
New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarSi" -Value 0 -PropertyType DWORD -Force
