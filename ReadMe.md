Traffic sign segmentation and classification
------------------------------------------------------------------------------------------------------------------------------------------------
This project segments the traffic sign in each frame from a video and classifies it into either **No Parking** or **Stop sign**.
This project finds only No Parking and Stop signs, but with more database, can be used for any other red circle traffic signs.

Code Structure
------------------------------------------------------------------------------------------------------------------------------------------------
The main folder contains three sub folders
1. Code
2. Data
3. VLFeat

	Code: This contains two sections, CodeForClassification and CodeForGeneratingDatabase
	
	Data: Contains training data, test data and videosForGeneratingDatabase. 
		Replace this folder with https://www.dropbox.com/sh/2s5hiplso5uzvwi/AACYjXWmTlRHNeImIeavLGbia?dl=0

	VLFeat: This is essential for running classification functions from vlfeat. 
			This folder should be at the same level as that of Code. Else, the path should be changed in runMe.m 
			You can download it from http://www.vlfeat.org/matlab/matlab.html if it doesn't exist in the aforementioned path.
			

Results can be viewed in https://www.dropbox.com/sh/mdqp192he28tgsi/AABGlUuWNNshmO9UfmMIVllZa?dl=0

Prerequisites
------------------------------------------------------------------------------------------------------------------------------------------------
To run rumMe.m in CodeForClassification, database of images are required. If you generate your own database, it needs to go in the path Data/TrainImages as NoParking, Stop and Negative. All images should be in jpg format.
To generate images from a video, you need to have a signInfo.txt file. Use CodeForGeneratingDatabase/parse.m to change the format in which the info is read from the file and CodeForGeneratingDatabase/CreateImageDatabase.m to generate the database.
The default format in which it is read is "frame# sign_type sign_no center_x center_y vertex_1_x vertex_1_y vertex_2_x vertex_2_y vertex_3_x vertex_3_y vertex_4_x vertex_4_y distance". 
Distance is the distance of the sign from the camera source. It is used for thresholding, that can be found in CodeForGeneratingDatabase/CreateImageDatabase.m.
After this step, it is necessary that you delete Code/CodeForClassification/features_neg.mat, Code/CodeForClassification/features_np.mat, Code/CodeForClassification/features_stop.mat files.

Running the classification code
-------------------------------------------------------------------------------------------------------------------------------------------------
Following parameters are hard-coded in the code
rumMe.m
Paths to read and write the video files.
Path to the database.
HoG template size = 36
HoG cell size = 6
Lambda value for the svm classifier = 0.00001
Radius range for imfindcircles = [10 100]
Width threshold = 20
Confidence threshold for HoG output = 0.67

To change the test video fileName:
Modify VideoName and extension in line 15 and line 19 of runMe.m
The result will be stored in the path HoG/Results as "videoName"_"dd_mm_yy_HH_MM_SS"."extension"


Extra Note
---------------------------------------------------------------------------------------------------------------------------------------------------
GUI implementation has been attempted.
ClassificationGUI.fig and ClassificationGUI.m  are the GUI files. 
The output destination SHOULD NOT HAVE AN EXTENSION, as it takes the same extension as the input file.

Authors
---------------------------------------------------------------------------------------------------------------------------------------------------
Manasa Kadiri*
Apoorva Beedu*
* School of Electrical and Computer Engineering , Georgia Institute of Technology

Acknowledgments
--------------------------------------------------------------
1. Min-Hung (Steve) Chen of Multimedia and Sensors Lab (MSL) for helping us with the database
2. James Hays, Associate Professor, School of Interactive Computing, College of Computing, Georgia Institute of Technology for non_max_supr_box.m (This was a part of CS647-project 5)
 

