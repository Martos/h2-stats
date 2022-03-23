function formatDate(data)
    local seconds = data

    if seconds <= 0 then
        data = "00:00:00";
    else
      hours = string.format("%02.f", math.floor(seconds/3600));
      mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
      secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60));
      
      data = string.format("%02d:%02d:%02d", hours, mins, secs)
    end

    return data
end