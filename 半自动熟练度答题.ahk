#Requires AutoHotkey v2.0

; ======== 第一步：自定义截图区域 ========
; 已替换为你提供的坐标
CaptureX := 158    ; 左上角 X 坐标
CaptureY := 432    ; 左上角 Y 坐标
CaptureW := 965    ; 截图宽度
CaptureH := 583    ; 截图高度
; ====================================

; 按【鼠标左侧下侧键】执行全自动流程
XButton1:: {
    ; 1. 先点击你指定的位置 (838, 1205)
    Click 838, 1205
    Sleep 300   ; 等待点击生效
    
    ; 2. 自动截取指定区域并复制到剪贴板
    CaptureAndCopy(CaptureX, CaptureY, CaptureW, CaptureH)
    
    ; 3. 自动点击右侧输入框（如果输入框位置变了，记得修改下面这行坐标）
    Click 1508, 1310
    
    ; 4. 粘贴图片
    Sleep 300   ; 等待光标激活
    Send "^v"
    
    ; 5. 发送
    Sleep 600  ; 等待上传（图片大或网速慢就改成 2000 或 3000）
    Send "{Enter}"
}

; ======== 截图并复制到剪贴板的函数（不需要改动） ========
CaptureAndCopy(x, y, w, h) {
    psCode := "Add-Type -AssemblyName System.Windows.Forms,System.Drawing; "
           . "$bmp = New-Object Drawing.Bitmap " w ", " h "; "
           . "$g = [Drawing.Graphics]::FromImage($bmp); "
           . "$g.CopyFromScreen(" x ", " y ", 0, 0, $bmp.Size); "
           . "[Windows.Forms.Clipboard]::SetImage($bmp)"
    
    tempFile := A_Temp "\capture.ps1"
    
    if FileExist(tempFile)
        FileDelete(tempFile)
        
    FileAppend(psCode, tempFile)
    
    ; 强制隐藏 PowerShell 黑框
    RunWait("powershell.exe -NoProfile -ExecutionPolicy Bypass -File `"" tempFile "`"", , "Hide")
}