function Bfield = ParallelBfield(D,L,M,MagPos,Points)

Ns = size(Points,2);
MM = size(MagPos,2);
radialV = zeros(3,Ns*MM);

Points = repmat(Points,1,MM);
MagPos = reshape(reshape(repmat(MagPos',1,Ns)',1,Ns*MM*6)',6,Ns*MM);

[Brho,BZ] = ParallelDerby(D,L,M,MagPos,Points,Ns,MM);

x = Points-MagPos(1:3,:);                       % distance vector

% x and mag moment not aligned
indexes = (vecnorm(cross(MagPos(4:6,:),x,1),2,1) ~= 0);
% axial and radial versor in the Local Frame
axialV  = repmat(dot(x,MagPos(4:6,:)),3,1).*MagPos(4:6,:);  
radialV(:,indexes) = ...
    (x-axialV(:,indexes))./repmat(vecnorm(x-axialV(:,indexes),2,1),3,1);

% Radial and axial component of the field w.r.t. local reference frame
B_radial = radialV.*repmat(Brho,3,1);
B_axial  = MagPos(4:6,:).*repmat(BZ,3,1);

Bfield = B_radial+B_axial;

% % Projection back to Cartesian
% Bx = Bsum(1,:);
% By = Bsum(2,:);
% Bz = Bsum(3,:);
