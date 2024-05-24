# ʹ�÷�ʽ��powershell ./screenshot.ps1 -param 0 ����ֱ�� powershell ./screenshot.ps1
# by NoRain
# 2024/5/24

# ����һ�����������û���ṩ����ôĬ��ֵΪ -1
param(
    [Parameter(Mandatory=$false)]
    [int]$param = -1
)

# ����һ���������������˲���Ҫ����Ĵ��ڱ���
$blacklist = "Default", "MSCTFIME"
# ����һ������������������Ҫ����Ĵ��ڱ���
$whitelist = "΢�ſ����߹��� Stable v1.06.2206090", "���������߹���ǰ�ù���ҳ","QQС���򿪷��߹���","�Ա������߹���"

# ����ṩ�˲��������Ҳ�����ֵС�� 0 ���ߴ��ڵ��ڰ������ĳ��ȣ���ô��ӡ������Ϣ���˳�
if ($param -ne -1 -and ($param -lt 0 -or $param -ge $whitelist.Length)) {
    Write-Host "�������Ҳ�����Ӧ�±�Ĳ�����'$param'"
    return
}

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
    }
"@ -ReferencedAssemblies System.Windows.Forms

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
        if($param -eq -1){
        Write-Host "Handle: $hWnd, Title: $($title.ToString())"
        }
        # ����ṩ�˲��������Ҵ��ڵı�����ڰ�����������Ϊ�����ı��⣬��ô�Դ��ڽ��н�ͼ���������� found Ϊ true
        if ($param -ne -1 -and $title.ToString() -eq $whitelist[$param]) {
            Capture-Screenshot $hWnd
            Set-Variable -Name found -Value $true -Scope Script
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
        $screenshot = "./screenshot_$param.png"
        $bmp.Save($screenshot)
    }
}

# ���� EnumWindows �������������еĴ���
[WinAPI]::EnumWindows($Callback, [IntPtr]::Zero)

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

# ����ṩ�˲���������û���ҵ���Ҫ�Ĵ��ڣ���ô����һ������ͼƬ
if ($param -ne -1 -and -not $found) {
    $errorMsg = "�Ҳ������⣺ $($whitelist[$param]) ��Ӧ�ľ��"
    Write-Host $errorMsg
    $screenshot = "./screenshot_$param.png"
    [TextToImage]::CreateImage($errorMsg, $screenshot)
}