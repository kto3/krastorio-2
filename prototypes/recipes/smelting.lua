-- A RECIPE FOR STAY IN THIS FILE SHOULD HAVE THE ATTRIBUTE category = "smelting"
return
{
	{
		type = "recipe",
		name = "coke",
		category = "smelting",
		energy_required = 12,
		enabled = false,
		allow_productivity = true,
		ingredients =
		{
			{"coal", 4},
			{"wood", 4}
		},
		result = "coke",
		result_count = 4
	},
	{
		type = "recipe",
		name = "glass",
		category = "smelting",
		energy_required = 3,
		enabled = false,
		always_show_made_in = true,
		always_show_products = true,
		allow_productivity = true,
		ingredients =
		{
			{"sand", 3}
		},
		result = "glass",
		result_count = 1
	},
	{
		type = "recipe",
		name = "silicon",
		category = "smelting",
		energy_required = 6.4,
		enabled = false,
		always_show_made_in = true,
		always_show_products = true,
		allow_productivity = true,
		ingredients = 
		{
			{"quartz", 6}
		},
		result = "silicon",
		result_count = 3
    },
	{
		type = "recipe",
		name = "rare-metals",
		category = "smelting",
		subgroup = "raw-material",
		energy_required = 16,
		enabled = true,
		always_show_made_in = true,
		always_show_products = true,
		allow_productivity = true,
		ingredients = 
		{
			{"raw-rare-metals", 10}
		},
		result = "rare-metals",
		result_count = 5
    },
	{
		type = "recipe",
		name = "enriched-iron-plate",
		category = "smelting",
		energy_required = 16,
		enabled = false,
		always_show_made_in = true,
		always_show_products = true,
		allow_productivity = true,
		ingredients = 
		{
			{"enriched-iron", 5}
		},
		result = "iron-plate",
		result_count = 5
    },	
	{
		type = "recipe",
		name = "enriched-copper-plate",
		category = "smelting",
		energy_required = 16,
		enabled = false,
		always_show_made_in = true,
		always_show_products = true,
		allow_productivity = true,
		ingredients = 
		{
			{"enriched-copper", 5}
		},
		result = "copper-plate",
		result_count = 5 
    },
	{
		type = "recipe",
		name = "imersium-plate",
		category = "smelting",
		energy_required = 32,
		enabled = false,
		always_show_made_in = true,
		always_show_products = true,
		allow_productivity = true,
		ingredients = 
		{
			{"imersite-powder", 9},
			{"rare-metals", 6}
		},
		result = "imersium-plate",
		result_count = 3
    }
}