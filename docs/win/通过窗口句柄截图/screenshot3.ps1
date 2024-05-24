# 使用方式：powershell ./screenshot.ps1 -param "'窗口标题，注意这里带双引号和单引号'" -filename "截图文件名" 默认png格式
# by NoRain
# 2024/5/24

# 定义两个参数，如果没有提供，那么默认值为 ""
param(
    [Parameter(Mandatory=$false)]
    [string]$param = "",
    [Parameter(Mandatory=$false)]
    [string]$filename = "screenshot"
)

# 定义一个黑名单，包含了不需要处理的窗口标题
$blacklist = "Default", "MSCTFIME"

# 添加一个类型定义，包含了一些 Windows API 函数和结构
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

        [DllImport("user32.dll")]
        public static extern bool SetWindowPos(IntPtr hWnd, IntPtr hWndInsertAfter, int X, int Y, int cx, int cy, uint uFlags);

        public static readonly IntPtr HWND_TOPMOST = new IntPtr(-1);
        public static readonly IntPtr HWND_NOTOPMOST = new IntPtr(-2);
        public const uint SWP_NOMOVE = 0x0002;
        public const uint SWP_NOSIZE = 0x0001;

    }
"@ -ReferencedAssemblies System.Windows.Forms

# 添加一个类型定义，这个类型包含了一个静态方法，用来将文本转换为图片
Add-Type -TypeDefinition @"
using System;
using System.Drawing;
using System.Drawing.Imaging;

public class TextToImage {
    public static void CreateImage(string text, string filePath) {
        Font font = new Font("Arial", 20, GraphicsUnit.Pixel);
        SizeF textSize;

        using (Graphics g = Graphics.FromImage(new Bitmap(1, 1))) {
            textSize = g.MeasureString(text, font);
        }

        using (Bitmap bitmap = new Bitmap((int)textSize.Width, (int)textSize.Height))
        using (Graphics g = Graphics.FromImage(bitmap)) {
            g.Clear(Color.White);
            using (Brush brush = new SolidBrush(Color.Black)) {
                g.DrawString(text, font, brush, 0, 0);
                bitmap.Save(filePath, ImageFormat.Png);
            }
        }
    }
}
"@ -ReferencedAssemblies System.Drawing



# 定义一个变量，用来标记是否找到了需要的窗口
$found = $false

# 定义一个回调函数，这个函数会被 EnumWindows 函数调用
$Callback = [WinAPI+EnumWindowsProc] {
    param($hWnd, $lParam)

    # 创建一个 StringBuilder 对象，用来存储窗口的标题
    $title = New-Object System.Text.StringBuilder 256
    # 如果窗口的标题不为空，并且不在黑名单中
    if ([WinAPI]::GetWindowText($hWnd, $title, $title.Capacity) -gt 0 -and $title.ToString() -ne "" -and !($blacklist | Where-Object { $title.ToString().Contains($_) })) {
        # 如果没有提供参数，那么打印窗口的句柄和标题
        if($param -eq ""){
            Write-Host "Handle: $hWnd, Title: $($title.ToString())"
        }
        # 如果提供了参数，并且窗口的标题等于参数，那么对窗口进行截图，并且设置 found 为 true
        if ($param -ne "" -and $title.ToString() -eq $param) {
            Capture-Screenshot $hWnd
            Set-Variable -Name found -Value $true -Scope Script
            return $false
        }
    }

    return $true
}

# 定义一个函数，用来对窗口进行截图
function Capture-Screenshot {
    param($hWnd)

    # 显示窗口，并且将窗口设置为前台窗口
    [WinAPI]::ShowWindow($hWnd, 9)  # SW_RESTORE
    [WinAPI]::SetForegroundWindow($hWnd)
    # 将窗口设置为“总是在顶部”
    [WinAPI]::SetWindowPos($hWnd, [WinAPI]::HWND_TOPMOST, 0, 0, 0, 0, [WinAPI]::SWP_NOMOVE + [WinAPI]::SWP_NOSIZE)

    # 等待 200 毫秒，确保窗口已经显示出来
    Start-Sleep -Milliseconds 200

    # 获取窗口的位置和大小
    $rect = New-Object WinAPI+RECT
    if ([WinAPI]::GetWindowRect($hWnd, [ref]$rect)) {
        # 计算窗口的宽度和高度
        $width = $rect.Right - $rect.Left
        $height = $rect.Bottom - $rect.Top

        # 创建一个 Bitmap 对象，然后从屏幕上复制窗口的图像到 Bitmap 对象
        $bmp = New-Object Drawing.Bitmap $width, $height
        $graphics = [Drawing.Graphics]::FromImage($bmp)
        $graphics.CopyFromScreen($rect.Left, $rect.Top, 0, 0, $bmp.Size)

        # 保存 Bitmap 对象到文件
        $bmp.Save("./$filename.png")

        Write-Host "截图成功，保存到 $filename.png"
        # 取消窗口的“总是在顶部”属性
        [WinAPI]::SetWindowPos($hWnd, [WinAPI]::HWND_NOTOPMOST, 0, 0, 0, 0, [WinAPI]::SWP_NOMOVE + [WinAPI]::SWP_NOSIZE)
    }
}

# 调用 EnumWindows 函数，遍历所有的窗口
$result = [WinAPI]::EnumWindows($Callback, [IntPtr]::Zero)



# 如果提供了参数，并且没有找到需要的窗口，那么生成一个错误图片
if ($param -ne "" -and -not $found) {
    $errorMsg = "找不到标题： $param 对应的句柄"
    Write-Host $errorMsg
    [TextToImage]::CreateImage($errorMsg, "./$filename.png")
}