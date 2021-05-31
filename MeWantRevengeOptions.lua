--[[
    MeWantRevengeOptions.lua

    Description:
    Most of the commands implemented for MeWantRevenge are for testing purposes.

    Maybe some useful user-oriented commands will be added in the future.
]]

local SM = LibStub:GetLibrary("LibSharedMedia-3.0")
local HBD = LibStub("HereBeDragons-2.0")
local HBDP = LibStub("HereBeDragons-Pins-2.0")
local AceLocale = LibStub("AceLocale-3.0")
local L = AceLocale:GetLocale("MeWantRevenge")
local fonts = SM:List("font")
local _

MeWantRevenge = LibStub("AceAddon-3.0"):NewAddon("MeWantRevenge", "AceConsole-3.0", "AceEvent-3.0", "AceComm-3.0", "AceTimer-3.0")
MeWantRevenge.Version = "1.1.2"
MeWantRevenge.DatabaseVersion = "1.1"
MeWantRevenge.Signature = "[MeWantRevenge]"
MeWantRevenge.ButtonLimit = 15
MeWantRevenge.MaximumPlayerLevel = MAX_PLAYER_LEVEL_TABLE[GetExpansionLevel()]
MeWantRevenge.MapNoteLimit = 20
MeWantRevenge.MapProximityThreshold = 0.02
MeWantRevenge.CurrentMapNote = 1
MeWantRevenge.ZoneID = {}
MeWantRevenge.KOSGuild = {}
MeWantRevenge.CurrentList = {}
MeWantRevenge.NearbyList = {}
MeWantRevenge.LastHourList = {}
MeWantRevenge.ActiveList = {}
MeWantRevenge.InactiveList = {}
MeWantRevenge.PlayerCommList = {}
MeWantRevenge.ListAmountDisplayed = 0
MeWantRevenge.ButtonName = {}
MeWantRevenge.EnabledInZone = false
MeWantRevenge.InInstance = false
MeWantRevenge.AlertType = nil
MeWantRevenge.UpgradeMessageSent = false
MeWantRevenge.zName = ""
MeWantRevenge.ChnlTime = 0
MeWantRevenge.Skull = -1
MeWantRevenge.PetGUID = {}

-- Localizations for MeWantRevengeStats
L_STATS = "MeWantRevenge "..L["Statistics"]
L_WON = L["Won"]
L_LOST = L["Lost"]
L_REASON = L["Reason"]
L_LIST = L["List"]
L_TIME = L["Time"]
L_FILTER = L["Filter"]..":"
L_SHOWONLY = L["Show Only"]..":"

