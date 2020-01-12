function B_model = ParallelGenerateReadings(D,L,M,MagPos,SensorPosMatrix)

BP = ParallelBfield(D,L,M,MagPos,SensorPosMatrix);

M = reshape(BP,3,size(SensorPosMatrix,2),size(MagPos,2));
B_model = sum(M,3);