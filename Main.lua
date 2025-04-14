local Rayfield = loadstring(game:HttpGet('https://[Log in to view URL]'))()

local Window = Rayfield:CreateWindow({
   Name = "Demon Blade Script",
   LoadingTitle = "Demons Hub",
   LoadingSubtitle = "by D3M0N",
   ConfigurationSaving = {
      Enabled = True,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "D3M0N Hub"
   },
   Discord = {
      Enabled = False,
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },
   KeySystem = true, -- Set this to true to use our key system
   KeySettings = {
      Title = "Demon blade | key ",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided",
      FileName = "Demon blade script key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = True, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = False, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"https://[Log in to view URL]"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})
