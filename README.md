# Spatial Frequency Decoding in the Inferior Temporal Cortex

This repository replicates the results of **spatial frequency decoding** in the inferior temporal (IT) cortex for fast and slow presentations, as described in the paper:  
**"The Spatial Frequency Representation Predicts Category Coding in the Inferior Temporal Cortex"**  
[Paper on eLife](https://elifesciences.org/reviewed-preprints/93589)

## Overview

The study investigates the spatial frequency representation in the IT cortex and its predictive power for category coding. 
This repository includes MATLAB code for replicating the main findings, focusing on spatial frequency decoding for fast and slow visual presentations.


## Repository Contents

### Main Script

- **`main.m`**  
  The primary script for executing the decoding analysis and generating results.  

### Sample Data
- **Data Labels**  
  - `label_matrix_fast`: Labels for trials with fast presentations.  
  - `label_matrix_slow`: Labels for trials with slow presentations.

- **Neuronal Responses**  
  - `neuron_response_fast`: Neuron response samples recorded during fast presentations.  
  - `neuron_response_slow`: Neuron response samples recorded during slow presentations.

- **Time Points**  
  - `x`: Real-time points corresponding to the time dimension.

## Data Availability

### Sample Data
The data included in this repository is **sample data** intended to demonstrate the functionality of the code. It does not contain the full dataset used in the study.

### Full Data
The full dataset used in the study is available upon reasonable request to the corresponding author. Please refer to the contact information provided in the [original paper](https://elifesciences.org/reviewed-preprints/93589).


## Prerequisites

### Software Requirements
- MATLAB (R2021b or later recommended)
- MATLAB Toolboxes: 
  - Statistics and Machine Learning Toolbox (for classification models and PCA).


## Usage

1. **Prepare Input Data**  
   Ensure that the input data (`data.mat`) is correctly loacated in the same forlder as `main.m`.

2. **Run the Main Script**  
   Open and execute `main.m` to replicate the spatial frequency decoding results.

3. **Adjust Parameters**  
   Modify variables in the script as needed for experimentation.


## Key Variables and Outputs

### Inputs
- **`neuron_response_fast`**: Neuronal responses during fast presentations.
- **`neuron_response_slow`**: Neuronal responses during slow presentations.
- **`label_matrix_fast` and `label_matrix_slow`**: Labels corresponding to each trial type.

### Outputs
- **Decoding Recall**: Classification recall for each frequency.
- **Onset Times**: Onset times of the recall calculated for each frequency.

## Citation

If you use this code or adapt it for your work, please cite the original paper:  
```bib
 @article{Toosi_2024,
    title={The Spatial Frequency Representation Predicts Category Coding in the Inferior Temporal Cortex},
    url={http://dx.doi.org/10.7554/eLife.93589.2}, DOI={10.7554/elife.93589.2},
    publisher={eLife Sciences Publications, Ltd},
    author={Toosi, Ramin and Karami, Behnam and Koushki, Roxana and Shakerian, Farideh and Noroozi, Jalaledin and Rezayat, Ehsan and Vahabie, Abdol-Hossein and Akhaee, Mohammad Ali and Dehaqani, Mohammad-Reza A.},
    year={2024},
    month=jun }
```

## Contact

For questions or contributions, please reach out to the authors of the original paper or create an issue in this repository. For access to the full dataset, please contact the corresponding author as stated in the paper.

