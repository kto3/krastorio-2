if settings.startup["loaders"] and settings.startup["loaders"].value then

	-- Variable utils
	local loader_names = 
	{
		[1] = "kr-loader",
		[2] = "kr-fast-loader",
		[3] = "kr-express-loader",
		[4] = "kr-superior-loader"
	}
	
	-- ITEMS

	function kr_loader_item(data)
		local name = data.name
		local subgroup = data.subgroup or "belt"
		local order = data.order	
		return 
		{
			type = "item",
			name = name,
			icon = kr_entities_icons_path .. "loaders/" .. name .. ".png",
			icon_size = 32,
			order = order,
			subgroup = subgroup,
			place_result = name,
			stack_size = 50
		}
	end

	local items = 
	{
		kr_loader_item
		{
			name = loader_names[1],
			order = "d[loader]-a1["..loader_names[1].."]",
		},
		kr_loader_item
		{
			name = loader_names[2],
			order = "d[loader]-a2["..loader_names[2].."]",
		},
		kr_loader_item
		{
			name = loader_names[3],
			order = "d[loader]-a3["..loader_names[3].."]",
		},
		--[[
		kr_loader_item
		{
			name = loader_names[4],
			order = "d[loader]-a4["..loader_names[4].."]",
		}
		--]]
	}
	data:extend(items)
	
end