MeWantRevenge.options = {
	name = L["MeWantRevenge"],
	type = "group",
	args = {
		About = {
			name = L["About"],
			desc = L["About"],
			type = "group",
			order = 1,
			args = {
				intro1 = {
					name = L["MeWantRevengeDescription1"],
					type = "description",
					order = 1,
					fontSize = "medium",					
				},	
				intro2 = {
					name = L["MeWantRevengeDescription2"],
					type = "description",
					order = 6,
					fontSize = "medium",
				},				
			}, 	
		},
		General = {
			name = L["GeneralSettings"],
			desc = L["GeneralSettings"],
			type = "group",
			order = 1,
			args = {
				intro = {
					name = L["GeneralSettingsDescription"],
					type = "description",
					order = 1,
					fontSize = "medium",					
				},
				EnabledInBattlegrounds = {
					name = L["EnabledInBattlegrounds"],
					desc = L["EnabledInBattlegroundsDescription"],
					type = "toggle",
					order = 2,
					width = "full",
					get = function(info)
						return MeWantRevenge.db.profile.EnabledInBattlegrounds
					end,
					set = function(info, value)
						MeWantRevenge.db.profile.EnabledInBattlegrounds = value
						MeWantRevenge:ZoneChangedEvent()
					end,
				},
				EnabledInArenas = {
					name = L["EnabledInArenas"],
					desc = L["EnabledInArenasDescription"],
					type = "toggle",
					order = 3,
					width = "full",
					get = function(info)
						return MeWantRevenge.db.profile.EnabledInArenas
					end,
					set = function(info, value)
						MeWantRevenge.db.profile.EnabledInArenas = value
						MeWantRevenge:ZoneChangedEvent()
					end,
				},
--[[				EnabledInWintergrasp = {
					name = L["EnabledInWintergrasp"],
					desc = L["EnabledInWintergraspDescription"],
					type = "toggle",
					order = 4,
					width = "full",
					get = function(info)
						return MeWantRevenge.db.profile.EnabledInWintergrasp
					end,
					set = function(info, value)
						MeWantRevenge.db.profile.EnabledInWintergrasp = value
						MeWantRevenge:ZoneChangedEvent()
					end,
				}, ]]--
				DisableWhenPVPUnflagged = {
					name = L["DisableWhenPVPUnflagged"],
					desc = L["DisableWhenPVPUnflaggedDescription"],
					type = "toggle",
					order = 5,
					width = "full",
					get = function(info)
						return MeWantRevenge.db.profile.DisableWhenPVPUnflagged
					end,
					set = function(info, value)
						MeWantRevenge.db.profile.DisableWhenPVPUnflagged = value
						MeWantRevenge:ZoneChangedEvent()
					end,
				},
				DisabledInZones = {
					name = L["DisabledInZones"],
					desc = L["DisabledInZonesDescription"],
					type = "multiselect",
					order = 6,					
					get = function(info, key) 
						return MeWantRevenge.db.profile.FilteredZones[key] 
					end,
					set = function(info, key, value) 
						MeWantRevenge.db.profile.FilteredZones[key] = value 
					end,
					values = {
						["Booty Bay"] = L["Booty Bay"],
						["Everlook"] = L["Everlook"],						
						["Gadgetzan"] = L["Gadgetzan"],
						["Ratchet"] = L["Ratchet"],
						["The Salty Sailor Tavern"] = L["The Salty Sailor Tavern"],
						["Shattrath City"] = L["Shattrath City"],
						["Area 52"] = L["Area 52"],
--						["Dalaran"] = L["Dalaran"],
--						["Dalaran (Northrend)"] = L["Dalaran (Northrend)"],
--						["Bogpaddle"] = L["Bogpaddle"],
--						["The Vindicaar"] = L["The Vindicaar"],
--						["Krasus' Landing"] = L["Krasus' Landing"],
--						["The Violet Gate"] = L["The Violet Gate"],		
--						["Magni's Encampment"] = L["Magni's Encampment"],
					},
				},
				ShowOnDetection = {
					name = L["ShowOnDetection"],
					desc = L["ShowOnDetectionDescription"],
					type = "toggle",
					order = 7,
					width = "full",
					get = function(info)
						return MeWantRevenge.db.profile.ShowOnDetection
					end,
					set = function(info, value)
						MeWantRevenge.db.profile.ShowOnDetection = value
					end,
				},
				HideMeWantRevenge = {
					name = L["HideMeWantRevenge"],
					desc = L["HideMeWantRevengeDescription"],
					type = "toggle",
					order = 8,
					width = "full",
					get = function(info)
						return MeWantRevenge.db.profile.HideMeWantRevenge
					end,
					set = function(info, value)
						MeWantRevenge.db.profile.HideMeWantRevenge = value
						if MeWantRevenge.db.profile.HideMeWantRevenge and MeWantRevenge:GetNearbyListSize() == 0 then
							MeWantRevenge.MainWindow:Hide()
						end
					end,
				},
--[[				ShowOnlyPvPFlagged = {
					name = L["ShowOnlyPvPFlagged"],
					desc = L["ShowOnlyPvPFlaggedDescription"],
					type = "toggle",
					order = 4,
					width = "full",
					get = function(info)
						return MeWantRevenge.db.profile.ShowOnlyPvPFlagged
					end,
					set = function(info, value)
						MeWantRevenge.db.profile.ShowOnlyPvPFlagged = value
					end,
				},	]]--
				ShowKoSButton = {
					name = L["ShowKoSButton"],
					desc = L["ShowKoSButtonDescription"],
					type = "toggle",
					order = 9,
					width = "full",
					get = function(info)
						return MeWantRevenge.db.profile.ShowKoSButton
					end,
					set = function(info, value)
						MeWantRevenge.db.profile.ShowKoSButton = value
					end,
				},
			},
		},
		DisplayOptions = {
			name = L["DisplayOptions"],
			desc = L["DisplayOptions"],
			type = "group",
			order = 2,
			args = {
				intro = {
					name = L["DisplayOptionsDescription"],
					type = "description",
					order = 1,
					fontSize = "medium",
				},
				ShowNearbyList = {
					name = L["ShowNearbyList"],
					desc = L["ShowNearbyListDescription"],
					type = "toggle",
					order = 2,
					width = "full",
					get = function(info)
						return MeWantRevenge.db.profile.ShowNearbyList
					end,
					set = function(info, value)
						MeWantRevenge.db.profile.ShowNearbyList = value
					end,
				},
				PrioritiseKoS = {
					name = L["PrioritiseKoS"],
					desc = L["PrioritiseKoSDescription"],
					type = "toggle",
					order = 3,
					width = "full",
					get = function(info)
						return MeWantRevenge.db.profile.PrioritiseKoS
					end,
					set = function(info, value)
						MeWantRevenge.db.profile.PrioritiseKoS = value
					end,
				},
				Alpha = {
					name = L["Alpha"],
					desc = L["AlphaDescription"],
					type = "range",
					order = 4,
--					width = "double",					
					min = 0, max = 1, step = 0.01,
					isPercent = true,
					get = function()
						return MeWantRevenge.db.profile.MainWindow.Alpha end,
					set = function(info, value)
						MeWantRevenge.db.profile.MainWindow.Alpha = value
						MeWantRevenge:UpdateMainWindow()

					end,
				},
				AlphaBG = {
					name = L["AlphaBG"],
					desc = L["AlphaBGDescription"],
					type = "range",
					order = 5,
--					width = "double",					
					min = 0, max = 1, step = 0.01,
					isPercent = true,
					get = function()
						return MeWantRevenge.db.profile.MainWindow.AlphaBG end,
					set = function(info, value)
						MeWantRevenge.db.profile.MainWindow.AlphaBG = value
						MeWantRevenge:UpdateMainWindow()
					end,
				},
				Lock = {
					name = L["LockMeWantRevenge"],
					desc = L["LockMeWantRevengeDescription"],
					type = "toggle",
					order = 6,
					width = 1.6,
					get = function(info) 
						return MeWantRevenge.db.profile.Locked
					end,
					set = function(info, value)
						MeWantRevenge.db.profile.Locked = value
						MeWantRevenge:LockWindows(value)
						MeWantRevenge:RefreshCurrentList()						
					end,
				},
				ClampToScreen = {
					name = L["ClampToScreen"],
					desc = L["ClampToScreenDescription"],				
					type = "toggle",
					order = 7,
--					width = "double",					
					get = function(info) 
						return MeWantRevenge.db.profile.ClampToScreen
					end,					
					set = function(info, value)
						MeWantRevenge.db.profile.ClampToScreen = value
						MeWantRevenge:ClampToScreen(value)
					end,
				},
				InvertMeWantRevenge = {
					name = L["InvertMeWantRevenge"],
					desc = L["InvertMeWantRevengeDescription"],
					type = "toggle",
					order = 8,
					get = function(info)
						return MeWantRevenge.db.profile.InvertMeWantRevenge
					end,
					set = function(info, value)
						MeWantRevenge.db.profile.InvertMeWantRevenge = value
					end,
				},
				[L["Reload"]] = {
					name = L["Reload"],
					desc = L["ReloadDescription"],
					type = 'execute',
					order = 9,					
					width = .6,					
					func = function()
						C_UI.Reload()
					end
				},				
				ResizeMeWantRevenge = {
					name = L["ResizeMeWantRevenge"],
					desc = L["ResizeMeWantRevengeDescription"],
					type = "toggle",
					order = 10,
					width = "full",
					get = function(info)
						return MeWantRevenge.db.profile.ResizeMeWantRevenge
					end,
					set = function(info, value)
						MeWantRevenge.db.profile.ResizeMeWantRevenge = value
						if value then MeWantRevenge:RefreshCurrentList() end
					end,
				},
				ResizeMeWantRevengeLimit = {  
					type = "range",
					order = 11,
					name = L["ResizeMeWantRevengeLimit"],
					desc = L["ResizeMeWantRevengeLimitDescription"],
					min = 1, max = 15, step = 1,
					get = function() return MeWantRevenge.db.profile.ResizeMeWantRevengeLimit end,
					set = function(info, value)
						MeWantRevenge.db.profile.ResizeMeWantRevengeLimit = value
						if value then 
							MeWantRevenge:ResizeMainWindow()
							MeWantRevenge:RefreshCurrentList() 
						end	
					end,
				},
				DisplayListData = {
					name = L["DisplayListData"],
					type = 'select',
					order = 12,
					values = {
						["NameLevelClass"] = L["Name"].." / "..L["Level"].." / "..L["Class"],
						["NameLevelOnly"] = L["Name"].." / "..L["Level"],
						["NameGuild"] = L["Name"].." / "..L["Guild"],
						["NameOnly"] = L["Name"],
					},					
					get = function()
						return MeWantRevenge.db.profile.DisplayListData
					end,
					set = function(info, value)
						MeWantRevenge.db.profile.DisplayListData = value
						MeWantRevenge:RefreshCurrentList() 
					end,
				},
				SelectFont = {
					type = "select",
					order = 13,
					name = L["SelectFont"],
					desc = L["SelectFontDescription"],
					values = fonts,
					get = function()
						for info, value in next, fonts do
							if value == MeWantRevenge.db.profile.Font then
								return info
							end
						end
					end,
					set = function(_, value)
						MeWantRevenge.db.profile.Font = fonts[value]
						if value then
							MeWantRevenge:UpdateBarTextures()
						end
					end,
				},
				RowHeight = {
					type = "range",
					order = 14,
					name = L["RowHeight"], 
					desc = L["RowHeightDescription"], 
					min = 8, max = 20, step = 1,
					get = function()
						return MeWantRevenge.db.profile.MainWindow.RowHeight
					end,
					set = function(info, value)
						MeWantRevenge.db.profile.MainWindow.RowHeight = value
						if value then
							MeWantRevenge:BarsChanged()
						end
					end,
				},
				BarTexture = {
					type = "select",				
					order = 15,
					name = L["Texture"],	
					desc = L["TextureDescription"],	
					dialogControl = "LSM30_Statusbar",					
					width = "double",
					values = SM:HashTable("statusbar"),
					get = function()
						return MeWantRevenge.db.profile.BarTexture
					end,
					set = function(_, key)
						MeWantRevenge.db.profile.BarTexture = key
						MeWantRevenge:UpdateBarTextures()
					end,
				},
				DisplayTooltipNearMeWantRevengeWindow = {
					name = L["DisplayTooltipNearMeWantRevengeWindow"],
					desc = L["DisplayTooltipNearMeWantRevengeWindowDescription"],
					type = "toggle",
					order = 16,
					width = "full",
					get = function(info)
						return MeWantRevenge.db.profile.DisplayTooltipNearMeWantRevengeWindow
					end,
					set = function(info, value)
						MeWantRevenge.db.profile.DisplayTooltipNearMeWantRevengeWindow = value
					end,
				},	
				SelectTooltipAnchor = {
					type = "select",
					order = 17,
					name = L["SelectTooltipAnchor"],
					desc = L["SelectTooltipAnchorDescription"],
					values = { 
						["ANCHOR_CURSOR"] = L["ANCHOR_CURSOR"],
						["ANCHOR_TOP"] = L["ANCHOR_TOP"],
						["ANCHOR_BOTTOM"] = L["ANCHOR_BOTTOM"],
						["ANCHOR_LEFT"] = L["ANCHOR_LEFT"],						
						["ANCHOR_RIGHT"] = L["ANCHOR_RIGHT"], 
					},
					get = function()
						return MeWantRevenge.db.profile.TooltipAnchor
					end,
					set = function(info, value)
						MeWantRevenge.db.profile.TooltipAnchor = value
					end,
				},				
				DisplayWinLossStatistics = {
					name = L["TooltipDisplayWinLoss"],
					desc = L["TooltipDisplayWinLossDescription"],
					type = "toggle",
					order = 18,
					width = "full",
					get = function(info)
						return MeWantRevenge.db.profile.DisplayWinLossStatistics
					end,
					set = function(info, value)
						MeWantRevenge.db.profile.DisplayWinLossStatistics = value
					end,
				},
				DisplayKOSReason = {
					name = L["TooltipDisplayKOSReason"],
					desc = L["TooltipDisplayKOSReasonDescription"],
					type = "toggle",
					order = 19,
					width = "full",
					get = function(info)
						return MeWantRevenge.db.profile.DisplayKOSReason
					end,
					set = function(info, value)
						MeWantRevenge.db.profile.DisplayKOSReason = value
					end,
				},
				DisplayLastSeen = {
					name = L["TooltipDisplayLastSeen"],
					desc = L["TooltipDisplayLastSeenDescription"],
					type = "toggle",
					order = 20,
					width = "full",
					get = function(info)
						return MeWantRevenge.db.profile.DisplayLastSeen
					end,
					set = function(info, value)
						MeWantRevenge.db.profile.DisplayLastSeen = value
					end,
				},
			},					
		},
		AlertOptions = {
			name = L["AlertOptions"],
			desc = L["AlertOptions"],
			type = "group",
			order = 3,
			args = {
				intro = {
					name = L["AlertOptionsDescription"],
					type = "description",
					order = 1,
					fontSize = "medium",
				},
				EnableSound = {
					name = L["EnableSound"],
					desc = L["EnableSoundDescription"],
					type = "toggle",
					order = 2,
					width = "full",
					get = function(info)
						return MeWantRevenge.db.profile.EnableSound
					end,
					set = function(info, value)
						MeWantRevenge.db.profile.EnableSound = value
					end,
				},
				SoundChannel = {
					name = L["SoundChannel"],
					type = 'select',
					order = 3,
					values = {
						["Master"] = L["Master"],
						["SFX"] = L["SFX"],
						["Music"] = L["Music"],
						["Ambience"] = L["Ambience"],					
					},					
					get = function()
						return MeWantRevenge.db.profile.SoundChannel
					end,
					set = function(info, value)
						MeWantRevenge.db.profile.SoundChannel = value 
					end,
				},
				OnlySoundKoS = {
					name = L["OnlySoundKoS"],
					desc = L["OnlySoundKoSDescription"],
					type = "toggle",
					order = 4,
					width = "full",
					get = function(info)
						return MeWantRevenge.db.profile.OnlySoundKoS
					end,
					set = function(info, value)
						MeWantRevenge.db.profile.OnlySoundKoS = value
					end,
				},
				StopAlertsOnTaxi = {
					name = L["StopAlertsOnTaxi"],
					desc = L["StopAlertsOnTaxiDescription"],
					type = "toggle",
					order = 5,
					width = "full",
					get = function(info)
						return MeWantRevenge.db.profile.StopAlertsOnTaxi
					end,
					set = function(info, value)
						MeWantRevenge.db.profile.StopAlertsOnTaxi = value
					end,
				},
				Announce = {
					name = L["Announce"],
					type = "group",
					order = 6,
					inline = true,
					args = {
						None = {
							name = L["None"],
							desc = L["NoneDescription"],
							type = "toggle",
							order = 1,
							get = function(info)
								return MeWantRevenge.db.profile.Announce == "None"
							end,
							set = function(info, value)
								MeWantRevenge.db.profile.Announce = "None"
							end,
						},
						Self = {
							name = L["Self"],
							desc = L["SelfDescription"],
							type = "toggle",
							order = 2,
							get = function(info)
								return MeWantRevenge.db.profile.Announce == "Self"
							end,
							set = function(info, value)
								MeWantRevenge.db.profile.Announce = "Self"
							end,
						},
						Party = {
							name = L["Party"],
							desc = L["PartyDescription"],
							type = "toggle",
							order = 3,
							get = function(info)
								return MeWantRevenge.db.profile.Announce == "Party"
							end,
							set = function(info, value)
								MeWantRevenge.db.profile.Announce = "Party"
							end,
						},
						Guild = {
							name = L["Guild"],
							desc = L["GuildDescription"],
							type = "toggle",
							order = 4,
							get = function(info)
								return MeWantRevenge.db.profile.Announce == "Guild"
							end,
							set = function(info, value)
								MeWantRevenge.db.profile.Announce = "Guild"
							end,
						},
						Raid = {
							name = L["Raid"],
							desc = L["RaidDescription"],
							type = "toggle",
							order = 5,
							get = function(info)
								return MeWantRevenge.db.profile.Announce == "Raid"
							end,
							set = function(info, value)
								MeWantRevenge.db.profile.Announce = "Raid"
							end,
						},
					},
				},
				OnlyAnnounceKoS = {
					name = L["OnlyAnnounceKoS"],
					desc = L["OnlyAnnounceKoSDescription"],
					type = "toggle",
					order = 7,
					width = "full",
					get = function(info)
						return MeWantRevenge.db.profile.OnlyAnnounceKoS
					end,
					set = function(info, value)
						MeWantRevenge.db.profile.OnlyAnnounceKoS = value
					end,
				},
				DisplayWarnings = {
					name = L["DisplayWarnings"],
					type = 'select',
					order = 8,
					values = {
						["Default"] = L["Default"],
						["ErrorFrame"] = L["ErrorFrame"],
						["Moveable"] = L["Moveable"],
					},					
					get = function()
						return MeWantRevenge.db.profile.DisplayWarnings
					end,
					set = function(info, value)
						MeWantRevenge.db.profile.DisplayWarnings = value
						MeWantRevenge:UpdateAlertWindow()
					end,
				},
				WarnOnStealth = {
					name = L["WarnOnStealth"],
					desc = L["WarnOnStealthDescription"],
					type = "toggle",
					order = 9,
					width = "full",
					get = function(info)
						return MeWantRevenge.db.profile.WarnOnStealth
					end,
					set = function(info, value)
						MeWantRevenge.db.profile.WarnOnStealth = value
					end,
				},
				WarnOnKOS = {
					name = L["WarnOnKOS"],
					desc = L["WarnOnKOSDescription"],
					type = "toggle",
					order = 10,
					width = "full",
					get = function(info)
						return MeWantRevenge.db.profile.WarnOnKOS
					end,
					set = function(info, value)
						MeWantRevenge.db.profile.WarnOnKOS = value
					end,
				},
				WarnOnKOSGuild = {
					name = L["WarnOnKOSGuild"],
					desc = L["WarnOnKOSGuildDescription"],
					type = "toggle",
					order = 11,
					width = "full",
					get = function(info)
						return MeWantRevenge.db.profile.WarnOnKOSGuild
					end,
					set = function(info, value)
						MeWantRevenge.db.profile.WarnOnKOSGuild = value
					end,
				},
				WarnOnRace = {
					name = L["WarnOnRace"],
					desc = L["WarnOnRaceDescription"],
					type = "toggle",
					order = 12,
					width = "full",
					get = function(info)
						return MeWantRevenge.db.profile.WarnOnRace
					end,
					set = function(info, value)
						MeWantRevenge.db.profile.WarnOnRace = value
					end,
				},
				SelectWarnRace = {
					type = "select",
					order = 13,
					name = L["SelectWarnRace"],
					desc = L["SelectWarnRaceDescription"],
					get = function()
						return MeWantRevenge.db.profile.SelectWarnRace
					end,
					set = function(info, value)
						MeWantRevenge.db.profile.SelectWarnRace = value
					end,
					values = function()
						local raceOptions = {}
						local races = {
							Alliance = {
								["None"] = L["None"],
								["Human"] = L["Human"],	
								["Dwarf"] = L["Dwarf"],		
								["Night Elf"] = L["Night Elf"],			
								["Gnome"] = L["Gnome"],	
--								["Draenei"] = L["Draenei"],
--								["Worgen"] = L["Worgen"],
--								["Pandaren"] = L["Pandaren"],	
--								["Lightforged Draenei"] = L["Lightforged Draenei"],
--								["Void Elf"] = L["Void Elf"],
--								["Dark Iron Dwarf"] = L["Dark Iron Dwarf"],
--								["Kul Tiran"] = L["Kul Tiran"],
--								["Mechagnome"] = L["Mechagnome"],
							},
							Horde = {
								["None"] = L["None"],
								["Orc"] = L["Orc"],
								["Tauren"] = L["Tauren"],
								["Troll"] = L["Troll"],	
								["Undead"] = L["Undead"],				
--								["Blood Elf"] = L["Blood Elf"],
--								["Goblin"] = L["Goblin"],			
--								["Pandaren"] = L["Pandaren"],
--								["Highmountain Tauren"] = L["Highmountain Tauren"],
--								["Nightborne"] = L["Nightborne"],
--								["Mag'har Orc"] = L["Mag'har Orc"],
--								["Zandalari Troll"] = L["Zandalari Troll"],
--								["Vulpera"] = L["Vulpera"],
							},
						}
						if MeWantRevenge.EnemyFactionName == "Alliance" then
							raceOptions = races.Alliance
						end	
						if MeWantRevenge.EnemyFactionName == "Horde" then
							raceOptions = races.Horde
						end	
						return raceOptions
					end,
				},
				WarnRaceNote = {
					order = 14,
					type = "description",
					name = L["WarnRaceNote"],
				},
			},
		},
		MapOptions = {
			name = L["MapOptions"],
			desc = L["MapOptions"],
			type = "group",
			order = 5,
			args = {
				intro = {
					name = L["MapOptionsDescription"],
					type = "description",
					order = 1,
					fontSize = "medium",
				},
				MinimapDetection = {
					name = L["MinimapDetection"],
					desc = L["MinimapDetectionDescription"],
					type = "toggle",
					order = 2,
					width = "full",
					get = function(info)
						return MeWantRevenge.db.profile.MinimapDetection
					end,
					set = function(info, value)
						MeWantRevenge.db.profile.MinimapDetection = value
					end,
				},
				MinimapNote = {
					order = 3,
					type = "description",
					name = L["MinimapNote"],
				},				
				MinimapDetails = {
					name = L["MinimapDetails"],
					desc = L["MinimapDetailsDescription"],
					type = "toggle",
					order = 4,
					width = "full",
					get = function(info)
						return MeWantRevenge.db.profile.MinimapDetails
					end,
					set = function(info, value)
						MeWantRevenge.db.profile.MinimapDetails = value
					end,
				},
				DisplayOnMap = {
					name = L["DisplayOnMap"],
					desc = L["DisplayOnMapDescription"],
					type = "toggle",
					order = 5,
					width = "full",
					get = function(info)
						return MeWantRevenge.db.profile.DisplayOnMap
					end,
					set = function(info, value)
						MeWantRevenge.db.profile.DisplayOnMap = value
					end,
				},
				SwitchToZone = {
					name = L["SwitchToZone"],
					desc = L["SwitchToZoneDescription"],
					type = "toggle",
					order = 6,
					width = "full",
					get = function(info)
						return MeWantRevenge.db.profile.SwitchToZone
					end,
					set = function(info, value)
						MeWantRevenge.db.profile.SwitchToZone = value
					end,
				},				
				MapDisplayLimit = {
					name = L["MapDisplayLimit"],
					type = "group",
					order = 7,
					inline = true,
					args = {
						SameZone = {
							name = L["LimitSameZone"],
							desc = L["LimitSameZoneDescription"],
							type = "toggle",
							order = 1,
							width = "full",
							get = function(info)
								return MeWantRevenge.db.profile.MapDisplayLimit == "SameZone"
							end,
							set = function(info, value)
								MeWantRevenge.db.profile.MapDisplayLimit = "SameZone"
							end,
						},
						SameContinent = {
							name = L["LimitSameContinent"],
							desc = L["LimitSameContinentDescription"],
							type = "toggle",
							order = 2,
							width = "full",
							get = function(info)
								return MeWantRevenge.db.profile.MapDisplayLimit == "SameContinent"
							end,
							set = function(info, value)
								MeWantRevenge.db.profile.MapDisplayLimit = "SameContinent"
							end,
						},
						None = {
							name = L["LimitNone"],
							desc = L["LimitNoneDescription"],
							type = "toggle",
							order = 3,
							width = "full",
							get = function(info)
								return MeWantRevenge.db.profile.MapDisplayLimit == "None"
							end,
							set = function(info, value)
								MeWantRevenge.db.profile.MapDisplayLimit = "None"
							end,
						},
					},
				},
			},
		},
		DataOptions = {
			name = L["DataOptions"],
			desc = L["DataOptions"],
			type = "group",
			order = 6,
			args = {
				intro = {
					name = L["ListOptionsDescription"],
					type = "description",
					order = 1,
					fontSize = "medium",
				},
				RemoveUndetected = {
					name = L["RemoveUndetected"],
					type = "group",
					order = 2,
					inline = true,
					args = {
						OneMinute = {
							name = L["1Min"],
							desc = L["1MinDescription"],
							type = "toggle",
							order = 1,
							get = function(info)
								return MeWantRevenge.db.profile.RemoveUndetected == "OneMinute"
							end,
							set = function(info, value)
								MeWantRevenge.db.profile.RemoveUndetected = "OneMinute"
								MeWantRevenge:UpdateTimeoutSettings()
							end,
						},
						TwoMinutes = {
							name = L["2Min"],
							desc = L["2MinDescription"],
							type = "toggle",
							order = 2,
							get = function(info)
								return MeWantRevenge.db.profile.RemoveUndetected == "TwoMinutes"
							end,
							set = function(info, value)
								MeWantRevenge.db.profile.RemoveUndetected = "TwoMinutes"
								MeWantRevenge:UpdateTimeoutSettings()
							end,
						},
						FiveMinutes = {
							name = L["5Min"],
							desc = L["5MinDescription"],
							type = "toggle",
							order = 3,
							get = function(info)
								return MeWantRevenge.db.profile.RemoveUndetected == "FiveMinutes"
							end,
							set = function(info, value)
								MeWantRevenge.db.profile.RemoveUndetected = "FiveMinutes"
								MeWantRevenge:UpdateTimeoutSettings()
							end,
						},
						TenMinutes = {
							name = L["10Min"],
							desc = L["10MinDescription"],
							type = "toggle",
							order = 4,
							get = function(info)
								return MeWantRevenge.db.profile.RemoveUndetected == "TenMinutes"
							end,
							set = function(info, value)
								MeWantRevenge.db.profile.RemoveUndetected = "TenMinutes"
								MeWantRevenge:UpdateTimeoutSettings()
							end,
						},
						FifteenMinutes = {
							name = L["15Min"],
							desc = L["15MinDescription"],
							type = "toggle",
							order = 5,
							get = function(info)
								return MeWantRevenge.db.profile.RemoveUndetected == "FifteenMinutes"
							end,
							set = function(info, value)
								MeWantRevenge.db.profile.RemoveUndetected = "FifteenMinutes"
								MeWantRevenge:UpdateTimeoutSettings()
							end,
						},
						Never = {
							name = L["Never"],
							desc = L["NeverDescription"],
							type = "toggle",
							order = 6,
							get = function(info)
								return MeWantRevenge.db.profile.RemoveUndetected == "Never"
							end,
							set = function(info, value)
								MeWantRevenge.db.profile.RemoveUndetected = "Never"
								MeWantRevenge:UpdateTimeoutSettings()
							end,
						},
					},
				},
				PurgeData = {
					name = L["PurgeData"],
					type = "group",
					order = 7,
					inline = true,
					args = {
						OneDay = {
							name = L["OneDay"],
							desc = L["OneDayDescription"],
							type = "toggle",
							order = 1,
							get = function(info)
								return MeWantRevenge.db.profile.PurgeData == "OneDay"
							end,
							set = function(info, value)
								MeWantRevenge.db.profile.PurgeData = "OneDay"
							end,
						},
						FiveDays = {
							name = L["FiveDays"],
							desc = L["FiveDaysDescription"],
							type = "toggle",
							order = 2,
							get = function(info)
								return MeWantRevenge.db.profile.PurgeData == "FiveDays"
							end,
							set = function(info, value)
								MeWantRevenge.db.profile.PurgeData = "FiveDays"
							end,
						},
						TenDays = {
							name = L["TenDays"],
							desc = L["TenDaysDescription"],
							type = "toggle",
							order = 3,
							get = function(info)
								return MeWantRevenge.db.profile.PurgeData == "TenDays"
							end,
							set = function(info, value)
								MeWantRevenge.db.profile.PurgeData = "TenDays"
							end,
						},
						ThirtyDays = {
							name = L["ThirtyDays"],
							desc = L["ThirtyDaysDescription"],
							type = "toggle",
							order = 4,
							get = function(info)
								return MeWantRevenge.db.profile.PurgeData == "ThirtyDays"
							end,
							set = function(info, value)
								MeWantRevenge.db.profile.PurgeData = "ThirtyDays"
							end,
						},
						SixtyDays = {
							name = L["SixtyDays"],
							desc = L["SixtyDaysDescription"],
							type = "toggle",
							order = 5,
							get = function(info)
								return MeWantRevenge.db.profile.PurgeData == "SixtyDays"
							end,
							set = function(info, value)
								MeWantRevenge.db.profile.PurgeData = "SixtyDays"
							end,
						},
						NinetyDays = {
							name = L["NinetyDays"],
							desc = L["NinetyDaysDescription"],
							type = "toggle",
							order = 6,
							get = function(info)
								return MeWantRevenge.db.profile.PurgeData == "NinetyDays"
							end,
							set = function(info, value)
								MeWantRevenge.db.profile.PurgeData = "NinetyDays"
							end,
						},
					},
				},
				PurgeKoS = {
					name = L["PurgeKoS"],
					desc = L["PurgeKoSDescription"],
					type = "toggle",
					order = 8,
					width = "full",
					get = function(info)
						return MeWantRevenge.db.profile.PurgeKoS
					end,
					set = function(info, value)
						MeWantRevenge.db.profile.PurgeKoS = value
					end,
				},
				PurgeWinLossData = {
					name = L["PurgeWinLossData"],
					desc = L["PurgeWinLossDataDescription"],
					type = "toggle",
					order = 9,
					width = "full",
					get = function(info)
						return MeWantRevenge.db.profile.PurgeWinLossData
					end,
					set = function(info, value)
						MeWantRevenge.db.profile.PurgeWinLossData = value
					end,
				},
				ShareData = {
					name = L["ShareData"],
					desc = L["ShareDataDescription"],
					type = "toggle",
					order = 10,
					width = "full",
					get = function(info)
						return MeWantRevenge.db.profile.ShareData
					end,
					set = function(info, value)
						MeWantRevenge.db.profile.ShareData = value
					end,
				},
				UseData = {
					name = L["UseData"],
					desc = L["UseDataDescription"],
					type = "toggle",
					order = 11,
					width = "full",
					get = function(info)
						return MeWantRevenge.db.profile.UseData
					end,
					set = function(info, value)
						MeWantRevenge.db.profile.UseData = value
					end,
				},
				ShareKOSBetweenCharacters = {
					name = L["ShareKOSBetweenCharacters"],
					desc = L["ShareKOSBetweenCharactersDescription"],
					type = "toggle",
					order = 12,
					width = "full",
					get = function(info)
						return MeWantRevenge.db.profile.ShareKOSBetweenCharacters
					end,
					set = function(info, value)
						MeWantRevenge.db.profile.ShareKOSBetweenCharacters = value
						if value then
							MeWantRevenge:RegenerateKOSCentralList()
						end
					end,
				},
			},
		},
	},
}

