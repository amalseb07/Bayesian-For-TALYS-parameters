# Talys -optimisation-procedure-using-bayesian-inference-technique


## Description
Bayesian framework using Metropolis–Hastings MCMC to quantify statistical  uncertainties in Oslo-method nuclear level densities and γ-ray strength functions, with uncertainty propagation to the  neutron-capture cross section and astrophysical reaction rate.


## Setup Instructions
1. Clone the repository:
   ```bash
      git clone https://github.com/amalseb07/Bayesian-For-TALYS-parameters.git
  

2. Create and Activate a python environment
   - micrmomaba create -n Bayes_OSlo
   - micromamba activate Bayes_OSlo
     
3. Install dependencies
   - pip install -r requirements.txt   


## Step 0: Data and model preperation.
For this work, we need both data from the experement and also the default models from TALYS ( Here I have used TALYS 2.0 but one can easily adopt this to other TALYS versions). First part is to setup the base models for GSF and NLD . Please refer the diectory talys_models and the readme file in it to set up the master_base_gsf.pkl , master_base_ld_n.pkl and master_base_ld_p.pkl.

### Experimental data
You need 2 pieces of experimental data : 
1. The  experimental GSF of the isotope ( here 97Zr).
2. The experimental NLD of the isotope ( here 97Zr).

These are found in input_data folder as gsf_300(6,9).csv,ld_300(6,9).csv for gsf and NLD respectively. You can replace it with your data in the same format. 



## Step 1: Constraining the γSF within the Bayesian framework

- In this step we get the set of all  tuned model parameters  that represent the GSF of 97Zr.

1. Take the jupyter notebook bayesian to gsf--3-paramters-.ipynb and add both your experimental GSF data ( here gsf_300(6,9).csv) in the respective cells
2. Also add the master_base_gsf.pkl file in the cell respective cell (Pulling the base data of gsf and interpolation to the experimental energy).
3. Add the necessary changes to the variables as you go.
4. In the prior definition ( cell -Likelihood and prior definition starts here)  , add the conditions on prior as necessary. How the priors must be chosen are explained in the paper (A.Sebastian et al 2026)
5. In the cell titled " Running the Full MCMC Setup" , you can spectify the initial starting point of the walker, prior mean , prior standard deviation, and also stepsize of each paramter.
6. The ideal acceptance percentage is around 30-50 but it can vary from problem to problem.
7. It is important that in the cell titled "Drawing different chains in MCMC" , you see a convergence of the each individual parameter. This is the proof that the MCMC has finally settled on a set of values . If the trend is such that it is increasing or decreasing , it means that it needs to be tuned again ( like stepsize , prior means, prior widths need to be reconsidered)
8. If everything goes well , run down the cells where you can see the corner plots and also the bands produced as result of uncertainty quantification

(Note : There is a cell in between that samples from the posterior distribution and saves in file2.txt. This is used later for cross-section calculation.)
   
## Step 2: Constraining the NLD within the Bayesian framework

1. Take the jupyter notebook bayesian on ld-2-parameters.ipynb and add  your experimental NLD data ( here ld_300(6,9).csv).
2. Also add the master_base_ld_p.pkl  and master_base_ld_n.pkl file.
3. In the cell titled " Running the Full MCMC Setup" , you can spectify the initial starting point of the walker, prior mean , prior standard deviation, and also stepsize of each paramter.
4. The ideal acceptance percentage is around 30-50 but it can vary from problem to problem.
5. It is important that in the cell titled "Drawing different chains in MCMC" , you see a convergence of the each individual parameter. This is the proof that the MCMC has finally settled on a set of values . If the trend is such that it is increasing or decreasing , it means that it needs to be tuned again ( like stepsize , prior means, prior widths need to be reconsidered)
8. If everything goes well , run down the cells where you can see the corner plots and also the bands produced as result of uncertainty quantification
4. The result is a posterior ensemble of ctable, ptable values stored as file1.txt.

   
## Step 3: Cross-Section

1. The file1.txt( contains NLD parameters) and file2.txt( contains GSF parameters) ae used to find cross-section. 
2. These are used as input for the TALYS reaction
4.  There is a .sh file in cross_section/repeat_cross_section.sh that takes in file1.txt and file2.txt and gives cross-section.txt. You can use cross-section.ipynb in same folder to draw the band of cross-sections.

### TADA DONE
