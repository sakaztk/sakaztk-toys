#UseHook
toggle_key = f9
setting_key = ^!f12

IniRead, toggle_key, %A_ScriptFullPath%.ini, Settings, toggle_key, %toggle_key%
IniRead, setting_key, %A_ScriptFullPath%.ini, Settings, setting_key, %setting_key%

Hotkey, %toggle_key%, do_toggle
Hotkey, %setting_key%, show_gui


vkf4::Send {``}  ; 半角/全角 to `
+vkf4::Send {~}  ; Shift+半角/全角 to ~
+2::Send {@}     ; Shift+2 " to @
+6::Send {^}     ; Shift+6 & to ^
+7::Send {&}     ; Shift+7 ' to &
+8::Send {*}     ; Shift+8 ( to *
+9::Send {(}     ; Shift+9 ) to (
+0::Send {)}     ; Shift+0 to )
+-::Send {_}     ; Shift+- = to _
^::=             ; ^ to =
+^::Send {+}     ; Shift+^ ~ to +
@::[             ; @ to [
+@::Send {{}     ; Shift+@ ` to {
[::]             ; [ to ]
+[::Send {}}     ; Shift+[ { to }
]::\             ; ] to \
+]::Send {|}     ; Shift+] } to |
+;::Send {:}     ; Shift+; + to :
vkba::'          ; : to '
+vkba::Send {"}  ; Shift+: * to "


do_toggle:
    Suspend, Toggle
return

show_gui:
    Gui, -MinimizeBox +Resize
    Gui, Add, Text, , Toggle Key
    Gui, Add, Hotkey, vtoggle_key, %toggle_key%
    Gui, Add, Text, , Show Settings
    Gui, Add, Hotkey, vsetting_key, %setting_key%
    Gui, Add, Button, W100 X25 Default , OK
    Gui, Add, Button, W100 X+0, Cancel
    Gui, Show, , Setting
return

ButtonOK:
    Hotkey, %toggle_key%, off
    Hotkey, %setting_key%, off
    Gui, Submit
    Hotkey, %toggle_key%, do_toggle
    Hotkey, %setting_key%, show_gui
    IniWrite, %toggle_key%, %A_ScriptFullPath%.ini, settings, toggle_key
    IniWrite, %setting_key%, %A_ScriptFullPath%.ini, settings, setting_key

ButtonCancel:
GuiClose:
  Gui, Destroy
return

