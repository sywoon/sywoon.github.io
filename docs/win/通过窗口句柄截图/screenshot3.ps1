# ʹ�÷�ʽ��powershell ./screenshot.ps1 -param "'���ڱ��⣬ע�������˫���ź͵�����'" -filename "��ͼ�ļ���" Ĭ��png��ʽ
# by NoRain
# 2024/5/24

# �����������������û���ṩ����ôĬ��ֵΪ ""
param(
    [Parameter(Mandatory=$false)]
    [string]$param = "",
    [Parameter(Mandatory=$false)]
    [string]$filename = "screenshot"
)

# ����һ���������������˲���Ҫ����Ĵ��ڱ���
$blacklist = "Default", "MSCTFIME"

# ���һ�����Ͷ��壬������һЩ Windows API �����ͽṹ
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

# ���һ�����Ͷ��壬������Ͱ�����һ����̬�������������ı�ת��ΪͼƬ
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



# ����һ����������������Ƿ��ҵ�����Ҫ�Ĵ���
$found = $false

# ����һ���ص���������������ᱻ EnumWindows ��������
$Callback = [WinAPI+EnumWindowsProc] {
    param($hWnd, $lParam)

    # ����һ�� StringBuilder ���������洢���ڵı���
    $title = New-Object System.Text.StringBuilder 256
    # ������ڵı��ⲻΪ�գ����Ҳ��ں�������
    if ([WinAPI]::GetWindowText($hWnd, $title, $title.Capacity) -gt 0 -and $title.ToString() -ne "" -and !($blacklist | Where-Object { $title.ToString().Contains($_) })) {
        # ���û���ṩ��������ô��ӡ���ڵľ���ͱ���
        if($param -eq ""){
            Write-Host "Handle: $hWnd, Title: $($title.ToString())"
        }
        # ����ṩ�˲��������Ҵ��ڵı�����ڲ�������ô�Դ��ڽ��н�ͼ���������� found Ϊ true
        if ($param -ne "" -and $title.ToString() -eq $param) {
            Capture-Screenshot $hWnd
            Set-Variable -Name found -Value $true -Scope Script
            return $false
        }
    }

    return $true
}

# ����һ�������������Դ��ڽ��н�ͼ
function Capture-Screenshot {
    param($hWnd)

    # ��ʾ���ڣ����ҽ���������Ϊǰ̨����
    [WinAPI]::ShowWindow($hWnd, 9)  # SW_RESTORE
    [WinAPI]::SetForegroundWindow($hWnd)
    # ����������Ϊ�������ڶ�����
    [WinAPI]::SetWindowPos($hWnd, [WinAPI]::HWND_TOPMOST, 0, 0, 0, 0, [WinAPI]::SWP_NOMOVE + [WinAPI]::SWP_NOSIZE)

    # �ȴ� 200 ���룬ȷ�������Ѿ���ʾ����
    Start-Sleep -Milliseconds 200

    # ��ȡ���ڵ�λ�úʹ�С
    $rect = New-Object WinAPI+RECT
    if ([WinAPI]::GetWindowRect($hWnd, [ref]$rect)) {
        # ���㴰�ڵĿ�Ⱥ͸߶�
        $width = $rect.Right - $rect.Left
        $height = $rect.Bottom - $rect.Top

        # ����һ�� Bitmap ����Ȼ�����Ļ�ϸ��ƴ��ڵ�ͼ�� Bitmap ����
        $bmp = New-Object Drawing.Bitmap $width, $height
        $graphics = [Drawing.Graphics]::FromImage($bmp)
        $graphics.CopyFromScreen($rect.Left, $rect.Top, 0, 0, $bmp.Size)

        # ���� Bitmap �����ļ�
        $bmp.Save("./$filename.png")

        Write-Host "��ͼ�ɹ������浽 $filename.png"
        # ȡ�����ڵġ������ڶ���������
        [WinAPI]::SetWindowPos($hWnd, [WinAPI]::HWND_NOTOPMOST, 0, 0, 0, 0, [WinAPI]::SWP_NOMOVE + [WinAPI]::SWP_NOSIZE)
    }
}

# ���� EnumWindows �������������еĴ���
$result = [WinAPI]::EnumWindows($Callback, [IntPtr]::Zero)



# ����ṩ�˲���������û���ҵ���Ҫ�Ĵ��ڣ���ô����һ������ͼƬ
if ($param -ne "" -and -not $found) {
    $errorMsg = "�Ҳ������⣺ $param ��Ӧ�ľ��"
    Write-Host $errorMsg
    [TextToImage]::CreateImage($errorMsg, "./$filename.png")
}