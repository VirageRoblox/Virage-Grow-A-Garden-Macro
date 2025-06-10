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


SendDiscordWebhook(urlP, messageP) {
    FormatTime, messageTime, , hh:mm:ss tt
    fullMessage := "[" . messageTime . "] " . messageP
    json := "{""content"": """ . fullMessage . """}"
    whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    try {
        whr.Open("POST", urlP, false)
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


CheckInputURLValid(inputUrlP, messageP := 0, modeP := "nil") {
global webhookURL
global privateServerLink
global settingsFile
isValid := 0
if (modeP = "webhook" && (inputUrlP = "" || !(InStr(inputUrlP, "discord.com/api") || InStr(inputUrlP, "discordapp.com/api")))) {
isValid := 0
if (messageP) {
MsgBox, 0, Message, Invalid Webhook
IniRead, savedWebhook, %settingsFile%, Main, UserWebhook,
GuiControl,, webhookURL, %savedWebhook%
}
return false
}
if (modeP = "privateserver" && (inputUrlP = "" || !InStr(inputUrlP, "roblox.com/share"))) {
isValid := 0
if (messageP) {
MsgBox, 0, Message, Invalid Private Server Link
IniRead, savedServerLink, %settingsFile%, Main, PrivateServerLink,
GuiControl,, privateServerLink, %savedServerLink%
}
return false
}
try {
whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
whr.Open("GET", inputUrlP, false)
whr.Send()
whr.WaitForResponse()
status := whr.Status
if (modeP = "webhook" && (status = 200 || status = 204)) {
isValid := 1
} else if (modeP = "privateserver" && (status >= 200 && status < 400)) {
isValid := 1
}
} catch {
isValid := 0
}
if (messageP) {
if (modeP = "webhook") {
if (isValid && webhookURL != "") {
IniWrite, %webhookURL%, %settingsFile%, Main, UserWebhook
MsgBox, 0, Message, Webhook Saved Successfully
}
else if (!isValid && webhookURL != "") {
MsgBox, 0, Message, Invalid Webhook
IniRead, savedWebhook, %settingsFile%, Main, UserWebhook,
GuiControl,, webhookURL, %savedWebhook%
}
} else if (modeP = "privateserver") {
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

MoveRelativeToRobloxWindow(relX, relY) {
if WinExist("ahk_exe RobloxPlayerBeta.exe") {
WinGetPos, winX, winY, winW, winH, ahk_exe RobloxPlayerBeta.exe
moveX := winX + Round(relX * winW)
moveY := winY + Round(relY * winH)
MouseMove, %moveX%, %moveY%
}
}


ClickRelativeToRobloxWindow(relX, relY) {
if WinExist("ahk_exe RobloxPlayerBeta.exe") {
WinGetPos, winX, winY, winW, winH, ahk_exe RobloxPlayerBeta.exe
clickX := winX + Round(relX * winW)
clickY := winY + Round(relY * winH)
Click, %clickX%, %clickY%
}
}


GetMouseRelativeToRobloxWindow(axis) {
    WinGetPos, winX, winY, winW, winH, ahk_exe RobloxPlayerBeta.exe
    CoordMode, Mouse, Screen
    MouseGetPos, mouseX, mouseY
    relX := (mouseX - winX) / winW
    relY := (mouseY - winY) / winH
    if (axis = "x")
        return relX
    else if (axis = "y")
        return relY

    return ""
}


NavigateUI(sequenceP := 0, exitUINavP := 1, continiousP := 0, spamP := 0, spamCountP := 30, delayP := 50, modeP := "universal", indexP := 0, directionP := "nil", itemTypeP := "nil") {
global SavedSpeed
global SavedKeybind
global UINavigationFix
global indexItem
global currentArray
If (!sequenceP && modeP = "universal") {
return
}
if (!continiousP) {
ToggleUINavigate(SavedKeybind)
Sleep, 50
if (UINavigationFix) {
RepeatKey("Up", 5, 50)
Sleep, 50
RepeatKey("Left", 3, 50)
Sleep, 50
RepeatKey("up", 5, 50)
Sleep, 50
RepeatKey("Left", 3, 50)
Sleep, 50
}
}
if (modeP = "universal") {
Loop, Parse, sequenceP
{
if (A_LoopField = "1") {
RepeatKey("Right", 1)
}
else if (A_LoopField = "2") {
RepeatKey("Left", 1)
}
else if (A_LoopField = "3") {
RepeatKey("Up", 1)
}
else if (A_LoopField = "4") {
RepeatKey("Down", 1)
}
else if (A_LoopField = "0") {
RepeatKey("Enter", spamP ? spamCountP : 1, spamP ? 10 : 0)
}
else if (A_LoopField = "5") {
Sleep, 100
}
if (SavedSpeed = "Stable" && A_LoopField != "5") {
Sleep, %delayP%
}
}
}
else if (modeP = "calculate") {
previousIndex := FindItemIndex(currentArray, indexItem)
sendCount := indexP - previousIndex
FileAppend, % "index: " . indexP . "`n", debug.txt
FileAppend, % "previusIndex: " . previousIndex . "`n", debug.txt
FileAppend, % "currentarray: " . currentArray.Name . "`n", debug.txt
if (directionP = "up") {
RepeatKey(directionP)
RepeatKey("Enter")
RepeatKey(directionP, sendCount)
}
else if (directionP = "down") {
FileAppend, % "sendCount: " . sendCount . "`n", debug.txt
if ((currentArray.Name = "honeyItems") && (previousIndex = 1 || previousIndex = 10 || previousIndex = 12)) {
if (!(FindItemIndex(indexArray, 1, "bool"))) {
sendCount++
}
sendCount--
FileAppend, % "went down one less because of previous indexP: " . previousIndex . "`n", debug.txt
}
RepeatKey(directionP, sendCount)
RepeatKey("Enter")
RepeatKey(directionP)
if ((currentArray.Name = "gearItems") && (indexP != 2) && (UINavigationFix)) {
RepeatKey("Left")
}
else if ((currentArray.Name = "seedItems") && (UINavigationFix)) {
RepeatKey("Left")
}
if ((currentArray.Name = "honeyItems") && (indexP = 1 || indexP = 10 || indexP = 12)) {
RepeatKey(directionP)
FileAppend, % "went down one extra for indexP: " . indexP . "`n", debug.txt
}
}
}
else if (modeP = "close") {
if (directionP = "up") {
if (itemTypeP = "Honey" && UINavigationFix) {
indexP += 10
}
RepeatKey(directionP)
RepeatKey("Enter")
RepeatKey(directionP, indexP)
}
else if (directionP = "down") {
RepeatKey(directionP, indexP)
RepeatKey("Enter")
RepeatKey(directionP)
}
}
if (exitUINavP) {
Sleep, 50
ToggleUINavigate(SavedKeybind)
}
return
}


BuyItem(itemTypeP) {
global currentArray
global currentSelectedArray
global indexItem := ""
global indexArray := []
global UINavigationFix
indexArray := []
lastIndex := 0
if (itemTypeP = "honey" && UINavigationFix) {
StringUpper, itemTypeP, itemTypeP, T
arrayName := "real" . itemTypeP . "Items"
}
else {
arrayName := itemTypeP . "Items"
}
currentArray := %arrayName%
currentArray.Name := arrayName
StringUpper, itemTypeP, itemTypeP, T
selectedArrayName := "selected" . itemTypeP . "Items"
currentSelectedArray := %selectedArrayName%
for i, selectedItem in currentSelectedArray {
indexArray.Push(FindItemIndex(currentArray, selectedItem))
}
for i, index in indexArray {
currentItem := currentSelectedArray[i]
Sleep, 50
NavigateUI(, 0, 1, , , , "calculate", index, "down", itemTypeP)
indexItem := currentSelectedArray[i]
SleepFromSpeed(100, 200)
HandleShopItem(0x26EE26, 0x1DB31D, 5, 0.4262, 0.2903, 0.6918, 0.8508)
Sleep, 50
lastIndex := index - 1
}
Sleep, 100
NavigateUI(, 0, 1,,,, "close", lastIndex, "up", itemTypeP)
Sleep, 100
}


RepeatKey(keyP := "nil", countP := 1, delayP := 30) {
global SavedSpeed
if (keyP = "nil") {
return
}
Loop, %countP% {
Send {%keyP%}
Sleep, % (SavedSpeed = "Ultra" ? (delayP - 25) : SavedSpeed = "Max" ? (delayP - 30) : delayP)
}
}


ToggleUINavigate(keybindP) {
if (keybindP = "\") {
Send, \
}
else if (keybindP = "#" || keybindP = "[") {
Send, {%keybindP%}
}
}


SleepFromSpeed(highP, lowP) {
global SavedSpeed
Sleep, % (SavedSpeed != "Stable") ? highP : lowP
}


FindItemIndex(array := "", itemP := "", returnType := "int") {
FileAppend, % "Searching " . array.Name . " for " . itemP . "`n", debug.txt
for index, item in array {
if (itemP = item) {
FileAppend, % "found " . itemP . " at index " . index "`n", debug.txt
if (returnType = "int") {
return index
}
else if (returnType = "bool") {
return true
}
}
}
if (returnType = "int") {
return 1
}
else if (returnType = "bool") {
return false
}
}


InventoryItemSearch(itemP := "nil") {
    global UINavigationFix
    if(itemP = "nil") {
        Return
    }

    if (UINavigationFix) {
        NavigateUI("150524150505305", 0)
        TypeString(itemP)
        Sleep, 50
        if (itemP = "recall") {
            NavigateUI("4335505541555055", 1, 1)
        }
        else if (itemP = "pollinated") {
            NavigateUI("22115505544444444441111111155055", 1, 1)
        }
        else if (itemP = "pollen") {
            NavigateUI("22115505544444444441155055", 1, 1)
        }

        NavigateUI(10)
    }
    else {
        NavigateUI("1011143333333333333333333311440", 0)
        Sleep, 50
        TypeString(itemP)
        Sleep, 50

        if (itemP = "recall") {
            NavigateUI("2211550554155055", 1, 1)
        }
        else if (itemP = "pollinated") {
            NavigateUI("22115505544444444444444444444441111111155055", 1, 1)
        }
        else if (itemP = "pollen") {
            NavigateUI("22115505544444444441155055", 1, 1, , , 200)
        }

        NavigateUI(10)
    }
}


TypeString(stringP, enterP := 1, clearP := 1) {
if (stringP = "") {
Return
}
if (clearP) {
Send {BackSpace 20}
Sleep, 100
}
Loop, Parse, stringP
{
Send, {%A_LoopField%}
Sleep, 100
}
if (enterP) {
Send, {Enter}
}
Return
}


ShopDialogClick(shopTypeP) {
    MoveRelativeToRobloxWindow(midX, midY)
    Sleep, 100
    Loop, 4 {
        Send, {WheelUp}
        Sleep, 20
    }
        Sleep, 300
    if (shopTypeP = "gear") {
        ClickRelativeToRobloxWindow(midX + 0.4, midY - 0.1)
    }
    else if (shopTypeP = "honey") {
        ClickRelativeToRobloxWindow(midX + 0.4, midY)
    }
        Sleep, 300
    Loop, 4 {
        Send, {WheelDown}
        Sleep, 20
    }
    Sleep, 100
    ClickRelativeToRobloxWindow(midX, midY)
}


HotbarNavigate(selectP := 0, deselectP := 0, keyP := "nil") {
    if ((selectP = 1 && deselectP = 1) || (selectP = 0 && deselectP = 0) || keyP = "nil") {
        Return
    }
    if (deselectP) {
        Send, {%keyP%}
        Sleep, 200
        Send, {%keyP%}
    }
    else if (selectP) {
        Send, {%keyP%}
    }
}


SpamEscape(count := 4) {
    Loop, %count% {
        Send {Escape}
        Sleep, 100
    }
}


GetRobloxWindowIDs(indexP := 0) {
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
if (indexP) {
Return windowIDS[indexP]
}
}


HandleShopClose(shopTypeP, openSuccessP) {
StringUpper, shopTypeP, shopTypeP, T
if (openSuccessP) {
Sleep, 500
if (shopTypeP = "Honey") {
if (UINavigationFix) {
NavigateUI("2223331111140", 1, 1)
}
else {
NavigateUI("43333311140320", 1, 1)
}
}
else {
NavigateUI("4330320", 1, 1)
}
}
else {
ToolTip, % "Error In Detecting " . shopTypeP
SetTimer, HideTooltip, -1500
SendDiscordWebhook(webhookURL, "Failed To Detect " . shopTypeP . " shop Opening [Error]" . (PingSelected ? " <@" . discordUserID . ">" : ""))
NavigateUI("3332223111133322231111054105")
}
}


HandleEggShop(buyColorP, variationP := 10, x1p := 0.0, y1p := 0.0, x2p := 1.0, y2p := 1.0) {
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
if (PixelSearchInRobloxWindow(color, variationP, 0.41, 0.32, 0.54, 0.38)) {
if (isSelected) {
HandleShopItem(buyColorP, 0, 5, 0.4, 0.60, 0.65, 0.70, 0, 1)
eggsCompleted = 1
break
} else {
if (PixelSearchInRobloxWindow(buyColorP, variationP, 0.40, 0.60, 0.65, 0.70)) {
ToolTip, % currentItem . "`nIn Stock, Not Selected"
SetTimer, HideTooltip, -1500
SendDiscordWebhook(webhookURL, currentItem . " In Stock, Not Selected")
}
else {
ToolTip, % currentItem . "`nNot In Stock, Not Selected"
SetTimer, HideTooltip, -1500
SendDiscordWebhook(webhookURL, currentItem . " Not In Stock, Not Selected")
}
if (UINavigationFix) {
NavigateUI(3140, 1, 1)
}
else {
NavigateUI(1105, 1, 1)
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
NavigateUI(5, 1, 1)
ToolTip, Error In Detection
SetTimer, HideTooltip, -1500
SendDiscordWebhook(webhookURL, "Failed To Detect Any Egg [Error]" . (PingSelected ? " <@" . discordUserID . ">" : ""))
}
}


PixelSearchInRobloxWindow(colorP, variationP, x1p := 0.0, y1p := 0.0, x2p := 1.0, y2p := 1.0) {
CoordMode, Pixel, Screen
CoordMode, Mouse, Screen
WinGetPos, winX, winY, winW, winH, ahk_exe RobloxPlayerBeta.exe
x1 := winX + Round(x1p * winW)
y1 := winY + Round(y1p * winH)
x2 := winX + Round(x2p * winW)
y2 := winY + Round(y2p * winH)
PixelSearch, FoundX, FoundY, x1, y1, x2, y2, colorP, variationP, Fast
if (ErrorLevel = 0) {
return true
}
}


HandleShopItem(itemColorP, buyColorP, variationP := 10, x1p := 0.0, y1p := 0.0, x2p := 1.0, y2p := 1.0, shopP := 1, eggP := 0) {
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
x1 := winX + Round(x1p * winW)
y1 := winY + Round(y1p * winH)
x2 := winX + Round(x2p * winW)
y2 := winY + Round(y2p * winH)
if (shopP) {
for index, color in [itemColorP, buyColorP] {
PixelSearch, FoundX, FoundY, x1, y1, x2, y2, %color%, variationP, Fast RGB
if (ErrorLevel = 0) {
stock := 1
ToolTip, %currentItem% `nIn Stock
SetTimer, HideTooltip, -1500
NavigateUI(50, 0, 1, 1)
Sleep, 50
if (ping)
SendDiscordWebhook(webhookURL, "Bought " . currentItem . ". <@" . discordUserID . ">")
else
SendDiscordWebhook(webhookURL, "Bought " . currentItem . ".")
}
}
}
if (eggP) {
PixelSearch, FoundX, FoundY, x1, y1, x2, y2, itemColorP, variationP, Fast RGB
if (ErrorLevel = 0) {
stock := 1
ToolTip, %currentItem% `nIn Stock
SetTimer, HideTooltip, -1500
NavigateUI(500, 1, 1)
Sleep, 50
if (ping)
SendDiscordWebhook(webhookURL, "Bought " . currentItem . ". <@" . discordUserID . ">")
else
SendDiscordWebhook(webhookURL, "Bought " . currentItem . ".")
}
if (!stock) {
if (UINavigationFix) {
NavigateUI(3140, 1, 1)
}
else {
NavigateUI(1105, 1, 1)
}
SendDiscordWebhook(webhookURL, currentItem . " Not In Stock.")
}
}
Sleep, 100
if (!stock) {
ToolTip, %currentItem% `nNot In Stock
SetTimer, HideTooltip, -1500
}
}

MainGUI:
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
Gui, Add, Checkbox, % "x50 y90 vSelectAllSeeds gHandleGuiCheckboxUpdate c90EE90 " . (SelectAllSeeds ? "Checked" : ""), Select All Seeds
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
Gui, Add, Checkbox, % "x" col " y" y " vSeedItem" A_Index " gHandleGuiCheckboxUpdate cD3D3D3 " . (sVal ? "Checked" : ""), % seedItems[A_Index]
}
Gui, Tab, 2
Gui, Font, s9 c87CEEB Bold, Segoe UI
Gui, Add, GroupBox, x23 y50 w475 h340 c87CEEB, Gear Shop Items
IniRead, SelectAllGears, %settingsFile%, Gear, SelectAllGears, 0
Gui, Add, Checkbox, % "x50 y90 vSelectAllGears gHandleGuiCheckboxUpdate c87CEEB " . (SelectAllGears ? "Checked" : ""), Select All Gears
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
Gui, Add, Checkbox, % "x" col " y" y " vGearItem" A_Index " gHandleGuiCheckboxUpdate cD3D3D3 " . (gVal ? "Checked" : ""), % gearItems[A_Index]
}
Gui, Tab, 3
Gui, Font, s9 ce87b07 Bold, Segoe UI
Gui, Add, GroupBox, x23 y50 w475 h340 ce87b07, Egg Shop
IniRead, SelectAllEggs, %settingsFile%, Egg, SelectAllEggs, 0
Gui, Add, Checkbox, % "x50 y90 vSelectAllEggs gHandleGuiCheckboxUpdate ce87b07 " . (SelectAllEggs ? "Checked" : ""), Select All Eggs
Loop, % eggItems.Length() {
IniRead, eVal, %settingsFile%, Egg, Item%A_Index%, 0
y := 125 + (A_Index - 1) * 25
Gui, Add, Checkbox, % "x50 y" y " vEggItem" A_Index " gHandleGuiCheckboxUpdate cD3D3D3 " . (eVal ? "Checked" : ""), % eggItems[A_Index]
}
Gui, Tab, 4
Gui, Font, s9 ce8ac07 Bold, Segoe UI
Gui, Add, GroupBox, x23 y50 w475 h340 ce8ac07, Honey Shop
IniRead, AutoCollectPollinated, %settingsFile%, Honey, AutoCollectPollinated, 0
Gui, Add, Checkbox, % "x50 y90 vAutoCollectPollinated ce8ac07 " . (AutoCollectPollinated ? "Checked" : ""), Auto-Collect Pollinated Plants
IniRead, AutoHoney, %settingsFile%, Honey, AutoHoney, 0
Gui, Add, Checkbox, % "x50 y115 vAutoHoney ce8ac07 " . (AutoHoney ? "Checked" : ""), Auto-Deposit Honey
IniRead, SelectAllHoney, %settingsFile%, Honey, SelectAllHoney, 0
Gui, Add, Checkbox, % "x50 y140 vSelectAllHoney gHandleGuiCheckboxUpdate ce8ac07 " . (SelectAllHoney ? "Checked" : ""), Select All Honey Items
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
Gui, Add, Checkbox, % "x" col " y" y " vHoneyItem" A_Index " gHandleGuiCheckboxUpdate cD3D3D3 " . (gVal ? "Checked" : ""), % realHoneyItems[A_Index]
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
Gui, Add, Checkbox, % "x50 y225 vPingSelected gHandleCheckboxColorUpdate " . pingColor . (PingSelected ? " Checked" : ""), Discord Item Pings
IniRead, AutoAlign, %settingsFile%, Main, AutoAlign, 0
autoColor := AutoAlign ? "c90EE90" : "cD3D3D3"
Gui, Add, Checkbox, % "x50 y250 vAutoAlign gHandleCheckboxColorUpdate " . autoColor . (AutoAlign ? " Checked" : ""), Auto-Align
IniRead, MultiInstanceMode, %settingsFile%, Main, MultiInstanceMode, 0
multiInstanceColor := MultiInstanceMode ? "c90EE90" : "cD3D3D3"
Gui, Add, Checkbox, % "x50 y275 vMultiInstanceMode gHandleCheckboxColorUpdate " . multiInstanceColor . (MultiInstanceMode ? " Checked" : ""), Multi-Instance Mode
IniRead, UINavigationFix, %settingsFile%, Main, UINavigationFix, 0
uiNavigationFixColor := UINavigationFix ? "c90EE90" : "cD3D3D3"
Gui, Add, Checkbox, % "x50 y300 vUINavigationFix gHandleCheckboxColorUpdate " . uiNavigationFixColor . (UINavigationFix ? " Checked" : ""), UI Navigation Fix
Gui, Font, s8 cD3D3D3 Bold, Segoe UI
Gui, Add, Text, x50 y90, Webhook URL:
Gui, Font, s8 cBlack, Segoe UI
IniRead, savedWebhook, %settingsFile%, Main, UserWebhook
if (savedWebhook = "ERROR") {
savedWebhook := ""
}
Gui, Add, Edit, x140 y90 w250 h18 vwebhookURL +BackgroundFFFFFF, %savedWebhook%
Gui, Font, s8 cWhite, Segoe UI
Gui, Add, Button, x400 y90 w85 h18 gSaveWebhookButtonHandler Background202020, Save Webhook
Gui, Font, s8 cD3D3D3 Bold, Segoe UI
Gui, Add, Text, x50 y115, Discord User ID:
Gui, Font, s8 cBlack, Segoe UI
IniRead, savedUserID, %settingsFile%, Main, DiscordUserID
if (savedUserID = "ERROR") {
savedUserID := ""
}
Gui, Add, Edit, x140 y115 w250 h18 vdiscordUserID +BackgroundFFFFFF, %savedUserID%
Gui, Font, s8 cD3D3D3 Bold, Segoe UI
Gui, Add, Button, x400 y115 w85 h18 gSaveUserIDButtonHandler Background202020, Save UserID
IniRead, savedUserID, %settingsFile%, Main, DiscordUserID
Gui, Add, Text, x50 y140, Private Server:
Gui, Font, s8 cBlack, Segoe UI
IniRead, savedServerLink, %settingsFile%, Main, PrivateServerLink
if (savedServerLink = "ERROR") {
savedServerLink := ""
}
Gui, Add, Edit, x140 y140 w250 h18 vprivateServerLink +BackgroundFFFFFF, %savedServerLink%
Gui, Font, s8 cD3D3D3 Bold, Segoe UI
Gui, Add, Button, x400 y140 w85 h18 gSavePrivateServerLinkButtonHandler Background202020, Save Link
Gui, Add, Button, x400 y165 w85 h18 gClearSavesButtonHandler Background202020, Clear Saves
Gui, Font, s8 cD3D3D3 Bold, Segoe UI
Gui, Add, Text, x50 y165, UI Navigation Keybind:
Gui, Font, s8 cBlack, Segoe UI
IniRead, SavedKeybind, %settingsFile%, Main, UINavigationKeybind, \
Gui, Add, DropDownList, vSavedKeybind gSaveKeybindHandler x180 y165 w50, \|#|[
GuiControl, ChooseString, SavedKeybind, %SavedKeybind%
Gui, Font, s8 cD3D3D3 Bold, Segoe UI
Gui, Add, Text, x50 y190, Macro Speed:
Gui, Font, s8 cBlack, Segoe UI
IniRead, SavedSpeed, %settingsFile%, Main, MacroSpeed, Stable
Gui, Add, DropDownList, vSavedSpeed gSaveMacroSpeedHandler x130 y190 w50, Stable|Fast|Ultra|Max
GuiControl, ChooseString, SavedSpeed, %SavedSpeed%
Gui, Font, s10 cWhite Bold, Segoe UI
Gui, Add, Button, x50 y335 w150 h40 gStartMacro Background202020, Start Macro (F5)
Gui, Add, Button, x320 y335 w150 h40 gReloadMacro Background202020, Stop Macro (F7)
Gui, Tab, 7
Gui, Font, s9 cWhite Bold, Segoe UI
Gui, Add, GroupBox, x23 y50 w475 h340 cD3D3D3, Credits
Gui, Add, Picture, x40 y70 w48 h48, % mainDir "Images\\Josh.png"
Gui, Font, s10 cWhite Bold, Segoe UI
Gui, Add, Text, x100 y70 w200 h24, Josh
Gui, Font, s8 cFFC0CB Italic, Segoe UI
Gui, Add, Text, x100 y96 w200 h16, Made this free
Gui, Font, s8 cWhite, Segoe UI
Gui, Add, Text, x40 y130 w200 h40, Selling an ahk script for 500 robux is terrible, anyways ur obfuscator is ass
Gui, Add, Text, x40 y200 w200 h20, Extra Resources:
Gui, Font, s8 cD3D3D3 Underline, Segoe UI
Gui, Add, Link, x40 y244 w300 h16,  Check the <a href="https://github.com/Josh-AS/Virage-Grow-A-Garden-Macro-PREMIUM-CRACKED-/">Github</a> for the latest macro updates!
Gui, Show, w520 h425, Virage GAG Macro (JoshAS Crack)
Return

SaveWebhookButtonHandler:
    Gui, Submit, NoHide
    CheckInputURLValid(webhookURL, 1, "webhook")
    Return

SaveUserIDButtonHandler:
    Gui, Submit, NoHide
    if (discordUserID != "") {
    IniWrite, %discordUserID%, %settingsFile%, Main, DiscordUserID
    MsgBox, 0, Message, Discord UserID Saved
    }
    Return

SavePrivateServerLinkButtonHandler:
    Gui, Submit, NoHide
    CheckInputURLValid(privateServerLink, 1, "privateserver")
    Return

ClearSavesButtonHandler:
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

SaveKeybindHandler:
    Gui, Submit, NoHide
    IniWrite, %SavedKeybind%, %settingsFile%, Main, UINavigationKeybind
    GuiControl, ChooseString, SavedKeybind, %SavedKeybind%
    MsgBox, 0, Message, % "Keybind saved as: " . SavedKeybind
    Return

SaveMacroSpeedHandler:
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

SaveResolutionHandler:
    Gui, Submit, NoHide
    IniWrite, %selectedResolution%, %settingsFile%, Main, Resolution
    return

HandleGuiCheckboxUpdate:
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
    Gosub, SaveSettings
    }
    else if (A_GuiControl = "SelectAllEggs") {
    Loop, % eggItems.Length()
    GuiControl,, EggItem%A_Index%, % SelectAllEggs
    Gosub, SaveSettings
    }
    else if (A_GuiControl = "SelectAllGears") {
    Loop, % gearItems.Length()
    GuiControl,, GearItem%A_Index%, % SelectAllGears
    Gosub, SaveSettings
    }
    else if (A_GuiControl = "SelectAllHoney") {
    Loop, % realHoneyItems.Length()
    GuiControl,, HoneyItem%A_Index%, % SelectAllHoney
    Gosub, SaveSettings
    }
    return

HandleCheckboxColorUpdate:
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

HideTooltip:
    ToolTip
    return

UpdateSelectedItemsFromGui:
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

GetSelectedItems() {
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

StartMacro:
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
    currentSection := "StartMacro"
    SetTimer, HandleReconnect, Off
    SetTimer, HandleRejoin, Off
    GetRobloxWindowIDs()
    if InStr(A_ScriptDir, A_Temp) {
    MsgBox, 16, Error, Please, extract the file before running the macro.
    ExitApp
    }
    if(!windowIDS.MaxIndex()) {
    MsgBox, 0, Message, No Roblox Window Found
    Return
    }
    SendDiscordWebhook(webhookURL, "Macro started.")
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
    SetTimer, HideTooltip, -5000
    WinActivate, % "ahk_id " . currentWindow
    Sleep, 500
    ClickRelativeToRobloxWindow(0.5, 0.5)
    Sleep, 100
    Gosub, AlignInstance
    Sleep, 100
    }
    }
    else {
    Sleep, 500
    Gosub, AlignInstance
    Sleep, 100
    }
    WinActivate, % "ahk_id " . firstWindow
    Gui, Submit, NoHide
    Gosub, UpdateSelectedItemsFromGui
    itemsText := GetSelectedItems()
    Sleep, 500
    Gosub, InitializeMacroCycles
    while (started) {
    if (actionQueue.Length()) {
    SetTimer, HandleReconnect, Off
    ToolTip
    next := actionQueue.RemoveAt(1)
    if (MultiInstanceMode) {
    for window in windowIDS {
    currentWindow := % windowIDS[window]
    instanceNumber := window
    ToolTip, % "Running Cycle On Instance " . window
    SetTimer, HideTooltip, -1500
    SendDiscordWebhook(webhookURL, "***Instance " . instanceNumber . "***")
    WinActivate, % "ahk_id " . currentWindow
    Sleep, 200
    ClickRelativeToRobloxWindow(midX, midY)
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
    Gosub, ShowCycleTimers
    if (cycleFinished) {
    WinActivate, % "ahk_id " . firstWindow
    cycleCount++
    SendDiscordWebhook(webhookURL, "[**CYCLE " . cycleCount . " COMPLETED**]")
    cycleFinished := 0
    if (!MultiInstanceMode) {
    SetTimer, HandleReconnect, 5000
    }
    }
    Sleep, 1000
    }
    }
    Return

SeedCycleTimer:
    if (cycleCount > 0 && Mod(currentMinute, 5) = 0 && currentMinute != lastSeedMinute) {
    lastSeedMinute := currentMinute
    SetTimer, QueueSeedShopAction, -8000
    }
    Return

QueueSeedShopAction:
    actionQueue.Push("SeedShopAction")
    Return

SeedShopAction:
    currentSection := "SeedShopAction"
    if (selectedSeedItems.Length())
    Gosub, SeedCycleRoutine
    Return

GearCycleTimer:
    if (cycleCount > 0 && Mod(currentMinute, 5) = 0 && currentMinute != lastGearMinute) {
    lastGearMinute := currentMinute
    SetTimer, QueueGearShopAction, -8000
    }
    Return

QueueGearShopAction:
    actionQueue.Push("GearShopAction")
    Return

GearShopAction:
    currentSection := "GearShopAction"
    if (selectedGearItems.Length())
    Gosub, GearCycleRoutine
    Return

EggCycleTimer:
    if (cycleCount > 0 && Mod(currentMinute, 30) = 0 && currentMinute != lastEggShopMinute) {
    lastEggShopMinute := currentMinute
    SetTimer, QueueEggShopAction, -8000
    }
    Return

QueueEggShopAction:
    actionQueue.Push("EggShopAction")
    Return

EggShopAction:
    currentSection := "EggShopAction"
    if (selectedEggItems.Length()) {
        Gosub, EggCycleRoutine
    }
    Return

CosmeticCycleTimer:
    if (cycleCount > 0 && currentMinute = 0 && Mod(currentHour, 2) = 0 && currentHour != lastCosmeticShopHour) {
    lastCosmeticShopHour := currentHour
    SetTimer, QueueCosmeticShopAction, -8000
    }
    Return

QueueCosmeticShopAction:
    actionQueue.Push("CosmeticShopAction")
    Return

CosmeticShopAction:
    currentSection := "CosmeticShopAction"
    if (BuyAllCosmetics) {
    Gosub, CosmeticCycleRoutine
    }
    Return

CollectPollinatedCycleTimer:
    if (cycleCount > 0 && currentMinute = 0 && currentHour != lastCollectPollinatedHour) {
    lastCollectPollinatedHour := currentHour
    SetTimer, QueueCollectPollinatedAction, -600000
    }
    Return

QueueCollectPollinatedAction:
    actionQueue.Push("CollectPollinatedAction")
    Return

CollectPollinatedAction:
    currentSection := "CollectPollinatedAction"
    if (AutoCollectPollinated) {
        Gosub, CollectPollinatedRoutine
    }
    Return

HoneyShopCycleTimer:
    if (cycleCount > 0 && Mod(currentMinute, 30) = 0 && currentMinute != lastHoneyShopMinute) {
    lastHoneyShopMinute := currentMinute
    SetTimer, QueueHoneyShopAction, -8000
    }
    Return

QueueHoneyShopAction:
    actionQueue.Push("HoneyShopAction")
    Return

HoneyShopAction:
    currentSection := "HoneyShopAction"
    if (selectedHoneyItems.Length()) {
    Gosub, HoneyShopRoutine
    }
    Return

HoneyDepositCycleTimer:
    if (cycleCount > 0 && Mod(currentMinute, 5) = 0 && currentMinute != lastDepositHoneyMinute) {
    lastDepositHoneyMinute := currentMinute
    SetTimer, QueueHoneyDepositAction, -8000
    }
    Return

QueueHoneyDepositAction:
    actionQueue.Push("HoneyDepositAction")
    Return

HoneyDepositAction:
    currentSection := "HoneyDepositAction"
    if (AutoHoney) {
        Gosub, HoneyDepositRoutine
    }
    Return

ShowCycleTimers:
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
    depositHoneyMin := rem5sec // 60Add commentMore actions
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
    if (AutoCollectPollinated) {
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

InitializeMacroCycles:
    SetTimer, UpdateCurrentTime, 1000
    if (selectedSeedItems.Length()) {
    actionQueue.Push("SeedShopAction")
    }
    seedAutoActive := 1
    SetTimer, SeedCycleTimer, 1000
    if (selectedGearItems.Length()) {
    actionQueue.Push("GearShopAction")
    }
    gearAutoActive := 1
    SetTimer, GearCycleTimer, 1000
    if (selectedEggItems.Length()) {
    actionQueue.Push("EggShopAction")
    }
    eggAutoActive := 1
    SetTimer, EggCycleTimer, 1000
    if (BuyAllCosmetics) {
    actionQueue.Push("CosmeticShopAction")
    }
    cosmeticAutoActive := 1
    SetTimer, CosmeticCycleTimer, 1000
    if (AutoCollectPollinated) {
        actionQueue.Push("CollectPollinatedAction")
    }
    collectPollinatedAutoActive := 1
    SetTimer, CollectPollinatedCycleTimer, 1000
    if (selectedHoneyItems.Length()) {
    actionQueue.Push("HoneyShopAction")
    }
    honeyShopAutoActive := 1
    SetTimer, HoneyShopCycleTimer, 1000
    if (AutoHoney) {
    actionQueue.Push("HoneyDepositAction")
    }
    honeyDepositAutoActive := 1
    SetTimer, HoneyDepositCycleTimer, 1000
    Return

UpdateCurrentTime:
    FormatTime, currentHour,, hh
    FormatTime, currentMinute,, mm
    FormatTime, currentSecond,, ss
    currentHour := currentHour + 0
    currentMinute := currentMinute + 0
    currentSecond := currentSecond + 0
    Return

HandleReconnect:
    global actionQueue
    if (PixelSearchInRobloxWindow(0x302927, 0, 0.3988, 0.3548, 0.6047, 0.6674) && PixelSearchInRobloxWindow(0xFFFFFF, 0, 0.3988, 0.3548, 0.6047, 0.6674) && privateServerLink != "") {
    started := 0
    actionQueue := []
    SetTimer, HandleReconnect, Off
    Sleep, 500
    WinClose, % "ahk_id" . firstWindow
    Sleep, 1000
    WinClose, % "ahk_id" . firstWindow
    Sleep, 500
    Run, % privateServerLink
    ToolTip, Attempting To Reconnect
    SetTimer, HideTooltip, -5000
    SendDiscordWebhook(webhookURL, "Lost connection or macro errored, attempting to reconnect..." . (PingSelected ? " <@" . discordUserID . ">" : ""))
    SleepFromSpeed(15000, 30000)
    SetTimer, HandleRejoin, 5000
    }
    Return

HandleRejoin:
    ToolTip, Detecting Rejoin
    GetRobloxWindowIDs()
    WinActivate, % "ahk_id" . firstWindow
    if (PixelSearchInRobloxWindow(0x000000, 0, 0.75, 0.75, 0.9, 0.9)) {
    ClickRelativeToRobloxWindow(midX, midY)
    }
    else {
    ToolTip, Rejoined Successfully
    SleepFromSpeed(5000, 10000)
    SendDiscordWebhook(webhookURL, "Successfully reconnected to server." . (PingSelected ? " <@" . discordUserID . ">" : ""))
    Sleep, 200
    Gosub, StartMacro
    }
    Return

AlignInstance:
    ToolTip, Beginning Alignment
    SetTimer, HideTooltip, -5000
    ClickRelativeToRobloxWindow(0.5, 0.5)
    Sleep, 100
    InventoryItemSearch("recall")
    Sleep, 200
    if (AutoAlign) {
    GoSub, AutoAlignRoutine
    Sleep, 100
    Gosub, ScrollToMiddleRoutine
    Sleep, 100
    GoSub, RightClickDragRoutine
    Sleep, 100
    Gosub, OpenShopRoutine
    Sleep, 100
    Gosub, AutoAlignRoutine
    Sleep, 100
    }
    else {
    Gosub, ScrollToMiddleRoutine
    Sleep, 100
    }
    Sleep, 1000
    NavigateUI(11110)
    Sleep, 100
    ToolTip, Alignment Complete
    SetTimer, HideTooltip, -1000
    Return

AutoAlignRoutine:
    Send, {Escape}
    Sleep, 500
    Send, {Tab}
    Sleep, 400
    Send {Down}
    Sleep, 100
    RepeatKey("Right", 2, (SavedSpeed = "Ultra") ? 55 : (SavedSpeed = "Max") ? 60 : 30)
    Sleep, 100
    Send {Escape}
    Return

RightClickDragRoutine:
    Click, Right, Down
    Sleep, 200
    MoveRelativeToRobloxWindow(0.5, 0.5)
    Sleep, 200
    MouseMove, 0, 800, R
    Sleep, 200
    Click, Right, Up
    Return

ScrollToMiddleRoutine:
    MoveRelativeToRobloxWindow(0.5, 0.5)
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
    midX := GetMouseRelativeToRobloxWindow("x")
    midY := GetMouseRelativeToRobloxWindow("y")
    Return

OpenShopRoutine:
    ToggleUINavigate(SavedKeybind)
    Sleep, 10
    if (UINavigationFix) {
    RepeatKey("Left", 5)
    Sleep, 10
    RepeatKey("Up", 5)
    Sleep, 10
    }
    RepeatKey("Right", 3)
    Loop, % ((SavedSpeed = "Ultra") ? 12 : (SavedSpeed = "Max") ? 18 : 8) {
    Send, {Enter}
    Sleep, 10
    RepeatKey("Right", 2)
    Sleep, 10
    Send, {Enter}
    Sleep, 10
    RepeatKey("Left", 2)
    }
    Sleep, 10
    ToggleUINavigate(SavedKeybind)
    Return

EggCycleRoutine:
    Sleep, 100
    NavigateUI("11110")
    Sleep, 100
    HotbarNavigate(1, 0, "2")
    SleepFromSpeed(100, 1000)
    ClickRelativeToRobloxWindow(midX, midY)
    SendDiscordWebhook(webhookURL, "**[Egg Cycle]**")
    Sleep, 800
    Send, {w Down}
    Sleep, 1800
    Send {w Up}
    SleepFromSpeed(500, 1000)
    Send {e}
    Sleep, 100
    NavigateUI("11114", 0, 0)
    Sleep, 100
    HandleEggShop(0x26EE26, 15, 0.41, 0.65, 0.52, 0.70)
    Sleep, 800
    Send, {w down}
    Sleep, 200
    Send, {w up}
    SleepFromSpeed(100, 1000)
    Send {e}
    Sleep, 100
    NavigateUI("11114", 0, 0)
    Sleep, 100
    HandleEggShop(0x26EE26, 15, 0.41, 0.65, 0.52, 0.70)
    Sleep, 800
    Send, {w down}
    Sleep, 200
    Send, {w up}
    SleepFromSpeed(100, 1000)
    Send, {e}
    Sleep, 200
    NavigateUI("11114", 0, 0)
    Sleep, 100
    HandleEggShop(0x26EE26, 15, 0.41, 0.65, 0.52, 0.70)
    Sleep, 300
    SpamEscape()
    SleepFromSpeed(1250, 2500)
    SendDiscordWebhook(webhookURL, "**[Eggs Completed]**")
    Return

SeedCycleRoutine:
    seedsCompleted := 0
    NavigateUI("1111020")
    SleepFromSpeed(100, 1000)
    Send, {e}
    SendDiscordWebhook(webhookURL, "**[Seed Cycle]**")
    SleepFromSpeed(2500, 5000)
    Loop, 5 {
    if (PixelSearchInRobloxWindow(0x00CCFF, 10, 0.54, 0.20, 0.65, 0.325)) {
    ToolTip, Seed Shop Opened
    SetTimer, HideTooltip, -1500
    SendDiscordWebhook(webhookURL, "Seed Shop Opened.")
    Sleep, 200
    NavigateUI("33311443333114405550555", 0)
    Sleep, 100
    BuyItem("seed")
    SendDiscordWebhook(webhookURL, "Seed Shop Closed.")
    seedsCompleted = 1
    }
    if (seedsCompleted) {
    break
    }
    Sleep, 2000
    }
    HandleShopClose("seed", seedsCompleted)
    SendDiscordWebhook(webhookURL, "**[Seeds Completed]**")
    Return

GearCycleRoutine:
    gearsCompleted := 0
    HotbarNavigate(0, 1, "0")
    NavigateUI("11110")
    SleepFromSpeed(100, 500)
    HotbarNavigate(1, 0, "2")
    SleepFromSpeed(100, 500)
    ClickRelativeToRobloxWindow(midX, midY)
    SleepFromSpeed(1200, 2500)
    Send, {e}
    SleepFromSpeed(1500, 5000)
    ShopDialogClick("gear")
    SendDiscordWebhook(webhookURL, "**[Gear Cycle]**")
    SleepFromSpeed(2500, 5000)
    Loop, 5 {
    if (PixelSearchInRobloxWindow(0x00CCFF, 10, 0.54, 0.20, 0.65, 0.325)) {
    ToolTip, Gear Shop Opened
    SetTimer, HideTooltip, -1500
    SendDiscordWebhook(webhookURL, "Gear Shop Opened.")
    Sleep, 200
    NavigateUI("33311443333114405550555", 0)
    Sleep, 100
    BuyItem("gear")
    SendDiscordWebhook(webhookURL, "Gear Shop Closed.")
    gearsCompleted = 1
    }
    if (gearsCompleted) {
    break
    }
    Sleep, 2000
    }
    HandleShopClose("gear", gearsCompleted)
    HotbarNavigate(0, 1, "0")
    SendDiscordWebhook(webhookURL, "**[Gears Completed]**")
    Return


CosmeticCycleRoutine:
    cosmeticsCompleted := 0
    HotbarNavigate(0, 1, "0")
    NavigateUI("11110")
    SleepFromSpeed(100, 500)
    HotbarNavigate(1, 0, "2")
    SleepFromSpeed(100, 500)
    ClickRelativeToRobloxWindow(midX, midY)
    SleepFromSpeed(800, 1000)
    Send, {w Down}
    Sleep, 900
    Send, {w Up}
    SleepFromSpeed(100, 1000)
    Send, {e}
    SleepFromSpeed(2500, 5000)
    SendDiscordWebhook(webhookURL, "**[Cosmetic Cycle]**")
    Loop, 5 {
    if (PixelSearchInRobloxWindow(0x00CCFF, 10, 0.61, 0.182, 0.764, 0.259)) {
    ToolTip, Cosmetic Shop Opened
    SetTimer, HideTooltip, -1500
    SendDiscordWebhook(webhookURL, "Cosmetic Shop Opened.")
    Sleep, 200
    for index, item in cosmeticItems {
    label := StrReplace(item, " ", "")
    currentItem := cosmeticItems[A_Index]
    Gosub, %label%
    SendDiscordWebhook(webhookURL, "Bought " . currentItem . (PingSelected ? " <@" . discordUserID . ">" : ""))
    Sleep, 100
    }
    SendDiscordWebhook(webhookURL, "Cosmetic Shop Closed.")
    cosmeticsCompleted = 1
    }
    if (cosmeticsCompleted) {
    break
    }
    Sleep, 2000
    }
    if (cosmeticsCompleted) {
    Sleep, 500
    NavigateUI("111114150320")
    }
    else {
    SendDiscordWebhook(webhookURL, "Failed To Detect Cosmetic Shop Opening [Error]" . (PingSelected ? " <@" . discordUserID . ">" : ""))
    NavigateUI("11114111350")
    Sleep, 50
    NavigateUI("11110")
    }
    HotbarNavigate(0, 1, "0")
    SendDiscordWebhook(webhookURL, "**[Cosmetics Completed]**")
    Return

Cosmetic1:

    Sleep, 50
    Loop, 5 {
        NavigateUI("161616161646465606")
        Sleep, % (SavedSpeed = "Ultra") ? 50 : (SavedSpeed = "Max") ? 30 : 200
    }

Return

Cosmetic2:

    Sleep, 50
    Loop, 5 {
        NavigateUI("1616161616464626265606")
        Sleep, % (SavedSpeed = "Ultra") ? 50 : (SavedSpeed = "Max") ? 30 : 200
    }

Return

Cosmetic3:

    Sleep, 50
    Loop, 5 {
        NavigateUI("16161616164646262626265606")
        Sleep, % (SavedSpeed = "Ultra") ? 50 : (SavedSpeed = "Max") ? 30 : 200
    }

Return

Cosmetic4:

    Sleep, 50
    Loop, 5 {
        NavigateUI("1616161616464626262626465606")
        Sleep, % (SavedSpeed = "Ultra") ? 50 : (SavedSpeed = "Max") ? 30 : 200
    }

Return

Cosmetic5:

    Sleep, 50
    Loop, 5 {
        NavigateUI("161616161646462626262646165606")
        Sleep, % (SavedSpeed = "Ultra") ? 50 : (SavedSpeed = "Max") ? 30 : 200
    }

Return

Cosmetic6:

    Sleep, 50
    Loop, 5 {
        NavigateUI("16161616164646262626264616165606")
        Sleep, % (SavedSpeed = "Ultra") ? 50 : (SavedSpeed = "Max") ? 30 : 200
    }

Return

Cosmetic7:

    Sleep, 50
    Loop, 5 {
        NavigateUI("1616161616464626262626461616165606")
        Sleep, % (SavedSpeed = "Ultra") ? 50 : (SavedSpeed = "Max") ? 30 : 200
    }

Return

Cosmetic8:

    Sleep, 50
    Loop, 5 {
        NavigateUI("161616161646462626262646161616165606")
       Sleep, % (SavedSpeed = "Ultra") ? 50 : (SavedSpeed = "Max") ? 30 : 200
    }

Return

Cosmetic9:

    Sleep, 50
    Loop, 5 {
        NavigateUI("16161616164646262626264616161616165606")
        Sleep, % (SavedSpeed = "Ultra") ? 50 : (SavedSpeed = "Max") ? 30 : 200
    }

Return

CollectPollinatedRoutine:
    SendDiscordWebhook(webhookURL, "**[Pollenated Plant Collection Cycle]**")
    NavigateUI("11110")
    SleepFromSpeed(1000, 2000)
    InventoryItemSearch("pollen")
    HotbarNavigate(1, 0, "3")
    SendDiscordWebhook(webhookURL, "**[Collecting Left Side...]**")
    Send, {s down}
    Sleep, 270
    Send, {s up}
    SleepFromSpeed(200, 500)
    Send, {a down}
    Sleep, 900
    Send, {a up}
    SleepFromSpeed(200, 500)
    ClickRelativeToRobloxWindow(midX, midY)
    SleepFromSpeed(8000, 10000)
    Send, {a down}
    Sleep, 800
    Send, {a up}
    SleepFromSpeed(200, 500)
    ClickRelativeToRobloxWindow(midX, midY)
    SleepFromSpeed(8000, 10000)
    Send, {a down}
    Sleep, 600
    Send, {a up}
    SleepFromSpeed(200, 500)
    Send, {s down}
    Sleep, 1000
    Send, {s up}
    SleepFromSpeed(200, 500)
    ClickRelativeToRobloxWindow(midX, midY)
    SleepFromSpeed(8000, 10000)
    Send, {s down}
    Sleep, 1200
    Send, {s up}
    SleepFromSpeed(200, 500)
    ClickRelativeToRobloxWindow(midX, midY)
    SleepFromSpeed(8000, 10000)
    Send, {s down}
    Sleep, 1300
    Send, {s up}
    SleepFromSpeed(200, 500)
    ClickRelativeToRobloxWindow(midX, midY)
    SleepFromSpeed(8000, 10000)
    Send, {s down}
    Sleep, 1000
    Send, {s up}
    SleepFromSpeed(200, 500)
    Send, {d down}
    Sleep, 900
    Send, {d up}
    SleepFromSpeed(200, 500)
    ClickRelativeToRobloxWindow(midX, midY)
    SleepFromSpeed(8000, 10000)
    Send, {d down}
    Sleep, 800
    Send, {d up}
    SleepFromSpeed(200, 500)
    ClickRelativeToRobloxWindow(midX, midY)
    SleepFromSpeed(8000, 10000)
    Send, {d down}
    Sleep, 600
    Send, {d up}
    SleepFromSpeed(200, 500)
    NavigateUI("11110")
    SendDiscordWebhook(webhookURL, "**[Collecting Right Side...]**")
    Send, {s down}
    Sleep, 270
    Send, {s up}
    SleepFromSpeed(200, 500)
    Send, {d down}
    Sleep, 800
    Send, {d up}
    SleepFromSpeed(200, 500)
    ClickRelativeToRobloxWindow(midX, midY)
    SleepFromSpeed(8000, 10000)
    Send, {d down}
    Sleep, 800
    Send, {d up}
    SleepFromSpeed(200, 500)
    ClickRelativeToRobloxWindow(midX, midY)
    SleepFromSpeed(8000, 10000)
    Send, {d down}
    Sleep, 600
    Send, {d up}
    SleepFromSpeed(200, 500)
    Send, {s down}
    Sleep, 1000
    Send, {s up}
    SleepFromSpeed(200, 500)
    ClickRelativeToRobloxWindow(midX, midY)
    SleepFromSpeed(8000, 10000)
    Send, {s down}
    Sleep, 1200
    Send, {s up}
    SleepFromSpeed(200, 500)
    ClickRelativeToRobloxWindow(midX, midY)
    SleepFromSpeed(8000, 10000)
    Send, {s down}
    Sleep, 1300
    Send, {s up}
    SleepFromSpeed(200, 500)
    ClickRelativeToRobloxWindow(midX, midY)
    SleepFromSpeed(8000, 10000)
    Send, {s down}
    Sleep, 1000
    Send, {s up}
    SleepFromSpeed(200, 500)
    Send, {a down}
    Sleep, 900
    Send, {a up}
    SleepFromSpeed(200, 500)
    ClickRelativeToRobloxWindow(midX, midY)
    SleepFromSpeed(8000, 10000)
    Send, {a down}
    Sleep, 800
    Send, {a up}
    SleepFromSpeed(200, 500)
    ClickRelativeToRobloxWindow(midX, midY)
    SleepFromSpeed(8000, 10000)
    Send, {a down}
    Sleep, 600
    Send, {a up}
    SleepFromSpeed(200, 500)
    NavigateUI("11110")
    SendDiscordWebhook(webhookURL, "**[Collecting Middle Area...]**")
    Send, {s down}
    Sleep, 1000
    Send, {s up}
    SleepFromSpeed(200, 500)
    ClickRelativeToRobloxWindow(midX, midY)
    SleepFromSpeed(8000, 10000)
    Send, {s down}
    Sleep, 1200
    Send, {s up}
    SleepFromSpeed(200, 500)
    ClickRelativeToRobloxWindow(midX, midY)
    SleepFromSpeed(8000, 10000)
    Send, {s down}
    Sleep, 1300
    Send, {s up}
    SleepFromSpeed(200, 500)
    ClickRelativeToRobloxWindow(midX, midY)
    SleepFromSpeed(8000, 10000)
    Send, {s down}
    Sleep, 1000
    Send, {s up}
    SleepFromSpeed(200, 500)
    ClickRelativeToRobloxWindow(midX, midY)
    SleepFromSpeed(8000, 10000)
    HotbarNavigate(0, 1, "0")
    NavigateUI(11110)
    SendDiscordWebhook(webhookURL, "**[Pollenated Plant Collection Completed]**")
    Return

;Honey Deposit Cycle
HoneyDepositRoutine:
    depositCount := 0
    SendDiscordWebhook(webhookURL, "**[Honey Deposit Cycle]**")
    NavigateUI("1111020")
    SleepFromSpeed(1000, 2000)
    Send, {d down}
    Sleep, 8500
    Send, {d up}
    SleepFromSpeed(100, 1000)
    Send, {w down}
    Sleep, 650
    Send, {w up}
    SleepFromSpeed(100, 1000)
    Send, {d down}
    Sleep, 1200
    Send, {d up}
    SleepFromSpeed(100, 500)
    Loop, 3 {
        InventoryItemSearch("pollinated")
        SpamEscape(2)
        Sleep, 500
        HotbarNavigate(1, 0, "9")
        SleepFromSpeed(100, 500)
        Loop, 2 {
            Send {e}
            Sleep, 200
        }
        depositCount++
        SendDiscordWebhook(webhookURL, "Depositing/Collecting Honey Try #" . depositCount . ".")
        Sleep, 1000
    }
    HotbarNavigate(0, 1, "0")
    NavigateUI(11110)
    SendDiscordWebhook(webhookURL, "**[Honey Deposit Completed]**")
    Return

HoneyShopRoutine:
    global UINavigationFix
    honeyCompleted := 0
    SendDiscordWebhook(webhookURL, "**[Honey Shop Cycle]**")
    NavigateUI("1111020")
    SleepFromSpeed(1000, 2000)
    Send, {d down}
    Sleep, 9050
    Send, {d up}
    SleepFromSpeed(100, 1000)
    Send, {w down}
    Sleep, 250
    Send, {w up}
    Loop, 2 {
    Send, {WheelDown}
    Sleep, 20
    }
    SleepFromSpeed(500, 1500)
    Send, {e}
    SleepFromSpeed(500, 1500)
    Loop, 2 {
    Send, {WheelUp}
    Sleep, 20
    }
    SleepFromSpeed(500, 2000)
    ShopDialogClick("honey")
    SleepFromSpeed(2500, 5000)
    Loop, 5 {
    if (PixelSearchInRobloxWindow(0x02EFD3, 10, 0.54, 0.20, 0.65, 0.325)) {
    ToolTip, Honey Shop Opened
    SetTimer, HideTooltip, -1500
    SendDiscordWebhook(webhookURL, "Honey Shop Opened.")
    Sleep, 200
    if (UINavigationFix) {
    NavigateUI("33332223333111405550555", 0)
    }
    else {
    NavigateUI("3333114443333311405550555", 0)
    }
    Sleep, 100
    BuyItem("honey")
    SendDiscordWebhook(webhookURL, "Honey Shop Closed.")
    honeyCompleted = 1
    }
    if (honeyCompleted) {
    break
    }
    Sleep, 2000
    }
    HandleShopClose("honey", honeyCompleted)
    HotbarNavigate(0, 1, "0")
    SendDiscordWebhook(webhookURL, "**[Honey Shop Completed]**")
    Return

SaveSettings:
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

StopMacro(exitApp := 1) {
    Gui, Submit, NoHide
    Sleep, 50
    started := 0
    Gosub, SaveSettings
    Gui, Destroy
    if (exitApp)
    ExitApp
}

PauseMacro(unusedP := 1) {
    Gui, Submit, NoHide
    Sleep, 50
    started := 0
    Gosub, SaveSettings
}

GuiClose:
    StopMacro(1)
    Return

ReloadMacro:
    PauseMacro(1)
    SendDiscordWebhook(webhookURL, "Macro reloaded.")
    Reload
    Return

F7::
    PauseMacro(1)
    Reload
    Return

F5::
    Gosub, StartMacro
    Return

F8::
    MsgBox, 1, Message, % "Delete debug file?"
    IfMsgBox, OK
    FileDelete, debug.txt
    Return

#MaxThreadsPerHotkey, 2
