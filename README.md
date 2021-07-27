# DRUMS-CDG
## AStract

POTS_checka_both_Real.m finds which patients could have POTS according to both their AS and HUT data (combines POTS_checka_AS.m and POTS_checka_HUT.m). However, it only checks for the 30 (or 40) BPM increase in HR, but not if the increase is sustained. SBPcalc_ben.m calculates systolic blood pressure by finding peaks of BP data (the other SBPcalc_X’s are not used).

## Control

Contains the generated workspace files for both valsalva maneuvers, deep breathing, and active stand for each control patient (mat files). Additionally, it contains the text files used to generate these workspaces. The times and general statistics about each patient are stored in the file “Control Patient Info.csv. The workspaces were generated using the script processor.m, which calls all of the remaining scripts in this folder. The sub-folder Control_Optimized contains the optimized files for the control patients generated from POTS_Driver in Cluster/Residual_Algorithm.  

## Markers

Markers.m calculates non-parameter markers, including clinical ratios (alpha, beta, gamma), and baseline HR and BP before and after VMs. 

## Optimized Stats

Folder where optimizations from the cluster are processed and analyzed. Includes flagchecka, which counts missing optimizations and those which are flagged by our optimization algorithm as poor fits or failing to converge, saving results in flagDiverge and flagBadErr. OptPars extracts optimized parameters from data, and combines this with nominal parameters, data markers, and neural tones to run kmeans clustering. This data is saved in 4plots.mat, which is fed to plotMakerOptPars, which makes plots to visualize summary statistics from optimizations and clustering results. check_Diverge checks which patients’ optimizations diverged to multiple optima. Opt_iteration_figure plots each optimized parameter across all 8 random starts. Get_All_Parameters.m takes the optimized files created by the cluster and uses the saved parameters to generate the rest of the parameter values. check_Driver.m calls DriverBasicME.m to obtain and save all of the optimized sympathetic and parasympathetic tones. DriverBasicME generates the model output using the optimized parameters. The rest of the folder is just a bunch of figures.

## Residual_Algorithm

This folder is virtually obsolete at this point. It is kept in order to have some base code ready if needed. INDMAPcomparison.m and INDMAP.plots.m were used to compare and generate plots based on model output using different INDMAPs, i.e. optimizing different sets of parameters. residual_comparer.m and the functions that it calls acted as base code for POTS_Driver in the Cluster folder. Residual_comparer_sampled.m and the functions that it calls were used to test the model and optimization at different sampling rates for the data. The resulting workspaces were saved in the Valsalva subfolder.

## Sophie Folder

Folder for Sophie Carlson to do her stuff. Contains new_Matlab_to_WS, for Sophie to plot blood pressures and extract the correct pkprominence to capture the best systolic curve, and then create the correct workspace. Also contains soph_plot, which plots the heart rate during Valsalva to manually select the max and min over the second phase. 

## Summary_Data_800_Gals

Summarydata.mat finds how many patients have each test (VM, DB, AS, HUT) (patientTotals). It finds rest times for all tests for all patients (counts), as well as the duration of time between the tests (betweenTimes). Finds how many unique patients have each test (uniqueTotals), their rest times (uniqueCounts), and time between tests (uniqueTimes) as well. Summaryplots.m uses the variables from summarydata.m to plot a) a boxplot of rest times before and after each VM, b) a histogram of patient ages, c) a boxplot of average AS lengths. 

## Cluster (Clean Code)

ForwardEvaluation
DriverBasic.m generates nominal files (saved to nomHR folder) and five panel plots of blood pressure, thoracic pressure, heart rate and tones (saved to Figures folder).

### Markers

markerExtractor.m extracts the markers (alpha, beta, gamma, HRbeforeVal, HRafterVal, SBPbeforeVal, SBPafterVal, maxHR2, maxBP2, maxHR3, maxBP3) from the data. Runs through Google Drive or GitHub but we should update the nomHRs on Google Drive since they’re very old. 

### LSA

DriverBasic_sens.m generates sens files. It loads workspaces from the MatFiles and saves sens files into the Sens folder. Using the sensitivity matrix computed in DriverBasic_sens.m, covariance.m files identify pairwise correlations between parameters and returns sensitive and linearly independent parameter subset. 

### Optimization

Runs optimization the old way so it is pretty slow and generates opt files. Use Residual Algorithm for optimizing on Henry2 and for the most recent version.

### Residual_Algorithm
	
Folder for optimizing lots of data on the cluster. Wrapper.m is what we call on the cluster to do hundreds of optimizations at once. The index in this file refers to tables in the PatientInfo Spreadsheet, and changing this index vector changes which patients will be optimized. The optimization itself is handled in the POTS_Driver subfunction, which loops over the indices in the Patient Info table, optimizes the corresponding patient’s valsalva data drawn from the MatFiles folder, and saves the results in the Optimized folder. POTS_Driver runs this optimization eight times at random nominal parameter values. On the first random start, it also tries to reduce rest time before the valsalva to the optimal length, using the best length for subsequent random starts. POTS_Driver calls subsidiary functions Func_DriverBasic_LM, which runs Levenburg-Marquardt optimization, load_data, which extracts the necessary data for optimization from the patient .mat files, and TimeCut, which cuts off excess resting data before and after the Valsalva. Other functions are necessary sub functions to execute optimization, including Fortran code. In our experience, POTS_Driver takes about 5-10 minutes to optimize each patient on Henry2, and 1-2 minutes on our machines.