MeWantRevenge.optionsSlash = {
	name = L["SlashCommand"],
	order = -3,
	type = "group",
	args = {
		intro = {
			name = L["MeWantRevengeSlashDescription"],
			type = "description",
			order = 1,
			cmdHidden = true,
		},
		show = {
			name = L["Show"],
			desc = L["ShowDescription"],
			type = 'execute',
			order = 2,
			func = function()
				MeWantRevenge:EnableMeWantRevenge(true, true)
			end,
			dialogHidden = true
		},
		hide = {
			name = L["Hide"],
			desc = L["HideDescription"],
			type = 'execute',
			order = 3,
			func = function()
				MeWantRevenge:EnableMeWantRevenge(false, true)				
			end,
			dialogHidden = true
		},		
		reset = {
			name = L["Reset"],
			desc = L["ResetDescription"],
			type = 'execute',
			order = 4,
			func = function()
				MeWantRevenge:ResetPositions()				
			end,
			dialogHidden = true
		},
		clear = {
			name = L["ClearSlash"],
			desc = L["ClearSlashDescription"],
			type = 'execute',
			order = 5,
			func = function()
				MeWantRevenge:ClearList()
			end,
			dialogHidden = true
		},			
		config = {
			name = L["Config"],
			desc = L["ConfigDescription"],
			type = 'execute',
			order = 6,
			func = function()
				MeWantRevenge:ShowConfig()
			end,
			dialogHidden = true
		},
		kos = {
			name = L["KOS"],
			desc = L["KOSDescription"],
			type = 'input',
			order = 7,
			pattern = ".",	-- Changed so names with special characters can be added
			set = function(info, value)
				if MeWantRevenge_IgnoreList[value] or strmatch(value, "[%s%d]+") then
					DEFAULT_CHAT_FRAME:AddMessage(value .. " - " .. L["InvalidInput"])		
				else
					MeWantRevenge:ToggleKOSPlayer(not MeWantRevengePerCharDB.KOSData[value], value)
				end	
			end,
			dialogHidden = true
		}, 
		ignore = {
			name = L["Ignore"],
			desc = L["IgnoreDescription"],
			type = 'input',
			order = 8,
			pattern = ".",			
			set = function(info, value)
				if MeWantRevenge_IgnoreList[value] or strmatch(value, "[%s%d]+") then
					DEFAULT_CHAT_FRAME:AddMessage(value .. " - " .. L["InvalidInput"])		
				else			
					MeWantRevenge:ToggleIgnorePlayer(not MeWantRevengePerCharDB.IgnoreData[value], value)
				end	
			end,
			dialogHidden = true
		},
		stats = {
			name = L["Statistics"],
			desc = L["StatsDescription"],
			type = 'execute',
			order = 9,
			func = function()
				MeWantRevengeStats:Toggle()
			end,
			dialogHidden = true
		},
		test = {
			name = L["Test"],
			desc = L["TestDescription"],
			type = 'execute',
			order = 10,					
			func = function()
				MeWantRevenge:AlertStealthPlayer("Bazzalan")
			end
		},
	},
}

