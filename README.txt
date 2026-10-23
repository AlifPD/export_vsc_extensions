========================================================================
PANDUAN EXPORT & IMPORT VS CODE EXTENSIONS
========================================================================

Folder ini digunakan untuk mem-backup extension VS Code menjadi file .vsix
dan meng-importnya ke PC lain secara offline.

------------------------------------------------------------------------
1. CARA EXPORT (Di PC Asal)
------------------------------------------------------------------------
Pilih salah satu cara berikut:

A. Lewat Windows PowerShell atau CMD:
   .\export_extensions.bat

B. Lewat PowerShell (Langsung file .ps1):
   powershell -ExecutionPolicy Bypass -File .\export_extensions.ps1

C. Lewat File Explorer:
   Cukup double-click file "export_extensions.bat"

D. Lewat Git Bash / Linux / macOS:
   ./export_extensions.sh

* Extension akan tersimpan otomatis di dalam folder: vsix_extensions
* Extension yang sudah pernah diexport (versi sama) akan otomatis di-skip.

------------------------------------------------------------------------
2. CARA PINDAH KE PC LAIN
------------------------------------------------------------------------
Copy seluruh folder ini (atau minimal folder vsix_extensions bersama
skrip import_extensions) ke PC tujuan.

------------------------------------------------------------------------
3. CARA IMPORT (Di PC Tujuan)
------------------------------------------------------------------------
Pastikan VS Code sudah terinstall di PC tujuan.
Pilih salah satu cara berikut:

A. Lewat Windows PowerShell atau CMD:
   .\import_extensions.bat

B. Lewat PowerShell (Langsung file .ps1):
   powershell -ExecutionPolicy Bypass -File .\import_extensions.ps1

C. Lewat File Explorer:
   Cukup double-click file "import_extensions.bat"

D. Lewat Git Bash / Linux / macOS:
   ./import_extensions.sh
========================================================================