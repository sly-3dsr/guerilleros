--to change line 28 make it work cross plateform

function incrementalsave()
	
	local scenepath = os.getenv("SCENE_PATH")
	local scene = os.getenv("SCENE")
	local fullpath = string.format("%s/%s.gproject",scenepath,scene)
	
	if not scene or (not scenepath) then
		return
	end

	local scenefile=string.format("%s/%s.gproject",scenepath,scene)
	local incrementalpath=string.format("%s/incrementalSaves/%s",scenepath,scene)

	--CheckIncrementalDir
	if not file.stat(incrementalpath) then
		file.mkdirtree(incrementalpath)
	end

	if savedocument() then
		local incrementedfile=string.format("%s/%s",incrementalpath,scene)
		local count=0
		while file.stat(string.format("%s.%04d.gproject",incrementedfile,count)) do
			count=count+1
		end
		local destination=string.format("%s.%04d.gproject",incrementedfile,count)
		os.execute(string.format("cp %s %s",fullpath,destination))
	else

		return

	end

end 

incrementalsave()
