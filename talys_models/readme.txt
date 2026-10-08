This is the starting point before we hit Bayesian . Here we create base models so that Bayesian can use it in later steps

# Step 1
->First we start with GSF. Three parameters we interested in this notebook are the ubpende , upbendc , ftable of GSF in TALYS models. So we set all of them to 0, run TALYS (input_gsf.txt) and the resulting GSF which we get in the output.dat files is saved as base_strength.txt.

-> Once we have this we can check whether changing parameters using master_base_gsf.pkl is same as changing parameters in TALYS using the notebook check_gsf.ipynb

# Step 2
-> We move onto nld. Since we use ldmodel 5 and we will use interpolations in the actual Bayesian. We need to get many ptable values and concatenate . So in TALYS run the script repeat_all.sh with input.txt. This creates a set of output files labeled
output_{ptable_value}_parity.txt in the folder ld_txt_files. ( An example txt file is shown as output_0.2_n.txt).

-> Then we need to concatenate all these textfiles to create a master database called master_base_ld_n.pkl and master_base_ld_p.pkl. (These file are used in the actual Bayesian Step). This is achieved using the notebook titled 

-> Just like for GSF , we can check changing parameter using masterdatabase is same as same as changing paramterer in talys using the notebook check_ld.ipynb.

