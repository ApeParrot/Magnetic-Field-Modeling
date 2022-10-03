# Magnetic-Field-Modeling

Collections of MATLAB scripts and functions for the design of systems comprising cylindrically magnetized objects.

Capability of the functions present in the repository: 
1) Computation of **Magnetic Field** and **Magnetic Field Gradient** for *cylindrical* and *ring* permanent magnets with *arbitrary* and *uniform* magnetization (e.g., Axially and Diametrically magnetized cylinders as special cases), or equivalently of axial solenoids. These functions can be used for the computation of the Torques and Forces (Field and Field Gradient, respectively) applied by a permanent magnet cylinder to a magnetic dipole.
2) Computation of **Forces** and **Torques** between *coaxial* permanent magnets cylinders with **axial** or **diametric** magnetization.
3) Visualization functions for the magnetic field and field gradient.

**Notes**: The expressions implemented in this library are based on the fundamental assumption of uniform magnetization, that is an excellent approximations for magnets made up of modern, high-grade magnetic materials, like SmCo, NdFeB or ferrites with susceptibilities $\chi < 0.1$. The main advantage over common numerical methods such as finite element (FE) approaches or direct numerical integration is the fast computation times of the order of microseconds, which enables highly efficient multivariate parameter space analysis and solving global optimization problems for permanent magnet arrangements.

## Magnetic Field and Gradient of cylindrical magnets

The present code computes of the magnetic field $\mathbf{H}$, as well as its gradient $\nabla\mathbf{H}$, at a generic point $\mathbf{P}$ either **outside or within the magnet**. These quantities are computed **analytically** solving the governing equations for magnetostatics in the absence of free currents, namely
$$\nabla \times \mathbf{H} = 0\mbox{ }, \quad \nabla \cdot  \mathbf{B} = 0\mbox{ },$$
with $\mathbf{B}$ representing magnetic induction, which is related to $\mathbf{H}$ and to the (local medium) magnetization $\mathbf{M}$ by $\mathbf{B} = \mu_0(\mathbf{H} + \mathbf{M} )$, where $\mu_0 = 4\pi \cdot 10^{-7} \mbox{ T m A}^{-1}$ denotes vacuum magnetic permeability. Once introduced the 
magnetostatic scalar potential $\varphi$, such that, $\mathbf{H} = -\nabla \varphi$, whence $\Delta\varphi = -\nabla\cdot\mathbf{H}$,
the remaining governing equation reads:
$$\nabla^2\varphi = \nabla \cdot \mathbf{M}\mbox{ }.$$
Its solution, based on the assumed uniform magnetization $\mathbf{M}\_{\star}$, formally reads:
$$\varphi(\mathbf{P}) = \frac{1}{4\pi}\int\_{\mathrm{S}}  \frac{\mathbf{M}\_{\star} \cdot \hat{\mathbf{n}}}{\lVert\mathbf{P}-\mathbf{P}'\rVert}\mbox{ } \mathrm{d} \mathrm{S}^\prime,$$
where $\mathrm{S}=\mathrm{S\_t}\cup\mathrm{S\_b}\cup\mathrm{S\_l}$ denotes the surface of the cylindrical magnet (union of top, bottom and lateral surfaces, respectively) and $\hat{\mathbf{n}}$ denotes the (outer) normal at the running point $\mathbf{P}'$ on the cylinder surface.

Last equation and its derivatives (up to second order) were solved to obtain all the components of $\mathbf{H}$ and $\nabla\mathbf{H}$ in cylindrical coordinates, recasting them in terms of the Bulirsch integral $\mbox{cel}$ and the Normalized Heuman Lambda function $\Lambda$,
$$\mbox{cel}(k\_c,p,a,b) = \int\_0^{\pi/2} \frac{a \cos^2(\psi) + b \sin^2(\psi)}{\left(\cos^2(\psi) + p \sin^2(\psi)\right) \mbox{ } \sqrt{\cos^2(\psi)+k\_c^2 \sin^2(\psi)}}\mbox{ } \mathrm{d}\psi$$
$$\Lambda(\sigma^2,k) = \sqrt{\tilde{p}\sigma^2} \mbox{ } \mbox{cel}(k\_c,\tilde{p},1,k\_c^2)\mbox{ }, \quad \tilde{p} = \frac{1 - \sigma^2 k\_c^2}{1 - \sigma^2}\mbox{ }.$$
The use of these two functions allow to achieve a fast computation without encurring into representation singularities.
These expressions could be used also in the computation of the magnetic force $\mathbf{F}$ and torque $\mathbf{T}$ exerted by a cylindrical magnet on a dipole, with magnetic moment $\mathbf{m}$, according to the expressions:
$$\mathbf{F}=\mu\_0\left(\nabla\mathbf{H}\cdot\mathbf{m}\right)\mbox{ }, \quad \mathbf{T}=\mu\_0\left(\mathbf{m}\times \mathbf{H}\right)$$.

## Magnetic Force and Torque between coaxial cylindrical magnets

The code provides also analytical models for force and torque between two coaxial cylinders, namely C1 (radius $\mathrm{R}\_1$, height $2\mathrm{L}\_1$, magnetization $\mathbf{M}\_1$) and C2 (radius $\mathrm{R}\_2$, height $2\mathrm{L}\_2$, magnetization $\mathbf{M}\_2$), at a relative distance (between magnets centers) $\mathrm{d} \ge \mathrm{L}\_1 + \mathrm{L}\_2$.
Force and torque exerted by C1 on C2 can be respectively computed as follows: 
$$\mathbf{F}\_{1\to 2}=\mu_0\int\_{V\_2} \nabla\mathbf{H}\_1 \cdot \mathbf{M}\_2\mbox{ } \mathrm{d}V\mbox{ },$$
$$\mathbf{T}\_{1\to 2}=\mu_0\int\_{V\_2} \Big( (\mathbf{P} - \mathbf{O}\_1) \times (\nabla\mathbf{H}\_1 \cdot \mathbf{M}\_2)+ \mathbf{M}\_2\times\mathbf{H}\_1 \Big)\mbox{ }\mathrm{d}V\mbox{ } ,$$ 
where (subscripts are understood and) $V_2$ denotes the volume occupied by C2.
By assuming axial magnetizations
$\mathbf{M}\_1 = \mathbf{M}\_{\parallel1}$ and 
$\mathbf{M}\_2 = \mathbf{M}\_{\parallel2}$, we
first computed the corresponding force $\mathbf{F}^\parallel\_{1\to2}$
(torque being null, by symmetry).
Then, by assuming diametric magnetizations
$\mathbf{M}\_1 = \mathbf{M}\_{\bot1}$ and 
$\mathbf{M}\_2 = \mathbf{M}\_{\bot2}$ at a generic relative angular shift, we computed the related force
$\mathbf{F}^\bot\_{1\to2}$ and torque $\mathbf{T}^\bot\_{1\to2}$.

Additional information on the models will be provided soon ...

[![View Magnetic Field Modeling on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://www.mathworks.com/matlabcentral/fileexchange/73906-magnetic-field-modeling)
