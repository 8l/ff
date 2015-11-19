#!/usr/bin/env wish
#### forth - front-end for ff


set forth "ff"
set current_font_size 14
set current_font "Courier"
set rcfile "$env(HOME)/.forth"
set wrap_mode char
set executing ""
set executing_pid 0
set current_foreground "#d1f8c7"
set initial_background "#34312c"
set current_background $initial_background
set tabwidth 8
set entry_box_status 0
set entry_box_exists 0
set initcmd ""
set hold_mode 0
set hold_start ""
set snippets {}


tk appname forth


proc Flash {{color red}} {
    global current_background
    .t configure -background $color
    after 100 {.t configure -background $current_background}
}


proc Insert {text {tags ""}} {
    .t insert insert $text $tags
    .t see insert
}


proc Bottom {} {
    .t mark set insert end
    .t see end
}


proc Top {} {
    .t mark set insert 1.0
    .t see 1.0
}


proc ResizeFont {inc} {
    global current_font_size current_font
    set current_font_size [expr $current_font_size + $inc]
    .t configure -font [list $current_font $current_font_size]
}


proc ConfigureWindow {} {
    global current_background current_foreground current_font current_font_size
    global wrap_mode
    .t configure -background $current_background -foreground $current_foreground  \
	-selectbackground $current_foreground -selectforeground $current_background \
	-insertbackground $current_foreground -wrap $wrap_mode \
	-insertofftime 0 -highlightthickness 0 \
	-font [list $current_font $current_font_size]
}


proc Background {col} {
    global current_background
    set current_backgriund $col
    .t configure -background $col
}


proc ToggleWrapMode {{mode ""}} {
    global wrap_mode
    
    if {$mode != ""} {
	set wrap_mode $mode
    } elseif {$wrap_mode == "none"} {
	set wrap_mode "char" 
    } else { 
	set wrap_mode "none"
    }

    .t configure -wrap $wrap_mode
}


proc DefineKey {event cmd} {
    bind .t $event $cmd
}


proc FunctionKey {f} {
    global fkeys
    set sel [.t tag ranges sel]

    if {$sel != ""} {
        set str [eval .t get $sel]
        set fkeys($f) $str
        eval .t tag remove sel $sel
    } elseif {[info exists fkeys($f)]} {
        SendMacro $fkeys($f)
    }
}


proc SendMacro {str} {
    if {[string index $str end] == "\n"} {
        SendForth [string range $str 0 end-1]
    } else {
        .t insert insert $str
    }
}


proc EntryBox {{title ""} {value ""}} {
    global entry_box_status entry_box_exists current_font current_font_size

    if {!$entry_box_exists} {
	# http://www.tek-tips.com/viewthread.cfm?qid=112205
	toplevel .box
	entry .box.e
	.box.e configure -font [list $current_font $current_font_size]
	pack .box.e -fill both -expand 1
	wm title .box $title
	wm resizable .box 0 0
	wm withdraw .box
	wm protocol .box WM_DELETE_WINDOW {
	    set entry_box_status 0
	}
	bind .box.e <Return> {
	    set entry_box_status 1
	}
	bind .box.e <Escape> {
	    set entry_box_status 0
	}
	set entry_box_exists 1
    }

    wm geometry .box "400x30+100+100"
    set entry_box_status 0
    set old_focus [focus]
    .box.e configure
    .box.e delete 0 end
    .box.e insert 0 $value
    wm deiconify .box
    focus .box.e
    catch {tkwait visibility .box}
    catch {grab set .box}
    tkwait variable entry_box_status
    grab release .box
    focus $old_focus
    wm withdraw .box

    if {$entry_box_status} {
	return [.box.e get]
    }

    return ""
}


proc KillLine {} {
    if {[.t get insert] == "\n"} {
	.t delete insert
    } else {
	.t tag add sel insert "insert lineend"
	tk_textCut .t
    }
}


proc LogOutput {file} {
    global executing current_background

    if {$executing == ""} return

    set input [read $file]
    set blocked [fblocked $file]

    if {$input != ""} {
        while 1 {
            if {![regexp "^(\[^\x0c\]*)\x0c(.*)\$" $input _ head rest]} {
                Insert $input
                break
            }
        
            Insert $head
            .t delete 1.0 end
            set input $rest
        }
    } elseif {!$blocked} {
	catch {close $file} result
        Background black
	set executing ""
	Bottom
	Insert "\n   *** TERMINATED ***\n"
    }

    update idletasks
}


