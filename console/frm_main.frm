VERSION 5.00
Begin VB.Form frm_main 
   Caption         =   "显示屏批量控制程序"
   ClientHeight    =   3450
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   7590
   LinkTopic       =   "Form1"
   ScaleHeight     =   3450
   ScaleWidth      =   7590
   StartUpPosition =   1  '所有者中心
   Begin VB.TextBox txt_cmd 
      Height          =   270
      Left            =   1260
      TabIndex        =   11
      Text            =   "python script.py"
      Top             =   2160
      Width           =   4335
   End
   Begin VB.CommandButton cmd_ok 
      Caption         =   "确定"
      Height          =   405
      Left            =   1200
      TabIndex        =   9
      Top             =   2760
      Width           =   2445
   End
   Begin VB.TextBox txt_download 
      Height          =   270
      Left            =   1260
      TabIndex        =   8
      Text            =   "http://hls.sysorem.xyz/screen/script.py"
      Top             =   1590
      Width           =   4335
   End
   Begin VB.OptionButton Opt_no 
      Caption         =   "否"
      Height          =   345
      Left            =   6810
      TabIndex        =   6
      Top             =   2190
      Value           =   -1  'True
      Width           =   585
   End
   Begin VB.OptionButton Opt_yes 
      Caption         =   "是"
      Height          =   345
      Left            =   6240
      TabIndex        =   5
      Top             =   2190
      Width           =   555
   End
   Begin VB.TextBox txt_index 
      Height          =   270
      Left            =   1230
      TabIndex        =   1
      Text            =   "http://screen.libc.pw"
      Top             =   450
      Width           =   4335
   End
   Begin VB.Label lbl_timestamp 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "时间戳"
      Height          =   180
      Left            =   1260
      TabIndex        =   10
      Top             =   1020
      Width           =   540
   End
   Begin VB.Label lbl_exe 
      BackStyle       =   0  'Transparent
      Caption         =   "执行:"
      Height          =   180
      Left            =   5760
      TabIndex        =   7
      Top             =   2250
      Width           =   450
   End
   Begin VB.Label lbl_cmd 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "CMD命令:"
      Height          =   180
      Left            =   390
      TabIndex        =   4
      Top             =   2220
      Width           =   720
   End
   Begin VB.Label lbl_download 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "下载文件:"
      Height          =   180
      Left            =   390
      TabIndex        =   3
      Top             =   1620
      Width           =   810
   End
   Begin VB.Label lbl_update 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "更新时间:"
      Height          =   180
      Left            =   360
      TabIndex        =   2
      Top             =   1020
      Width           =   810
   End
   Begin VB.Label lbl_index 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "首页地址:"
      Height          =   180
      Left            =   360
      TabIndex        =   0
      Top             =   510
      Width           =   810
   End
End
Attribute VB_Name = "frm_main"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Public Function PostData(ByVal StrUrl As String, ByVal StrData As String) As Variant
  On Error GoTo ERR:
  
  Dim XMLHTTP As Object
  Dim DataS As String

  
  Set XMLHTTP = CreateObject("Microsoft.XMLHTTP")
  
  XMLHTTP.Open "POST", StrUrl, True
  XMLHTTP.setRequestHeader "Content-Length", Len(PostData)
  XMLHTTP.setRequestHeader "Referer", "rc://screen.libc.pw/"
  XMLHTTP.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
  XMLHTTP.send (StrData)
  
  Do Until XMLHTTP.ReadyState = 4
    DoEvents
  Loop
  PostData = XMLHTTP.responseText
  'MsgBox XMLHTTP.responseText
  Set XMLHTTP = Nothing
  
  Exit Function
ERR:
  PostData = "404"
End Function
Function ToUnixTime(strTime, intTimeZone)
    If IsEmpty(strTime) Or Not IsDate(strTime) Then strTime = Now
    If IsEmpty(intTimeZone) Or Not IsNumeric(intTimeZone) Then intTimeZone = 0
     ToUnixTime = DateAdd("h", -intTimeZone, strTime)
     ToUnixTime = DateDiff("s", "1970-1-1 0:0:0", ToUnixTime)
End Function
Function BytesToStr(ByVal vIn) As String
  strReturn = ""
  For i = 1 To LenB(vIn)
    ThisCharCode = AscB(MidB(vIn, i, 1))
    If ThisCharCode < &H80 Then
      strReturn = strReturn & Chr(ThisCharCode)
    Else
      NextCharCode = AscB(MidB(vIn, i + 1, 1))
      strReturn = strReturn & Chr(CLng(ThisCharCode) * &H100 + CInt(NextCharCode))
      i = i + 1
    End If
  Next
  BytesToStr = strReturn
End Function

Private Sub cmd_ok_Click()
    Dim ret
    Dim data As String
    data = "start_page=" & txt_index.Text & "&update_time=" & lbl_timestamp.Caption & "&extra_download_url=" & txt_download.Text & "&extra_download_execute=" & exeute_cmd() & "&extra_download_command=" & txt_cmd.Text
    ret = PostData("http://rc.deadbeef.win/update.php", data)
    If ret <> "404" Then
        MsgBox "更新成功！", vbOKOnly, "提示"
    Else
        MsgBox "更新失败！", vbOKOnly, "提示"
    End If
    
End Sub



Private Function exeute_cmd()
    If Opt_yes.Value = True Then
        exeute_cmd = "True"
    Else
        exeute_cmd = "False"
    End If
    
    
End Function



Private Sub Form_Load()
    lbl_timestamp.Caption = ToUnixTime(DateDiff("s", #1/1/1970#, Now()), 8)
End Sub
