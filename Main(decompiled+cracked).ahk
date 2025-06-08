#SingleInstance, Force
#NoEnv
SetWorkingDir %A_ScriptDir%
#WinActivateForce
SetMouseDelay, -1
SetWinDelay, -1
SetControlDelay, -1
SetBatchLines, -1
global webhookURL
global privateServerLink
global discordUserID
global PingSelected
global windowIDS := []
global currentWindow := ""
global firstWindow := ""
global instanceNumber
global idDisplay := ""
global started := 0
global cycleCount := 0
global cycleFinished := 0
global toolTipText := ""
global currentItem := ""
global currentArray := ""
global currentSelectedArray := ""
global indexItem := ""
global indexArray := []
global currentHour
global currentMinute
global currentSecond
global midX
global midY
global msgBoxCooldown := 0
global gearAutoActive := 0
global seedAutoActive := 0
global eggAutoActive  := 0
global cosmeticAutoActive := 0
global honeyShopAutoActive := 0
global honeyDepositAutoActive := 0
global collectPollinatedAutoActive := 0
global actionQueue := []
settingsFile := A_ScriptDir "\settings.ini"
global currentShop := ""
global selectedResolution
global scrollCounts_1080p, scrollCounts_1440p_100, scrollCounts_1440p_125
scrollCounts_1080p :=       [2, 4, 6, 8, 9, 11, 13, 14, 16, 18, 20, 21, 23, 25, 26, 28, 29, 31]
scrollCounts_1440p_100 :=   [3, 5, 8, 10, 13, 15, 17, 20, 22, 24, 27, 30, 31, 34, 36, 38, 40, 42]
scrollCounts_1440p_125 :=   [3, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 23, 25, 27, 29, 30, 31, 32]
global gearScroll_1080p, toolScroll_1440p_100, toolScroll_1440p_125
gearScroll_1080p     := [1, 2, 4, 6, 8, 9, 11, 13]
gearScroll_1440p_100 := [2, 3, 6, 8, 10, 13, 15, 17]
gearScroll_1440p_125 := [1, 3, 4, 6, 8, 9, 12, 12]


