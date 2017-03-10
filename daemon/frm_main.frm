VERSION 5.00
Begin VB.Form frm_main 
   BorderStyle     =   0  'None
   Caption         =   "开机屏幕"
   ClientHeight    =   5475
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   8235
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   5475
   ScaleWidth      =   8235
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  '所有者中心
   Begin VB.Timer tmr_chrome 
      Interval        =   2000
      Left            =   840
      Top             =   3060
   End
   Begin VB.CommandButton Command1 
      Caption         =   "hide teamviewer"
      Height          =   555
      Left            =   930
      TabIndex        =   0
      Top             =   450
      Visible         =   0   'False
      Width           =   2535
   End
   Begin VB.Timer tmr_check 
      Interval        =   100
      Left            =   120
      Top             =   540
   End
End
Attribute VB_Name = "frm_main"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Const WM_CLOSE = &H10
Private Declare Function FindWindow Lib "user32" Alias "FindWindowA" (ByVal lpClassName As Any, ByVal lpWindowName As String) As Long
Private Declare Function SendMessage Lib "user32" Alias "SendMessageA" (ByVal Hwnd As Long, ByVal wMsg As Long, ByVal wParam As Long, lParam As Any) As Long

Private Declare Function GetDesktopWindow Lib "user32" () As Long
Private Declare Function GetWindow Lib "user32" (ByVal Hwnd As Long, ByVal wCmd As Long) As Long
Private Declare Function GetWindowText Lib "user32" Alias "GetWindowTextA" (ByVal Hwnd As Long, ByVal lpString As String, ByVal cch As Long) As Long
'Private Declare Function FindWindow Lib "user32" Alias "FindWindowA" (ByVal lpClassName As String, ByVal lpWindowName As String) As Long
Private Declare Function ShowWindow Lib "user32" (ByVal Hwnd As Long, ByVal nCmdShow As Long) As Long
Private Const SW_HIDE = 0
Private Const SW_SHOWNORMAL = 1
Private Const SW_SHOWMINIMIZED = 2
Private Const SW_SHOWMAXIMIZED = 3
Private Declare Function GetActiveWindow Lib "user32" () As Long


Private Declare Function SetWindowPos Lib "user32" (ByVal Hwnd As Long, ByVal hWndInsertAfter As Long, ByVal x As Long, ByVal y As Long, ByVal cx As Long, ByVal cy As Long, ByVal wFlags As Long) As Long

Private Declare Function SetLayeredWindowAttributes Lib "user32" (ByVal Hwnd As Long, ByVal crKey As Long, ByVal bAlpha As Byte, ByVal dwFlags As Long) As Long
Private Declare Function GetWindowLong Lib "user32" Alias "GetWindowLongA" (ByVal Hwnd As Long, ByVal nIndex As Long) As Long
Private Declare Function SetWindowLong Lib "user32" Alias "SetWindowLongA" (ByVal Hwnd As Long, ByVal nIndex As Long, ByVal dwNewLong As Long) As Long
'窗口透明常数
'Const WS_EX_LAYERED = &H80000
Const GWL_EXSTYLE = (-20)
Const LWA_ALPHA = &H2
Const LWA_COLORKEY = &H1
Private Const GW_CHILD = 5
Private Const GW_HWNDNEXT = 2




Private Sub Command1_Click()
    hwndid = FindWindow(0&, "TeamViewer")
    Call SendMessage(hwndid, WM_CLOSE, 0, ByVal 0&)
End Sub

Private Sub Form_Load()
    Shell "cmd /c taskkill /im Teamviewer.exe"
    Shell "cmd /c start C:\TeamViewerQS\App\TeamViewer\Teamviewer.exe"
    
    Dim rtn As Long
    Me.BackColor = RGB(0, 0, 0)
    rtn = GetWindowLong(Me.Hwnd, GWL_EXSTYLE)
    rtn = rtn Or WS_EX_LAYERED
    SetWindowLong Me.Hwnd, GWL_EXSTYLE, rtn
    SetLayeredWindowAttributes Me.Hwnd, RGB(0, 0, 0), 150, LWA_ALPHA
    
    
    
    Dim x As Integer
    Dim y As Integer
    x = Screen.Width
    y = Screen.Height
    Me.Width = x
    Me.Height = y
    

    
    
    
    
    
    
End Sub



Private Sub tmr_check_Timer()
    hwndid = FindWindow(0&, "TeamViewer")
    Call SendMessage(hwndid, WM_CLOSE, 0, ByVal 0&)
    
    
    
  '保证chrome最大化
  Dim lngDeskTopHandle As Long
  Dim lngHand As Long
  Dim strName As String * 255
  Dim a As Long
  lngDeskTopHandle = GetDesktopWindow()
  lngHand = GetWindow(lngDeskTopHandle, GW_CHILD)
  Do While lngHand <> 0
     GetWindowText lngHand, strName, Len(strName)
     lngHand = GetWindow(lngHand, GW_HWNDNEXT)
     If Left$(strName, 1) <> vbNullChar Then
        If InStr(strName, "Google Chrome") Then
            a = FindWindow(vbNullString, CStr(strName))
            If GetActiveWindow() = a Then
                Print 1
            Else
                SetWindowPos a, -1, 0, 0, 0, 0, 3
                ShowWindow a, SW_SHOWMAXIMIZED
            End If
            Exit Sub
        End If
     End If
  Loop
    
    
    
    
End Sub

Private Sub tmr_chrome_Timer()
    Shell "cmd /c python C:\Chrome\start.py"
    tmr_chrome.Enabled = False
    
End Sub
