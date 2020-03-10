local cu = {}

cu.not_valid_replacers = 
{ 
	["kr-creep"] = true, 
	["water"] = true, 
	["deepwater"] = true, 
	["water-green"] = true, 
	["deepwater-green"] = true, 
	["water-shallow"] = true, 
	["water-mud"] = true, 
	["landfill"] = true, 
	["stone-path"] = true, 
	["concrete"] = true, 
	["hazard-concrete-left"] = true, 
	["hazard-concrete-right"] = true, 
	["refined-concrete"] = true, 
	["refined-hazard-concrete-left"] = true, 
	["refined-hazard-concrete-right"] = true, 	
	["kr-white-reinforced-plate"] = true, 
	["kr-black-reinforced-plate"] = true
}
if script.active_mods["Dectorio"] then
	local directions = 
	{
		{this="left", next="right"},
		{this="right", next="left"}
	}
	local paint_variants = 
	{
		{name="danger", color={r=0.81,g=0.31,b=0.31}},
		{name="emergency", color={r=0.86,g=0.36,b=0.38}},
		{name="caution", color={r=0.85,g=0.56,b=0.26}},
		{name="radiation", color={r=0.86,g=0.56,b=0.78}},
		{name="defect", color={r=0.47,g=0.50,b=1.00}},
		{name="operations", color={r=0.37,g=0.37,b=0.37}},
		{name="safety", color={r=0.61,g=0.77,b=0.40}}
	}
	for _, variant in pairs(paint_variants) do
		for _, direction in pairs(directions) do
			cu.not_valid_replacers["dect-paint-"..variant.name.."-"..direction.this] = true
			cu.not_valid_replacers["dect-paint-refined-"..variant.name.."-"..direction.this] = true
		end
	end
	if settings.startup["dectorio-concrete"] and settings.startup["dectorio-concrete"].value then
		cu.not_valid_replacers["dect-concrete-grid"] = true
	end
end

cu.random_generator = nil

-- Util function for calculate the round of number
function cu.round(num)
    return (num + 0.5 - (num + 0.5) % 1.0)
end

function cu.droppedBiomass()
	if not cu.random_generator or not cu.random_generator.valid then
		cu.random_generator = game.create_random_generator()
		math.randomseed(cu.random_generator())
	end
	return math.random(global.COLLECT_PROBABILITY, 100)
end

function cu.isTooDistantFromArea(position, area)
	local a, b = area.left_top or area[1], area.right_bottom or area[2]
	local area_min_pos = { x = math.min(a.x, b.x), y = math.min(a.y, b.y) }
	local area_max_pos = { x = math.max(a.x, b.x), y = math.max(a.y, b.y) }
	
	local delta_x = math.max(area_min_pos.x - position.x, 0, position.x - area_max_pos.x)
	local delta_y = math.max(area_min_pos.y - position.y, 0, position.y - area_max_pos.y)
	
	return math.sqrt(delta_x*delta_x + delta_y*delta_y) > global.MAX_TILE_DISTANCE
end

function cu.isInRange(char_pos, tile_pos)
	local delta_pos = {x = tile_pos.x - char_pos.x, y = tile_pos.y - char_pos.y}
	local vector_length = math.sqrt(delta_pos.x*delta_pos.x + delta_pos.y*delta_pos.y)	
	return vector_length <= global.MAX_TILE_DISTANCE
end

function cu.showDistanceErrorMessage(character)
	global.krastorio.flying_texts.showOnSurfaceText
	{
		entity = character,
		text   = {"other.kr-collect-distant-error"},
		color  = {1, 0, 0}
	}
end

function cu.showInventoryFullErrorMessage(character)
	global.krastorio.flying_texts.showOnSurfaceText
	{
		entity = character,
		text   = {"other.kr-player-inventory-full-error"},
		color  = {1, 0, 0}
	}
end

function cu.showCollectionBiomassCountMessage(character, percentage, num)
	global.krastorio.flying_texts.showOnSurfaceText
	{
		entity = character,
		text   = {"other.kr-collect-message-with-icon-prob", tostring(num), tostring(percentage), {"item-name.biomass"}, "biomass"},
		color  = {0.3, 1, 0.3}
	}
end

function cu.showCollectionCountMessage(character, num)
	global.krastorio.flying_texts.showOnSurfaceText
	{
		entity = character,
		text   = {"other.kr-collect-message", tostring(num), "tiles"},
		color  = {0.3, 1, 0.3}
	}
end

function cu.getNearestTileType(surface, area)
	local a, b = area.left_top or area[1], area.right_bottom or area[2]
	local mid_pos = {x = (a.x+b.x)/2,y = (a.y+b.y)/2}
	local delta_pos = {x = a.x - b.x, y = a.y - b.y}
	local vector_length = math.max(1, math.sqrt(delta_pos.x*delta_pos.x + delta_pos.y*delta_pos.y))
	local iteration = 0
	local tiles = nil
	local actual_radius = nil
	while iteration < 6 do
		actual_radius = vector_length*(iteration+10)
		tiles = surface.find_tiles_filtered
		{
			position = mid_pos,
			radius = math.min(50, actual_radius)
		}
		for _, tile in pairs(tiles) do
			if not cu.not_valid_replacers[tile.name] then
				return tile.name
			end
		end
		if actual_radius > 50 then
			break
		else
			iteration = iteration+1
		end
	end
	return "landfill"
end

function cu.playCollectCreepSound(player)
	player.play_sound
	{
		path            = "kr-collect-creep",
		position        = player.character.position,
		volume_modifier = 1.0
	}
end

function cu.playJackhammerSound(player)
	player.play_sound
	{
		path            = "kr-jackhammer",
		position        = player.character.position,
		volume_modifier = 1.0
	}
end

return cu