ffk@@f@ff@@k(@f@fk#ff#k#fkfkf, f@fkffk#k@fk@fkf) {
FormatTime, messageTime, , hh:mm:ss tt
fullMessage := "[" . messageTime . "] " . f@fkff%ff@k#f%k#k@fk@fkf
json := "{""content"": """ . fullMessage . """}"
whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
try {
whr.Open("POST", @f@fk#%@kf#%%f@#fff%ff#k#fkfkf, false)
whr.SetRequestHeader("Content-Type", "application/json")
whr.Send(json)
whr.WaitForResponse()
status := whr.Status
if (status != 200 && status != 204) {
return
}
} catch {
return
}
}


k#kk@ff@ff#f@f@k(kkkkff#ffkkf, k#k@kkk#kfffkfk@ := 0, k#kkk#fff@kkff@f := "nil") {
global webhookURL
global privateServerLink
global settingsFile
isValid := 0
if (k#kkk%fffff@%#fff@kkff@f = "webhook" && (kkk%kfkkk#%kff#ffkkf = "" || !(InStr(kkkkff%ffkf#k%#ffkkf, "discord.com/api") || InStr(kkkkf%fkfk%f#ffkkf, "discordapp.com/api")))) {
isValid := 0
if (k#%f@#kfkkk%k@%#fk@%kkk#kfffkfk@) {
MsgBox, 0, Message, Invalid Webhook
IniRead, savedWebhook, %settingsFile%, Main, UserWebhook,
GuiControl,, webhookURL, %savedWebhook%
}
return false
}
if (k#kk%@kk@k@%%k#@kf@f@%k#fff@kkff@f = "privateserver" && (kkkkf%kffkff#k%f#ffkkf = "" || !InStr(k%k@f#@k%kkkff#ffkkf, "roblox.com/share"))) {
isValid := 0
if (k#k@k%k#@fkk%kk#kfffkfk@) {
MsgBox, 0, Message, Invalid Private Server Link
IniRead, savedServerLink, %settingsFile%, Main, PrivateServerLink,
GuiControl,, privateServerLink, %savedServerLink%
}
return false
}
try {
whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
whr.Open("GET", kkkk%#k#k@fkf%ff#ffkkf, false)
whr.Send()
whr.WaitForResponse()
status := whr.Status
if (k#kkk%kfk@#k%#fff@%ffkfkk%kkff@f = "webhook" && (status = 200 || status = 204)) {
isValid := 1
} else if (k#kkk#%f@k@%fff@kkff@f = "privateserver" && (status >= 200 && status < 400)) {
isValid := 1
}
} catch {
isValid := 0
}
if (k#k%fk#fk#%@k%#kff#k%kk#kfffkfk@) {
if (k#kk%ffkf%k#ff%@fkkk#%f@kkff@f = "webhook") {
if (isValid && webhookURL != "") {
IniWrite, %webhookURL%, %settingsFile%, Main, UserWebhook
MsgBox, 0, Message, Webhook Saved Successfully
}
else if (!isValid && webhookURL != "") {
MsgBox, 0, Message, Invalid Webhook
IniRead, savedWebhook, %settingsFile%, Main, UserWebhook,
GuiControl,, webhookURL, %savedWebhook%
}
} else if (k#kkk#%f@f@#f%fff@%f##f@fk@%kkff@f = "privateserver") {
if (isValid && privateServerLink != "") {
IniWrite, %privateServerLink%, %settingsFile%, Main, PrivateServerLink
MsgBox, 0, Message, Private Server Link Saved Successfully
}
else if (!isValid && privateServerLink != "") {
MsgBox, 0, Message, Invalid Private Server Link
IniRead, savedServerLink, %settingsFile%, Main, PrivateServerLink,
GuiControl,, privateServerLink, %savedServerLink%
}
}
}
return isValid
}


#k@f#fkkkk#f(#kf@@k@k@fkf#k := "nil", @k#kkfkkffk@kkkf := 2000) {
static popupID := 99
WinGetPos, guiX, guiY, guiW, guiH, A
innerX := 20
innerY := 35
innerW := 200
innerH := 50
winW := 200
winH := 50
x := guiX + (guiW - winW) // 2 - 40
y := guiY + (guiH - winH) // 2
if (!msgBoxCooldown) {
msgBoxCooldown = 1
Gui, %popupID%:Destroy
Gui, %popupID%:+AlwaysOnTop -Caption +ToolWindow +Border
Gui, %popupID%:Color, FFFFFF
Gui, %popupID%:Font, s10 cBlack, Segoe UI
Gui, %popupID%:Add, Text, x%innerX% y%innerY% w%innerW% h%innerH% BackgroundWhite Center cBlack, %@kk@k@%%#kf@@k@k@fkf#k%%f#k@k@%
Gui, %popupID%:Show, x%x% y%y% NoActivate
SetTimer, #ff@k@%kkkkfk#f%f#kkk@@f#kf#k@k@fff#k#f@kkkk#f#fkfk#, -%@k#kkfkkffk@kkkf%%f##f@fk@%%#kf#ff%
Sleep, 2200
msgBoxCooldown = 0
}
}


@kff#f@fkffkf##f(ffk@fkfkkfk@k#) {
MsgBox, 1, Disclaimer,
(
Your browser will open with a link to a roblox gamepass once you press OK.
- Feel free to check the code, there are no malicious links.
)
IfMsgBox, OK
if (ffk@f%#kk#k#k#%%fff#k@k@%kfkkfk@k# = "Donate100")
Run, https://www.roblox.com/game-pass/1197306369/100-Donation
else if (ffk@f%kfk@%kfkkfk@k# = "Donate500")
Run, https://www.roblox.com/game-pass/1222540123/500-Donation
else if (ffk@f%#fff%kfk%f#ffkk%kfk@k# = "Donate1000")
Run, https://www.roblox.com/game-pass/1222262383/1000-Donation
else if (ffk@%ff@k#f%fkfkkfk@k# = "Donate2500")
Run, https://www.roblox.com/game-pass/1222306189/2500-Donation
else if (ffk@f%@ffk@ffk%kfkk%ff@k#f%fk@k# = "Donate10000")
Run, https://www.roblox.com/game-pass/1220930414/10-000-Donation
else
return
}


fk#kf@fkf@f@#k(#k@fk#@f#fk#kf#f, f@k@k@f#kkkkk@kk) {
if WinExist("ahk_exe RobloxPlayerBeta.exe") {
WinGetPos, winX, winY, winW, winH, ahk_exe RobloxPlayerBeta.exe
moveX := winX + Round(#%kfk#f#@f%k@%ff@k#f%fk#@f#fk#kf#f * winW)
moveY := winY + Round(f@k%ff#fkk%@k@f#%f#ffkk%kkkkk@kk * winH)
MouseMove, %moveX%, %moveY%
}
}


@fk@kff#k#kkf@#k(@fkkf#kkff#ffk, ff@fkf@k@kk#) {
if WinExist("ahk_exe RobloxPlayerBeta.exe") {
WinGetPos, winX, winY, winW, winH, ahk_exe RobloxPlayerBeta.exe
clickX := winX + Round(@fk%f#ffkk%kf#kkff#ffk * winW)
clickY := winY + Round(f%f#@f%f@fk%kkffkf@k%f@k@kk# * winH)
Click, %clickX%, %clickY%
}
}


ff#ff#f@kkff(k##fk#kk@k#fk##k) {
WinGetPos, winX, winY, winW, winH, ahk_exe RobloxPlayerBeta.exe
CoordMode, Mouse, Screen
MouseGetPos, mouseX, mouseY
relX := (mouseX - winX) / winW
relY := (mouseY - winY) / winH
if (k%#fk@%##fk#kk@k#fk##k = "x")
return relX
else if (k##f%kkffkf@k%k#kk@k#fk##k = "y")
return relY
return ""
}


fkfkk@@k@kkk(#kk@#ff#@f@ffk := 0, kkk@#ff##fkkk# := 1, #fk@f#k#kk#f#k := 0, kf#kffkfkfff := 0, fk@fk#@fk#fk#k@f := 30, k@fkfkf@kff# := 50, k##kf#kkff#k@k := "universal", #k#fk@#k#kk@kffk := 0, ff#ffkf@ffff#ff@ := "nil", f#@kffk@kf@k := "nil") {
global SavedSpeed
global SavedKeybind
global UINavigationFix
global indexItem
global currentArray
If (!#kk@#f%f@f@#f%f#@f@ffk && k#%f#fk@f%#kf%fff#k@k@%#kkff#k@k = "universal") {
return
}
if (!#%k@kf@f#k%fk@%fkfk%f#k#kk#f#k) {
kf@k%#k#f@fk#%#kkfkk#kk#(SavedKeybind)
Sleep, 50
if (UINavigationFix) {
fk#kfkk%fk#k@fff%%kkffkf@k%kk#fff@kk("Up", 5, 50)
Sleep, 50
fk%#kff#k%%kffk%#kfkkkk#fff@kk("Left", 3, 50)
Sleep, 50
fk%k@f#@k%#kfkkkk#fff@kk("up", 5, 50)
Sleep, 50
fk#k%kfk@%fk%k#ff#f%kkk#fff@kk("Left", 3, 50)
Sleep, 50
}
}
if (k##%@kk@k@%kf#kkff#k@k = "universal") {
Loop, Parse, #kk@#f%kfkkk#%f#%f##f@fk@%@f@ffk
{
if (A_LoopField = "1") {
f%kkffkf@k%k#kfkkkk#fff@kk("Right", 1)
}
else if (A_LoopField = "2") {
fk#%fk#k@fff%kfkk%#fk@%kk#fff@kk("Left", 1)
}
else if (A_LoopField = "3") {
fk#kfkk%fkk#%kk#fff@kk("Up", 1)
}
else if (A_LoopField = "4") {
fk#kf%ffkk%kkkk#fff@kk("Down", 1)
}
else if (A_LoopField = "0") {
fk#%k@#kk#%kfkkkk#fff@kk("Enter", k%f##f@fk@%f#kff%kk#fk@%kfkfff ? fk@fk#@%fk#kk@#k%fk%#kff#k%#fk#k@f : 1, kf#kf%ff#fkk%f%f@#fff%kfkfff ? 10 : 0)
}
else if (A_LoopField = "5") {
Sleep, 100
}
if (SavedSpeed = "Stable" && A_LoopField != "5") {
Sleep, %ff#fkk%%k@fkfkf@kff#%%fk#kk@#k%
}
}
}
else if (k#%#k@kff%%kk#fk@%#kf#kkff#k@k = "calculate") {
previousIndex := f@%kfk@%f#@f#kf@kfk@(currentArray, indexItem)
sendCount := #k#fk@#%fk#kff@f%k#kk@kffk - previousIndex
FileAppend, % "index: " . #k#fk@#%ffkk%k#kk@kffk . "`n", debug.txt
FileAppend, % "previusIndex: " . previousIndex . "`n", debug.txt
FileAppend, % "currentarray: " . currentArray.Name . "`n", debug.txt
if (ff#ff%kkkkfk#f%kf@fff%kffk#k%f#ff@ = "up") {
f%k#kfk#k@%k#kfkkk%fk#kkk%k#fff@kk(f%f#k@k@%f#ffk%#kf#ff%f@ffff#ff@)
fk#kf%kf#f%kkkk#fff@kk("Enter")
fk#kf%ff@k#f%kkkk#fff@kk(ff#f%kfk#f#%f%@ffk@ffk%kf@ffff#ff@, sendCount)
}
else if (ff#ff%fk#ff@%kf@ffff#ff@ = "down") {
FileAppend, % "sendCount: " . sendCount . "`n", debug.txt
if ((currentArray.Name = "honeyItems") && (previousIndex = 1 || previousIndex = 10 || previousIndex = 12)) {
if (!(f@f#@f%f@#fff%#kf@%@k#f@f@f%kfk@(indexArray, 1, "bool"))) {
sendCount++
}
sendCount--
FileAppend, % "went down one less because of previous #k#fk@#%f@#kfkkk%k#kk@kffk: " . previousIndex . "`n", debug.txt
}
fk%#fk@%#kfkkkk#fff@kk(ff#ffk%fk#kff@f%f@ffff#ff@, sendCount)
fk#kf%ff@fkff@%kkkk#ff%fkfk%f@kk("Enter")
fk#kf%kfk#f#%kkkk#fff@kk(ff#ff%f@#fff%kf@ffff#ff@)
if ((currentArray.Name = "gearItems") && (#k#fk@#%k#f#k#@f%k#kk@kffk != 2) && (UINavigationFix)) {
fk#kfk%kkk@#f%kkk#fff%k@ffff#f%@kk("Left")
}
else if ((currentArray.Name = "seedItems") && (UINavigationFix)) {
fk#%ffkfkk%kfkkkk#fff@kk("Left")
}
if ((currentArray.Name = "honeyItems") && (#k#fk@%@kkk@f@k%#k#kk@kffk = 1 || #%k@ffff#f%k#fk@#k%f#@f%#kk@kffk = 10 || #k#fk%f#fk@f%@#k#kk@kffk = 12)) {
fk#%f@@fff%kfkkkk#fff@kk(ff#ff%@ff@@fk#%kf@f%k@kk@k%fff#ff@)
FileAppend, % "went down one extra for #k#f%@kfffk%k@#k#k%fffk#fk@%k@kffk: " . #k#fk@#%f@k@%k#kk@%#fk@%kffk . "`n", debug.txt
}
}
}
else if (k##kf%@fk@f@f@%#kkff#k@k = "close") {
if (f%f@#f#kkk%%#k@k#kk#%f#ffkf@ffff#ff@ = "up") {
if (f#@kffk%#kk#@f%@kf@k = "Honey" && UINavigationFix) {
#%kkffkf@k%k#fk@#k#kk@kffk += 10
}
fk#%#fk#%k%k@kf@f#k%fkkkk#fff@kk(ff%k#@fkk%%kffk#k%#ffkf@ffff#ff@)
fk#%fk#kkk%kfkkkk#fff@kk("Enter")
fk#kfkk%k@k@ff%kk#fff@kk(ff#ff%k@ffff#f%kf@ff%f@#fff%ff#ff@, #%@kkk@f@k%k#fk@#k#kk@kffk)
}
else if (ff#ffk%#k@kff%f%kkkkfk#f%@ffff#ff@ = "down") {
fk#kfkk%kkf@kfff%k%k#@fkk%k#fff@kk(f%#k#f@fk#%f#%k#ff#f%ffkf@ffff#ff@, #k#f%@ffkkfff%k@#k#kk@kffk)
fk#kfk%@ff@@fk#%kkk#ff%kkffkf@k%f@kk("Enter")
f%@fk@f@f@%k#kfkkk%kffk#k%k#fff@kk(ff#ffkf%f@#f#kkk%@ff%k@kk@k%ff#ff@)
}
}
if (kk%@kk#%k@#%kffkff#k%ff##fkkk#) {
Sleep, 50
kf@k#k%f@#fff%kfkk#kk#(SavedKeybind)
}
return
}


k@f@kf#f@f@kk#kf(kkfff##kk##ffk) {
global currentArray
global currentSelectedArray
global indexItem := ""
global indexArray := []
global UINavigationFix
indexArray := []
lastIndex := 0
if (kkfff%k@ffff#f%##kk##ffk = "honey" && UINavigationFix) {
StringUpper, kkff%kkfff#ff%f##kk%#k@kff%##ffk, kkfff%k@ffffkk%##kk##ffk, T
arrayName := "real" . k%f@#f#kkk%kfff##kk##ffk . "Items"
}
else {
arrayName := kkfff%fkkk@kfk%##kk##ffk . "Items"
}
currentArray := %arrayName%
currentArray.Name := arrayName
StringUpper, kkfff#%kfk@%#kk#%@kk#%#ffk, kkfff#%k@kk@k%#kk##ffk, T
selectedArrayName := "selected" . kkff%#k#k@fkf%f##kk%fk#fk#%##ffk . "Items"
currentSelectedArray := %selectedArrayName%
for i, selectedItem in currentSelectedArray {
indexArray.Push(f@f#%k@#kff#f%@f#kf%kkf@kfff%@kfk@(currentArray, selectedItem))
}
for i, index in indexArray {
currentItem := currentSelectedArray[i]
Sleep, 50
fkfk%#k#k@fkf%k@@k@kkk(, 0, 1, , , , "calculate", index, "down", kkfff#%k#f@%#k%#k#f@fk#%k##ffk)
indexItem := currentSelectedArray[i]
f#@f%kkf@kfff%@kk@k@@fkf(100, 200)
k@%k@fkkf%fff%k@f#@k%@ffkff@(0x26EE26, 0x1DB31D, 5, 0.4262, 0.2903, 0.6918, 0.8508)
Sleep, 50
lastIndex := index - 1
}
Sleep, 100
fkfkk@%#fk#%@k@kkk(, 0, 1,,,, "close", lastIndex, "up", k%kf#f%kfff##kk##ffk)
Sleep, 100
}


fk#kfkkkk#fff@kk(fkkkfff#@kk#fkkk := "nil", f#@kk@k@kfff := 1, k@@kk#@kfk#k#f := 30) {
global SavedSpeed
if (fk%k#f@%kkfff%ff@k#f%#@kk#fkkk = "nil") {
return
}
Loop, %ff#fkk%%f#@kk@k@kfff%%#fff% {
Send {%k#ff%%fkkkfff#@kk#fkkk%%f@#f#kkk%}
Sleep, % (SavedSpeed = "Ultra" ? (k@%@ff@fk#f%@kk#@k%k@ffff#f%fk#k#f - 25) : SavedSpeed = "Max" ? (k@@kk%k@kk@k%#@kfk%fk#ff@%#k#f - 30) : k@@kk%k@#kff#f%#@kfk%#kff#k%#k#f)
}
}


kf@k#kkfkk#kk#(kk@fk@k#@f@f#f) {
if (kk@f%#kk#k#k#%k@k#@f@f#f = "\") {
Send, \
}
else if (kk@fk%#k#k@fkf%@k#@f@f#f = "#" || kk@%ff@k#f%fk@k#@f@f#f = "[") {
Send, {%kk@fk@k#@f@f#f%%fffff@%%kffkff#k%}
}
}


f#@f@kk@k@@fkf(kf#kf#f@@fffkf, f@@f@k@kk#k##fff) {
global SavedSpeed
Sleep, % (SavedSpeed != "Stable") ? kf%kkfff#ff%#kf%k#@kf@f@%#f@@fffkf : f@%#k#f@fk#%@%@ffk@ffk%f@k@kk#k##fff
}


f@f#@f#kf@kfk@(@k@kk#f@fffkkf := "", @kf##k@f@f#f := "", k#@f@k@f#ff#f@fk := "int") {
FileAppend, % "Searching " . @k@kk%#kk#@f%#f@fffkkf.Name . " for " . @kf%#kk#k#k#%##k@f@f#f . "`n", debug.txt
for index, item in @k@k%kkk@#f%k#f@fffkkf {
if (@%ff@k#f%kf##k@f@f#f = item) {
FileAppend, % "found " . @kf#%f#@f%#k@f@f#f . " at index " . index "`n", debug.txt
if (k#@%@ffkkfff%f@k@f#f%kfk@%f#f@fk = "int") {
return index
}
else if (k#@f%kf#f%@k@f#ff#f@fk = "bool") {
return true
}
}
}
if (k%#fff%#@f@k@f#ff#f@fk = "int") {
return 1
}
else if (k#@f@k@%@kk#%f%#kkk@k%#ff#f@fk = "bool") {
return false
}
}


@k#k@f@fk#ff(k#fk@f#ff#@fk@ := "nil") {
global UINavigationFix
if(k#fk%@k@fkf%@f#ff#@fk@ = "nil") {
Return
}
if (UINavigationFix) {
fkfkk%#kf#ff%@@k@kkk("150524150505305", 0)
f@%#fk@%f%@k@fkf%kkkk@fkf#fk(k#%k@fkkf%fk@f#ff#@fk@)
Sleep, 50
if (k%fk#f@kkk%#fk@f#ff#@fk@ = "recall") {
fkf%k@kk@k%kk%ff#k@k@k%@@k@kkk("4335505541555055", 1, 1)
}
else if (k#f%kkf@kfff%k@f#ff%k@ffffkk%#@fk@ = "pollinated") {
fk%fkk#%fkk@@k@kkk("22115505544444444441111111155055", 1, 1)
}
else if (k#f%#kk#k#k#%k@%k#ff%f#ff#@fk@ = "pollen") {
fkfk%f#k@k@%k@@%fk#kk@#k%k@kkk("2211550554444444444111111155055", 1, 1)
}
fkfkk%#f@k%@%fk#ff@%@k@kkk(10)
}
else {
fkf%k@kf@f#k%kk@@k%#kf#ff%@kkk("1011143333333333333333333311440", 0)
Sleep, 50
f@fkk%k##k%kk%k@ffff#f%@fkf#fk(k#%#k#f@fk#%fk@f#ff#@fk@)
Sleep, 50
if (k#fk@%kkkkfk#f%%ffkf%f#ff#@fk@ = "recall") {
fkfkk%#kkk@k%@@k@k%@f#kfk%kk("2211550554155055", 1, 1)
}
else if (k#%kfk@%fk@f#ff#@fk@ = "pollinated") {
fkfk%#k@k#kk#%k@@k@%@f@k%kkk("22115505544444444444444444444441111111155055", 1, 1)
}
else if (k#%ff#k@k@k%fk@f#ff#@fk@ = "pollen") {
fk%f#@f%fk%@k#f@f@f%k@@k@kkk("2211550554444444444111111155055", 1, 1)
}
fkfkk%#ff#k#k#%@@k%kkkkfk#f%@kkk(10)
}
}


f@fkkkk@fkf#fk(f@f@fkk#k##f#f, #kf#f@@fk#kf := 1, #kk@fkkkkkkf@k := 1) {
if (f%k@#kkf%%@k@fkf%@f@fkk#k##f#f = "") {
Return
}
if (#%fk#ff@%kk@fkkkkkkf@k) {
Send {BackSpace 20}
Sleep, 100
}
Loop, Parse, f@f@fk%@k@kk@f#%k#k##f#f
{
Send, {%A_LoopField%}
Sleep, 100
}
if (#kf#f@%kfk#f#@f%@fk#kf) {
Send, {Enter}
}
Return
}


f#f@@ffffkf@(kkk#f@fkf#fkf@ff) {
Loop, 5 {
Send, {WheelUp}
Sleep, 20
}
Sleep, 500
if (kkk#f@f%kffk#k%kf%kf#f%#fkf@ff = "gear") {
@fk@%@fkkk#%kf%kfk#f#%f#k#kkf@#k(midX + 0.4, midY - 0.1)
}
else if (kkk#f%k@fkkf%@fkf#fkf@ff = "honey") {
@%@ff@fk#f%fk@kff#k#kkf@#k(midX + 0.4, midY)
}
Sleep, 500
Loop, 5 {
Send, {WheelDown}
Sleep, 20
}
@f%kfk@#k%k@kff#k#kkf@#k(midX, midY)
}


ffkfkff#ff#f(#fk##ff#ff@ff#kf := 0, kfkffkkkk@ffk@ := 0, k@ffkkkf@k#ff@ff := "nil") {
if ((#fk##f%fk#kkk%f#ff@ff%ff@k#f%#kf = 1 && kfkf%#fff@k%fkkkk@ffk@ = 1) || (#fk##%@ffkkfff%ff#ff@ff#kf = 0 && kfkff%fk#kff@f%kk%#kk#k#k#%kk@ffk@ = 0) || k@ffk%kkf@kfff%k%ffkfkk%kf@k#ff@ff = "nil") {
Return
}
if (kfkf%k@ffffkk%fkkkk@ffk@) {
Send, {%k@ffkkkf@k#ff@ff%%#kk#k#k#%%fk#fk#%}
Sleep, 200
Send, {%k@fkkf%%k@ffkkkf@k#ff@ff%%fkffk#k#%}
}
else if (#fk##ff%k@f#@k%#ff@ff#kf) {
Send, {%f#fk@f%%#f@k%%k@ffkkkf@k#ff@ff%}
}
}


k#@kkfkff#fff@() {
Loop, 4 {
Send {Escape}
Sleep, 100
}
}


kk@kk#kf#ffk@k(f#ff#kf@kff#k# := 0) {
global windowIDS
global idDisplay
global firstWindow
windowIDS := []
idDisplay := ""
firstWindow := ""
WinGet, robloxWindows, List, ahk_exe RobloxPlayerBeta.exe
Loop, %robloxWindows% {
windowIDS.Push(robloxWindows%A_Index%)
idDisplay .= windowIDS[A_Index] . ", "
}
firstWindow := % windowIDS[1]
StringTrimRight, idDisplay, idDisplay, 2
if (f#%@kkk@f@k%f%kf#f%f#kf@kff#k#) {
Return windowIDS[f#ff#kf%kkk@#f%@kff#k#]
}
}


kfk#@k@kfkkk@ff@(kkk#fkfkf#k@#f#f, ff#f@kf@fkk#f#kf) {
StringUpper, kkk#%kfk@#k%fkfkf#k@#f#f, kkk#%@kkk@f@k%fkfkf%f@k@%#k@#f#f, T
if (ff#f%kffk%@kf@fkk#f#kf) {
Sleep, 500
if (kkk%ffkk%#fkfkf#k@#f#f = "Honey") {
if (UINavigationFix) {
f%#k#k@fkf%%k#f#k#@f%kfkk@@k@kkk("2223331111140", 1, 1)
}
else {
fkf%ff#k@k@k%kk@@k@kkk("43333311140320", 1, 1)
}
}
else {
fkfkk%@kkk@f@k%@@k@kkk("4330320", 1, 1)
}
}
else {
ToolTip, % "Error In Detecting " . kkk#fk%f##f@fk@%fkf#k@#f#f
SetTimer, kkk#%f@#f#kkk%fkk#ff#kfkfkfk@ff#f@, -1500
f%fkk#%%#fff%fk@@f@ff@@k(webhookURL, "Failed To Detect " . kkk#fkf%k#f#k#@f%kf#k@%k#ff#f%#f#f . " kkk#fkf%@kk#%kf#k@#f#f Opening [Error]" . (PingSelected ? " <@" . discordUserID . ">" : ""))
fkfkk%#fff%@@k@kkk("3332223111133322231111054105")
}
}


kk@fk#k@f#k#k#(k@fkkk@f#fkk := 0, #f@f@k#f@f@kk# := 1) {
}


k@k##kf@f@@k@f#k() {
}


#fkff@f@@fffkfk@(ff#kkffkfffffk, kfkfkk#f@f@kff := 10, k@#ffkkkk#@kkk := 0.0, kf@kff@f#kk##k := 0.0, k@kkk#k@k@f#@fkk := 1.0, fff@@kf@k#fff# := 1.0) {
global UINavigationFix
global selectedEggItems
global currentItem
eggsCompleted := 0
isSelected := 0
eggColorMap := Object()
eggColorMap["Common Egg"]    := "0xFFFFFF"
eggColorMap["Uncommon Egg"]  := "0x81A7D3"
eggColorMap["Rare Egg"]      := "0xBB5421"
eggColorMap["Legendary Egg"] := "0x2D78A3"
eggColorMap["Mythical Egg"]  := "0x00CCFF"
eggColorMap["Bug Egg"]       := "0x86FFD5"
Loop, 5 {
for rarity, color in eggColorMap {
currentItem := rarity
isSelected := 0
for i, selected in selectedEggItems {
if (selected = rarity) {
isSelected := 1
break
}
}
if (@kk#@f@%k#f#k#@f%ffk@k#ff@(color, kfkfk%@k@fkf%k#f@%fk#f@kkk%f@kff, 0.41, 0.32, 0.54, 0.38)) {
if (isSelected) {
k@ff%fffff@%f@ffkff@(ff#kkff%ffkfkk%kfffffk, 0, 5, 0.4, 0.60, 0.65, 0.70, 0, 1)
eggsCompleted = 1
break
} else {
if (@kk#@f@%f#k@k@%ffk@k#ff@(ff#%#k#f@fk#%kkffkfffffk, kfkfk%@kkk@f@k%k#f@%@ffk@ffk%f@kff, 0.40, 0.60, 0.65, 0.70)) {
ToolTip, % currentItem . "`nIn Stock, Not Selected"
SetTimer, kkk#fk%k#@fkk%k#ff#kfkfkfk@ff#f@, -1500
ffk@@%ff#k@k@k%f%#k#k@fkf%@ff@@k(webhookURL, currentItem . " In Stock, Not Selected")
}
else {
ToolTip, % currentItem . "`nNot In Stock, Not Selected"
SetTimer, kkk#%kf#f%fkk#ff%fk#fk#%#kfkfkfk@ff#f@, -1500
ffk@@%f#fk@f%f@%kf#f%ff@@k(webhookURL, currentItem . " Not In Stock, Not Selected")
}
if (UINavigationFix) {
fkfkk%kkkkfk#f%%k@k@ff%@@k@kkk(3140, 1, 1)
}
else {
fkfkk@@%@fkkk#%k@kkk(1105, 1, 1)
}
eggsCompleted = 1
break
}
}
}
if (eggsCompleted) {
return
}
Sleep, 1500
}
if (!eggsCompleted) {
fkfk%k#kfk#k@%k%#k#f@fk#%@@k@kkk(5, 1, 1)
ToolTip, Error In Detection
SetTimer, k%f@f@#f%kk%fffk#fk@%#fkk#ff#kfkfkfk@ff#f@, -1500
ffk@@%kffkff#k%f@ff@@k(webhookURL, "Failed To Detect Any Egg [Error]" . (PingSelected ? " <@" . discordUserID . ">" : ""))
}
}


@kk#@f@ffk@k#ff@(#kk#k#ffk@kf@f, k@f#f@kk@ffk@k, k#k#k@k@f@#f := 0.0, k@ff#k#ffkk#kkk@ := 0.0, #k#k#fffffff := 1.0, ffk@kkf@#kk@ := 1.0) {
CoordMode, Pixel, Screen
CoordMode, Mouse, Screen
WinGetPos, winX, winY, winW, winH, ahk_exe RobloxPlayerBeta.exe
x1 := winX + Round(k#k#k%fk#fk#%@k%#fk#%@f@#f * winW)
y1 := winY + Round(k@ff#k#%kfk@#k%ffkk#kkk@ * winH)
x2 := winX + Round(#%@kf#%k#%kfk@#k%k#fffffff * winW)
y2 := winY + Round(ffk%#fk@%@kkf%kffk#k%@#kk@ * winH)
PixelSearch, FoundX, FoundY, x1, y1, x2, y2, #kk%ffkk%#k#f%@kk#%fk@kf@f, k@f#f%k#@fkk%@kk@ffk@k, Fast
if (ErrorLevel = 0) {
return true
}
}


k@fff@ffkff@(k#kkk@@kff@k, fkf##k@f#kk#k##k, k#f#@ffk@k@f := 10, k@#kk#@kk##k#kf# := 0.0, f#ffk#k@fkf@kkff := 0.0, k#@ff@f@fk@f := 1.0, #f#kkf#ff@fkkf := 1.0, f@kf#f@f#ff# := 1, k@f#@kfffkkfk#f# := 0) {
CoordMode, Pixel, Screen
CoordMode, Mouse, Screen
stock := 0
eggDetected := 0
global currentItem
global UINavigationFix
pingItems := ["Bamboo Seed", "Coconut Seed", "Cactus Seed", "Dragon Fruit Seed", "Mango Seed", "Grape Seed", "Mushroom Seed", "Pepper Seed"
, "Cacao Seed", "Beanstalk Seed"
, "Basic Sprinkler", "Advanced Sprinkler", "Godly Sprinkler", "Lightning Rod", "Master Sprinkler"
, "Rare Egg", "Legendary Egg", "Mythical Egg", "Bug Egg"
, "Flower Seed Pack", "Nectarine Seed", "Hive Fruit Seed", "Honey Sprinkler"
, "Bee Egg", "Bee Crate", "Honey Comb", "Bee Chair", "Honey Torch", "Honey Walkway"]
ping := false
if (PingSelected) {
for i, pingitem in pingItems {
if (pingitem = currentItem) {
ping := true
break
}
}
}
WinGetPos, winX, winY, winW, winH, ahk_exe RobloxPlayerBeta.exe
x1 := winX + Round(k@#k%@f@k%k#@kk##k#kf# * winW)
y1 := winY + Round(f#ffk#%k@fkkf%%k@kk@k%k@fkf@kkff * winH)
x2 := winX + Round(k#%@k@kk@f#%@ff@f@fk@f * winW)
y2 := winY + Round(#%fkfk%f#kkf#ff@fkkf * winH)
if (f@kf#%kffk#k%f@f#ff#) {
for index, color in [k#k%#kk#@f%kk@@kff@k, fk%@f#kfk%f##k@f#kk#k##k] {
PixelSearch, FoundX, FoundY, x1, y1, x2, y2, %color%, k#%kfk#f#%f#@f%k#ff%fk@k@f, Fast RGB
if (ErrorLevel = 0) {
stock := 1
ToolTip, %currentItem% `nIn Stock
SetTimer, kk%kkfff#ff%k#fkk#%f##f@fk@%ff#kfkfkfk@ff#f@, -1500
fkfkk%f@f@#f%@@k@kkk(50, 0, 1, 1)
Sleep, 50
if (ping)
ffk@@%f#@f%f@ff@@k(webhookURL, "Bought " . currentItem . ". <@" . discordUserID . ">")
else
f%f##kkkkf%fk@@%k@ffff#f%f@ff@@k(webhookURL, "Bought " . currentItem . ".")
}
}
}
if (k@f#@kf%#kk#@f%ffkkfk#f#) {
PixelSearch, FoundX, FoundY, x1, y1, x2, y2, k#%k#f@%kkk@@%ffkf%kff@k, k#f#@%ffkk%%ff@k#f%ffk@k@f, Fast RGB
if (ErrorLevel = 0) {
stock := 1
ToolTip, %currentItem% `nIn Stock
SetTimer, kkk#fkk%k@fkkf%#ff#kfkfkfk@ff#f@, -1500
f%ffkfkk%%#k@kff%kfkk@@k@kkk(500, 1, 1)
Sleep, 50
if (ping)
ffk@%f##f@fk@%@f@ff@@k(webhookURL, "Bought " . currentItem . ". <@" . discordUserID . ">")
else
ffk@@%@kkk@f@k%f@ff@@k(webhookURL, "Bought " . currentItem . ".")
}
if (!stock) {
if (UINavigationFix) {
fk%@kk@k@%%#k@kff%fkk@@k@kkk(3140, 1, 1)
}
else {
fkfk%kfk@#k%k%fkfk%@@k@kkk(1105, 1, 1)
}
ffk%kfk@#k%@%fkfk%@f@ff@@k(webhookURL, currentItem . " Not In Stock.")
}
}
Sleep, 100
if (!stock) {
ToolTip, %currentItem% `nNot In Stock
SetTimer, kkk#fkk%fk#kk@#k%#ff#kfkfkfk@ff#f@, -1500
}
}


seedItems := ["Carrot Seed", "Strawberry Seed", "Blueberry Seed", "Orange Tulip"
, "Tomato Seed", "Corn Seed", "Daffodil Seed", "Watermelon Seed"
, "Pumpkin Seed", "Apple Seed", "Bamboo Seed", "Coconut Seed"
, "Cactus Seed", "Dragon Fruit Seed", "Mango Seed", "Grape Seed"
, "Mushroom Seed", "Pepper Seed", "Cacao Seed", "Beanstalk Seed", "Ember Lily"]
gearItems := ["Watering Can", "Trowel", "Recall Wrench", "Basic Sprinkler", "Advanced Sprinkler"
, "Godly Sprinkler", "Lightning Rod", "Master Sprinkler", "Favorite Tool", "Harvest Tool", "Friendship Pot"]
eggItems := ["Common Egg", "Uncommon Egg", "Rare Egg", "Legendary Egg", "Mythical Egg"
, "Bug Egg"]
cosmeticItems := ["Cosmetic 1", "Cosmetic 2", "Cosmetic 3", "Cosmetic 4", "Cosmetic 5"
, "Cosmetic 6",  "Cosmetic 7", "Cosmetic 8", "Cosmetic 9"]
honeyItems := ["Flower Seed Pack", "placeHolder1", "Lavender Seed", "Nectarshade Seed", "Nectarine Seed", "Hive Fruit Seed", "Pollen Rader", "Nectar Staff"
, "Honey Sprinkler", "Bee Egg", "placeHolder2", "Bee Crate", "placeHolder3", "Honey Comb", "Bee Chair", "Honey Torch", "Honey Walkway"]
realHoneyItems := ["Flower Seed Pack", "Lavender Seed", "Nectarshade Seed", "Nectarine Seed", "Hive Fruit Seed", "Pollen Rader", "Nectar Staff"
, "Honey Sprinkler", "Bee Egg", "Bee Crate", "Honey Comb", "Bee Chair", "Honey Torch", "Honey Walkway"]

settingsFile := A_ScriptDir "\settings.ini"

URLEncode(str)
{
static chars := "0123456789ABCDEF"
VarSetCapacity(out, StrLen(str)*3, 0)
j := 0
Loop, Parse, str
{
asc := Asc(A_LoopField)
if ( (asc >= 48 && asc <= 57)
|| (asc >= 65 && asc <= 90)
|| (asc >= 97 && asc <= 122)
|| asc = 45 || asc = 46
|| asc = 95 || asc = 126 )
{
out .= Chr(asc)
}
else if (asc == 32)
{
out .= "+"
}
else
{
hi := asc >> 4
lo := asc & 0xF
out .= "%" . SubStr(chars, hi+1, 1) . SubStr(chars, lo+1, 1)
}
}
return out
}
@fff@fkk@fffffkkkf@kf@@f#kkk:
Gui, Destroy
Gui, +Resize +MinimizeBox +SysMenu
Gui, Margin, 10, 10
Gui, Color, 0x202020
Gui, Font, s9 cWhite, Segoe UI
Gui, Add, Tab, x10 y10 w500 h400 vMyTab, Seeds|Gears|Eggs|Honey|Cosmetics|Settings|Credits
Gui, Tab, 1
Gui, Font, s9 c90EE90 Bold, Segoe UI
Gui, Add, GroupBox, x23 y50 w475 h340 c90EE90, Seed Shop Items
IniRead, SelectAllSeeds, %settingsFile%, Seed, SelectAllSeeds, 0
Gui, Add, Checkbox, % "x50 y90 vSelectAllSeeds g@k@fffkk@kfkkk#kffk@@ff@f@@fff#k@kkf c90EE90 " . (SelectAllSeeds ? "Checked" : ""), Select All Seeds
Loop, % seedItems.Length() {
IniRead, sVal, %settingsFile%, Seed, Item%A_Index%, 0
if (A_Index > 18) {
col := 350
idx := A_Index - 19
yBase := 125
}
else if (A_Index > 9) {
col := 200
idx := A_Index - 10
yBase := 125
}
else {
col := 50
idx := A_Index
yBase := 100
}
y := yBase + (idx * 25)
Gui, Add, Checkbox, % "x" col " y" y " vSeedItem" A_Index " g@k@fffkk@kfkkk#kffk@@ff@f@@fff#k@kkf cD3D3D3 " . (sVal ? "Checked" : ""), % seedItems[A_Index]
}
Gui, Tab, 2
Gui, Font, s9 c87CEEB Bold, Segoe UI
Gui, Add, GroupBox, x23 y50 w475 h340 c87CEEB, Gear Shop Items
IniRead, SelectAllGears, %settingsFile%, Gear, SelectAllGears, 0
Gui, Add, Checkbox, % "x50 y90 vSelectAllGears g@k@fffkk@kfkkk#kffk@@ff@f@@fff#k@kkf c87CEEB " . (SelectAllGears ? "Checked" : ""), Select All Gears
Loop, % gearItems.Length() {
IniRead, gVal, %settingsFile%, Gear, Item%A_Index%, 0
if (A_Index > 9) {
col := 200
idx := A_Index - 10
yBase := 125
}
else {
col := 50
idx := A_Index
yBase := 100
}
y := yBase + (idx * 25)
Gui, Add, Checkbox, % "x" col " y" y " vGearItem" A_Index " g@k@fffkk@kfkkk#kffk@@ff@f@@fff#k@kkf cD3D3D3 " . (gVal ? "Checked" : ""), % gearItems[A_Index]
}
Gui, Tab, 3
Gui, Font, s9 ce87b07 Bold, Segoe UI
Gui, Add, GroupBox, x23 y50 w475 h340 ce87b07, Egg Shop
IniRead, SelectAllEggs, %settingsFile%, Egg, SelectAllEggs, 0
Gui, Add, Checkbox, % "x50 y90 vSelectAllEggs g@k@fffkk@kfkkk#kffk@@ff@f@@fff#k@kkf ce87b07 " . (SelectAllEggs ? "Checked" : ""), Select All Eggs
Loop, % eggItems.Length() {
IniRead, eVal, %settingsFile%, Egg, Item%A_Index%, 0
y := 125 + (A_Index - 1) * 25
Gui, Add, Checkbox, % "x50 y" y " vEggItem" A_Index " g@k@fffkk@kfkkk#kffk@@ff@f@@fff#k@kkf cD3D3D3 " . (eVal ? "Checked" : ""), % eggItems[A_Index]
}
Gui, Tab, 4
Gui, Font, s9 ce8ac07 Bold, Segoe UI
Gui, Add, GroupBox, x23 y50 w475 h340 ce8ac07, Honey Shop
IniRead, AutoCollectPollinated, %settingsFile%, Honey, AutoCollectPollinated, 0
Gui, Add, Checkbox, % "x50 y90 vAutoCollectPollinated ce8ac07 " . (AutoCollectPollinated ? "Checked" : ""), Auto-Collect Pollinated Plants
IniRead, AutoHoney, %settingsFile%, Honey, AutoHoney, 0
Gui, Add, Checkbox, % "x50 y115 vAutoHoney ce8ac07 " . (AutoHoney ? "Checked" : ""), Auto-Deposit Honey
IniRead, SelectAllHoney, %settingsFile%, Honey, SelectAllHoney, 0
Gui, Add, Checkbox, % "x50 y140 vSelectAllHoney g@k@fffkk@kfkkk#kffk@@ff@f@@fff#k@kkf ce8ac07 " . (SelectAllHoney ? "Checked" : ""), Select All Honey Items
Loop, % realHoneyItems.Length() {
IniRead, gVal, %settingsFile%, Honey, Item%A_Index%, 0
if (A_Index > 7) {
col := 200
idx := A_Index - 8
yBase := 175
} else {
col := 50
idx := A_Index
yBase := 150
}
y := yBase + (idx * 25)
Gui, Add, Checkbox, % "x" col " y" y " vHoneyItem" A_Index " g@k@fffkk@kfkkk#kffk@@ff@f@@fff#k@kkf cD3D3D3 " . (gVal ? "Checked" : ""), % realHoneyItems[A_Index]
}
Gui, Tab, 5
Gui, Font, s9 cD41551 Bold, Segoe UI
Gui, Add, GroupBox, x23 y50 w475 h340 cD41551, Cosmetic Shop
IniRead, BuyAllCosmetics, %settingsFile%, Cosmetic, BuyAllCosmetics, 0
Gui, Add, Checkbox, % "x50 y90 vBuyAllCosmetics cD41551 " . (BuyAllCosmetics ? "Checked" : ""), Buy All Cosmetics
Gui, Tab, 6
Gui, Font, s9 cWhite Bold, Segoe UI
Gui, Font, s9, cWhite Bold, Segoe UI
Gui, Add, GroupBox, x23 y50 w475 h340 cD3D3D3, Settings
IniRead, PingSelected, %settingsFile%, Main, PingSelected, 0
pingColor := PingSelected ? "c90EE90" : "cD3D3D3"
Gui, Add, Checkbox, % "x50 y225 vPingSelected gk@@f#fk@ffkffff@ff@ff@#f#fkf " . pingColor . (PingSelected ? " Checked" : ""), Discord Item Pings
IniRead, AutoAlign, %settingsFile%, Main, AutoAlign, 0
autoColor := AutoAlign ? "c90EE90" : "cD3D3D3"
Gui, Add, Checkbox, % "x50 y250 vAutoAlign gk@@f#fk@ffkffff@ff@ff@#f#fkf " . autoColor . (AutoAlign ? " Checked" : ""), Auto-Align
IniRead, MultiInstanceMode, %settingsFile%, Main, MultiInstanceMode, 0
multiInstanceColor := MultiInstanceMode ? "c90EE90" : "cD3D3D3"
Gui, Add, Checkbox, % "x50 y275 vMultiInstanceMode gk@@f#fk@ffkffff@ff@ff@#f#fkf " . multiInstanceColor . (MultiInstanceMode ? " Checked" : ""), Multi-Instance Mode
IniRead, UINavigationFix, %settingsFile%, Main, UINavigationFix, 0
uiNavigationFixColor := UINavigationFix ? "c90EE90" : "cD3D3D3"
Gui, Add, Checkbox, % "x50 y300 vUINavigationFix gk@@f#fk@ffkffff@ff@ff@#f#fkf " . uiNavigationFixColor . (UINavigationFix ? " Checked" : ""), UI Navigation Fix
Gui, Font, s8 cD3D3D3 Bold, Segoe UI
Gui, Add, Text, x50 y90, Webhook URL:
Gui, Font, s8 cBlack, Segoe UI
IniRead, savedWebhook, %settingsFile%, Main, UserWebhook
if (savedWebhook = "ERROR") {
savedWebhook := ""
}
Gui, Add, Edit, x140 y90 w250 h18 vwebhookURL +BackgroundFFFFFF, %savedWebhook%
Gui, Font, s8 cWhite, Segoe UI
Gui, Add, Button, x400 y90 w85 h18 g#fkkkkk#kff@f#kkfkfk@k@kk@fk@ff#fff# Background202020, Save Webhook
Gui, Font, s8 cD3D3D3 Bold, Segoe UI
Gui, Add, Text, x50 y115, Discord User ID:
Gui, Font, s8 cBlack, Segoe UI
IniRead, savedUserID, %settingsFile%, Main, DiscordUserID
if (savedUserID = "ERROR") {
savedUserID := ""
}
Gui, Add, Edit, x140 y115 w250 h18 vdiscordUserID +BackgroundFFFFFF, %savedUserID%
Gui, Font, s8 cD3D3D3 Bold, Segoe UI
Gui, Add, Button, x400 y115 w85 h18 gf##fk#@k@fk@#ff#fk#fk@kkfff@ Background202020, Save UserID
IniRead, savedUserID, %settingsFile%, Main, DiscordUserID
Gui, Add, Text, x50 y140, Private Server:
Gui, Font, s8 cBlack, Segoe UI
IniRead, savedServerLink, %settingsFile%, Main, PrivateServerLink
if (savedServerLink = "ERROR") {
savedServerLink := ""
}
Gui, Add, Edit, x140 y140 w250 h18 vprivateServerLink +BackgroundFFFFFF, %savedServerLink%
Gui, Font, s8 cD3D3D3 Bold, Segoe UI
Gui, Add, Button, x400 y140 w85 h18 gkff@#fkf#kffk#fkkkf#@fff#ff# Background202020, Save Link
Gui, Add, Button, x400 y165 w85 h18 gfff#fk#fkk#f@kk@k@f#@k#f#k Background202020, Clear Saves
Gui, Font, s8 cD3D3D3 Bold, Segoe UI
Gui, Add, Text, x50 y165, UI Navigation Keybind:
Gui, Font, s8 cBlack, Segoe UI
IniRead, SavedKeybind, %settingsFile%, Main, UINavigationKeybind, \
Gui, Add, DropDownList, vSavedKeybind g#k@k@fkfk@ffkk#kkfkfk@#kffk@f@k#f@fk@fk#fk x180 y165 w50, \|#|[
GuiControl, ChooseString, SavedKeybind, %SavedKeybind%
Gui, Font, s8 cD3D3D3 Bold, Segoe UI
Gui, Add, Text, x50 y190, Macro Speed:
Gui, Font, s8 cBlack, Segoe UI
IniRead, SavedSpeed, %settingsFile%, Main, MacroSpeed, Stable
Gui, Add, DropDownList, vSavedSpeed g#k@f#f@kk#@k@k@k#fffffkkf#kk@fk# x130 y190 w50, Stable|Fast|Ultra|Max
GuiControl, ChooseString, SavedSpeed, %SavedSpeed%
Gui, Font, s10 cWhite Bold, Segoe UI
Gui, Add, Button, x50 y335 w150 h40 gkkkfkffkk@kkkf#ff#fkfk#fkkkk#kk@f@f#ff Background202020, Start Macro (F5)
Gui, Add, Button, x320 y335 w150 h40 g@fk#@ff@kf@kfk#k#f@kkfkkkff#f#@kfk@fk# Background202020, Stop Macro (F7)
Gui, Tab, 7
Gui, Font, s9 cWhite Bold, Segoe UI
Gui, Add, GroupBox, x23 y50 w475 h340 cD3D3D3, Credits
Gui, Add, Picture, x40 y70 w48 h48, % mainDir "Images\\Josh.png"
Gui, Font, s10 cWhite Bold, Segoe UI
Gui, Add, Text, x100 y70 w200 h24, Josh
Gui, Font, s8 cFFC0CB Italic, Segoe UI
Gui, Add, Text, x100 y96 w200 h16, Made this free
Gui, Font, s8 cWhite, Segoe UI
Gui, Add, Text, x40 y130 w200 h40, Selling an ahk script for 500 robux is terrible, anyways ur obsfucator is ass
Gui, Add, Text, x40 y200 w200 h20, Extra Resources:
Gui, Font, s8 cD3D3D3 Underline, Segoe UI
Gui, Add, Link, x40 y244 w300 h16,  Check the <a href="https://github.com/Josh-AS/Virage-Grow-A-Garden-Macro-PREMIUM-CRACKED-/">Github</a> for the latest macro updates!
Gui, Show, w520 h425, Virage GAG Macro (JoshAS Crack)
Return
#fkkkkk#kff@f#kkfkfk@k@kk@fk@ff#fff#:
Gui, Submit, NoHide
k#k%f@f@#f%k@%fkkk@kfk%ff@ff#f@f@k(webhookURL, 1, "webhook")
Return
f##fk#@k@fk@#ff#fk#fk@kkfff@:
Gui, Submit, NoHide
if (discordUserID != "") {
IniWrite, %discordUserID%, %settingsFile%, Main, DiscordUserID
MsgBox, 0, Message, Discord UserID Saved
}
Return
kff@#fkf#kffk#fkkkf#@fff#ff#:
Gui, Submit, NoHide
k#%#ff#k#k#%kk%kkf@kfff%@ff@ff#f@f@k(privateServerLink, 1, "privateserver")
Return
fff#fk#fkk#f@kk@k@f#@k#f#k:
IniWrite, %A_Space%, %settingsFile%, Main, UserWebhook
IniWrite, %A_Space%, %settingsFile%, Main, DiscordUserID
IniWrite, %A_Space%, %settingsFile%, Main, PrivateServerLink
IniRead, savedWebhook, %settingsFile%, Main, UserWebhook
IniRead, savedUserID, %settingsFile%, Main, DiscordUserID
IniRead, savedServerLink, %settingsFile%, Main, PrivateServerLink
GuiControl,, webhookURL, %savedWebhook%
GuiControl,, discordUserID, %savedUserID%
GuiControl,, privateServerLink, %savedServerLink%
MsgBox, 0, Message, Webhook, User Id, and Private Server Link Cleared
Return
#k@k@fkfk@ffkk#kkfkfk@#kffk@f@k#f@fk@fk#fk:
Gui, Submit, NoHide
IniWrite, %SavedKeybind%, %settingsFile%, Main, UINavigationKeybind
GuiControl, ChooseString, SavedKeybind, %SavedKeybind%
MsgBox, 0, Message, % "Keybind saved as: " . SavedKeybind
Return
#k@f#f@kk#@k@k@k#fffffkkf#kk@fk#:
Gui, Submit, NoHide
IniWrite, %SavedSpeed%, %settingsFile%, Main, MacroSpeed
GuiControl, ChooseString, SavedSpeed, %SavedSpeed%
if (SavedSpeed = "Fast") {
MsgBox, 0, Disclaimer, % "Macro speed set to " . SavedSpeed . ". Use with caution (Requires a stable FPS rate)."
}
else if (SavedSpeed = "Ultra") {
MsgBox, 0, Disclaimer, % "Macro speed set to " . SavedSpeed . ". Use at your own risk, high chance of erroring/breaking (Requires a very stable and high FPS rate)."
}
else if (SavedSpeed = "Max") {
MsgBox, 0, Disclaimer, % "Macro speed set to " . SavedSpeed . ". Zero delay on UI Navigation inputs, I wouldn't recommend actually using this it's mostly here for fun."
}
else {
MsgBox, 0, Message, % "Macro speed set to " . SavedSpeed . ". Recommended for lower end devices."
}
Return
fk@fkfkkfk@kf#kkk#kfk##kk@k@:
Gui, Submit, NoHide
IniWrite, %selectedResolution%, %settingsFile%, Main, Resolution
return
@k@fffkk@kfkkk#kffk@@ff@f@@fff#k@kkf:
Gui, Submit, NoHide
if (SubStr(A_GuiControl, 1, 9) = "SelectAll") {
group := SubStr(A_GuiControl, 10)
controlVar := A_GuiControl
Loop {
item := group . "Item" . A_Index
if (!IsSet(%item%))
break
GuiControl,, %item%, % %controlVar%
}
}
else if (RegExMatch(A_GuiControl, "^(Seed|Gear|Egg|Honey)Item\d+$", m)) {
group := m1
assign := (group = "Seed" || group = "Gear" || group = "Egg") ? "SelectAll" . group . "s" : "SelectAll" . group
if (!%A_GuiControl%)
GuiControl,, %assign%, 0
}
if (A_GuiControl = "SelectAllSeeds") {
Loop, % seedItems.Length()
GuiControl,, SeedItem%A_Index%, % SelectAllSeeds
Gosub, k#%f#kf@k%k%fffff@%ffk#kkkfkkkff#f#fk@f##k@k@f@fkfk@#kf#
}
else if (A_GuiControl = "SelectAllEggs") {
Loop, % eggItems.Length()
GuiControl,, EggItem%A_Index%, % SelectAllEggs
Gosub, k#kff%ffkf#k%k#kkkfkkkff#f#fk@f##k@k@f@fkfk@#kf#
}
else if (A_GuiControl = "SelectAllGears") {
Loop, % gearItems.Length()
GuiControl,, GearItem%A_Index%, % SelectAllGears
Gosub, k%kkk@#f%#kffk#kkkfkkkff#f#fk@f##k@k@f@fkfk@#kf#
}
else if (A_GuiControl = "SelectAllHoney") {
Loop, % realHoneyItems.Length()
GuiControl,, HoneyItem%A_Index%, % SelectAllHoney
Gosub, k#kffk%#fff@k%#kkkfkkkff#f#fk@f##k@k@f@fkfk@#kf#
}
return
k@@f#fk@ffkffff@ff@ff@#f#fkf:
Gui, Submit, NoHide
autoColor := "+c" . (AutoAlign ? "90EE90" : "D3D3D3")
pingColor := "+c" . (PingSelected ? "90EE90" : "D3D3D3")
multiInstanceColor := "+c" . (MultiInstanceMode ? "90EE90" : "D3D3D3")
uiNavigationFixColor := "+c" . (UINavigationFix ? "90EE90" : "D3D3D3")
GuiControl, %autoColor%, AutoAlign
GuiControl, +Redraw, AutoAlign
GuiControl, %pingColor%, PingSelected
GuiControl, +Redraw, PingSelected
GuiControl, %multiInstanceColor%, MultiInstanceMode
GuiControl, +Redraw, MultiInstanceMode
GuiControl, %uiNavigationFixColor%, UINavigationFix
GuiControl, +Redraw, UINavigationFix
return
@f#kf@f@k@#fk@f@k@@f@kff#kk##k#kkkf#k@k@:
@kff#f@%kf#f%%kkf@kfff%fkffkf##f(A_GuiControl)
Return
kkk#fkk#ff#kfkfkfk@ff#f@:
ToolTip
return
#ff@k@f#kkk@@f#kf#k@k@fff#k#f@kkkk#f#fkfk#:
Gui, 99:Destroy
Return
@k@fk#@f@f#f(f##kff#kf@kff@, #f@kfk#f@kkf#f := "seed") {
global scrollCounts_1080p, scrollCounts_1440p_100, scrollCounts_1440p_125
global gearScroll_1080p, gearScroll_1440p_100, gearScroll_1440p_125
if (#f@kfk%f#fk@f%%k#kfk#k@%#f@kkf#f = "seed") {
arr1 := scrollCounts_1080p
arr2 := scrollCounts_1440p_100
arr3 := scrollCounts_1440p_125
} else if (#f@kfk%#f@k%#f@kkf#f = "gear") {
arr1 := gearScroll_1080p
arr2 := gearScroll_1440p_100
arr3 := gearScroll_1440p_125
}
arr := (selectedResolution = 1) ? arr1
: (selectedResolution = 2) ? arr2
: (selectedResolution = 3) ? arr3
: []
loopCount := arr.HasKey(f##k%fkkk@kfk%ff#%@f#kfk%kf@kff@) ? arr[f##kff%fk#ff@%#kf@kf%f@#fff%f@] : 0
return loopCount
}
@ffkk@kkk#kkk#@fff#fkf#kf@@kkffk@kfk:
Gui, Submit, NoHide
selectedSeedItems := []
Loop, % seedItems.Length() {
if (SeedItem%A_Index%)
selectedSeedItems.Push(seedItems[A_Index])
}
selectedGearItems := []
Loop, % gearItems.Length() {
if (GearItem%A_Index%)
selectedGearItems.Push(gearItems[A_Index])
}
selectedEggItems := []
Loop, % eggItems.Length() {
if (eggItem%A_Index%)
selectedEggItems.Push(eggItems[A_Index])
}
selectedHoneyItems := []
Loop, % realHoneyItems.Length() {
if (HoneyItem%A_Index%)
selectedHoneyItems.Push(realHoneyItems[A_Index])
}
Return
f@f@#kk#f@k#f#() {
result := ""
if (selectedSeedItems.Length()) {
result .= "Seed Items:`n"
for _, name in selectedSeedItems
result .= "  - " name "`n"
}
if (selectedGearItems.Length()) {
result .= "Gear Items:`n"
for _, name in selectedGearItems
result .= "  - " name "`n"
}
if (selectedEggItems.Length()) {
result .= "Egg Items:`n"
for _, name in selectedEggItems
result .= "  - " name "`n"
}
if (selectedHoneyItems.Length()) {
result .= "Honey Items:`n"
for _, name in selectedHoneyItems
result .= "  - " name "`n"
}
return result
}
kkkfkffkk@kkkf#ff#fkfk#fkkkk#kk@f@f#ff:
Gui, Submit, NoHide
global cycleCount
global cycleFinished
global lastGearMinute := -1
global lastSeedMinute := -1
global lastEggShopMinute := -1
global lastCosmeticShopHour := -1
global lastHoneyShopMinute := -1
global lastDepositHoneyMinute := -1
global lastCollectPollinatedHour := -1
started := 1
cycleFinished := 1
currentSection := "kkkfkffkk@kkkf#ff#fkfk#fkkkk#kk@f@f#ff"
SetTimer, kf%k@fkkf%@fkfkf%kfkkk#%k@@f#fkf#ff#kkf#f@fkkkf#f#kk, Off
SetTimer, @f@fk%k@#kkf%@f@f#k%#kkk@k%@kkf@k##kkfk#, Off
kk%fffff@%@kk#kf#ffk@k()
if InStr(A_ScriptDir, A_Temp) {
MsgBox, 16, Error, Please, extract the file before running the macro.
ExitApp
}
if(!windowIDS.MaxIndex()) {
MsgBox, 0, Message, No Roblox Window Found
Return
}
ffk@%kffkff#k%@f@%#fk@%ff@@k(webhookURL, "Macro started.")
if (MultiInstanceMode) {
MsgBox, 1, Multi-Instance Mode, % "You have " . windowIDS.MaxIndex() . " instances open. (Instance ID's: " . idDisplay . ")`nPress OK to start the macro."
IfMsgBox, Cancel
Return
}
if WinExist("ahk_id " . firstWindow) {
WinActivate
WinWaitActive, , , 2
}
if (MultiInstanceMode) {
for window in windowIDS {
currentWindow := % windowIDS[window]
ToolTip, % "Aligning Instance " . window . " (" . currentWindow . ")"
SetTimer, kkk%@f#kfk%#fkk#f%#k@kff%f#kfkfkfk@ff#f@, -5000
WinActivate, % "ahk_id " . currentWindow
Sleep, 500
@fk@k%kffk#k%%#fk#%ff#k#kkf@#k(0.5, 0.5)
Sleep, 100
Gosub, k@%kfk#f#%fkk%@k@fkf%f#fk##k#ff@k#ff@fkk
Sleep, 100
}
}
else {
Sleep, 500
Gosub, k@f%fkffk#k#%kkf#fk##k#ff@k#ff@fkk
Sleep, 100
}
WinActivate, % "ahk_id " . firstWindow
Gui, Submit, NoHide
Gosub, @ffkk@%k@#kkf%kkk#kkk#@fff#fkf#kf@@kkffk@kfk
itemsText := f@f@#kk%kkfff#ff%#f@k#f#()
Sleep, 500
Gosub, fkfkkkk%#k#k@fkf%@@%f#kf@k%kf@kkkffkf#f@k#f##ff@@k@ffk
while (started) {
if (actionQueue.Length()) {
SetTimer, k%k@ffffkk%%kkffkf@k%f@fkfkfk@@f#fkf#ff#kkf#f@fkkkf#f#kk, Off
ToolTip
next := actionQueue.RemoveAt(1)
if (MultiInstanceMode) {
for window in windowIDS {
currentWindow := % windowIDS[window]
instanceNumber := window
ToolTip, % "Running Cycle On Instance " . window
SetTimer, kk%k#@kf@f@%k#fkk#ff#kfkfkfk@ff#f@, -1500
ff%#fff@k%%f#kf@k%k@@f@ff@@k(webhookURL, "***Instance " . instanceNumber . "***")
WinActivate, % "ahk_id " . currentWindow
Sleep, 200
@fk@k%#fk#%ff#k#kkf@#k(midX, midY)
Sleep, 200
Gosub, % next
}
}
else {
WinActivate, % "ahk_id " . firstWindow
Gosub, % next
}
if (!actionQueue.MaxIndex()) {
cycleFinished := 1
}
Sleep, 500
} else {
Gosub, #kkkk%kffk#k%@kfk@#fkf#k#kf#f@
if (cycleFinished) {
WinActivate, % "ahk_id " . firstWindow
cycleCount++
ff%@k@kk@f#%%k#ff%k@@f@ff@@k(webhookURL, "[**CYCLE " . cycleCount . " COMPLETED**]")
cycleFinished := 0
if (!MultiInstanceMode) {
SetTimer, kf@fkf%kfk@%kfk@@f#fkf#ff#kkf#f@fkkkf#f#kk, 5000
}
}
Sleep, 1000
}
}
Return
@f#kkk#k@f@fkfk#f##fkkk#kf:
if (cycleCount > 0 && Mod(currentMinute, 5) = 0 && currentMinute != lastSeedMinute) {
lastSeedMinute := currentMinute
SetTimer, f@@f%#k@k#kk#%f@kk#k#ffkfk@fkff#f@#fkkf#, -8000
}
Return
f@@ff@kk#k#ffkfk@fkff#f@#fkkf#:
actionQueue.Push("#k#ff#f#kkk@@k@kkkkf@fkkkkkk#kk@f@#fff")
Return
#k#ff#f#kkk@@k@kkkkf@fkkkkkk#kk@f@#fff:
currentSection := "#k#ff#f#kkk@@k@kkkkf@fkkkkkk#kk@f@#fff"
if (selectedSeedItems.Length())
Gosub, @k@k%#k@kff%@kf#f@f@f#f##kkkf#fff#fkkkff@f@kkf#k
Return
#ff#@kkffk#k@fkk#kff#kk#@f#fkkf#f@k#fkf##f:
if (cycleCount > 0 && Mod(currentMinute, 5) = 0 && currentMinute != lastGearMinute) {
lastGearMinute := currentMinute
SetTimer, #fkf%f#ffkk%@k@kf%@k#f@f@f%fff#kfff#@kk#@kkfffk@k@kk#kkk@k, -8000
}
Return
#fkf@k@kffff#kfff#@kk#@kkfffk@k@kk#kkk@k:
actionQueue.Push("kff##f#kf@#f@fkkkffkfk")
Return
kff##f#kf@#f@fkkkffkfk:
currentSection := "kff##f#kf@#f@fkkkffkfk"
if (selectedGearItems.Length())
Gosub, f%f@#f#kkk%fk@k#k@%@ff@fk#f%f#k#kkkfk@#fff@ffk@ffk@kf#
Return
k#k@k@fkfk#kkk@k#kk##kk@f#fff@f#:
if (cycleCount > 0 && Mod(currentMinute, 30) = 0 && currentMinute != lastEggShopMinute) {
lastEggShopMinute := currentMinute
SetTimer, fkk%kkfff#ff%kffk#f@@fkff@f#k#@fk@@k#kk@@ff#f@f#, -8000
}
Return
fkkkffk#f@@fkff@f#k#@fk@@k#kk@@ff#f@f#:
actionQueue.Push("k#fk@f@k@kkf#k@fk@kfkf#kf#ffk#@f")
Return
k#fk@f@k@kkf#k@fk@kfkf#kf#ffk#@f:
currentSection := "k#fk@f@k@kkf#k@fk@kfkf#kf#ffk#@f"
if (selectedEggItems.Length()) {
Gosub, kkkk@%k@f#@k%ff@k@#f@ff@f@k#kkf@f#kff#f#@k@kf#kfk@
}
Return
#f#kkk#kfk#fkff@kkf##ffkkkkfkkkkk#f@kf:
if (cycleCount > 0 && currentMinute = 0 && Mod(currentHour, 2) = 0 && currentHour != lastCosmeticShopHour) {
lastCosmeticShopHour := currentHour
SetTimer, f@%fffff@%f#f@@f#f@kkfffk@kk#k@fkfk@ff@fk@#k#f@k, -8000
}
Return
f@f#f@@f#f@kkfffk@kk#k@fkfk@ff@fk@#k#f@k:
actionQueue.Push("kk@ff@fk@ff@k##fkkkfkf@kfk@f@f@k")
Return
kk@ff@fk@ff@k##fkkkfkf@kfk@f@f@k:
currentSection := "kk@ff@fk@ff@k##fkkkfkf@kfk@f@f@k"
if (BuyAllCosmetics) {
Gosub, k@ff%kfk@%k@k##%#k@k#kk#%kkk#fkfk@ff#kffkk
}
Return
k@#k@ff@#kfkk@#k@kkfk#f@f#ff@k#ff#f@@f@ffk:
if (cycleCount > 0 && currentMinute = 0 && currentHour != lastCollectPollinatedHour) {
lastHoneyShopHour := currentHour
SetTimer, #k#k%#kkk@k%k#@kffkkk@fkf@@fkf@kk#f#, -600000
}
Return
#k#kk#@kffkkk@fkf@@fkf@kk#f#:
actionQueue.Push("f#fkf@@fff@kf@kfkk@kf#")
Return
f#fkf@@fff@kf@kfkk@kf#:
currentSection := "f#fkf@@fff@kf@kfkk@kf#"
if (k@#k%k##k%@ff@#kf%@f@k%kk@#k@kkfk#f@f#ff@k#ff#f@@f@ffk) {
Gosub, f#kf@%#ff#k#k#%fk#f#fkf#k#k#ff#k
}
Return
f#kff@fffkk@#kk#kfk##kkk@f@ff@kf#k:
if (cycleCount > 0 && Mod(currentMinute, 30) = 0 && currentMinute != lastHoneyShopMinute) {
lastHoneyShopMinute := currentMinute
SetTimer, @kkff#%@f#kfk%@kfkk@#f#f#k#kf##fkfk@kfk@fff##ff@, -8000
}
Return
@kkff#@kfkk@#f#f#k#kf##fkfk@kfk@fff##ff@:
actionQueue.Push("#kk#fff#@fk@k##ff#@fk#k@")
Return
#kk#fff#@fk@k##ff#@fk#k@:
currentSection := "#kk#fff#@fk@k##ff#@fk#k@"
if (selectedHoneyItems.Length()) {
Gosub, f@k%f#k@k@%kfkkkfk%@ffkkfff%f@kk@kf#k#k#@kfff#ff@f@k@f
}
Return
kf#k#fffkkkfk@kkfff@k@@f:
if (cycleCount > 0 && Mod(currentMinute, 5) = 0 && currentMinute != lastDepositHoneyMinute) {
lastDepositHoneyMinute := currentMinute
SetTimer, f@kf%@kkk@f@k%k@#kffk%kffkff#k%#@f#k@f@ff@fk#kkk@f#f#fk#k@, -8000
}
Return
f@kfk@#kffk#@f#k@f@ff@fk#kkk@f#f#fk#k@:
actionQueue.Push("f##kkf@fk@k@@kkkkff@#ff#k@#k")
Return
f##kkf@fk@k@@kkkkff@#ff#k@#k:
currentSection := "f##kkf@fk@k@@kkkkff@#ff#k@#k"
if (AutoHoney) {
Gosub, fffkk#k%kfk@%k#fkf#k#kf#f@#f#kfk#kk#k@kk#k#kk#k#
}
Return
#kkkk@kfk@#fkf#k#kf#f@:
mod5 := Mod(currentMinute, 5)
rem5min := (mod5 = 0) ? 5 : 5 - mod5
rem5sec := rem5min * 60 - currentSecond
if (rem5sec < 0)
rem5sec := 0
seedMin := rem5sec // 60
seedSec := Mod(rem5sec, 60)
seedText := (seedSec < 10) ? seedMin . ":0" . seedSec : seedMin . ":" . seedSec
gearMin := rem5sec // 60
gearSec := Mod(rem5sec, 60)
gearText := (gearSec < 10) ? gearMin . ":0" . gearSec : gearMin . ":" . gearSec
depositHoneyMin := rem5sec // 60
depositHoneySec := Mod(rem5sec, 60)
depositHoneyText := (depositHoneySec < 10) ? depositHoneyMin . ":0" . depositHoneySec : depositHoneyMin . ":" . depositHoneySec
mod30 := Mod(currentMinute, 30)
rem30min := (mod30 = 0) ? 30 : 30 - mod30
rem30sec := rem30min * 60 - currentSecond
if (rem30sec < 0)
rem30sec := 0
eggMin := rem30sec // 60
eggSec := Mod(rem30sec, 60)
eggText := (eggSec < 10) ? eggMin . ":0" . eggSec : eggMin . ":" . eggSec
honeyMin := rem30sec // 60
honeySec := Mod(rem30sec, 60)
honeyText := (honeySec < 10) ? honeyMin . ":0" . honeySec : honeyMin . ":" . honeySec
totalSecNow := currentHour * 3600 + currentMinute * 60 + currentSecond
nextCosHour := (Floor(currentHour/2) + 1) * 2
nextCosTotal := nextCosHour * 3600
remCossec := nextCosTotal - totalSecNow
if (remCossec < 0)
remCossec := 0
cosH := remCossec // 3600
cosM := (remCossec - cosH*3600) // 60
cosS := Mod(remCossec, 60)
if (cosH > 0)
cosText := cosH . ":" . (cosM < 10 ? "0" . cosM : cosM) . ":" . (cosS < 10 ? "0" . cosS : cosS)
else
cosText := cosM . ":" . (cosS < 10 ? "0" . cosS : cosS)
if (currentMinute = 0 && currentSecond = 0) {
remHoneySec := 0
} else {
remHoneySec := 3600 - (currentMinute * 60 + currentSecond)
}
collectPollinatedMin := remHoneySec // 60
collectPollinatedSec := Mod(remHoneySec, 60)
collectPollinatedText := (collectPollinatedSec < 10) ? collectPollinatedMin . ":0" . collectPollinatedSec : collectPollinatedMin . ":" . collectPollinatedSec
tooltipText := ""
if (selectedSeedItems.Length()) {
tooltipText .= "Seed Shop: " . seedText . "`n"
}
if (selectedGearItems.Length()) {
tooltipText .= "Gear Shop: " . gearText . "`n"
}
if (selectedEggItems.Length()) {
tooltipText .= "Egg Shop : " . eggText . "`n"
}
if (BuyAllCosmetics) {
tooltipText .= "Cosmetic Shop: " . cosText . "`n"
}
if (AutoHoney) {
tooltipText .= "Deposit Honey: " . depositHoneyText . "`n"
}
if (selectedHoneyItems.Length()) {
tooltipText .= "Honey Shop: " . honeyText . "`n"
}
if (k@#k@f%f##kkkkf%f@#kfkk@#k@kkfk#f@f#ff@k#ff#f@@f@ffk) {
tooltipText .= "Collect Pollinated: " . collectPollinatedText . "`n"
}
if (tooltipText != "") {
CoordMode, Mouse, Screen
MouseGetPos, mX, mY
offsetX := 10
offsetY := 10
ToolTip, % tooltipText, % (mX + offsetX), % (mY + offsetY)
} else {
ToolTip
}
Return
fkfkkkk@@kf@kkkffkf#f@k#f##ff@@k@ffk:
SetTimer, k#k%fk#kff@f%kfk@k#f#fkkkkk@kkffk#k@, 1000
if (selectedSeedItems.Length()) {
actionQueue.Push("#k#ff#f#kkk@@k@kkkkf@fkkkkkk#kk@f@#fff")
}
seedAutoActive := 1
SetTimer, @f#kkk%@f@k%#k@f@fkfk#f##fkkk#kf, 1000
if (selectedGearItems.Length()) {
actionQueue.Push("kff##f#kf@#f@fkkkffkfk")
}
gearAutoActive := 1
SetTimer, #ff#%#kf#ff%@kkf%k@kf@f#k%fk#k@fkk#kff#kk#@f#fkkf#f@k#fkf##f, 1000
if (selectedEggItems.Length()) {
actionQueue.Push("k#fk@f@k@kkf#k@fk@kfkf#kf#ffk#@f")
}
eggAutoActive := 1
SetTimer, k#k@k@%@kk@k@%fkfk#kkk@k#kk##kk@f#fff@f#, 1000
if (BuyAllCosmetics) {
actionQueue.Push("kk@ff@fk@ff@k##fkkkfkf@kfk@f@f@k")
}
cosmeticAutoActive := 1
SetTimer, #f#kkk%k##k%#kfk#f%fkkk@kfk%kff@kkf##ffkkkkfkkkkk#f@kf, 1000
if (k@#k@%f##f@fk@%ff@#%fkkk@kfk%kfkk@#k@kkfk#f@f#ff@k#ff#f@@f@ffk) {
actionQueue.Push("f#fkf@@fff@kf@kfkk@kf#")
}
collectPollinatedAutoActive := 1
SetTimer, k@#k@f%fk#f@kkk%f@#kfkk@#k@kkfk#f@f#ff@k#ff#f@@f@ffk, 1000
if (selectedHoneyItems.Length()) {
actionQueue.Push("#kk#fff#@fk@k##ff#@fk#k@")
}
honeyShopAutoActive := 1
SetTimer, f%kk#fk@%%@kfffk%#kff@fffkk@#kk#kfk##kkk@f@ff@kf#k, 1000
if (AutoHoney) {
actionQueue.Push("f##kkf@fk@k@@kkkkff@#ff#k@#k")
}
honeyDepositAutoActive := 1
SetTimer, k%kfk#f#@f%f#%k#f#k#@f%k#fffkkkfk@kkfff@k@@f, 1000
Return
k#kkfk@k#f#fkkkkk@kkffk#k@:
FormatTime, currentHour,, hh
FormatTime, currentMinute,, mm
FormatTime, currentSecond,, ss
currentHour := currentHour + 0
currentMinute := currentMinute + 0
currentSecond := currentSecond + 0
Return
kf@fkfkfk@@f#fkf#ff#kkf#f@fkkkf#f#kk:
global actionQueue
if (@%k#@kf@f@%kk#%@fkkk#%@f@ffk@k#ff@(0x302927, 0, 0.3988, 0.3548, 0.6047, 0.6674) && @kk%ff#fkk%#@%@fk@f@f@%f@ffk@k#ff@(0xFFFFFF, 0, 0.3988, 0.3548, 0.6047, 0.6674) && privateServerLink != "") {
started := 0
actionQueue := []
SetTimer, kf@%#kff#k%fkfkf%ffkf%k@@f#fkf#ff#kkf#f@fkkkf#f#kk, Off
Sleep, 500
WinClose, % "ahk_id" . firstWindow
Sleep, 1000
WinClose, % "ahk_id" . firstWindow
Sleep, 500
Run, % privateServerLink
ToolTip, Attempting To Reconnect
SetTimer, kkk%fkkk@kfk%#f%f@f@#f%kk#ff#kfkfkfk@ff#f@, -5000
ffk@@%kf#f%f@ff@%fk#ff@%@k(webhookURL, "Lost connection or macro errored, attempting to reconnect..." . (PingSelected ? " <@" . discordUserID . ">" : ""))
f%#f@k%#@f@kk@k@@fkf(15000, 30000)
SetTimer, @f@fk@%k@kf@f#k%f%@kf#%@f#k@kkf@k##kkfk#, 5000
}
Return
@f@fk@f@f#k@kkf@k##kkfk#:
ToolTip, Detecting Rejoin
kk@%f##kkkkf%kk#k%fkfk%f#ffk@k()
WinActivate, % "ahk_id" . firstWindow
if (@kk#@%@fkkk#%f@%@ffkkfff%ffk@k#ff@(0x000000, 0, 0.75, 0.75, 0.9, 0.9)) {
@fk@k%k@#kff#f%ff#k#kkf@#k(midX, midY)
}
else {
ToolTip, Rejoined Successfully
f#%ff@fkff@%%ff@fkff@%@f@kk@k@@fkf(5000, 10000)
ffk@%fk#kk@#k%@f@f%kkf@kfff%f@@k(webhookURL, "Successfully reconnected to server." . (PingSelected ? " <@" . discordUserID . ">" : ""))
Sleep, 200
Gosub, kkkf%kkf@kfff%%fk#fk#%kffkk@kkkf#ff#fkfk#fkkkk#kk@f@f#ff
}
Return
k@fkkf#fk##k#ff@k#ff@fkk:
ToolTip, Beginning Alignment
SetTimer, kkk#f%@k#f@f@f%kk#ff#kfkfkfk@ff#f@, -5000
@fk@k%fk#fk#%ff#k#kkf@#k(0.5, 0.5)
Sleep, 100
@k#k@%k@ffffkk%f@f%kkk@#f%k#ff("recall")
Sleep, 200
if (AutoAlign) {
GoSub, @fkf@kk%f#k@k@%#ff#f#%#k@k#kk#%fkkkkk@kkfk@k#k
Sleep, 100
Gosub, #ffk%k#f#k#@f%#kk@%k#f#k#@f%k@#ff#@fffkff@#fkfkff#fffkk@ff
Sleep, 100
GoSub, #fkf#ff%@kf#%f@kf##fkkf#k@kfkf#fkkff@k
Sleep, 100
Gosub, kkkf%@k@kk@f#%kf%kkfff#ff%kf#f@fk##kf#fffk
Sleep, 100
Gosub, @fkf@k%kf#f%k#ff#f#fkkkkk@kkfk@k#k
Sleep, 100
}
else {
Gosub, #ffk#%k#f@%kk@k@#f%f##f@fk@%f#@fffkff@#fkfkff#fffkk@ff
Sleep, 100
}
Sleep, 1000
fkfkk%f#fk@f%@@k@kkk(11110)
Sleep, 100
ToolTip, Alignment Complete
SetTimer, k%ff#fkk%kk#fkk#ff#kfkfkfk@ff#f@, -1000
Return
@fkf@kk#ff#f#fkkkkk@kkfk@k#k:
Send, {Escape}
Sleep, 500
Send, {Tab}
Sleep, 400
Send {Down}
Sleep, 100
fk#kfkk%kffk#k%k%#kff#k%k#fff@kk("Right", 2, (SavedSpeed = "Ultra") ? 55 : (SavedSpeed = "Max") ? 60 : 30)
Sleep, 100
Send {Escape}
Return
#fkf#fff@kf##fkkf#k@kfkf#fkkff@k:
Click, Right, Down
Sleep, 200
f%kfk#f#@f%%f#fk@f%k#kf@fkf@f@#k(0.5, 0.5)
Sleep, 200
MouseMove, 0, 800, R
Sleep, 200
Click, Right, Up
Return
#ffk#kk@k@#ff#@fffkff@#fkfkff#fffkk@ff:
fk#kf%@kk@k@%@f%k@#kkf%kf@f@#k(0.5, 0.5)
Sleep, 100
Loop, 40 {
Send, {WheelUp}
Sleep, 20
}
Sleep, 200
Loop, 6 {
Send, {WheelDown}
Sleep, 20
}
midX := f%kfk#f#@f%f#ff#f@kkff("x")
midY := ff#f%fk#f@kkk%f#f@k%@k#f@f@f%kff("y")
Return
kkkfkfkf#f@fk##kf#fffk:
k%k@ffff#f%f@%@kfffk%k#kkfkk#kk#(SavedKeybind)
Sleep, 10
if (UINavigationFix) {
fk#k%kk#fk@%fkkk%kffkff#k%k#fff@kk("Left", 5)
Sleep, 10
fk#kf%fkk#%kkkk#fff@kk("Up", 5)
Sleep, 10
}
fk%@k@fkf%#kf%fk#ff@%kkkk#fff@kk("Right", 3)
Loop, % ((SavedSpeed = "Ultra") ? 12 : (SavedSpeed = "Max") ? 18 : 8) {
Send, {Enter}
Sleep, 10
fk#%k#ff#f%kfkkkk%fkfk%#fff@kk("Right", 2)
Sleep, 10
Send, {Enter}
Sleep, 10
f%ffkfkk%k#kfk%f@#fff%kkk#fff@kk("Left", 2)
}
Sleep, 10
k%k@#kkf%f@k%fk#f@kkk%#kkfkk#kk#(SavedKeybind)
Return
kkkk@ff@k@#f@ff@f@k#kkf@f#kff#f#@k@kf#kfk@:
Sleep, 100
f%kfk#f#@f%kfkk@%k#ff%@k@kkk("11110")
Sleep, 100
ffkfkf%k#f@%f#ff#f(1, 0, "2")
f#@%fffk#fk@%f@kk%@kfffk%@k@@fkf(100, 1000)
@fk@k%f@#kfkkk%ff#k#kkf@#k(midX, midY)
f%fk#kk@#k%%k@f#@k%fk@@f@ff@@k(webhookURL, "**[Egg Cycle]**")
Sleep, 800
Send, {w Down}
Sleep, 1800
Send {w Up}
f#@%k@kk@k%f@kk@k@@fkf(500, 1000)
Send {e}
Sleep, 100
fkfkk@@%kkfff#ff%k@kkk("11114", 0, 0)
Sleep, 100
#f%#k#f@fk#%kff@f@@fffkfk@(0x26EE26, 15, 0.41, 0.65, 0.52, 0.70)
Sleep, 800
Send, {w down}
Sleep, 200
Send, {w up}
f#@f@k%f@#kfkkk%k@k@@fkf(100, 1000)
Send {e}
Sleep, 100
fkfkk@%f#@f%@k@kkk("11114", 0, 0)
Sleep, 100
#fkf%fffff@%f@f@@%k@fkkf%fffkfk@(0x26EE26, 15, 0.41, 0.65, 0.52, 0.70)
Sleep, 800
Send, {w down}
Sleep, 200
Send, {w up}
f%@kk#%#@f@%#kff#k%kk@k@@fkf(100, 1000)
Send, {e}
Sleep, 200
fkfkk%#k@kff%@@k@kkk("11114", 0, 0)
Sleep, 100
#fkff@f%#fff%@@fffkfk@(0x26EE26, 15, 0.41, 0.65, 0.52, 0.70)
Sleep, 300
k#%f#kf@k%@kk%#fff%fkff#fff@()
f#@f@k%f@f@#f%k@%#k@k#kk#%k@@fkf(1250, 2500)
ffk%fk#kk@#k%%kkfff#ff%@@f@ff@@k(webhookURL, "**[Eggs Completed]**")
Return
@k@k@kf#f@f@f#f##kkkf#fff#fkkkff@f@kkf#k:
seedsCompleted := 0
fk%@kf#%fkk%k@kf@f#k%@@k@kkk("1111020")
f#%ffkf%@%k#@fkk%f@kk@k@@fkf(100, 1000)
Send, {e}
ffk@@%fk#fk#%f@ff%k@k@ff%@@k(webhookURL, "**[Seed Cycle]**")
f#@f@%fkfk%kk@k@@fkf(2500, 5000)
Loop, 5 {
if (@%#fff%kk#@f@ffk@k#ff@(0x00CCFF, 10, 0.54, 0.20, 0.65, 0.325)) {
ToolTip, Seed Shop Opened
SetTimer, kkk%@k@kk@f#%#fkk#ff%kkfff#ff%#kfkfkfk@ff#f@, -1500
ffk@@%fff#k@k@%f@ff@@k(webhookURL, "Seed Shop Opened.")
Sleep, 200
fkfk%@f#kfk%k@@k@kkk("33311443333114405550555", 0)
Sleep, 100
k@f%ffkf#k%%fffk#fk@%@kf#f@f@kk#kf("seed")
ffk@@%fk#kk@#k%f@ff@@k(webhookURL, "Seed Shop Closed.")
seedsCompleted = 1
}
if (seedsCompleted) {
break
}
Sleep, 2000
}
kfk#%ff#k@k@k%@k@kfkkk@ff@("seed", seedsCompleted)
f%kfk@%fk@@f@ff@@k(webhookURL, "**[Seeds Completed]**")
Return
ffk@k#k@f#k#kkkfk@#fff@ffk@ffk@kf#:
gearsCompleted := 0
ffkf%#k#f@fk#%kff#f%@f@k%f#f(0, 1, "0")
fk%k@#kk#%%@k@fkf%fkk@@k@kkk("11110")
f#@%k@kf@f#k%f@kk@k@@fkf(100, 500)
ffk%@f#kfk%fkff%f#@f%#ff#f(1, 0, "2")
f#@f%kffk%@kk@k@@fkf(100, 500)
@fk@kf%k@#kk#%f#k#k%@ff@fk#f%kf@#k(midX, midY)
f#@f@k%fk#kkk%k@k@%fk#kff@f%@fkf(1200, 2500)
Send, {e}
f#@f@kk%kfkkk#%@k@@fkf(1500, 5000)
f#f%@k@fkf%@@fff%f#k@k@%fkf@("gear")
ffk@@f@%kfk@%ff@@k(webhookURL, "**[Gear Cycle]**")
f#@f@kk%kffk%@k@@fkf(2500, 5000)
Loop, 5 {
if (@%k@ffffkk%kk#@%fkk#%f@ffk@k#ff@(0x00CCFF, 10, 0.54, 0.20, 0.65, 0.325)) {
ToolTip, Gear Shop Opened
SetTimer, kkk%f@f@#f%#fkk#f%k@#kk#%f#kfkfkfk@ff#f@, -1500
ffk@@f%#kk#@f%@ff@@k(webhookURL, "Gear Shop Opened.")
Sleep, 200
fk%@ffk@ffk%fkk@@k@kkk("33311443333114405550555", 0)
Sleep, 100
k@f@%k#@kf@f@%kf#f@f@kk#kf("gear")
ffk@%k@ffffkk%@f@ff@@k(webhookURL, "Gear Shop Closed.")
gearsCompleted = 1
}
if (gearsCompleted) {
break
}
Sleep, 2000
}
kfk#@%k@k@ff%k@kf%#fk@%kkk@ff@("gear", gearsCompleted)
ffk%fk#ff@%fkf%kfkkk#%f#ff#f(0, 1, "0")
ffk@%k@#kk#%@%@kkk@f@k%f@ff@@k(webhookURL, "**[Gears Completed]**")
Return


k@ffk@k##kkk#fkfk@ff#kffkk:
cosmeticsCompleted := 0
ffkfk%ffkf#k%ff#f%#fk#%f#f(0, 1, "0")
fkfkk@@%ffkfkk%k@kkk("11110")
f#@%#fff%f@kk@k@@fkf(100, 500)
ffk%fff#k@k@%fkff#ff#f(1, 0, "2")
f%ffkf%#@f@kk@k@@fkf(100, 500)
@fk@kf%#kf#ff%f#k#kkf@#k(midX, midY)
f#@%@k#f@f@f%f@kk%k#@fkk%@k@@fkf(800, 1000)
Send, {w Down}
Sleep, 900
Send, {w Up}
f#@f%fk#f@kkk%@kk@k@@fkf(100, 1000)
Send, {e}
f#@f%kf#f%@kk@k@%k@#kkf%@fkf(2500, 5000)
ffk@@f@%ff#fkk%ff@@k(webhookURL, "**[Cosmetic Cycle]**")
Loop, 5 {
if (@kk%k@fkkf%#@%@ff@@fk#%f@ffk@k#ff@(0x00CCFF, 10, 0.61, 0.182, 0.764, 0.259)) {
ToolTip, Cosmetic Shop Opened
SetTimer, kk%k@kf@f#k%%f#k@k@%k#fkk#ff#kfkfkfk@ff#f@, -1500
ffk@@%k@f#@k%f@ff%#fff@k%@@k(webhookURL, "Cosmetic Shop Opened.")
Sleep, 200
for index, item in cosmeticItems {
label := StrReplace(item, " ", "")
currentItem := cosmeticItems[A_Index]
Gosub, %label%
ffk@@f@%fk#kk@#k%ff@@k(webhookURL, "Bought " . currentItem . (PingSelected ? " <@" . discordUserID . ">" : ""))
Sleep, 100
}
ffk@@%fkfk%f@ff@%#kkk@k%@k(webhookURL, "Cosmetic Shop Closed.")
cosmeticsCompleted = 1
}
if (cosmeticsCompleted) {
break
}
Sleep, 2000
}
if (cosmeticsCompleted) {
Sleep, 500
f%k#kfk#k@%%@fkkk#%kfkk@@k@kkk("111114150320")
}
else {
ff%#k@kff%k@@f@ff@@k(webhookURL, "Failed To Detect Cosmetic Shop Opening [Error]" . (PingSelected ? " <@" . discordUserID . ">" : ""))
fkf%kk#fk@%kk@@k%#fk#%@kkk("11114111350")
Sleep, 50
fkfkk%k@ffff#f%@@k@kkk("11110")
}
ffkfk%#ff#k#k#%%ffkf#k%ff#ff#f(0, 1, "0")
ff%k#ff#f%k@@f%@k@kk@f#%@ff@@k(webhookURL, "**[Cosmetics Completed]**")
Return

Cosmetic1:

    Sleep, 50
    Loop, 5 {
        fkfkk@@k@kkk("161616161646465606")
        Sleep, % (SavedSpeed = "Ultra") ? 50 : (SavedSpeed = "Max") ? 30 : 200
    }

Return

Cosmetic2:

    Sleep, 50
    Loop, 5 {
        fkfkk@@k@kkk("1616161616464626265606")
        Sleep, % (SavedSpeed = "Ultra") ? 50 : (SavedSpeed = "Max") ? 30 : 200
    }

Return

Cosmetic3:

    Sleep, 50
    Loop, 5 {
        fkfkk@@k@kkk("16161616164646262626265606")
        Sleep, % (SavedSpeed = "Ultra") ? 50 : (SavedSpeed = "Max") ? 30 : 200
    }

Return

Cosmetic4:

    Sleep, 50
    Loop, 5 {
        fkfkk@@k@kkk("1616161616464626262626465606")
        Sleep, % (SavedSpeed = "Ultra") ? 50 : (SavedSpeed = "Max") ? 30 : 200
    }

Return

Cosmetic5:

    Sleep, 50
    Loop, 5 {
        fkfkk@@k@kkk("161616161646462626262646165606")
        Sleep, % (SavedSpeed = "Ultra") ? 50 : (SavedSpeed = "Max") ? 30 : 200
    }

Return

Cosmetic6:

    Sleep, 50
    Loop, 5 {
        fkfkk@@k@kkk("16161616164646262626264616165606")
        Sleep, % (SavedSpeed = "Ultra") ? 50 : (SavedSpeed = "Max") ? 30 : 200
    }

Return

Cosmetic7:

    Sleep, 50
    Loop, 5 {
        fkfkk@@k@kkk("1616161616464626262626461616165606")
        Sleep, % (SavedSpeed = "Ultra") ? 50 : (SavedSpeed = "Max") ? 30 : 200
    }

Return

Cosmetic8:

    Sleep, 50
    Loop, 5 {
        fkfkk@@k@kkk("161616161646462626262646161616165606")
       Sleep, % (SavedSpeed = "Ultra") ? 50 : (SavedSpeed = "Max") ? 30 : 200
    }

Return

Cosmetic9:

    Sleep, 50
    Loop, 5 {
        fkfkk@@k@kkk("16161616164646262626264616161616165606")
        Sleep, % (SavedSpeed = "Ultra") ? 50 : (SavedSpeed = "Max") ? 30 : 200
    }

Return

f#kf@fk#f#fkf#k#k#ff#k:
ffk@%k#@fkk%@f@%@ffk@ffk%ff@@k(webhookURL, "**[Pollenated Plant Collection Cycle]**")
fkfkk@@%fffk#fk@%k@kkk("11110")
f#@f@k%ff@fkff@%k@k%f@#fff%@@fkf(1000, 2000)
@k#k@%kfk@#k%f@fk#%#fff%ff("pollen")
f%f@#kfkkk%fkfk%#fff@k%ff#ff#f(1, 0, "3")
ff%k@kk@k%k@@f@ff@@k(webhookURL, "**[Collecting Left Side...]**")
Send, {s down}
Sleep, 270
Send, {s up}
f#@f%@ff@fk#f%@kk@k@@fkf(200, 500)
Send, {a down}
Sleep, 900
Send, {a up}
f#@f@kk%@ff@@fk#%@k@@fkf(200, 500)
@fk@kff%k@fkkf%#k#kkf@#k(midX, midY)
f#%f##f@fk@%@f@kk@k@@fkf(8000, 10000)
Send, {a down}
Sleep, 800
Send, {a up}
f#%#kk#@f%@f@k%@kk@k@%k@k@@fkf(200, 500)
@fk@kf%f#@f%f#k#%#kkk@k%kkf@#k(midX, midY)
f#@f@kk%@k#f@f@f%@k@@fkf(8000, 10000)
Send, {a down}
Sleep, 600
Send, {a up}
f#@%fff#k@k@%f@kk@k@@fkf(200, 500)
Send, {s down}
Sleep, 1000
Send, {s up}
f#@f%kfk@%@k%ff#fkk%k@k@@fkf(200, 500)
@fk@%f##f@fk@%kff#k%@kk#%#kkf@#k(midX, midY)
f#@%fk#kkk%f@kk@%ff@k#f%k@@fkf(8000, 10000)
Send, {s down}
Sleep, 1200
Send, {s up}
f#%k@#kk#%@f@kk@k@@fkf(200, 500)
@fk@kf%f@k@%f%f@#kfkkk%#k#kkf@#k(midX, midY)
f#@f@%@k@fkf%kk@k@@fkf(8000, 10000)
Send, {s down}
Sleep, 1300
Send, {s up}
f#@f@%#kf#ff%%fffk#fk@%kk@k@@fkf(200, 500)
@fk%fffff@%@%fkk#%kff#k#kkf@#k(midX, midY)
f#@f%#kff#k%@kk@k@@fkf(8000, 10000)
Send, {s down}
Sleep, 1000
Send, {s up}
f%f#fk@f%#@f@kk%#kk#k#k#%@k@@fkf(200, 500)
Send, {d down}
Sleep, 900
Send, {d up}
f%fkkk@kfk%#@f@kk@k@@fkf(200, 500)
@fk@kff%f@#fff%#k#kkf@#k(midX, midY)
f#%fkfk%@f@%f#k@k@%kk@k@@fkf(8000, 10000)
Send, {d down}
Sleep, 800
Send, {d up}
f#@f%#fff%@%k@ffff#f%kk@k@@fkf(200, 500)
@%@ffkkfff%fk%f##f@fk@%@kff#k#kkf@#k(midX, midY)
f#@f@%fk#kff@f%kk@k%#kff#k%@@fkf(8000, 10000)
Send, {d down}
Sleep, 600
Send, {d up}
f#@f@k%#kk#@f%k@k%k#ff#f%@@fkf(200, 500)
fkfk%@kk@k@%k@@k@kkk("11110")
f%f@#kfkkk%fk%k#f#k#@f%@@f@ff@@k(webhookURL, "**[Collecting Right Side...]**")
Send, {s down}
Sleep, 270
Send, {s up}
f%f#kf@k%#@f@kk%kkfff#ff%@k@@fkf(200, 500)
Send, {d down}
Sleep, 800
Send, {d up}
f%k#ff%#@f@k%@k#f@f@f%k@k@@fkf(200, 500)
@fk@kff%kkffkf@k%#k%fk#f@kkk%#kkf@#k(midX, midY)
f%kfkkk#%#@f@kk@k@@fkf(8000, 10000)
Send, {d down}
Sleep, 800
Send, {d up}
f#@%#fk@%f@kk@k@@fkf(200, 500)
@f%k@f#@k%k@kff#k#kkf@#k(midX, midY)
f#@f@k%@ffk@ffk%k@k@@%fffff@%fkf(8000, 10000)
Send, {d down}
Sleep, 600
Send, {d up}
f#%@f@k%@f@kk@k@@fkf(200, 500)
Send, {s down}
Sleep, 1000
Send, {s up}
f#@f%#fff@k%@kk@k@@fkf(200, 500)
@fk@kff%#kkk@k%#k#kkf@#k(midX, midY)
f%@fkkk#%#@f@kk%fk#k@fff%@k@@fkf(8000, 10000)
Send, {s down}
Sleep, 1200
Send, {s up}
f%kfk#f#%#@f@kk@k@@fkf(200, 500)
@fk%@k@fkf%@kff#k#kkf@#k(midX, midY)
f#%k#@kf@f@%@f@k%fk#fk#%k@k@@fkf(8000, 10000)
Send, {s down}
Sleep, 1300
Send, {s up}
f#@f%@k#f@f@f%@kk@k@@fkf(200, 500)
@fk%k@#kk#%@kff#k#kkf@#k(midX, midY)
f#@%#k#f@fk#%f@%fff#k@k@%kk@k@@fkf(8000, 10000)
Send, {s down}
Sleep, 1000
Send, {s up}
f#@%f#ffkk%f@kk@k@@fkf(200, 500)
Send, {a down}
Sleep, 900
Send, {a up}
f%@ffkkfff%#@f@kk@k@@fkf(200, 500)
@fk@%k@fkkf%kff#k#kkf@#k(midX, midY)
f#@f@kk%kkkkfk#f%@k@@fkf(8000, 10000)
Send, {a down}
Sleep, 800
Send, {a up}
f#@f%kk#fk@%%ffkk%@kk@k@@fkf(200, 500)
@fk@kff%#kk#k#k#%#k#kkf@#k(midX, midY)
f#@f@%k#@kf@f@%kk@k@@fkf(8000, 10000)
Send, {a down}
Sleep, 600
Send, {a up}
f#@f%#kk#k#k#%@kk%f#@f%@k@@fkf(200, 500)
fkf%@ff@@fk#%kk@@%#ff#k#k#%k@kkk("11110")
ffk@@%kfkkk#%f@ff@@k(webhookURL, "**[Collecting Middle Area...]**")
Send, {s down}
Sleep, 1000
Send, {s up}
f#@f@%ff#fkk%kk@k@@fkf(200, 500)
@fk@%k@#kk#%k%#kk#@f%ff#k#kkf@#k(midX, midY)
f#@f@kk%fk#k@fff%@k@@fkf(8000, 10000)
Send, {s down}
Sleep, 1200
Send, {s up}
f%@k@kk@f#%#@%@ff@@fk#%f@kk@k@@fkf(200, 500)
@%ff#k@k@k%fk@kff#k#kkf@#k(midX, midY)
f#%fk#kkk%@f@k%fkffk#k#%k@k@@fkf(8000, 10000)
Send, {s down}
Sleep, 1300
Send, {s up}
f#@f@k%#fk@%k@k@@fkf(200, 500)
@f%kk#fk@%k@kff#k#kkf@#k(midX, midY)
f#@%kkk@#f%f@kk@%#kff#k%k@@fkf(8000, 10000)
Send, {s down}
Sleep, 1000
Send, {s up}
f#@f%kffkff#k%@kk@k@@fkf(200, 500)
@fk@%fkkk@kfk%kff#k#kkf@#k(midX, midY)
f#%kffk#k%@f@kk@k@@fkf(8000, 10000)
ffkf%f@#kfkkk%kff#f%#kf#ff%f#f(0, 1, "0")
fk%@ff@fk#f%fkk@@k@kkk(11110)
ffk%fk#k@fff%@@f@ff@@k(webhookURL, "**[Pollenated Plant Collection Completed]**")
Return

;Honey Deposit Cycle
fffkk#kk#fkf#k#kf#f@#f#kfk#kk#k@kk#k#kk#k#:
depositCount := 0
ff%kffk%k@@f@ff@@k(webhookURL, "**[Honey Deposit Cycle]**")
fkf%k@k@ff%kk@@k@kkk("1111020")
f#%fk#k@fff%@f@kk@k@@fkf(1000, 2000)
Send, {d down}
Sleep, 8500
Send, {d up}
f#@f@%fkkk@kfk%kk@k@@fkf(100, 1000)
Send, {w down}
Sleep, 650
Send, {w up}
f#@f@k%kffkff#k%k%k#f#k#@f%@k@@fkf(100, 1000)
Send, {d down}
Sleep, 1200
Send, {d up}
f#@%f#k@k@%f@kk@k@@fkf(100, 500)
Loop, 3 {
@k#%@k#f@f@f%k@f@fk#ff("pollinated")
ff%f#k@k@%kfkff%#fff@k%#ff#f(1, 0, "9")
f%@kk#%#@%kfkkk#%f@kk@k@@fkf(100, 500)
Loop, 2 {
Send {e}
Sleep, 200
}
depositCount++
ffk@@%k@fkkf%f@ff@@k(webhookURL, "Depositing/Collecting Honey Try #" . depositCount . ".")
Sleep, 1000
}
ffkfkff%fk#kk@#k%#ff#f(0, 1, "0")
fkfk%f#k@k@%k@@k@kkk(11110)
ffk@%ff#k@k@k%@f%f#kf@k%@ff@@k(webhookURL, "**[Honey Deposit Completed]**")
Return
f@kkfkkkfkf@kk@kf#k#k#@kfff#ff@f@k@f:
global UINavigationFix
honeyCompleted := 0
ffk@%fk#kff@f%@f@f%k@ffff#f%f@@k(webhookURL, "**[Honey Shop Cycle]**")
f%f##kkkkf%%k@ffffkk%kfkk@@k@kkk("1111020")
f#@f@kk%#k@kff%@k@@fkf(1000, 2000)
Send, {d down}
Sleep, 9050
Send, {d up}
f%k@f#@k%#%kkf@kfff%@f@kk@k@@fkf(100, 1000)
Send, {w down}
Sleep, 250
Send, {w up}
Loop, 2 {
Send, {WheelDown}
Sleep, 20
}
f#@f@%kfk@%k%fk#fk#%k@k@@fkf(500, 1500)
Send, {e}
f#@f@kk%kffk%@k@@fkf(500, 1500)
Loop, 2 {
Send, {WheelUp}
Sleep, 20
}
f#@f@kk%#kk#k#k#%@k@@fkf(500, 2000)
f#f@@%kkk@#f%ffffkf@("honey")
f#@f@k%#kk#@f%k@k@@f%k#f@%kf(2500, 5000)
Loop, 5 {
if (@k%#fff@k%k#@f@ffk@k#ff@(0x02EFD3, 10, 0.54, 0.20, 0.65, 0.325)) {
ToolTip, Honey Shop Opened
SetTimer, kkk#f%kfk@#k%kk#ff#kfkfkfk@ff#f@, -1500
ffk@@f@%@kkk@f@k%ff@@k(webhookURL, "Honey Shop Opened.")
Sleep, 200
if (UINavigationFix) {
fkfkk%kkkkfk#f%@@k@kkk("33332223333111405550555", 0)
}
else {
f%#k@k#kk#%kf%@ff@@fk#%kk@@k@kkk("3333114443333311405550555", 0)
}
Sleep, 100
k@f@%k#ff%kf#f@f@kk#kf("honey")
f%kfk@#k%fk@@f@ff@@k(webhookURL, "Honey Shop Closed.")
honeyCompleted = 1
}
if (honeyCompleted) {
break
}
Sleep, 2000
}
kfk#@k@%@kfffk%kfkkk@f%#k@kff%f@("honey", honeyCompleted)
ffkfk%ffkfkk%ff#ff#f(0, 1, "0")
ff%fk#fk#%%#kk#k#k#%k@@f@ff@@k(webhookURL, "**[Honey Shop Completed]**")
Return
k#k##kfk@kf#ff@ff##kf@f#f#kkk#k@k@@k#k:
Sleep, 50
Loop, 5 {
f%fkk#%k%#kk#k#k#%fkk@@k@kkk("111114450")
f#@%f@@fff%f@kk@k@@fkf(50, 200)
}
Return
f@f#ff@kk@@k#fk#k#k@k#@kkff#fk:
Sleep, 50
Loop, 5 {
fkfkk@@%f@f@#f%k@kkk("11111442250")
f%fk#kkk%#@f@kk@k@@fkf(50, 200)
}
Return
f##fkff@fkk@k#k@@kk@ff#fk@:
Sleep, 50
Loop, 5 {
fk%#fff@k%fkk@@%ffkf%k@kkk("1111144222250")
f#@f@k%kffk%k@k@@fkf(50, 200)
}
Return
#kk##f@f@f@k@k@k@fk@kf#f#f#ff#fkk@kkf@kk:
Sleep, 50
Loop, 5 {
fkf%kfk#f#@f%kk%k#kfk#k@%@@k@kkk("11111442222450")
f#@%#ff#k#k#%f@%k@k@ff%kk@k@@fkf(50, 200)
}
Return
#fk#kfk#k#@kk#kkk@@ffkk@kf#kkkfkk@@k@kk@ff:
Sleep, 50
Loop, 5 {
fkfk%ffkfkk%k@@k@kkk("111114422224150")
f#@f@%#k@kff%kk@k@%#ff#k#k#%@fkf(50, 200)
}
Return
fffkfkk#kf#f@f#fk@k@kff#kkfffk#k#k:
Sleep, 50
Loop, 5 {
fkfkk@@%fk#kkk%k@kkk("1111144222241150")
f%f@@fff%#@f@kk@k@@fkf(50, 200)
}
Return
fkk#@kk@f##k@kk#ffk#k#k#k@fff@k@@kf#fk:
Sleep, 50
Loop, 5 {
fkfk%k@#kkf%k@@k@kkk("11111442222411150")
f#@f@k%f##kkkkf%k@k@%k#ff#f%@fkf(50, 200)
}
Return
ffk#kfff#f@kf#@k#ff@ffk#f@#k#kfkk#:
Sleep, 50
Loop, 5 {
fk%@kk@k@%fk%@kf#@f%k@@k@kkk("111114422224111150")
f#@%fffk#fk@%f@kk@k%k#@fkk%@@fkf(50, 200)
}
Return
f#@fk#f#@fkffk@fkk@ffkk#k@@k@f:
Sleep, 50
Loop, 5 {
fkfk%#fff@k%k@%#f@k%@k@kkk("1111144222241111150")
f#@f@%fk#f@kkk%kk@k@%fffff@%@fkf(50, 200)
}
Return
k#kffk#kkkfkkkff#f#fk@f##k@k@f@fkfk@#kf#:
Gui, Submit, NoHide
Loop, % eggItems.Length()
IniWrite, % (eggItem%A_Index% ? 1 : 0), %settingsFile%, Egg, Item%A_Index%
Loop, % gearItems.Length()
IniWrite, % (GearItem%A_Index% ? 1 : 0), %settingsFile%, Gear, Item%A_Index%
Loop, % seedItems.Length()
IniWrite, % (SeedItem%A_Index% ? 1 : 0), %settingsFile%, Seed, Item%A_Index%
Loop, % realHoneyItems.Length()
IniWrite, % (HoneyItem%A_Index% ? 1 : 0), %settingsFile%, Honey, Item%A_Index%
IniWrite, %AutoAlign%, %settingsFile%, Main, AutoAlign
IniWrite, %PingSelected%, %settingsFile%, Main, PingSelected
IniWrite, %MultiInstanceMode%, %settingsFile%, Main, MultiInstanceMode
IniWrite, %UINavigationFix%, %settingsFile%, Main, UINavigationFix
IniWrite, %AutoHoney%, %settingsFile%, Honey, AutoHoney
IniWrite, %AutoCollectPollinated%, %settingsFile%, Honey, AutoCollectPollinated
IniWrite, %BuyAllCosmetics%, %settingsFile%, Cosmetic, BuyAllCosmetics
IniWrite, %SelectAllEggs%, %settingsFile%, Egg, SelectAllEggs
IniWrite, %SelectAllSeeds%, %settingsFile%, Seed, SelectAllSeeds
IniWrite, %SelectAllGears%, %settingsFile%, Gear, SelectAllGears
IniWrite, %SelectAllHoney%, %settingsFile%, Honey, SelectAllHoney
Return
fff#kkkff@@k#kk@(f@kf@fffk@kff#f@ := 1) {
Gui, Submit, NoHide
Sleep, 50
started := 0
Gosub, k#kffk#%#f@k%kkkfkkkff#f#fk@f##k@k@f@fkfk@#kf#
Gui, Destroy
if (f@kf@ff%f@k@%fk@%@k@fkf%kff#f@)
ExitApp
}
@ff##kk#kkfkf@k#(@f#kf@k@kk#f := 1) {
Gui, Submit, NoHide
Sleep, 50
started := 0
Gosub, k#k%@fk@f@f@%ffk#%f@#fff%kkkfkkkff#f#fk@f##k@k@f@fkfk@#kf#
}
GuiClose:
f%kkffkf@k%ff#kkkff@@k#kk@(1)
Return
@fk#@ff@kf@kfk#k#f@kkfkkkff#f#@kfk@fk#:
@f%k@fkkf%%@fkkk#%f##kk#kkfkf@k#(1)
ffk@@f%fk#fk#%@ff@@k(webhookURL, "Macro reloaded.")
Reload
Return
F7::
@f%k@fkkf%%@fkkk#%f##kk#kkfkf@k#(1)
Reload
Return
F5::
Gosub, kkkfkffkk@kkkf#ff#fkfk#fkkkk#kk@f@f#ff
Return
F8::
MsgBox, 1, Message, % "Delete debug file?"
IfMsgBox, OK
FileDelete, debug.txt
Return
#MaxThreadsPerHotkey, 2