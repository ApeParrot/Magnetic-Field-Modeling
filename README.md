# Magnetic-Field-Modeling

Collections of MATLAB scripts and functions for the design of systems comprising cylindrically magnetized objects.

Capability of the functions present in the repository: 
1) Computation of **Magnetic Field** and **Magnetic Field Gradient** for *cylindrical* and *ring* permanent magnets with *arbitrary* and *uniform* magnetization (e.g., Axially and Diametrically magnetized cylinders as special cases), or equivalently of axial solenoids. These functions can be used for the computation of the Torques and Forces (Field and Field Gradient, respectively) applied by a permanent magnet cylinder to a magnetic dipole.
2) Computation of **Forces** and **Torques** between *coaxial* permanent magnets cylinders with **axial** or **diametric** magnetization.
3) Visualization functions for the magnetic field and field gradient.

## Magnetic Field and Gradient of cylindrical magnets

The present code computes of the magnetic field $\mathbf{H}$, as well as its gradient $\nabla\mathbf{H}$, at a generic point $\mathbf{P}$ either outside or within the magnet. These quantities are computed **analytically** solving the governing equations for magnetostatics (in the absence of free currents), namely
$$\nabla \times \mathbf{H} = 0$$
$$\nabla \cdot  \mathbf{B} = 0$$,
with $\mathbf{B}$ representing magnetic induction, which is related to $\mathbf{H}$ and to the (local medium) magnetization $\mathbf{M}$ by $\mathbf{B} = \mu_0(\mathbf{H} + \mathbf{M} )$, where $\mu_0 = 4\pi \cdot 10^{-7} \mbox{T m A}^{-1}$ denotes vacuum magnetic permeability. Once introduced the 
magnetostatic scalar potential $\varphi$, such that, $\mathbf{H} = -\nabla \varphi$, whence $\Delta\varphi = -\nabla\cdot\mathbf{H}$,
the remaining governing equation reads:
$$\nabla^2\varphi = \nabla \cdot \mathbf{M}.$$

Additional information on the models will be provided soon ...

[![View Magnetic Field Modeling on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://www.mathworks.com/matlabcentral/fileexchange/73906-magnetic-field-modeling)
