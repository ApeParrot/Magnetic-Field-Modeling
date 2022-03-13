function T = computeTorqueDiametricRings(R1in,R1out,R2in,R2out,L1,L2,M1,M2,d) 

T1 = computeTorqueDiametric(R1out,R2out,L1,L2,M1,M2,d);
T2 = computeTorqueDiametric(R1in,R2out,L1,L2,M1,M2,d);
T3 = computeTorqueDiametric(R1out,R2in,L1,L2,M1,M2,d);
T4 = computeTorqueDiametric(R1in,R2in,L1,L2,M1,M2,d);

T = T1 - T2 - T3 + T4;