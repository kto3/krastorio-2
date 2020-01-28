water_tile_type_names = { "water", "deepwater", "water-green", "deepwater-green", "water-shallow", "water-mud" }
default_transition_group_id = 0
water_transition_group_id = 1
out_of_map_transition_group_id = 2
patch_for_inner_corner_of_transition_between_transition =
{
  filename = "__base__/graphics/terrain/water-transitions/water-patch.png",
  width = 32,
  height = 32,
  hr_version =
  {
    filename = "__base__/graphics/terrain/water-transitions/hr-water-patch.png",
    scale = 0.5,
    width = 64,
    height = 64
  }
}

local function create_transition_to_out_of_map_from_template(normal_res_template_path, high_res_template_path, options)
  return make_out_of_map_transition_template
  (
    { "out-of-map" },
    normal_res_template_path,
    high_res_template_path,
    {
      o_transition_tall = false,
      side_count = 8,
      inner_corner_count = 4,
      outer_corner_count = 4,
      u_transition_count = 1,
      o_transition_count = 1,
      base = init_transition_between_transition_common_options()
    },
    options.has_base_layer == true,
    options.has_background == true,
    options.has_mask == true
  )
end


local function water_transition_template_with_effect(to_tiles, normal_res_transition, high_res_transition, options)
  return make_generic_transition_template(to_tiles, water_transition_group_id, nil, normal_res_transition, high_res_transition, options, true, false, true)
end

local ground_to_out_of_map_transition =
  create_transition_to_out_of_map_from_template("__base__/graphics/terrain/out-of-map-transition/out-of-map-transition.png",
                                                "__base__/graphics/terrain/out-of-map-transition/hr-out-of-map-transition.png",
                                                { has_base_layer = false, has_background = true, has_mask = true })
base_tile_transition_effect_maps = {}
local ttfxmaps = base_tile_transition_effect_maps


ttfxmaps.water_creep =
{
  filename_norm = "__base__/graphics/terrain/effect-maps/water-dirt-mask.png",
  filename_high = "__base__/graphics/terrain/effect-maps/hr-water-dirt-mask.png",
  count = 8,
  o_transition_tall = false,
  u_transition_count = 2,
  o_transition_count = 1,
}

ttfxmaps.water_creep_to_land =
{
  filename_norm = "__base__/graphics/terrain/effect-maps/water-dirt-to-land-mask.png",
  filename_high = "__base__/graphics/terrain/effect-maps/hr-water-dirt-to-land-mask.png",
  count = 3,
  u_transition_count = 1,
  o_transition_count = 0,
}

ttfxmaps.water_creep_to_out_of_map =
{
  filename_norm = "__base__/graphics/terrain/effect-maps/water-dirt-to-out-of-map-mask.png",
  filename_high = "__base__/graphics/terrain/effect-maps/hr-water-dirt-to-out-of-map-mask.png",
  count = 3,
  u_transition_count = 0,
  o_transition_count = 0,
}


-- ~~~CREEP


local creep_out_of_map_transition =
  make_generic_transition_template
  (
    nil,
    default_transition_group_id,
    out_of_map_transition_group_id,
    "__base__/graphics/terrain/out-of-map-transition/dirt-out-of-map-transition.png",
    "__base__/graphics/terrain/out-of-map-transition/hr-dirt-out-of-map-transition.png",
    {
      inner_corner_tall = true,
      inner_corner_count = 3,
      outer_corner_count = 3,
      side_count = 3,
      u_transition_count = 1,
      o_transition_count = 0,
      base = init_transition_between_transition_common_options()
    },
    false,
    true,
    true
  )


local creep_transitions =
{
  water_transition_template_with_effect
  (
      water_tile_type_names,
      "__base__/graphics/terrain/water-transitions/dark-dirt.png",
      "__base__/graphics/terrain/water-transitions/hr-dark-dirt.png",
      {
        effect_map = ttfxmaps.water_creep,
        o_transition_tall = false,
        u_transition_count = 2,
        o_transition_count = 4,
        side_count = 8,
        outer_corner_count = 8,
        inner_corner_count = 8
      }
  ),
  ground_to_out_of_map_transition
}

