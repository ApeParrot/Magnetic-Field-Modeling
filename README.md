# Magnetic-Field-Modeling

Collections of MATLAB scripts and functions for the design of systems comprising cylindrically magnetized objects.

Capability of the functions present in the repository: 
1) Computation of **Magnetic Field** and **Magnetic Field Gradient** for *cylindrical* and *ring* permanent magnets with *arbitrary* and *uniform* magnetization (e.g., Axially and Diametrically magnetized cylinders as special cases), or equivalently of axial solenoids. These functions can be used for the computation of the Torques and Forces (Field and Field Gradient, respectively) applied by a permanent magnet cylinder to a magnetic dipole.
2) Computation of **Forces** and **Torques** between *coaxial* permanent magnets cylinders with **axial** or **diametric** magnetization.
3) Visualization functions for the magnetic field and field gradient.

## Magnetic Field and Gradient of cylindrical magnets

The expressions implemented provide excellent approximations to the real fields when modern, high-grade magnetic materials, like SmCo, NdFeB or ferrites with susceptibilities $\chi < 0.1$ are involved. The main advantage over common numerical methods such as finite element (FE) approaches or direct numerical integration is the fast computation times of the order of microseconds, which enables highly efficient multivariate parameter space analysis and solving global optimization problems for permanent magnet arrangements.

The present code computes of the magnetic field $\mathbf{H}$, as well as its gradient $\nabla\mathbf{H}$, at a generic point $\mathbf{P}$ either outside or within the magnet. These quantities are computed **analytically** solving the governing equations for magnetostatics (in the absence of free currents), namely
$$\nabla \times \mathbf{H} = 0\mbox{ }, \quad \nabla \cdot  \mathbf{B} = 0\mbox{ },$$
with $\mathbf{B}$ representing magnetic induction, which is related to $\mathbf{H}$ and to the (local medium) magnetization $\mathbf{M}$ by $\mathbf{B} = \mu_0(\mathbf{H} + \mathbf{M} )$, where $\mu_0 = 4\pi \cdot 10^{-7} \mbox{ T m A}^{-1}$ denotes vacuum magnetic permeability. Once introduced the 
magnetostatic scalar potential $\varphi$, such that, $\mathbf{H} = -\nabla \varphi$, whence $\Delta\varphi = -\nabla\cdot\mathbf{H}$,
the remaining governing equation reads:
$$\nabla^2\varphi = \nabla \cdot \mathbf{M}\mbox{ }.$$
Its solution, based on the assumed uniform magnetization $\mathbf{M}\_{\star}$, formally reads:
$$\varphi(\mathbf{P}) = \frac{1}{4\pi}\int\_{\mathrm{S}}  \frac{\mathbf{M}\_{\star} \cdot \hat{\mathbf{n}}}{||\mathbf{P}-\mathbf{P}'||}\mbox{ } \mathrm{d} \mathrm{S}^\prime,$$
where $\mathrm{S}=\mathrm{S\_t}\cup\mathrm{S\_b}\cup\mathrm{S\_l}$ denotes the surface of the cylindrical magnet (union of top, bottom and lateral surfaces, respectively) and $\hat{\mathbf{n}}$ denotes the (outer) normal at the running point $\mathbf{P}'$ on the cylinder surface.

Last equation and derivatives (up to second order) were solved to obtain all the components of $\mathbf{H}$ and $\nabla\mathbf{H}$ in cylindrical coordinates, recasting them in terms of the Bulirsch integral $\mbox{cel}$ and the Normalized Heuman Lambda function $\Lambda$,
$$ \mbox{cel}{k\_c}{p}{a}{b} = \int\_0^{\pi/2} \frac{a \cos(\psi)^2 + b \sin(\psi)^2}{(\cos(\psi)^2+p \sin(\psi)^2) \,
\sqrt{\cos(\psi)^2+k\_c^2 \sin(\psi)^2}}\mbox{ } \mathrm{d}\psi$$
$$ \Lambda(\sigma^2,k) = \sqrt{\tilde{p}\, \sigma^2} \mbox{cel}{k\_c}{\tilde{p}}{1}{k\_c^2}$$

Additional information on the models will be provided soon ...

[![View Magnetic Field Modeling on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://www.mathworks.com/matlabcentral/fileexchange/73906-magnetic-field-modeling)
