tell application "Terminal"
    repeat with w from 1 to count windows
        repeat with t from 1 to count tabs of window w
            if processes of tab t of window w contains "PROD" then
                set current settings of tab t of window w to (first settings set whose name is "Homebrew")
            else
                set current settings of tab t of window w to (first settings set whose name is "Ocean")
            end if
        end repeat
    end repeat
end tell

