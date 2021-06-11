# soil-models
This is a software implementation of the model for assessing the degree of influence of а vehicle on waterlogged forest soil, taking into account the design parameters of the tire and the vertical loads on it.
The model is developed based on the theory of soil mechanics. The plane problem of compaction of water-saturated anisotropic (in the general case) soil is considered. 
The problem is described by a system of partial differential equations. The solution is found by the finite element method with respect to displacements. Then, the steady-state and initial values of the stresses are determined, as well as the values of the maximum deviation of the total stress vector.
In the case of an isotropic medium, analytical expressions are obtained for the initial values of heads and stresses. With their help, one can select the optimal triangulation of the region for a given loading diagram and check the finite element solution.

Main software modules:<br>
MKESol - control module;<br>
UnCode - contains subroutines for identifying the area of the partition;<br>
SplinUnt - contains subroutines for constructing an interpolation cubic spline and for outputting spline values at specified points;<br>
GetSpline - the procedure for forming the global load vector (the right side of the linear algebraic system of equations);<br>
GetData - procedure for generating a global stiffness matrix;<br>
LDL - contains routines for decomposition and solutions for strip matrices by the Cholesky method.<br>
After the MKESol program has been processed, the values of the grid functions from the space that define the vertical and horizontal displacements are known. 
These values are recorded in the Output.mke file;<br>
MKEDrow - control module for presenting calculation results;<br>
Sigma - contains programs for calculating mesh functions from a subspace.<br> 
The initial data is the values of the mesh displacement functions contained in the Output.mke file;<br>
FuncLoad - contains numerical integration routines for finding a solution to the first boundary value problem in the case of an isotropic medium;<br>
Anal - contains subroutines for graphical representation of a grid function in the form of function level lines of two variables.<br> 
This representation is performed by the LineLab (Nf, k) procedure.<br> 
Here Nf is a parameter defining the identifier code of the grid function; k is the number of level lines on the display screen.<br>

software required: DosBox, Turbo Pascal: https://gist.github.com/nvgrw/da00b5d3ac96b9c45c80 <br>
after the installation, you can update the DOSBox configuration file (eg. for MacOS
open -e ~/Library/Preferences/DOSBox\ 0.74-3-3\ Preferences) with the following:
<br>
cycles=max <br>
mount A ~/TP/BIN<br>
mount C ~<br>
C:<br>
cd soil-m~1\src<br>

to compile the code, once inside DosBox, type in: <br>
TURBOC.BAT LAPLAS.PAS<br>
TURBOC.BAT MKESOL.PAS<br>
TURBOC.BAT MKEDROW.PAS<br>
run the examples: <br>
LAPLAS.EXE tires/71x47-25.WIN<br> 
press any key to continue, or "ESC" to cancel.<br>
MODEL.BAT tires/71x47-25.WIN<br>
MKEDROW.BAT tires/71x47-25.WIN<br>
The files in the tires dir are expected to be in Windows format,
use can use Sublime text editor to convert from Unix/MacOS to Windows: 
open a file, View -> Line Endings -> Windows; save the file.
