#Requires AutoHotkey v2.0
#SingleInstance Force
#UseHook
window_title := "JP2EN"
toggle_key := "f9"
setting_key := "^!f12"

toggle_key := IniRead(A_ScriptFullPath ".ini", "Settings", "toggle_key", toggle_key)
setting_key := IniRead(A_ScriptFullPath ".ini", "Settings", "setting_key", setting_key)

Hotkey(toggle_key, do_toggle, "S")
Hotkey(setting_key, show_gui, "S")

vkf4::Send("{``}")  ; 半角/全角 to `
+vkf4::Send("{~}")  ; Shift+半角/全角 to ~
+2::Send("{@}")     ; Shift+2 " to @
+6::Send("{^}")     ; Shift+6 & to ^
+7::Send("{&}")     ; Shift+7 ' to &
+8::Send("{*}")     ; Shift+8 ( to *
+9::Send("{(}")     ; Shift+9 ) to (
+0::Send("{)}")     ; Shift+0 to )
+-::Send("{_}")     ; Shift+- = to _
^::=                ; ^ to =
+^::Send("{+}")     ; Shift+^ ~ to +
@::[                ; @ to [
+@::Send("{{}")     ; Shift+@ ` to {
[::]                ; [ to ]
+[::Send("{}}")     ; Shift+[ { to }
]::\                ; ] to \
+]::Send("{|}")     ; Shift+] } to |
+;::Send("{:}")     ; Shift+; + to :
vkba::'             ; : to '
+vkba::Send("{`"}") ; Shift+: * to "

do_toggle(ThisHotkey)
{
    Suspend(-1)
}

show_gui(ThisHotkey)
{
    myGui := Gui(,window_title)
    myGui.Add("Text",, "Toggle Key")
    toggleHotkey := myGui.Add("Hotkey", "vtoggle_key", toggle_key)
    toggleHotkey.OnEvent("Change", change_toggle_value)
    myGui.Add("Text",, "Show Settings")
    settingHotkey := myGui.Add("Hotkey", "vsetting_key", setting_key)
    settingHotkey.OnEvent("Change", change_setting_value)
    okBtn := myGui.Add("Button", "W100 X25", "OK")
    okBtn.OnEvent("Click", click_ok) 
    cancelBtn := myGui.Add("Button", "W100 X+0", "Cancel")
    cancelBtn.OnEvent("Click", close_gui)
    myGui.OnEvent("Close", close_gui)
    myGui.OnEvent("Escape", close_gui)
    change_toggle_value(*)
    {
        if(toggleHotkey.Value = "")
        {
            toggleHotkey.Value := toggle_key
        }
    }
    change_setting_value(*)
    {
        if(settingHotkey.Value = "")
        {
            settingHotkey.Value := setting_key
        }
    }
    click_ok(*)
    {
        oSaved := myGui.Submit()
        toggle_key_new := oSaved.toggle_key
        setting_key_new := oSaved.setting_key
        IniWrite(toggle_key_new, A_ScriptFullPath ".ini", "settings", "toggle_key")
        IniWrite(setting_key_new, A_ScriptFullPath ".ini", "settings", "setting_key")
        Reload()
    }
    close_gui(*)
    {
        Reload()
    }
    Hotkey(setting_key, "off", "S")
    myGui.Show()
}