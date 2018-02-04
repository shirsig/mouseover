local mouseover

do
	local orig = GameTooltip.SetUnit
	function GameTooltip:SetUnit(unit)
		mouseover = unit
		return orig(self, unit)
	end
end

do
	local orig = GameTooltip.FadeOut
	function GameTooltip:FadeOut()
		mouseover = nil
		return orig(self)
	end
end

do
	local orig = GameTooltip.Hide
	function GameTooltip:Hide()
		mouseover = nil
		return orig(self)
	end
end

do
	local pass = function() end
	local orig = UseAction
	function UseAction(unit, clicked, onself)
		if mouseover and not strfind(mouseover, 'target') then
			local _PlaySound = PlaySound
			local target = UnitName'target'
			PlaySound = pass
			ClearTarget()
			PlaySound = _PlaySound
			do
				local autoSelfCast = GetCVar'autoSelfCast'
				SetCVar('autoSelfCast', nil)
				orig(unit, clicked, onself)
				SetCVar('autoSelfCast', autoSelfCast)
			end
			if SpellCanTargetUnit(mouseover) then
				SpellTargetUnit(mouseover)
			end
			if target then
				PlaySound = pass
				TargetLastTarget()
				PlaySound = _PlaySound
			end
		else
			orig(unit, clicked, onself)
		end
	end
end