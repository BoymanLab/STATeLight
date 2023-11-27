# STATeLight
This macro was used to calculate the ratio of acceptor/donor intensity (AoverD) and donor/acceptor intensity (DoverA) to select cells for FLIM analysis. At the end, it saves the AoverD and DoverA images automatically as TIFF files in the specified output folder.
# Input
In Fiji, open the macro by drag-and-drop.

Import your .lif file by File>Import>Bio-Formats.

Choose the corresponding files of intensity images.

# Output

Run the macro. This will open a dialog asking where you want to set the lower and upper threshold for visualization (lower=everything below this ration is black, upper = range of ratio that will be display). AoverD and DoverA images will be saved in your designated output folder. Images that were opened for the analysis will be automatically closed. 
