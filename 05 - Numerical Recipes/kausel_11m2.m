function I11m2 = kausel_11m2(a,b,c,mode)

switch mode
        
    case 'HP' % from table 4 Kausel
        
        A = sqrt((a+b).^2+c.^2);
        B = sqrt((a-b).^2+c.^2);
        L1 = 1/2*(A-B);
        L2 = 1/2*(A+B);
        k  = L1./L2;
        nab = k.*a./b;
        nba = k.*b./a;

        K   = EllipticK(k);
        E   = EllipticE(k);
        Pab = EllipticPi(nab(a<=b),k(a<=b));
        Pba = EllipticPi(nba(a>b),k(a>b));
        
        I11m2 = 1./(3*pi*L1).*( (2*a.^2+2*b.^2-c.^2).*( E - K ) + 4*a.^2.*b.^2./L2.^2.*K );
        I11m2(a<=b) = I11m2(a<=b) + 1./(3*pi*L1(a<=b)).*( 3*b(a<=b).^2.*c(a<=b).^2./L2(a<=b).^2.*(K(a<=b)-Pab) + 3*a(a<=b).^2.*c(a<=b).^2./L2(a<=b).^2.*( Pab - pi*L2(a<=b)./(2*c(a<=b)) ) );
        I11m2(a>b)  = I11m2(a>b)  + 1./(3*pi*L1(a>b) ).*(  3*a(a>b).^2.*c( a>b).^2./L2( a>b).^2.*(K( a>b)-Pba) + 3*b( a>b).^2.*c( a>b).^2./L2( a>b).^2.*( Pba - pi*L2( a>b)./(2*c( a>b)) ) );
    
    case 'HP_formula' % using 1/3*(I_01^-1 + b*I_10^-1 - c*I_11^-1) with expressions from Table 4
    
        I01m1 = kausel_10m1(b,a,c,'HP');
        I10m1 = kausel_10m1(a,b,c,'HP');
        I11m1 = kausel_11m1(a,b,c,'HP');
        I11m2 = 1/3*(I01m1 + b.*I10m1 - c.*I11m1);
            
    otherwise % using 1/3*(I_01^-1 + b*I_10^-1 - c*I_11^-1) with expressions from Table 3
        
        I01m1 = kausel_10m1(b,a,c,'ENS');
        I10m1 = kausel_10m1(a,b,c,'ENS');
        I11m1 = kausel_11m1(a,b,c,'ENS');
        I11m2 = 1/3*(I01m1 + b.*I10m1 - c.*I11m1);
    
end