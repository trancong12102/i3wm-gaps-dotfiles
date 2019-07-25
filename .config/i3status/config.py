from i3pystatus import Status

status = Status()

# Clock
status.register("clock",
	hints = {"markup": "pango"},
	format=[ '%a %b %-d %b %X', '%X' ],
)

# The battery monitor has many formatting options, see README for details

# This would look like this, when discharging (or charging)
# ↓14.22W 56.15% [77.81%] 2h:41m
# And like this if full:
# =14.22W 100.0% [91.21%]
#
# This would also display a desktop notification (via D-Bus) if the percentage
# goes below 5 percent while discharging. The block will also color RED.
# If you don't have a desktop notification demon yet, take a look at dunst:
#   http://www.knopwob.org/dunst/
status.register("battery",
    hints = {"markup": "pango"},
    format="{status}/{consumption:.2f}W {percentage:.2f}% [{percentage_design:.2f}%] {remaining:%E%hh:%Mm} ",
    alert=True,
    alert_percentage=5,
    status={
        "DIS": "↓",
        "CHR": "<span background='#ea8685' color='#ffffff'>↑</span>",
        "FULL": "=",
    },)

# This would look like this:
# Discharging 6h:51m
status.register("battery",
    format="{status} {remaining:%E%hh:%Mm}",
    alert=True,
    alert_percentage=5,
    status={
        "DIS":  "Discharging",
        "CHR":  "Charging",
        "FULL": "Bat full",
    },)

# CPU Usage
status.register("cpu_usage",
	hints = {"markup": "pango"},
	format="<span background='#ea8685' color='#ffffff'> CPU: {usage:02}% </span>",
	on_leftclick="tilix -e 'htop'",
)
status.run()
