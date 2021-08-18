local util = {}

-- TODO: Move these functions to another file?
local our_parts = {
  {
    name = "kr-crash-site-lab-repaired",
    angle_deviation = 0.05,
    max_distance = 30,
    min_separation = 10,
    fire_count = 3,
    explosion_count = 1
  },
  {
    name = "kr-crash-site-assembling-machine-1-repaired",
    repeat_count = 2,
    angle_deviation = 0.3,
    max_distance = 20,
    min_separation = 5,
    fire_count = 1
  },
  {
    name = "kr-crash-site-assembling-machine-2-repaired",
    repeat_count = 2,
    angle_deviation = 0.3,
    max_distance = 20,
    min_separation = 5,
    fire_count = 1
  },
  {
    name = "kr-crash-site-chest-1",
    repeat_count = 3,
    angle_deviation = 0.1,
    max_distance = 20,
    min_separation = 3,
    fire_count = 1
  },
  {
    name = "kr-crash-site-chest-2",
    repeat_count = 3,
    angle_deviation = 0.1,
    max_distance = 20,
    min_separation = 2,
    fire_count = 1
  },
  {
    name = "kr-mineable-wreckage",
    repeat_count = 9,
    angle_deviation = 0.8,
    max_distance = 10,
  },
}
function util.add_to_crash_site()
  if
    remote.interfaces["freeplay"]
    and not remote.call("freeplay", "get_disable_crashsite")
    and not remote.call("freeplay", "get_init_ran")
  then
    local ship_parts = remote.call("freeplay", "get_ship_parts")
    for _, part in pairs(our_parts) do
      ship_parts[#ship_parts + 1] = part
    end
    remote.call("freeplay", "set_ship_parts", ship_parts)
  end
end
function util.disable_rocket_victory()
  if remote.interfaces["silo_script"] then
    remote.call("silo_script", "set_no_victory", true)
  end
end

function util.ensure_turret_force()
  if not game.forces["kr-internal-turrets"] then
    game.create_force("kr-internal-turrets")
  end
end

function util.error_flying_text(player, text, options)
  options = options or {}
  player.create_local_flying_text{
    color = options.color,
    create_at_cursor = not options.position,
    position = options.position,
    text = text,
  }
  player.play_sound{path = "utility/cannot_build"}
end

return util
