--[[--------------------------------------------------
quik logger (debug window)
Version: 1.0
mbul@arqa.ru
------------------------------------------------------
--]]--------------------------------------------------


QLogger ={}
QLogger.__index = QLogger
QLogger.INFINITE = -1

function QLogger.new()
  local t_id = AllocTable()
	if t_id ~= nil then
		q_table = {}
		setmetatable(q_table, QLogger)
		q_table.t_id=t_id
		q_table.caption = "QLogger"
		q_table.max_row=-1 -- -1 means infinity
		AddColumn(q_table.t_id, 1, "message type", true, QTABLE_CACHED_STRING_TYPE, 10)
		AddColumn(q_table.t_id, 2, "date", true, QTABLE_DATE_TYPE, 10)
		AddColumn(q_table.t_id, 3, "time", true, QTABLE_TIME_TYPE, 8)
		AddColumn(q_table.t_id, 4, "message", true, QTABLE_CACHED_STRING_TYPE, 1024)
		AddColumn(q_table.t_id, 5, "tags", true, QTABLE_CACHED_STRING_TYPE, 256)
		q_table:Show()
		return q_table
	else
		return nil
	end
end

function QLogger:Show()
	CreateWindow(self.t_id)
	if self.caption ~="" then
		SetWindowCaption(self.t_id, self.caption)
	end
end

function QLogger:SetMaxRow(amount)
	self.max_row = amount
	local rows_amount, _ = GetTableSize(self.t_id)
	if self.max_row ~=-1 and rows_amount >= self.max_row then
		for i=1,rows_amount-self.max_row do
			DeleteRow(self.t_id, 1)
		end
	end	
end


function QLogger:IsClosed()
	return IsWindowClosed(self.t_id)
end

function QLogger:delete()
	DestroyTable(self.t_id)
end

function QLogger:GetCaption()
	if IsWindowClosed(self.t_id) then
		return self.caption
	else
		return GetWindowCaption(self.t_id)
	end
end

function QLogger:SetCaption(s)
	self.caption = s
	if not IsWindowClosed(self.t_id) then
		res = SetWindowCaption(self.t_id, tostring(s))
	end
end


function QLogger:Clear()
	Clear(self.t_id)
end

function QLogger:msg(severity, msg, tag)
	tag = tag or ""
	local rows_amount, _ = GetTableSize(self.t_id)

	if self.max_row ~=-1 and rows_amount >= self.max_row then
		DeleteRow(self.t_id, 1)
	end

	local row = InsertRow(self.t_id, -1)
	local _t = os.date("*t")
	local _d = _t.year*10000 + _t.month*100 + _t.day
	local _time = _t.hour*10000 + _t.min*100 + _t.sec
	SetCell(self.t_id, row, 1, severity) -- severity
	SetCell(self.t_id, row, 2, string.format("%4d.%02d.%02d", _t.year, _t.month, _t.day), _d) -- date
	SetCell(self.t_id, row, 3, string.format("%02d:%02d:%02d", _t.hour, _t.min, _t.sec), _time) -- time
	SetCell(self.t_id, row, 4, tostring(msg)) -- msg
	SetCell(self.t_id, row, 5, tostring(tag)) -- tag
	return row
end

function QLogger:debug(msg, tag)
	local row = self:msg("DEBUG", msg, tag)
	SetColor(self.t_id, row, QTABLE_NO_INDEX, RGB(11, 27, 59), RGB(255,255,224), QTABLE_DEFAULT_COLOR, QTABLE_DEFAULT_COLOR)
end
function QLogger:info(msg, tag)
	local row = self:msg("INFO", msg, tag)
	SetColor(self.t_id, row, QTABLE_NO_INDEX, RGB(11, 27, 59), RGB(4, 215, 243), QTABLE_DEFAULT_COLOR, QTABLE_DEFAULT_COLOR)
end
function QLogger:error(msg, tag)
	local row = self:msg("ERROR", msg, tag)
	SetColor(self.t_id, row, QTABLE_NO_INDEX, RGB(11, 27, 59), RGB(255,160,122), QTABLE_DEFAULT_COLOR, QTABLE_DEFAULT_COLOR)
end
function QLogger:achtung(msg, tag)
	local row = self:msg("ACHTUNG", msg, tag)
	SetColor(self.t_id, row, QTABLE_NO_INDEX, RGB(11, 27, 59), RGB(255, 0, 0), QTABLE_DEFAULT_COLOR, QTABLE_DEFAULT_COLOR)
end