local creep_transitions_between_transitions =
{
  make_generic_transition_template --generic_transition_between_transitions_template
  (
      nil,
      default_transition_group_id,
      water_transition_group_id,
      "__base__/graphics/terrain/water-transitions/dark-dirt-transition.png",
      "__base__/graphics/terrain/water-transitions/hr-dark-dirt-transition.png",
      {
        effect_map = ttfxmaps.water_creep_to_land,
        o_transition_tall = false,
        inner_corner_count = 3,
        outer_corner_count = 3,
        side_count = 3,
        u_transition_count = 1,
        o_transition_count = 0,
        base = { water_patch = patch_for_inner_corner_of_transition_between_transition, }
      },
      true,
      false,
      true
  ),
  creep_out_of_map_transition,
  generic_transition_between_transitions_template
  (
      water_transition_group_id,
      out_of_map_transition_group_id,
      "__base__/graphics/terrain/out-of-map-transition/dark-dirt-shore-out-of-map-transition.png",
      "__base__/graphics/terrain/out-of-map-transition/hr-dark-dirt-shore-out-of-map-transition.png",
      {
        effect_map = ttfxmaps.water_creep_to_out_of_map,
        o_transition_tall = false,
        inner_corner_count = 3,
        outer_corner_count = 3,
        side_count = 3,
        u_transition_count = 1,
        o_transition_count = 0,
        base = init_transition_between_transition_water_out_of_map_options()
      }
  ),
}



data:extend(
{

	{	
		type = "tile",
		name = "kr-creep",
		needs_correction = false,
		minable = {mining_time = 1, result = "biomass", count = 10},
		mined_sound = { filename = kr_tiles_sounds_path .. "creep-deconstruction.ogg" },
		collision_mask = {"ground-tile"},
		walking_speed_modifier = 0.5,
		layer = 99,
		transition_overlay_layer_offset = 9,
		decorative_removal_probability = 1,
		variants =
		{
			main =
			{
				{
					picture = kr_tiles_path .. "creep/creep.png",
					count = 16,
					size = 4,
					hr_version =
					{
						picture = kr_tiles_path .. "creep/hr-creep.png",
						count = 16,
						scale = 0.5,
						size = 4
					}
				},
				{
					picture = kr_tiles_path .. "creep/creep.png",
					count = 16,
					size = 1,
					hr_version =
					{
						picture = kr_tiles_path .. "creep/hr-creep.png",
						count = 16,
						scale = 0.5,
						size = 1
					}
				},
			},
			inner_corner =
			{
				picture = kr_tiles_path .. "creep/creep-inner-corner.png",
				count = 4,
				tall = true,
				hr_version =
				{
					picture = kr_tiles_path .. "creep/hr-creep-inner-corner.png",
					count = 4,
					tall = true,
					scale = 0.5
				}
			},
			outer_corner =
			{
				picture = kr_tiles_path .. "creep/creep-outer-corner.png",
				count = 4,
				tall = true,
				hr_version =
				{
					picture = kr_tiles_path .. "creep/hr-creep-outer-corner.png",
					count = 4,
					tall = true,
					scale = 0.5
				}
			},
			side =
			{
				picture = kr_tiles_path .. "creep/creep-side.png",
				count = 16,
				tall = true,
				hr_version =
				{
					picture = kr_tiles_path .. "creep/hr-creep-side.png",
					count = 16,
					tall = true,
					scale = 0.5
				}
			},
			u_transition =
			{
				picture = kr_tiles_path .. "creep/creep-u.png",
				count = 2,
				tall = true,
				hr_version =
				{
					picture = kr_tiles_path .. "creep/hr-creep-u.png",
					count = 2,
					tall = true,
					scale = 0.5
				}
			},
			o_transition =
			{
				picture = kr_tiles_path .. "creep/creep-o.png",
				count = 2,
				hr_version =
				{
					picture = kr_tiles_path .. "creep/hr-creep-o.png",
					count = 2,
					scale = 0.5
				}
			}
		},
		walking_sound =
		{
			{
				filename = kr_tiles_sounds_path .. "creep-walk-01.ogg",
				volume = 0.75
			},
			{
				filename = kr_tiles_sounds_path .. "creep-walk-02.ogg",
				volume = 0.75
			},
			{
				filename = kr_tiles_sounds_path .. "creep-walk-03.ogg",
				volume = 0.75
			},
		},
		map_color={r=75, g=60, b=70},
		pollution_absorption_per_second = 0.01,
		vehicle_friction_modifier = 200,
		
		transitions = creep_transitions,
		transitions_between_transitions = creep_transitions_between_transitions,
		
	}
})