// TO RUN: select batch directory for analysis

// GOALS:
// 1) automatically split long stacks into hyperstacks with 3 channels and 1 z plane
// 2) allow user to select ROIs and make crops from a big batch of movies quickly

mainDir = getDirectory("Choose a directory containing your files:"); 
mainList = getFileList(mainDir); 

Dialog.create("Define the image type");
Dialog.addString("Input Image Type:", ".tif"); //default is .tif
Dialog.addNumber("Total time of movie (sec):", "30");

// next pull out the values from the dialog box and save them as variables
Dialog.show();
imageType = Dialog.getString();
totalTime = Dialog.getNumber();

// make sub directory for the analysis
newDir = mainDir+"Output-Crops"+File.separator;
File.makeDirectory(newDir);

for (m=0; m<mainList.length; m++) { //clunky, loops thru all items in folder looking for image
	if (endsWith(mainList[m], imageType)) { 
		open(mainDir+mainList[m]); //open image file on the list
		title = getTitle(); //save the title of the movie
		// find dimensions of the movie
		getDimensions(width, height, channels, slices, frames);

		// change the micron scale
		Stack.setXUnit("micron");
		fps = totalTime / slices;
		// microns per pixel hard coded below, 100X = 0.11
		run("Properties...", "channels=1 slices=&slices frames=1 pixel_width=0.11 pixel_height=0.11 voxel_depth=0.11 frame=[&fps sec]");
		// use number of slices and divide by 3 for number of frames
		newFrames = slices / 3;
		run("Stack to Hyperstack...", "order=xyczt(default) channels=3 slices=1 frames=&newFrames display=Grayscale");
		
		// prompt user to select regions of interest and save them using t shortcut
		setTool("rectangle");
		waitForUser("Manually select ROI(s), press t to save, then click OK"); 

		// loop thru ROI list and duplicate and save each crop as a tiff, ready for analysis!
		for (n = 0; n < roiManager("count"); n++){
			selectWindow(title); // selects your movie
			roiManager("Select", n);
			run("Duplicate...", "duplicate");
			newName = getTitle();
			saveAs("Tiff", newDir+newName);
        	}
        	
        selectWindow("ROI Manager");
		run("Select All");
		roiManager("save selected", newDir+title+"-RoiSet.zip"); // saves the roiset   		
		selectWindow("ROI Manager");
		run("Close"); //close ROI manager
		close("*"); // close all open images
	}
}