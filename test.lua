gScriptPath = getScriptPath()
dofile(gScriptPath .. "\\qlogger.lua")
dofile(gScriptPath .. "\\qcolors.lua")

logger = nil
function OnInit(name)
  logger = QLogger.new()
end
function main()
	logger:debug("test")
	logger:info("test")
	logger:error("test")
	logger:achtung("test")
	sleep(1000)
	logger:SetMaxRow(5)
	for i=1,10 do
		logger:info("i = " .. i)
		sleep(500)
	end

	sleep(1000)
	logger:SetMaxRow(3)
	for i=1,10 do
		logger:info("i = " .. i)
		sleep(500)
	end

	sleep(1000)
	logger:SetMaxRow(10)
	for i=1,10 do
		logger:info("i = " .. i)
		sleep(500)
	end

	sleep(1000)
	logger:SetMaxRow(4)
	for i=1,10 do
		logger:info("i = " .. i)
		sleep(500)
	end

	sleep(1000)
	logger:SetMaxRow(QLogger.INFINITE)
	for i=1,10 do
		logger:info("i = " .. i)
		sleep(500)
	end
end