local Default_Profile = {
	profile = {
		Colors = {
			["Window"] = {
				["Title"] = { r = 1, g = 1, b = 1, a = 1 },
				["Background"]= { r = 24/255, g = 24/255, b = 24/255, a = 1 },
				["Title Text"] = { r = 1, g = 1, b = 1, a = 1 },
			},
			["Other Windows"] = {
				["Title"] = { r = 1, g = 0, b = 0, a = 1 },
				["Background"]= { r = 24/255, g = 24/255, b = 24/255, a = 1 },
				["Title Text"] = { r = 1, g = 1, b = 1, a = 1 },
			},
			["Bar"] = {
				["Bar Text"] = { r = 1, g = 1, b = 1 },
			},
			["Warning"] = {
				["Warning Text"] = { r = 1, g = 1, b = 1 },
			},
			["Tooltip"] = {
				["Title Text"] = { r = 0.8, g = 0.3, b = 0.22 },
				["Details Text"] = { r = 1, g = 1, b = 1 },
				["Location Text"] = { r = 1, g = 0.82, b = 0 },
				["Reason Text"] = { r = 1, g = 0, b = 0 },
			},
			["Alert"] = {
				["Background"]= { r = 0, g = 0, b = 0, a = 0.4 },
				["Icon"] = { r = 1, g = 1, b = 1, a = 0.5 },
				["KOS Border"] = { r = 1, g = 0, b = 0, a = 0.4 },
				["KOS Text"] = { r = 1, g = 0, b = 0 },
				["KOS Guild Border"] = { r = 1, g = 0.82, b = 0, a = 0.4 },
				["KOS Guild Text"] = { r = 1, g = 0.82, b = 0 },
				["Stealth Border"] = { r = 0.6, g = 0.2, b = 1, a = 0.4 },
				["Stealth Text"] = { r = 0.6, g = 0.2, b = 1 },
				["Away Border"] = { r = 0, g = 1, b = 0, a = 0.4 },
				["Away Text"] = { r = 0, g = 1, b = 0 },
				["Location Text"] = { r = 1, g = 0.82, b = 0 },
				["Name Text"] = { r = 1, g = 1, b = 1 },
			},
			["Class"] = {
				["HUNTER"] = { r = 0.67, g = 0.83, b = 0.45, a = 0.6 },
				["WARLOCK"] = { r = 0.58, g = 0.51, b = 0.79, a = 0.6 },
				["PRIEST"] = { r = 1.0, g = 1.0, b = 1.0, a = 0.6 },
				["PALADIN"] = { r = 0.96, g = 0.55, b = 0.73, a = 0.6 },
				["MAGE"] = { r = 0.41, g = 0.8, b = 0.94, a = 0.6 },
				["ROGUE"] = { r = 1.0, g = 0.96, b = 0.41, a = 0.6 },
				["DRUID"] = { r = 1.0, g = 0.49, b = 0.04, a = 0.6 },
				["SHAMAN"] = { r = 0.14, g = 0.35, b = 1.0, a = 0.6 },
				["WARRIOR"] = { r = 0.78, g = 0.61, b = 0.43, a = 0.6 },
--				["DEATHKNIGHT"] = { r = 0.77, g = 0.12, b = 0.23, a = 0.6 },
--				["MONK"] = { r = 0.00, g = 1.00, b = 0.59, a = 0.6 },
--				["DEMONHUNTER"] = { r = 0.64, g = 0.19, b = 0.79, a = 0.6 },
				["PET"] = { r = 0.09, g = 0.61, b = 0.55, a = 0.6 },
				["MOB"] = { r = 0.58, g = 0.24, b = 0.63, a = 0.6 },
				["UNKNOWN"] = { r = 0.1, g = 0.1, b = 0.1, a = 0.6 },
				["HOSTILE"] = { r = 0.7, g = 0.1, b = 0.1, a = 0.6 },
				["UNGROUPED"] = { r = 0.63, g = 0.58, b = 0.24, a = 0.6 },
			},
		},
		MainWindow={
			Alpha=1,
			AlphaBG=1,
			Buttons={
				ClearButton=true,
				LeftButton=true,
				RightButton=true,
			},
			RowHeight=14,
			RowSpacing=2,
			TextHeight=12,
			AutoHide=true,
			BarText={
				RankNum = true,
				PerSec = true,
				Percent = true,
				NumFormat = 1,
			},
			Position={
				x = 4,
				y = 740,
				w = 160,
				h = 34,
			},
		},
		AlertWindow={
			Position={
--				x = 0,
--				y = -140,
				x = 750,
				y = 750,
			},
			NameSize=14,
			LocationSize=10,			
		},
		BarTexture="Flat",		
		MainWindowVis=true,
		CurrentList=1,
		Locked=false,
		ClampToScreen=true,		
		Font="Friz Quadrata TT",
		Scaling=1,
		Enabled=true,
		EnabledInBattlegrounds=true,
		EnabledInArenas=true,
		EnabledInWintergrasp=true,
		DisableWhenPVPUnflagged=true,
		MinimapDetection=false,
		MinimapDetails=true,
		DisplayOnMap=true,
		SwitchToZone=false,
		MapDisplayLimit="SameZone",
		DisplayTooltipNearMeWantRevengeWindow=false,
		TooltipAnchor="ANCHOR_CURSOR",
		DisplayWinLossStatistics=true,
		DisplayKOSReason=true,
		DisplayLastSeen=true,
		DisplayListData="NameLevelClass",
		ShowOnDetection=true,
		HideMeWantRevenge=false,
--		ShowOnlyPvPFlagged=false,
		ShowKoSButton=false,		
		InvertMeWantRevenge=false,
		ResizeMeWantRevenge=true,
		ResizeMeWantRevengeLimit=15,
		SoundChannel="SFX",
		Announce="None",
		OnlyAnnounceKoS=false,
		WarnOnStealth=true,
		WarnOnKOS=true,
		WarnOnKOSGuild=false,
		WarnOnRace=false,
		SelectWarnRace="None",		
		DisplayWarnings="Default",
		EnableSound=true,
		OnlySoundKoS=false, 
		StopAlertsOnTaxi=true,
		RemoveUndetected="OneMinute",
		ShowNearbyList=true,
		PrioritiseKoS=true,
		PurgeData="NinetyDays",
		PurgeKoS=false,
		PurgeWinLossData=false,
		ShareData=false,
		UseData=false,
		ShareKOSBetweenCharacters=true,
		AppendUnitNameCheck=false,
		AppendUnitKoSCheck=false,
		FilteredZones = {
			["Booty Bay"] = false,
			["Gadgetzan"] = false,
			["Ratchet"] = false,
			["Everlook"] = false,
			["The Salty Sailor Tavern"] = false,
			["Shattrath City"] = false,
			["Area 52"] = false,
--			["Dalaran"] = false,
--			["Dalaran (Northrend)"] = false,
--			["Bogpaddle"] = false,			
--			["The Vindicaar"] = false,
--			["Krasus' Landing"] = false,
--			["The Violet Gate"] = false,
--			["Magni's Encampment"] = false,
		},
	},
}

