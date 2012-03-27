--[[
	Implementation of the Maya incremental save.
--]]

local	incrementalsavecommand = command.create ("Save Incremental", "icon_file_save.png", "Ctrl+S")

function incrementalsavecommand:isenabled ()
	return true
end

function incrementalsavecommand:action ()

	local scenefile=string.format("%s/%s.gproject",os.getenv("SCENE_PATH"),os.getenv("SCENE"))
	local stat=file.stat(scenefile)
	
	--Save scene
	if not stat then
		stat=savedocumentas()
	else
		stat=savedocument()
	end

	if not stat then
		pwarning("WARNING:The document was not saved")
		return false
	end
	
	--Declare the scene variables
	local scenepath = os.getenv("SCENE_PATH")
	local scene = os.getenv("SCENE")
	local incrementalpath=string.format("%s/incrementalSaves/%s",scenepath,scene)
	local incrementedfile=string.format("%s/%s",incrementalpath,scene)
	scenefile=string.format("%s/%s.gproject",scenepath,scene)
	
	--Check if the incremental directory exist
	if not file.stat(incrementalpath) then
		file.mkdirtree(incrementalpath)
	end

	--Check incremented files to find a new file name
	local count=0

	while file.stat(string.format("%s.%05d.gproject",incrementedfile,count)) do
		count=count+1
	end

	--Copying the file to the incremental directory with the found name
	local destination=string.format("%s.%04d.gproject",incrementedfile,count)

	if file.copy(scenefile,incrementalpath) then

		local copiedfile=string.format("%s/%s.gproject",incrementalpath,scene)

		if file.rename(copiedfile,destination) then
			return true        
		else
			perror(string.format("ERROR:could not rename '%s' to '%s'",copiedfile,destination))
			return false
		end
	else
		perror(string.format("ERROR:could not copy '%s' to '%s'",scenefile,incrementalpath))
		return false
	end

end

if MainMenu then
	MainMenu:addcommand (incrementalsavecommand, "Guerilleros", "File")
end
--print("IncrementalSaveModule Loaded")