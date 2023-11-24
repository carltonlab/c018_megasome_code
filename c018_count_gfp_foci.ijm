//count the number of cosa1 foci

//set the batch mode
setBatchMode(false);

//set the expandable arrays
setOption("ExpandableArrays", true);

//get the main directory
main_dir = getDir("Select the directory with the .csv files and the .tif files");
 
//get the file list
file_list = getFileList(main_dir);

//get the working file list
working_file_list = newArray();

//get the counter
working_counter = 0;

//close all images
close("*");

//loop throuhg the flie list
for (a = 0; a < file_list.length; a++) {
	
	//index fo chr
	index_of_chr = indexOf(file_list[a], "_chr");
	
	//get the index of traces
	index_of_traces = indexOf(file_list[a], "traces");
	
	//index of rois
	index_of_rois = indexOf(file_list[a], "_rois");
	
	//get the index of sbs
	index_of_sbs = indexOf(file_list[a], "_sbs");
	
	//get the index of count
	index_of_count = indexOf(file_list[a], "_count");
	
	//get the index of proj
	index_of_proj = indexOf(file_list[a], "_proj");
		
	//if the index is more thfan 0
	if (index_of_chr <= -1 && index_of_rois <= -1 && index_of_traces <= -1 && index_of_sbs >= 0 && index_of_count <= -1 && index_of_proj <= -1) {
	
		//set it
		working_file_list[working_counter] = file_list[a];
		
		//add one to the counter
		working_counter += 1;

	}

}

//make an array to add the file lise
counted_foci_file_array = newArray();

//make an array to add the counted number
count_foci_for_file_array = newArray();

//set the counter foci counter
counted_file_counter = 0;

//loop through the working file list
for (a = 0; a < working_file_list.length; a++) {

	//if it is 0
	if (a == 0) {
	
		//get the index of sbs
		index_of_sbs = indexOf(working_file_list[a], "_sbs");
	
		//get the name of the file
		saving_file_name = substring(working_file_list[a], 0, index_of_sbs) + "_cosa1_foci_count.csv" ; 
		
		//print the saving file name
		print("Saving file name: " + saving_file_name);
					
	}
	
	//print the working file
	print("Working on file: " + working_file_list[a]);
	
	//reset the results
	run("Clear Results");
	
	//close all images
	close("*");
	
	//get the cosa1_count filename
	sbs_result_filename = File.getNameWithoutExtension(working_file_list[a]) + "_cosa1_count.csv";
	
	//if the file exists:
	if (File.exists(main_dir + sbs_result_filename)) {

		//open the file
		open(main_dir + sbs_result_filename);
		
		//get the foci count
		foci_count = Table.get("cosa1_count", 0);
		
		//add the file to the array
		counted_foci_file_array[counted_file_counter] = working_file_list[a];
		
		//add the count to the other array
		count_foci_for_file_array[counted_file_counter] = foci_count;
		
		//add one to it
		counted_file_counter += 1;		
		
		//print the count
		print("The count is: " + foci_count);
		
		close(sbs_result_filename);
	
	}
	
	
	//if the file file doens't exist:
	if (File.exists(main_dir + sbs_result_filename) == false) {

		//open the file
		open(main_dir + working_file_list[a]);
				
		//set it to channel 3
		Stack.setChannel(3);
		
		//get the dimensions
		getDimensions(image_width, image_height, image_channels, image_slices, image_frames);
		
		//get the half slice
		half_slice = floor(image_slices/2);
		
		//set the slice
		Stack.setSlice(half_slice);
		
				//set it to color
		Stack.setDisplayMode("color");
		
		//set the first channel
		Stack.setChannel(1);
		
		//set it to magenta
		run("Magenta");
		
		run("Enhance Contrast", "saturated=0.35");
		
		//set the channel 3
		Stack.setChannel(3);
		
		//set to green
		run("Green");
		
		run("Enhance Contrast", "saturated=0.35");
		
		//set to composite
		Stack.setDisplayMode("composite");
		
		//set the active channels to 1 and 3
		Stack.setActiveChannels("101");
					
		//make a dialog
		Dialog.createNonBlocking("Count the GFP cosa foci");
		
		//add the count
		Dialog.addNumber("GFP Foci: ", 5);
		
		//add the skip flag
		Dialog.addCheckbox("Skip file: ", false);
		
		//show the dialog
		Dialog.show();
		
		//get the count
		foci_count = Dialog.getNumber();
		
		//get the skip flag
		skip_flag = Dialog.getCheckbox();
		
		//if the skip flag is false
		if (skip_flag == false) {
			
			//add the file to the array
			counted_foci_file_array[counted_file_counter] = working_file_list[a];
			
			//add the count to the other array
			count_foci_for_file_array[counted_file_counter] = foci_count;
			
			//print the foci count
			print("The count is: " + foci_count);
			
			//close all images
			close("*");
			
			//set the result
			setResult("filename", 0, working_file_list[a]);
			
			//set the result
			setResult("cosa1_count", 0, foci_count);
			
			//save the result
			saveAs("results", main_dir + sbs_result_filename);
						
			//add one to it
			counted_file_counter += 1;		
			
		}
		
		//clear results
		run("Clear Results");
		
		//close all images
		close("*");
		
	}
	
};

//get the results cleared
run("Clear Results");

//loop through the array
for (a = 0; a < counted_foci_file_array.length; a++) {

	//set the resutl
	setResult("filename", a, counted_foci_file_array[a]);
	
	//set the result
	setResult("cosa1_count", a, count_foci_for_file_array[a]);
				
}

//save the results
saveAs("results", main_dir + saving_file_name);
	
//clear results
run("Clear Results");

print("counting done");
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	