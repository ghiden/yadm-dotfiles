-- Duplicate Browser Tab
-- Bind CMD + OPT + "=" to duplicate the current browser tab
hs.hotkey.bind({"cmd", "alt"}, "=", function()
  local app = hs.application.frontmostApplication()
  local appName = app:name()
  local duplicated = false

  if appName == "Safari" then
    -- Safari keeps this under the "Window" menu
    duplicated = app:selectMenuItem({"Window", "Duplicate Tab"})
  elseif appName == "Google Chrome" or appName == "Brave Browser" then
    -- Chrome and Brave keep this under the "Tab" menu
    duplicated = app:selectMenuItem({"Tab", "Duplicate tab"})
  elseif appName == "Firefox" then
    -- Firefox lacks a top menu bar item for duplicating tabs, so we simulate keystrokes
    hs.eventtap.keyStroke({"cmd"}, "l")
    hs.timer.usleep(50000)
    hs.eventtap.keyStroke({"alt"}, "return")
    duplicated = true
  end

  -- Show an alert if the action was successfully triggered
  if duplicated then
    hs.alert.show("Tab Duplicated: " .. appName)
  else
    -- Optional alert in case the native menu option is grayed out (e.g., no window open)
    hs.alert.show("Failed to duplicate tab")
  end
end)


-- Text-to-speech
-- Initialize the speech synthesizer
local talker = hs.speech.new()

-- Play / Pause / Resume hotkey (Cmd + Option + S)
hs.hotkey.bind({"cmd", "alt"}, "s", function()
  -- 1. If it is currently paused, resume speaking
  if talker:isPaused() then
    talker:continue()
    hs.alert.show("Speech Resumed")
    return
  end

  -- 2. If it is currently speaking, pause it
  if talker:isSpeaking() then
    talker:pause()
    hs.alert.show("Speech Paused")
    return
  end

  -- 3. If neither paused nor speaking, grab new text and start
  local currentClipboard = hs.pasteboard.getContents()
  hs.eventtap.keyStroke({"cmd"}, "c")

  hs.timer.doAfter(0.1, function()
    local selectedText = hs.pasteboard.getContents()

    if selectedText and selectedText ~= "" then
        hs.alert.show("Reading text...")
        talker:speak(selectedText)
    else
        hs.alert.show("No text selected to speak.")
    end

    if currentClipboard then
        hs.pasteboard.setContents(currentClipboard)
    else
        hs.pasteboard.clearContents()
    end
  end)
end)

-- Stop and Reset hotkey (Cmd + Option + Q)
hs.hotkey.bind({"cmd", "alt"}, "q", function()
  if talker:isSpeaking() or talker:isPaused() then
    talker:stop()
    hs.alert.show("Speech Stopped & Reset")
  end
end)

