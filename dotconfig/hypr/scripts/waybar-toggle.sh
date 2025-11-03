 #!/bin/bash                                                              10:30:14

  if pgrep -x "waybar" > /dev/null
      then
      pkill waybar
  else
      waybar &
      fi