proc TerminateForth {} {
    global executing executing_pid
    catch {close $executing}
    catch {exec kill -9 $executing_pid}
    Background black
    set executing ""
    Bottom
    Insert "\n   *** TERMINATED ***\n"
}


proc ExecuteForth {} {
    global executing initial_background hold_mode

    if {$executing != ""} {
        set range [.t tag ranges sel]

        if {$range == ""} {
            if {$hold_mode != 0} return

            set input [.t get {insert linestart} {insert lineend}]
        } else {
            set input [.t get [lindex $range 0] [lindex $range 1]]
        }

	puts $executing "$input"
	Bottom
    } else {
        Background $initial_background
        StartForth
    }
}


proc SendForth {str} {
    global executing

    if {$executing != ""} {
	puts $executing $str
    }
}


proc Terminate {} {
    global executing

    if {$executing != ""} {
        TerminateForth
    } else {
        exit
    }
}

proc SaveFile {} {
    set init [GetFileDir]
    set name [tk_getSaveFile -initialdir $init]

    if {$name == ""} { return 0 }

    Flash green
    set out [open $name w]
    puts -nonewline $out [.t get 1.0 "end - 1 chars"]
    close $out
}


proc StartForth {} {
    global forth executing initcmd executing_pid
    set executing [open "| $forth 2>@ stdout" r+]
    fconfigure $executing -blocking 0 -buffering none
    fileevent $executing readable [list LogOutput $executing]
    set executing_pid [pid $executing]

    if {$initcmd != ""} { 
        SendForth $initcmd
    }
}


proc Help {} {
    global snippets
    Insert {
    Delete                 Toggle "hold" mode
    <Arrow>                Move insertion point
    Sh-<Arrow>             Move insertion point + extend selection
    C-Left, C-Right        Move insertion point by words
    C-Sh-Left, C-Sh-Right  Move insertion point by words + extend selection
    M-b, M-f               Same as C-Left and C-Right
    C-Sh-Up, C-Sh-Down     Move by paragraphs + extend selection
    C-p, C-n               Move up or down
    Next, Prior            Move vertically one screenful
    Sh-Next, Sh-Prior      Move screenful + extend selection
    C-v                    Move down one screenful without changing insertion point
    C-Next, C-Prior        Move horizontally one page without changing point
    Home, C-a              Move to beginning of line
    End, C-e               Move to end of line
    Sh-Home, Sh-End        Move to beginning or end of line + extend selection
    C-Home, M-<            Move to beginning of text
    C-Sh-Home              Move to beginning of text + extend selection
    C-End, M->             Move to end of text
    C-Sh-End               Move to end of text + extend selection
    C-Space                Set selection anchor
    C-Sh-Space             Select from anchor to insertion point
    C-/                    Select all text
    C-\                    Clear selection
    Del, C-d               Delete selection or one character
    Backspace, C-h         Delete selection or last character
    M-d                    Delete next word
    C-k                    Cut rest of line
    M-Backspace, M-Del     Delete previous word
    C-w                    Cut selection
    C-t                    Transpose characters
    C-z                    Undo
    C-Sh-z                 Redo
    C-+                    Increase font size
    C--                    Decrease font size
    Return                 Send selection or current line to forth and insert newline
    C-Up                   List previous block
    C-Down                 List next block
    Escape                 Terminate
    Tab                    Indent or tab
    Alt-w                  Copy current selection
    Insert                 Insert unicode codepoint (in hex, or named character)
    F1                     Show this text
    C-F1 ... C-F10         Bind function key to selected text
}
}


proc GetWord {} {
    set start [.t get "current linestart" current]
    set end [.t get current "current lineend"]

    if {[regexp -indices {(\S+)$} $start _ pos]} {
        set w0 [lindex $pos 0]
        
        if {[regexp -indices {^(\S+)} $end _ pos]} {
            set line [.t get "current linestart" "current lineend"]
            return [string range $line $w0 [expr [string length $start] + [lindex $pos 1]]]
        }

        return [string range $start $w0 [string length $start]]
    }

    if {[regexp {^(\S+)} $end _ word]} {
        return $word
    }
    
    return ""
}


proc SelectButton {} {
    SendForth "command [GetWord]"
}


