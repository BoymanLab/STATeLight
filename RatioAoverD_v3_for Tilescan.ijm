//This macro was written by Karin Seubert, Center for Microscopy and Image Analysis, University of Zurich, karin.seubert@zmb.uzh.ch
//It was written using ImageJ 1.53f51
//After choosing an import file and output folder, the macro automatically calculates the ratio of 
//acceptor/donor intensity (AoverD) and donor/acceptor intensity (DoverA) and additionally makes the background black for better discrimination
//of cells versus background in the intensity ratio images.
//At the end, it saves the AoverD and DoverA images automatically as TIFF files in the specified output folder.

//version 2
//version 3: scalebar added

//Choose a folder for saving the processed images.

outputDir=getDirectory("Select an output folder");

// Dialog window for parameters choice ----------------
channelchoice=newArray("(3C)","(4C)","(5C)");
batchchoice=newArray("yes","no");
Dialog.create("Setting thresholds for display");
Dialog.addNumber("Lower Threshold for AoverD analysis", 0);
Dialog.addNumber("Upper Threshold for AoverD analysis", 2);
Dialog.addNumber("Lower Threshold for DoverA analysis", 0);
Dialog.addNumber("Upper Threshold for DoverA analysis", 2);
Dialog.addChoice("How many channels (seen in the import selection window)", channelchoice);
Dialog.addNumber("Threshold for background calculation", 5);
Dialog.addChoice("Would you like to process in batch mode (nothing on screen)", batchchoice);
Dialog.show();

lownumberAoverD=Dialog.getNumber();
highnumberAoverD=Dialog.getNumber();
lownumberDoverA=Dialog.getNumber();
highnumberDoverA=Dialog.getNumber();
channelnumber=Dialog.getChoice;
backgroundthreshold=Dialog.getNumber();
batch=Dialog.getChoice;

// End of Dialog --------------------------------------

if(batch=="yes") setBatchMode(true);

if(channelnumber=="(3C)") number=3;
if(channelnumber=="(4C)") number=4;
if(channelnumber=="(5C)") number=5;
numberimages=nImages;
repetitionnumber=numberimages/number;

for(i=0;0<repetitionnumber-1;i++){
	

name=getTitle();
le=lengthOf(name);
nameD=substring(name, 0,le-1)+"0";
nameA=substring(name,0,le-1)+"1";
nameFLIM=substring(name,0,le-1)+"2";
nameD2=substring(name,0,le-1)+"3";
nameA2=substring(name,0,le-1)+"4";

//Creating a mask for automatic background calculation
selectWindow(nameD);
run("Duplicate...", " ");
rename("Mask");
setAutoThreshold("Default dark");
//run("Threshold...");
setThreshold(backgroundthreshold, 65535);
setOption("BlackBackground", false);
run("Convert to Mask");
run("Fill Holes");
run("Open");
run("Divide...", "value=255");
setMinAndMax(0, 1);

//Calculating the ratio images
imageCalculator("Divide create 32-bit", nameA ,nameD);

nameresult=getTitle() ;
stringstart=indexOf(name, ".lif");
stringstop=indexOf(name, " - C=");
shortname=substring(replace(name,  "/", "-"), stringstart+7,stringstop);
newAoverD="Ratio AoverD of "+shortname;
rename(newAoverD);
imageCalculator("Multiply create 32-bit", "Mask",newAoverD);
close(newAoverD);
selectWindow("Result of Mask");
rename(newAoverD);
run("Fire");
setMinAndMax(lownumberAoverD, highnumberAoverD);
run("Calibration Bar...", "location=[Upper Right] fill=White label=Black number=5 decimal=1 font=14 zoom=1 overlay");
run("Scale Bar...", "width=10 height=4 font=14 color=White background=None location=[Lower Right] bold overlay");

imageCalculator("Divide create 32-bit", nameD ,nameA);
nameresult=getTitle() ;
stringstart=indexOf(name, ".lif");
stringstop=indexOf(name, " - C=");
shortname=substring(replace(name,  "/", "-"), stringstart+7, stringstop);
newDoverA="Ratio DoverA of "+shortname;
rename(newDoverA);
imageCalculator("Multiply create 32-bit", "Mask",newDoverA);
close(newDoverA);
selectWindow("Result of Mask");
rename(newDoverA);
run("Fire");
setMinAndMax(lownumberDoverA, highnumberDoverA);
run("Calibration Bar...", "location=[Upper Right] fill=White label=Black number=5 decimal=1 font=14 zoom=1 overlay");
run("Scale Bar...", "width=10 height=4 font=14 color=White background=None location=[Lower Right] bold overlay");

//Closing windows and saving the images
close(nameD);
close(nameA);
close(nameFLIM);
close("Mask");
if(channelnumber=="(4C)") close(nameD2);
if(channelnumber=="(5C)") close(nameD2);
if(channelnumber=="(5C)") close(nameA2);

selectWindow(newAoverD);
saveTitleAoverD= outputDir+newAoverD;
print("new file path is "+saveTitleAoverD);
saveAs("Tiff", saveTitleAoverD);
close();

selectWindow(newDoverA);
saveTitleDoverA= outputDir+newDoverA;
print("new file path is "+saveTitleDoverA);
saveAs("Tiff", saveTitleDoverA);
close();

}

setBatchMode(false);

