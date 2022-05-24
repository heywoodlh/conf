-- Manipulate and get the status of Zoom mute/unmute, and show that status using the app AnyBar
-- Uses AnyBar to show zoom audio status (https://github.com/tonsky/AnyBar)
-- 
-- Takes one argument:
--   - toggle_zoom: Toggles the mute status and updates AnyBar red/green to reflect new status
--   - update_bar:  Grabs the current mute status and updates AnyBar
--
-- Anybar colors:
--   - Green: mic on
--   - Red: mic muted
--   - Hidden: No zoom meeting in progress
--

property btnTitleMute : "Mute audio"
property btnTitleUnMute : "Unmute audio"

on is_running(appName)
	tell application "System Events" to (name of processes) contains appName
end is_running

on set_indicator(indicatorColor)
	tell application "AnyBar" to set image name to indicatorColor
	-- display notification indicatorColor
end set_indicator

-- Return true if zoom meeting is active
on is_zoom_meeting_active()
	-- Is zoom even running?
	if not is_running("zoom.us") then
		return false
	end if
	
	tell application "System Events"
		tell application process "zoom.us"
			if exists (menu bar item "Meeting" of menu bar 1) then
				return true
			end if
			return false
		end tell
	end tell
end is_zoom_meeting_active

-- Return true/false if mic is active or not
on get_zoom_meeting_mic_on()
	if is_zoom_meeting_active() then
		tell application "System Events"
			tell application process "zoom.us"
				if exists (menu item btnTitleMute of menu 1 of menu bar item "Meeting" of menu bar 1) then
					return true
				end if
			end tell
		end tell
	end if
	return false
end get_zoom_meeting_mic_on


-- Update the status bar
on update_status_bar()
	if get_zoom_meeting_mic_on() then
		set_indicator("green")
	else
		set_indicator("red")
	end if
end update_status_bar

-- Toggle the audio state in zoom
on toggle_zoom_audio_state()
	if is_zoom_meeting_active() then
		tell application "System Events"
			tell application process "zoom.us"
				if my get_zoom_meeting_mic_on() then
					-- If unmuted, mute
					click menu item btnTitleMute of menu 1 of menu bar item "Meeting" of menu bar 1
					my set_indicator("red")
				else
					-- If unmuted, mute
					click menu item btnTitleUnMute of menu 1 of menu bar item "Meeting" of menu bar 1
					my set_indicator("green")
				end if
			end tell
		end tell
	end if
end toggle_zoom_audio_state

-- Entry point for script
on run argv
	-- If there is no zoom meeting, quit anybar (no indicator), and quit processing
	if not is_zoom_meeting_active() then
		tell application "AnyBar" to quit
		return
	end if
	
	if (count of argv) > 0 then
		set mode to item 1 of argv
		
		if mode is "toggle_zoom" then
			-- Change state of audio zoom (triggered from keybard shortcut)
			toggle_zoom_audio_state()
		else if mode is "update_bar" then
			-- Just update the menu bar (called via cron)
			update_status_bar()
		end if
	end if
end run
