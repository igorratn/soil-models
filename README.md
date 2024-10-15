# soil-models

This is a software implementation of a model for assessing the degree of influence of a vehicle on waterlogged forest soil, taking into account the design parameters of the tire and the vertical loads on it. The model is developed based on the theory of soil mechanics. The plane problem of compaction of water-saturated anisotropic (in the general case) soil is considered. The problem is described by a system of partial differential equations. The solution is found using the finite element method with respect to displacements. Then, the steady-state and initial values of the stresses are determined, as well as the values of the maximum deviation of the total stress vector. In the case of an isotropic medium, analytical expressions are obtained for the initial values of heads and stresses. With their help, one can select the optimal triangulation of the region for a given loading diagram and check the finite element solution.

### Main Software Modules:

- **MKESol**: Control module.
- **UnCode**: Contains subroutines for identifying the area of the partition.
- **SplinUnt**: Contains subroutines for constructing an interpolation cubic spline and for outputting spline values at specified points.
- **GetSpline**: Procedure for forming the global load vector (the right side of the linear algebraic system of equations).
- **GetData**: Procedure for generating a global stiffness matrix.
- **LDL**: Contains routines for decomposition and solutions for strip matrices by the Cholesky method.
- **MKEDrow**: Control module for presenting calculation results.
- **Sigma**: Contains programs for calculating mesh functions from a subspace. The initial data is the values of the mesh displacement functions contained in the Output.mke file.
- **FuncLoad**: Contains numerical integration routines for finding a solution to the first boundary value problem in the case of an isotropic medium.
- **Anal**: Contains subroutines for graphical representation of a grid function in the form of function level lines of two variables. This representation is performed by the LineLab (Nf, k) procedure, where Nf is a parameter defining the identifier code of the grid function, and k is the number of level lines on the display screen.

After the MKESol program has been processed, the values of the grid functions from the space that define the vertical and horizontal displacements are known. These values are recorded in the Output.mke file.

### How to Run:

#### Using Docker:
1. Build the Docker image:
   ```sh
   docker build -t soil-models .
   ```
2. Run the Docker container:
   ```sh
   docker run -p 9090:80 soil-models
   ```
3. Access the application at:
   ```
   http://localhost:9090/
   ```
   See 'Run the Examples' below.

#### Using DOSBox:
1. Install DOSBox and Turbo Pascal (https://gist.github.com/nvgrw/da00b5d3ac96b9c45c80).
2. Update the DOSBox configuration file (e.g., for macOS):
   ```sh
   open -e ~/Library/Preferences/DOSBox\ 0.74-3-3\ Preferences
   ```
3. Add the following lines to the configuration file:
   ```
   cycles=max
   mount A ~/TP/BIN
   mount C ~
   C:
   cd soil-m~1/src
   ```

4. To compile the code, once inside DOSBox, type:
   ```
   TURBOC.BAT LAPLAS.PAS
   TURBOC.BAT MKESOL.PAS
   TURBOC.BAT MKEDROW.PAS
   ```

### Run the Examples:
1. Run LAPLAS.EXE with a sample file:
   ```
   LAPLAS.EXE tires/71x47-25.WIN
   ```
   Press any key to continue, or "ESC" to cancel. The calculation results are presented as level lines of a function of two variables.

2. Run MODEL.BAT and MKEDROW.BAT:
   ```
   MODEL.BAT tires/71x47-25.WIN
   MKEDROW.BAT tires/71x47-25.WIN
   ```

The files in the `tires` directory are expected to be in Windows format. You can use the Sublime Text editor to convert from Unix/macOS to Windows format: open a file, go to `View -> Line Endings -> Windows`, then save the file.