function MeWantRevenge:ResetProfile()
	MeWantRevenge.db.profile = Default_Profile.profile
--	MeWantRevenge:CheckDatabase()
end

function MeWantRevenge:HandleProfileChanges()
	MeWantRevenge:CreateMainWindow()
	MeWantRevenge:RestoreMainWindowPosition(MeWantRevenge.db.profile.MainWindow.Position.x, MeWantRevenge.db.profile.MainWindow.Position.y, MeWantRevenge.db.profile.MainWindow.Position.w, 34)	
	MeWantRevenge:ResizeMainWindow()
	MeWantRevenge:UpdateTimeoutSettings()
	MeWantRevenge:LockWindows(MeWantRevenge.db.profile.Locked)
	MeWantRevenge:ClampToScreen(MeWantRevenge.db.profile.ClampToScreen)	
end

function MeWantRevenge:RegisterModuleOptions(name, optionTbl, displayName)
	MeWantRevenge.options.args[name] = (type(optionTbl) == "function") and optionTbl() or optionTbl
	self.optionsFrames[name] = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("MeWantRevenge", displayName, L["MeWantRevenge Option"], name)
end

function MeWantRevenge:SetupOptions()
    print("Setting options...")
    self.optionsFrames = {}

 	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("MeWantRevenge", MeWantRevenge.options)
	LibStub("AceConfig-3.0"):RegisterOptionsTable("MeWantRevenge Commands", MeWantRevenge.optionsSlash, "MeWantRevenge")

	local ACD3 = LibStub("AceConfigDialog-3.0")
	self.optionsFrames.MeWantRevenge = ACD3:AddToBlizOptions("MeWantRevenge", L["MeWantRevenge Option"], nil, "General")
	self.optionsFrames.About = ACD3:AddToBlizOptions("MeWantRevenge", L["About"], L["MeWantRevenge Option"], "About")
	self.optionsFrames.DisplayOptions = ACD3:AddToBlizOptions("MeWantRevenge", L["DisplayOptions"], L["MeWantRevenge Option"], "DisplayOptions")
	self.optionsFrames.AlertOptions = ACD3:AddToBlizOptions("MeWantRevenge", L["AlertOptions"], L["MeWantRevenge Option"], "AlertOptions")