proc SmartIndent {} {
    global tabwidth
    set pos [.t index insert]
    regexp {(\d+)\.(\d+)} $pos all row col

    if {$row > 1} {
	set rowup [expr $row - 1]
	set above [.t get $rowup.0 "$rowup.0 lineend"]
	set uplen [string length $above]

	if {$uplen > $col} {
	    set i $col
	    # first skip non-ws chars
	    while {$i < $uplen && [string index $above $i] != " "} {
		incr i
	    }

	    while {$i < $uplen} {
		if {[string index $above $i] != " "} {
		    Insert [string repeat " " [expr $i - $col]]
		    return
		}

		incr i
	    }
	}
    }
    
    set tcol [expr (($col / $tabwidth) + 1) * $tabwidth]
    Insert [string repeat " " [expr $tcol - $col]]
}


proc HoldMode {} {
    global hold_mode hold_start

    if {$hold_mode != 0} {
        set input [string trim [.t get $hold_start [.t index insert]]]
        set hold_mode 0
        .t configure -highlightthickness 0

        if {$input != ""} {
            Insert "\n"
            SendForth $input
        }
    } else {
        set hold_mode 1
        set hold_start [.t index insert]
        .t configure -highlightthickness 3
        .t configure -highlightcolor yellow
    }
}


proc EnterCodepoint {} {
    global snippets
    
    set key [string trim [EntryBox "Enter codepoint or name"]]

    if {$key != ""} {
        foreach c $snippets {
            if {[lindex $c 0] == $key} {
                Insert [lindex $c 1]
                return
            }
        }

        catch {
            scan $key "%x" code
            Insert [format "%c" $code]
        }
    }
}
        

text .t -wrap none -undo 1
pack .t -fill both -expand 1
#XXX does not work on Windows
focus .t

wm protocol . WM_DELETE_WINDOW Terminate

DefineKey <Control-plus> { ResizeFont 1 }
DefineKey <Control-minus> { ResizeFont -1 }

DefineKey <Escape> {
    if {$hold_mode} {
        set hold_mode 0
        .t configure -highlightthickness 0
    } else {
        Terminate
    }
}

DefineKey <Alt-w> { tk_textCopy .t }
DefineKey <Control-w> { tk_textCut .t }
DefineKey <Control-q> SaveFile 
DefineKey <Home> { Top; break }
DefineKey <End> { Bottom; break }

DefineKey <Control-k> { 
    KillLine
    break
}

DefineKey <Return> {
    ExecuteForth
}

DefineKey <Tab> { SmartIndent; break }
DefineKey <F1> { Help; break }

DefineKey <Control-Up> { SendForth "previous-screen"; break }
DefineKey <Control-Down> { SendForth "next-screen"; break }

bind .t <3> SelectButton

DefineKey <Insert> { 
    HoldMode
    break
}

DefineKey <Control-q> EnterCodepoint

DefineKey <F1> { FunctionKey 1; break }
DefineKey <F2> { FunctionKey 2; break }
DefineKey <F3> { FunctionKey 3; break }
DefineKey <F4> { FunctionKey 4; break }
DefineKey <F5> { FunctionKey 5; break }
DefineKey <F6> { FunctionKey 6; break }
DefineKey <F7> { FunctionKey 7; break }
DefineKey <F8> { FunctionKey 8; break }
DefineKey <F9> { FunctionKey 9; break }
DefineKey <F10> { FunctionKey 10; break }


if {[file exists $rcfile]} { source $rcfile }

for {set i 0} {$i < $argc} {incr i} {
    set arg [lindex $argv $i]

    switch -- $arg {
	"-background" { 
	    incr i
	    set current_background [lindex $argv $i]
	}
	"-foreground" { 
	    incr i
	    set current_foreground [lindex $argv $i]
	}
	"-fontname" { 
	    incr i
	    set current_font [lindex $argv $i]
	}
	"-fontsize" { 
	    incr i
	    set current_font_size [lindex $argv $i]
	}
	"-execute" {
	    incr i
	    source [lindex $argv $i]
	}
	"-init" {
	    incr i
	    set initcmd [lindex $argv $i]
	}
	"-image" {
	    incr i
	    set initcmd "load-image [lindex $argv $i]"
	}
	"-ff" {
	    incr i
	    set forth [lindex $argv $i]
	}
	"-cd" {
	    incr i
	    cd [lindex $argv $i]
	}
	"--" break
    }
}

ConfigureWindow
.t mark set insert 1.0
StartForth
