$blacklist = "Default", "MSCTFIME"

Add-Type -TypeDefinition @"
    using System;
    using System.Drawing;
    using System.Runtime.InteropServices;
    using System.Text;
    using System.Windows.Forms;

    public class WinAPI {
        [DllImport("user32.dll")]
        public static extern bool EnumWindows(EnumWindowsProc lpEnumFunc, IntPtr lParam);

        [DllImport("user32.dll")]
        public static extern int GetWindowText(IntPtr hWnd, StringBuilder lpString, int nMaxCount);

        [DllImport("user32.dll")]
        public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);

        [DllImport("user32.dll")]
        public static extern bool SetForegroundWindow(IntPtr hWnd);

        [DllImport("user32.dll")]
        public static extern bool GetWindowRect(IntPtr hWnd, out RECT lpRect);

        public delegate bool EnumWindowsProc(IntPtr hWnd, IntPtr lParam);

        public struct RECT {
            public int Left;
            public int Top;
            public int Right;
            public int Bottom;
        }
    }
"@ -ReferencedAssemblies System.Windows.Forms

$Callback = [WinAPI+EnumWindowsProc] {
    param($hWnd, $lParam)

    $title = New-Object System.Text.StringBuilder 256
    if ([WinAPI]::GetWindowText($hWnd, $title, $title.Capacity) -gt 0 -and $title.ToString() -ne "" -and !($blacklist | Where-Object { $title.ToString().Contains($_) })) {
        Write-Host "Handle: $hWnd, Title: $($title.ToString())"
    }

    return $true
}

[WinAPI]::EnumWindows($Callback, [IntPtr]::Zero)

$hWnd = Read-Host "Enter the handle of the window to capture"

if ($hWnd -ne "") {
    $hWnd = [IntPtr]::new([System.Convert]::ToInt64($hWnd))

    [WinAPI]::ShowWindow($hWnd, 9)  # SW_RESTORE
    [WinAPI]::SetForegroundWindow($hWnd)

    Start-Sleep -Milliseconds 200

    $rect = New-Object WinAPI+RECT
    if ([WinAPI]::GetWindowRect($hWnd, [ref]$rect)) {
        $width = $rect.Right - $rect.Left
        $height = $rect.Bottom - $rect.Top

        $bmp = New-Object Drawing.Bitmap $width, $height
        $graphics = [Drawing.Graphics]::FromImage($bmp)
        $graphics.CopyFromScreen($rect.Left, $rect.Top, 0, 0, $bmp.Size)

        $bmp.Save("./screenshot.png")
    }
}