# mp-scripts

## hwscale.lua

Automatically use hardware video processor for scaling (vaapi and d3d11vpp).
The scaling factor is automatically adjusted based on window size.

On compatible hardware, the default setting achieves better scaling quality
compared to `profile=fast`, while having much lower power usage and faster
speed compared to shader-based scalers. It's recommended to use `profile=fast`
with this script to minimize power usage.

Advanced scaling methods, such as Nvidia VSR, can be set via the scaling
mode options.

This requires non-copyback hwdec to be enabled (e.g. `hwdec=auto-safe`).
Note that this script assumes that no other video filters are used, and will
set `auto-window-resize=no` since the source video size as seen by the VO is
changed after window resize, and the default auto resize behavior plays poorly
with this.
