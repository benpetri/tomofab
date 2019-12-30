TOMOFAB is a free, open-source Matlab package providing a graphical interface to visualize and analyze a distribution of ellipsoids (that can represent simplified grains, grain aggregates or pores) to derive fabric information as e.g. acquired by X-ray computed micro-tomography and treated using Blob3D (Ketcham, 2005) or equivalent.


TOMOFAB was developed in MATLAB language and is compatible with MATLAB R2015a and subsequent versions.


To launch TOMOFAB:
- Start Matlab program
- Set the Current Directory to tomofab path of the tomofab folder
- In the command Window, type tomofab and press Enter
OR - Open the tomofab.m file in the MATLAB EDITOR and press F5.


Load dataset by clicking on "Import dataset".
Set appropriate ellipsoid volume range and click on "Refresh volume filtering".
Stereonet display options and statistical treatment can be set to the left-hand side of the GUI. Click on "Refresh plots" to perform all calculations and refresh diagrams and parameters display.
Selected dataset can be exported by clicking on "Export dataset".
Calculations results can be printed in a text file by clicking on "Export statistics", Orientation and fabric plots are saved by clicking on "Export stereoplot" and "Export fabric plots", respectively.


Preparing files:
- dataset: Tabulation separated values file. File name should start with TT_XXXX- followed by keywords. See template provided with the TOMOFAB package.
- sample orientations: Tabulation separated values file containing sample name, dip direction, dip angle, tomography analysis name (TT_XXXX), Reverse position or not, Misorientation angle (see help file for details). The file name should be SampleOrientations.xls. See template provided with the TOMOFAB package.


Please report any error, bug or suggestion to bpetri@unistra.fr


Reference cited:
Ketcham, R.A., 2005. Computational methods for quantitative analysis of three-dimensional features in geological specimens. Geosphere 1, 32–41.
