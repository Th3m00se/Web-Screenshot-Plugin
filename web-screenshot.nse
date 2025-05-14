-- NSE Script to get a screenshot from the host using Selenium
description = [[
Gets a screenshot from the host using Selenium
]]

author = "Your Name"
license = "GPLv2"
categories = {"discovery", "safe"}

-- Updated the NSE Script imports and variable declarations
local shortport = require "shortport"
local stdnse = require "stdnse"

-- Define the port rule to target HTTP and HTTPS ports
portrule = function(host, port)
    return port.protocol == "tcp" and (port.number == 80 or port.number == 443) and port.state == "open"
end

action = function(host, port)
    -- Check to see if ssl is enabled, if it is, this will be set to "ssl"
    local ssl = port.version.service_tunnel

    -- The default URLs will start with http://
    local prefix = "http"

    -- If SSL is set on the port, switch the prefix to https
    if ssl == "ssl" then
        prefix = "https"
    end

    -- Construct the URL
    local url = prefix .. "://" .. host.ip .. ":" .. port.number

    -- Screenshots will be called screenshot-nmap-<IP>:<port>.png
    local filename = "screenshot-nmap-" .. host.ip .. "_" .. port.number .. ".png"

    -- Construct the command to call the Python script
    local cmd = "python3 screenshot_selenium.py " .. url .. " " .. filename .. " 2>&1"

    -- Execute the shell command
    local handle = io.popen(cmd)
    local output = handle:read("*a")
    handle:close()

    -- Trim whitespace from the output
    output = output:gsub("^%s+", ""):gsub("%s+$", "")

    -- If the output contains "Saved to", the command was successful
    local result = "failed (verify python3 and selenium are in your path)"

    if output:find("saved to") then
        result = output
    elseif output:find("Failed to take screenshot") then
        result = output
    -- else
    --     result = "Something went seriously wrong here..."
    end

    -- Return the output message
    return stdnse.format_output(true, result)
end
