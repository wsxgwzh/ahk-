#Requires AutoHotkey v2.0

; ======== 第一步：自定义截图区域 ========
CaptureX := 158    ; 左上角 X 坐标
CaptureY := 432    ; 左上角 Y 坐标
CaptureW := 965    ; 截图宽度
CaptureH := 583    ; 截图高度
; ====================================

; ======== 鼠标下侧键 (XButton1) ========
XButton1:: {
    Click 838, 1205
    Sleep 300   ; 等待点击生效
    ProcessQuestion()
}

; ======== 鼠标上侧键 (XButton2) ========
XButton2:: {
    ProcessQuestion()
}

; ======== 公共流程函数 ========
ProcessQuestion() {
    ; 1. 截图并复制
    CaptureAndCopy(CaptureX, CaptureY, CaptureW, CaptureH)
    
    ; 2. 点击右侧输入框
    Click 1508, 1310
    
    ; 3. 粘贴图片
    Sleep 300
    Send "^v"
    
    ; 4. 发送
    Sleep 600  ; 等待上传
    Send "{Enter}"
    
    ; 5. 把鼠标移到 314, 593（不点击）
    Sleep 500
    MouseMove 314, 593
}

; ======== 截图并复制到剪贴板的函数（千万别漏掉这一段！）========
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
    
    RunWait("powershell.exe -NoProfile -ExecutionPolicy Bypass -File `"" tempFile "`"", , "Hide")
}