--	self.optionsFrames.ListOptions = ACD3:AddToBlizOptions("MeWantRevenge", L["ListOptions"], L["MeWantRevenge Option"], "ListOptions")
	self.optionsFrames.MapOptions = ACD3:AddToBlizOptions("MeWantRevenge", L["MapOptions"], L["MeWantRevenge Option"], "MapOptions")
	self.optionsFrames.DataOptions = ACD3:AddToBlizOptions("MeWantRevenge", L["DataOptions"], L["MeWantRevenge Option"], "DataOptions")

    -- THIS LINE IS NOT WORKING
	self:RegisterModuleOptions("Profiles", LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db), L["Profiles"])
	MeWantRevenge.options.args.Profiles.order = -2
    print("Options set.")
end

function MeWantRevenge:CheckDatabase()
	if not MeWantRevengePerCharDB or not MeWantRevengePerCharDB.PlayerData then
		MeWantRevengePerCharDB = {}
	end
	MeWantRevengePerCharDB.version = MeWantRevenge.DatabaseVersion
	if not MeWantRevengePerCharDB.PlayerData then
		MeWantRevengePerCharDB.PlayerData = {}
	end
	if not MeWantRevengePerCharDB.IgnoreData then
		MeWantRevengePerCharDB.IgnoreData = {}
	end
	if not MeWantRevengePerCharDB.KOSData then
		MeWantRevengePerCharDB.KOSData = {}
	end
	if MeWantRevengeDB.kosData == nil then MeWantRevengeDB.kosData = {} end
	if MeWantRevengeDB.kosData[MeWantRevenge.RealmName] == nil then MeWantRevengeDB.kosData[MeWantRevenge.RealmName] = {} end
	if MeWantRevengeDB.kosData[MeWantRevenge.RealmName][MeWantRevenge.FactionName] == nil then MeWantRevengeDB.kosData[MeWantRevenge.RealmName][MeWantRevenge.FactionName] = {} end
	if MeWantRevengeDB.kosData[MeWantRevenge.RealmName][MeWantRevenge.FactionName][MeWantRevenge.CharacterName] == nil then MeWantRevengeDB.kosData[MeWantRevenge.RealmName][MeWantRevenge.FactionName][MeWantRevenge.CharacterName] = {} end
	if MeWantRevengeDB.removeKOSData == nil then MeWantRevengeDB.removeKOSData = {} end
	if MeWantRevengeDB.removeKOSData[MeWantRevenge.RealmName] == nil then MeWantRevengeDB.removeKOSData[MeWantRevenge.RealmName] = {} end
	if MeWantRevengeDB.removeKOSData[MeWantRevenge.RealmName][MeWantRevenge.FactionName] == nil then MeWantRevengeDB.removeKOSData[MeWantRevenge.RealmName][MeWantRevenge.FactionName] = {} end
