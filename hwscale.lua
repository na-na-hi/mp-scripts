local options = {
    enabled = true,
    vaapi_scaling_mode = "hq",
    d3d11vpp_scaling_mode = "standard",
}

local vaapi_template = "scale_vaapi:w=%d:h=%d:mode=%s:force_original_aspect_ratio=decrease:force_divisible_by=4"
local d3d11vpp_template = "d3d11vpp:scale=%g:scaling-mode=%s"

function on_resize(name)
    local hwdec = mp.get_property("hwdec-current")
    local osize = mp.get_property_native("osd-dimensions")
    local vsize = mp.get_property_native("video-params")
    if hwdec == "vaapi" and osize ~= nil then
        mp.set_property("vf", vaapi_template:format(osize.w, osize.h, options.vaapi_scaling_mode))
    elseif hwdec == "d3d11va" and osize ~= nil and vsize ~= nil then
        local scale = math.min(osize.w / vsize.dw, osize.h / vsize.dh)
        mp.set_property("vf", d3d11vpp_template:format(scale, options.d3d11vpp_scaling_mode))
    else
        mp.set_property("vf", "")
    end
end

function on_change(enabled)
    if enabled then
        mp.set_property("auto-window-resize", "no")
        mp.observe_property("osd-dimensions", "native", on_resize)
    else
        mp.unobserve_property(on_resize)
        mp.set_property("vf", "")
    end
end

require "mp.options".read_options(options, "hwscale", function (changed) 
    on_change(options.enabled)
end)

on_change(options.enabled)