end

function MeWantRevenge:OnInitialize()
    MeWantRevenge.RealmName = GetRealmName()
    MeWantRevenge.FactionName = select(1, UnitFactionGroup("player"))
	if MeWantRevenge.FactionName == "Alliance" then
		MeWantRevenge.EnemyFactionName = "Horde"
	elseif MeWantRevenge.FactionName == "Horde" then
		MeWantRevenge.EnemyFactionName = "Alliance"
	else
		MeWantRevenge.EnemyFactionName = "None"	
	end
	MeWantRevenge.CharacterName = UnitName("player")

	MeWantRevenge.ValidClasses = {
		["DRUID"] = true,
		["HUNTER"] = true,	
		["MAGE"] = true,	
		["PALADIN"] = true,	
		["PRIEST"] = true,
		["ROGUE"] = true,	
		["SHAMAN"] = true,
		["WARLOCK"] = true,		
		["WARRIOR"] = true,
--		["DEATHKNIGHT"] = true,		
--		["MONK"] = true,
--		["DEMONHUNTER"] = true
	}

	MeWantRevenge.ValidRaces = {
		["Human"] = true,
		["Orc"] = true,
		["Dwarf"] = true,
		["Tauren"] = true,
		["Troll"] = true,		
		["NightElf"] = true,
		["Scourge"] = true,		
		["Gnome"] = true,
		["BloodElf"] = true,		
		["Draenei"] = true,
--		["Goblin"] = true,		
--		["Worgen"] = true,
--		["Pandaren"] = true,
--		["HighmountainTauren"] = true,		
--		["LightforgedDraenei"] = true,
--		["Nightborne"] = true,		
--		["VoidElf"] = true,
--		["DarkIronDwarf"] = true,
--		["MagharOrc"] = true,		
--		["KulTiran"] = true,
--		["ZandalariTroll"] = true,
--		["Mechagnome"] = true,
--		["Vulpera"] = true,				
	}

    local AceDB = LibStub:GetLibrary("AceDB-3.0")

    MeWantRevenge.db = AceDB:New("MeWantRevengeDB", Default_Profile)
    MeWantRevenge:CheckDatabase()
    --MeWantRevenge.db.RegisterCallback(MeWantRevenge, "OnNewProfile", "ResetProfile")
    MeWantRevenge.db.RegisterCallback(MeWantRevenge, "OnNewProfile", "HandleProfileChanges")
    --MeWantRevenge.db.RegisterCallback(MeWantRevenge, "OnProfileReset", "ResetProfile")
    MeWantRevenge.db.RegisterCallback(MeWantRevenge, "OnProfileReset", "HandleProfileChanges")
    MeWantRevenge.db.RegisterCallback(MeWantRevenge, "OnProfileChanged", "HandleProfileChanges")
    MeWantRevenge.db.RegisterCallback(MeWantRevenge, "OnProfileCopied", "HandleProfileChanges")
    MeWantRevenge:SetupOptions()

	----------------------------------------------
	-- WINDOW TEST
	local frame = MeWantRevenge:CreateFrame("MeWantRevenge_MainWindow", "MeWantRevenge", 200, 300, nil, nil)
	frame:SetResizable(true)
	frame:SetMinResize(90, 34)
	frame:SetMaxResize(300, 264)

	frame:SetMovable(true)
    frame:EnableMouseWheel(true)
	print("Frame configured")
end